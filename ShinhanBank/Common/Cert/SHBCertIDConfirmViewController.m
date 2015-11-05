//
//  SHBCertIdentyConfirmViewController.m
//  ShinhanBank
//
//  Created by RedDragon on 12. 11. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertIDConfirmViewController.h"
#import "INISAFEXSafe.h"

@interface SHBCertIDConfirmViewController ()

- (void)delyStart;
- (int)runCheckPKeyPassword;
@end

@implementation SHBCertIDConfirmViewController

@synthesize subjectLabel;
@synthesize issuerAliasLabel;
@synthesize notAfterLabel;
@synthesize typeLabel;
@synthesize notAfterTitle;
@synthesize confirmBtn;
//@synthesize cancelBtn;

@synthesize ssnTextField;
@synthesize certPwdTextField;
@synthesize certImageView;
@synthesize certData;
@synthesize ssnData;

- (void) dealloc
{
    [certData release];
    [ssnData release];
    [certImageView release];
    [ssnTextField release];
    [certPwdTextField release];
    //[cancelBtn release];
    [confirmBtn release];
    [subjectLabel release];
    [issuerAliasLabel release];
    [notAfterLabel release];
    [typeLabel release];
    
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
    endTextFieldTag = 11;
    
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
    
    
    // 보안키패드 띄우기.
    [self.certPwdTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:50];
    [self.ssnTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:13];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) confirmClick:(id)sender
{
    
    if ([self.ssnTextField.text length] < 1 || [self.ssnTextField.text length] < 13)
    {
        
        NSString *msg = @"주민등록번호 13자리를 입력해 주십시오.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        return;
    }
    
    if ([self.certPwdTextField.text length] < 1)
    {
        NSString *msg = @"인증서암호를 입력하여 주십시오.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        return;
    }
    //[self show];
    [AppDelegate showProgressView];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(delyStart) userInfo:nil repeats:NO];
}

//- (IBAction) cancelClick:(id)sender
//{
//    
//}

- (void)delyStart
{
    
    [AppDelegate closeProgressView];
    NSString *msg;
    int ret = [self runCheckPKeyPassword];
    if(ret != 0){
		if(ret == CHECKVID_PARAM_ERROR){
//			msg = @"파라미터 오류입니다.";
            msg = @"본인확인에 실패하였습니다.";
		}
		else if(ret == GET_RANDOM_FROM_PKEY_FAIL){
//			msg = @"인증서 비밀번호를 잘못 입력하였습니다.";
            msg = @"본인확인에 실패하였습니다.";
            self.certPwdTextField.text = @"";
		}
		else if(ret == INVALID_VID){
//			msg = @"주민번호를 잘못 입력하였습니다.";
            msg = @"본인확인에 실패하였습니다.";
            self.ssnTextField.text = @"";
		}
		else {
//			msg = @"인증서 분석에 실패하였습니다.";
            msg = @"본인확인에 실패하였습니다.";
		}
        
	}
	else {
		
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Identification was successful.";
        }else
        {
            msg = @"본인확인에 성공하였습니다.";
        }
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg language:AppInfo.LanguageProcessType];
        return;
	}
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        msg = @"Failed to identify the user.";
    }
    [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg language:AppInfo.LanguageProcessType];
    //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
}

#pragma mark - 텍스트 필드 델리게이트
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    BOOL shouldReturn = YES;
    
    if (textField == self.ssnTextField)
    {
        
        if ([self.ssnTextField.text length] > 12)
        {
            return NO;
        }
        //shouldReturn = NO;
    }
    
    return shouldReturn;
}

#pragma mark - initech process
#pragma mark - 비밀번호 확인
- (int) runCheckPKeyPassword
{
	NSString *strSSN = self.ssnTextField.text;
	NSString *strPKeypass = self.certPwdTextField.text;
	int ret = -1;
	
	unsigned char *cert = NULL;
	int certlen = 0;
	
	unsigned char *priv_str = NULL;
	int priv_len = 0;
	
	char *alg = NULL;
	char *hash_alg = NULL;
	
	/* get cert and key */
	ret = IXL_GetCertPkey([AppInfo.selectedCertificate index], &cert, &certlen, &priv_str, &priv_len);
	if( ret != 0){
		// error
        
	}
	
	ret = IXL_Get_Cert_AlgorithmAndHash(1, cert, certlen, &alg, &hash_alg);
	
    int nReturn = IXL_nFilterKeyCheck();
    if(nReturn == 0)
    {
        ret = IXL_CheckVID([AppInfo.selectedCertificate index], self.certData, self.ssnData);
    }else
    {
        ret = IXL_CheckVID([AppInfo.selectedCertificate index], (char *)[strPKeypass UTF8String], (char *)[strSSN UTF8String]);
    }
	
	

    return ret;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag == EXIT_ALERT_VIEW_TAG)
    {
        // 앱 종료.
        exit(-1);
        
    }
    
    if (alertView.tag == 10) {
        //[self dismiss];
        [AppDelegate closeProgressView];
        [self.navigationController fadePopViewController];
    }
    
}

- (void)navigationButtonPressed:(id)sender
{
    AppInfo.certProcessType = CertProcessTypeManage;
    [super navigationButtonPressed:sender];
}

#pragma mark - SHBSecureDelegate

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    // !!!: 암호화된 비밀번호를 다시 포맷팅 하므로, 주의 할 것!
    //self.encriptedPassword = [NSString stringWithFormat:@"%@%@%@", ENC_PW_PREFIX, value, ENC_PW_SUFFIX];
    if (textField == self.certPwdTextField)
    {
        self.certData = aData;
    }else if (textField == self.ssnTextField)
    {
        self.ssnData = aData;
    }
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
}

@end
