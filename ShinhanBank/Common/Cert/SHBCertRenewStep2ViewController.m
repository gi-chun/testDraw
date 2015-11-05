//
//  SHBCertRenewStep2ViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertRenewStep2ViewController.h"
#import "SHBCertRenewStep3CardViewController.h"
#import "SHBCertRenewStep3OtpViewController.h"
#import "INISAFEXSafe.h"

@interface SHBCertRenewStep2ViewController ()
{
    int processStep;
    int secureFieldTag;
}
@end

@implementation SHBCertRenewStep2ViewController
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
    processStep = 0;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initField) name:@"cancelBtnClick" object:nil];
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
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"Certificate renewal";
        [self navigationBackButtonEnglish];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"電子証明書更新";
        [self navigationBackButtonJapnes];
    }else
    {
        self.title = @"인증서 갱신";
        self.strBackButtonTitle = @"인증서 갱신 2단계";
    }
    [accountTextField setAccDelegate:self];
    [self.accountPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    [self.ssnPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:13];
    
    processStep = 0;
    startTextFieldTag = 10;
    endTextFieldTag = 12;
    
    //NSLog(@"signdata:%@",self.signDataString);
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
        AppInfo.certProcessType = CertProcessTypeRenew;
        SendData(SHBTRTypeServiceCode, @"C2096", CERT_RENEW_URL, self, forwardDic);
        
    }else
    {
        NSDictionary *forwardDic =
        @{
        @"출금계좌번호" : self.accountTextField.text,
        @"출금계좌비밀번호" : self.encryptPwd,
        //@"실명번호" : self.ssnPwdTextField.text,
        @"실명번호" : self.encryptSsn,
        //@"PKCS7SignedData" : [AppInfo.signedData substringFromIndex:16],
        };
        AppInfo.certProcessType = CertProcessTypeRenew;
        SendData(SHBTRTypeServiceCode, @"C2090", CERT_RENEW_URL, self, forwardDic);
    }
     
    
}

- (IBAction) cancelClick:(id)sender //취소
{
    [self.navigationController fadePopViewController]; //인증서 목록
    [self.navigationController fadePopViewController]; //인증서 상세
    [self.navigationController fadePopViewController]; //자신
}

#pragma mark - SHBText
- (void)textFieldDidBeginEditing:(SHBTextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    secureFieldTag = textField.tag;
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


#pragma mark - SHBSecureDelegate

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
        secureFieldTag = 10;
    }
    
    [self.ssnPwdTextField becomeFirstResponder];
    //super.curTextField = self.ssnPwdTextField;
}
- (IBAction) accountPwdBtnClick:(id)sender
{
    if (secureFieldTag == 11)
    {
        [super closeNormalPad:sender];
        secureFieldTag = 12;
    }
    [self.accountPwdTextField becomeFirstResponder];
    //super.curTextField = self.accountPwdTextField;
}

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    secureFieldTag = textField.tag;
    //super.curTextField = textField;
    
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
            processStep = 2;
            //C1301 보낸다

            
            NSDictionary *forwardDic =
            @{
            @"출금계좌번호" : aDataSet[@"출금계좌번호->originalValue"],
            @"고객번호" : aDataSet[@"고객번호"],
            //@"실명번호" : aDataSet[@"실명번호->originalValue"],
            //@"실명번호" : self.ssnPwdTextField.text,
            @"실명번호" : self.encryptSsn,
            @"정책코드" : @"04",
            };


            SendData(SHBTRTypeServiceCode, @"C1301", CERT_ISSUE_URL, self, forwardDic);

        }
        
    } else if (processStep == 2)
    {
    
        //가입구분에 따라 다음 단계진입을 결정한다.
        if (![aDataSet[@"가입구분"] isEqualToString:@"0"])
        {
            NSString *msg;
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                msg = @"The certificate you have submitted isn't availible to renew in the Shinhan S bank service.Please check the certificate issuer and type.It is only possible to update digital certificates issued by Shinhan Bank Financial Telecommunications and Clearings Institute.The certificate you have submitted isn't availible to renew in the Shinhan S bank service.";
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                msg = @"電送された電子証明書は新韓Sバンクで更新できません。電子証明書発行機関及び種類をご確認ください。当行から発行した金融決済院の電子証明書のみ更新できます。";
            }else
            {
                msg = @"고객님의 경우 신한S뱅크를 통한 인증서갱신이 불가능합니다.\n인터넷뱅킹을 통해 거래해주십시오.";
            }
            
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1906 title:@"" message:msg];
            return;
        }
        
        // 보안관련
        NSString *secutryType = [aDataSet objectForKey:@"보안카드매체구분"];
                
        if ([secutryType intValue] == 1)
        {           //보안카드
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                SHBCertRenewStep3CardViewController *viewController = [[SHBCertRenewStep3CardViewController alloc] initWithNibName:@"SHBCertRenewStep3CardViewControllerEng" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                SHBCertRenewStep3CardViewController *viewController = [[SHBCertRenewStep3CardViewController alloc] initWithNibName:@"SHBCertRenewStep3CardViewControllerJpn" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else
            {
                SHBCertRenewStep3CardViewController *viewController = [[SHBCertRenewStep3CardViewController alloc] initWithNibName:@"SHBCertRenewStep3CardViewController" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
            
            
        }
        else
        {           //OTP
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                SHBCertRenewStep3OtpViewController *viewController = [[SHBCertRenewStep3OtpViewController alloc] initWithNibName:@"SHBCertRenewStep3OtpViewControllerEng" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                SHBCertRenewStep3OtpViewController *viewController = [[SHBCertRenewStep3OtpViewController alloc] initWithNibName:@"SHBCertRenewStep3OtpViewControllerJpn" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else
            {
                SHBCertRenewStep3OtpViewController *viewController = [[SHBCertRenewStep3OtpViewController alloc] initWithNibName:@"SHBCertRenewStep3OtpViewController" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
            
            
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag == 1906)
    {
        //메인으로 이동
        [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
        
    }
    
    
}
@end
