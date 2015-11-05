//
//  SHBCertIssueStep5CardViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 27..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertIssueStep5CardViewController.h"
#import "SHBCertIssueStep6ViewController.h"
#import "SHBCertIssueStep6ReViewController.h"
#import "Encryption.h"

@interface SHBCertIssueStep5CardViewController ()
{
    int secureFieldTag;
}
@end

@implementation SHBCertIssueStep5CardViewController
@synthesize accountTransferPwdTextField;
@synthesize secureCardSerialNO1TextField;
@synthesize secureCardSerialNO2TextField;
@synthesize secureCardSerialNO3TextField;
@synthesize secureCardSerialNO4TextField;
@synthesize secureCardSerialNO5TextField;
@synthesize secureCardSerialNO6TextField;
@synthesize secureCardSerialNO7TextField;
@synthesize secureCardSerialNO8TextField;
@synthesize frontLabel;
@synthesize frontNumberLabel;
@synthesize backLabel;
@synthesize backNumberLabel;
@synthesize accountEmailTextField;
@synthesize accountPhoneTextField;
@synthesize secureFrontLabel;
@synthesize encryptPwd1;
@synthesize encryptPwd2;
@synthesize encryptPwd3;
@synthesize frontNumTextField;
@synthesize backNumTextField;
@synthesize transDataSet;
@synthesize mainView;
@synthesize mark1ImageView;
@synthesize mark2ImageView;
@synthesize isFirstLoginSetting;
@synthesize nextSVC;

- (void) dealloc
{
    [nextSVC release];
    [mark1ImageView release];
    [mark2ImageView release];
    [encryptPwd1 release];
    [encryptPwd2 release];
    [encryptPwd3 release];
    [mainView release];
    [transDataSet release];
    [frontNumTextField release];
    [backNumTextField release];
    [secureFrontLabel release];
    [accountTransferPwdTextField release];
    [secureCardSerialNO1TextField release];
    [secureCardSerialNO2TextField release];
    [secureCardSerialNO3TextField release];
    [secureCardSerialNO4TextField release];
    [secureCardSerialNO5TextField release];
    [secureCardSerialNO6TextField release];
    [secureCardSerialNO7TextField release];
    [secureCardSerialNO8TextField release];
    [frontLabel release];
    [frontNumberLabel release];
    [backLabel release];
    [backNumberLabel release];
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
    endTextFieldTag = 17;
    
    self.contentScrollView.contentSize = CGSizeMake(317, 460);
    contentViewHeight = 460;
    
    [self.accountTransferPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:8];
    [self.secureCardSerialNO1TextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:1];
    [self.secureCardSerialNO2TextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:1];
    [self.secureCardSerialNO3TextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:1];
    [self.secureCardSerialNO4TextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:1];
    [self.secureCardSerialNO5TextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:1];
    [self.secureCardSerialNO6TextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:1];
    [self.secureCardSerialNO7TextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:1];
    [self.secureCardSerialNO8TextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:1];
    
    [self.frontNumTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:2];
    [self.backNumTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:2];
    
    [self.secureCardSerialNO1TextField setBackground:[UIImage imageNamed:@"securitycode.png"]];
    [self.secureCardSerialNO2TextField setBackground:[UIImage imageNamed:@"securitycode.png"]];
    [self.secureCardSerialNO3TextField setBackground:[UIImage imageNamed:@"securitycode.png"]];
    [self.secureCardSerialNO4TextField setBackground:[UIImage imageNamed:@"securitycode.png"]];
    [self.secureCardSerialNO5TextField setBackground:[UIImage imageNamed:@"securitycode.png"]];
    [self.secureCardSerialNO6TextField setBackground:[UIImage imageNamed:@"securitycode.png"]];
    [self.secureCardSerialNO7TextField setBackground:[UIImage imageNamed:@"securitycode.png"]];
    [self.secureCardSerialNO8TextField setBackground:[UIImage imageNamed:@"securitycode.png"]];
    
    
    [self.accountEmailTextField setAccDelegate:self];
    [self.accountPhoneTextField setAccDelegate:self];
    
    //이메일 주소
    if ([[transDataSet objectForKey:@"EMail주소"] length] > 0)
    {
        self.accountEmailTextField.text = self.transDataSet[@"EMail주소"];
        
    }
    //전화번호
    if ([[transDataSet objectForKey:@"전화번호"] length] > 0)
    {
        self.accountPhoneTextField.text = [self.transDataSet[@"전화번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
    }
    //보안카드 일련번호
    self.secureFrontLabel.text = [NSString stringWithFormat:@"%@,%@,%@",self.transDataSet[@"보안카드일련질의1"],self.transDataSet[@"보안카드일련질의2"],self.transDataSet[@"보안카드일련질의3"]];
    int i = 11;
    //보안카드 일련번호 배치
    for (SHBSecureTextField *subview in self.mainView.subviews)
    {
        
        if ([subview isKindOfClass:[SHBSecureTextField class]])
        {
            if ((subview.tag == [self.transDataSet[@"보안카드일련질의1"] intValue]) || (subview.tag == [self.transDataSet[@"보안카드일련질의2"] intValue]) || (subview.tag == [self.transDataSet[@"보안카드일련질의3"] intValue]))
            {
                subview.userInteractionEnabled = YES;
                [subview setBackground:[UIImage imageNamed:@"textfeld_nor.png"]];
                subview.tag = i;
                i++;
            } else
            {
                
                if (subview.tag >= 1 && subview.tag <= 8)
                {
                    subview.userInteractionEnabled = NO;
                    //subview.enabled = NO;
                    [subview setBackground:[UIImage imageNamed:@"securitycode.png"]];
                    [subview setDisabledBackground:[UIImage imageNamed:@"securitycode.png"]];
                    subview.tag = 1000;
                } else
                {
                    subview.userInteractionEnabled = YES;
                }
                
            }
        }
        
    }
    
    self.frontNumTextField.tag = 14;
    self.backNumTextField.tag = 15;
    self.accountEmailTextField.tag = 16;
    self.accountPhoneTextField.tag = 17;

    
//    if ([[transDataSet objectForKey:@"보안카드매체구분"] isEqualToString:@"1"])
//    {
//       self.frontLabel.text = @"세자리 중";
//       self.backLabel.text = @"세자리 중";
//       
//        mark1ImageView.hidden = YES;
//        mark2ImageView.hidden = YES;
//        [backNumTextField setFrame:CGRectMake(mark2ImageView.frame.origin.x + 2, backNumTextField.frame.origin.y, backNumTextField.bounds.size.width, backNumTextField.bounds.size.height)];
//    } else
//    {
//       self.frontLabel.text = @"네자리 중";
//       self.backLabel.text = @"네자리 중";
//    }

    if ([[transDataSet objectForKey:@"보안카드은행구분"] isEqualToString:@"S"])
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            self.frontLabel.text = @"Enter the first two digitss of the the 3-digits";
            self.backLabel.text = @"Enter the last two digitss of the the 3-digits";
            
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            self.frontLabel.text = @"3桁の中で前２つの数字";
            self.backLabel.text = @"3桁の中で後２つの数字";
        }else
        {
            self.frontLabel.text = @"세자리 중";
            self.backLabel.text = @"세자리 중";
        }
        
        
        mark1ImageView.hidden = YES;
        mark2ImageView.hidden = YES;
        [backNumTextField setFrame:CGRectMake(mark2ImageView.frame.origin.x + 2, backNumTextField.frame.origin.y, backNumTextField.bounds.size.width, backNumTextField.bounds.size.height)];
        
    } else if ([[transDataSet objectForKey:@"보안카드은행구분"] isEqualToString:@"C"] || [[transDataSet objectForKey:@"보안카드은행구분"] isEqualToString:@"N"])
    {
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            self.frontLabel.text = @"Enter the first two digitss of the the 4-digits ";
            self.backLabel.text = @"Enter the last two digitss of the the 4-digits ";
            
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            self.frontLabel.text = @"４桁の中で前２つの数字";
            self.backLabel.text = @"４桁の中で後２つの数字";
        }else
        {
            self.frontLabel.text = @"네자리 중";
            self.backLabel.text = @"네자리 중";
        }
    }
    else
    {
        
    }

    self.frontNumberLabel.text = self.transDataSet[@"COM_SEC_CHAL1"];
    self.backNumberLabel.text = self.transDataSet[@"COM_SEC_CHAL2"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSecureCardNumber) name:@"changeSecureCard" object:nil];
}

- (void)viewDidUnload
{
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
    NSString *secureCard1 = @"";
    NSString *secureCard2 = @"";
    NSString *secureCard3 = @"";
    
    for (SHBSecureTextField *subview in self.mainView.subviews)
    {
        if ([subview isKindOfClass:[SHBSecureTextField class]])
        {
            if (subview.tag == 11)
            {
                if (([subview.text length] < 1))
                {
                    
                    if (AppInfo.LanguageProcessType == EnglishLan)
                    {
                        msg = [NSString stringWithFormat:@"Please enter the [%@] th serial number",self.transDataSet[@"보안카드일련질의1"]];
                    }else if (AppInfo.LanguageProcessType == JapanLan)
                    {
                        msg = [NSString stringWithFormat:@"%@番目の一連番号をご入力ください。",self.transDataSet[@"보안카드일련질의1"]];
                    }else
                    {
                        msg = [NSString stringWithFormat:@"%@번째 일련번호를 입력해 주십시오.",self.transDataSet[@"보안카드일련질의1"]];
                    }
                    //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
                    [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
                    return;
                } else
                {
                    secureCard1 = subview.text;
                    //subview.text = @"";
                }
                
            }
            
            if (subview.tag == 12)
            {
                if (([subview.text length] < 1))
                {
                    
                    if (AppInfo.LanguageProcessType == EnglishLan)
                    {
                        msg = [NSString stringWithFormat:@"Please enter the [%@] th serial number",self.transDataSet[@"보안카드일련질의2"]];
                    }else if (AppInfo.LanguageProcessType == JapanLan)
                    {
                        msg = [NSString stringWithFormat:@"%@番目の一連番号をご入力ください。",self.transDataSet[@"보안카드일련질의2"]];
                    }else
                    {
                        msg = [NSString stringWithFormat:@"%@번째 일련번호를 입력해 주십시오.",self.transDataSet[@"보안카드일련질의2"]];
                    }
                    [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
                    return;
                } else
                {
                    secureCard2 = subview.text;
                    //subview.text = @"";
                }
                
            }
            
            if (subview.tag == 13)
            {
                if (([subview.text length] < 1))
                {
                    if (AppInfo.LanguageProcessType == EnglishLan)
                    {
                        msg = [NSString stringWithFormat:@"Please enter the [%@] th serial number",self.transDataSet[@"보안카드일련질의3"]];
                    }else if (AppInfo.LanguageProcessType == JapanLan)
                    {
                        msg = [NSString stringWithFormat:@"%@番目の一連番号をご入力ください。",self.transDataSet[@"보안카드일련질의3"]];
                    }else
                    {
                        msg = [NSString stringWithFormat:@"%@번째 일련번호를 입력해 주십시오.",self.transDataSet[@"보안카드일련질의3"]];
                    }
                    [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
                    return;
                } else
                {
                    secureCard3 = subview.text;
                    //subview.text = @"";
                }
                
            }
        }
    }
    
    
    if ([self.frontNumTextField.text length] < 2)
    {
       //msg = @"보안카드 첫번째 앞 두자리를 값을 입력하여 주십시오(2자리 입력)";
       //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Enter the first two digits of the security card";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"セキュリティカード前の2桁の数字をご入力ください（2桁入力）。";
        }else
        {
            msg = @"보안카드 첫번째 앞 두자리를 값을 입력하여 주십시오(2자리 입력)";
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
       return;
    }
    
    if ([self.backNumTextField.text length] < 2)
    {
        //msg = @"보안카드  두번째 뒤 두자리를 값을 입력하여 주십시오(2자리 입력)";
        //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Enter the last two digits of the  security card";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"セキュリティカード後の2桁の数字をご入力ください（2桁入力）。";
        }else
        {
            msg = @"보안카드  두번째 뒤 두자리를 값을 입력하여 주십시오(2자리 입력)";
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    NSString *eMail, *phone;
   
    
    //if (self.transDataSet[@"EMail주소"] == nil)
    if (self.accountEmailTextField.text == nil || [self.accountEmailTextField.text length] == 0)
    {
        eMail = @"";
    } else
    {
        
        //eMail = self.transDataSet[@"EMail주소"];
        eMail = self.accountEmailTextField.text;
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
    
   
    else if ([phone_1 isEqualToString:@"000"])
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

    else
    {
        
        
        //phone = self.transDataSet[@"전화번호"];
        phone = self.accountPhoneTextField.text;
        
    }
    //NSLog(@"1:%@, 2:%@, 3:%@",secureCard1,secureCard2,secureCard3);
    //NSLog(@"email:%@, phone:%@",self.transDataSet[@"보안카드은행구분"],self.transDataSet[@"전화번호"]);
    self.accountTransferPwdTextField.text = @"";
    self.backNumTextField.text = @"";
    self.frontNumTextField.text = @"";
    self.secureCardSerialNO1TextField.text = @"";
    self.secureCardSerialNO2TextField.text = @"";
    self.secureCardSerialNO3TextField.text = @"";
    self.secureCardSerialNO4TextField.text = @"";
    self.secureCardSerialNO5TextField.text = @"";
    self.secureCardSerialNO6TextField.text = @"";
    self.secureCardSerialNO7TextField.text = @"";
    self.secureCardSerialNO8TextField.text = @"";
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                           @"이체비밀번호" : self.encryptPwd1,
                           @"보안카드암호1" : self.encryptPwd2,
                           @"보안카드암호2" : self.encryptPwd3,
                           @"이체비밀번호구분" : @"1",
                           @"보안카드은행구분" : self.transDataSet[@"보안카드은행구분"],
                           @"보안카드일련질의1" : self.transDataSet[@"보안카드일련질의1"],
                           @"보안카드일련질의2" : self.transDataSet[@"보안카드일련질의2"],
                           @"보안카드일련질의3" : self.transDataSet[@"보안카드일련질의3"],
                           @"보안카드일련응답1" : secureCard1,
                           @"보안카드일련응답2" : secureCard2,
                           @"보안카드일련응답3" : secureCard3,
                           @"EMail주소" : eMail,
                           @"전화번호" : phone,
                           }];
    
    
    dataSet.serviceCode = @"C1102";
    [self serviceRequest:dataSet];
    
    
}
- (IBAction) cancelClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelBtnClick" object:nil];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
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

#pragma mark - SHBText
- (void)textFieldDidBeginEditing:(SHBTextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    secureFieldTag = textField.tag;
    //가로 보안키패드를 막아야 될 경우 처리
    if (secureFieldTag == 16 || secureFieldTag == 17 || secureFieldTag == 10)
    {
        AppInfo.isLandScapeKeyPadBolck = NO;
    } else
    {
        AppInfo.isLandScapeKeyPadBolck = YES;
    }
}

#pragma mark - SHBSecureDelegate

- (IBAction) accountTransferClick:(id)sender
{
//    if (secureFieldTag == 16 || secureFieldTag == 17)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 16 || self.curTextField.tag == 17)
    {
        [super closeNormalPad:sender];
    }
    
    [self.accountTransferPwdTextField becomeFirstResponder];
    super.curTextField = self.accountTransferPwdTextField;
}
- (IBAction) secureCardSerialNO1Click:(id)sender
{
//    if (secureFieldTag == 16 || secureFieldTag == 17)
//    {
//        [super closeNormalPad:sender];
//    }

    if (self.curTextField.tag == 16 || self.curTextField.tag == 17)
    {
        [super closeNormalPad:sender];
    }
    
    [self.secureCardSerialNO1TextField becomeFirstResponder];
    super.curTextField = self.secureCardSerialNO1TextField;
}
- (IBAction) secureCardSerialNO2Click:(id)sender
{
//    if (secureFieldTag == 16 || secureFieldTag == 17)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 16 || self.curTextField.tag == 17)
    {
        [super closeNormalPad:sender];
    }
    
    [self.secureCardSerialNO2TextField becomeFirstResponder];
    super.curTextField = self.secureCardSerialNO2TextField;
}
- (IBAction) secureCardSerialNO3Click:(id)sender
{
//    if (secureFieldTag == 16 || secureFieldTag == 17)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 16 || self.curTextField.tag == 17)
    {
        [super closeNormalPad:sender];
    }
    
    [self.secureCardSerialNO3TextField becomeFirstResponder];
    super.curTextField = self.secureCardSerialNO3TextField;
}
- (IBAction) secureCardSerialNO4Click:(id)sender
{
//    if (secureFieldTag == 16 || secureFieldTag == 17)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 16 || self.curTextField.tag == 17)
    {
        [super closeNormalPad:sender];
    }
    
    [self.secureCardSerialNO4TextField becomeFirstResponder];
    super.curTextField = self.secureCardSerialNO4TextField;
}
- (IBAction) secureCardSerialNO5Click:(id)sender
{
//    if (secureFieldTag == 16 || secureFieldTag == 17)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 16 || self.curTextField.tag == 17)
    {
        [super closeNormalPad:sender];
    }
    
    [self.secureCardSerialNO5TextField becomeFirstResponder];
    super.curTextField = self.secureCardSerialNO5TextField;
}
- (IBAction) secureCardSerialNO6Click:(id)sender
{
//    if (secureFieldTag == 16 || secureFieldTag == 17)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 16 || self.curTextField.tag == 17)
    {
        [super closeNormalPad:sender];
    }
    
    [self.secureCardSerialNO6TextField becomeFirstResponder];
    super.curTextField = self.secureCardSerialNO6TextField;
}
- (IBAction) secureCardSerialNO7Click:(id)sender
{
//    if (secureFieldTag == 16 || secureFieldTag == 17)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 16 || self.curTextField.tag == 17)
    {
        [super closeNormalPad:sender];
    }
    
    [self.secureCardSerialNO7TextField becomeFirstResponder];
    super.curTextField = self.secureCardSerialNO7TextField;
}
- (IBAction) secureCardSerialNO8Click:(id)sender
{
//    if (secureFieldTag == 16 || secureFieldTag == 17)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 16 || self.curTextField.tag == 17)
    {
        [super closeNormalPad:sender];
    }
    
    [self.secureCardSerialNO8TextField becomeFirstResponder];
    super.curTextField = self.secureCardSerialNO8TextField;
}
- (IBAction) frontNumClick:(id)sender
{
//    if (secureFieldTag == 16 || secureFieldTag == 17)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 16 || self.curTextField.tag == 17)
    {
        [super closeNormalPad:sender];
    }
    
    [self.frontNumTextField becomeFirstResponder];
    super.curTextField = self.frontNumTextField;
}
- (IBAction) backNumClick:(id)sender
{
//    if (secureFieldTag == 16 || secureFieldTag == 17)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 16 || self.curTextField.tag == 17)
    {
        [super closeNormalPad:sender];
    }
    
    [self.backNumTextField becomeFirstResponder];
    super.curTextField = self.backNumTextField;
}

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
    
    if (textField.tag == 14)
    {
        self.encryptPwd2 = [NSString stringWithFormat:@"%@%@%@", @"<E2K_NUM=", value, @">"];
    }
    
    if (textField.tag == 15)
    {
        self.encryptPwd3 = [NSString stringWithFormat:@"%@%@%@", @"<E2K_NUM=", value, @">"];
    }
}

#pragma mark - SHBNetworkHandlerDelegate 메서드
- (void)client: (OFHTTPClient *) aClient didReceiveDataSet:(SHBDataSet *)aDataSet
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
         }else if (AppInfo.LanguageProcessType == JapanLan)
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

- (void)changeSecureCardNumber
{
    Encryption *decryptor = [[Encryption alloc] init];
    //번호변경에 따른 방어코드
    if (![self.frontNumberLabel.text isEqualToString:[decryptor aes128Decrypt:AppInfo.secretChar1]])
    {
        self.frontNumberLabel.text = [decryptor aes128Decrypt:AppInfo.secretChar1];
    }
    
    if (![self.backNumberLabel.text isEqualToString:[decryptor aes128Decrypt:AppInfo.secretChar2]])
    {
        self.backNumberLabel.text = [decryptor aes128Decrypt:AppInfo.secretChar2];
    }
    [decryptor release];
}
@end
