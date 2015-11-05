//
//  SHBLoginViewController.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 17..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBLoginViewController.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "SHBCertManageViewController.h"
#import "SHBCertDetailViewController.h"
#import "SHBCertCenterViewController.h"
#import "SHBSignupViewController.h"
#import "SHBUserPWRegInputViewController.h"
#import "SHBQryServiceViewController.h"
#import "SHBVersionService.h"
#import "SHBPushInfo.h"
#import "SHBNoCertForCertLogInViewController.h"
#import "SHBCheckingViewController.h"
#import "Encryption.h"
#import "SHBOldSecurityViewController.h"
#import "SHBOldSecurityChangeViewController.h"
#import "SHBIdentity4ViewController.h"

//2014.3.5 이용자비밀번호 등록
#import "SHBUserPWRegViewController.h"

#define ENC_PW_PREFIX @"<E2K_CHAR="
#define ENC_PW_SUFFIX @">"

#define TAG_PUSH_ALERT 8999997

@interface SHBLoginViewController ()
{
    int textFieldTag;
    int remineCount;
    int processStep;
    NSString *accountType;
    NSString *accountClass;
    NSString *accountOldPC;
    NSString *accountOldSecurity;
    int startCnt;
}
@end

@implementation SHBLoginViewController

@synthesize encriptedPassword;
@synthesize idTextField;
@synthesize pwTextField;
@synthesize idLoginButton;

- (void)dealloc
{
    [idLoginButton release];
    [encriptedPassword release], encriptedPassword = nil;
    [idTextField release], idTextField = nil;
    [pwTextField release], pwTextField = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loginClose" object:nil];
    [super dealloc];
}

- (void)setLabelText{
	//_descLabel1.text = @"이용자 ID/비밀번호로 로그인 하시는 고객님은 조회성\n거래업무만 가능합니다.";
	//_descLabel2.text = @"인터넷뱅킹 ID가 없으신 고객님은 회원가입\n(홈페이지회원)을 통해 계좌조회 서비스를\n이용하실 수 있습니다.";
	//_descLabel3.text = @"영업점에서 등록한 이용자 ID에 대한 이용자비밀번호를\n등록하시고자 하는 고객님은 환경설정 ➛이용자비밀번호\n등록을 이용하시기 바랍니다.";
	//_descLabel4.text = @"이용자 ID/비밀번호를 분실하신 고객님은 신한은행\n홈페이지를 통해 조회하여 주시기 바랍니다.";
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//    {
//        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, 24, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height + 20)];
//    }

    AppInfo.indexQuickMenu = 0;
	[self setTitle:@"로그인"];
    self.strBackButtonTitle = @"로그인";
	startTextFieldTag = 10;
    endTextFieldTag = 11;
    
    remineCount = 5;
    processStep = 0;
	// ScrollView Setting
	//[_infoView setFrame:CGRectMake(0, 0, self.contentScrollView.frame.size.width, _infoView.frame.size.height)];
	//[_descView setFrame:CGRectMake(0, _infoView.frame.origin.y+_infoView.frame.size.height, self.contentScrollView.frame.size.width, _descView.frame.size.height)];
	//[self.contentScrollView addSubview:_infoView];
	//[self.contentScrollView addSubview:_descView];
	[self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.frame.size.width, _infoView.frame.size.height+_descView.frame.size.height)];
	contentViewHeight = _infoView.frame.size.height+_descView.frame.size.height;
    
	//[self setLabelText];
	
	[self.idTextField setAccDelegate:self];
	
	[AppInfo loadCertificates];
	
    // 테스트 계정.
    //self.idTextField.text = @"jskbankqqq";
    self.idTextField.text = @"";
    // 보안키패드 띄우기.
    [self.pwTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:16];
    
//    if (AppInfo.certProcessType != CertProcessTypeInFotterLogin)
//    {
//        AppInfo.certProcessType = CertProcessTypeNo;
//    }
    AppInfo.isLoginView = YES;
}

- (void)clearData{
	[AppInfo logout];
	
	self.pwTextField.text = @"";
	SafeRelease(encriptedPassword);
}
- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	AppInfo.isLoginView = YES;
    
    AppInfo.isNfilterPK = NO;
    
	if (self.needClearData){
		NSArray *viewArray = [self.navigationController viewControllers];
		NSLog(@"Array View : %@",viewArray);
		[self clearData];
	}
}


- (void)viewDidUnload
{
    
    [super viewDidUnload];
    AppInfo.isLoginView = NO;
    self.idTextField.text = @"";
    self.pwTextField.text = @"";
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    AppInfo.isLoginView = NO;
    self.idTextField.text = @"";
    self.pwTextField.text = @"";
    startCnt = 0;
}

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 
 // xcode 4.5 미만 ios5 이하
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 //NSLog(@"shouldAutorotateToInterfaceOrientation");
 if (AppInfo.isSecurityKeyPad) {
 
 return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
 } else {
 
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 
 return NO;
 }
 */

#pragma mark - 퍼블릭 메서드
//- (void)scrollMainView:(float)posY{
//	//animation set
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:0.3];
//	[UIView setAnimationDelegate:_scrollView];
//
//	//scroll set
//	[_scrollView setFrame:CGRectMake(0, 44 + posY, _scrollView.frame.size.width, _scrollView.frame.size.height)];
//
//	//animation run
//	[UIView commitAnimations];
//
//}
//- (IBAction) closeNormalPad:(id)sender
//{
//    [self.idTextField resignFirstResponder];
//}

- (IBAction)login:(id)sender
{
    // !!!: 전송할 데이터(전문)를 생성하는 방법은 두 가지 이다.
    // NSMutableDictionary 또는 NSDictionary 타입을 사용 하는 것이다.
    // NSDictionary를 사용할 경우에는 NSDictionay Literals를 사용하라!
    // 그리고 특별한 목적이 없다면, 데이터 전송 시 SEND_DATA(서비스코드, 델리게이트(항상 self), 데이터)를 사용하라.
    
    /*
     // NSMutableDictionary를 사용하는 경우.
     NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     [dict setValue:self.idTextField.text forKey:@"아이디"];
     [dict setValue:self.encriptedPassword forKey:@"비밀번호"];
     */
    
    //    // NSDictionary를 사용하는 경우.
    //    NSDictionary *dict = @{
    //        @"아이디" : self.idTextField.text,
    //        @"비밀번호" : self.encriptedPassword,
    //    };
    //
    //    // 메서드를 사용하는 경우.
    //    [HTTPClient sendData:SHBTRTypeServiceCode serviceCode:SC_H1001 path:IDPW_LOGIN_URL obj:self data:dict];
    //
    //    // 매크로를 사용하는 경우.
    //    SendData(SHBTRTypeServiceCode, SC_H1001, IDPW_LOGIN_URL, self, dict);
    
	// Condition Check
    
    //버젼정보를 가져왔는지 확인후 로그인을 시도한다.
    if (AppInfo.isGetVersionInfo == 0)
    {
        startCnt++;
        if (startCnt <= 20)
        {
            NSLog(@"버젼정보 가져오기 대기");
            //10초를 기다린다.
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(login:) userInfo:nil repeats:NO];
            
            return;
        }
        
        
    }else if (AppInfo.isGetVersionInfo == -1)
    {
        processStep = 3;
        AppInfo.isGetVersionInfo = 1; //성공으로 가정한다.
        //통신 실패인 경우 다시한번 시도한다
        SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                    @{
                                                           TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                                         TASK_ACTION_KEY : @"doStart",
                                    @"서비스구분" : SERVICE_TYPE,
                                    @"채널구분코드" : CHANNEL_CODE,
                                    @"Client버젼" : AppInfo.bundleVersion ,
                                    }] autorelease];
        
        // release 추가
        self.service = nil;
        self.service = [[[SHBVersionService alloc] initWithServiceId:VERSION_INFO2 viewController:self] autorelease];
        self.service.previousData = forwardData;
        [self.service start];
        return;
    }
    
    NSString *msg;
	if(self.idTextField.text == nil || [self.idTextField.text isEqualToString:@""] || [self.idTextField.text length] < 4)
	{
        msg = @"이용자아이디는 영문,숫자,대소문자 구분없이 4~16자 이내입니다.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
		return;
	}
    if(self.pwTextField.text == nil || [self.pwTextField.text isEqualToString:@""] || [self.pwTextField.text length] < 6)
	{
        msg = @"이용자 비밀번호는 영문,숫자의 조합으로 6~16자 이내입니다.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
		return;
	}
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(idloginError) name:@"notiServerError" object:nil];
    
    
    self.idLoginButton.enabled = NO;
	processStep = 1;
    AppInfo.isStartApp = NO;
    AppInfo.serviceCode = @"H1001";
    
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
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                            @{
                            @"deviceId" : [AppDelegate getSSODeviceID],
                            @"아이디" : [self.idTextField.text uppercaseString],
                            @"비밀번호" : self.encriptedPassword,
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
    aDataSet.serviceCode = @"H1001";
    
    [self serviceRequest: aDataSet];
}

- (IBAction)goCertManage:(id)sender
{
    AppInfo.isLoginView = NO;
    [self.idTextField resignFirstResponder];
    //[AppInfo loadCertificates];
    //if (AppInfo.certificateCount <= 0)
    if (AppInfo.validCertCount <= 0)
    {
        SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
        return;
    }
    
    
    //if (AppInfo.certificateCount == 1)
    if (AppInfo.validCertCount == 1)
    {
        // 인증서 로그인.
        if (AppInfo.certProcessType != CertProcessTypeInFotterLogin)
        {
            AppInfo.certProcessType = CertProcessTypeLogin;
        }
        
        SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
        viewController.whereAreYouFrom = FromLogin;
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
        
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
            
            SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
            viewController.whereAreYouFrom = FromLogin;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            
        } else
        {
            SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
            
            // 인증서 목록 로그인.
            if (AppInfo.certProcessType == CertProcessTypeInFotterLogin) {
                
                viewController.isSignupProcess = YES;
                
            } else
            {
                AppInfo.certProcessType = CertProcessTypeLogin;
            }
            
            viewController.whereAreYouFrom = FromLogin;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
        
    }
    
}

- (IBAction)goCertCenter:(id)sende
{
    SHBCertCenterViewController *viewController = [[SHBCertCenterViewController alloc] initWithNibName:@"SHBCertCenterViewController" bundle:nil];
    viewController.needsLogin = NO;
    [self checkLoginBeforePushViewController:viewController animated:YES];
    [viewController release];
}

- (IBAction)joinMember:(id)sender
{
    
    //2014.08.07 주민번호 입력 금지로 인해 알럿 보여준 후 아무 처리하지 않음
    
    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"인근 영업점을 방문하시어\n신한 온라인서비스 신청 후\n이용하시기 바랍니다."];
    /*
    AppInfo.certProcessType = CertProcessTypeNo;
	SHBSignupViewController *viewController = [[SHBSignupViewController alloc] initWithNibName:@"SHBSignupViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
	[viewController release];
     */
}

- (void) idloginError
{
    self.pwTextField.text = @"";
    self.idLoginButton.enabled = YES;
}
#pragma mark - 텍스트 필드 델리게이트

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"login textFieldDidBeginEditing");
    

    [super textFieldDidBeginEditing:(SHBTextField *)textField];
    
    
    textFieldTag = textField.tag;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginClose) name:@"loginClose" object:nil];
	if (textField == self.idTextField){
		
        
		//self.contentScrollView.scrollEnabled = NO;
        //[super performSelector:@selector(delyScroll) withObject:nil afterDelay:1];
	}
    
}

//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//	[self scrollMainView:0];
//
//	[idTextField focusSetWithLoss:NO];
//	[idTextField resignFirstResponder];
//
//	return YES;
//}
//
//
//#pragma mark - Delegate : SHBTextFieldDelegate
//- (void)didNextButtonTouch{
//	[idTextField focusSetWithLoss:NO];
//	[idTextField resignFirstResponder];
//	[pwTextField becomeFirstResponder];
//};		// 다음버튼
//- (void)didCompleteButtonTouch{
//
//    //[super didCompleteButtonTouch];
//	//[idTextField focusSetWithLoss:NO];
//	//[idTextField resignFirstResponder];
//
//	//[self scrollMainView:0];
//
//};	// 완료버튼


- (void)requestInsertPhoneInfo{
	// 사용자 Device 정보 등록
	isRequestInsPush = NO;
	
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
	Debug(@"AppInfo.customerNo : [%@]",AppInfo.customerNo);
	Debug(@"AppInfo.ssn : [%@]",[AppInfo getPersonalPK]);
	Debug(@"AppInfo.phoneNumber : [%@]",AppInfo.phoneNumber);
	Debug(@"AppInfo.openUDID : [%@]",AppInfo.openUDID);
	Debug(@"AppInfo.macAddress : [%@]",AppInfo.macAddress);
	Debug(@"push.deviceToken : [%@]",push.deviceToken);
	Debug(@"carrierName : [%@]",carrierName);
	
    #if !TARGET_IPHONE_SIMULATOR
    NSString *phoneInfo = [NSString stringWithFormat:@"%@%@",PROTOCOL_HTTPS,AppInfo.serverIP];
    NSString *phoneDetailInfo = [SHBUtilFile getResultSum:phoneInfo portNumber:443 connected:TRUE accessGroup:@"HQ59H9US6W.com.ktb.KeychainSuite"];
    NSString *ktbMacAddress = [SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"];
    
    NSLog(@"getUUID1:%@",[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"]);
    NSLog(@"getUUID2:%@",[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"]);
    NSLog(@"단말기통합정보:%@",phoneDetailInfo);
    #endif
    //SBANK_MAC1값으로 getPhoneUUID2, SBANK_UID1 값으로 getPhoneUUID1 를 넣어준다.
    #if !TARGET_IPHONE_SIMULATOR
    SHBDataSet *forwardData;
    if ([push.deviceToken length] == 0)
    {
        forwardData = [[[SHBDataSet alloc] initWithDictionary:
                        @{
                                               TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                             TASK_ACTION_KEY : @"phoneInfoInsert",
                        @"SBANK_SVC_CODE" : @"H1001",
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
                        @"SBANK_SVC_CODE" : @"H1001",
                        @"SBANK_CUSNO" : AppInfo.customerNo,
                        @"SBANK_PHONE_ETC1" : @"",
                        //@"SBANK_RRNO" : AppInfo.ssn,
                        //@"SBANK_RRNO" : [AppInfo getPersonalPK],
                        @"SBANK_RRNO" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                        @"SBANK_SBANKVER" : [NSString stringWithFormat:@"02 %@",versionNumber],
                        //@"SBANK_PHONE_OS" : [[UIDevice currentDevice] systemVersion],
                        @"SBANK_PHONE_OS" : [SHBUtilFile getOSVersion],
                        @"SBANK_PHONE_NO" : @"",//AppInfo.phoneNumber,
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
    /*
     SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
     @{
     TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
     TASK_ACTION_KEY : @"phoneInfoInsert",
     @"SBANK_SVC_CODE" : @"H1001",
     @"SBANK_CUSNO" : AppInfo.customerNo,
     @"SBANK_PHONE_ETC1" : @"",
     @"SBANK_RRNO" : AppInfo.ssn,
     @"SBANK_SBANKVER" : [NSString stringWithFormat:@"02 %@",versionNumber],
     @"SBANK_PHONE_OS" : [[UIDevice currentDevice] systemVersion],
     @"SBANK_PHONE_NO" : AppInfo.phoneNumber,
     @"SBANK_PHONE_COM" : carrierName,
     @"SBANK_PHONE_MODEL" : [[UIDevice currentDevice] model],
     @"SBANK_UID1" : AppInfo.openUDID,
     //@"SBANK_MAC1" : AppInfo.macAddress,
     @"SBANK_MAC1" : ktbMacAddress,                              
     @"SBANK_TOKEN" : push.deviceToken,
     @"OS_TYPE" : @"I",
     @"SBANK_PHONE_INFO" : phoneDetailInfo,
     }] autorelease];
     */
     #else
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                                       TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                                     TASK_ACTION_KEY : @"phoneInfoInsert",
                                @"SBANK_SVC_CODE" : @"H1001",
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

	//self.service = [[SHBVersionService alloc] initWithServiceId:VERSION_INFO viewController:self];
    
    self.service = nil;
	self.service = [[[SHBVersionService alloc] initWithServiceId:PHONE_INFO viewController:self] autorelease];
	self.service.previousData = forwardData;
	
    AppInfo.serviceCode = @"앱정보전송";
   
	[self.service start];
    
}

#pragma mark - SHBNetworkHandlerDelegate 메서드

- (void)client: (OFHTTPClient *) aClient didReceiveDataSet:(SHBDataSet *)aDataSet{
	Debug(@"로그인 후 푸쉬알림 서비스 인증 결과값 client: %@",aDataSet);
    if (processStep == 1)
    {
        self.idLoginButton.enabled = YES;
        if (AppInfo.errorType != nil)
        {
            remineCount--;
            self.pwTextField.text = @""; //초기화
            
            if (remineCount  < 1) //5회 이상 틀린경우 메인으로 간다.
            {
                [self.navigationController fadePopToRootViewController];
            }
        }
        //NSLog(@"receiveData:dataSet: %@", aDataSet);
        //NSLog(@"receiveData:dataSet: %@", [aDataSet objectForKey:@"고객번호"]);
        
        // TODO: 사용자 정보의 범위와 저장 방식에 대해 결정할 것!
        // 사용자 정보 저장.
        /*
        if ([[aDataSet objectForKey:@"스마트뱅킹가입상태"] isEqualToString:@"1"]){
            AppInfo.isSignupService = YES;
        } else
        {
            AppInfo.isSignupService = NO;
            AppInfo.phoneNumber = [aDataSet objectForKey:@"전화번호"];
            self.pwTextField.text = @"";
            SHBBaseViewController *signViewController = [[[NSClassFromString(@"SHBSignupServiceStep1ViewController") class] alloc] initWithNibName:@"SHBSignupServiceStep1ViewController" bundle:nil];
            [self.navigationController pushFadeViewController:signViewController];
            [signViewController release];
            return;
        }
        */
        //하단의 알림버튼 교체
        if ([[aDataSet objectForKey:@"NEW_LETTER"] isEqualToString:@"Y"] || [[aDataSet objectForKey:@"NEW_COUPON"] isEqualToString:@"Y"])
        {
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeBottmNotice:2];
        }
        Encryption *encryptor = [[Encryption alloc] init];
        AppInfo.isSSOLogin = NO;
        AppInfo.userInfo = [NSMutableDictionary dictionaryWithDictionary:aDataSet];
        //AppInfo.customerNo = [aDataSet objectForKey:@"고객번호"];
        if ([[aDataSet objectForKey:@"고객번호"] length] == 9)
        {
            AppInfo.customerNo = [NSString stringWithFormat:@"0%@",[aDataSet objectForKey:@"고객번호"]];
        }else
        {
            AppInfo.customerNo = [aDataSet objectForKey:@"고객번호"];
        }

        //AppInfo.ssn = [aDataSet objectForKey:@"주민등록번호"];
        AppInfo.ssn = [encryptor aes128Encrypt:[aDataSet objectForKey:@"주민등록번호"]];
        AppInfo.phoneNumber = [aDataSet objectForKey:@"전화번호"];
        AppInfo.loginID = idTextField.text;
        
        
        accountType = [aDataSet objectForKey:@"회원구분"];
        accountClass = [aDataSet objectForKey:@"고객회원등급"];
        accountOldSecurity = [aDataSet objectForKey:@"사기예방동의여부"];
        accountOldPC = [aDataSet objectForKey:@"구PC등록동의여부"];

        
        // 로그인 정보 저장.
        AppInfo.isLogin = LoginTypeIDPW;
        AppInfo.ssnForIDPWD = [aDataSet objectForKey:@"주민등록번호"];
        
        [encryptor release];
        
        AppInfo.isCheatDefanceAgree = YES;
        AppInfo.isOldPCRegister = YES;
        
        
        // 하단의 퀵메뉴에 로그인,아웃 버튼 교체
		//[[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeQuickLogin:YES];
        if (AppInfo.isSettingServiceView)
        {
            for (int i = 0; i < [[AppDelegate.navigationController viewControllers] count]; i++)
            {
                //NSLog(@"aaa:%@",NSStringFromClass([[[AppDelegate.navigationController viewControllers] objectAtIndex:i] class]));
                [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeQuickLogin:YES];
                //하단의 알림버튼 교체
                if (([[aDataSet objectForKey:@"NEW_LETTER"] isEqualToString:@"Y"] || [[aDataSet objectForKey:@"NEW_COUPON"] isEqualToString:@"Y"]) && AppInfo.noticeState != 1)
                {
                    AppInfo.noticeState = 2;
                    [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeBottmNotice:2];
                }
            }
            AppInfo.isSettingServiceView = NO;
        }
        else
        {
            if (![[aDataSet objectForKey:@"회원구분"] isEqualToString:@"9"])
            {
                [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeQuickLogin:YES];
            }
            
            if (([[aDataSet objectForKey:@"NEW_LETTER"] isEqualToString:@"Y"] || [[aDataSet objectForKey:@"NEW_COUPON"] isEqualToString:@"Y"]) && AppInfo.noticeState != 1)
            {
                AppInfo.noticeState = 2;
                [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeBottmNotice:2];
            }
            
        }
        
        if ([[aDataSet objectForKey:@"회원구분"] isEqualToString:@"9"])
         {
            
            //NSString *msg = @"이용자 비밀번호가 등록되어 있지 않습니다. 환경 설정에서 이용자 비밀번호를 등록 후 이용하여 주시기 바랍니다.";
            //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg];
            //return;
            
             
             //		// 이용자 비밀번호 등록 필요   ===== 2014. 3.5 수정 주민번호 입력으로
            /*
             SHBUserPWRegInputViewController *regPwViewController = [[SHBUserPWRegInputViewController alloc] initWithNibName:@"SHBUserPWRegInputViewController" bundle:nil];
            regPwViewController.data = aDataSet;
            regPwViewController.strServiceCode = @"H1001";
            [AppDelegate.navigationController pushFadeViewController:regPwViewController];
            [regPwViewController release];
             */
             
             AppInfo.certProcessType = CertProcessTypeNo;
             SHBUserPWRegViewController *regPwViewController = [[SHBUserPWRegViewController alloc] initWithNibName:@"SHBUserPWRegViewController" bundle:nil];
             
             [AppDelegate.navigationController pushFadeViewController:regPwViewController];
             [regPwViewController release];

            
        }
         else if ([[aDataSet objectForKey:@"고객회원등급"] isEqualToString:@"3"])
        {
            //NSLog(@"aaaa:%@",[aDataSet objectForKey:@"고객회원등급"]);
            
            // 외국인인 경우 알럿처리
            if ([aDataSet[@"주민등록번호"] length] == 13) {
                NSString *forType = [aDataSet[@"주민등록번호"] substringWithRange:NSMakeRange(6, 1)];
                
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
            
            
            [AppInfo logout];
            
            NSString *customerNo = aDataSet[@"COM_CIF_NO"];
            
            if ([customerNo length] < 10) {
                
                customerNo = [NSString stringWithFormat:@"0%@", customerNo];
            }
            
            AppInfo.commonDic = @{ //@"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? aDataSet[@"주민등록번호"] : @"",
                                   @"실명번호" :aDataSet[@"주민등록번호"],
                                   @"고객명" : aDataSet[@"고객성명"],
                                   //@"아이디" : AppInfo.loginID };
                                   @"아이디" : aDataSet[@"아이디"],
                                   @"고객번호" : customerNo };
            
            
            
            SHBQryServiceViewController *qryViewController = [[SHBQryServiceViewController alloc] initWithNibName:@"SHBQryServiceViewController" bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:qryViewController];
            [qryViewController release];
            
        }else if ([aDataSet[@"블랙리스트차단구분"] isEqualToString:@"4"])
        {
            
            if (AppInfo.lastViewController != nil)
            {
                AppInfo.lastViewController = nil;
            }
            SHBIdentity4ViewController *viewController = [[SHBIdentity4ViewController alloc]initWithNibName:@"SHBIdentity4ViewController" bundle:nil];
            [viewController setServiceSeq:SERVICE_IP_CHECK];
            viewController.needsLogin = YES;
            //viewController.delegate = self;
            [self checkLoginBeforePushViewController:viewController animated:YES];
            
            //Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
            [viewController executeWithTitle:@"본인 확인절차 강화 서비스" Step:0 StepCnt:0 NextControllerName:@""];
            //[viewController subTitle:@"안심거래 서비스 본인 확인 절차 강화"];
            //viewController.subTitleLabel.text = @"안심거래 서비스 본인 확인 절차 강화";
            [viewController release];
            return;
        }
        //* 전자금융 사기예방을 위해 통지 신청 불가 (해지는 가능) 14.03.17
        /*
        else if ([[aDataSet objectForKey:@"사기예방동의여부"] isEqualToString:@"0"] ){
           
            AppInfo.isCheatDefanceAgree = NO;
            if (AppInfo.isLogin == LoginTypeIDPW )
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"구 서비스(구 사기예방서비스 또는 구 이용PC사전등록 서비스) 변경동의 대상 고객입니다. 변경동의를 위해서 공인인증서 로그인이 필요합니다. 공인인증서 로그인을 하시겠습니까?"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"예", @"아니오",nil];
                alert.tag = 1999997;
                [alert show];
                [alert release];
                return;
            }
            

            //구 사기예방서비스 변경동의
            SHBOldSecurityChangeViewController *regPwViewController = [[SHBOldSecurityChangeViewController alloc] initWithNibName:@"SHBOldSecurityChangeViewController" bundle:nil];

            [AppDelegate.navigationController pushFadeViewController:regPwViewController];
            [regPwViewController release];
           

            
        } 
        */
       else if ([[aDataSet objectForKey:@"구PC등록동의여부"] isEqualToString:@"0"])
       {
           AppInfo.isOldPCRegister = NO;
           if (AppInfo.isLogin == LoginTypeIDPW )
           {
               
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                               message:@"구 서비스(구 사기예방서비스 또는 구 이용PC사전등록 서비스) 변경동의 대상 고객입니다. 변경동의를 위해서 공인인증서 로그인이 필요합니다. 공인인증서 로그인을 하시겠습니까?"
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"예", @"아니오",nil];
               alert.tag = 1999997;
               [alert show];
               [alert release];
               return;
           }
           
            
           SHBOldSecurityViewController *regPwViewController = [[SHBOldSecurityViewController alloc] initWithNibName:@"SHBOldSecurityViewController" bundle:nil];
           
        [AppDelegate.navigationController pushFadeViewController:regPwViewController];
           [regPwViewController release];
        }
        
        
        else{
#if TARGET_IPHONE_SIMULATOR
			// 로그인 화면 종료 후 다음단계 진행
			[self.navigationController fadePopViewController];
			
			// 프로세스 중간에 들어간 로그인일 경우 다음 뷰컨트롤를 푸시하고 아니면 닫는다.
			if (!AppInfo.isSingleLogin)
            {
                if (AppInfo.lastViewControllerNeedCert)
                {
                    [AppDelegate.navigationController fadePopToRootViewController];
                } else
                {
                    [AppDelegate.navigationController pushFadeViewController:AppInfo.lastViewController];
                }
				
				//[(SHBBaseViewController*)AppInfo.lastViewController helloCustomer];
			}else{
				//[[[AppDelegate.navigationController viewControllers] objectAtIndex:0] helloCustomer];
			}
#else
			if ([[NSUserDefaults standardUserDefaults]pushFlag] == PUSH_IS_FIRST){
				// 알림 수신여부 알럿
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:@"신한S뱅크를 이용해 주셔서 감사합니다. 편리한 서비스 정보를 제공하는 알림 메시지를 수신하시겠습니까?\n\n(환경설정→알림설정에서 변경 가능)\n\n단, 입출내역 알림은 신한Smail 설치 후\n이용가능"
															   delegate:self
													  cancelButtonTitle:nil
													  otherButtonTitles:@"예", @"아니오",nil];
				alert.tag = TAG_PUSH_ALERT;
				[alert show];
				[alert release];
				
			}else{
				// 핸드폰정보 서버 등록
				//[self requestInsertPhoneInfo];
                
                // 로그인 화면 종료 후 다음단계 진행
                [self loginSuccess];
			}
#endif
			
        }
        
    }
	
}

- (void)loginSuccess
{
    // 로그인 화면 종료 후 다음단계 진행
    [self.navigationController fadePopViewController];
    
    if (AppInfo.isEasyInquiry && [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBAccountInqueryViewController"]) {
        SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
        [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
    }else
    {
        // 프로세스 중간에 들어간 로그인일 경우 다음 뷰컨트롤를 푸시하고 아니면 닫는다.
        if (!AppInfo.isSingleLogin){
            
            if (AppInfo.lastViewControllerNeedCert)
            {
                AppInfo.lastViewController = nil;
                [AppDelegate.navigationController fadePopToRootViewController];
                
            } else
            {
                
                if (AppInfo.lastViewController != nil)
                {
                    if (((SHBBaseViewController*)AppInfo.lastViewController).needsCert == NO)
                    {
                        
                        [AppDelegate.navigationController pushFadeViewController:AppInfo.lastViewController];
                        AppInfo.lastViewController = nil;
                    }else
                    {
                        AppInfo.lastViewController = nil;
                        [AppDelegate.navigationController fadePopToRootViewController];
                    }
                }
                
                
            }
            
            //[AppDelegate.navigationController pushFadeViewController:AppInfo.lastViewController];
            //[(SHBBaseViewController*)AppInfo.lastViewController helloCustomer];
        }else{
            //[[[AppDelegate.navigationController viewControllers] objectAtIndex:0] helloCustomer];
            //알림메뉴쪽 ID/PWD 로그인 진입시 처리
            AppInfo.isSingleLogin = NO;
            if ([NSClassFromString(LOGIN_CLASS) class] != [AppInfo.lastViewController class])
            {
                
                if (AppInfo.lastViewController != nil)
                {
                    if (((SHBBaseViewController*)AppInfo.lastViewController).needsCert == NO)
                    {
                        [AppDelegate.navigationController pushSlideUpViewController:AppInfo.lastViewController];
                        AppInfo.lastViewController = nil;
                    }else
                    {
                        AppInfo.lastViewController = nil;
                        [AppDelegate.navigationController fadePopToRootViewController];
                    }
                }
                
                
            }else
            {
                AppInfo.lastViewController = nil;
            }
            
        }
    }
}

- (BOOL) onParse:(OFDataSet *)aDataSet string:(NSData *)aContent{
    
    if (processStep == 3)
    {
        [self login:nil];
    }else
    {
#if !TARGET_IPHONE_SIMULATOR
        // 로그인 화면 종료 후 다음단계 진행
        [self loginSuccess];
//        if (isRequestInsPush){
//            // 휴대폰정보 서버등록
//            [self requestInsertPhoneInfo];
//        }else{
//            
//            // 로그인 화면 종료 후 다음단계 진행
//            [self.navigationController fadePopViewController];
//            
//            if (AppInfo.isEasyInquiry && [NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBAccountInqueryViewController"]) {
//                SHBCheckingViewController *checking = [[[SHBCheckingViewController alloc] initWithNibName:@"SHBCheckingViewController" bundle:nil] autorelease];
//                [checking requestCheckWithController:NSStringFromClass([AppInfo.lastViewController class])];
//            }else
//            {
//                // 프로세스 중간에 들어간 로그인일 경우 다음 뷰컨트롤를 푸시하고 아니면 닫는다.
//                if (!AppInfo.isSingleLogin){
//                    
//                    if (AppInfo.lastViewControllerNeedCert)
//                    {
//                        [AppDelegate.navigationController fadePopToRootViewController];
//                    } else
//                    {
//                        [AppDelegate.navigationController pushFadeViewController:AppInfo.lastViewController];
//                    }
//                    
//                    //[AppDelegate.navigationController pushFadeViewController:AppInfo.lastViewController];
//                    //[(SHBBaseViewController*)AppInfo.lastViewController helloCustomer];
//                }else{
//                    //[[[AppDelegate.navigationController viewControllers] objectAtIndex:0] helloCustomer];
//                }
//            }
//            
//        }
#endif
    }

    return NO;
}

#pragma mark - SHBSecureDelegate
- (void)secureTextFieldDidBeginEditing:(SHBSecureTextField *)textField
{
    
    
    [super secureTextFieldDidBeginEditing:textField];
    textFieldTag = textField.tag;
    super.curTextField = textField;
	
	
}

- (IBAction)closeNormalPad:(id)sender
{
    //SHBSecureTextField *tmp = sender;
    //NSLog(@"closeNormalPad");
    [super closeNormalPad:sender];
    
    [self.pwTextField becomeFirstResponder];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    BOOL shouldReturn = YES;
    
    if (textField == self.idTextField)
    {
        //int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
        int stringLength = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
        //NSLog(@"dataLength:%i",dataLength);
        //NSLog(@"stringLength:%i",stringLength);
        
        //한글은 입력 못한다.
        if (stringLength > 1)
        {
            return NO;
        }
        
        //특수문자 : ₩ $ £ ¥ • 은 입력 안됨
		NSString *SPECIAL_CHAR = @"\\$₩€£¥•%#<>[]^{|}\"";
		
		NSCharacterSet *cs;
		cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (basicTest && [string length] > 0 )
        {
			return NO;
		}
        
		//16자 못 넘는다.
        if ([self.idTextField.text length] > 15)
        {
            if ([string length] == 0)
            {
                return shouldReturn;
            } else
            {
                return NO;
            }
            
        }
        
    }
    
    return shouldReturn;
}

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    
    
    //[self.contentScrollView setContentOffset:CGPointZero animated:YES];
    
    // !!!: 암호화된 비밀번호를 다시 포맷팅 하므로, 주의 할 것!
	SafeRelease(encriptedPassword);
    encriptedPassword = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX]];
	
	//[self scrollMainView:0];
    //[self login:nil];
}

//- (void)didGetToMaxmum
//{
//    // 필요하면 구현...
//}

- (void) loginClose
{
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.frame.size.width, _infoView.frame.size.height+_descView.frame.size.height)];
	contentViewHeight = _infoView.frame.size.height+_descView.frame.size.height;
    
    [self.contentScrollView scrollsToTop];
}

#pragma mark - UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[super alertView:alertView clickedButtonAtIndex:buttonIndex];
	
	if (alertView.tag == TAG_PUSH_ALERT)
    {
		isRequestInsPush = YES;
		if (buttonIndex == 0) {
			[[NSUserDefaults standardUserDefaults]setPushFlag:PUSH_IS_USE];
			// 알림설정 서버에 등록
			SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
										@{
															   TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
															 TASK_ACTION_KEY : @"updateSbankPushToken",
										@"고객번호" : AppInfo.customerNo,
										@"수신여부" : @"Y",
										}] autorelease];
            self.service = nil;
			self.service = [[[SHBVersionService alloc] initWithServiceId:TASK_INS_PUSH viewController:self] autorelease];
			self.service.previousData = forwardData;
            AppInfo.serviceCode = @"타이머블럭";
			[self.service start];
			
		}
        else{
			[[NSUserDefaults standardUserDefaults]setPushFlag:PUSH_NOT_USE];
			// 알림설정 서버에 등록
			SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
										@{
															   TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
															 TASK_ACTION_KEY : @"updateSbankPushToken",
										@"고객번호" : AppInfo.customerNo,
										@"수신여부" : @"N",
										}] autorelease];
            self.service = nil;
			self.service = [[[SHBVersionService alloc] initWithServiceId:TASK_INS_PUSH viewController:self] autorelease];
			self.service.previousData = forwardData;
            AppInfo.serviceCode = @"타이머블럭";
			[self.service start];
			
		}
		
	}
    
    else if (alertView.tag == 1999997)
    {
        //[AppInfo logout];
		
        if (buttonIndex == 0)
        {
            [AppDelegate.navigationController fadePopToRootViewController];
            if (AppInfo.certificateCount < 1)
            {
                SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:viewController];
                [viewController release];
                return;
            }
            
            if (AppInfo.certificateCount == 1)
            {
                
                // 인증서 로그인.
                if (AppInfo.certProcessType != CertProcessTypeInFotterLogin){
                    AppInfo.certProcessType = CertProcessTypeLogin;
                }
                
                UIViewController *certController = [[[NSClassFromString(@"SHBCertDetailViewController") class] alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:certController];
                [certController release];
                
            }
            else
            {
                // 인증서 로그인.
                if (AppInfo.certProcessType != CertProcessTypeInFotterLogin){
                    AppInfo.certProcessType = CertProcessTypeLogin;
                }
                
                UIViewController *certController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
                [AppDelegate.navigationController pushFadeViewController:certController];
                [certController release];
            }
            
        }
        
        else
        {
            [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
        }

    }
    
}



@end
