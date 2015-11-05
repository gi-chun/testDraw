//
//  SHBCertIssueStep5OtpViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 27..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertIssueStep5OtpViewController.h"
#import "SHBCertIssueStep6ViewController.h"
#import "SHBCertIssueStep6ReViewController.h"

@interface SHBCertIssueStep5OtpViewController ()
{
    int processStep;
    int secureFieldTag;
}
@end

@implementation SHBCertIssueStep5OtpViewController

@synthesize encryptPwd1;
@synthesize encryptPwd2;
@synthesize accountTransferPwdTextField;
@synthesize accountOtpPwdTextField;
@synthesize accountEmailTextField;
@synthesize accountPhoneTextField;
@synthesize transDataSet;
@synthesize isFirstLoginSetting;

- (void) dealloc
{
    [transDataSet release];
    [encryptPwd1 release];
    [encryptPwd2 release];
    [accountTransferPwdTextField release];
    [accountOtpPwdTextField release];
    [accountEmailTextField release];
    [accountPhoneTextField release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
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
        self.strBackButtonTitle = @"인증서 발급/재발급 5단계";
    }
    
    startTextFieldTag = 10;
    endTextFieldTag = 13;
    processStep = 0;
    [self.accountTransferPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:8];
    [self.accountOtpPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:6];
    
    //이메일 주소
    if ([[self.transDataSet objectForKey:@"EMail주소"] length] > 0)
    {
        self.accountEmailTextField.text = self.transDataSet[@"EMail주소"];
        
    }
    //전화번호
    if ([[self.transDataSet objectForKey:@"전화번호"] length] > 0)
    {
        self.accountPhoneTextField.text = [self.transDataSet[@"전화번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 텍스트 필드 델리게이트

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    BOOL shouldReturn = YES;
    
    if (textField == self.accountEmailTextField)
    {
        
        if ([self.accountEmailTextField.text length] > 49)
        {
            return NO;
        }
        //shouldReturn = NO;
    }
    
    if (textField == self.accountPhoneTextField)
    {
        
        if ([self.accountPhoneTextField.text length] > 19)
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

- (IBAction) accountTransferClick:(id)sender
{
//    if (secureFieldTag == 12 || secureFieldTag == 13)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 12 || self.curTextField.tag == 13)
    {
        [super closeNormalPad:sender];
    }
    
    [self.accountTransferPwdTextField becomeFirstResponder];
    super.curTextField = self.accountTransferPwdTextField;
}
- (IBAction) accountOtpPwdClick:(id)sender
{
    if (self.curTextField.tag == 12 || self.curTextField.tag == 13)
    {
        [super closeNormalPad:sender];
    }
    [self.accountOtpPwdTextField becomeFirstResponder];
    super.curTextField = self.accountOtpPwdTextField;
}

#pragma mark - SHBSecureDelegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    // !!!: 암호화된 비밀번호를 다시 포맷팅 하므로, 주의 할 것!
    //self.encriptedPassword = [NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX];
    //self.encryptPwd = [NSString stringWithFormat:@"%@%@%@", @"<E2K_NUM=", value, @">"];
    secureFieldTag = textField.tag;
    if (textField.tag == 10)
    {
        self.encryptPwd1 = [NSString stringWithFormat:@"%@%@%@", @"<E2K_CHAR=", value, @">"];
    }
    
    if (textField.tag == 11)
    {
        self.encryptPwd2 = [NSString stringWithFormat:@"%@%@%@", @"<E2K_NUM=", value, @">"];
    }
    
    
}

- (IBAction) confirmClick:(id)sender
{
    NSString *msg;
        
    if ([self.accountTransferPwdTextField.text length] < 6 || self.accountTransferPwdTextField.text == nil)
    {
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Please enter your6-8 digit transfer password.";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"振込暗証番号は6-8桁でご入力ください。";
        }else
        {
            msg = @"'이체 비밀번호'는 6~8 자리로 입력해야 합니다.";
        }
        //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    if ([self.accountOtpPwdTextField.text length] == 0)
    {
        //msg = @"'OTP번호'를 입력하여 주십시오.";
        //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"You shall enter 6 digit OTP code card.";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"OTP番号を6桁でご入力ください。";
        }else
        {
            msg = @"'OTP번호'를 입력하여 주십시오.";
        }
        //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    if ([self.accountOtpPwdTextField.text length] < 6 || self.accountTransferPwdTextField.text == nil)
    {
        //msg = @"'OPT번호'는 6자리로 입력해야 합니다.";
        //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"You shall enter 6 digit OTP code card.";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"OTP番号を6桁でご入力ください。";
        }else
        {
            msg = @"'OPT번호'는 6자리로 입력해야 합니다.";
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    
    //if (self.transDataSet[@"전화번호"] == nil)
    if (self.accountPhoneTextField.text == nil || [self.accountPhoneTextField.text length] == 0)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"전화번호를 입력하여주세요."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
        
    }
    
    NSString *phone_1 = [self.accountPhoneTextField.text substringWithRange:NSMakeRange(0, 3)];
    NSLog(@"phone_1 %@",phone_1);
    
    if ([self.accountPhoneTextField.text length] < 9 || [self.accountPhoneTextField.text length] > 12)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"전화번호는 9~12자리로 입력해야 합니다."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
    }
    
    
    if ([phone_1 isEqualToString:@"000"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"전화번호를 정확히 입력하여 주세요."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
    }
    
    
    processStep = 1;
    // release 처리
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                               @{
                               @"OTP카드암호" : self.encryptPwd2,
                               @"nextServiceCode" : @"C1102",
                               }] autorelease];
    
    SendData(SHBTRTypeServiceCode, @"C2079", GUEST_SERVICE_URL, self, forwardData);
    
}

- (IBAction) cancelClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelBtnClick" object:nil];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
}

#pragma mark - SHBNetworkHandlerDelegate 메서드
- (void)client: (OFHTTPClient *) aClient didReceiveDataSet:(SHBDataSet *)aDataSet
{
    
    
    if (processStep == 1)
    {
        processStep = 2;
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                               @"이체비밀번호" : self.encryptPwd1,
                               @"이체비밀번호구분" : @"A",
                               @"보안카드은행구분" : self.transDataSet[@"보안카드은행구분"],
                               @"TOTP응답값" : self.encryptPwd2,
                               @"EMail주소" : self.accountEmailTextField.text,
                               @"전화번호" : self.accountPhoneTextField.text,
                               }];
        
        
        dataSet.serviceCode = @"C1102";
        [self serviceRequest:dataSet];
        
    } else if (processStep == 2)
    {
        NSString *tmp = self.transDataSet[@"발급_재발급여부"];
        if ([tmp isEqualToString:@"1"])
        {
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                SHBCertIssueStep6ViewController *viewController = [[SHBCertIssueStep6ViewController alloc] initWithNibName:@"SHBCertIssueStep6ViewControllerEng" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                SHBCertIssueStep6ViewController *viewController = [[SHBCertIssueStep6ViewController alloc] initWithNibName:@"SHBCertIssueStep6ViewControllerJpn" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else
            {
                SHBCertIssueStep6ViewController *viewController = [[SHBCertIssueStep6ViewController alloc] initWithNibName:@"SHBCertIssueStep6ViewController" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
            
        } else
        {
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                SHBCertIssueStep6ReViewController *viewController = [[SHBCertIssueStep6ReViewController alloc] initWithNibName:@"SHBCertIssueStep6ReViewControllerEng" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else if (AppInfo.LanguageProcessType == EnglishLan)
            {
                SHBCertIssueStep6ReViewController *viewController = [[SHBCertIssueStep6ReViewController alloc] initWithNibName:@"SHBCertIssueStep6ReViewControllerJpn" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }else
            {
                SHBCertIssueStep6ReViewController *viewController = [[SHBCertIssueStep6ReViewController alloc] initWithNibName:@"SHBCertIssueStep6ReViewController" bundle:nil];
                
                viewController.transDataSet = aDataSet;
                viewController.isFirstLoginSetting = self.isFirstLoginSetting;
                [self.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
            
        }
    }
    
}

@end
