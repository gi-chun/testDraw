//
//  SHBCertDetailViewController.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertDetailViewController.h"
#import "SHBCertMovePCViewController.h"
#import "SHBCertRenewStep2ViewController.h"
#import "SHBCheckingViewController.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "INISAFEXSafe.h"
#import "SHBUtility.h"
#import "SHBLoginViewController.h"
#import "SHBVersionService.h"
#import "SHBPushInfo.h"
#import "SHBCertElectronicSignViewController.h"
#import "MoaSignSDK.h"
#import "Encryption.h"
#import "SHBOldSecurityViewController.h"
#import "SHBOldSecurityChangeViewController.h"
#import "SHBNoCertForCertLogInViewController.h"
#import "SHBIdentity4ViewController.h"

#define TAG_PUSH_ALERT 987654

@interface SHBCertDetailViewController ()
{
    BOOL isAfterAlert;
    int remineCount;
    int processStep;
    NSString *accountType;
    NSString *accountClass;
    int dDay;
    int startCnt;
    NSString *networkErrorMsg;
    BOOL isPlainUse;
}
- (int)doSignOnPasswrod:(NSString*)ns_password vidText:(NSString*)ns_Vid signedData:(NSString**)ns_signedData;
- (int)doSendSignedDataString:(NSString*)ns_signedDataString vidText:(NSString*)ns_Vid outString:(NSString**)ns_outString;
- (void)delyStart;
- (int)runCheckPKeyPassword;
- (BOOL)checkTrickAgree;
@end

@implementation SHBCertDetailViewController


@synthesize certPWTextField;
@synthesize certArray;
@synthesize subjectCNLabel;
@synthesize issuerAliasLabel;
@synthesize certificateOIDAliasLabel;
@synthesize notAfterLabel;
@synthesize isSignupProcess;
@synthesize encryptPwd;
@synthesize notAfterTitle;
@synthesize confirmBtn;
@synthesize cancelBtn;
@synthesize certImageView;
@synthesize idBtn;
@synthesize pwdTitle;
@synthesize subTitleLabel;

- (void)dealloc
{
    [encryptPwd release];
    //[certificate release], certificate = nil;
    [certPWTextField release], certPWTextField = nil;
    [subjectCNLabel release], subjectCNLabel = nil;
    [issuerAliasLabel release], issuerAliasLabel = nil;
    [certificateOIDAliasLabel release], certificateOIDAliasLabel = nil;
    [notAfterLabel release], notAfterLabel = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // 초기화.
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && AppInfo.isBackGroundCall)
    {
        //if (![SHBUtility isFindString:[SHBUtilFile getModel] find:@"iPhone 5"] && displayKeyboard == YES)
        if ([UIScreen mainScreen].bounds.size.height <= 480 && displayKeyboard == YES)
        {
            [self.contentScrollView setContentOffset:CGPointMake(0, 24.0f) animated:NO];
            AppInfo.isBackGroundCall = NO;
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    AppInfo.indexQuickMenu = 0;
    startTextFieldTag = 1;
    endTextFieldTag = 1;
    remineCount = 5;
    isPlainUse = NO;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y - 20, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
    }
    
    if (AppInfo.certProcessType == CertProcessTypeCopySHCard)
    {
        [self setTitle:@"신한카드 앱으로 인증서복사"];
    } else if (AppInfo.certProcessType == CertProcessTypeCopySHInsure)
    {
        [self setTitle:@"신한생명 앱으로 인증서복사"];
    } else if (AppInfo.certProcessType == CertProcessTypeCopySHCardEasyPay)
    {
        [self setTitle:@"신한카드 앱으로 인증서복사"];
    } else if (AppInfo.certProcessType == CertProcessTypeCopyPC)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            [self setTitle:@"Copy certificate  smart phone➞pc"];
            [self navigationBackButtonEnglish];
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            [self setTitle:@"スマートフォン➞PC　電子証明書コピー"];
            [self navigationBackButtonJapnes];
        }else
        {
            [self setTitle:@"스마트폰➞PC 인증서 복사"];
        }
    } else
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            [self setTitle:@"Digital Certificate Login"];
            [self navigationBackButtonEnglish];
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            [self setTitle:@"電子証明書ログイン"];
            [self navigationBackButtonJapnes];
        }else
        {
            [self setTitle:@"공인인증서 로그인"];
        }
        
    }
    
    Debug(@"certProcessType2:%i",AppInfo.certProcessType);
    //AppInfo.certProcessType = CertProcessTypeLogin;
    
    // 보안키패드 호출.
    [self.certPWTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:50];
    
    // 인증서정보 설정.
    
    //    NSLog(@"selectedCertificate:%@",AppInfo.selectedCertificate.user);
    //    NSLog(@"selectedCertifibcate:%@",AppInfo.selectedCertificate.issuer);
    //    NSLog(@"selectedCertificate:%@",AppInfo.selectedCertificate.type);
    //    NSLog(@"selectedCertificate:%@",AppInfo.selectedCertificate.expire);
    
    if (AppInfo.certProcessType == CertProcessTypeMoasignSign || AppInfo.certProcessType == CertProcessTypeMoasignLogin)
    {
        
        self.subjectCNLabel.text = AppInfo.selectCertificateInfomation.user;
        self.issuerAliasLabel.text = AppInfo.selectCertificateInfomation.issuer;
        self.certificateOIDAliasLabel.text = AppInfo.selectCertificateInfomation.type;
        self.notAfterLabel.text = AppInfo.selectCertificateInfomation.expire;
    } else
    {
        self.subjectCNLabel.text = AppInfo.selectedCertificate.user;
        self.issuerAliasLabel.text = AppInfo.selectedCertificate.issuer;
        self.certificateOIDAliasLabel.text = AppInfo.selectedCertificate.type;
        self.notAfterLabel.text = AppInfo.selectedCertificate.expire;
        
    }

    if (AppInfo.LanguageProcessType == EnglishLan)
    {
       self.issuerAliasTitleLabel.text = @"Issuer :";
       self.certificateOIDAliasTitleLabel.text = @"Type :";
       self.notAfterTitle.text = @"Expiration date :";
        [self.notAfterTitle setFrame:CGRectMake(self.notAfterTitle.frame.origin.x, self.notAfterTitle.frame.origin.y, 100.0f, self.notAfterTitle.frame.size.height)];
        [self.notAfterLabel setFrame:CGRectMake(170.0f, self.notAfterLabel.frame.origin.y, 100.0f, self.notAfterLabel.frame.size.height)];
        pwdTitle.text = @"Certificate Pwd";
        self.subTitleLabel.text = @"Selected Certificate Login";
        [self.confirmBtn setTitle:@"Confirm" forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.issuerAliasTitleLabel.text = @"発行者 :";
        self.certificateOIDAliasTitleLabel.text = @"区別 :";
        self.notAfterTitle.text = @"満了日 :";
        pwdTitle.text = @"電子証明書暗証番号";
        self.subTitleLabel.text = @"Selected Certificate Login";
        [self.confirmBtn setTitle:@"Confirm" forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    }else
    {
    
    }

    
    NSLog(@"aaaa:%@",self.notAfterLabel.text);
    dDay = [SHBUtility getDDay:self.notAfterLabel.text];
    //int dDay = [SHBUtility getDDay:@"2012-11-23"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginClose) name:@"loginClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginClose) name:@"notiServerError" object:nil];
    
    //만료된 인증서인지 확인하고 이미지와 색깔을 바꿔준다.
    if (dDay < 30)
    {
        self.notAfterTitle.textColor = RGB(209, 75, 75);
        self.notAfterLabel.textColor = RGB(209, 75, 75);
        
    }
    
    [self.view sendSubviewToBack:self.contentScrollView];
    
    remineCount = 5;
    //보안키패드를 올린다
    //[self.certPWTextField becomeFirstResponder];
    //if ([SHBUtility isFindString:[SHBUtilFile getModel] find:@"iPhone 5"] && floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    //{
       [self performSelector:@selector(autoTouchSecureKeypad) withObject:nil afterDelay:0.01];
        //[self.certPWTextField becomeFirstResponder];
        
    //}else
    //{
       //[self.certPWTextField becomeFirstResponder];
    //    [self performSelector:@selector(autoTouchSecureKeypad) withObject:nil afterDelay:0.01];
    //}
    
    
    
    //NSLog(@"aaaa:%i",AppInfo.certProcessType);
    /*
    if ((AppInfo.certProcessType == CertProcessTypeNo || AppInfo.certProcessType == CertProcessTypeLogin || AppInfo.certProcessType == CertProcessTypeInFotterLogin || AppInfo.certProcessType == CertProcessTypeIssue || AppInfo.certProcessType == CertProcessTypeCopyQR || AppInfo.certProcessType == CertProcessTypeCopySmart) && (AppInfo.isLogin != LoginTypeIDPW))
    {
        idBtn.hidden = NO;
    } else
    {
        idBtn.hidden = YES;
    }
     */
    
    //푸터로그인, 메뉴 진입전 로그인 단계 아니면 id 로그인 버튼 보이지 않음
    if ((AppInfo.certProcessType == CertProcessTypeNo || AppInfo.certProcessType == CertProcessTypeLogin || AppInfo.certProcessType == CertProcessTypeInFotterLogin) && (AppInfo.isLogin != LoginTypeIDPW))
    {
        idBtn.hidden = NO;
    } else
    {
        idBtn.hidden = YES;
    }
    
    
    if (AppInfo.certProcessType == CertProcessTypeIssueLogin)
    {
        //인증서 발급받고 로그인을 시도할때...
        AppInfo.certProcessType =CertProcessTypeLogin;
    }
    
    if (AppInfo.certProcessType == CertProcessTypeNo || AppInfo.certProcessType == CertProcessTypeLogin || AppInfo.certProcessType == CertProcessTypeInFotterLogin || AppInfo.certProcessType == CertProcessTypeCopySmart || AppInfo.certProcessType == CertProcessTypeCopyQR || AppInfo.certProcessType == CertProcessTypeRenew || AppInfo.certProcessType == CertProcessTypeMoasignLogin || AppInfo.certProcessType == CertProcessTypeMoasignSign || AppInfo.certProcessType ==CertProcessTypeCopySHCard || AppInfo.certProcessType == CertProcessTypeCopySHInsure || AppInfo.certProcessType == CertProcessTypeCopySHCardEasyPay || AppInfo.certProcessType == CertProcessTypeCopyPC)
    {
        if (!UIAccessibilityIsVoiceOverRunning())
        {
            self.confirmBtn.hidden = YES;
            self.cancelBtn.hidden = YES;
        }
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (AppInfo.isWebSSOLogin) //sso 웹 연동일경우 초기화(로그인 안하고 화면 닫을경우 대비
    {
        AppInfo.isWebSSOLogin = NO;
    }
    startCnt = 0;
    [super viewWillDisappear:animated];
}
- (void)viewDidUnload
{
    self.certPWTextField = nil;
    [super viewDidUnload];
}
/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)autoTouchSecureKeypad
{
    if (!UIAccessibilityIsVoiceOverRunning())
    {
        [self.certPWTextField becomeFirstResponder];
    }
    
}

- (void)delyStart
{
    
    //버젼정보를 가져왔는지 확인후 로그인을 시도한다.
    if (AppInfo.isGetVersionInfo == 0)
    {
        startCnt++;
        if (startCnt <= 20)
        {
            NSLog(@"버젼정보 가져오기 대기");
            
            //10초를 기다린다.
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(delyStart) userInfo:nil repeats:NO];
            
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
    
    //모아 사인 처리
    if (AppInfo.certProcessType == CertProcessTypeMoasignLogin || AppInfo.certProcessType == CertProcessTypeMoasignSign)
    {
        //[self dismiss];
        [AppDelegate closeProgressView];
        int nReturn = IXL_nFilterKeyCheck();
        
        int rtnCode = -1;
        if(nReturn == 0)
        {
            rtnCode = [MoaSignSDK runCheckPKeyPasswordData:AppInfo.eccData cert:AppInfo.selectCertificateInfomation];
        }else
        {
            rtnCode = [MoaSignSDK runCheckPKeyPassword:self.certPWTextField.text cert:AppInfo.selectCertificateInfomation];
        }
        
        if(0 == rtnCode)
        {
            if (AppInfo.certProcessType == CertProcessTypeMoasignLogin)
            {
                int nReturn = IXL_nFilterKeyCheck();
                //nReturn = -1;
                if(nReturn == 0)
                {
                    //NSString *phoneInfo = [NSString stringWithFormat:@"%@%@",PROTOCOL_HTTPS,AppInfo.serverIP];
                    //NSString *phoneDetailInfo = [SHBUtilFile getResultSum:phoneInfo portNumber:443 connected:TRUE accessGroup:@"HQ59H9US6W.com.ktb.KeychainSuite"];
                    //[MoaSignSDK setUserDefinedReturnValue:@"abcdefg!!" Name:@"Encryptedtestdata" Encrypt:true];
                    //[MoaSignSDK setUserDefinedReturnValue:phoneDetailInfo Name:@"testdata" Encrypt:false];
                    
                    NSString *tocken;
                    if ([[SHBPushInfo instance].deviceToken length] == 0)
                    {
                        tocken = @"";
                    }else
                    {
                        tocken = [SHBPushInfo instance].deviceToken;
                    }
                    NSString *totInfo = [SHBUtilFile getResultSum:[NSString stringWithFormat:@"%@%@",PROTOCOL_HTTPS,AppInfo.serverIP] portNumber:443 connected:TRUE accessGroup:@"HQ59H9US6W.com.ktb.KeychainSuite"];
                    
                    //totInfo = [totInfo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    [MoaSignSDK setUserDefinedReturnValue:AppInfo.bundleVersion Name:@"APP_VERSION" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:@"I" Name:@"OS_TYPE" Encrypt:false];
                    
                    
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"] Name:@"MACADDRESS1" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"] Name:@"MACADDRESS2" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[NSString stringWithFormat:@"02 %@",AppInfo.bundleVersion]Name:@"SBANK_SBANKVER" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getOSVersion] Name:@"SBANK_PHONE_OS" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:@"" Name:@"SBANK_PHONE_NO" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getTelecomCarrierName] Name:@"SBANK_PHONE_COM" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getModel] Name:@"SBANK_PHONE_MODEL" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"] Name:@"SBANK_UID1" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"] Name:@"SBANK_MAC1" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:tocken Name:@"SBANK_TOKEN" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:totInfo  Name:@"SBANK_PHONE_INFO" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:AppInfo.bundleVersion Name:@"VERSION" Encrypt:false];
                    
                    [MoaSignSDK sendCertificateToServer:AppInfo.selectCertificateInfomation passwordData:AppInfo.eccData delegate:self];
                    
                }else
                {
                    NSString *tocken;
                    if ([[SHBPushInfo instance].deviceToken length] == 0)
                    {
                        tocken = @"";
                    }else
                    {
                        tocken = [SHBPushInfo instance].deviceToken;
                    }
                    NSString *totInfo = [SHBUtilFile getResultSum:[NSString stringWithFormat:@"%@%@",PROTOCOL_HTTPS,AppInfo.serverIP] portNumber:443 connected:TRUE accessGroup:@"HQ59H9US6W.com.ktb.KeychainSuite"];
                    
                    //totInfo = [totInfo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    [MoaSignSDK setUserDefinedReturnValue:AppInfo.bundleVersion Name:@"APP_VERSION" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:@"I" Name:@"OS_TYPE" Encrypt:false];
                    
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"] Name:@"MACADDRESS1" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"] Name:@"MACADDRESS2" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[NSString stringWithFormat:@"02 %@",AppInfo.bundleVersion]Name:@"SBANK_SBANKVER" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getOSVersion] Name:@"SBANK_PHONE_OS" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:@"" Name:@"SBANK_PHONE_NO" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getTelecomCarrierName] Name:@"SBANK_PHONE_COM" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getModel] Name:@"SBANK_PHONE_MODEL" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"] Name:@"SBANK_UID1" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"] Name:@"SBANK_MAC1" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:tocken Name:@"SBANK_TOKEN" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:totInfo  Name:@"SBANK_PHONE_INFO" Encrypt:false];
                    [MoaSignSDK setUserDefinedReturnValue:AppInfo.bundleVersion Name:@"VERSION" Encrypt:false];
                    
                    [MoaSignSDK sendCertificateToServer:AppInfo.selectCertificateInfomation password:self.certPWTextField.text delegate:self];
                }
                
                AppInfo.certProcessType = CertProcessTypeNo;
                return;
            } else if (AppInfo.certProcessType == CertProcessTypeMoasignSign) //전자 서명 페이지
            {
                
                if (AppInfo.LanguageProcessType == EnglishLan)
                {
                    SHBCertElectronicSignViewController *viewController = [[SHBCertElectronicSignViewController alloc] initWithNibName:@"SHBCertElectronicSignViewControllerEng" bundle:nil];
                    [self.navigationController pushFadeViewController:viewController];
                    [viewController release];
                    return;
                } else
                {
                    SHBCertElectronicSignViewController *viewController = [[SHBCertElectronicSignViewController alloc] initWithNibName:@"SHBCertElectronicSignViewController" bundle:nil];
                    [self.navigationController pushFadeViewController:viewController];
                    [viewController release];
                    return;
                }
                
            }
            
        }
        else
        {
            
            [self.certPWTextField becomeFirstResponder];
            NSString *msg = [NSString stringWithFormat:@"선택된 인증서 암호가 맞지 않습니다. 암호를 다시 입력하십시오."];
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
            
            return;
        }
    }
    
    //로그인 처리
    NSString *signDataString = nil, *msg;
    NSString *outMsg = nil;
    
    if ([self runCheckPKeyPassword] == -1)
    {
        return;
    } else
    {
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
        {
            [self.contentScrollView setContentOffset:CGPointMake(0, -20) animated:YES];
        }else
        {
            [self.contentScrollView setContentOffset:CGPointZero animated:YES];
        }
        
    }
    
    //유효성 체크
    int rtn = [self doSignOnPasswrod:self.certPWTextField.text vidText:@"0000000000000" signedData:&signDataString];
    //NSLog(@"encryptPwd:%@",self.encryptPwd);
    //int rtn = [self doSignOnPasswrod:[self.encryptPwd UTF8String] vidText:@"0000000000000" signedData:&signDataString];
    //NSLog(@"certprocesstype:%i",AppInfo.certProcessType);
    
    if (rtn == -2)
    {
        self.confirmBtn.hidden = NO;
        self.cancelBtn.hidden = NO;
        msg =  @"거래진행이 중단되었습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다. 이체실행중이셨으면 반드시 예금거래내역조회를 통하여 처리결과를 먼저 확인하시기 바랍니다.";
        msg = [NSString stringWithFormat:@"%@\n[%@]",msg,networkErrorMsg];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:@"" message:msg];
        return;
    }
    AppInfo.certPlainPwd = certPWTextField.text;
    
    
    if (AppInfo.certProcessType == CertProcessTypeNo || AppInfo.certProcessType == CertProcessTypeLogin || AppInfo.certProcessType == CertProcessTypeInFotterLogin || AppInfo.certProcessType == CertProcessTypeCopySmart || AppInfo.certProcessType == CertProcessTypeCopyQR || AppInfo.certProcessType == CertProcessTypeIssue)
    {
        if (rtn == 0)
        {
            rtn = [self doSendSignedDataString:signDataString vidText:@"0000000000000" outString:&outMsg];
            
        }
        
    } else if (AppInfo.certProcessType == CertProcessTypeRenew || AppInfo.certProcessType == CertProcessTypeCopySHCard || AppInfo.certProcessType == CertProcessTypeCopySHInsure || AppInfo.certProcessType == CertProcessTypeCopySHCardEasyPay) //인증서 갱신, 신한카드 인증서 푸쉬, 신한생명 인증서 푸쉬
    {
        //NSLog(@"signeddatastring:%@",signDataString);
        if (rtn == 0)
        {
            self.confirmBtn.hidden = NO;
            self.cancelBtn.hidden = NO;
            //[self dismiss];
            [AppDelegate closeProgressView];
            [AppDelegate.navigationController fadePopViewController];   // 인증서 상세.
            [AppDelegate.navigationController fadePopViewController];   // 인증서 목록
            
            if (AppInfo.certProcessType == CertProcessTypeRenew)
            {
                if (AppInfo.LanguageProcessType == EnglishLan)
                {
                    SHBCertRenewStep2ViewController *viewController = [[SHBCertRenewStep2ViewController alloc] initWithNibName:@"SHBCertRenewStep2ViewControllerEng" bundle:nil];
                    
                    char *outsigndataUrlEnc = IXL_URLEncode((char*)[signDataString UTF8String]);
                    NSString *postString = [NSString stringWithFormat:@"PKCS7SignedData=%s",outsigndataUrlEnc];
                    AppInfo.signedData = postString;
                    //viewController.signDataString = signDataString;
                    //viewController.signDataString = [NSString stringWithFormat:@"PKCS7SignedData=%@",signDataString];
                    [AppDelegate.navigationController pushFadeViewController:viewController];
                    [viewController release];
                    return;
                }else
                {
                    SHBCertRenewStep2ViewController *viewController = [[SHBCertRenewStep2ViewController alloc] initWithNibName:@"SHBCertRenewStep2ViewController" bundle:nil];
                    
                    char *outsigndataUrlEnc = IXL_URLEncode((char*)[signDataString UTF8String]);
                    NSString *postString = [NSString stringWithFormat:@"PKCS7SignedData=%s",outsigndataUrlEnc];
                    AppInfo.signedData = postString;
                    //viewController.signDataString = signDataString;
                    //viewController.signDataString = [NSString stringWithFormat:@"PKCS7SignedData=%@",signDataString];
                    [AppDelegate.navigationController pushFadeViewController:viewController];
                    [viewController release];
                    return;
                }
                
            } else if (AppInfo.certProcessType == CertProcessTypeCopySHCard || AppInfo.certProcessType == CertProcessTypeCopySHInsure|| AppInfo.certProcessType == CertProcessTypeCopySHCardEasyPay)
            {
                
                //NSError *error = nil;
                
                NSString* macAddress = [SHBUtility getMacAddress:NO];
                NSRange strRange;
                strRange.location = 6;
                strRange.length = [macAddress length] - strRange.location;
                
                NSString* AuthenticationCode = [NSString stringWithFormat:@"%@%@%@",[macAddress substringToIndex:6],@"_ShinHan_",[macAddress substringWithRange:strRange]];
                
                char *authCode = (char*)[AuthenticationCode UTF8String];
                
                //NSLog(@"AuthenticationCode:%@",AuthenticationCode);
                
                int nRet = IXL_NOK;
                char *pKeyAndCert = NULL;
                int nKeyAndCertlen = 0;
                int cert_index = [AppInfo.selectedCertificate index];
                
                nRet = IXL_EncryptFromCertWithAuthCode(cert_index, authCode, &pKeyAndCert, &nKeyAndCertlen);
                
                NSString* base64pkcs12 = [NSString stringWithFormat:@"%s", pKeyAndCert];
                NSString *stringURL = @"";
                if (AppInfo.certProcessType == CertProcessTypeCopySHCard)
                {
                    stringURL = [NSString stringWithFormat:@"%@?cmd=certpush&caller_url_scheme=%@&result=00&cert=%@",@"SFG-SHC-smartcard://",@"SFG-SHB-sbank://",base64pkcs12];
                    
                } else if (AppInfo.certProcessType == CertProcessTypeCopySHInsure)
                {
                    stringURL = [NSString stringWithFormat:@"%@?cmd=certpush&caller_url_scheme=%@&result=00&cert=%@",@"SFG-SHL-slife://",@"SFG-SHB-sbank://",base64pkcs12];
                } else if (AppInfo.certProcessType == CertProcessTypeCopySHCardEasyPay)
                {
                    stringURL = [NSString stringWithFormat:@"%@?cmd=certpush&caller_url_scheme=%@&result=00&cert=%@",@"SFG-SEEROO-shsmartpay://",@"SFG-SHB-sbank://",base64pkcs12];
                }
                
                [AppDelegate.navigationController fadePopViewController];
                //URL 전송으로 위해 UTF8형태로 인코딩
                NSString* escapeUrl = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                //escapeUrl = [escapeUrl stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escapeUrl]];
                
            }
            
        }
    }else if (AppInfo.certProcessType == CertProcessTypeCopyPC) //스맛폰에서 pc인증서 복사인경우...
    {
        if (rtn == 0)
        {
            self.confirmBtn.hidden = NO;
            self.cancelBtn.hidden = NO;
            //[self dismiss];
            [AppDelegate closeProgressView];
            [AppDelegate.navigationController fadePopViewController];   // 인증서 상세.
            [AppDelegate.navigationController fadePopViewController];   // 인증서 목록
            
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                SHBCertMovePCViewController *viewController = [[SHBCertMovePCViewController alloc] initWithNibName:@"SHBCertMovePCViewControllerEng" bundle:nil];
                viewController.certPwd = self.certPWTextField.text; //평문 인증서 암호를 넘겨준다.
                [AppDelegate.navigationController pushFadeViewController:viewController];
                [viewController release];
                return;
                
            } else
            {
                SHBCertMovePCViewController *viewController = [[SHBCertMovePCViewController alloc] initWithNibName:@"SHBCertMovePCViewController" bundle:nil];
                viewController.certPwd = self.certPWTextField.text; //평문 인증서 암호를 넘겨준다.
                [AppDelegate.navigationController pushFadeViewController:viewController];
                [viewController release];
                return;
            }
            
        }
        
    }
    
    if(rtn == 0){
        
        NSLog(@"Password is valid ");
        //        msg = @"인증서 제출에 성공하였습니다.";
        //alertTag = 100;
    }
    else {
        if (outMsg) {
            msg = outMsg;
        }else{
            self.confirmBtn.hidden = NO;
            self.cancelBtn.hidden = NO;
            msg = [NSString stringWithFormat:@"[오류가 발생하였습니다.]\n[ErrorCd:%d]",rtn];
            //msg = @"인증서 암호가 올바르지 않습니다.";
            if (rtn == 1052013) {
                //[self dismiss];
                [AppDelegate closeProgressView];
                remineCount--;
                if (remineCount > 0)
                {
                    if (AppInfo.LanguageProcessType == EnglishLan)
                    {
                        msg = [NSString stringWithFormat:@"You have entered an incorrect password. Please try again. (the number of remainning trials: %d)", remineCount];
                    }else if (AppInfo.LanguageProcessType == JapanLan)
                    {
                        msg = [NSString stringWithFormat:@"選択された電子証明書のパスワードが違います。パスワードをもう一度ご入力ください。（残りの再入力回数:%d）", remineCount];
                    }else
                    {
                       msg = [NSString stringWithFormat:@"선택된 인증서 암호가 맞지 않습니다. 암호를 다시 입력하십시오.(남은재시도횟수:%d)", remineCount]; 
                    }

                    
                } else
                {
                    if (AppInfo.LanguageProcessType == EnglishLan)
                    {
                        msg = @"You have entered an incorrect password in 5 times. If you would like to continue to use the service, please startover the step.";
                    }else if (AppInfo.LanguageProcessType == JapanLan)
                    {
                       msg = @"電子証明書のパスワード入力回数（５回）を超えました。続けてサービスをご利用の場合は最初からやり直してください。初期画面に移動します。"; 
                    }else
                    {
                      msg = @"인증서 암호입력회수(5회)를 초과하였습니다. 계속해서 서비스를 이용하시려면 처음부터 다시 거래하여 주시기 바랍니다. 처음거래화면으로 이동합니다.";  
                    }
                    
                }
                
                
                
            }
        }
        //alertTag = 200;
        self.certPWTextField.text = @"";
        
        //        if (remineCount > 0)
        //        {
        //            [self.certPWTextField becomeFirstResponder];
        //        }
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg language:AppInfo.LanguageProcessType];
        
        return;
    }
}
#pragma makr - 퍼블릭 메서드
- (IBAction)confirmAction:(id)sender
{
    

#ifdef DEVELOPER_MODE
    [LPStopwatch start:@"로그인 속도 계산"];
#endif
    NSString *msg;
    
    self.confirmBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
    
    //    if(self.certPWTextField.text == nil || [self.certPWTextField.text isEqualToString:@""] || [self.certPWTextField.text length] < 6)
    //	{
    //        msg = @"이용자 비밀번호는 영문,숫자의 조합으로 6~16자 이내입니다.";
    //        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
    //		return;
    //	}
    
    //16자 못 넘는다.
    if ([self.certPWTextField.text length] == 0 || self.certPWTextField.text == nil)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Please enter the digital certificate password.";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"電子証明書暗証番号をご入力ください。";
        }else
        {
            msg = @"인증서 암호를 입력하여 주십시오.";
        }
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        [self.certPWTextField becomeFirstResponder];
        return;
    }
    
    
    //[self show];
    [AppDelegate showProgressView];
    //[self performSelector:@selector(delyStart) withObject:nil afterDelay:0.1];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(delyStart) userInfo:nil repeats:NO];
}

- (IBAction)cancelAction:(id)sender
{
//    if (AppInfo.certProcessType == CertProcessTypeMoasignLogin)
//    {
//        [MoaSignSDK sendCertificateToServer:nil password:nil delegate:self];
//        AppInfo.certProcessType = CertProcessTypeNo;
//    }else
//    {
        [self.navigationController fadePopViewController];
    //}
    
}


#pragma mark - initech process
- (int)doSignOnPasswrod:(NSString*)ns_password vidText:(NSString*)ns_Vid signedData:(NSString**)ns_signedData
{
    //통신처리
    //NSURL* theURL = [NSURL URLWithString:@"https://demo.initech.com:8343/initech/mobilianNet/Time.jsp"];
    
    
    //테스트용 인증서도 처리할수 있는 우회방법 찾은 후 주석 풀어야 됨
    //    NSURL *url = [NSURL URLWithString:
    //                  [NSString stringWithFormat:@"%@%@%@",PROTOCOL_HTTPS,REAL_SERVER_IP,CERT_TIME_URL]];
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@%@",PROTOCOL_HTTPS,AppInfo.serverIP,CERT_TIME_URL]];
    
    
    NSLog(@"sUrl:%@",[NSString stringWithFormat:@"%@%@%@",PROTOCOL_HTTPS,AppInfo.serverIP,CERT_TIME_URL]);
    //NSURL *url = [NSURL URLWithString:
    //NSLog(@"sUrl:%@",[NSString stringWithFormat:@"%@%@%@",PROTOCOL_HTTPS,REAL_CERT_IMPORT_IP,CERT_TIME_URL]);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSString* in_vd = nil;
    
#ifdef DEVELOPER_MODE
    [LPStopwatch start:@"서명데이터 생성"];
#endif
    
    NSData *url_out = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error];


    // release 처리
    NSString *sTime = [[[NSString alloc] initWithData:url_out encoding:NSUTF8StringEncoding] autorelease];
    
    NSRange range1 = [sTime rangeOfString:@"<TOLBA01>"];
    
    if (range1.location > 0)
    {
        NSString *serverTime = [sTime substringFromIndex:(range1.location + 22)];
        
        NSRange range2 = [serverTime rangeOfString:@"\"/></TOLBA01>"];
        
        if (range2.location > 0)
        {
            serverTime = [serverTime substringToIndex:range2.location];
            
            url_out = [serverTime dataUsingEncoding:NSUTF8StringEncoding];
        }
        
    }
    
    if (nil != url_out && 0 < [url_out length]) {
        in_vd = [[[NSString alloc] initWithData:url_out
                                       encoding:NSUTF8StringEncoding]
                 autorelease];
        if(nil == in_vd) {
            in_vd = [[[NSString alloc] initWithData:url_out
                                           encoding:NSEUCKRStringEncoding]
                     autorelease];
        }
    }
    else
    {
        networkErrorMsg = [error localizedDescription];
        return -2;
    }
    NSLog(@"sTime:%@",in_vd);
    time_t tm;
    struct tm *recv_tim;
    int ret = IXL_Get_Server_Time((char*)[in_vd UTF8String], &tm);
    
    if(IXL_NOK == ret)
    {
        //#if DEBUG // 서버시간을 가져오지 못하여 에러 처리할 경우
        //msg = [NSString stringWithFormat: @"서버시간을 가져오지 못하였습니다."];
        //*ns_outString = msg;
        //return -1;
        //#else // 단말기 시간을 설정하여 진행할 경우
        time(&tm);
        //#endif
    }
    //타임존이 외국으로 설정되어 있는경우 대비
    tzset();
    setenv("TZ", "Asia/Seoul", 1);
    
    recv_tim = localtime(&tm);
    
    NSLog(@"오늘은 %d년 %d월 %d일 %d요일 입니다. \n 현재 %d시 %d분 %d초 입니다."
          , recv_tim->tm_year+1900
          , recv_tim->tm_mon+1
          , recv_tim->tm_mday
          , recv_tim->tm_wday
          ,recv_tim->tm_hour
          , recv_tim->tm_min
          , recv_tim->tm_sec);
    
    unsigned char *outcertdata = NULL;
    unsigned char *outsigndata = NULL;
    //unsigned char *outrandom = NULL;
    int outcertdata_len = 0;
    int outsigndata_len = 0;
    //int outrandom_len = 0;
    
    NSString *ns_indata = [NSString stringWithFormat:@"%@",ns_Vid];
    char *indata = (char*)[ns_indata UTF8String];
    int indata_len = strlen(indata);
    char *password = (char*)[ns_password UTF8String];
    int password_len = strlen(password);
    
    int cert_index = [AppInfo.selectedCertificate index];
    
//    ret = IXL_PKCS7_Cert_With_Random(cert_index/* cert index */, 1 /* with random flag */, recv_tim, (unsigned char*)password, password_len, (unsigned char *)indata, indata_len, 1 /* base64 encoding flag */, &outcertdata, &outcertdata_len, &outsigndata, &outsigndata_len);
    
    //IXL_PKCS7_Cert_With_Random (int idx, int nWithRandomFlag, struct tm *recv_time, NSData* pwd, unsigned char* org_data, int org_datal,int encodingflag, unsigned char** outcert , int* outcertl, unsigned char** outdata, int* outdatal);
    
    int nReturn = IXL_nFilterKeyCheck();
    
    if (isPlainUse == YES)
    {
        nReturn = -1;
        isPlainUse = NO;
    }
    
    if(nReturn == 0)
    {
        ret = IXL_PKCS7_Cert_With_Random(cert_index/* cert index */, 1 /* with random flag */, recv_tim, AppInfo.eccData, (unsigned char *)indata, indata_len, 1 /* base64 encoding flag */, &outcertdata, &outcertdata_len, &outsigndata, &outsigndata_len);
    }else
    {
        ret = IXL_PKCS7_Cert_With_Random(cert_index/* cert index */, 1 /* with random flag */, recv_tim, (unsigned char*)password, password_len, (unsigned char *)indata, indata_len, 1 /* base64 encoding flag */, &outcertdata, &outcertdata_len, &outsigndata, &outsigndata_len);
    }
    
    if (0 != ret) {
        return ret;
    }
    *ns_signedData = [NSString stringWithCString:(char*)outsigndata encoding:NSEUCKRStringEncoding];
    
    return 0;
}



/**
 * @brief	: doSendSignedDataString:vidText:outString:	[ 제출할 인증서를 전송한다. ]
 * @param	: [IN] NSString* ns_signedDataString	 [ 인증서 암호 ]
 * @param	: [IN] NSString* ns_Vid	 [ 임의의 문자(주민번호가 아니어도 괜찮음) ]
 * @param	: [OUT]NSString** ns_outString	 [ 제출할 인증서 데이터 (base64) ]
 * @return
 *	 성공 : 0
 *	 실패 : -1
 */
- (int)doSendSignedDataString:(NSString*)ns_signedDataString vidText:(NSString*)ns_Vid outString:(NSString**)ns_outString
{
    processStep = 1;
    //NSURL *theURL = [NSURL URLWithString:@"https://demo.initech.com:8343/initech/mobilianNet/login.jsp"];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];
    
    
    char *outsigndataUrlEnc = IXL_URLEncode((char*)[ns_signedDataString UTF8String]);
    //NSString *postString = [NSString stringWithFormat:@"JuminNO=%@&PKCS7SignedData=%s", ns_Vid, outsigndataUrlEnc]; //구
#ifdef DEVELOPER_MODE
    [LPStopwatch stop:@"서명데이터 생성"];
#endif
    NSString *postString = [NSString stringWithFormat:@"PKCS7SignedData=%s",outsigndataUrlEnc];
    
    AppInfo.signedData = postString;
    //NSLog(@"AppInfo.signedData:%@",AppInfo.signedData);
    isAfterAlert = NO;
    AppInfo.isStartApp = NO;
    //개인화 이미지적용에 의한 변경
    //AppInfo.serviceCode = @"A0010";
    AppInfo.serviceCode = @"A1000";
    // release 처리
    NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionNumber = [versionNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
    versionNumber = [NSString stringWithFormat:@"%@0",versionNumber];
    
    
    //2013.10.08 추가 수정
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
    //NSLog(@"carrierName:%@",[SHBUtilFile getModel]);
    //NSLog(@"SBANK_PHONE_OS:%@",[[UIDevice currentDevice] systemVersion]);
    
    SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                             @{
                             @"모바일뱅킹번호" : @"01000000000",
                             //@"프록시서버PORT" : @"3810", //앱의 버젼 정보를 넣으면 된다.
                             @"프록시서버PORT" : versionNumber, //앱의 버젼 정보를 넣으면 된다.
                             @"deviceId" : [AppDelegate getSSODeviceID],
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
                             @"SBANK_PHONE_COM" :[SHBUtilFile getTelecomCarrierName],
                             //@"SBANK_PHONE_MODEL" :[[UIDevice currentDevice] model],
                             @"SBANK_PHONE_MODEL" :[SHBUtilFile getModel],
                             @"SBANK_UID1" :[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                             @"SBANK_MAC1" :[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                             @"SBANK_PHONE_ETC1" : @"",
                             @"SBANK_TOKEN" : tocken,
                             @"SBANK_PHONE_INFO" : [SHBUtilFile getResultSum:[NSString stringWithFormat:@"%@%@",PROTOCOL_HTTPS,AppInfo.serverIP] portNumber:443 connected:TRUE accessGroup:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                             }] autorelease];
    
    SendData(SHBTRTypeServiceCode, SC_A0010, LOGIN_URL, self, aDataSet); //실제 인증서 로그인 전문을 태운다
    
    return 0;
    
}
#pragma mark - 비밀번호 확인
- (int) runCheckPKeyPassword
{
    
    NSString *strPKeypass = self.certPWTextField.text;
	NSString *msg = nil;
	int ret = -1;
	
    //nFilter의 공개키가 설정되었는지 확인한다.
    int nReturn = IXL_nFilterKeyCheck();
    if (nReturn == 0)
    {
        ret = IXL_CheckPOP([AppInfo.selectedCertificate index], AppInfo.eccData);
        
        if (ret == PKEY_PASSWORD_INCORRECT)
        {
            //평문으로 재검증
            ret = IXL_CheckPOP([AppInfo.selectedCertificate index], (char *)[strPKeypass UTF8String], (int)[strPKeypass length]);
            if (ret == 0) isPlainUse = YES;
                
        }
    }else
    {
        ret = IXL_CheckPOP([AppInfo.selectedCertificate index], (char *)[strPKeypass UTF8String], (int)[strPKeypass length]);
    }
    
	
    //ret = IXL_CheckPOP([AppInfo.selectedCertificate index], AppInfo.eccData);
    
	if(ret != 0){
		if(ret == CHECKVID_PARAM_ERROR){
			//msg = @"파라미터 오류";
		}
		else if(ret == PKEY_PASSWORD_INCORRECT){
            
            //[self dismiss];
            [AppDelegate closeProgressView];
            remineCount--;
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                [self.contentScrollView setContentOffset:CGPointMake(0, -20) animated:NO];
            }else
            {
                [self.contentScrollView setContentOffset:CGPointZero animated:NO];
            }
            
            if (!AppInfo.isiPhoneFive)
            {
                self.certificateOIDAliasTitleLabel.hidden = NO;
                self.certificateOIDAliasLabel.hidden = NO;
                [self.subjectCNLabel setFrame:CGRectMake(60, 4, 245, 23)];
                self.notAfterTitle.hidden = NO;
                self.notAfterLabel.hidden = NO;
                self.issuerAliasTitleLabel.frame = CGRectMake(60, 25, 50, 21);
                self.issuerAliasLabel.frame = CGRectMake(115, 25, 190, 21);
            }
            
            if (remineCount > 0)
            {
                if (AppInfo.LanguageProcessType == EnglishLan)
                {
                    msg = [NSString stringWithFormat:@"You have entered an incorrect password. Please try again. (the number of remainning trials: %d)", remineCount];
                }else if (AppInfo.LanguageProcessType == JapanLan)
                {
                    msg = [NSString stringWithFormat:@"選択された電子証明書のパスワードが違います。パスワードをもう一度ご入力ください。（残りの再入力回数:%d）", remineCount];
                }else
                {
                    msg = [NSString stringWithFormat:@"선택된 인증서 암호가 맞지 않습니다. 암호를 다시 입력하십시오.(남은재시도횟수:%d)", remineCount];
                }
                
            } else
            {
                if (AppInfo.LanguageProcessType == EnglishLan)
                {
                    msg = @"You have entered an incorrect password in 5 times. If you would like to continue to use the service, please startover the step.";
                }else if (AppInfo.LanguageProcessType == JapanLan)
                {
                    msg = @"電子証明書のパスワード入力回数（５回）を超えました。続けてサービスをご利用の場合は最初からやり直してください。初期画面に移動します。";
                }else
                {
                    msg = @"인증서 암호입력회수(5회)를 초과하였습니다. 계속해서 서비스를 이용하시려면 처음부터 다시 거래하여 주시기 바랍니다. 처음거래화면으로 이동합니다.";
                }
                
            }
            
            self.certPWTextField.text = @"";
            
            if (remineCount > 0)
            {
                [self.certPWTextField becomeFirstResponder];
            }
            
            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg language:AppInfo.LanguageProcessType];
            
            return -1;
		}
		else {
			//msg = @"인증서 가져오기 실패";
		}
		
	}
    
    if (dDay < 30 && !isAfterAlert)
    {
        isAfterAlert = YES;
        //self.encryptPwd = [NSString stringWithFormat:@"<E2K_CHAR=%@>", value];
        NSArray *tmpArray = [self.notAfterLabel.text componentsSeparatedByString:@"-"];
        NSString *msg;
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            
            msg = [NSString stringWithFormat:@"You have selected a digital certificate which will be expired on\n%@.%@.%@ 23:59\n(Expiration of %i days)\nPlease renew the existing certificate before the expiration date.A digital certificate issued by Shinhan Bank can be renewed from the certificate center of Shinhan S Bank.  A digital certificate issued by another insititutions is possible to renew in each institution's internet banking.",[tmpArray objectAtIndex:0],[tmpArray objectAtIndex:1],[tmpArray objectAtIndex:2],dDay];
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = [NSString stringWithFormat:@"選択された電子証明書の満了日は\n%@年%@月%@日 23時59分です。\n(満了%i日前)\n電子証明書満了前に既存の電子証明書を更新してください。当行電子証明書は新韓Sバンクの電子証明書センターで更新でき、他行電子証明書は該当機関のインターネットバンキングで更新できます。",[tmpArray objectAtIndex:0],[tmpArray objectAtIndex:1],[tmpArray objectAtIndex:2],dDay];
        }else
        {
            msg = [NSString stringWithFormat:@"선택한 인증서의 만료일은\n%@년%@월%@일 23시59분 입니다.\n(만료%i일전)\n인증서 만료 전에 기존인증서를\n갱신하시기 바랍니다.\n당행인증서는 신한S뱅크의\n공인인증센터에서 갱신가능하며,\n타행인증서는 해당기관의\n인터넷뱅킹에서 갱신가능합니다.",[tmpArray objectAtIndex:0],[tmpArray objectAtIndex:1],[tmpArray objectAtIndex:2],dDay];
        }
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:9876 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return -1;
    }
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.contentScrollView setContentOffset:CGPointMake(0, -20) animated:NO];
    }else
    {
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
    }
    
    
    return 0;
    
}
#pragma mark - SHBSecureDelegate
- (void)textFieldDidBeginEditing:(SHBTextField *)textField
{
    //if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && [SHBUtility isFindString:[SHBUtilFile getModel] find:@"iPhone 5"])
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        curTextField = textField;
        
        int intFirstTextFieldTag = startTextFieldTag;
        int intLastTextFieldTag  = endTextFieldTag;
        
        // 최초 textField의 이전 버튼 처리
        for ( int i = intFirstTextFieldTag ; i < intLastTextFieldTag ; i++ )
        {
            if ( ((UITextField*)[self.view viewWithTag:intFirstTextFieldTag]).enabled == YES )
            {
                break;
            }
            
            intFirstTextFieldTag++;
        }
        
        // 마지막 textField의 다음 버튼 처리
        for ( int i = intLastTextFieldTag ; i > intFirstTextFieldTag ; i-- )
        {
            if ( ((UITextField*)[self.view viewWithTag:intLastTextFieldTag]).enabled == YES )
            {
                break;
            }
            
            intLastTextFieldTag--;
        }
        
        [(SHBTextField *)curTextField enableAccButtons:curTextField.tag == intFirstTextFieldTag ? NO : YES Next:curTextField.tag == intLastTextFieldTag ? NO : YES];
        
        if([curTextField respondsToSelector:@selector(focusSetWithLoss:)])
        {
            [(SHBTextField *)curTextField focusSetWithLoss:YES];
        }
        
        CGRect textFieldRect = [textField convertRect:textField.bounds toView:self.contentScrollView];
        int changeHeight = AppInfo.isiPhoneFive ? 548 : 460;
        changeHeight -= self.contentScrollView.frame.origin.y;
        if([curTextField isKindOfClass:[SHBSecureTextField class]])
        {
            if(((SHBSecureTextField *)curTextField).keyboardType == 0)
            {// 숫자키패드
                changeHeight -= 260;
            }
            else
            {// 문자키패드
                changeHeight -= 284;
            }
        }
        else
        {
            changeHeight -= 256;
        }
        
        textFieldRect.origin.y -= (changeHeight - textFieldRect.size.height);
        NSLog(@"textFieldRect.origin.y:%f",textFieldRect.origin.y);
        if(textFieldRect.origin.y < 0)
        {
            
            //ios7 + xcode5 대응
            //if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1 && textFieldRect.origin.y < -20)
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
            {
                //NSLog(@"height:%f",[UIScreen mainScreen].bounds.size.height);
                //if ([SHBUtility isFindString:[SHBUtilFile getModel] find:@"iPhone 5"] && [curTextField isKindOfClass:[SHBSecureTextField class]])
                if (([SHBUtility isFindString:[SHBUtilFile getModel] find:@"iPhone 5"] || [UIScreen mainScreen].bounds.size.height >= 568) && [curTextField isKindOfClass:[SHBSecureTextField class]])
                {
                    
                    textFieldRect.origin.y = 0;
                    //[self.contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y) animated:YES];
                    
                }else
                {
                    if (textFieldRect.origin.y < -64)
                    {
                        textFieldRect.origin.y = -20;
                        [self.contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y) animated:YES];
                        
                    }else
                    {
                        
                        [self.contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y) animated:YES];
                    }
                }
                
                
            }else
            {
                textFieldRect.origin.y = 0;
                [self.contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y) animated:YES];
            }
            offset.y = textFieldRect.origin.y;
            
            
        } else
        {
            
            if (self.navigationController.navigationBarHidden)
            {
                NSLog(@"textFieldRect.origin.y:%f",textFieldRect.origin.y);
                [self.contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y) animated:YES];
                
                
            } else
            {
                [self.contentScrollView setContentOffset:CGPointMake(0, textFieldRect.origin.y + 44) animated:YES];
            }
            offset.y = textFieldRect.origin.y;
        }
        
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.contentSize.width, contentViewHeight + 260.0f);
        
        displayKeyboard = YES;
    }else
    {
        [super textFieldDidBeginEditing:(SHBTextField *)textField];
    }
}
#pragma mark - SHBSecureDelegate
- (void)secureTextFieldDidBeginEditing:(SHBSecureTextField *)textField{
    [super secureTextFieldDidBeginEditing:textField];
	
    if (!AppInfo.isiPhoneFive && (AppInfo.certProcessType != CertProcessTypeMoasignSign && AppInfo.certProcessType != CertProcessTypeSign))
    {
        self.certificateOIDAliasTitleLabel.hidden = YES;
        self.certificateOIDAliasLabel.hidden = YES;
        [self.subjectCNLabel setFrame:CGRectMake(60, 46, 245, 23)];
        self.notAfterTitle.hidden = YES;
        self.notAfterLabel.hidden = YES;
        self.issuerAliasTitleLabel.frame = self.notAfterTitle.frame;
        self.issuerAliasLabel.frame = self.notAfterLabel.frame;
    }
    

	if (AppInfo.certProcessType == CertProcessTypeNo || AppInfo.certProcessType == CertProcessTypeLogin || AppInfo.certProcessType == CertProcessTypeInFotterLogin || AppInfo.certProcessType == CertProcessTypeCopySmart || AppInfo.certProcessType == CertProcessTypeCopyQR || AppInfo.certProcessType == CertProcessTypeRenew || AppInfo.certProcessType == CertProcessTypeCopyPC)
    {
        self.confirmBtn.hidden = YES;
        self.cancelBtn.hidden = YES;
    }
}

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    //[super textField:textField didEncriptedVaule:value];

    if (!AppInfo.isiPhoneFive && (AppInfo.certProcessType != CertProcessTypeMoasignSign && AppInfo.certProcessType != CertProcessTypeSign))
    {
        self.certificateOIDAliasTitleLabel.hidden = NO;
        self.certificateOIDAliasLabel.hidden = NO;
        [self.subjectCNLabel setFrame:CGRectMake(60, 4, 245, 23)];
        self.notAfterTitle.hidden = NO;
        self.notAfterLabel.hidden = NO;
        self.issuerAliasTitleLabel.frame = CGRectMake(60, 25, 50, 21);
        self.issuerAliasLabel.frame = CGRectMake(115, 25, 190, 21);
    }

    
    //만료 30일전이면 알럿을 뛰우고 로그인 시킨다
    
    //Debug(@"EncriptedVaule: %@", value);
    //@"<E2K_CHAR="
    //기획안에 따라 무조건 로그인 시킨다.
    NSLog(@"Appinfo.CertProcessType:%i",AppInfo.certProcessType);
    if (AppInfo.certProcessType == CertProcessTypeLogin || AppInfo.certProcessType == CertProcessTypeCopyPC || AppInfo.certProcessType == CertProcessTypeInFotterLogin || AppInfo.certProcessType == CertProcessTypeCopySmart || AppInfo.certProcessType == CertProcessTypeRenew || AppInfo.certProcessType == CertProcessTypeCopyQR || AppInfo.certProcessType == CertProcessTypeMoasignLogin || AppInfo.certProcessType == CertProcessTypeMoasignSign || AppInfo.certProcessType ==CertProcessTypeCopySHCard || AppInfo.certProcessType == CertProcessTypeCopySHInsure || AppInfo.certProcessType ==CertProcessTypeCopySHCardEasyPay)
    {
        //encryptPwd = [encryptPwd initWithFormat:@"<E2K_CHAR=%@>", value];
        //        if ([textField.text isEqualToString:@""] || textField.text == nil) {
        //            return;
        //        }
        //        if (dDay < 30)
        //        {
        //            self.encryptPwd = [NSString stringWithFormat:@"<E2K_CHAR=%@>", value];
        //            NSArray *tmpArray = [self.notAfterLabel.text componentsSeparatedByString:@"-"];
        //            NSString *msg = [NSString stringWithFormat:@"선택한 인증서의 만료일은\n%@년%@월%@일 23시59분 입니다.\n(만료%i일전)\n인증서 만료 전에 기존인증서를\n갱신하시기 바랍니다.\n당행인증서는 신한S뱅크의\n공인인증센터에서 갱신가능하며,\n타행인증서는 해당기관의\n인터넷뱅킹에서 갱신가능합니다.",[tmpArray objectAtIndex:0],[tmpArray objectAtIndex:1],[tmpArray objectAtIndex:2],dDay];
        //            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:9876 title:@"" message:msg];
        //            return;
        //        }
        
        AppInfo.eccData = aData;
        self.encryptPwd = [NSString stringWithFormat:@"<E2K_CHAR=%@>", value];
        [self confirmAction:nil];
    }
    
}

- (void)afterLoginProcess{
    
    AppInfo.loginCertificate = AppInfo.selectedCertificate;
    if ([AppInfo.userInfo[@"블랙리스트차단구분"] isEqualToString:@"4"])
    //if ([AppInfo.userInfo[@"블랙리스트차단구분"] isEqualToString:@""])
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
    
    if (![AppInfo.ssnForIDPWD isEqualToString:@""])
    {
        NSLog(@"AppInfo.ssnForIDPWD:%@",AppInfo.ssnForIDPWD);
        NSLog(@"AppInfo.juminNO:%@",[AppInfo getPersonalPK]);
        //if (![AppInfo.ssnForIDPWD isEqualToString:AppInfo.ssn])
        if (![AppInfo.ssnForIDPWD isEqualToString:[AppInfo getPersonalPK]])
        {
            
            [AppInfo differentUserAlert];
        }
    }
    
	if (!isSignupProcess){
		
        
		if (AppInfo.certProcessType == CertProcessTypeInFotterLogin){
			[AppDelegate.navigationController fadePopToRootViewController];
            
			//사기예방 동의체크
            if (![self checkTrickAgree])
            {
                //동의를 안했으면 동의 화면으로 이동하고 다음로직 연결을 중지한다.
                return;
            }
        
		} else{
			
			if (AppInfo.certProcessType == CertProcessTypeLogin)
			{
				AppInfo.certProcessType = CertProcessTypeNo;
			}
			BOOL isManageView = NO;
			BOOL isLoginView = NO;
			int viewCnt = [[AppDelegate.navigationController viewControllers] count];
			//NSLog(@"AppDelegate.navigationController viewControllers:%@",AppDelegate.navigationController.viewControllers);
			if (viewCnt > 2){
				if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:viewCnt - 2] class] == [NSClassFromString(@"SHBCertManageViewController") class]){
					isManageView = YES;
				}
				if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:viewCnt - 2] class] == [NSClassFromString(LOGIN_CLASS) class]){
					isLoginView = YES;
				}
				if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:viewCnt - 3] class] == [NSClassFromString(LOGIN_CLASS) class]){
					isLoginView = YES;
				}
			}
			
			[AppDelegate.navigationController fadePopViewController];   // 인증서 상세.
			
			if (isManageView)
            {
                [AppDelegate.navigationController fadePopViewController];   // 인증서 목록
            }
				
			
			if (isLoginView)
            {
                [AppDelegate.navigationController fadePopViewController];   // loginview.
            }
				
			
            //NSLog(@"AppDelegate.navigationController viewControllers:%@",AppDelegate.navigationController.viewControllers);
            //인증서 상세. 인증서 목록. loginview 를 팝하고도 현재 떠있는 뷰컨트롤러의 개수가 2개 이상일경우 중간단계에서 로그인
            //하였으므로 로그인을 시도한 뷰컨틑로러의 퀵메뉴를 로그인으로 교체한다, 메인뷰는 제외한다.
            if ([[AppDelegate.navigationController viewControllers] count] > 1)
            {
                for (int i = 1; i < [[AppDelegate.navigationController viewControllers] count]; i++)
                {
                    if ([[[AppDelegate.navigationController viewControllers] objectAtIndex:i] respondsToSelector:@selector(changeQuickLogin:)]) {
                        [[[AppDelegate.navigationController viewControllers] objectAtIndex:i] changeQuickLogin:YES];
                        
                    }
                }
            }
            
            //사기예방 동의체크
            if (![self checkTrickAgree])
            {
                //동의를 안했으면 동의 화면으로 이동하고 다음로직 연결을 중지한다.
                return;
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
            
			else {
                if (!AppInfo.isWebSSOLogin)
                {
                    //로그인 후 로그인 관련 뷰로 가는것 없다...
                    NSLog(@"AppInfo.lastViewController class:%@",NSStringFromClass([AppInfo.lastViewController class]));
                    
                    
                    if (![NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBLoginViewController"] && ![NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBCertManageViewController"] && ![NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBCertDetailViewController"] && ![NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBCertMovePhoneViewController"] && ![NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBCertCopyQRViewController"])
                    {
                        //NSLog(@"AppInfo.lastViewController:%@",NSStringFromClass([AppInfo.lastViewController class]));
                        //푸시할 뷰컨트롤러와 배열에 있는 마지막 뷰가 같은면 푸시하지 않는다.
                        if ([AppInfo.lastViewController class] != [AppDelegate.navigationController.viewControllers.lastObject class])
                        {
                            [AppDelegate.navigationController pushFadeViewController:AppInfo.lastViewController];
                        }
                    }
                
                }
				
				// 최근접속일자 표시
				//[(SHBBaseViewController*)AppInfo.lastViewController helloCustomer];
			}
		}
	}else{
        
        // 쿠폰에서 외화환전 직접 진입의 경우에 대한 처리
        if ([NSStringFromClass([AppInfo.lastViewController class]) hasPrefix:@"SHBForexRequest"])
        {
            // 해당 경우를 pass 할 수 있도록 값 변경
            isSignupProcess = NO;
            AppInfo.certProcessType = CertProcessTypeNo;
            [self afterLoginProcess];
            return;
            
        }
		[AppDelegate.navigationController fadePopToRootViewController];
		
        //사기예방 동의체크
        if (![self checkTrickAgree])
        {
            //동의를 안했으면 동의 화면으로 이동하고 다음로직 연결을 중지한다.
            return;
        }
	}
    
    //NSLog(@"AppInfo.ssnForIDPWD:%@",AppInfo.ssnForIDPWD);
    
//    if (![AppInfo.ssnForIDPWD isEqualToString:@""])
//    {
//        //if (![AppInfo.ssnForIDPWD isEqualToString:AppInfo.ssn])
//        if (![AppInfo.ssnForIDPWD isEqualToString:[AppInfo getPersonalPK]])
//        {
//            
//            [AppInfo differentUserAlert];
//        }
//    }
    
    
    //공인 인증서 로그인을 안하고 websso 연동하는경우
    if (AppInfo.isWebSSOLogin)
    {
        AppInfo.isWebSSOLogin = NO;
        [[SHBPushInfo instance] requestOpenURL:AppInfo.webSSOUrl SSO:YES];
    }
    
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
}

- (BOOL)checkTrickAgree
{
    AppInfo.isCheatDefanceAgree = YES;
    AppInfo.isOldPCRegister = YES;
    
    //* 전자금융 사기예방을 위해 통지 신청 불가 (해지는 가능) 14.03.17
    // 사기예방 동의 하는 화면으로 이동하고 다음로직은 중단한다.
    /*
    if ([[self.data objectForKey:@"사기예방동의여부"] isEqualToString:@"0"] )
    {
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
            return YES;
        }

        //구 사기예방서비스 변경동의
        SHBOldSecurityChangeViewController *regPwViewController = [[SHBOldSecurityChangeViewController alloc] initWithNibName:@"SHBOldSecurityChangeViewController" bundle:nil];
      
        
        [AppDelegate.navigationController pushFadeViewController:regPwViewController];
        [regPwViewController release];
        return NO;
    }
    
    else */
    if ([[self.data objectForKey:@"구PC등록동의여부"] isEqualToString:@"0"]){
        
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
             return YES;
        }

        //구PC등록동의여부
        
        SHBOldSecurityViewController *regPwViewController = [[SHBOldSecurityViewController alloc] initWithNibName:@"SHBOldSecurityViewController" bundle:nil];
    
        
        [AppDelegate.navigationController pushFadeViewController:regPwViewController];
        [regPwViewController release];
        return NO;
    }
    
    
     
    return YES;
}


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
	Debug(@"단말기 디바이스 토큰:%@",push.deviceToken);
	Debug(@"단말기 운영체제:%@",[[UIDevice currentDevice] systemVersion]);
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
    
    
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
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
    
	//self.service = [[SHBVersionService alloc] initWithServiceId:VERSION_INFO viewController:self];
    
    // release 처리
    self.service = nil;
	self.service = [[[SHBVersionService alloc] initWithServiceId:PHONE_INFO viewController:self] autorelease];
	self.service.previousData = forwardData;
    
        AppInfo.serviceCode = @"앱정보전송";
    
	
	[self.service start];
    
}

#pragma mark - SHBNetworkHandlerDelegate 메서드
- (void)client: (OFHTTPClient *) aClient didReceiveDataSet:(SHBDataSet *)aDataSet
{
    
#ifdef DEVELOPER_MODE
    [LPStopwatch stop:@"로그인 속도 계산"];
#endif
    
    if (processStep == 1)
    {
        AppInfo.isSSOLogin = NO;
        if ([[aDataSet objectForKey:@"스마트뱅킹가입상태"] isEqualToString:@"1"]){
            AppInfo.isSignupService = YES;
        } else
        {
            AppInfo.isRegisterAccountService = YES;
            [AppInfo logout];
            AppInfo.isSignupService = NO;
            AppInfo.phoneNumber = [aDataSet objectForKey:@"전화번호"];
            self.certPWTextField.text = @"";
            self.confirmBtn.hidden = NO;
            self.cancelBtn.hidden = NO;
            SHBBaseViewController *signViewController = [[[NSClassFromString(@"SHBSignupServiceStep1ViewController") class] alloc] initWithNibName:@"SHBSignupServiceStep1ViewController" bundle:nil];
            [self.navigationController pushFadeViewController:signViewController];
            [signViewController release];
            return;
        }
        
        self.data = aDataSet;
        Encryption *encryptor = [[Encryption alloc] init];
        // 로그인 정보 저장.
        AppInfo.userInfo = [NSMutableDictionary dictionaryWithDictionary:aDataSet];
        
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
        accountType = [aDataSet objectForKey:@"회원구분"];
        accountClass = [aDataSet objectForKey:@"고객회원등급"];
        
        AppInfo.isLogin = LoginTypeCert;
        
        
        // 하단의 퀵메뉴에 로그인,아웃 버튼 교체
        if (AppInfo.isSettingServiceView) {
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
        } else
        {
            //NSLog(@"aaaa:%@",[AppDelegate.navigationController viewControllers]);
            [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeQuickLogin:YES];
            if (([[aDataSet objectForKey:@"NEW_LETTER"] isEqualToString:@"Y"] || [[aDataSet objectForKey:@"NEW_COUPON"] isEqualToString:@"Y"]) && AppInfo.noticeState != 1)
            {
                AppInfo.noticeState = 2;
                [[[AppDelegate.navigationController viewControllers] objectAtIndex:0] changeBottmNotice:2];
            }
            
        }
		
        
        if (![AppInfo.userInfo[@"카드이용동의여부"] isEqualToString:@"Y"])
        {
            AppInfo.isCardAgree = NO;
        } else
        {
            AppInfo.isCardAgree = YES;
        }
        
        
        
        self.certPWTextField.text = @"";
        
        if (!AppInfo.isSignupService)
        {
            isSignupProcess = YES;
            SHBBaseViewController *signViewController = [[[NSClassFromString(@"SHBSignupServiceStep1ViewController") class] alloc] initWithNibName:@"SHBSignupServiceStep1ViewController" bundle:nil];
            [self.navigationController pushFadeViewController:signViewController];
            [signViewController release];
            return;
        }else
        {
            isSignupProcess = NO;
#if TARGET_IPHONE_SIMULATOR
			// 정상 로그인 후 처리사항
            
			[self afterLoginProcess];
#else
            
			//if ([[NSUserDefaults standardUserDefaults]pushFlag] == PUSH_IS_FIRST)
            if ([[NSUserDefaults standardUserDefaults]pushFlag] == PUSH_IS_FIRST)
            {
                //블랙리스트 ARS 인증
                
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
                
                // 정상 로그인 후 처리사항
                [self afterLoginProcess];
				
			}
#endif
        }
        
    } else if (processStep == 2)
    {
        
    }
}

- (BOOL) onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (processStep == 3)
    {
        [self delyStart];
        
    }else
    {
        #if !TARGET_IPHONE_SIMULATOR
//        if (isRequestInsPush){
//            // 핸드폰정보 서버 등록
//            [self requestInsertPhoneInfo];
//            
//        }else{
//            // 정상 로그인 후 처리사항
//            [self afterLoginProcess];
//        }
        
        // 정상 로그인 후 처리사항
        [self afterLoginProcess];
        #endif
    }

    return NO;
}

#pragma mark - UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[super alertView:alertView clickedButtonAtIndex:buttonIndex];
	
    if (alertView.tag == EXIT_ALERT_VIEW_TAG)
    {
        // 앱 종료.
        //exit(-1);
        [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
    }
    
	if (alertView.tag == TAG_PUSH_ALERT){
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
            
            // release 처리
            self.service = nil;
			self.service = [[[SHBVersionService alloc] initWithServiceId:TASK_INS_PUSH viewController:self] autorelease];
			self.service.previousData = forwardData;
            AppInfo.serviceCode = @"타이머블럭";
			[self.service start];
			
		}else{
			[[NSUserDefaults standardUserDefaults]setPushFlag:PUSH_NOT_USE];
			// 알림설정 서버에 등록
			SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
										@{
                                                               TASK_NAME_KEY : @"sfg.sphone.task.sbank.Sbank_info",
                                                             TASK_ACTION_KEY : @"updateSbankPushToken",
										@"고객번호" : AppInfo.customerNo,
										@"수신여부" : @"N",
										}] autorelease];
            
            // release 처리
            self.service = nil;
			self.service = [[[SHBVersionService alloc] initWithServiceId:TASK_INS_PUSH viewController:self] autorelease];
			self.service.previousData = forwardData;
            AppInfo.serviceCode = @"타이머블럭";
			[self.service start];
			
		}
		
	}else if (alertView.tag == 10)
    {
        if (remineCount < 1)
        	[self.navigationController fadePopToRootViewController];
		
    }
    else if (alertView.tag == 9876)
    {
        
        [self confirmAction:nil];
    }
    
    else if (alertView.tag == 1999997)
    {
        //[AppInfo logout];
		
        if (buttonIndex == 0)
        {
            if (AppInfo.certificateCount < 1)
            {
                SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
                [self.navigationController pushFadeViewController:viewController];
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
                [self.navigationController pushFadeViewController:certController];
                [certController release];
                
            }
            
        }
        
        else
        {
            [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
        }
        
        
        
    }
}

- (IBAction) pushIDPWDLoginView:(id)sender
{
    //[AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
    
    AppInfo.certProcessType = CertProcessTypeNo;
    SHBLoginViewController *viewController = [[SHBLoginViewController alloc] initWithNibName:@"SHBLoginViewController" bundle:nil];
    [AppDelegate.navigationController pushFadeViewController:viewController];
    [viewController release];
}

- (void)loginClose
{
    if (!AppInfo.isiPhoneFive)
    {
        self.certificateOIDAliasTitleLabel.hidden = NO;
        self.certificateOIDAliasLabel.hidden = NO;
        [self.subjectCNLabel setFrame:CGRectMake(60, 4, 245, 23)];
        self.notAfterTitle.hidden = NO;
        self.notAfterLabel.hidden = NO;
        self.issuerAliasTitleLabel.frame = CGRectMake(60, 25, 50, 21);
        self.issuerAliasLabel.frame = CGRectMake(115, 25, 190, 21);
    }

    
    self.confirmBtn.hidden = NO;
    self.cancelBtn.hidden = NO;
    //self.contentScrollView.scrollEnabled = YES;
    displayKeyboard = NO;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.contentScrollView setContentOffset:CGPointMake(0, -20) animated:NO];
    }else
    {
        [self.contentScrollView setContentOffset:CGPointZero animated:NO];
    }
    
}

#pragma mark - 모아싸인 델리게이트 콜백
- (void)finishSendCertificate:(NSString*)errorCode
{
    NSString *resultString = nil;
    if ([@"0" isEqualToString:errorCode]) {
        //인증서 데이터 전송처리와 동시에 제출처리 완료가 되므로 따로 처리를 호출할 필요가 없음.
        //화면위치 초기화
        [self.navigationController fadePopToRootViewController];
        //종료처리는 별도로 호출해야함
        [MoaSignSDK callbackWebPage];
        
    }else{
        resultString = [NSString stringWithFormat: @"인증서 제출에 실패하였습니다.\n(error code:%@)",errorCode];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"인증서 제출"
                              message:resultString
                              delegate:nil
                              cancelButtonTitle:@"확인"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];        // release 처리
    }
    
}

@end