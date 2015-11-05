//
//  SHBSpotCertIssueStep1ViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 14. 6. 11..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSpotCertIssueStep1ViewController.h"
#import "SHBSpotCertIssueStep2ViewController.h"

@interface SHBSpotCertIssueStep1ViewController ()
{
    int processStep;
}
@end

@implementation SHBSpotCertIssueStep1ViewController
@synthesize encryptSsn;
@synthesize ssnPwdTextField;
@synthesize authCode1TextField;
@synthesize authCode2TextField;
@synthesize encryptAuthCode;
@synthesize authCodeTextField;

- (void)dealloc
{
    [authCodeTextField release];
    [encryptAuthCode release];
    [authCode1TextField release];
    [authCode2TextField release];
    [encryptSsn release];
    [ssnPwdTextField release];
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
    [self setTitle:@"인증서 발급/재발급"];
    
    startTextFieldTag = 10;
    endTextFieldTag = 11;
    
    contentViewHeight = self.contentScrollView.contentSize.height;
    [self.ssnPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:13];
    [self.authCodeTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:6];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction) ssnBtnClick:(id)sender
{
    
    [super closeNormalPad:sender];
    [self.ssnPwdTextField becomeFirstResponder];
    super.curTextField = self.ssnPwdTextField;
}
*/
- (IBAction)confirmClicked:(id)sender
{
    
    NSString *msg;
    if ([self.ssnPwdTextField.text length] < 13 || [self.ssnPwdTextField.text isEqualToString:@""] || self.ssnPwdTextField.text == nil)
    {
        
        msg = @"주민등록번호 13자리를 입력해 주십시요.";
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    //if ([self.authCode1TextField.text length] != 6)
    if ([self.authCodeTextField.text length] != 6)
    {
        msg = @"인증번호 6자리를 입력해 주십시요.";
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    processStep = 1;
    
    NSDictionary *forwardDic =
    @{
      @"서비스코드" : @"C1151",
      @"주민번호" : self.encryptSsn,
      //@"인증번호" : [NSString stringWithFormat:@"%@",self.authCode1TextField.text],
      @"인증번호" : self.encryptAuthCode,
      };
    
    SendData(SHBTRTypeServiceCode, @"E3031", CERT_ISSUE_URL, self, forwardDic);
}

- (IBAction)cancelClicked:(id)sender
{
    [AppDelegate.navigationController fadePopViewController];
}
#pragma mark - UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    //NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    /*
    if (textField == (UITextField *)self.authCode1TextField)
    {
        if ([textField.text length] >= 6 && range.length == 0)
        {
            return NO;
        }
    }
    */
    
    /*
    if (textField == (UITextField *)self.authCode1TextField)
    {
        if ([textField.text length] >= 3 && range.length == 0)
        {
            if ([textString length] <= 4)
            {
                textField.text = textString;
            }
            [super didNextButtonTouch];
            return NO;
        }
    }else if (textField == (UITextField *)self.authCode2TextField)
    {
        if ([textField.text length] >= 4 && range.length == 0)
        {
            return NO;
        }
    }
    */
    return YES;
}

#pragma mark - SHBSecureDelegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    // !!!: 암호화된 비밀번호를 다시 포맷팅 하므로, 주의 할 것!
    //self.encriptedPassword = [NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX];
    
    if (textField == self.ssnPwdTextField)
    {
        self.encryptSsn = [NSString stringWithFormat:@"%@%@%@", @"<E2K_NUM=", value, @">"];
    }else if (textField == self.authCodeTextField)
    {
        self.encryptAuthCode = [NSString stringWithFormat:@"%@%@%@", @"<E2K_NUM=", value, @">"];
    }
    
}

#pragma mark - SHBNetworkHandlerDelegate 메서드
- (void)client:(OFHTTPClient *)aClient didReceiveDataSet:(SHBDataSet *)aDataSet
{
    if (processStep == 1)
    {
        if (AppInfo.errorType != nil)
        {
            //
        }else
        {
            processStep = 2;
            
            NSDictionary *forwardDic =
            @{
              @"주민번호" : self.encryptSsn,
              };
            
            SendData(SHBTRTypeServiceCode, @"C1151", CERT_ISSUE_URL, self, forwardDic);
        }
    }else if (processStep == 2)
    {
        
         SHBSpotCertIssueStep2ViewController *viewController = [[SHBSpotCertIssueStep2ViewController alloc] initWithNibName:@"SHBSpotCertIssueStep2ViewController" bundle:nil];
         viewController.transDataSet = aDataSet;
         [self.navigationController pushFadeViewController:viewController];
         [viewController release];
        
    }
}
@end
