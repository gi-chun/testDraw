//
//  SHBCertIssueStep2ViewController.m
//  ShinhanBank
//
//  Created by RedDragon on 12. 11. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertIssueStep2ViewController.h"
#import "SHBMobileCertificateViewController.h"
#import "SHBCertIssueStep5CardViewController.h"
#import "SHBCertIssueStep5OtpViewController.h"
#import "SHBIdentity1ViewController.h"
#import "Encryption.h"

@interface SHBCertIssueStep2ViewController () <SHBIdentity1Delegate>
{
    int processStep;
    int secureFieldTag;
    
}
@end

@implementation SHBCertIssueStep2ViewController
@synthesize accountPwdTextField;
@synthesize ssnPwdTextField;
@synthesize accountTextField;
@synthesize encryptPwd;
@synthesize isFirstLoginSetting;
@synthesize encryptSsn;

- (void)dealloc
{
    [ssnPwdTextField release];
    [accountPwdTextField release];
    [accountTextField release];
    
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.accountPwdTextField.text = @"";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initField) name:@"mobileCertificateCancel" object:nil];
}
-(void) initField
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.accountTextField.text = @"";
    self.ssnPwdTextField.text = @"";
    self.accountPwdTextField.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [AppInfo logout]; //세션클리어
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//    {
//        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y - 20, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
//    }
    NSLog(@"self.contentScrollView.frame.origin.y:%f",self.contentScrollView.frame.origin.y);
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"Issue/ Reissue Digital Certificate";
        [self navigationBackButtonEnglish];
        //self.strBackButtonTitle = @"main menu";
    } else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"電子証明書の発行・再発行";
        [self navigationBackButtonJapnes];
        
    }else
    {
        self.title = @"인증서 발급/재발급";
        self.strBackButtonTitle = @"인증서 발급/재발급 2단계";
    }
   
    startTextFieldTag = 10;
    endTextFieldTag = 12;
    
    //[accountTextField setAccDelegate:self];
    [self.accountPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    [self.ssnPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:13];
    
    processStep = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) confirmClick:(id)sender //확인
{


    NSString *msg;
    if ([ssnPwdTextField.text length] < 13 || [ssnPwdTextField.text isEqualToString:@""] || ssnPwdTextField.text == nil)
    {
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Please enter the 13-digits Social Security number.";
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"じゅ身分証明書13桁を入力してください。";
        } else
        {
            msg = @"주민등록번호 13자리를 입력해 주십시요.";
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }

    if ([accountTextField.text length] < 11 || [accountTextField.text isEqualToString:@""] || accountTextField.text == nil)
    {
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Enter your withdrawal Account number in 11 to 12 characters.";
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"出金口座番号11-12桁をご入力ください。";
        } else
        {
            msg = @"출금계좌번호 11자에서 12자리를 입력해 주십시요.";
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    if ([accountPwdTextField.text length] < 4 || [accountPwdTextField.text isEqualToString:@""] || accountPwdTextField.text == nil)
    {
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Please enter your 4-digits account PIN.";
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"口座暗証番号４桁をご入力ください。";
        } else
        {
            msg = @"계좌비밀번호 4자리를 입력해 주십시요.";
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }

    /** 본인 확인을 한다 */
    processStep = 1;
    int tmpAcc = [[self.accountTextField.text substringWithRange:NSMakeRange(0,3)] intValue];
    if (tmpAcc == 180 || tmpAcc == 181) //외환계좌
    {
        NSDictionary *forwardDic =
        @{
        @"업무구분" : @"2",
        //@"실명번호" : self.ssnPwdTextField.text,
        @"실명번호" : self.encryptSsn,
        @"계좌번호" : self.accountTextField.text,
        @"비밀번호" : self.encryptPwd,
        @"증서" : @"1",
        @"은행구분" : @"1",
        };
        
        SendData(SHBTRTypeServiceCode, @"C2096", CERT_ISSUE_URL, self, forwardDic);
    }else
    {
        NSDictionary *forwardDic =
        @{
        @"출금계좌번호" : self.accountTextField.text,
        @"출금계좌비밀번호" : self.encryptPwd,
        //@"실명번호" : self.ssnPwdTextField.text,
        @"실명번호" : self.encryptSsn,
        };
        
        SendData(SHBTRTypeServiceCode, @"C2090", CERT_ISSUE_URL, self, forwardDic);
    }
    
    
}
- (IBAction) cancelClick:(id)sender //취소
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelBtnClick" object:nil];
    [self.navigationController fadePopViewController];
    
}

#pragma mark - 텍스트 필드 델리게이트
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    BOOL shouldReturn = YES;
    
    if (textField == self.accountTextField)
    {
        if ([string length] > 1)
        {
            return NO;
        }
        if ([self.accountTextField.text length] > 11 && [string length] != 0)
        {
            return NO;
        }
        //shouldReturn = NO;
    }
    
    return shouldReturn;
}
#pragma mark - SHBText
- (void)textFieldDidBeginEditing:(SHBTextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    secureFieldTag = textField.tag;
}

- (void)didCompleteButtonTouch      // 완료버튼
{
    [super didCompleteButtonTouch];
	[self.contentScrollView setContentOffset:CGPointZero];
}
#pragma mark - SHBSecureDelegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    secureFieldTag = textField.tag;
    // !!!: 암호화된 비밀번호를 다시 포맷팅 하므로, 주의 할 것!
    //self.encriptedPassword = [NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX];
    if (textField == self.accountPwdTextField)
    {
        self.encryptPwd = [NSString stringWithFormat:@"%@%@%@", @"<E2K_NUM=", value, @">"];
    }else if (textField == self.ssnPwdTextField)
    {
        self.encryptSsn = [NSString stringWithFormat:@"%@%@%@", @"<E2K_NUM=", value, @">"];
    }
    
}

- (void)secureTextFieldDidBeginEditing:(SHBSecureTextField *)textField
{
    
    [super secureTextFieldDidBeginEditing:textField];
    secureFieldTag = textField.tag;
}

- (IBAction) ssnBtnClick:(id)sender
{
    if (secureFieldTag == 11)
    {
        [super closeNormalPad:sender];
    }
    
    [self.ssnPwdTextField becomeFirstResponder];
    super.curTextField = self.ssnPwdTextField;
}
- (IBAction) accountPwdBtnClick:(id)sender
{
    if (secureFieldTag == 11)
    {
        [super closeNormalPad:sender];
    }
    [self.accountPwdTextField becomeFirstResponder];
    super.curTextField = self.accountPwdTextField;
}

#pragma mark - SHBNetworkHandlerDelegate 메서드
- (void)client: (OFHTTPClient *) aClient didReceiveDataSet:(SHBDataSet *)aDataSet
{
    if (processStep == 1)
    {
        if (AppInfo.errorType != nil)
        {
            self.accountPwdTextField.text = nil;
            return;
        } else
        {
            
            NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            versionNumber = [versionNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
            versionNumber = [NSString stringWithFormat:@"%@0",versionNumber];
            
            NSString *tocken;
            if ([[SHBPushInfo instance].deviceToken length] == 0)
            {
                tocken = @"";
            }else
            {
                tocken = [SHBPushInfo instance].deviceToken;
            }
            
            if ([[aDataSet objectForKey:@"고객번호"] length] == 9)
            {
                AppInfo.customerNo = [NSString stringWithFormat:@"0%@",[aDataSet objectForKey:@"고객번호"]];
            }else
            {
                AppInfo.customerNo = [aDataSet objectForKey:@"고객번호"];
            }
            AppInfo.commonDic = nil;
            AppInfo.commonDic = @{
            @"고객번호" : aDataSet[@"고객번호"],
            @"출금계좌번호" : aDataSet[@"출금계좌번호->originalValue"],
            //@"실명번호" : self.ssnPwdTextField.text,
            @"실명번호" : self.encryptSsn,
            //@"실명번호" : aDataSet[@"실명번호->originalValue"],
            //@"실명번호" : [encryptor aes128Encrypt:aDataSet[@"실명번호->originalValue"]],
            @"정책코드" : @"04",
            @"고객명"   :aDataSet[@"출금계좌성명"],
            //2014.09.30 추가
            @"모바일뱅킹번호" : @"01000000000",
            @"프록시서버PORT" : versionNumber, //앱의 버젼 정보를 넣으면 된다.
            @"deviceId" : [AppDelegate getSSODeviceID],
            @"APP_VERSION" :AppInfo.bundleVersion,
            @"OS_TYPE" : @"I",
            @"MACADDRESS1" :[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
            @"MACADDRESS2" :[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"],
            @"SBANK_SBANKVER":[NSString stringWithFormat:@"02 %@",AppInfo.bundleVersion],
            @"SBANK_PHONE_OS" : [SHBUtilFile getOSVersion],
            @"SBANK_PHONE_COM" :[SHBUtilFile getTelecomCarrierName],
            @"SBANK_PHONE_MODEL" :[SHBUtilFile getModel],
            @"SBANK_UID1" :[SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
            @"SBANK_MAC1" :[SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"],
            @"SBANK_TOKEN" : tocken,
            @"SBANK_PHONE_INFO" : [SHBUtilFile getResultSum:[NSString stringWithFormat:@"%@%@",PROTOCOL_HTTPS,AppInfo.serverIP] portNumber:443 connected:TRUE accessGroup:@"HQ59H9US6W.com.ktb.KeychainSuite"],
            };
            
            /*
            // TODO: 휴대폰인증화면
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
             
                SHBMobileCertificateViewController *viewController = [[SHBMobileCertificateViewController alloc]initWithNibName:@"SHBMobileCertificateViewControllerEng" bundle:nil];
                
                [self.navigationController pushFadeViewController:viewController];
                
                // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
                [viewController executeWithTitle:@"Issue/ Reissue Digital Certificate" Step:3 StepCnt:7 NextControllerName:nil];
                [viewController subTitle:@"own cell phone authentication" infoViewCount:MOBILE_INFOVIEW_1];
                [viewController setServiceSeq:SERVICE_CERT];
                //[self checkLoginBeforePushViewController:viewController animated:YES];
                
                [viewController release];
                
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                SHBMobileCertificateViewController *viewController = [[SHBMobileCertificateViewController alloc]initWithNibName:@"SHBMobileCertificateViewControllerJpn" bundle:nil];
                
                [self.navigationController pushFadeViewController:viewController];
                
                // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
                [viewController executeWithTitle:@"電子証明書の発行・再発行" Step:2 StepCnt:7 NextControllerName:nil];
                [viewController subTitle:@"本人携帯認証" infoViewCount:MOBILE_INFOVIEW_1];
                [viewController setServiceSeq:SERVICE_CERT];
                //[self checkLoginBeforePushViewController:viewController animated:YES];
                
                [viewController release];
                
            }else
            {
                
                AppInfo.transferDic = @{ @"서비스코드" : @"C1101" };
                
                SHBIdentity1ViewController *viewController = [[SHBIdentity1ViewController alloc]initWithNibName:@"SHBIdentity1ViewController" bundle:nil];
                [viewController setServiceSeq:SERVICE_CERT];
                viewController.delegate = self;

                [self.navigationController pushFadeViewController:viewController];
                
                // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
                [viewController executeWithTitle:@"인증서 발급/재발급" Step:2 StepCnt:7 NextControllerName:nil];
                [viewController subTitle:@"추가인증 방법 선택"];
                //[viewController setServiceSeq:SERVICE_CERT];
                [viewController release];
                
            }
            */
            processStep = 2;
            SendData(SHBTRTypeServiceCode, @"C1101", CERT_ISSUE_URL, self, AppInfo.commonDic);
        }
        
    } else if (processStep == 2)
    {
        
        //가입구분에 따라 다음 단계진입을 결정한다.
        if (![aDataSet[@"가입구분"] isEqualToString:@"0"])
        {
            NSString *msg = @"고객님의 경우 신한S뱅크를 통한 인증서발급이 불가능합니다.\n인터넷뱅킹을 통해 새로운 인증서를 발급해주십시오.";
            //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1907 title:@"" message:msg];
            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:1907 title:@"" message:msg language:AppInfo.LanguageProcessType];
            return;
        }
        
        self.data = aDataSet;
        // TODO: 휴대폰인증화면
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            
            SHBMobileCertificateViewController *viewController = [[SHBMobileCertificateViewController alloc]initWithNibName:@"SHBMobileCertificateViewControllerEng" bundle:nil];
            
            [self.navigationController pushFadeViewController:viewController];
            
            // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
            [viewController executeWithTitle:@"Issue/ Reissue Digital Certificate" Step:3 StepCnt:7 NextControllerName:nil];
            [viewController subTitle:@"own cell phone authentication" infoViewCount:MOBILE_INFOVIEW_1];
            [viewController setServiceSeq:SERVICE_CERT];
            //[self checkLoginBeforePushViewController:viewController animated:YES];
            
            [viewController release];
            
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            SHBMobileCertificateViewController *viewController = [[SHBMobileCertificateViewController alloc]initWithNibName:@"SHBMobileCertificateViewControllerJpn" bundle:nil];
            
            [self.navigationController pushFadeViewController:viewController];
            
            // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
            [viewController executeWithTitle:@"電子証明書の発行・再発行" Step:2 StepCnt:7 NextControllerName:nil];
            [viewController subTitle:@"本人携帯認証" infoViewCount:MOBILE_INFOVIEW_1];
            [viewController setServiceSeq:SERVICE_CERT];
            //[self checkLoginBeforePushViewController:viewController animated:YES];
            
            [viewController release];
            
        }else
        {
            
            AppInfo.transferDic = @{ @"서비스코드" : @"C1101" };
            
            SHBIdentity1ViewController *viewController = [[SHBIdentity1ViewController alloc]initWithNibName:@"SHBIdentity1ViewController" bundle:nil];
            [viewController setServiceSeq:SERVICE_CERT];
            viewController.delegate = self;
            viewController.secureMediaCode = aDataSet[@"보안카드매체구분"];
            [self.navigationController pushFadeViewController:viewController];
            
            // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
            [viewController executeWithTitle:@"인증서 발급/재발급" Step:2 StepCnt:7 NextControllerName:nil];
            [viewController subTitle:@"추가인증 방법 선택"];
            //[viewController setServiceSeq:SERVICE_CERT];
            [viewController release];
            
        }
        
        /*
        // 보안관련
        NSString *secutryType = [aDataSet objectForKey:@"보안카드매체구분"];
        

        if ([secutryType intValue] == 1)
        {           //보안카드
         
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                SHBCertIssueStep5CardViewController *viewController = [[SHBCertIssueStep5CardViewController alloc] initWithNibName:@"SHBCertIssueStep5CardViewControllerEng" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            } else if (AppInfo.LanguageProcessType == JapanLan)
            {
                SHBCertIssueStep5CardViewController *viewController = [[SHBCertIssueStep5CardViewController alloc] initWithNibName:@"SHBCertIssueStep5CardViewControllerJpn" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else
            {
                SHBCertIssueStep5CardViewController *viewController = [[SHBCertIssueStep5CardViewController alloc] initWithNibName:@"SHBCertIssueStep5CardViewController" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
        }
        else
        {
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                //OTP
                SHBCertIssueStep5OtpViewController *viewController = [[SHBCertIssueStep5OtpViewController alloc] initWithNibName:@"SHBCertIssueStep5OtpViewControllerEng" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            } else if (AppInfo.LanguageProcessType == JapanLan)
            {
                //OTP
                SHBCertIssueStep5OtpViewController *viewController = [[SHBCertIssueStep5OtpViewController alloc] initWithNibName:@"SHBCertIssueStep5OtpViewControllerJpn" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else
            {
                //OTP
                SHBCertIssueStep5OtpViewController *viewController = [[SHBCertIssueStep5OtpViewController alloc] initWithNibName:@"SHBCertIssueStep5OtpViewController" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
        }
        */
    }
}

-(void) viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic
{
    /*
    processStep = 2;
    SendData(SHBTRTypeServiceCode, @"C1101", CERT_ISSUE_URL, self, AppInfo.commonDic);
     */
    
    NSString *secutryType = [self.data objectForKey:@"보안카드매체구분"];
    
    
    if ([secutryType intValue] == 1)
    {           //보안카드
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            SHBCertIssueStep5CardViewController *viewController = [[SHBCertIssueStep5CardViewController alloc] initWithNibName:@"SHBCertIssueStep5CardViewControllerEng" bundle:nil];
            
            viewController.transDataSet = (SHBDataSet*)self.data;
            viewController.isFirstLoginSetting = self.isFirstLoginSetting;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            SHBCertIssueStep5CardViewController *viewController = [[SHBCertIssueStep5CardViewController alloc] initWithNibName:@"SHBCertIssueStep5CardViewControllerJpn" bundle:nil];
            
            viewController.transDataSet = (SHBDataSet*)self.data;
            viewController.isFirstLoginSetting = self.isFirstLoginSetting;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }else
        {
            SHBCertIssueStep5CardViewController *viewController = [[SHBCertIssueStep5CardViewController alloc] initWithNibName:@"SHBCertIssueStep5CardViewController" bundle:nil];
            
            viewController.transDataSet = (SHBDataSet*)self.data;
            viewController.isFirstLoginSetting = self.isFirstLoginSetting;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }
    else
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            //OTP
            SHBCertIssueStep5OtpViewController *viewController = [[SHBCertIssueStep5OtpViewController alloc] initWithNibName:@"SHBCertIssueStep5OtpViewControllerEng" bundle:nil];
            
            viewController.transDataSet = (SHBDataSet*)self.data;
            viewController.isFirstLoginSetting = self.isFirstLoginSetting;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            //OTP
            SHBCertIssueStep5OtpViewController *viewController = [[SHBCertIssueStep5OtpViewController alloc] initWithNibName:@"SHBCertIssueStep5OtpViewControllerJpn" bundle:nil];
            
            viewController.transDataSet = (SHBDataSet*)self.data;
            viewController.isFirstLoginSetting = self.isFirstLoginSetting;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }else
        {
            //OTP
            SHBCertIssueStep5OtpViewController *viewController = [[SHBCertIssueStep5OtpViewController alloc] initWithNibName:@"SHBCertIssueStep5OtpViewController" bundle:nil];
            
            viewController.transDataSet = (SHBDataSet*)self.data;
            viewController.isFirstLoginSetting = self.isFirstLoginSetting;
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1907)
    {
        //메인으로 이동
        [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
        
    }
}

#pragma mark - identity1 delegate
- (void)identity1ViewControllerCancel
{
    [self initField];
}

@end
