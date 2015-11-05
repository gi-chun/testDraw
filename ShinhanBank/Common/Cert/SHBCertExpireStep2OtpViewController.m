//
//  SHBCertExpireStep2OtpViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertExpireStep2OtpViewController.h"
#import "SHBCertExpireStep3ViewController.h"
#import "INISAFEXSafe.h"

@interface SHBCertExpireStep2OtpViewController ()
{
    int processStep;
    int secureFieldTag;
}
- (void) onRevokeCertificate;

@end

@implementation SHBCertExpireStep2OtpViewController
@synthesize encryptPwd1;
@synthesize encryptPwd2;
@synthesize accountTransferPwdTextField;
@synthesize accountOtpPwdTextField;
@synthesize accountEmailTextField;
@synthesize accountPhoneTextField;
@synthesize transDataSet;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppInfo.certProcessType = CertProcessTypeNo;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppInfo.certProcessType = CertProcessTypeRegOrExpire;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"Certificate revokation";
        [self navigationBackButtonEnglish];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"電子証明書削除";
        [self navigationBackButtonJapnes];
    }else
    {
        self.title = @"인증서 폐기";
        self.strBackButtonTitle = @"인증서 폐기 2단계";
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
    // release 처리
    SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                               @{
                               @"OTP카드암호" : self.encryptPwd2,
                               @"nextServiceCode" : @"C1202",
                               }] autorelease];
    
    SendData(SHBTRTypeServiceCode, @"C2079", GUEST_SERVICE_URL, self, forwardData);
    
}

- (IBAction) cancelClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelBtnClick" object:nil];
    [self.navigationController fadePopViewController];
}

#pragma mark - SHBNetworkHandlerDelegate 메서드
- (void)client: (OFHTTPClient *) aClient didReceiveDataSet:(SHBDataSet *)aDataSet
{
    
    
    if (processStep == 1) //otp 확인
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
        
        
        dataSet.serviceCode = @"C1202";
        [self serviceRequest:dataSet];
         
        
    } else if (processStep == 2)
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            SHBCertExpireStep3ViewController *viewController = [[SHBCertExpireStep3ViewController alloc] initWithNibName:@"SHBCertExpireStep3ViewControllerEng" bundle:nil];
            
            viewController.title = @"Certificate revokation";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            SHBCertExpireStep3ViewController *viewController = [[SHBCertExpireStep3ViewController alloc] initWithNibName:@"SHBCertExpireStep3ViewControllerJpn" bundle:nil];
            
            viewController.title = @"電子証明書削除";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }else
        {
            SHBCertExpireStep3ViewController *viewController = [[SHBCertExpireStep3ViewController alloc] initWithNibName:@"SHBCertExpireStep3ViewController" bundle:nil];
            
            viewController.title = @"인증서 폐기";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
        //[self onRevokeCertificate];
        
    }
    
    /*
     SHBCertExpireStep3ViewController *viewController = [[SHBCertExpireStep3ViewController alloc] initWithNibName:@"SHBCertExpireStep3ViewController" bundle:nil];
     
     viewController.title = @"인증서 폐기";
     [self.navigationController pushFadeViewController:viewController];
     [viewController release];*/
    
    
}

- (void) onRevokeCertificate
{
    //NSLog(@"dddd");
    //UIAlertView *alert = nil;
    //int alertTag = 0;
    NSString *msg = nil;
    //char *ref = NULL;
	//char *auth = NULL;
	//char *addr = NULL;
	//char *port = NULL;
    //char *pCAName = NULL;
	//char *pPassword = NULL;
	//int canamelen = 0;
	//int passwordlen = 0;
	//char pDN[512] = {0x00,};
	int ret = -1;
    
    //NSURL *theURL = [NSURL URLWithString:self.revokeURL];
    //request = [NSMutableURLRequest requestWithURL:theURL];
    
    //int currentRow = [[certificateListTable indexPathForSelectedRow] row];
    //CertificateInfo *certInfo = [certificateList objectAtIndex:currentRow];
    
    /********************
     * PEM타입의 인증서 취득
     *******************/
    unsigned char *pemCert_str = NULL;
    int pemCert_len = 0;
    
    ret = IXL_GetPEMCert([AppInfo.selectedCertificate index], 0, &pemCert_str, &pemCert_len);
    
    if (0 != ret) {
        if(GET_CERTPKEY_FROM_IPHONE_FAIL == ret)
        {
            ret = 942;  // 사용자 인증서 취득에 실패하였습니다.
            msg = [NSString stringWithFormat:@"error code:%d",ret];
        }
        else if(IXL_MALLOC_ERROR == ret)
        {
            ret = 943;  // 사용자 인증서 취득시 메모리 할당에 실패하였습니다.
            msg = [NSString stringWithFormat:@"error code:%d",ret];
        }
        else if(MEMORY_ALLOCATE_ERROR == ret)
        {
            ret = 943;
            msg = [NSString stringWithFormat:@"error code:%d",ret];
        }
        else if(IXL_OK != ret)
        {
            ret = 944;  // 사용자 인증서 취득에 실패하였습니다.
            msg = [NSString stringWithFormat:@"error code:%d",ret];
        }
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        return;
    }
    
    //char *pemCert_encoded_str = IXL_URLEncode((char*)pemCert_str);
    
    //NSString *postString = [NSString stringWithFormat:@"CACode=01&CertPolicy=04&Cert=%s",pemCert_encoded_str];
    //    NSString *postString = [NSString stringWithFormat:@"CACode=01&CertPolicy=04&Cert=%s",(char*)pemCert_str];
    
    //NSData* postData = [postString dataUsingEncoding:NSEUCKRStringEncoding];
    //[request setHTTPBody:postData];
    //[request setHTTPMethod:@"POST"];
    
    //NSURLResponse *resp = nil;
    //NSError *error = nil;
    //NSData *url_out = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error];
    
    //NSString* resultData = [[[NSString alloc] initWithData:url_out
    //                                              encoding:NSUTF8StringEncoding]
    //                        autorelease];
    //if(nil == resultData)
    //{
    //    resultData = [[[NSString alloc] initWithData:url_out
    //                                        encoding:NSEUCKRStringEncoding]
    //                  autorelease];
    //}
	
	//NSLog(@"resultData [%@]", resultData);
	//NSArray *parsedStr = [resultData componentsSeparatedByString:@"$"];
    
	//if([[parsedStr objectAtIndex:0] isEqualToString:@"000"])  // 정상
    //{
    ret = IXL_DeleteCert([AppInfo.selectedCertificate index]);
    if (0 != ret) {
        if (INDEX_NOT_VALID == ret) {
            ret = 908;
            msg = [NSString stringWithFormat:@"인증서 삭제에 실패했습니다. error code:%d",ret];
        }
        else if (DELETE_FAIL_FROM_IPHONE_KEYCHAIN == ret)
        {
            ret = 909;
            msg = [NSString stringWithFormat:@"인증서 삭제에 실패했습니다. error code:%d",ret];
        }
        else
        {
            ret = 910;
            msg = [NSString stringWithFormat:@"인증서 삭제에 실패했습니다. error code:%d",ret];
        }
        
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        return;
    }
    else
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            SHBCertExpireStep3ViewController *viewController = [[SHBCertExpireStep3ViewController alloc] initWithNibName:@"SHBCertExpireStep3ViewControllerEng" bundle:nil];
            
            viewController.title = @"Certificate revokation";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            SHBCertExpireStep3ViewController *viewController = [[SHBCertExpireStep3ViewController alloc] initWithNibName:@"SHBCertExpireStep3ViewControllerJpn" bundle:nil];
            
            viewController.title = @"電子証明書削除";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }else
        {
            SHBCertExpireStep3ViewController *viewController = [[SHBCertExpireStep3ViewController alloc] initWithNibName:@"SHBCertExpireStep3ViewController" bundle:nil];
            
            viewController.title = @"인증서 폐기";
            [self.navigationController pushFadeViewController:viewController];
            [viewController release];
            return;
        }
        //msg = [NSString stringWithFormat: @"인증서 폐기를 성공하였습니다. 인증서 삭제가 완료되었습니다."];
        
    }
	//}
	//else  // 에러
    //{
	//	NSString *errcode = [parsedStr objectAtIndex:0];
	//	NSString *errmsg = [[parsedStr objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    //    msg = [NSString stringWithFormat: @"[%@][%@]", errcode, errmsg];
    
	//	goto end;
	//}
    
    //end:
    //    alert = [[UIAlertView alloc]
    //			 initWithTitle:@"인증서 폐기!"
    //			 message:msg
    //			 delegate:self
    //			 cancelButtonTitle:@"확인"
    //			 otherButtonTitles:nil];
    //	alert.tag = alertTag;
    //	[alert show];
    
}


@end
