//
//  SHBSpotCertIssueStep2ViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 14. 6. 12..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBCertRenewStep4ViewController.h"
#import "SHBCertRenewStep5ViewController.h"
#import "SHBFirstLogInSettingType2ViewController.h"
#import "INISAFEXSafe.h"
#import "SHBCertManageViewController.h"
#import "SHBCertDetailViewController.h"

@interface SHBCertRenewStep4ViewController ()
{
    int certIndex;
    NSString *curNotBefore;
    NSMutableArray *certArray;
}

- (void) registerCert;
@end

@implementation SHBCertRenewStep4ViewController

@synthesize transDataSet;
@synthesize certPwdTextField;
@synthesize certPwdConfirmTextField;
@synthesize encryptCertPwd1;
@synthesize encryptCertPwd2;
@synthesize isFirstLoginSetting;
- (void) dealloc
{
    [encryptCertPwd1 release];
    [encryptCertPwd2 release];
    [transDataSet release];
    [certPwdConfirmTextField release];
    [certPwdTextField release];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppInfo.certProcessType = CertProcessTypeRenew;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AppInfo.certProcessType = CertProcessTypeNo;
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"Certificate renewal";
        [self navigationBackButtonEnglish];
        [self navigationBackButtonHidden];
    } else if(AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"Certificate renewal";
        [self navigationBackButtonEnglish];
        [self navigationBackButtonHidden];
    }else
    {
        self.title = @"인증서 갱신";
        self.strBackButtonTitle = @"인증서 갱신 4단계";
        [self navigationBackButtonHidden];
    }
    
    startTextFieldTag = 10;
    endTextFieldTag = 11;
    
    [self.certPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:30];
    [self.certPwdConfirmTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:30];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) confirmClick:(id)sender
{
    NSString *msg;
    if ([self.certPwdTextField.text length] < 10 || [self.certPwdTextField.text length] > 30)
    {
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"The new digital certificate password must be 8 digits or longer and use exclusively English letters.";
            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"新しい電子証明書の暗証番号は英文を含めて8桁以上でご入力ください。";
            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        }else
        {
            msg = @"인증서 암호의 길이는 반드시 10자리 이상\n30자리 이하로 설정해야 합니다.\n- 사용 불가 예: \"akdb19056\", \"q!235a\" 등\n올바른 사용 예) akc#r780814, akdb!(#%197, akdb!891akdo";
            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        }
        return;
    }
    
    //    if ([self.certPwdConfirmTextField.text length] < 10 || [self.certPwdConfirmTextField.text length] > 30)
    //    {
    //
    //
    //        if (AppInfo.LanguageProcessType == EnglishLan)
    //        {
    //            msg = @"The new digital certificate password must be 8 digits or longer and use exclusively English letters.";
    //            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
    //        } else if (AppInfo.LanguageProcessType == JapanLan)
    //        {
    //            msg = @"新しい電子証明書の暗証番号は英文を含めて8桁以上でご入力ください。";
    //            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
    //        }else
    //        {
    //            msg = @"인증서 암호의 길이는 반드시 10자리 이상\n30자리 이하로 설정해야 합니다.\n- 사용 불가 예: \"akdb19056\", \"q!235a\" 등\n올바른 사용 예) akc#r780814, akdb!(#%197, akdb!891akdo";
    //            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
    //        }
    //        return;
    //    }
    
    //이니텍 공인인증서 비밀강화 메서드 적용
    //영문자 포함 여부 체크
    const char *newPasswd = [self.certPwdTextField.text UTF8String];
    int newPasswdLen = strlen(newPasswd);
    int ret;
    ret = IXL_Check_AlphabetType((const unsigned char*)newPasswd, newPasswdLen);
    if (ret == IXL_NOK)
    {
        msg = @"인증서 암호는 숫자, 영문, 특수문자를\n반드시 포함하여 구성해야 합니다.\n(단, ('\"|₩\\ 사용 불가)\n사용 불가 예: \"akdbkgid\", \"10866899\" \"!@##$^%^&\" \"akdb5793\" 등\n올바른 사용 예) qw!r7808, q#e7!ppa, qwar&8890  등";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        return;
    }
    //숫자 포함여부 체크
    ret = IXL_Check_NumberType((const unsigned char*)newPasswd, newPasswdLen);
    if (ret == IXL_NOK)
    {
        msg = @"인증서 암호는 숫자, 영문, 특수문자를\n반드시 포함하여 구성해야 합니다.\n(단, ('\"|₩\\ 사용 불가)\n사용 불가 예: \"akdbkgid\", \"10866899\" \"!@##$^%^&\" \"akdb5793\" 등\n올바른 사용 예) qw!r7808, q#e7!ppa, qwar&8890  등";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        return;
    }
    //특수문자 포함여부 체크
    NSString *specialCharList = @"` ~!@#$%^&*()-=_+[]{};:,../<>?";
    ret = IXL_Check_SpecialCharType((const unsigned char*)newPasswd, newPasswdLen, specialCharList);
    if (ret == IXL_NOK)
    {
        msg = @"인증서 암호는 숫자, 영문, 특수문자를\n반드시 포함하여 구성해야 합니다.\n(단, ('\"|₩\\ 사용 불가)\n사용 불가 예: \"akdbkgid\", \"10866899\" \"!@##$^%^&\" \"akdb5793\" 등\n올바른 사용 예) qw!r7808, q#e7!ppa, qwar&8890  등";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        return;
    }
    
    if ([SHBUtility isFindString:self.certPwdTextField.text find:@"\\"] || [SHBUtility isFindString:self.certPwdTextField.text find:@"|"] || [SHBUtility isFindString:self.certPwdTextField.text find:@"\""] || [SHBUtility isFindString:self.certPwdTextField.text find:@"'"])
    {
        NSString *msg = @"일부 특수문자는\n사용이 불가능 합니다.('\"|₩\\)";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        return;
    }
    
    //    if (![SHBUtility isExistAlpabet:self.certPwdTextField.text])
    //    {
    //
    //        if (AppInfo.LanguageProcessType == EnglishLan)
    //        {
    //            msg = @"The new digital certificate password must be 8 digits or longer and use exclusively English letters.";
    //            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
    //        } else if (AppInfo.LanguageProcessType == JapanLan)
    //        {
    //            msg = @"新しい電子証明書の暗証番号は英文を含めて8桁以上でご入力ください。";
    //            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
    //        }else
    //        {
    //            msg = @"새 인증서 비밀번호는 영문을 포함하여 8자리 이상으로 입력하셔야 합니다.";
    //            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
    //        }
    //        return;
    //    }
    
    //    if (![SHBUtility isExistNumber:self.certPwdConfirmTextField.text])
    //    {
    //        msg = @"새 인증서 비밀번호 확인은 숫자를 포함하여 8자리 이상으로 입력하셔야 합니다.";
    //        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
    //        return;
    //    }
    //3자리 연속된 숫자나 문자를 막는다
    //    NSRange range = [@"tttkimtaeil" rangeOfString:@"([a-zA-Z0-9])\\1\\1" options:NSRegularExpressionSearch];
    //
    //    if( range.location != NSNotFound )
    //    {
    //        msg = @"인증서 비밀번호는 동일문자로 입력 하실 수 없습니다.";
    //        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
    //        return;
    //    }
    
    
    if (![self.certPwdTextField.text isEqualToString:self.certPwdConfirmTextField.text])
    {
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"The new digital certificate password has not successfully confirmed. Please enter the new password again.";
            self.certPwdTextField.text = nil;
            self.certPwdConfirmTextField.text = nil;
            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
            
        } else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"新しい電子証明書の暗証番号と新しい暗証番号の再入力が一致していません。";
            self.certPwdTextField.text = nil;
            self.certPwdConfirmTextField.text = nil;
            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
            
        }else
        {
            msg = @"새인증서 비밀번호와 새 인증서 비밀번호 확인이 일치하지 않습니다. 다시 한번 입력하여 주십시요.";
            self.certPwdTextField.text = nil;
            self.certPwdConfirmTextField.text = nil;
            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
            
        }
        return;
    }
    
    //[self registerCert];
    //[self show];
    
    
    
    [AppDelegate showProgressView];
    [self performSelector:@selector(registerCert) withObject:nil afterDelay:0.1];
}
- (IBAction) cancelClick:(id)sender
{
    
}

- (IBAction) secureGuide:(id)sender;
{
    //암호설정가이드 팝업뷰 뛰우기
}

- (void) registerCert
{
    
    //2014.09.29 qㅣ밀번호 변경 로직 추가
    NSString *msg = nil;
    const char *now = [AppInfo.certPlainPwd UTF8String];
    const char *new1 = [self.certPwdTextField.text UTF8String];
    
    int pret = [AppInfo.selectedCertificate changePassword:(char*)now newPasswd:(char*)new1];
    if(pret != 0)
	{
        msg = [NSString stringWithFormat: @"인증서 암호변경에 실패했습니다.(error code : %d)", pret];
        goto end;
    }
    //////////////////////////////////////
  	char *addr = NULL;
	char *port = NULL;
    char *pCAName = NULL;
	unsigned char *pPassword = NULL;
    //    unsigned char *pNewPassword = NULL;
    //	int canamelen = 0;
	char pDN[512] = {0x00,};
	int ret = -1;
    
    //    UIAlertView* alert;
	//package = [NSString stringWithFormat:@"INITECH_CA"];
    
    //2014.09.26 갱신시 비밀번호 입력 추가
	//NSString *password = AppInfo.certPlainPwd;
    NSString *password = self.certPwdTextField.text;
    
    //	NSString *newPassword = AppInfo.certPlainPwd;
    //[NSString stringWithFormat:@"qwer1234"];
    
    //int currentRow = [[certlistTable indexPathForSelectedRow] row];
    //CertificateInfo *certInfo = [listData objectAtIndex:currentRow];
    
    /**
     해쉬타입 취득 시작
     **/
    unsigned char *cert = NULL;
    int certlen = 0;
    unsigned char *priv_str = NULL;
    int priv_len = 0;
    
    ret = IXL_GetCertPkey([AppInfo.selectedCertificate index], &cert, &certlen, &priv_str, &priv_len);
    
    if (IXL_OK != ret) {
        if (GET_CERTPKEY_FROM_IPHONE_FAIL == ret) {
            msg = @"IPhone Keychain으로 부터 개인키&인증서 가져오기 실패*";
        }
        else if(IXL_MALLOC_ERROR == ret){
            msg = @"메모리 할당 실패";
        }
        else/*이외의 알 수 없는 오류*/
        {
            msg = [NSString stringWithFormat:@"error code:%d",ret];
        }
        goto end;
    }
    
    
    char *hash_alg = NULL;
    char *alg = NULL;
    
    IXL_Get_Cert_AlgorithmAndHash(1, cert, certlen, &alg, &hash_alg);
    
    if (IXL_OK != ret) {
        if (LOAD_X509_ERROR == ret) {
            /*X509 정보 파싱 실패*/
            msg = @"X509 정보 파싱 실패";
        }
        else if(MEMORY_ALLOCATE_ERROR == ret){
            /*메모리 할당 실패*/
            msg = @"메모리 할당 실패";
        }
        else/*이외의 알 수 없는 오류*/
        {
            msg = [NSString stringWithFormat:@"알고리즘 취득에 실패하였습니다. (error code:%d)",ret];
        }
        goto end;
    }
    
    
	// 공인인증서 갱신
    NSString *caName = [NSString stringWithFormat:@"YESSIGN"];
    NSString *address = [NSString stringWithFormat:@"203.233.91.71"];
    if ([AppInfo.serverIP isEqualToString:TEST_SERVER_IP])
    {
        address = [NSString stringWithFormat:@"203.233.91.231"];
    }
    
    NSString *portNo = [NSString stringWithFormat:@"4512"];
    
    addr = (char*)[address UTF8String];
    port = (char*)[portNo UTF8String];
    
    pCAName = (char*)[caName UTF8String];
    //    canamelen = [caName length];
    
    sprintf(pDN,"CAIP=%s&CAPORT=%s", addr, port);
    pPassword = (unsigned char*)[password UTF8String];
    //    pNewPassword = (unsigned char*)[newPassword UTF8String];
    
    
    int nReturn = IXL_nFilterKeyCheck();
    nReturn = -1;
    if(nReturn == 0)
    {
        ret =  IXL_Keychain_Update_Cert([AppInfo.selectedCertificate index], pCAName, pDN, AppInfo.eccData, AppInfo.eccData, hash_alg, (unsigned char*)"2048");
    }else
    {
        ret =  IXL_Keychain_Update_Cert([AppInfo.selectedCertificate index], pCAName, pDN, pPassword, pPassword, hash_alg, (unsigned char*)"2048");
    }
    
    [AppDelegate closeProgressView];
    if (IXL_OK == ret) {
        //msg = [NSString stringWithFormat: @"인증서 갱신이 성공했습니다."];
        
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            SHBCertRenewStep5ViewController *viewController = [[SHBCertRenewStep5ViewController alloc] initWithNibName:@"SHBCertRenewStep5ViewControllerEng" bundle:nil];
            viewController.title = @"Certificate renewal";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            SHBCertRenewStep5ViewController *viewController = [[SHBCertRenewStep5ViewController alloc] initWithNibName:@"SHBCertRenewStep5ViewControllerJpn" bundle:nil];
            viewController.title = @"電子証明書更新";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }else
        {
            SHBCertRenewStep5ViewController *viewController = [[SHBCertRenewStep5ViewController alloc] initWithNibName:@"SHBCertRenewStep5ViewController" bundle:nil];
            viewController.title = @"인증서 갱신";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }
        
        
    }
    else
    {
        AppInfo.isNfilterPK = NO;
        msg = [NSString stringWithFormat: @"암호 변경은 성공했으나\n인증서 갱신이 실패했습니다.(error code : %d)", ret];
    }
end:
    [AppDelegate closeProgressView];
    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:17659 title:@"" message:msg];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 17659)
    {
        
        [AppDelegate.navigationController fadePopToRootViewController];
    }
}



#pragma mark - SHBSecureDelegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    // !!!: 암호화된 비밀번호를 다시 포맷팅 하므로, 주의 할 것!
    //self.encriptedPassword = [NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX];
    if (textField.tag == 10)
    {
        self.encryptCertPwd1 = [NSString stringWithFormat:@"%@%@%@", @"<E2K_CHAR=", value, @">"];
        AppInfo.eccData = aData;
    }
    
    if (textField.tag == 11)
    {
        self.encryptCertPwd2 = [NSString stringWithFormat:@"%@%@%@", @"<E2K_CHAR=", value, @">"];
    }
}

@end
