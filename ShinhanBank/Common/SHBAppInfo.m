//
//  SHBAppInfo.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAppInfo.h"
#import "UIDevice+Hardware.h"
#import "NSURLResponse+Header.h"
#import "OpenUDID.h"
#import "INISAFEXSafe.h"
#import "SHBMainViewController.h"
#import "SHBLoginViewController.h"
#import "Encryption.h"
#import "SHBCertManageViewController.h"
#import "EccEncryptor.h"

@implementation SHBAppInfo

@synthesize LanguageProcessType;
@synthesize isiPhoneFive;
@synthesize nfilterPK;
@synthesize isLogin;
@synthesize certProcessType;
@synthesize selectedCertificate;
@synthesize electronicSignString;
@synthesize certError;
@synthesize userInfo;
@synthesize secretChar1;
@synthesize secretChar2;
@synthesize customerNo;
@synthesize phoneNumber;
@synthesize loginID;
@synthesize loginName;

@synthesize lastViewController;
@synthesize lastViewControllerNeedCert;
@synthesize isFirstOpen;
@synthesize isSingleLogin;
@synthesize isSignupService;
@synthesize versionInfo;
@synthesize bundleVersion;
@synthesize tran_Date;
@synthesize tran_Time;
@synthesize codeList;
@synthesize commonDic;
@synthesize commonLoanDic;
@synthesize serviceOption;
@synthesize eSignNVBarTitle;
@synthesize signedData;
@synthesize certificateCount;
@synthesize bankCodeVersion;
@synthesize isStartApp;
@synthesize schemaUrl;
@synthesize isCardAgree;
@synthesize certPlainPwd;
@synthesize openUDID;
@synthesize macAddress;
@synthesize otherAppArray;
@synthesize serverIP;
@synthesize indexQuickMenu;
//@synthesize isGetKeyNFilter;
@synthesize isSecurityKeyClose;
@synthesize isSmartLetterNew;
@synthesize isCouponNew;
@synthesize electronicSignCode;
@synthesize electronicSignTitle;
@synthesize isSettingServiceView;
@synthesize ssnForIDPWD;
@synthesize isLoginView;
@synthesize Close_type;
@synthesize isNfilterPK;

@synthesize noticeState;
@synthesize smartFundType;
@synthesize isEasyInquiry;
@synthesize isNeedBackWhenError;
@synthesize realServer;
@synthesize isBolckServerErrorDisplay;
@synthesize serverErrorMessage;
@synthesize isWebSSOLogin;
@synthesize webSSOUrl;
@synthesize isForceRotate;
@synthesize beforeRotateDirect;
@synthesize isLandScapeKeyPadBolck;

@synthesize isUserPwdRegister;
@synthesize isSSOLogin;
@synthesize isBackGroundCall;

@synthesize isRegisterAccountService;

@synthesize isCheatDefanceAgree;
@synthesize isOldPCRegister;
@synthesize isGetVersionInfo;
@synthesize isWebSchemeCall;
@synthesize isAllIdenty;
@synthesize isARSIdenty;
@synthesize isSMSIdenty;
@synthesize isAllIdentyDone;
@synthesize transferDic;

@synthesize isTapSmithingMenu;
@synthesize smsInfo;
@synthesize smithingType;
@synthesize scrollBlock;
@synthesize loginCertificate;
@synthesize isSmartCareNoti;
@synthesize dummyStr;
@synthesize liveAlert;
@synthesize isSetPKForMobi;

@synthesize eccData;
@synthesize isFishingDefence;
@synthesize commonNotiOption;
@synthesize accountD0011;
@synthesize ollehCoupon;
@synthesize giftType;
@synthesize isShowSearchView;
@synthesize isD0011Start;
@synthesize validCertCount;
@synthesize arsLimtTime;
@synthesize isHotSpot;

static SHBAppInfo *sharedSHBAppInfo = nil;
int initStep = 0;
int remainCount = 2;

+ (SHBAppInfo *)sharedSHBAppInfo
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedSHBAppInfo = [[self alloc] init];
    });
#else
    @synchronized(self)
    {
        if (sharedSHBAppInfo == nil)
        {
            [[self alloc] init];
        }
    }
#endif
    
    return sharedSHBAppInfo;
}

// 초기화.
- (id)init
{
    self = [super init];
	if (self)
    {
        
      #ifndef DEVELOPER_MODE // !@#$!@#$
        disable_gdb();
      #else
        [[NSUserDefaults standardUserDefaults]settypeOfLoginCert:@"testCert"]; //테스트 서버로 접속
      #endif
        
        //접속 서버를 결정한다.
        NSString *typeofcert = [[NSUserDefaults standardUserDefaults]typeOfLoginCert];
        
        if ([typeofcert isEqualToString:@"testCert"]) //테스트용 인증서(테스트 서버 접속)
        {
            
            self.serverIP = TEST_SERVER_IP;
            self.realServer = NO;
            
        } else if ([typeofcert isEqualToString:@"realCert"]) //실 인증서 제출(운영서버 접속)
        {
            self.serverIP = REAL_SERVER_IP;
            self.realServer = YES;
            
            
        } else //디폴트(운영서버 접속)
        {
            self.serverIP = REAL_SERVER_IP;
            self.realServer = YES;
        }
        
        Debug(@"\n------------------------------------------------------------------\
              \n연결 서버 IP:%@\
              \n------------------------------------------------------------------", self.serverIP);
        // !@#$!@#$
        
        // iPhone5 여부.
        self.isiPhoneFive = IS_IPHONE_5;
        self.ssnForIDPWD = @"";
        // 로거 초기화.
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        self.isWebSchemeCall = NO;
        
        // 자원 업데이트 테스트.
        //[self updateResources]; //추후 구현 필요
        
        // 인증서 관련 초기화.
        self.certProcessType = CertProcessTypeNo;
        self.certError = nil;
        self.electronicSignString =@"";
        self.isGetVersionInfo = 0; //중립상태,
        self.isAllIdenty = NO;
        self.isAllIdentyDone = NO;
        self.codeList = [[[SHBCodeList alloc] init] autorelease];
        
        self.isTapSmithingMenu = NO;
        self.smsInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.accountD0011 = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.loginCertificate = nil;
        self.selectedCertificate = nil;
        self.eccData = nil;
        self.isFishingDefence = NO;
        self.commonNotiOption = -1;
        self.isD0011Start = YES;
        self.arsLimtTime = 60.0;
	}
	
	return self;
}

// 객체 할당(alloc) 시 호출됨.
// 객체 할당과 초기화 시 sharedAppInfo 인스턴스가 nil인지 확인.
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedSHBAppInfo == nil)
        {
            sharedSHBAppInfo = [super allocWithZone:zone];
            return sharedSHBAppInfo;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
	// 릴리즈되어서는 안될 객체 표시(또는 NSUIntegerMax, INT32_MAX 사용).
    return UINT_MAX;
}

- (void)release
{
    // 아무일도 안함.
}

- (id)autorelease
{
    return self;
}

#pragma mark - 퍼블릭 메서드
- (BOOL) getServerType
{
    //접속 서버를 결정한다.
    NSString *typeofcert = [[NSUserDefaults standardUserDefaults]typeOfLoginCert];
    
    if ([typeofcert isEqualToString:@"testCert"]) //테스트용 인증서(테스트 서버 접속)
    {
        
        return NO;
        
    } else if ([typeofcert isEqualToString:@"realCert"]) //실 인증서 제출(운영서버 접속)
    {
        return YES;
        
    }
    return YES;
}
- (void)initProcess
{
    // nFilter 퍼블릭키 로드.
    //[AppDelegate initNFlterTimer]; //pk값 다시 가져오기 타임 생성
    self.ssnForIDPWD = @"";
    self.isNfilterPK = NO;
    //[self loadPublicKeyForNFilter];
    [self loadCertificates];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SettingsLoginTypeKey"] == nil)
    {
        [[NSUserDefaults standardUserDefaults]setLoginTypeForSetting:SettingsLoginTypeNone];
    }
    
}

- (void)finishProcess
{
    
}

// TODO: 통신 방법(Async : Sync) 최종 결정할 것!
- (BOOL)loadPublicKeyForNFilter
{
    
    //@autoreleasepool
    //{
    //[SVProgressHUD show];
    // 스탑와치 시작.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    #ifdef DEVELOPER_MODE
        [LPStopwatch start:@"nFilter 퍼블릭키 로드"];
    #endif
    
    //NSString *nfilterPKURL = [NSString stringWithFormat:@"%@%@%@", PROTOCOL_HTTPS, SERVER_IP, NFILTER_PK_URL];
    NSString *nfilterPKURL = [NSString stringWithFormat:@"%@%@%@", PROTOCOL_HTTPS, self.serverIP, NFILTER_PK_URL];
    //NSLog(@"nfilterPKURL:%@",nfilterPKURL);
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:nfilterPKURL]];
    //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:nfilterPKURL] options:NSDataReadingUncached error:&error];
    //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:nfilterPKURL] options:NSDataReadingMappedIfSafe error:&error];
    //NSDataReadingMappedIfSafe
    // 데이터를 수신하지 못했을 경우...
    if (nil == data)
    {   //[SVProgressHUD show];
        //[self performSelector:@selector(loadPublicKeyForNFilter) withObject:nil afterDelay:1];
        
        
        Debug(@"\n------------------------------------------------------------------\
              \nnfilterPK 값얻기 실패\
              \n------------------------------------------------------------------");
        //isGetKeyNFilter = NO;
        AppInfo.isNfilterPK = NO;
        remainCount--;
        //2번 연결을 시도해보고 안되면 넽워크 여결 에러를 알렺고 앱을 종료한다.
        if (remainCount < 0)
        {
            NSString *msg = @"거래진행이 중단되었습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다. 이체실행중이셨으면 반드시 예금거래내역조회를 통하여 처리결과를 먼저 확인하시기 바랍니다.";
            //msg = [NSString stringWithFormat:@"%@\n[%@]",msg,[error localizedDescription]];
            msg = [NSString stringWithFormat:@"%@",msg];
            //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:@"" message:msg];
            [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:nil buttonTitle:nil message:msg];
            
        }else
        {
            [self performSelector:@selector(loadPublicKeyForNFilter)];
        }
        //[SVProgressHUD dismiss];
        return NO;
    }
    
    error = nil;
    TBXML *tbxml = [[TBXML newTBXMLWithXMLData:data error:&error] autorelease];
    
    if (tbxml.rootXMLElement)
        self.nfilterPK = [TBXML textForElement:tbxml.rootXMLElement->firstChild];
    
    AppInfo.isNfilterPK = YES;
    //isGetKeyNFilter = YES;
    //NSHC로 부터 전달받은 공개키를 설정한다.
    IXL_SetNFilterPublicKey(self.nfilterPK);
    
    remainCount = 2;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    Debug(@"\n------------------------------------------------------------------\
          \nnfilterPK 값:%@\
          \n------------------------------------------------------------------", self.nfilterPK);
    
    //이니텍모듈에 값세팅
//    IXL_nFilterKeyCleanup(); //초기화
//    int nReturn = IXL_SetNFilterPublicKey(self.nfilterPK); //공개키 설정
//    if (nReturn != 0)
//    {
//        
//        [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:0 title:nil buttonTitle:nil message:@"공개키 설정에 실패했습니다."];
//    }
    
    //NSLog(@"nfilterPK 길이:%i",[self.nfilterPK length]);
    // 스탑와치 중지.
    #ifdef DEVELOPER_MODE
    [LPStopwatch stop:@"nFilter 퍼블릭키 로드"];
    #endif
    //[SVProgressHUD dismiss];
    [AppDelegate closeProgressView];
    
    return YES;
    //}
    
    
    /*
    [LPStopwatch start:@"nFilter 퍼블릭키 로드"];
    NSString *nfilterPKURL = [NSString stringWithFormat:@"%@%@%@", PROTOCOL_HTTPS, self.serverIP, NFILTER_PK_URL];
    
    NSURL *theURL = [NSURL URLWithString:nfilterPKURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];
    
    NSString *httpBody = @"";
    [request setHTTPMethod:OFHTTPMethodPOST];   // !!! 보낼때는 EUC-KR, 받을 때는 UTF-8.
    [request setValue:OFMIMETypeFormURLEncoded forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSData dataWithBytes:[httpBody UTF8String] length:[httpBody length]]];
    
    [HTTPClient requestBlockED:request obj:self];
     */
}
- (void) getNFilterPK
{
    //[self performSelectorInBackground:@selector(loadPublicKeyForNFilter) withObject:nil];
}
- (void)updateResources
{
    // 스탑와치 시작.
    #ifdef DEVELOPER_MODE
    [LPStopwatch start:@"리소스 업데이트"];
    #endif
    [OFDownloadManager downloadResource:@"update.bundle.zip" withURL:@"http://localhost:8888"];
    
    // 스탑와치 중지.
    #ifdef DEVELOPER_MODE
    [LPStopwatch stop:@"리소스 업데이트"];
    #endif
}

- (void)logout
{
    // 서버의 세션 삭제.
	initStep = 0;
    //[HTTPClient initTimer];
    // 로그아웃 URL은 리턴이 없다고 한다.
    
    // 로그인 여부 상태값 변경.
    self.isLogin = LoginTypeNo;
    
    self.userInfo = nil;
    self.accountD0011 = nil;
    self.customerNo = nil;
    self.ssn = nil;
    self.phoneNumber = nil;
    self.loginID = nil;
    BOOL isSendLogout = YES;
    if (self.isRegisterAccountService )
    {
        self.isRegisterAccountService = NO;
        isSendLogout = NO;
    }else
    {
        if (AppInfo.certProcessType != CertProcessTypeRenew)
        {
            self.selectedCertificate = nil;
        }
        
    }
    self.loginCertificate = nil;
    //self.certificateCount = 0;
    self.isStartApp = NO;
    self.serviceCode = @"";
    self.ssnForIDPWD = @"";
    self.isSSOLogin = NO;
    self.commonDic = nil;
    self.isFishingDefence = NO;
    self.isAllIdenty = NO;
    self.isAllIdentyDone = NO;
    //[self getNFilterPK];
    // 그외 처리할 것이 있다면 이 곳에(회면 이동 등)...
    [AppDelegate initTimer];
    self.isNfilterPK = NO;
    self.lastViewController = nil;
    self.lastViewControllerNeedCert = NO;
    //설정된 nFilter공개키를 초기화한다.
    self.eccData = nil;
    IXL_nFilterKeyCleanup();
    
    [self.codeList.cardList removeAllObjects];
    [self.codeList.creditCardList removeAllObjects];
    
    //self.codeList = nil;
    //self.codeList = [[[SHBCodeList alloc] init] autorelease];
    
    Debug(@"LogOut");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutClose" object:nil];
    // 하단의 퀵메뉴에 로그인,아웃 버튼 교체
    //[[AppDelegate.navigationController.view viewWithTag:8888] removeFromSuperview];
    
    //    UIWindow *tempWindow;
    //
    //	for (int c=0; c < [[[UIApplication sharedApplication] windows] count]; c++)
    //	{
    //		tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
    //
    //
    //		for (int i = 0; i < [tempWindow.subviews count]; i++)
    //		{
    //            NSLog(@"temp window:%@",NSStringFromClass([[tempWindow.subviews objectAtIndex:i] class]));
    //			//[self _hideKeyboardRecursion:[tempWindow.subviews objectAtIndex:i]];
    //		}
    //	}
    
    //    for (int i = 0; i < [[AppDelegate.navigationController viewControllers] count]; i++)
    //    {
    //        NSLog(@"logout vc:%@",NSStringFromClass([[[AppDelegate.navigationController viewControllers] objectAtIndex:i] class]));
    //    }
    
    if (AppInfo.isSettingServiceView)
    {
        for (int i = 0; i < [[AppDelegate.navigationController viewControllers] count]; i++)
        {
            if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:i] respondsToSelector:@selector(changeQuickLogin:)]) {
                [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeQuickLogin:NO];
            }
            
            if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:i] respondsToSelector:@selector(changeBottmNotice:)]) {
                [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeBottmNotice:0];
            }
            
        }
        AppInfo.isSettingServiceView = NO;
        AppInfo.noticeState = 0;
    } else
    {
        
        if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:0] respondsToSelector:@selector(changeQuickLogin:)]) {
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeQuickLogin:NO];
        }
        
        if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:0] respondsToSelector:@selector(changeBottmNotice:)]) {
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeBottmNotice:0];
        }
        
        AppInfo.noticeState = 0;
    }
    
    if (isSendLogout)
    {
        AppInfo.serviceCode = @"타이머블럭";
        SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                    @{
                                    @"deviceId" : [AppDelegate getSSODeviceID],
                                    }] autorelease];
        SendData(SHBTRTypeServiceCode, @"request", LOGOUT_URL, self, forwardData);
    }
    
	
}

- (void)changeFishingState
{
    for (int i = 0; i < [[AppDelegate.navigationController viewControllers] count]; i++)
    {
        if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:i] respondsToSelector:@selector(resetFishingDefence)]) {
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] resetFishingDefence];
        }
    }
}

- (void)xkfdhrAlert
{
    //[UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:92673 title:nil buttonTitle:@"확인" message:@"탈옥된 단말입니다.\n개인정보 유출의 위험성이 있으므로\n신한S뱅크를 종료합니다."];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"탈옥된 단말입니다.\n개인정보 유출의 위험성이 있으므로\n신한S뱅크를 종료합니다."
                                                   delegate:self
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil];
    alert.tag = 92673; //444,EXIT_ALERT_VIEW_TAG=exit(1); -> 확인버튼 누를 시 종료 시킬려면 444, EXIT_ALERT_VIEW_TAG로 바꾸세요~~
    [alert show];
    [alert release];
}
- (void)client: (OFHTTPClient *) aClient didReceiveData:(NSData *)data
{
    
    // 데이터를 수신하지 못했을 경우...
    if (nil == data)
    {
        
        Debug(@"\n------------------------------------------------------------------\
              \nnfilterPK 값얻기 실패\
              \n------------------------------------------------------------------");
        
        AppInfo.isNfilterPK = NO;
        remainCount--;
        //5초간 연결을 시도해보고 안되면 넽워크 여결 에러를 알렺고 앱을 종료한다.
        if (remainCount < 0)
        {
            NSString *msg = @"거래진행이 중단되었습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다. 이체실행중이셨으면 반드시 예금거래내역조회를 통하여 처리결과를 먼저 확인하시기 바랍니다.";
            
            //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:@"" message:msg];
            [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:nil buttonTitle:nil message:msg];
        }
        
        return;
    }
    
    NSError *error = nil;
    TBXML *tbxml = [[TBXML newTBXMLWithXMLData:data error:&error] autorelease];
    
    if (tbxml.rootXMLElement)
        self.nfilterPK = [TBXML textForElement:tbxml.rootXMLElement->firstChild];
    
    AppInfo.isNfilterPK = YES;
    
    remainCount = 2;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    Debug(@"\n------------------------------------------------------------------\
          \nnfilterPK 값:%@\
          \n------------------------------------------------------------------", self.nfilterPK);
    // 스탑와치 중지.
    #ifdef DEVELOPER_MODE
    [LPStopwatch stop:@"nFilter 퍼블릭키 로드"];
    #endif
}

- (void)client:(OFHTTPClient *)aClient didReceiveDataSet:(SHBDataSet *)aDataSet
{
    //NSLog(@"aaaa:%@",aDataSet);
    if (initStep == 0)
    {
        /*
         //[HTTPClient initTimer];
         // 로그아웃 URL은 리턴이 없다고 한다.
         
         // 로그인 여부 상태값 변경.
         self.isLogin = LoginTypeNo;
         
         self.userInfo = nil;
         self.customerNo = nil;
         self.ssn = nil;
         self.phoneNumber = nil;
         self.loginID = nil;
         self.selectedCertificate = nil;
         self.certificateCount = 0;
         
         //[self getNFilterPK];
         // 그외 처리할 것이 있다면 이 곳에(회면 이동 등)...
         [AppDelegate initTimer];
         //AppInfo.isNfilterPK = NO;
         // 로그아웃시 신한카드 데이터 초기화
         [self.codeList.cardList removeAllObjects];
         self.codeList.cardList = [NSMutableArray array];
         [self.codeList.creditCardList removeAllObjects];
         self.codeList.creditCardList = [NSMutableArray array];
         Debug(@"LogOut");
         // 하단의 퀵메뉴에 로그인,아웃 버튼 교체
         
         if (AppInfo.isSettingServiceView)
         {
         for (int i = 0; i < [[AppDelegate.navigationController viewControllers] count]; i++)
         {
         if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:i] respondsToSelector:@selector(changeQuickLogin:)]) {
         [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeQuickLogin:NO];
         }
         
         if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:i] respondsToSelector:@selector(changeBottmNotice:)]) {
         [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeBottmNotice:0];
         }
         
         }
         AppInfo.isSettingServiceView = NO;
         AppInfo.noticeState = 0;
         } else
         {
         if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:0] respondsToSelector:@selector(changeQuickLogin:)]) {
         [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeQuickLogin:NO];
         }
         
         if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:0] respondsToSelector:@selector(changeBottmNotice:)]) {
         [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeBottmNotice:0];
         }
         
         AppInfo.noticeState = 0;
         }
         */
    }else if (initStep == 1)
    {
        
    }
	
}

- (NSString *) getMainBundleDirectory:(NSString *) fileNmae {
    
    return [[NSBundle mainBundle] pathForResource:fileNmae ofType:nil];
}

- (void) addElectronicSign:(NSString *)str
{
    if (str == nil)
    {
        str = @"";
    }
    self.electronicSignString = [NSString stringWithFormat:@"%@%@\n", self.electronicSignString, str];
}


- (void) getDeviceInfo
{
    //디바이스 정보를 가져온다
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *Device_OpenUDID = [userDefaults objectForKey:@"Device_OpenUDID"];
    
    if (Device_OpenUDID == nil) {	//저장된 디바이스 정보가 없는 경우 최초 실행이라 판단
		//UDID정보 가져오기
		Device_OpenUDID = [OpenUDID value];
		
		if (Device_OpenUDID != nil) {
			[userDefaults setObject:Device_OpenUDID forKey:@"Device_OpenUDID"];
            [userDefaults synchronize];
		}
		
		//NSLog(@"OpenUDID = [%@]",Device_OpenUDID);
		
	}
    if (Device_OpenUDID == nil)
    {
        self.openUDID = @"";
    } else
    {
        self.openUDID = Device_OpenUDID;
    }
    
    if ([SHBUtility getMacAddress:NO] == nil)
    {
        self.macAddress = @"";
        
    } else
    {
        self.macAddress = [SHBUtility getMacAddress:NO];
    }
    //NSLog(@"OpenUDID = [%@]",[SHBUtility getMacAddress:NO]);
    
}

- (NSMutableArray *)loadCertificates
{
    //[SVProgressHUD show];
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	char *nowp = NULL;
	char *p = NULL;
	char line[2048] = {0x00,};
	
	char *certlist = NULL;
	int i = 0;
	int cnt = 0;
	int findIdx = 0;
	
	IXL_Init();
	//	IXL_LogInit("log","IXL",0);
	
	/******************************************************************************
     // filter string 사용예)
     // SerialNumber=12345|IssuerDN=yessign
     // SubjectDN=HKD
     // HexaSerial=010A23
     // 한글이 포함된 경우 euckr 로 인코딩 된 문자열이어야 함.
     ******************************************************************************/
	//	cnt = IXL_GetAllCertHeader(11,NULL,NULL, &certlist);
	//	cnt = IXL_GetAllCertHeaderFilter(11,NULL,NULL,"SubjectDN=HKD", &certlist);
	//cnt = IXL_GetAllCertHeaderFilter(11,@"SerialNumber=000000449947",NULL,NULL, &certlist);
	
    
    //cnt = IXL_GetAllCertHeaderFilter(11,NULL,NULL,NULL, &certlist);
    cnt = IXL_GetAllKeychainCertHeaderFilterforCaAndOID(NULL,"a1|a4|b1|b4|c1|c7|ca|d1|d4|e1|e4|f3",&certlist);
    
    
    //NSLog(@"certlist = %s\n", certlist);
	/*
	 //	cnt = IXL_CountCerts(11,NULL, NULL);
	 cnt = IXL_CountCerts(0,NULL, "/Users/dh999/Work/INISAFE_XSafe_for_C/1.x/trunk/sample");
	 */
	
	NSLog(@"Cert Count = %d \n", cnt);
    self.validCertCount = 0;
    
    
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
		
        if (ci.expired == 0)
        {
            findIdx = i;
            self.validCertCount++;
        }
		[array addObject:ci];
	}
	
    NSLog(@"valid Cert Count = %d \n", self.validCertCount);
    
	/* subject dn get */
	for(i=0; i < cnt ; i++){
		char *subjectdn = NULL;
		IXL_GetsubjectDN(i, &subjectdn);
		//NSLog(@"subjectdn = %s", subjectdn);
		IXL_Free((unsigned char *)subjectdn, 0);
	}
	
	//NSLog(@"list assign oK!!!");
	
	self.certificateCount = [array count];
    
    //인증서가 하나이면 기본 디폴트로 지정한다.
    if ([array count] == 1)
    {
        
        //선택된 인증서를 전역으로 저장한다.
        CertificateInfo *certificate = [array objectAtIndex:0];
        
        AppInfo.selectedCertificate = certificate;
        if (AppInfo.selectedCertificate.expired != 0)
        {
            self.selectedCertificate = nil;
            self.certificateCount = 0;
            self.validCertCount = 0;
        }
        
        
    } else
    {
        if ([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificateSelected) //지정 공인 인증서를 찾는다
        {
            BOOL isFind = NO;
            NSMutableDictionary *settingCertDic = [[NSUserDefaults standardUserDefaults]certificateData];
            
            Debug(@"%@", settingCertDic);
            
            for (int i = 0; i < [array count]; i++)
            {
                CertificateInfo *certificate = [array objectAtIndex:i];
                
                Debug(@"%@", [certificate user]);
                Debug(@"%@", [certificate issuer]);
                Debug(@"%@", [certificate type]);
                
                if ([[certificate user] isEqualToString:[settingCertDic objectForKey:@"1"]] &&
                    [[NSString stringWithFormat:@"발급자 : %@", [certificate issuer]] isEqualToString:[settingCertDic objectForKey:@"2"]] &&
                    [[certificate type] isEqualToString:[settingCertDic objectForKey:@"4"]])
                {
                    isFind = YES;
                    AppInfo.selectedCertificate = certificate;
                    if (AppInfo.selectedCertificate.expired != 0)
                    {
                        AppInfo.selectedCertificate = nil;
                        
                    }
                }
            }
            
            if (!isFind)
            {
                AppInfo.selectedCertificate = nil; //지정된 인증서를 찾을 수 없다.
                
            }
        }else if ([[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
        {
            if (self.validCertCount == 1)
            {
                CertificateInfo *certificate = [array objectAtIndex:findIdx];
                AppInfo.selectedCertificate = certificate;
            }
        }
    }
    //[SVProgressHUD dismiss];
    return array;
}
////세션연장을 위해 그냥 날린다
- (void) reSession
{
    //[self getNFilterPK];
    initStep = 1;
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"codeKey" : @"bank_code_smart",
                                }] autorelease];
    
    SendData(SHBTRTypeServiceCode, @"CODE", CODE_URL, self, forwardData);
}
- (void) logoutAlert
{
    /*
    // 로그아웃
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"신한S뱅크를 로그아웃 하시겠습니까?"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"예", @"아니오",nil];
    alert.tag = 4444999;
    [alert show];
    [alert release];
     */
    [UIAlertView showAlertCustome:self type:ONFAlertTypeTwoButton tag:4444999 title:nil buttonTitle:nil message:@"신한S뱅크를 로그아웃 하시겠습니까?"];
}

- (void) differentUserAlert
{
    NSString *msg = @"로그인한 이용자ID 사용자정보와 다른 공인인증서를 선택하여 로그인 되었습니다. 메인화면으로 이동합니다.";
    //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:456781 title:@"" message:msg];
    [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButton tag:456781 title:nil buttonTitle:nil message:msg];
    
}

- (void) moveLoginAlert
{
    NSString *msg = @"로그인 후, 메인화면으로\n이동합니다.\n로그인 하시겠습니까?";
    //[UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:5555512 title:@"" message:msg];
    [UIAlertView showAlertCustome:self type:ONFAlertTypeTwoButton tag:5555512 title:nil buttonTitle:nil message:msg];
}

- (void) updateAlert:(NSString *)sVer
{
    NSString *msg = [NSString stringWithFormat:@"신한S뱅크 버젼 %@ 이상에서\n실행이 가능합니다.\n업데이트 하시겠습니까?",sVer];
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"업데이트"
                                          otherButtonTitles:@"취소",nil];
    
    alert.tag =779;
    [alert show];
    [alert release];
     */
    [UIAlertView showAlertCustome:self type:ONFAlertTypeTwoButton tag:779 title:nil buttonTitle:@"업데이트,취소" message:msg];
    return;
}
#pragma mark - 얼럿뷰 델리게이트
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == EXIT_ALERT_VIEW_TAG)
    {
        // 앱 종료.
        //exit(-1);
        [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
        
    } else if (alertView.tag == 4444999 && buttonIndex == 0)
    {
        [self logout];
        self.isLogin = LoginTypeNo;
        self.certProcessType = CertProcessTypeNo;
        [AppDelegate.navigationController fadePopToRootViewController];
        
        //} else if (alertView.tag == 4444999)
        //{
        //    [AppDelegate.navigationController fadePopToRootViewController];
    } else if (alertView.tag == 456781)
    {
        AppInfo.ssnForIDPWD = @"";
        [AppDelegate.navigationController fadePopToRootViewController];
        
    } else if (alertView.tag == 5555512 && buttonIndex == 0)
    {
        [AppDelegate.navigationController fadePopToRootViewController];
        
        //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
        if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
        {
            AppInfo.certProcessType = CertProcessTypeLogin;
            //인증서가 한개이면 인증서 상세 화면
            if (AppInfo.validCertCount == 1 && AppInfo.selectedCertificate != nil)
            {
                SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertDetailViewController") class] alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else
            {
                SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
        }else
        {
            SHBLoginViewController *viewController = [[SHBLoginViewController alloc] initWithNibName:@"SHBLoginViewController" bundle:nil];
            
            [AppDelegate.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
        
    } else if (alertView.tag == 779 && buttonIndex == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id357484932?mt=8"]];
        exit(1);
    }else if (alertView.tag == 92673)
    {
        exit(-1);
    }
}

- (NSString *)getPersonalPK
{
    Encryption *fkrjw = [[Encryption alloc] init];
    NSString *dbstjdtlr = [fkrjw aes128Decrypt:AppInfo.ssn];
    [fkrjw release];
    return dbstjdtlr;
}

- (NSString *)sungsikjunsik0402:(NSString *)a1008
{
    Encryption *aslkdas = [[Encryption alloc] init];
    NSString *dbstjdtlr = [aslkdas aes128Encrypt:a1008];
    [aslkdas release];
    return dbstjdtlr;
}

/*
- (NSString *)eunheeya0225:(NSString *)asdf12073
{
    Encryption *adsfh = [[Encryption alloc] init];
    NSString *dbstjdtlr = [adsfh aes128Decrypt:asdf12073];
    [adsfh release];
    return dbstjdtlr;
}
*/
- (void)smithingAlert
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"aaaa:%@",[defaults objectForKey:@"SMSNotiDate"]);
    
    if ([[defaults objectForKey:@"SMSNotiDate"] length] == 0)
    {
        
        SHBSMSAlertPopupView *alertView = [[SHBSMSAlertPopupView alloc] initWithString:@"보다 안전한 거래를 위하여\n안심거래 서비스를\n신청 하시겠습니까?" ButtonCount:2 SubViewHeight:170];
        [alertView showInView:AppDelegate.window animated:YES];
    }else
    {
        if ([[defaults objectForKey:@"SMSNotiType"] isEqualToString:@"1"])
        {
            NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [outputFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *sdate = [outputFormatter dateFromString:[defaults objectForKey:@"SMSNotiDate"]];
            
            NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
            //currentDate = @"2013-12-19";
            NSDate *edate = [outputFormatter dateFromString:currentDate];
            
            NSDateComponents *dcom = [[NSCalendar currentCalendar]components: NSDayCalendarUnit
                                                                    fromDate:sdate toDate:edate options:0];
            
            int dDay = [dcom day] + 1;
            NSLog(@"1111:%i",dDay);
            
            if (dDay >=0 && dDay < 8)
            {
                //아무것도 안함
            }else
            {
                [defaults setObject:@"" forKey:@"SMSNotiType"];
                [defaults synchronize];
                //7일 지났음
                
                SHBSMSAlertPopupView *alertView = [[SHBSMSAlertPopupView alloc] initWithString:@"보다 안전한 거래를 위하여\n안심거래 서비스를\n신청 하시겠습니까?" ButtonCount:2 SubViewHeight:170];
                [alertView showInView:AppDelegate.window animated:YES];
                
            }
        }else
        {
            
            SHBSMSAlertPopupView *alertView = [[SHBSMSAlertPopupView alloc] initWithString:@"보다 안전한 거래를 위하여\n안심거래 서비스를\n신청 하시겠습니까?" ButtonCount:2 SubViewHeight:170];
            [alertView showInView:AppDelegate.window animated:YES];
        }
        
    }

}

- (NSString *)encNfilterData:(NSString *)aStr
{
    if (!self.isNfilterPK)
    {
        if (![self loadPublicKeyForNFilter])
        {
            
            return @"fail";
        }
    }
    
    EccEncryptor *ec = [EccEncryptor sharedInstance];
    [ec setServerPublickey:AppInfo.nfilterPK];
    NSString *encData = [ec makeEncNoPadding:aStr];
    NSLog(@"암호화값: %@", encData);
    return encData;
}

@end