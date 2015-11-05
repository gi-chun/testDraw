//
//  SHBCertRenewStep3OtpViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertRenewStep3OtpViewController.h"
#import "SHBCertRenewStep4ViewController.h"
#import "INISAFEXSafe.h"

@interface SHBCertRenewStep3OtpViewController ()
{
    int processStep;
    int secureFieldTag;
}
-(void) onUpdateCertificate;

@end

@implementation SHBCertRenewStep3OtpViewController
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
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (AppInfo.certProcessType == CertProcessTypeRenew)
    {
        AppInfo.certProcessType = CertProcessTypeNo;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
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
        self.strBackButtonTitle = @"인증서 갱신 3단계";
    }
    startTextFieldTag = 10;
    endTextFieldTag = 13;
    processStep = 0;
    
    
    [self.accountTransferPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:8];
    [self.accountOtpPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:6];
    
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

#pragma mark - SHBText
- (void)textFieldDidBeginEditing:(SHBTextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    secureFieldTag = textField.tag;
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
//    if (secureFieldTag == 12 || secureFieldTag == 13)
//    {
//        [super closeNormalPad:sender];
//    }
    
    if (self.curTextField.tag == 12 || self.curTextField.tag == 13)
    {
        [super closeNormalPad:sender];
    }
    
    [self.accountOtpPwdTextField becomeFirstResponder];
    super.curTextField = self.accountOtpPwdTextField;
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
    
    if (textField.tag == 11)
    {
        self.encryptPwd2 = [NSString stringWithFormat:@"%@%@%@", @"<E2K_NUM=", value, @">"];
    }
    
    
}

- (IBAction) confirmClick:(id)sender
{
    NSString *msg;
    AppInfo.certProcessType = CertProcessTypeRenew;
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
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                               @{
                               @"OTP카드암호" : self.encryptPwd2,
                               @"nextServiceCode" : @"C1302",
                               }] autorelease];
    
    SendData(SHBTRTypeServiceCode, @"C2079", GUEST_SERVICE_URL, self, forwardData);
    
}

- (IBAction) cancelClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelBtnClick" object:nil];
    AppInfo.certProcessType = CertProcessTypeRenew;
    [self.navigationController fadePopViewController]; //사용자 정보
    [self.navigationController fadePopViewController]; //자신
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
        
        
        dataSet.serviceCode = @"C1302";
        [self serviceRequest:dataSet];
        
    } else if (processStep == 2)
    {
        SHBCertRenewStep4ViewController *viewController = [[SHBCertRenewStep4ViewController alloc] initWithNibName:@"SHBCertRenewStep4ViewController" bundle:nil];
        
        viewController.title = @"인증서 갱신";
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
        
        //[self onUpdateCertificate];
       
    }

}

- (void) onUpdateCertificate
{
    
 	char *addr = NULL;
	char *port = NULL;
    char *pCAName = NULL;
	unsigned char *pPassword = NULL;
//    unsigned char *pNewPassword = NULL;
//	int canamelen = 0;
	char pDN[512] = {0x00,};
	int ret = -1;
    NSString *msg = nil;
//    UIAlertView* alert;
	//package = [NSString stringWithFormat:@"INITECH_CA"];
	NSString *password = AppInfo.certPlainPwd;
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
    
    if (IXL_OK == ret) {
        //msg = [NSString stringWithFormat: @"인증서 갱신이 성공했습니다."];
        
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            SHBCertRenewStep4ViewController *viewController = [[SHBCertRenewStep4ViewController alloc] initWithNibName:@"SHBCertRenewStep4ViewControllerEng" bundle:nil];
            viewController.title = @"Certificate renewal";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            SHBCertRenewStep4ViewController *viewController = [[SHBCertRenewStep4ViewController alloc] initWithNibName:@"SHBCertRenewStep4ViewControllerJpn" bundle:nil];
            viewController.title = @"電子証明書更新";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }else
        {
            SHBCertRenewStep4ViewController *viewController = [[SHBCertRenewStep4ViewController alloc] initWithNibName:@"SHBCertRenewStep4ViewController" bundle:nil];
            viewController.title = @"인증서 갱신";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }
        
        
    }
    else
    {
        AppInfo.isNfilterPK = NO;
        msg = [NSString stringWithFormat: @"인증서 갱신이 실패했습니다.(error code : %d)", ret];
    }
end:
    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:17659 title:@"" message:msg];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 17659)
    {
        
        [AppDelegate.navigationController fadePopToRootViewController];
    }
}
@end
