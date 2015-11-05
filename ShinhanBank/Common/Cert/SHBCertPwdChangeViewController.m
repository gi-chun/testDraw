//
//  SHBCertPwdChangeViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertPwdChangeViewController.h"
#import "INISAFEXSafe.h"

@interface SHBCertPwdChangeViewController ()
{
    int reminCount;
}
- (int)runCheckPKeyPassword;
@end

@implementation SHBCertPwdChangeViewController

@synthesize subjectLabel;
@synthesize issuerAliasLabel;
@synthesize notAfterLabel;
@synthesize typeLabel;
@synthesize pwOldTextField, pwNewTextField, pwNewConfirmTextField;
@synthesize confirmBtn;
@synthesize certImageView;
@synthesize notAfterTitle;

@synthesize issuerAliasTitleLabel;
@synthesize certificateOIDAliasTitleLabel;
@synthesize pwdTitle1;
@synthesize pwdTitle2;
@synthesize pwdTitle3;
- (void) dealloc
{
    [certImageView release];
    [confirmBtn release];
    [subjectLabel release];
    [issuerAliasLabel release];
    [notAfterLabel release];
    [typeLabel release];
    [pwOldTextField release];
    [pwNewTextField release];
    [pwNewConfirmTextField release];
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
        [self setTitle:@"Certificate Management"];
        [self navigationBackButtonEnglish];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        [self setTitle:@"電子証明書管理"];
        [self navigationBackButtonJapnes];
    }else
    {
        [self setTitle:@"인증서 관리"];
        self.strBackButtonTitle = @"인증서 관리";
    }
    
    startTextFieldTag = 10;
    endTextFieldTag = 12;
    
    self.subjectLabel.text = AppInfo.selectedCertificate.user;
    self.issuerAliasLabel.text = AppInfo.selectedCertificate.issuer;
    self.typeLabel.text = AppInfo.selectedCertificate.type;
    self.notAfterLabel.text = AppInfo.selectedCertificate.expire;
    
    int dDay = [SHBUtility getDDay:self.notAfterLabel.text];
    //int dDay = [SHBUtility getDDay:@"2012-11-23"];
    
    //만료된 인증서인지 확인하고 이미지와 색깔을 바꿔준다.
    if (dDay < 0)
    {
        self.notAfterTitle.textColor = RGB(209, 75, 75);
        self.notAfterLabel.textColor = RGB(209, 75, 75);
        certImageView.image = [UIImage imageNamed:@"icon_certificate_expire.png"];
    }
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.issuerAliasTitleLabel.text = @"Issuer :";
        self.certificateOIDAliasTitleLabel.text = @"Type :";
        self.notAfterTitle.text = @"Expiration date :";
        [self.notAfterTitle setFrame:CGRectMake(self.notAfterTitle.frame.origin.x, self.notAfterTitle.frame.origin.y, 100.0f, self.notAfterTitle.frame.size.height)];
        [self.notAfterLabel setFrame:CGRectMake(170.0f, self.notAfterLabel.frame.origin.y, 100.0f, self.notAfterLabel.frame.size.height)];
        self.pwdTitle1.text = @"Existing PWD";
        self.pwdTitle2.text = @"New PWD";
        self.pwdTitle3.text = @"Confirm New PWD";
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.issuerAliasTitleLabel.text = @"発行者 :";
        self.certificateOIDAliasTitleLabel.text = @"区別 :";
        self.notAfterTitle.text = @"満了日 :";
        self.pwdTitle1.text = @"既存暗証番号";
        self.pwdTitle2.text = @"新しい暗証番号";
        self.pwdTitle3.text = @"新しい暗証番号再入力";
    }else
    {
        
    }
    // 보안키패드 띄우기.
    [self.pwOldTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:50];
    [self.pwNewTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:50];
    [self.pwNewConfirmTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:50];
    
    reminCount = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) changePassword:(id)sender
{
    NSString *msg;
    
    if (AppInfo.selectedCertificate.expired == 1)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"A digital certificate was expired.  You are not able to change a digital certificate which was already expired.";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"期間満了の電子証明書です。満了した電子証明書は暗証番号変更ができません。";
        }else
        {
            msg = @"만료된 인증서입니다.\n만료된 인증서는 암호변경을\n하실 수 없습니다.";
        }
       
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    //검증
    if (reminCount <= 0)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"You have entered an incorrect password in 5 times. If you would like to continue to use the service, please startover the step.";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"電子証明書のパスワード入力回数（５回）を超えました。続けてサービスをご利用の場合は最初からやり直してください。初期画面に移動します。";
        }else
        {
            msg = @"인증서 비밀번호 입력 오류 5회 초과하였습니다.";
        }
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        [self.navigationController fadePopToRootViewController];
        return;
    }
    if ([self.pwOldTextField.text length] == 0 )
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
          msg = @"Please enter the existing digital certificate password.";  
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
           msg = @"既存電子証明書のパスワードをご入力ください。"; 
        }else
        {
           msg = @"기존 인증서 비밀번호를 입력하여 주십시요."; 
        }
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    //인증서 비밀번호 체크
    if ([self runCheckPKeyPassword] != 0)
    {
        
        reminCount--;
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = [NSString stringWithFormat:@"You have entered an incorrect password. Please try again.\n(the number of remainning trials:%d)", reminCount];
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = [NSString stringWithFormat:@"選択された電子証明書のパスワードが違います。パスワードをもう一度ご入力ください。\n（%d残りの再入力回数）", reminCount];
        }else
        {
            msg = [NSString stringWithFormat:@"인증서 비밀번호를 잘못 입력하였습니다.\n(%d회 남음)", reminCount];
        }
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    if ([self.pwNewTextField.text length] < 8)
    {
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"The new digital certificate password must be 8 digits or longer and use exclusively English letters.";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"新しい電子証明書の暗証番号は英文を含めて8桁以上でご入力ください。";
        }else
        {
            msg = @"새 인증서 비밀번호는 영문을 포함하여 8자리 이상으로 입력하셔야 합니다.";
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    if (![SHBUtility isExistAlpabet:self.pwNewTextField.text])
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"The new digital certificate password must be 8 digits or longer and use exclusively English letters.";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"新しい電子証明書の暗証番号は英文を含めて8桁以上でご入力ください。";
        }else
        {
            msg = @"새 인증서 비밀번호는 영문을 포함하여 8자리 이상으로 입력하셔야 합니다.";
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
//    if (![SHBUtility isExistNumber:self.pwNewTextField.text])
//    {
//        msg = @"새 인증서 비밀번호 확인은 숫자를 포함하여 8자리 이상으로 입력하셔야 합니다.";
//        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
//        return;
//    }
    //3자리 연속된 문자 또는 숫자를 막는다
//    NSRange range = [@"tttkimtaeil" rangeOfString:@"([a-zA-Z0-9])\\1\\1" options:NSRegularExpressionSearch];
//    
//    if( range.location != NSNotFound )
//    {
//        msg = @"인증서 비밀번호는 동일문자로 입력 하실 수 없습니다.";
//        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
//        return;
//    }
    
    //NSString *numrange = @"1234567890234567890345678904567890567890678907890890";
    
    
    if (![self.pwNewTextField.text isEqualToString:pwNewConfirmTextField.text])
    {
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
           msg = @"The new digital certificate password has not successfully confirmed. Please enter the new password again."; 
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
           msg = @"新しい電子証明書の暗証番号と新しい暗証番号の再入力が一致していません。"; 
        }else
        {
           msg = @"새인증서 비밀번호와 새 인증서 비밀번호 확인이 일치하지 않습니다. 다시 한번 입력하여 주십시요."; 
        }
        self.pwNewTextField.text = nil;
        self.pwNewConfirmTextField.text = nil;
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
    }
    
    const char *now = [self.pwOldTextField.text UTF8String];
	const char *new1 = [self.pwNewTextField.text UTF8String];
    int ret = [AppInfo.selectedCertificate changePassword:(char*)now newPasswd:(char*)new1];
    
    if(ret != 0)
	{
		if(ret == -1)
        {
			msg = @"인증서 비밀번호 변경에 실패하였습니다.";
		}
		else if(ret == 1051027)
        {
            reminCount--;
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                msg = [NSString stringWithFormat:@"You have entered an incorrect password. Please try again.\n(the number of remainning trials:%d)", reminCount];
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                msg = [NSString stringWithFormat:@"選択された電子証明書のパスワードが違います。パスワードをもう一度ご入力ください。\n（%d残りの再入力回数）", reminCount];
            }else
            {
                msg = [NSString stringWithFormat:@"인증서 비밀번호를 잘못 입력하였습니다.\n(%d회 남음)", reminCount];
            }
            
		}
		else if(ret == -3)
        {
			msg = @"인증서 비밀번호 변경에 실패하였습니다.";
		}else
        {
            msg = @"인증서 비밀번호 변경에 실패하였습니다.";
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        
        pwNewTextField.text = nil;
        pwNewConfirmTextField.text = nil;
        pwOldTextField.text = nil;
        
	}
	else
    {
		
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
           msg = @"The certificate password has been successfully changed"; 
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
           msg = @"電子証明書パスワードが変更されました。"; 
        }else
        {
           msg = @"인증서 비밀번호가 변경되었습니다."; 
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg language:AppInfo.LanguageProcessType];
	}
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex:%i",alertView.tag);
    
    if (alertView.tag == 10) {
       [self.navigationController fadePopViewController];
    }

}

- (void)navigationButtonPressed:(id)sender
{
    AppInfo.certProcessType = CertProcessTypeManage;
    [super navigationButtonPressed:sender];
}

#pragma mark - 비밀번호 확인
- (int) runCheckPKeyPassword
{
    NSString *strPKeypass = self.pwOldTextField.text;
	
	int ret = -1;
	
    int nReturn = IXL_nFilterKeyCheck();
    if(nReturn == 0)
    {
        ret = IXL_CheckPOP([AppInfo.selectedCertificate index], AppInfo.eccData);
        
        if (ret == PKEY_PASSWORD_INCORRECT)
        {
            //평문으로 재검증
            ret = IXL_CheckPOP([AppInfo.selectedCertificate index], (char *)[strPKeypass UTF8String], (int)[strPKeypass length]);
        }
    }else
    {
        ret = IXL_CheckPOP([AppInfo.selectedCertificate index], (char *)[strPKeypass UTF8String], (int)[strPKeypass length]);
    }
	
	if(ret != 0){
		if(ret == CHECKVID_PARAM_ERROR){
			//msg = @"파라미터 오류";
             
		}
		else if(ret == PKEY_PASSWORD_INCORRECT){
            
            
            
            return -1;
		}
		else {
			//msg = @"인증서 가져오기 실패";
		}
		return -1;
	}
    
    return 0;
    
}

#pragma mark - SHBSecureDelegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    // !!!: 암호화된 비밀번호를 다시 포맷팅 하므로, 주의 할 것!
    //self.encriptedPassword = [NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX];
    if (textField == self.pwOldTextField)
    {
        AppInfo.eccData = aData;
    }
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
}

@end
