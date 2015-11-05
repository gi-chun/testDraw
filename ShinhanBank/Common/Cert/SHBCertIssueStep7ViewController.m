//
//  SHBCertIssueStep7ViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertIssueStep7ViewController.h"
#import "SHBFirstLogInSettingType2ViewController.h"
#import "INISAFEXSafe.h"
#import "SHBCertManageViewController.h"
#import "SHBCertDetailViewController.h"

@interface SHBCertIssueStep7ViewController ()
{
    int certIndex;
    NSString *curNotBefore;
     NSMutableArray *certArray;
}
- (void) DetailInfoWithParsing:(unsigned char *)line length:(int)strlen;
//- (void) DetailInfoWithParsing:(unsigned char *)line;
- (void) searchCert;
- (void) registerCert;
@end

@implementation SHBCertIssueStep7ViewController
@synthesize transDataSet;
@synthesize certPwdTextField;
@synthesize certPwdConfirmTextField;
@synthesize encryptCertPwd1;
@synthesize encryptCertPwd2;
@synthesize isFirstLoginSetting;
@synthesize secureGuideView;

- (void) dealloc
{
    [secureGuideView release];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"Issue/ Reissue Digital Certificate";
        [self navigationBackButtonEnglish];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"電子証明書の発行・再発行";;
        [self navigationBackButtonJapnes];
    }else
    {
        self.title = @"인증서 발급/재발급";
        self.strBackButtonTitle = @"인증서 발급/재발급 7단계";
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

- (void) searchCert
{
    
    //certArray = [[[NSMutableArray alloc] init] autorelease];
    //certArray = [AppInfo loadCertificates];
    
     //NSString *toDay = [SHBUtility getCurrentDate:YES];
     
     NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
     [outputFormatter setDateFormat:@"yyyy-MM-dd"];
     NSString *toDay = [outputFormatter stringFromDate:[NSDate date]];
     
    certIndex = -1;
    /*
    @try {
        for (int i = 0; i < [certArray count]; i++)
        {
            CertificateInfo *certi = [certArray objectAtIndex:i];
            
            //인증서 상세정보 가져오기
            unsigned char *cert = NULL;
            int certlen = 0;
            
            unsigned char *priv_str = NULL;
            int priv_len = 0;
            
            unsigned char *certDetailStr = NULL;
            int certDetailStrlen = 0;
            
            // get cert and key
            //int ret = IXL_GetCertPkey([AppInfo.selectedCertificate index], &cert, &certlen, &priv_str, &priv_len);
            int ret = IXL_GetCertPkey([certi index], &cert, &certlen, &priv_str, &priv_len);
            if(0 != ret){
                // error
            }
            
            ret = IXL_Make_CertDetail(cert, certlen, &certDetailStr, &certDetailStrlen);
            if(0 != ret){
                
            }
            
            [self DetailInfoWithParsing:certDetailStr length:certDetailStrlen];
            //[self performSelector:@selector(DetailInfoWithParsing:) withObject:certDetailStr afterDelay:1];
            if ([toDay isEqualToString:curNotBefore])
            {
                
                certIndex = i; //찾은 인덱스 정보를 저장
                Debug(@"오늘 발급된 인증서 인덱스:%@",certIndex);
                
            }
        }
    }
    @catch (NSException *exception) {
       
    }
     */
     
}
- (void) registerCert
{
    
    
    char *pPassword = NULL;
    char pDN[512] = {0x00,};
    char *pCAName = NULL;
    char *port = NULL;
    char *addr = NULL;
    char *ref = NULL;
    char *auth = NULL;
    int passwordlen = 0;
    int canamelen = 0;
    int ret = -1;
    
    NSString *msg = @"";
    NSString *caName = [NSString stringWithFormat:@"YESSIGN"];
    //self.serverIP = TEST_SERVER_IP
    NSString *address = [NSString stringWithFormat:@"203.233.91.71"];

    if ([AppInfo.serverIP isEqualToString:TEST_SERVER_IP])
    {
        address = [NSString stringWithFormat:@"203.233.91.231"];
    }

    NSString *portNo = [NSString stringWithFormat:@"4512"];
    NSString *password = self.certPwdTextField.text;
    //NSString *rePassword = self.certPwdConfirmTextField.text;
    if (self.transDataSet[@"참조번호"] == nil || [self.transDataSet[@"참조번호"] length] == 0)
    {
        msg = @"인증서 발급에 필요한 참조번호가 없습니다.\n인증서 발급에 실패했습니다.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1890 title:@"" message:msg];
        return;
    }
    if (self.transDataSet[@"인가코드"] == nil || [self.transDataSet[@"인가코드"] length] == 0)
    {
        msg = @"인증서 발급에 필요한 인가코드가 없습니다.\n인증서 발급에 실패했습니다.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1890 title:@"" message:msg];
        return;
    }
    Debug(@"참조번호:%@",self.transDataSet[@"참조번호"]);
    Debug(@"인가코드:%@",self.transDataSet[@"인가코드"]);
    
    ref = (char*)[self.transDataSet[@"참조번호"] UTF8String];
    auth = (char*)[self.transDataSet[@"인가코드"] UTF8String];
    addr = (char*)[address UTF8String];
    port = (char*)[portNo UTF8String];
    
    pCAName = (char*)[caName UTF8String];
    canamelen = [caName length];
    
    sprintf(pDN,"REF=%s&CODE=%s&CAIP=%s&CAPORT=%s&CANAME=%s", ref, auth, addr, port, pCAName);
    
    pPassword = (char*)[password UTF8String];
    passwordlen = [password length];
    
//    NISAFEXSAFE_API __attribute__((overloadable)) int IXL_Issue_Certificate_Reduction (int nStoreType, char* pDriveName, int nDriveNamelen, unsigned char* pPin, int nPinlen,  char* pCAName,int nCANamelen,
//                                                                                       char* pDn, int nDnlen, NSData* pPassword, char* pHashAlg, int nHashAlglen,unsigned char* pKeyBit, int nKeyBitlen);
    
    int nReturn = IXL_nFilterKeyCheck();
    //nReturn = -1;
    if(nReturn == 0)
    {
        ret = IXL_Issue_Certificate_Reduction (11, NULL, 0, NULL, 0,  pCAName, canamelen,
                                               pDN, strlen(pDN), AppInfo.eccData, "SHA256", 6, (unsigned char*)"2048", 4);
    }else
    {
        ret = IXL_Issue_Certificate_Reduction (11, NULL, 0, NULL, 0,  pCAName, canamelen,
                                               pDN, strlen(pDN), (unsigned char*)pPassword, passwordlen, "SHA256", 6, (unsigned char*)"2048", 4);
    }
    
    AppInfo.commonDic = nil;
    if (IXL_OK == ret) {
        
        if (AppInfo.isLogin == LoginTypeCert)
        {
            [AppInfo loadCertificates];
            msg = @"인증서 발급이 완료되었습니다.\n메인화면으로 이동합니다.";
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1890 title:nil message:msg];
            return;
        }
        certArray = [AppInfo loadCertificates];
        
        if ([certArray count] > 1 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificateSelected)
        {
 
            
            [self searchCert];
            
            if (certIndex == -1) //발급된 인증서를 찾지 못한경우 처리
            {
                if (AppInfo.LanguageProcessType == EnglishLan)
                {
                    msg = @"The digital certificate has been issued successfully.\nproceed to login";
                }else if (AppInfo.LanguageProcessType == JapanLan)
                {
                    msg = @"電子証明書発行が完了しました。\nログインします。";
                }else
                {
                    msg = @"인증서 발급이 완료되었습니다.\n로그인을 진행합니다.";
                }
                
            }else
            {
                msg = [NSString stringWithFormat:@"인증서 발급이 완료되었습니다.스마트폰에서 사용하는 인증서가\n2개 이상일 경우\n환경설정에서 로그인 설정을\n선택하여 사용하실 수 있습니다.\n소유자:%@\n발급자:%@\n구분:%@\n만료일:%@\n로그인을 진행합니다.",[[certArray objectAtIndex:certIndex] user],[[certArray objectAtIndex:certIndex] issuer],[[certArray objectAtIndex:certIndex] type],[[certArray objectAtIndex:certIndex] expire]];
                
            }
            
        } else if ([certArray count] == 1)
        {
            
            certIndex = 0;
            
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                msg = [NSString stringWithFormat: @"The digital certificate has been issued successfully.\nSubject:%@\nIssuer:%@\nType:%@\nExpiration date:%@\nproceed to login",[[certArray objectAtIndex:0] user],[[certArray objectAtIndex:0] issuer],[[certArray objectAtIndex:0] type],[[certArray objectAtIndex:0] expire]];
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                
                msg = [NSString stringWithFormat: @"電子証明書発行が完了しました。\n所有者:%@\n発行者:%@\n区別:%@\n満了日:%@\nログインします。",[[certArray objectAtIndex:0] user],[[certArray objectAtIndex:0] issuer],[[certArray objectAtIndex:0] type],[[certArray objectAtIndex:0] expire]];
            }else
            {
                msg = [NSString stringWithFormat: @"인증서 발급이 완료되었습니다.\n소유자:%@\n발급자:%@\n구분:%@\n만료일:%@\n로그인을 진행합니다.",[[certArray objectAtIndex:0] user],[[certArray objectAtIndex:0] issuer],[[certArray objectAtIndex:0] type],[[certArray objectAtIndex:0] expire]];
            }
            
        } else if ([certArray count] > 1)
        {
            
            [self searchCert];
            if (certIndex == -1) //발급된 인증서를 찾지 못한경우 처리
            {
                if (AppInfo.LanguageProcessType == EnglishLan)
                {
                    msg = @"The digital certificate has been issued successfully.\nproceed to login";
                }else if (AppInfo.LanguageProcessType == JapanLan)
                {
                    msg = @"電子証明書発行が完了しました。\nログインします。";
                }else
                {
                    msg = @"인증서 발급이 완료되었습니다.\n로그인을 진행합니다.";
                }
            }else
            {
               msg = [NSString stringWithFormat: @"인증서 발급이 완료되었습니다.\n소유자:%@\n발급자:%@\n구분:%@\n만료일:%@\n로그인을 진행합니다.",[[certArray objectAtIndex:certIndex] user],[[certArray objectAtIndex:certIndex] issuer],[[certArray objectAtIndex:certIndex] type],[[certArray objectAtIndex:certIndex] expire]]; 
            }
             
        }
        
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg language:AppInfo.LanguageProcessType];
        
        /*
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
        
        alertView.tag = 10;
        [alertView show];
        
        [alertView release];
         */
    }
    else
    {
        
        if (ret == 1051025)
        {
            //에러코드 1051025 대응
            
            int keychainStatusPugy = 0;
            int result = IXL_PurgeKeychainGroup("HQ59H9US6W.com.initech.KeychainSuite", &keychainStatusPugy);
            if (0 != result) {
                
                NSString *msg = [NSString stringWithFormat:@"인증서데이터 오류가 발생되어\n인증서데이터 초기화를 시도\n했으나 실패하였습니다.\n신한S뱅크를 종료 하시겠습니까?\n고객센터(1577-8000)로\n문의주시기 바랍니다.\n(%d)\n(%d)",ret,keychainStatusPugy];
                [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:4444 title:@"" message:msg];
                
            }else
            {
                NSString *msg = @"인증서데이터 오류가 발생되어\n인증서데이터를 초기화했습니다.\n고객님의 안전한 거래를 위하여\n공인인증센터 메뉴에서 인증서를\n다시 발급하여 주십시오.";
                msg = [NSString stringWithFormat:@"%@\n(%d)",msg,ret];
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1890 title:@"" message:msg];
            }
            
        }else
        {
            AppInfo.isNfilterPK = NO;
            msg = [NSString stringWithFormat: @"인증서 발급이 실패했습니다.(error code : %d)", ret];
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1890 title:@"" message:msg];
        }
        
        
        
    }
    
    //[self dismiss];
    [AppDelegate closeProgressView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex:%i",alertView.tag);
    
    if (alertView.tag == 10) {
        
        if (AppInfo.lastViewController != nil)
        {
            AppInfo.lastViewController = nil;
        }
        if (self.isFirstLoginSetting == YES) //로그인 설정으로
        {
            SHBFirstLogInSettingType2ViewController *viewController = [[SHBFirstLogInSettingType2ViewController alloc] initWithNibName:@"SHBFirstLogInSettingType2ViewController" bundle:nil];
            //[self.navigationController pushFadeViewController:viewController];
            //[viewController release];
            viewController.certIndex = certIndex;
            [viewController navigationViewHidden];
            [self presentModalViewController:viewController animated:NO];
            [viewController release];
            
        } else
        {
            //NSLog(@"aaaa:%@",[AppDelegate.navigationController viewControllers]);
//            [AppDelegate.navigationController popViewControllerAnimated:NO];
//            [AppDelegate.navigationController popViewControllerAnimated:NO];
//            [AppDelegate.navigationController popViewControllerAnimated:NO];
//            [AppDelegate.navigationController popViewControllerAnimated:NO];
//            [AppDelegate.navigationController popViewControllerAnimated:NO];
//            [AppDelegate.navigationController popViewControllerAnimated:NO];
//            [AppDelegate.navigationController popViewControllerAnimated:NO];
            //[self.navigationController popViewControllerAnimated:NO];
            
            [AppDelegate.navigationController fadePopToRootViewController];
            //AppInfo.certProcessType = CertProcessTypeLogin;
            //AppInfo.certProcessType = CertProcessTypeIssue;
            AppInfo.certProcessType = CertProcessTypeIssueLogin;
            //[super pushViewControllerQuickMenu:QUICK_LOGOUT_TAG];
            //인증서 목록 또는 인증서 상세 화면
            if (AppInfo.certificateCount == 1) {
                
                
                AppInfo.isSignupService = YES;
                SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] init];
                viewController.isSignupProcess = YES;
                [AppDelegate.navigationController pushFadeViewController:viewController];
                [viewController release];
                
                
            } else
            {
                AppInfo.isSignupService = YES;
                //AppInfo.certProcessType = CertProcessTypeIssue; //인증서 목록화면에서 id/pwd 버튼이 보이지 않게 하기 위해...
                SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] init];
                viewController.isSignupProcess = YES;
                [AppDelegate.navigationController pushFadeViewController:viewController];
                [viewController release];
            }
        }
        
        
    }else if (alertView.tag == 4444 && buttonIndex == 0)
    {
        exit(-1);
    }else if (alertView.tag == 1890)
    {
        
        [AppDelegate.navigationController fadePopToRootViewController];
    }
    
}

- (void) DetailInfoWithParsing:(unsigned char *)line length:(int)strlen
//- (void) DetailInfoWithParsing:(unsigned char *)line
{

	// 받은 정보를 파싱해서 각 변수에 보존
	//NSString *tempCertString = [NSString stringWithCString:line length:strlen];
	NSString *tempCertString = [NSString stringWithCString:line encoding:NSUTF8StringEncoding];
    
	NSArray *tempArray1 = nil;
	NSArray *tempArray2 = nil;
	NSString *tempString = nil;
	unsigned char* pEncoding = NULL;
	int nEncodinglen = 0;
	int nRet = 0;
	
	tempArray1 = [tempCertString componentsSeparatedByString:@"&"];
	
	//NSLog(@" CertDetailInfo : %@", tempArray1);
	
	for (int index = 0; ([tempArray1 count]-1)>index; index++)
    {
		pEncoding = NULL;
		
		tempString = [tempArray1 objectAtIndex:index];
		tempArray2 = [tempString componentsSeparatedByString:@"^"];
		
//		NSString *tempTitle = [tempArray2 objectAtIndex:0];
		
		char *buf = (char*)[[tempArray2 objectAtIndex:1] UTF8String];
		nRet = IXL_DataDecode(ENCODE_URL_OR_BASE64,
							  (unsigned char*)buf,
							  [[tempArray2 objectAtIndex:1] length],
							  &pEncoding,&nEncodinglen);
		
		NSString *tempContents = [NSString stringWithCString:pEncoding
                                                    encoding:NSEUCKRStringEncoding];
		
		
        if ([tempArray2 count] > 0)
        {
            if( [@"validity_from" isEqualToString:[tempArray2 objectAtIndex:0]])
            {
                //            tempTitle = @"유효기간 시작";
                Debug(@"temp contents:%@",tempContents);
                Debug(@"[tempArray2 objectAtIndex:0]:%@",[tempArray2 objectAtIndex:0]);
                Debug(@"발급된 인증서 유효기간 찾기 성공:%@",tempContents);
                curNotBefore = tempContents;
               
            }
        }
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
