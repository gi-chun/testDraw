//
//  SHBPushInfo.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBPushInfo.h"
#import "SHBUtilFile.h"
#import "SHBCheckingViewController.h"
#import "Encryption.h"
#import "INISAFEXSafe.h"
#import "SHBNoCertForCertLogInViewController.h"
#import "SHBCertDetailViewController.h"
#import "SHBCertManageViewController.h"
#import "Encryption.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "SHBVersionService.h"
#import "SHBOldSecurityViewController.h"
#import "SHBOldSecurityChangeViewController.h"
#import "SHBUserPWRegInputViewController.h"
#import "SHBQryServiceViewController.h"

//2014.3.5 이용자비밀번호 등록
#import "SHBUserPWRegViewController.h"


#import "SHBCheckingViewController.h"
#import "SHBCardSSOAgreeContentsViewController.h"
#import "SHBSignupViewController.h"
#import "SHBIdentity4ViewController.h"

#define PGM_REGISTER_PUSH		@"9519"
#define KEY_PUSH_NOTIFICATION	@"PushNotification"
#define KEY_DEVICE_TOKEN		@"deviceToken"
#define KEY_SCHEME_URL			@"SchemeURL"
#define KEY_FIRST_REGISTER		@"firstRegister"


@implementation SHBPushInfo
{
    NSString *ssoCertserialNum;
    NSString *ssoCertIssuer;
    NSString *ssoCertDN;
    NSString *ssoCertSubjectDN;
    BOOL isAutoLogin;
    BOOL isgrSSO;
}


@synthesize deviceToken=_deviceToken;
@synthesize stockCode=_stockCode;

@synthesize viewSignal=_viewSignal;
@synthesize viewTitle=_viewTitle;
@synthesize viewInterest=_viewInterest;

@synthesize launchMenuCode=_launchMenuCode;
@synthesize launchDataCode=_launchDataCode;

@synthesize wantMorningBrief=_wantMorningBrief;
@synthesize wantSchemeUrl=_wantSchemeUrl;
@synthesize isFirstRegister=_isFirstRegister;

@synthesize requestParm = _requestParm;

@synthesize ssoSid;

static SHBPushInfo* theInfoPush = nil;	// sigleton

#pragma mark - Init & Dealloc
+ (void)initialize
{
    //NSLog(@"push step 1");
	[super initialize];
	
	if (theInfoPush == nil)
	{
		theInfoPush = [[SHBPushInfo alloc] init];
	}
}

+ (void)finalize
{
    //NSLog(@"push step 2");
	if (theInfoPush)
	{
		[theInfoPush release];
		theInfoPush = nil;
	}
	
	[super finalize];
}

- (id) init
{
    //NSLog(@"push step 3");
	self = [super init];
	if (self)
	{
		// 화면 연동 배열 초기화
		[self classListInitialize];
		
		_deviceToken = [[NSString alloc] init];
		_dataDic    = [[NSMutableDictionary alloc] init];
		
		_launchMenuCode = [[NSString alloc] init];
		_launchDataCode = [[NSString alloc] init];
		
		_scrNo		 = 0;
		_isActive	 = NO;
		
		_viewSignal = nil;
		_viewNews = nil;
		_viewTitle = nil;
		_viewInterest = nil;
		
		_wantSchemeUrl = YES;
		_wantPushNotification = YES;
		_isFirstRegister = YES;
		
		_requestParm = [[NSString alloc] init];
        isgrSSO = NO;
	}
	return self;
	
}

- (void) dealloc
{
	[_deviceToken release];
	[_dataDic release];
	
	[_launchDataCode release];
	[_launchMenuCode release];
	
	[_classArray release];
	
	[_requestParm release];
	
	SafeRelease(_appArray);
	
	[super dealloc];
}

+ (SHBPushInfo*) instance
{
    //NSLog(@"push step 4");
	return theInfoPush;
}

#pragma mark - Request TR
- (void)ssoAutoLogin{
    //NSLog(@"push step 5");
    // 자동 로그인
    isAutoLogin = YES;
    AppInfo.serviceCode = @"autoLogin";
    /*
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								@{
								@"deviceId" : [AppDelegate getSSODeviceID],
								@"appStatus" : @"AUTO",
								@"syncResult" : @"1",
								}] autorelease];
    SendData(SHBTRTypeServiceCode, @"request", SSO_URL, self, forwardData);
	*/
    //ios7 대응으로 2013.10.07 변경
    NSLog(@"ssoSid:%@",self.ssoSid);
    NSString *carrierName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
		// Setup the Network Info and create a CTCarrier object
		CTTelephonyNetworkInfo *networkInfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
		CTCarrier *carrier = [networkInfo subscriberCellularProvider];
		
		// Get carrier name
		if ([carrier carrierName] != nil){
			carrierName = [carrier carrierName];
		}else {
			carrierName = @"";
		}
	}else {
		carrierName = @"";
	}
	
	if ([carrierName isEqualToString:@"AT&T"]){
		carrierName = @"AT_T";
	}
    NSString *tocken;
    if ([[SHBPushInfo instance].deviceToken length] == 0)
    {
        tocken = @"";
    }else
    {
        tocken = [SHBPushInfo instance].deviceToken;
    }
    
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								@{
								@"deviceId" : [AppDelegate getSSODeviceID],
								@"appStatus" : @"AUTO",
                                @"ssoSid" : self.ssoSid,
								@"syncResult" : @"1",
                                @"APP_VERSION" :AppInfo.bundleVersion,
                                @"OS_TYPE" : @"I",
                                @"MACADDRESS1" :[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                @"MACADDRESS2" :[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                //@"SBANK_SVC_CODE" : @"A0010",
                                @"SBANK_SVC_CODE" : @"A1000",
                                @"SBANK_CUSNO" : @"",
                                @"SBANK_RRNO" :@"",
                                @"SBANK_SBANKVER":[NSString stringWithFormat:@"02 %@",AppInfo.bundleVersion],
                                //@"SBANK_PHONE_OS" : [[UIDevice currentDevice] systemVersion],
                                @"SBANK_PHONE_OS" : [SHBUtilFile getOSVersion],
                                @"SBANK_PHONE_NO" :@"",
                                //@"SBANK_PHONE_COM" :carrierName,
                                @"SBANK_PHONE_COM" : [SHBUtilFile getTelecomCarrierName],
                                //@"SBANK_PHONE_MODEL" :[[UIDevice currentDevice] model],
                                @"SBANK_PHONE_MODEL" :[SHBUtilFile getModel],
                                @"SBANK_UID1" :[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                @"SBANK_MAC1" :[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                @"SBANK_PHONE_ETC1" : @"",
                                @"SBANK_TOKEN" : tocken,
                                @"SBANK_PHONE_INFO" : [SHBUtilFile getResultSum:[NSString stringWithFormat:@"%@%@",PROTOCOL_HTTPS,AppInfo.serverIP] portNumber:443 connected:TRUE accessGroup:@"HQ59H9US6W.com.ktb.KeychainSuite"],
								}] autorelease];
    
    SendData(SHBTRTypeServiceCode, @"request", SSO_URL2, self, forwardData);
    
}

- (void)ssoSessionSync{
    //NSLog(@"push step 6");
	// 동기화
    isAutoLogin = NO;
    /*
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								@{
								@"deviceId" : [AppDelegate getSSODeviceID],
								@"appStatus" : @"SYNC",
								}] autorelease];
     
    SendData(SHBTRTypeServiceCode, @"request", SSO_URL, self, forwardData);
	*/
    //ios7 대응으로 2013.10.07 변경
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								@{
								@"deviceId" : [AppDelegate getSSODeviceID],
								@"appStatus" : @"SYNC",
								}] autorelease];
    
    SendData(SHBTRTypeServiceCode, @"request", SSO_URL2, self, forwardData);
}

- (void)ssoWebSessionSync{
	
    isAutoLogin = NO;
    //티켓 생성 요청
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								@{
								@"deviceId" : [AppDelegate getSSODeviceID],
								@"procStatus" : @"CREATE",
                                @"createResult" : @"0",
                                @"ticket" : @"",
								}] autorelease];
    SendData(SHBTRTypeServiceCode, @"request", SSO_TICKET_URL, self, forwardData);
    
}

- (void)client:(OFHTTPClient *)client didReceiveDataSet:(OFDataSet *)dataSet{
	Debug(@"SSO 로그인 및 동기화 결과 : %@",dataSet);
	//NSLog(@"push step 7");
	if ([dataSet objectForKey:@"result"])
    {
        //sync  전문 처리
        //result가 2이면 sso 실패로 메인페이지로 보낸다.
        if ([dataSet[@"result"] isEqualToString:@"2"] && isgrSSO)
        {
            [AppDelegate closeProgressView];
            [AppDelegate.navigationController fadePopToRootViewController];
            isgrSSO = NO;
            return;
        }
        
        //그룹사 sso search 전문 result가 4이면 회원가입 페이지로 보낸다.
        if ([dataSet[@"result"] isEqualToString:@"4"])
        {
            [AppDelegate closeProgressView];
            [AppDelegate.navigationController fadePopToRootViewController];
            if (AppInfo.isLogin == LoginTypeIDPW || AppInfo.isLogin == LoginTypeCert)
            {
                [AppInfo logout];
            }
            AppInfo.certProcessType = CertProcessTypeNo;
            SHBSignupViewController *viewController = [[SHBSignupViewController alloc] initWithNibName:@"SHBSignupViewController" bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }
        
        if (isAutoLogin)
        {
            [AppDelegate closeProgressView];
            isAutoLogin = NO;
            
            //로그아웃을 시키고 로그인 로직을 태운 후 해당 메뉴로 진입하게 한다.
            if (AppInfo.isLogin == LoginTypeIDPW || AppInfo.isLogin == LoginTypeCert)
            {
                [AppInfo logout];
                
            }
            [self showViewController];
            return;
        }
        
        if (ssoType == 0)
        {
            // SSO 동기화 결과
            // scheme URL 호출
            
            NSString *schNm = [[_appArray objectAtIndex:0] objectForKey:@"appID"]; // 기존 "패키지_스키마" (화면아이디가 있는 경우가 있으므로 수정)
            
            NSString *schUrl;
            //스마트펀드 예외처리
            if ([schNm hasPrefix:@"smartfundcenter://"] || AppInfo.smartFundType != 0)
            {
                NSString *ssoData = @"";
                
                // release 처리
                Encryption *encrypt = [[[Encryption alloc] init] autorelease];
                if (AppInfo.smartFundType == 1)
                {
                    ssoData = @"{\"menu\":\"myfund\",\"sub\":\"0\"}";
                } else if (AppInfo.smartFundType == 2)
                {
                    ssoData = @"{\"menu\":\"banking\",\"sub\":\"0\"}";
                } else if (AppInfo.smartFundType == 3)
                {
                    ssoData = @"{\"menu\":\"best\",\"sub\":\"0\"}";
                } else if (AppInfo.smartFundType == 4)
                {
                    ssoData = @"{\"menu\":\"search\",\"sub\":\"0\"}";
                }
                
                ssoData = [encrypt aes128Encrypt:ssoData];
                
                //schUrl = [NSString stringWithFormat:@"%@?syncResult=%@&ssoData=%@",schNm,[dataSet objectForKey:@"result"],ssoData];
                NSLog(@"schNm:%@",schNm);
                //ios7 대응으로 2013.10.07 수정
                //if (ssoData == nil)
                //{
                //    schUrl = [NSString stringWithFormat:@"%@?syncResult=%@&syncSsoSid=%@",schNm,[dataSet objectForKey:@"result"],[dataSet objectForKey:@"ssoSid"]];
                //}else
                //{
                
                schUrl = [NSString stringWithFormat:@"%@?syncResult=%@&ssoData=%@&syncSsoSid=%@",schNm,[dataSet objectForKey:@"result"],ssoData,[dataSet objectForKey:@"ssoSid"]];
                
                //}
                
                self.ssoSid = [dataSet objectForKey:@"ssoSid"];
                AppInfo.smartFundType = 0;
            }else
            {
                //schUrl = [NSString stringWithFormat:@"%@?syncResult=%@",schNm,[dataSet objectForKey:@"result"]];
                //ios7 대응으로 2013.10.07 수정
                //#ifdef DEVELOPER_MODE
                //if ([schNm isEqualToString:@"smartcaremgr://"])
                //{
                    //schNm = @"smailapp://A201";
                    //schNm = @"smartcaremgr://A201";
                //}
                //#endif
                schNm = [schNm stringByReplacingOccurrencesOfString:@"?" withString:@""];
                schUrl = [NSString stringWithFormat:@"%@?syncResult=%@&syncSsoSid=%@",schNm,[dataSet objectForKey:@"result"],[dataSet objectForKey:@"ssoSid"]];
                self.ssoSid = [dataSet objectForKey:@"ssoSid"];
            }
            
            
            Debug(@"SSO schNm : %@",schNm);
            Debug(@"SSO schUrl : %@",schUrl);
            //NSString *schUrl = [NSString stringWithFormat:@"%@app?syncRetult=%@",schNm,[dataSet objectForKey:@"result"]];
            // schme Url 호출
            if (schNm == nil)
            {
                [AppDelegate closeProgressView];
                return;
            }
            [self callSchemeUrl:schUrl];
            
        
            
        } else if (ssoType == 1) //web
        {
            if ([SHBUtility isFindString:webSSOUrl find:@"jsp?"])
            {
                webSSOUrl = [NSString stringWithFormat:@"%@&ssoTicketId=%@",webSSOUrl,[dataSet objectForKey:@"ticket"]];
            }else
            {
                webSSOUrl = [NSString stringWithFormat:@"%@?&ssoTicketId=%@",webSSOUrl,[dataSet objectForKey:@"ticket"]];
            }
            
            Debug(@"webSSOUrl:%@",webSSOUrl);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webSSOUrl]];
        }
		
		//개인화 이미지적용에 의한 변경
	}//else if ([[dataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"A0010"]){
else if ([[dataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"A1000"] && [dataSet[@"고객회원등급"] isEqualToString:@"1"]){
    
        [AppDelegate.navigationController fadePopToRootViewController];
        if (AppInfo.isSSOLogin)
        {
            [AppDelegate closeProgressView];
            AppInfo.isSSOLogin = NO;
        }
        
        if ([[dataSet objectForKey:@"스마트뱅킹가입상태"] isEqualToString:@"1"]){
            AppInfo.isSignupService = YES;
        } else
        {
            AppInfo.isSignupService = NO;
            AppInfo.phoneNumber = [dataSet objectForKey:@"전화번호"];
            
            SHBBaseViewController *signViewController = [[[NSClassFromString(@"SHBSignupServiceStep1ViewController") class] alloc] initWithNibName:@"SHBSignupServiceStep1ViewController" bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:signViewController];
            [signViewController release];
            return;
        }
        
		// 공인인증 자동 로그인
		Debug(@"1. 공인인증 자동 로그인 결과");
        //sso로 들어온 인증서 정보와 비교해 같은 인증서가 있는지 확인하고 인증서로 지정 ////////////////////////
        ssoCertserialNum = [dataSet objectForKey:@"SSO_SERIAL"];
        ssoCertIssuer = [dataSet objectForKey:@"SSO_SISSUER"];
        ssoCertDN = [dataSet objectForKey:@"SSO_CERTDN"];
        ssoCertSubjectDN = [dataSet objectForKey:@"SSO_SUBJECTDN"];
        [self loadCertificates];
        //////////////////////////////////////////////////////////////////////////////////////
		// 로그인 정보 저장.
        Encryption *encryptor = [[Encryption alloc] init];
		AppInfo.userInfo	= [NSMutableDictionary dictionaryWithDictionary:dataSet];
		AppInfo.customerNo	= [dataSet objectForKey:@"고객번호"];
		//AppInfo.ssn			= [dataSet objectForKey:@"주민등록번호"];
        AppInfo.ssn			= [encryptor aes128Encrypt:[dataSet objectForKey:@"주민등록번호"]];
		AppInfo.phoneNumber	= [dataSet objectForKey:@"전화번호"];
		AppInfo.isLogin		= LoginTypeCert;
    
        [encryptor release];
        
        //폰정보 전송
        #if !TARGET_IPHONE_SIMULATOR
            //[self requestInsertPhoneInfo];
        #endif
    
        
		// 하단의 퀵메뉴에 로그인,아웃 버튼 교체
		[[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeQuickLogin:YES];
		
        AppInfo.isCheatDefanceAgree = YES;
        AppInfo.isOldPCRegister = YES;
    
        //* 전자금융 사기예방을 위해 통지 신청 불가 (해지는 가능) 14.03.17
        // 사기예방 동의 하는 화면으로 이동하고 다음로직은 중단한다.
        /*
        if ([[dataSet objectForKey:@"사기예방동의여부"] isEqualToString:@"0"]){
            
            AppInfo.isCheatDefanceAgree = NO;
            // 구 사기예방서비스 변경동의
            SHBOldSecurityChangeViewController *regPwViewController = [[SHBOldSecurityChangeViewController alloc] initWithNibName:@"SHBOldSecurityChangeViewController" bundle:nil];
           
            
            [AppDelegate.navigationController pushFadeViewController:regPwViewController];
            [regPwViewController release];
            return;
        }
        
        else
         */
    
    if ([AppInfo.userInfo[@"블랙리스트차단구분"] isEqualToString:@"4"])
    {
        if (AppInfo.lastViewController != nil)
        {
            AppInfo.lastViewController = nil;
        }
        SHBIdentity4ViewController *viewController = [[SHBIdentity4ViewController alloc]initWithNibName:@"SHBIdentity4ViewController" bundle:nil];
        [viewController setServiceSeq:SERVICE_IP_CHECK];
        viewController.needsLogin = YES;
        //viewController.delegate = self;
        //[self checkLoginBeforePushViewController:viewController animated:YES];
        [AppDelegate.navigationController pushFadeViewController:viewController];
        //Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
        [viewController executeWithTitle:@"본인 확인절차 강화 서비스" Step:0 StepCnt:0 NextControllerName:@""];
        //[viewController subTitle:@"안심거래 서비스 본인 확인 절차 강화"];
        //viewController.subTitleLabel.text = @"안심거래 서비스 본인 확인 절차 강화";
        [viewController release];
        return;
    }
    
        if ([[dataSet objectForKey:@"구PC등록동의여부"] isEqualToString:@"0"]){
            
            //구PC등록동의여부
            AppInfo.isOldPCRegister = NO;
            SHBOldSecurityViewController *regPwViewController = [[SHBOldSecurityViewController alloc] initWithNibName:@"SHBOldSecurityViewController" bundle:nil];
         
            
            [AppDelegate.navigationController pushFadeViewController:regPwViewController];
            [regPwViewController release];
        }
         
        // 신한카드 이용동의
        if (![AppInfo.userInfo[@"카드이용동의여부"] isEqualToString:@"Y"]){
            AppInfo.isCardAgree = NO;
        }else{
            AppInfo.isCardAgree = YES;
        }
        
		// 신한카드 메뉴 선택인 경우 이용동의 체크
		if ([NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBCard"]) {
			SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
			[checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
		}
        
        // 보안센터 이용기기등록서비스 선택시
        else if ([NSStringFromClass([AppInfo.lastViewController class]) isEqualToString:@"SHBDeviceRegistServiceViewController"]) {
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
        }
		
		// 지로 지방세의 경우
		// 메뉴 1,2,3,4 경우 시간 확인이 필요
		// 메뉴 진입전 처리
		else if ( [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBGiroTax"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBDistricTaxMenu"])
		{
			SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
			[checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
		}
		
		// 퇴직연금 메뉴의 경우
		// 퇴직연금의 메뉴 1,2,3,4,5 경우 가입 유무와 동의 확인이 필요하다
		// 메뉴 진입 전 로그인 후에 처리되고 있음(2군데)
		else if ( [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBRetirementReserve"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBProductState"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBSurcharge"] || [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBRetirementReceip"]|| [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBESNoti"] )
		{
			
			SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
			[checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
		}
        
        // 간편조회 서비스의 경우
        else if (AppInfo.isEasyInquiry && [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBAccountInqueryViewController"]) {
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
        }
    
        // 예적금담보대출의 신청버튼을 누른 경우 4영업일 이내 가입인지 체크
        else if ([NSStringFromClass([AppInfo.lastViewController class]) isEqualToString:@"SHBLoanStipulationViewController"]) {
            
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
        }
    
        // 스마트 이체 조회/등록/변경
        else if ([NSStringFromClass([AppInfo.lastViewController class]) isEqualToString:@"SHBSmartTransferAddInputViewController"]) {
            
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
        }
    
        else{
			// 해당화면으로 고고씽!!!
			[self showViewController];
		}
        //안심거래 예방서비스 공지 팝업 여부
        if (AppInfo.isTapSmithingMenu)
        {
            AppInfo.isTapSmithingMenu = NO;
        }else
        {
            AppInfo.isTapSmithingMenu = NO;
            //이용기기 등록서비스 가입여부
            if ([AppInfo.userInfo[@"이용기기등록여부"] isEqualToString:@"1"])
            {
                return;
            }
            //사기예방 sms 통지여부
            if ([AppInfo.userInfo[@"사기예방SMS통지여부"] isEqualToString:@"1"])
            {
                return;
            }
            //otp  사용자인지
            if ([AppInfo.userInfo[@"보안매체정보"] isEqualToString:@"5"])
            {
                return;
            }
            if ([AppInfo.userInfo[@"안심거래가입여부"] isEqualToString:@"1"])
            {
                return;
            }
            if ([AppInfo.userInfo[@"안심거래서비스사용여부"] isEqualToString:@"N"])
            {
                return;
            }
            if ([AppInfo.userInfo[@"안심거래서비스팝업사용여부"] isEqualToString:@"N"])
            {
                return;
            }
            [AppInfo smithingAlert];
        }

	}//else
        //개인화 이미지적용에 의한 변경
    else if ([[dataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"A1000"] && ![dataSet[@"고객회원등급"] isEqualToString:@"1"])
    {
        [AppDelegate.navigationController fadePopToRootViewController];
        //id,pwd로 sso 로그인 한 경우....
        if (AppInfo.isSSOLogin)
        {
            [AppDelegate closeProgressView];
            AppInfo.isSSOLogin = NO;
        }
        Encryption *encryptor = [[Encryption alloc] init];
		// ID,PW 자동 로그인
		Debug(@"2. ID/PW 자동 로그인 결과");
		// 사용자 정보 저장.
        AppInfo.userInfo	= [NSMutableDictionary dictionaryWithDictionary:dataSet];
        AppInfo.customerNo	= [dataSet objectForKey:@"고객번호"];
        //AppInfo.ssn			= [dataSet objectForKey:@"주민등록번호"];
        AppInfo.ssn			= [encryptor aes128Encrypt:[dataSet objectForKey:@"주민등록번호"]];
        AppInfo.phoneNumber	= [dataSet objectForKey:@"전화번호"];
        AppInfo.loginID		= [dataSet objectForKey:@"아이디"];
        AppInfo.isLogin		= LoginTypeIDPW;
        
        AppInfo.ssnForIDPWD = [dataSet objectForKey:@"주민등록번호"];
        [encryptor release];
        
        //폰정보 전송
        #if !TARGET_IPHONE_SIMULATOR
            //[self requestInsertPhoneInfo];
        #endif
        
        //AppInfo.loginID = [AppInfo.loginID uppercaseString];
		// 하단의 퀵메뉴에 로그인,아웃 버튼 교체
		[[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeQuickLogin:YES];
		
        
        if ([[dataSet objectForKey:@"회원구분"] isEqualToString:@"9"])
        {
            
            //		// 이용자 비밀번호 등록 필요   ===== 2014. 3.5 수정 주민번호 입력으로
            /*
            SHBUserPWRegInputViewController *regPwViewController = [[SHBUserPWRegInputViewController alloc] initWithNibName:@"SHBUserPWRegInputViewController" bundle:nil];
            regPwViewController.data = dataSet;
            regPwViewController.strServiceCode = @"H1001";
            [AppDelegate.navigationController pushFadeViewController:regPwViewController];
            [regPwViewController release];
            return;
             */
            
            
            SHBUserPWRegViewController *regPwViewController = [[SHBUserPWRegViewController alloc] initWithNibName:@"SHBUserPWRegViewController" bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:regPwViewController];
            [regPwViewController release];
            return;

            
        }
        else if ([[dataSet objectForKey:@"고객회원등급"] isEqualToString:@"3"])
        {
            //NSLog(@"aaaa:%@",[aDataSet objectForKey:@"고객회원등급"]);
            
            // 외국인인 경우 알럿처리
            if ([dataSet[@"주민등록번호"] length] == 13) {
                NSString *forType = [dataSet[@"주민등록번호"] substringWithRange:NSMakeRange(6, 1)];
                
                if ([forType isEqualToString:@"5"] ||
                    [forType isEqualToString:@"6"] ||
                    [forType isEqualToString:@"7"] ||
                    [forType isEqualToString:@"8"]) {
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"영업점을 방문하여 가입을 완료하시기 바랍니다.(온라인 서비스 가입)"];
                    
                    [AppInfo logout];
                    
                    return;
                }
            }
            
            NSString *customerNo = dataSet[@"COM_CIF_NO"];
            
            if ([customerNo length] < 10) {
                
                customerNo = [NSString stringWithFormat:@"0%@", customerNo];
            }
            
            AppInfo.commonDic = @{ //@"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? dataSet[@"주민등록번호"] : @"",
                                   @"실명번호" : dataSet[@"주민등록번호"],
                                   @"고객명" : dataSet[@"고객성명"],
                                   @"아이디" : AppInfo.loginID,
                                   @"고객번호" : customerNo };
            
            [AppInfo logout];
            
            SHBQryServiceViewController *qryViewController = [[SHBQryServiceViewController alloc] initWithNibName:@"SHBQryServiceViewController" bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:qryViewController];
            [qryViewController release];
            return;
            
        }
        
        AppInfo.isCheatDefanceAgree = YES;
        AppInfo.isOldPCRegister = YES;
        
        //* 전자금융 사기예방을 위해 통지 신청 불가 (해지는 가능) 14.03.17
        // 사기예방 동의 하는 화면으로 이동하고 다음로직은 중단한다.
        /*
        if ([[dataSet objectForKey:@"사기예방동의여부"] isEqualToString:@"0"]){
            AppInfo.isCheatDefanceAgree = NO;
            // 구 사기예방서비스 변경동의
            SHBOldSecurityChangeViewController *regPwViewController = [[SHBOldSecurityChangeViewController alloc] initWithNibName:@"SHBOldSecurityChangeViewController" bundle:nil];
     
            [AppDelegate.navigationController pushFadeViewController:regPwViewController];
            [regPwViewController release];
            return;
        }
        
        else 
         */
        
        if ([AppInfo.userInfo[@"블랙리스트차단구분"] isEqualToString:@"4"])
        {
            if (AppInfo.lastViewController != nil)
            {
                AppInfo.lastViewController = nil;
            }
            SHBIdentity4ViewController *viewController = [[SHBIdentity4ViewController alloc]initWithNibName:@"SHBIdentity4ViewController" bundle:nil];
            [viewController setServiceSeq:SERVICE_IP_CHECK];
            viewController.needsLogin = YES;
            //viewController.delegate = self;
            //[self checkLoginBeforePushViewController:viewController animated:YES];
            [AppDelegate.navigationController pushFadeViewController:viewController];
            //Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
            [viewController executeWithTitle:@"본인 확인절차 강화 서비스" Step:0 StepCnt:0 NextControllerName:@""];
            //[viewController subTitle:@"안심거래 서비스 본인 확인 절차 강화"];
            //viewController.subTitleLabel.text = @"안심거래 서비스 본인 확인 절차 강화";
            [viewController release];
            return;
        }
        
        if ([[dataSet objectForKey:@"구PC등록동의여부"] isEqualToString:@"0"]){
            
            AppInfo.isOldPCRegister = NO;
            //구PC등록동의여부
            SHBOldSecurityViewController *regPwViewController = [[SHBOldSecurityViewController alloc] initWithNibName:@"SHBOldSecurityViewController" bundle:nil];
            
            [AppDelegate.navigationController pushFadeViewController:regPwViewController];
            [regPwViewController release];
            return;
         
        }
         
         
        
		// 해당화면으로 고고씽!!!
		[self showViewController];
	}
}


// 디바이스 토큰 등록
- (void) requestPush
{
    //NSLog(@"push step 8");
	if (_deviceToken.length == 0)
		return;
	
	
}

// PUSH 서비스 정보 획득
- (void) requestMyPushInfo
{
	
}


#pragma mark - Methods
- (void)setDeviceTokenWithData:(NSData *)data
{
    //NSLog(@"push step 9");
	NSMutableString* mstr = [[NSMutableString alloc] initWithCapacity:0];
	
	BytePtr ptr = (BytePtr)[data bytes];
	for (int i = 0; i < data.length; i++)
	{
		[mstr appendFormat:@"%02x", ptr[i]];
	}
	
	self.deviceToken = mstr;
	
	NSDictionary* userData = [[NSDictionary alloc] initWithObjectsAndKeys:
							  mstr, 								KEY_DEVICE_TOKEN,
							  _wantPushNotification ? @"Y" : @"N",	KEY_PUSH_NOTIFICATION,
							  _wantSchemeUrl		? @"Y" : @"N",	KEY_SCHEME_URL,
							  _isFirstRegister		? @"Y" : @"N",	KEY_FIRST_REGISTER,
							  nil];
	
	SHBUtilFile *util = [SHBUtilFile instance];
	[util setShareDataFile:PUSH_DATA_FILE_NAME fileData:userData];
	
	[mstr release];
	[userData release];
}

- (BOOL)readDeviceTokenFromFile
{
    //NSLog(@"push step 10");
	SHBUtilFile *util = [SHBUtilFile instance];
	NSDictionary* userData =[util getShareDataFile:PUSH_DATA_FILE_NAME];
	if (userData)
	{
		NSString* token 		= [userData  objectForKey:KEY_DEVICE_TOKEN 		];
		_wantPushNotification	= [[userData objectForKey:KEY_PUSH_NOTIFICATION	] isEqualToString:@"Y"] ? YES : NO;
		_wantSchemeUrl			= [[userData objectForKey:KEY_SCHEME_URL		] isEqualToString:@"Y"] ? YES : NO;
		_isFirstRegister		= [[userData objectForKey:KEY_FIRST_REGISTER 	] isEqualToString:@"Y"] ? YES : NO;
		
		if (token && token.length == 64)
		{
            Debug(@"\n------------------------------------------------------------------\
                  \nDevice Token:%@\
                  \n------------------------------------------------------------------", token);
			[self setDeviceToken:token];
			return YES;
		}
	}
	
	return NO;
}


- (void)onReceivePush:(NSDictionary *)userInfo
{
    //NSLog(@"push step 11");
#ifdef TARGET_IPHONE_SIMULATOR
	Debug(@"onReceivePush - BEGIN");
    
    NSDictionary *tmpDic = [[NSDictionary alloc] init];
	for (id key in userInfo) {
		Debug(@"key=%@ value=%@", key, [userInfo objectForKey:key]);
        if ([(NSString *)key isEqualToString:@"customData"])
        {
            tmpDic = [userInfo objectForKey:key];
        }
	}
	Debug(@"onReceivePush - END");
	Debug(@"---");
#endif
	if (tmpDic[@"url"])
    {
        //스키마 url인지 확인
        NSArray *appUrlArr =  [tmpDic[@"url"] componentsSeparatedByString:@"://"];
        if ([appUrlArr count] == 2)
        {
            NSArray *screenArr =  [[appUrlArr objectAtIndex:1] componentsSeparatedByString:@"?"];
            if( [screenArr count] == 2 )
            {
                AppInfo.schemaUrl = tmpDic[@"url"];
                [self recieveOpenURL];
                
                //스마트케어 url인지 확인한 후 바텀뷰 이미지를 교체한다.
                NSString *menuID = [[NSString alloc] initWithString:[screenArr objectAtIndex:0]];
                if ([menuID isEqualToString:@"SM_06"])
                {
                    AppInfo.noticeState = 2;
                    AppInfo.isSmartCareNoti = YES;
                    for (int i = 0; i < [[AppDelegate.navigationController viewControllers] count]; i++)
                    {
                        [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeBottmNotice:AppInfo.noticeState];
                    }
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"smartCareReceiveNoti" object:nil];
                }
                return;
            }
        }
        
    }
    
	//스키마에 의한 메뉴이동이 아니면 스마트레터를 오픈한다.
	SafeRelease(_screenId);
	_screenId = [[NSString alloc] initWithString:@"SM_01"];
	if (!_screenId) return;
	
    [_dataDic removeAllObjects];
    [_dataDic setObject:_screenId forKey:@"screenID"];
    
    
	NSString *clsNm = [self getClassName];
	if (clsNm != nil && [clsNm length] > 0){
		SHBBaseViewController *viewController = [[[NSClassFromString(clsNm) class] alloc] initWithNibName:clsNm bundle:nil];
		AppInfo.lastViewController = viewController;
		[viewController release];
	}
	
	// 해당 화면을 찾아서 쇼우~!
	[self showViewController];
}

- (void) didChangeScreen:(classSeq)scrNo{
    //NSLog(@"push step 12");
    //	if (scrNo == _scrNo) return;
    //
    //	_scrNo = scrNo;
    //
    //	CGRect rect = _viewTitle.frame;
    //
    //	switch (scrNo)
    //	{
    //		case CONTENT_STOCK_PRESENT_QUATE:
    //		case CONTENT_STOCK_PRESENT_FIRMS:
    //		case CONTENT_STOCK_PRESENT_CONTRACT:
    //		case CONTENT_STOCK_PRESENT_DAY:
    //		case CONTENT_STOCK_PRESENT_CHART:
    //		case CONTENT_STOCK_PRESENT_INVESTOR:
    //		case CONTENT_STOCK_PRESENT_NEWS:
    //		case CONTENT_STOCK_PRESENT_INFO:
    //		{
    //			_isActive = YES;
    //			_viewSignal.hidden = YES;
    //			_viewNews.hidden = YES;
    //			rect.size.width = 141;
    //		}
    //			break;
    //
    //		default:
    //		{
    //			_isActive = NO;
    //			_viewSignal.hidden = YES;
    //			_viewNews.hidden = YES;
    //			rect.size.width = 198;
    //		}
    //	}
    //
    //	_viewTitle.frame = rect;
}


- (void) showViews
{
    //NSLog(@"push step 13");
	if (NO == _isActive) return;
	
    //#if TARGET_IPHONE_SIMULATOR
    //	NSString* data1 = [_stockSignal objectForKey:_stockCode];
    //	NSString* data2 = [_stockNews objectForKey:_stockCode];
    //	NSLog(@"stcd=%@ data1=%@ data2=%@", _stockCode, data1, data2);
    //#endif
    //
    //	_viewSignal.hidden = [_stockSignal objectForKey:_stockCode] == nil ? YES : NO;
    //	_viewNews.hidden   = [_stockNews   objectForKey:_stockCode] == nil ? YES : NO;
}

- (void) addLaunchStockCodeToHistory
{
    //NSLog(@"push step 14");
    //    CodeMaster* master = [CodeMaster getInstance];
    //    [master addHistory:_launchStockCode market:MARKET_GUBUN_STOCK];
}

- (NSString*) getClassName{
    //NSLog(@"push step 15");
	for (int i = 0; i < [_classArray count]; i++) {
		if ([[_classArray objectAtIndex:i] objectForKey:_screenId]){
			return [[_classArray objectAtIndex:i] objectForKey:_screenId];
			break;
		}
	}
	
	return nil;
}

- (void) showViewController{
    //NSLog(@"push step 16");
	NSString *className = nil;
    NSString *classNibName = nil;
	NSString *loginFlag = nil;
	
	for (int i = 0; i < [_classArray count]; i++) {
		if ([[_classArray objectAtIndex:i] objectForKey:_screenId]){
			className = [[_classArray objectAtIndex:i] objectForKey:_screenId];
			loginFlag = [[_classArray objectAtIndex:i] objectForKey:@"login"];
			break;
		}
	}
	
    
	if ([className length] > 0 && className != nil){
        classNibName = className;
        //공인 인증셑너 다국어 지원 nib 호출
        if (AppInfo.certProcessType != CertProcessTypeNo)
        {
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                classNibName = [NSString stringWithFormat:@"%@Eng",className];
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                classNibName = [NSString stringWithFormat:@"%@Jpn",className];
            }else
            {
                
            }
        }

        NSLog(@"className:%@",className);
        
        //즉시이체/예금입금 스키마 연동 처리
//        if ([_dataDic[@"screenID"] isEqualToString:@"D2011"])
//        {
//            className =
//        }
        
		SHBBaseViewController *viewController = [[[NSClassFromString(className) class] alloc] initWithNibName:classNibName bundle:nil];
		if ([loginFlag isEqualToString:@"1"]){
			viewController.needsLogin = YES;
			viewController.needsCert = NO;
		}else if ([loginFlag isEqualToString:@"2"]){
			viewController.needsLogin = NO;
			viewController.needsCert = YES;
		}else{
			viewController.needsLogin = NO;
			viewController.needsCert = NO;
		}
        //		if ([className isEqualToString:@"SHBCertManageViewController"]) //모바일웹 스마트폰->pc인증서 복사
        //        {
        //            AppInfo.certProcessType = CertProcessTypeCopyPC;
        //        }
		viewController.isPushAndScheme = YES;
        
        AppInfo.indexQuickMenu = 0;
        //[AppDelegate.navigationController PopSlideDownViewController];
        
		[[NSNotificationCenter defaultCenter] postNotificationName:@"logoutClose" object:nil];
        [AppDelegate.navigationController fadePopToRootViewController];
		[[[AppDelegate.navigationController viewControllers] objectAtIndex:0] checkLoginBeforePushViewController:viewController animated:NO];
        
        NSLog(@"datadic:%@",_dataDic);
		[viewController executeWithDic:_dataDic];
		[viewController release];
	}
	
	
}

- (void) recieveOpenURL{
    //NSLog(@"push step 17");
    @try {
        NSString *urlSchema =  AppInfo.schemaUrl;
        
        if(urlSchema && [urlSchema length] > 0 )
        {
            Debug(@"urlSchema =====> [%@]",urlSchema);
            //AppUrl 확인
            NSArray *appUrlArr =  [urlSchema componentsSeparatedByString:@"://"];
			
            //앱간 인증서 복사 처리
            if ([[appUrlArr objectAtIndex:0] isEqualToString:@"SFG-SHB-sbank"])
            {
                //신한카드
                
                if ([[appUrlArr objectAtIndex:1] rangeOfString:@"SFG-SHC-smartcard"].location != NSNotFound)
                {
                    AppInfo.certProcessType = CertProcessTypeCopySHCard;
                } else if ([[appUrlArr objectAtIndex:1] rangeOfString:@"SFG-SHL-slife"].location != NSNotFound)
                {
                    AppInfo.certProcessType = CertProcessTypeCopySHInsure;
                }else if ([[appUrlArr objectAtIndex:1] rangeOfString:@"SFG-SEEROO-shsmartpay"].location != NSNotFound)
                {
                    AppInfo.certProcessType = CertProcessTypeCopySHCardEasyPay;
                }else
                {
                    return;
                }
                
                SHBBaseViewController *viewController = [[[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil] autorelease];
                AppInfo.lastViewController = viewController;
                [viewController release];
                [AppDelegate.navigationController pushFadeViewController:viewController];
                
            } else if( [appUrlArr count] == 2) //푸시나 sso 처리
            {
                
                NSArray *screenArr =  [[appUrlArr objectAtIndex:1] componentsSeparatedByString:@"?"];
                
				//화면 ID 확인
                if( [screenArr count] == 2 )
                {
					[_dataDic removeAllObjects];
					
					// 화면별 파라미터 셋팅
					NSArray *argArr =  [[screenArr objectAtIndex:1] componentsSeparatedByString:@"&"];
					for( int i=0;i < [argArr count];i++){
						NSArray *ArrKeyVal = [[argArr objectAtIndex:i] componentsSeparatedByString:@"="];
						
						if ([ArrKeyVal count] < 2) break;
						
						[_dataDic setObject:[ArrKeyVal objectAtIndex:1] forKey:[ArrKeyVal objectAtIndex:0]];
						
					}
					
					SafeRelease(_screenId);
					_screenId = [[NSString alloc] initWithString:[screenArr objectAtIndex:0]];
                    
                    [_dataDic setObject:_screenId forKey:@"screenID"];
                    
                    NSLog(@"_dataDic:%@",_dataDic);
                    
                    
                    //언어 세팅
                    if ([SHBUtility isFindString:[screenArr objectAtIndex:1] find:@"lang=KOR"])
                    {
                        AppInfo.LanguageProcessType = KoreaLan;
                        
                    } else if ([SHBUtility isFindString:[screenArr objectAtIndex:1] find:@"lang=ENG"])
                    {
                        AppInfo.LanguageProcessType = EnglishLan;
                    } else if ([SHBUtility isFindString:[screenArr objectAtIndex:1] find:@"lang=JPN"])
                    {
                        AppInfo.LanguageProcessType = JapanLan;
                    } else
                    {
                        AppInfo.LanguageProcessType = KoreaLan;
                    }
                    //모바일 웹에서 들어온 인증센터 종류를 결정한다.
                    if ([_screenId isEqualToString:@"KA-0"]) //인증서 발급/ 재발급
                    {
                        if (AppInfo.isLogin)
                        {
                            [AppInfo logout];
                        }
                        AppInfo.certProcessType = CertProcessTypeIssue;
                    }else if ([_screenId isEqualToString:@"KA-1"]) //인증서 창구 발급/재발급
                    {
                        if (AppInfo.isLogin)
                        {
                            [AppInfo logout];
                        }
                        AppInfo.certProcessType = CertProcessTypeSpotIssue;
                    }else if ([_screenId isEqualToString:@"KB-1"]) //pc->스마트폰 인증서 복사
                    {
                        if (AppInfo.isLogin)
                        {
                            [AppInfo logout];
                        }
                        AppInfo.certProcessType = CertProcessTypeCopySmart;
                    } else if ([_screenId isEqualToString:@"TA-1"]) //스마트폰 -> PC
                    {
                        AppInfo.certProcessType = CertProcessTypeCopyPC;
                    } else if ([_screenId isEqualToString:@"KF-1"]) //인증서 갱신
                    {
                        if (AppInfo.isLogin)
                        {
                            [AppInfo logout];
                        }
                        AppInfo.certProcessType = CertProcessTypeRenew;
                    } else if ([_screenId isEqualToString:@"KF-1"]) //인증서 폐기
                    {
                        if (AppInfo.isLogin)
                        {
                            [AppInfo logout];
                        }
                        AppInfo.certProcessType = CertProcessTypeRegOrExpire;
                    } else if ([_screenId isEqualToString:@"KD-1"]) //pc->QR 인증서 복사
                    {
                        if (AppInfo.isLogin)
                        {
                            [AppInfo logout];
                        }
                        AppInfo.certProcessType = CertProcessTypeCopyQR;
                    } else if ([_screenId isEqualToString:@"KI-1"]) //인증서 관리
                    {
                        if (AppInfo.isLogin)
                        {
                            [AppInfo logout];
                        }
                        AppInfo.certProcessType = CertProcessTypeManage;
                    } else if ([_screenId isEqualToString:@"KJ-1"]) //인증서 안내
                    {
                        AppInfo.certProcessType = CertProcessTypeNo;
                    } else
                    {
                        AppInfo.certProcessType = CertProcessTypeNo;
                    }
                    
					if (!_screenId) return;
//					if (!_screenId || [_screenId isEqualToString:@""])
//                    {
//                       return;
//                    }
                    
					NSString *clsNm = [self getClassName];
					if (clsNm != nil && [clsNm length] > 0){
                        //공인 인증셑너 다국어 지원 nib 호출
                        if (AppInfo.certProcessType != CertProcessTypeNo)
                        {
                            if (AppInfo.LanguageProcessType == EnglishLan)
                            {
                                clsNm = [NSString stringWithFormat:@"%@Eng",clsNm];
                            }else if (AppInfo.LanguageProcessType == JapanLan)
                            {
                                clsNm = [NSString stringWithFormat:@"%@Jpn",clsNm];
                            }else
                            {
                                
                            }
                        }
                        
                        
						SHBBaseViewController *viewController = [[[[NSClassFromString(clsNm) class] alloc] initWithNibName:clsNm bundle:nil] autorelease];
						AppInfo.lastViewController = viewController;
						[viewController release];
					}
					
                    //해당 화면 진입시 버젼을 체크하여 진입여부를 결정
                    //[[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeBottmNotice:2];
                    NSString *tmpStr = [_dataDic objectForKey:@"iVer"];
                    
                    if ([tmpStr length] > 0)
                    {
                        tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"." withString:@""];
                        NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                        versionNumber = [versionNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
                        
                        if ([tmpStr intValue] > [versionNumber intValue])
                        {
                            NSString *msg = [NSString stringWithFormat:@"신한S뱅크 버젼 %@ 이상에서\n실행이 가능합니다.\n업데이트 하시겠습니까?",[_dataDic objectForKey:@"iVer"]];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                            message:msg
                                                                           delegate:self
                                                                  cancelButtonTitle:@"업데이트"
                                                                  otherButtonTitles:@"취소",nil];
                            
                            alert.tag =775;
                            [alert show];
                            [alert release];
                            return;
                        }
                    }
                    
					//SSO 연동 체크
					if ([_dataDic objectForKey:@"syncResult"] && [[_dataDic objectForKey:@"syncResult"] isEqualToString:@"1"])
                    {
                        //ios7 대응으로 2013.10.07 수정
                        if ([_dataDic objectForKey:@"syncSsoSid"])
                        {
                            self.ssoSid = [_dataDic objectForKey:@"syncSsoSid"];
                        }else
                        {
                            self.ssoSid = @"";
                        }
                        
						[self ssoAutoLogin];
                        
					}else{
						if ([_dataDic objectForKey:@"grssoTicket"])
                        {
                            //그룹사 sso
                            [self groupSSOSearch];
                        }else
                        {
                            //해당 화면을 찾아서 쇼우~!
                            [self showViewController];
                        }
					}
					
                } // end of data parsing
            } // end of AppUrl
        }
        
    }
    @catch (NSException *exception) {
        Debug(@"error => [%@]", exception);
    }
}

- (void) requestOpenURL:(NSString *)appId Parm:(NSString*)parm{
    //NSLog(@"push step 18");
    _requestParm = @"";
	[self setRequestParm:parm];
	
	SafeRelease(_appArray);
	_appArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	[_appArray removeAllObjects];
    
    if ([appId isEqualToString:@"shctopsclub://"] && AppInfo.indexQuickMenu != 3)
    {
        // Tops Club에서 프리미엄쿠폰을 누른 경우 web으로 이동해야함 (앱더보기에서는 아님)
        
        NSString *topsURL = @"/pages/financialInfo/mtops/mtops_premium.jsp";
        
        if (AppInfo.realServer) {
            topsURL = [NSString stringWithFormat:@"http://m.shinhan.com%@", topsURL];
        }
        else {
            topsURL = [NSString stringWithFormat:@"http://dev-m.shinhan.com%@", topsURL];
        }
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appId]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appId]];
            
            return;
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:topsURL]];
        
        return;
    }
    
    
	for (NSMutableDictionary *dic in AppInfo.otherAppArray){
        

		if ([appId hasPrefix:[dic objectForKey:@"패키지_스키마"]])
        {
            
            [dic setObject:appId forKey:@"appID"];
            [_appArray addObject:dic];
			break;
		}
        
        if ([SHBUtility isFindString:[dic objectForKey:@"패키지_스키마"] find:appId])
        {
            
            [dic setObject:appId forKey:@"appID"];
            [_appArray addObject:dic];
			break;
		}
	}
	NSLog(@"_appArray:%@",_appArray);
    
	if ([_appArray count] == 0)
    {
        [AppDelegate closeProgressView];
        return;
	}
	NSString *schName  = [[_appArray objectAtIndex:0] objectForKey:@"패키지_스키마"];
    NSString *ssoFlag  = [[_appArray objectAtIndex:0] objectForKey:@"SSO연동여부"];
    
//#ifdef DEVELOPER_MODE
    if ([SHBUtility isFindString:appId find:@"smartcaremgr://"] && [ssoFlag isEqualToString:@"0"])
    {
        //schName = @"smailapp://A201";
    //    schName = @"smartcaremgr://A201";
    //    ssoFlag  = @"1";
    }
//#endif
    
	// SSO 연동 구분 체크
	if ([ssoFlag isEqualToString:@"1"]){
        ssoType = 0; //app
		[self ssoSessionSync];
	}else{
        
        //그룹사 sso 스마트 신한인지 확인
        if ([schName isEqualToString:@"smartshinhan://"])
        {
            //로그인 안되어잇을 경우 로그인 화면으로 보낸다.
//            SHBCardSSOAgreeContentsViewController *viewController = [[[SHBCardSSOAgreeContentsViewController alloc] initWithNibName:@"SHBCardSSOAgreeContentsViewController" bundle:nil] autorelease];
//            viewController.needsLogin= YES;
//            [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] checkLoginBeforePushViewController:viewController animated:NO];
            
            /* 서비스 open 중지상태로 주석처리
            SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
            [checking requestCheckWithController:@"SHBCardSSOAgreeContentsViewController"];
            [checking release];
             */
            
            [self callSchemeUrl:schName]; //예전처럼 일반처리
        }else
        {
            // scheme URL 호출
            [self callSchemeUrl:schName];
        }
            
		
	}
	
}

- (void) requestOpenURL:(NSString *)strUrl SSO:(BOOL)ssoFlag{
    NSLog(@"push step 19:%@, %i",strUrl, ssoFlag);
	if (ssoFlag)
    {
        ssoType = 1; //web
        webSSOUrl = @"";
        webSSOUrl = [strUrl copy];
        
        if (AppInfo.isLogin == LoginTypeIDPW || AppInfo.isLogin == LoginTypeNo)
        {
            AppInfo.webSSOUrl = nil;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"공인인증서 로그인이 필요한 메뉴입니다.\n공인인증서 로그인을 하시겠습니까?"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"예", @"아니오",nil];
            alert.tag = 1999996;
            [alert show];
            [alert release];
        } else
        {
            //공인인증서 로그인 상태일경우
            [self ssoWebSessionSync];
        }
		
	}else
    {
        //NSLog(@"strUrl:%@",strUrl);
        //strUrl = [strUrl stringByReplacingOccurrencesOfString:@"iphonesbank" withString:@"iphoneSbank"];
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
	}
}

- (void)callSchemeUrl:(NSString*)schUrl{
    //NSLog(@"push step 20");
	NSString *storeUrl = [[_appArray objectAtIndex:0] objectForKey:@"다운로드URL"];
	NSString *schName  = [[_appArray objectAtIndex:0] objectForKey:@"패키지_스키마"];
	
	// scheme URL 호출
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:schName]]) {
		if ([_requestParm length] > 0 && _requestParm != nil){
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",schUrl,_requestParm]]];
		}else{
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:schUrl]];
		}
	} else {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:storeUrl]];
	}
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alert.tag == 444 && buttonIndex == 0)
    { // "확인" 버튼
	} else if (alert.tag == 1999996 && buttonIndex == 0)
    {
        [AppInfo loadCertificates];
        if (AppInfo.certificateCount < 1)
        {
            SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }
        
		if (AppInfo.certificateCount == 1){
            
            AppInfo.isWebSSOLogin = YES;
            AppInfo.webSSOUrl = webSSOUrl;
			// 인증서 로그인.
			if (AppInfo.certProcessType != CertProcessTypeInFotterLogin){
				AppInfo.certProcessType = CertProcessTypeLogin;
			}
			
			UIViewController *certController = [[[NSClassFromString(@"SHBCertDetailViewController") class] alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
			[AppDelegate.navigationController pushFadeViewController:certController];
			[certController release];
			
		} else
        {
            
            //지정된 공인인증서가 있다면...
            if ([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificateSelected && AppInfo.selectedCertificate != nil)
            {
                // 인증서 로그인.
                if (AppInfo.certProcessType != CertProcessTypeInFotterLogin)
                {
                    AppInfo.certProcessType = CertProcessTypeLogin;
                }
                
                AppInfo.isWebSSOLogin = YES;
                AppInfo.webSSOUrl = webSSOUrl;
                
                SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                viewController.whereAreYouFrom = FromLogin;
                [AppDelegate.navigationController pushFadeViewController:viewController];
                [viewController release];
                
            } else
            {
                AppInfo.isWebSSOLogin = YES;
                AppInfo.webSSOUrl = webSSOUrl;
                SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                
                // 인증서 목록 로그인.
                if (AppInfo.certProcessType == CertProcessTypeInFotterLogin) {
                    
                    viewController.isSignupProcess = YES;
                    
                } else
                {
                    AppInfo.certProcessType = CertProcessTypeLogin;
                }
                
                viewController.whereAreYouFrom = FromLogin;
                [AppDelegate.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
		}
    } else if (alert.tag == 775 && buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id357484932?mt=8"]];
        exit(1);
    } else if (alert.tag == 775 && buttonIndex == 1)
    {
        [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
    }
	
}


#pragma mark - Class List Initialize
- (void)classListInitialize{
    //NSLog(@"push step 21");
	//Debug(@"화면 매핑용 배열 생성 !!!");
	
	_classArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccountMenuListViewController",@"D0011",@"계좌조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
//	{
//		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccountListViewController",@"D2011",@"즉시이체/예금입금",@"title",@"2",@"login",nil];
//		[_classArray addObject:nDic];
//	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBTransferInfoInputViewController",@"D2011",@"즉시이체/예금입금",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBTransferResultListViewController",@"D4110",@"이체결과 조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAutoTransferAgreeViewController",@"D2201",@"자동이체등록",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAutoTransferInqueryViewController",@"D2221",@"자동이체조회/변경/취소",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAutoTransferResultInqueryViewController",@"D2214",@"자동이체결과조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBFreqAccountViewController",@"C2210",@"자주쓰는예금계좌",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccountNickNameListViewController",@"C2350",@"예금별별명관리",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBFreqTransferListViewController",@"S_002",@"스피드이체체관리",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
    
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccountOrderChangeViewController",@"S_001",@"계좌리스트변경",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBReservationTransferInfoInputViewController",@"D2103",@"예약이체등록",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBReservRegListViewController",@"D2110",@"예약이체조회/취소",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBReservationTransferResultListViewController",@"D2113",@"예약이체결과조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCelebrationTransferInfoInputViewController",@"D2023",@"경조금이체",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNewProductListViewController",@"D3622",@"상품목록",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    
    
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNewProductListViewController",@"D5010",@"상품상세화면",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCloseProductInfoViewController",@"D3281",@"예금/적금해지",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBUDreamInfoViewController",@"C2315",@"U드림저축예금전환",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBLoanInfoViewController",@"L1311",@"예적금담보대출",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBELD_BA17_1ViewController",@"D3276",@"ELD 상품목록",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBELD_BA17_3ViewController",@"D3276_1",@"ELD 상품안내",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBFundAccountListViewController",@"D6010",@"펀드계좌조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBLoanAccountListViewController",@"L0010",@"대출조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBLoanAccountListViewController",@"L1211",@"이자납입",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCardUseInputViewController",@"E2911",@"이용내역조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCardMonthDateInputViewController",@"E2913",@"월별청구금액조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCardSchedulePaymentListViewController",@"E2914",@"결제예정금액조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCardAcknowledgmentInputViewController",@"E2905",@"승인내역조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCardPaymentInputViewController",@"E2904",@"결제내역조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCardTrafficInputViewController",@"E2906",@"교통카드내역조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCardPointListViewController",@"E2907",@"포인트조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCardLimitInfoViewController",@"E2901",@"이용한도조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBGiroTaxInputViewController",@"G0111",@"지로조회납부",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBGiroTaxInputNoViewController",@"G0121",@"지로입력납부",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBGiroTaxPaymentListViewController",@"G0151",@"납부내역조회/취소",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBDistricTaxMenuViewController",@"G0312",@"지방세납부",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBDistricTaxPaymentMenuViewController",@"G0321",@"지방세납부내역조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBExRateListViewController",@"F3730",@"환율조회",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBForexGoldListViewController",@"F0010",@"외화골드예금조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBForexRequestInfoViewController",@"F3780",@"외화환전신청",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBForexRequestListViewController",@"F3120",@"환전신청내역조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBForexFavoritInfoViewController",@"F2035",@"자주쓰는해외송금/조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBRetirementReserveListViewController",@"E3946",@"퇴직연금적립금조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBProductStateListViewController",@"E3715",@"운용상품현황조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBSurchargeListViewController",@"E3725",@"가입자분담금입금",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBRetirementReceipListViewController",@"E3710",@"퇴직연금입금내역조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBRetirementCallCenterViewController",@"R_001",@"퇴직연금콜센터",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBESNotiListViewController",@"E3925",@"Email,SMS통지/정보변경",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBFindBranchesMapViewController",@"E4310",@"영업점/ATM찾기",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBFindBranchesLocationViewController",@"E4307",@"대기고객조회",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBFindBranchesLocationViewController",@"E4305",@"영업점/ATM검색",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBUrgencyInputInfoViewController",@"C2090",@"ATM긴급출금등록",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBUrgencyInputAccountViewController",@"E1702",@"ATM긴급출금조회/취소",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBUserInfoViewController",@"S_004",@"이용안내",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCallCenterListViewController",@"S_005",@"전화상담문의",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCheckInputViewController",@"D5220",@"수표조회",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccidentBankBookInfoViewController",@"E4131",@"통장/인감사고신고",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccidentCardInfoViewController",@"E4141",@"현금/IC카드사고신고",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccidentSecCardInfoViewController",@"E4112",@"보안카드사고신고",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccidentOTPInfoViewController",@"E4122",@"OTP카드사고신고",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccidentSelfCheckInputViewController",@"E4161",@"자기앞수표사고신고",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccidentAncestryCheckInputViewController",@"E4151",@"가계수표사고신고",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccidentSearchBankBookViewController",@"E4130",@"통장/인감사고신고조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccidentSearchCardViewController",@"E4140",@"현금/IC카드사고신고조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccidentSearchSecCardViewController",@"E4111",@"보안카드사고신고조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBAccidentSearchOTPViewController",@"E4121",@"OTP카드사고신고조회",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCheckInputViewController",@"PE-5",@"수표사고신고조회",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBUserInfoEditSIDViewController",@"C2310",@"고객정보변경",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBUserPWRegViewController",@"S_006",@"이용자비밀번호등록",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBOTPReplaceInputViewController",@"S_007",@"OTP시간보정",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCloseServiceViewController",@"S_008",@"서비스해지",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNoticeMenuViewController",@"SM_00",@"로그인알림",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
    
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNoticeMenuViewController",@"SM_01",@"스마트레터",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNoticeMenuViewController",@"SM_02",@"쿠폰함",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNoticeMenuViewController",@"SM_03",@"새소식",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNoticeMenuViewController",@"SM_04",@"이벤트",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNoticeMenuViewController",@"SM_05",@"FAQ",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		//NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBSmartCareViewController",@"SM_06",@"스마트 케어 매니저",@"title",@"2",@"login",nil];
        NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNoticeMenuViewController",@"SM_06",@"스마트 케어 매니저",@"title",@"2",@"login",nil];
        [_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNoticeMenuViewController",@"SM_07",@"스마트명함",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNoticeMenuViewController",@"SM_08",@"스마트신규",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBTransferInfoInputViewController",@"D2012",@"즉시이체/예금입금",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCertIssueStep1ViewController",@"KA-0",@"인증서발급/재발급",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCertMovePhoneViewController",@"KB-1",@"PC->스마트폰인증서복사",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCertCopyQRViewController",@"KD-1",@"인증서간편복사",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCertManageViewController",@"TA-1",@"스마트폰->PC인증서복사",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCertRenewStep1ViewController",@"KF-1",@"인증서갱신",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBSpotCertIssueStep1ViewController",@"KA-1",@"인증서 창구 발급/재발급",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCertExpireStep1ViewController",@"KG-1",@"인증서폐기",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCertManageViewController",@"KI-1",@"인증서관리",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBCertIssueViewController",@"KJ-1",@"인증서안내",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBDeviceRegistServiceViewController",@"MJ-1",@"이용기기 사전등록 서비스",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBOldSecurityViewController",@"OLD-PC",@"구 이용PC 사전등록 변경",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBOldSecurityChangeViewController",@"OLD-CON",@"구 사기예방서비스 변경",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBSmithingGuideViewController",@"SMS01",@"안심거래 서비스",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBExceptionDeviceViewController",@"EXC01",@"예외 기기 로그인 알림",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBFishingDefenceSettingViewController",@"E4124",@"피싱방지 보안설정",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBTransferLimitViewController",@"C2141",@"이체한도감액",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBSecurityCenterMenu2MainViewController",@"S_003",@"전자금융사기예방서비스",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBLoanMyLimitInputViewController",@"L3660",@"예상 대출 한도 조회",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBSimpleLoanInfoViewController",@"L3211",@"약정업체 간편대출",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBSShieldGuideViewController",@"E7010",@"S-Shield",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBEasyCloseInfoViewController",@"E2670",@"신한e-간편해지",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBClosedProductStep_1ViewController",@"D4380",@"예금적금해지현황조회",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    
	{
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBSmartNewListViewController",@"D3249",@"스마트신규",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBGitfInfoViewController",@"E1730",@"모바일 상품권 구매",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBGiftCancelInfoViewController",@"E1740",@"모바일상품권 구매취소",@"title",@"2",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBVersionViewController",@"S_009",@"버젼확인",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBWallPaperViewController",@"S_010",@"배경화면설정",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBLoginSettingViewController",@"S_011",@"로그인설정",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBMenuOrderViewController",@"S_012",@"메뉴순서설정",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBEasyInquiryViewController",@"S_013",@"간편조회설정",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}

    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNotificationSettingViewController",@"S_014",@"알림설정",@"title",@"1",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBSearchPopupSettingViewController",@"S_015",@"검색팝업설정",@"title",@"0",@"login",nil];
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNewProductEventInfoViewController",@"OLLEH_01",@"이벤트",@"title",@"2",@"login",nil];  // 올레 이벤트페이지
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBNewProductCouponViewController",@"OLLEH_02",@"이벤트",@"title",@"2",@"login",nil];   // 올레쿠폰등록
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBExRateRequestViewController",@"F3730_01",@"환율조회상세",@"title",@"0",@"login",nil];   // 환율조회 상세
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBSmartTransferAddInputViewController",@"E5082",@"스마트이체 조회/등록/변경",@"title",@"2",@"login",nil];   // 스마트이체 조회/등록/변경
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBDepositInfoInputViewController",@"D2031",@"즉시이체/예금입금",@"title",@"2",@"login",nil];   // 즉시이체/예금입금 예금 1단계
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBLoanBizNoVisitViewController",@"L3668",@"직장인 무방문 신용대출",@"title",@"0",@"login",nil];   // 직장인 최적상품(무방문대출) 신청
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBLoanBizNoVisitApplyListViewController",@"L3223",@"직장인 무방문 신용대출",@"title",@"2",@"login",nil];   // 신청 조회 및 실행
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBLoanBizNoVisitListViewController",@"LOAN_LIST",@"직장인 무방문 신용대출",@"title",@"0",@"login",nil];   // 직장인신용대출상품 목록
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBLoanInterestRateReductionViewController",@"LOAN_RATE",@"직장인 무방문 신용대출",@"title",@"0",@"login",nil];   // 금리인하 요구권 안내
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBProductMenualListViewController",@"PROD_MENUAL",@"약관 ∙ 상품설명서 보기",@"title",@"1",@"login",nil];   // 약관 ∙ 상품설명서 보기
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBUserInfoUseSupplyViewController",@"D1410",@"본인정보 이용제공 조회시스템",@"title",@"2",@"login",nil];   // 본인정보 이용제공 조회시스템
		[_classArray addObject:nDic];
	}
    
    {
		NSDictionary *nDic = [NSDictionary dictionaryWithObjectsAndKeys:@"SHBTaxQRCodeLocalTaxPaymentViewController",@"QR_LOCALTAX",@"QR코드 납부",@"title",@"2",@"login",nil];   // QR코드 납부 - 지방세
		[_classArray addObject:nDic];
	}
    
}

-(void) loadCertificates
{
    //[SVProgressHUD show];
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	char *nowp = NULL;
	char *p = NULL;
	char line[2048] = {0x00,};
	
	char *certlist = NULL;
	int i = 0;
	int cnt = 0;
	
	
	IXL_Init();
	//	IXL_LogInit("log","IXL",0);
	//ssoCertserialNum;
    //ssoCertIssuer;
    //ssoCertDN;
    //ssoCertSubjectDN;
    NSLog(@"ssoCertserialNum:%@",ssoCertserialNum);
    NSLog(@"ssoCertIssuer:%@",ssoCertIssuer);
    NSLog(@"ssoCertDN:%@",ssoCertDN);
    NSLog(@"ssoCertSubjectDN:%@",ssoCertSubjectDN);
	/******************************************************************************
     // filter string 사용예)
     // SerialNumber=12345|IssuerDN=yessign
     // SubjectDN=HKD
     // HexaSerial=010A23
     // 한글이 포함된 경우 euckr 로 인코딩 된 문자열이어야 함.
     ******************************************************************************/
	//	cnt = IXL_GetAllCertHeader(11,NULL,NULL, &certlist);
    
    
    //cnt = IXL_GetAllCertHeaderFilter(11,NULL,NULL,NULL, &certlist);
    cnt = IXL_GetAllKeychainCertHeaderFilterforCaAndOID(NULL,"a1|a4|b1|b4|c1|c7|ca|d1|d4|e1|e4|f3",&certlist);
    
    
	//ssoCertserialNum = [NSString stringWithFormat:@"HexaSerial=%@",ssoCertserialNum];
    //ssoCertSubjectDN = [NSString stringWithFormat:@"SubjectDN=%@",@"정상교_테스트()008801320120924488000008"];
    //cnt = IXL_GetAllCertHeaderFilter(11,ssoCertserialNum,NULL,[NSString stringWithCString:ssoCertSubjectDN encoding:NSEUCKRSt ringEncoding], &certlist);
	
    //NSLog(@"certlist = %s\n", certlist);
	/*
	 //	cnt = IXL_CountCerts(11,NULL, NULL);
	 cnt = IXL_CountCerts(0,NULL, "/Users/dh999/Work/INISAFE_XSafe_for_C/1.x/trunk/sample");
	 */
	
	NSLog(@"Cert Count = %d \n", cnt);
	nowp = certlist;
	for(i=0; i < cnt ;i++){
		
		
		p = strstr(nowp, "|");
		if(p){
			memset(line, 0x00, sizeof(line));
			memcpy(line, nowp, p - nowp);
			nowp = p + 1;
		}
		else {
			break;
		}
		CertificateInfo *ci = [[[CertificateInfo alloc] init] autorelease];
		[ci initWithParsing:line];
		
		[array addObject:ci];
	}
    
	//NSLog(@"list assign oK!!!");
    [self searchCert:array];
}
- (void) searchCert:(NSMutableArray *)certArray
{
    
    BOOL isFind = NO;
    //     NSString *msg;
    for (int i = 0; i < [certArray count]; i++)
    {
        CertificateInfo *certi = [certArray objectAtIndex:i];
        
        //인증서 상세정보 가져오기
        unsigned char *cert = NULL;
        int certlen = 0;
        
        unsigned char *priv_str = NULL;
        int priv_len = 0;
        
        unsigned char *certDetailStr = NULL;
        int certDetailStrlen = 0;
        
        // get cert and key
        //int ret = IXL_GetCertPkey([AppInfo.selectedCertificate index], &cert, &certlen, &priv_str, &priv_len);
        int ret = IXL_GetCertPkey([certi index], &cert, &certlen, &priv_str, &priv_len);
        if(0 != ret){
            // error
        }
        
        ret = IXL_Make_CertDetail(cert, certlen, &certDetailStr, &certDetailStrlen);
        if(0 != ret){
            
        }
        
        ret = [self DetailInfoWithParsing:certDetailStr length:certDetailStrlen];
        if(0 != ret)
        {
            isFind = YES;
            AppInfo.selectedCertificate = certi;
            AppInfo.loginCertificate = AppInfo.selectedCertificate;
            AppInfo.certificateCount = [certArray count];
            
        }
        
    }
    
    if (!isFind)
    {
        [AppInfo logout];
        NSString *msg = [NSString stringWithFormat:@"로그인에 필요한 인증서\n정보를 찾을 수 없습니다.\n%@",ssoCertDN];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        [AppDelegate.navigationController fadePopToRootViewController];
        
    } else
    {
        [AppDelegate.navigationController fadePopToRootViewController];
    }
    
}

- (int) DetailInfoWithParsing:(unsigned char *)line length:(int)strlen
{
    
	// 받은 정보를 파싱해서 각 변수에 보존
	NSString *tempCertString = [NSString stringWithCString:line encoding:NSUTF8StringEncoding];
    
	NSArray *tempArray1 = nil;
	NSArray *tempArray2 = nil;
	NSString *tempString = nil;
	unsigned char* pEncoding = NULL;
	int nEncodinglen = 0;
	int nRet = 0;
	
	
	tempArray1 = [tempCertString componentsSeparatedByString:@"&"];
	
	//NSLog(@" CertDetailInfo : %@", tempArray1);
	BOOL isFindSerial, isFindSDN;
    isFindSerial = NO;
    isFindSDN = NO;
	for (int index = 0; ([tempArray1 count]-1)>index; index++) {
        
        
		pEncoding = NULL;
		
		tempString = [tempArray1 objectAtIndex:index];
		tempArray2 = [tempString componentsSeparatedByString:@"^"];
		
        //		NSString *tempTitle = [tempArray2 objectAtIndex:0];
		
		char *buf = (char*)[[tempArray2 objectAtIndex:1] UTF8String];
		nRet = IXL_DataDecode(ENCODE_URL_OR_BASE64,
							  (unsigned char*)buf,
							  [[tempArray2 objectAtIndex:1] length],
							  &pEncoding,&nEncodinglen);
		
		NSString *tempContents = [NSString stringWithCString:pEncoding
                                                    encoding:NSEUCKRStringEncoding];
		
		
        //NSLog(@"temp contents:%@",[tempArray2 objectAtIndex:0]);
        
        if( [@"serial" isEqual:[tempArray2 objectAtIndex:0]])
        {
            
            //NSArray *tempArray3 = [tempContents componentsSeparatedByString:@"0x"];
            //tempContents = [tempArray3 objectAtIndex:1];
            tempContents = [tempContents stringByReplacingOccurrencesOfString:@" " withString:@""];
            tempContents = [tempContents stringByReplacingOccurrencesOfString:@")" withString:@""];
            tempContents = [tempContents stringByReplacingOccurrencesOfString:@"(" withString:@""];
            //if ([ssoCertserialNum isEqualToString:tempContents])
            if ([SHBUtility isFindString:tempContents find:ssoCertserialNum])
            {
                isFindSerial = YES;
            }
        }
        
        if( [@"subjectDN" isEqual:[tempArray2 objectAtIndex:0]])
		{
			
            NSLog(@"subjectDN:%@",tempContents);
            //if ([[tempContents uppercaseString] isEqualToString:[ssoCertDN uppercaseString]])
            if ([[tempContents uppercaseString] isEqualToString:[ssoCertDN uppercaseString]])
            {
                NSLog(@"find");
                //return 1;
                isFindSDN = YES;
            }
		}
        
        //        if( [@"issuerDN" isEqual:[tempArray2 objectAtIndex:0]])
        //        {
        //
        //            NSLog(@"issuerDN:%@",tempContents);
        //        }
	}
    if (isFindSDN || isFindSerial)
    {
        return 1;
    }
	return 0;
}

- (void)requestInsertPhoneInfo
{
	// 사용자 Device 정보 등록
	
	NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	NSString *carrierName;
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
		// Setup the Network Info and create a CTCarrier object
		CTTelephonyNetworkInfo *networkInfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
		CTCarrier *carrier = [networkInfo subscriberCellularProvider];
		
		// Get carrier name
		if ([carrier carrierName] != nil){
			carrierName = [carrier carrierName];
		}else {
			carrierName = @"";
		}
	}else {
		carrierName = @"";
	}
	
	if ([carrierName isEqualToString:@"AT&T"]){
		carrierName = @"AT_T";
	}
	[AppInfo getDeviceInfo];
	Debug(@"openUDID : %@",AppInfo.openUDID);
	Debug(@"macAddress :%@",AppInfo.macAddress);
	
	SHBPushInfo *push = [SHBPushInfo instance];
	Debug(@"단말기 디바이스 토큰:%@",push.deviceToken);
	Debug(@"단말기 운영체제:%@",[[UIDevice currentDevice] systemVersion]);

#if !TARGET_IPHONE_SIMULATOR
    NSString *phoneInfo = [NSString stringWithFormat:@"%@%@",PROTOCOL_HTTPS,AppInfo.serverIP];
    NSString *phoneDetailInfo = [SHBUtilFile getResultSum:phoneInfo portNumber:443 connected:TRUE accessGroup:@"HQ59H9US6W.com.ktb.KeychainSuite"];
    //NSString *ktbMacAddress = [SHBUtilFile getWiFiMACAddress:YES];
    NSString *ktbMacAddress = [SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"];
    NSLog(@"getUUID1:%@",[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"]);
    NSLog(@"getUUID2:%@",[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"]);
    NSLog(@"단말기통합정보:%@",phoneDetailInfo);
#endif

    SHBDataSet *forwardData;
 
    //SBANK_MAC1값으로 getPhoneUUID2, SBANK_UID1 값으로 getPhoneUUID1 를 넣어준다.
#if !TARGET_IPHONE_SIMULATOR
    if ([push.deviceToken length] == 0)
    {
        forwardData = [[[SHBDataSet alloc] initWithDictionary:
                        @{
                                               TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                             TASK_ACTION_KEY : @"phoneInfoInsert",
                        //@"SBANK_SVC_CODE" : @"A0010",
                        @"SBANK_SVC_CODE" : @"A1000",
                        @"SBANK_CUSNO" : AppInfo.customerNo,
                        @"SBANK_PHONE_ETC1" : @"",
                        //@"SBANK_RRNO" : AppInfo.ssn,
                        //@"SBANK_RRNO" : [AppInfo getPersonalPK],
                        @"SBANK_RRNO" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                        @"SBANK_SBANKVER" : [NSString stringWithFormat:@"02 %@",versionNumber],
                        //@"SBANK_PHONE_OS" : [[UIDevice currentDevice] systemVersion],
                        @"SBANK_PHONE_OS" : [SHBUtilFile getOSVersion],
                        @"SBANK_PHONE_NO" : @"", //AppInfo.phoneNumber,
                        //@"SBANK_PHONE_COM" : carrierName,
                        @"SBANK_PHONE_COM" : [SHBUtilFile getTelecomCarrierName],
                        //@"SBANK_PHONE_MODEL" : [[UIDevice currentDevice] model],
                        @"SBANK_PHONE_MODEL" :[SHBUtilFile getModel],
                        //@"SBANK_UID1" : AppInfo.openUDID,
                        @"SBANK_UID1" : [SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                        //@"SBANK_MAC1" : AppInfo.macAddress,
                        @"SBANK_MAC1" : ktbMacAddress,
                        @"SBANK_TOKEN" : @"",
                        @"OS_TYPE" : @"I",
                        @"SBANK_PHONE_INFO" : phoneDetailInfo,
                        }] autorelease];
    }else
    {
        forwardData = [[[SHBDataSet alloc] initWithDictionary:
                        @{
                                               TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                             TASK_ACTION_KEY : @"phoneInfoInsert",
                        //@"SBANK_SVC_CODE" : @"A0010",
                        @"SBANK_SVC_CODE" : @"A1000",
                        @"SBANK_CUSNO" : AppInfo.customerNo,
                        @"SBANK_PHONE_ETC1" : @"",
                        //@"SBANK_RRNO" : AppInfo.ssn,
                        //@"SBANK_RRNO" : [AppInfo getPersonalPK],
                        @"SBANK_RRNO" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                        @"SBANK_SBANKVER" : [NSString stringWithFormat:@"02 %@",versionNumber],
                        //@"SBANK_PHONE_OS" : [[UIDevice currentDevice] systemVersion],
                        @"SBANK_PHONE_OS" : [SHBUtilFile getOSVersion],
                        @"SBANK_PHONE_NO" : @"", //AppInfo.phoneNumber,
                        //@"SBANK_PHONE_COM" : carrierName,
                        @"SBANK_PHONE_COM" : [SHBUtilFile getTelecomCarrierName],
                        //@"SBANK_PHONE_MODEL" : [[UIDevice currentDevice] model],
                        @"SBANK_PHONE_MODEL" :[SHBUtilFile getModel],
                        //@"SBANK_UID1" : AppInfo.openUDID,
                        @"SBANK_UID1" : [SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                        //@"SBANK_MAC1" : AppInfo.macAddress,
                        @"SBANK_MAC1" : ktbMacAddress,
                        @"SBANK_TOKEN" : push.deviceToken,
                        @"OS_TYPE" : @"I",
                        @"SBANK_PHONE_INFO" : phoneDetailInfo,
                        }] autorelease];
    }
#else
    forwardData = [[[SHBDataSet alloc] initWithDictionary:
                    @{
                                           TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                         TASK_ACTION_KEY : @"phoneInfoInsert",
                    //@"SBANK_SVC_CODE" : @"A0010",
                    @"SBANK_SVC_CODE" : @"A1000",
                    @"SBANK_CUSNO" : AppInfo.customerNo,
                    @"SBANK_PHONE_ETC1" : @"",
                    //@"SBANK_RRNO" : AppInfo.ssn,
                    //@"SBANK_RRNO" : [AppInfo getPersonalPK],
                    @"SBANK_RRNO" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                    @"SBANK_SBANKVER" : [NSString stringWithFormat:@"02 %@",versionNumber],
                    //@"SBANK_PHONE_OS" : [[UIDevice currentDevice] systemVersion],
                    @"SBANK_PHONE_OS" : [SHBUtilFile getOSVersion],
                    @"SBANK_PHONE_NO" : @"", //AppInfo.phoneNumber,
                    //@"SBANK_PHONE_COM" : carrierName,
                    @"SBANK_PHONE_COM" : [SHBUtilFile getTelecomCarrierName],
                    //@"SBANK_PHONE_MODEL" : [[UIDevice currentDevice] model],
                    @"SBANK_PHONE_MODEL" :[SHBUtilFile getModel],
                    @"SBANK_UID1" : AppInfo.openUDID,
                    @"SBANK_MAC1" : AppInfo.macAddress,
                    @"SBANK_TOKEN" : push.deviceToken,
                    @"OS_TYPE" : @"I",
                    //@"SBANK_PHONE_INFO" : phoneDetailInfo,
                    }] autorelease];
#endif

    // release 처리
    
	SHBVersionService *insertPhoneInfo = [[[SHBVersionService alloc] initWithServiceId:PHONE_INFO viewController:nil] autorelease];
	insertPhoneInfo.previousData = forwardData;
    
    AppInfo.serviceCode = @"앱정보전송";
	[insertPhoneInfo start];
    
}
- (void)groupSSOSearch
{
    
    AppInfo.serviceCode = @"A1000";
    NSString *tocken;
    if ([self.deviceToken length] == 0)
    {
        tocken = @"";
    }else
    {
        tocken = self.deviceToken;
    }
    isgrSSO = YES;
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"deviceId" : [AppDelegate getSSODeviceID],
                                @"appStatus" : @"SEARCH",
                                @"syncResult" : @"1",
                                @"ticket" : _dataDic[@"grssoTicket"],
                                @"GROUP_CODE" : @"S012",
                                @"APP_VERSION" :AppInfo.bundleVersion,
                                @"OS_TYPE" : @"I",
                                @"MACADDRESS1" :[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                @"MACADDRESS2" :[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                @"SBANK_SVC_CODE" : AppInfo.serviceCode,
                                @"SBANK_CUSNO" : @"",
                                @"SBANK_RRNO" :@"",
                                @"SBANK_SBANKVER":[NSString stringWithFormat:@"02 %@",AppInfo.bundleVersion],
                                //@"SBANK_PHONE_OS" : [[UIDevice currentDevice] systemVersion],
                                @"SBANK_PHONE_OS" : [SHBUtilFile getOSVersion],
                                @"SBANK_PHONE_NO" :@"",
                                @"SBANK_PHONE_COM" :[SHBUtilFile getTelecomCarrierName],
                                //@"SBANK_PHONE_MODEL" :[[UIDevice currentDevice] model],
                                @"SBANK_PHONE_MODEL" :[SHBUtilFile getModel],
                                @"SBANK_UID1" :[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                @"SBANK_MAC1" :[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                @"SBANK_PHONE_ETC1" : @"",
                                @"SBANK_TOKEN" : tocken,
                                @"SBANK_PHONE_INFO" : [SHBUtilFile getResultSum:[NSString stringWithFormat:@"%@%@",PROTOCOL_HTTPS,AppInfo.serverIP] portNumber:443 connected:TRUE accessGroup:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                }] autorelease];
    
    
    
    SendData(SHBTRTypeRequst, @"Request", TASK_CARDSSO_URL, self, forwardData);
    
}
@end
