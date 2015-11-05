//
//  SHBCertMovePhoneViewController.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertMovePhoneViewController.h"
#import "SHBCertManageViewController.h"
#import "SHBCertDetailViewController.h"
#import "SHBFirstLogInSettingType1ViewController.h"
#import "INISAFEXSafe.h"
#import "SHBUtility.h"

@interface SHBCertMovePhoneViewController ()

- (void)importAuthorizeCode;
- (void)reImportAuthorizeCode;

- (void) getCertfromServer;
- (void) startImport:(NSTimer *)theTimer;
- (void) timeLimt;

@end

@implementation SHBCertMovePhoneViewController

@synthesize limtTimer;
@synthesize timer;

@synthesize firstAuthCode;
@synthesize secondAuthCode;
@synthesize info1Label;
@synthesize authcode;
@synthesize progressActive;
@synthesize isFirstLoginSetting;

- (void)dealloc
{
    if (timer != nil && [timer isValid])
    {
        [timer invalidate];
        self.timer = nil;
        
    }
    if (limtTimer != nil && [limtTimer isValid])
    {
        [limtTimer invalidate];
        self.limtTimer = nil;
    }
    
    [progressActive release];
    [firstAuthCode release], firstAuthCode = nil;
    [secondAuthCode release], secondAuthCode = nil;
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
    
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"Copy Certificate pc➞smartphone";
        [self navigationBackButtonEnglish];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"PC➞スマートフォン電子証明書コピー";
        [self navigationBackButtonJapnes];
    }else
    {
        self.title = @"PC➞스마트폰 인증서 복사";
        info1Label.text = @"고객님의 PC에 저장되어 있는 공인인증서를 스마트폰으로\n복사하시면 스마트폰과 PC에서 동일한 공인인증서를 이용하여\n은행거래를 하실수 있습니다.";
    }
    
    self.limtTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(timeLimt) userInfo:nil repeats:NO];
    
    //[self show];
    self.progressActive.hidden = NO;
    // 인증코드 가져오기.
    [self performSelector:@selector(importAuthorizeCode) withObject:nil afterDelay:0.5];
}

- (void)viewDidUnload
{
    [self setFirstAuthCode:nil];
    [self setSecondAuthCode:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.progressActive.hidden = YES;
    
    if (timer != nil && [timer isValid])
    {
        [timer invalidate];
        self.timer = nil;
        
    }
    if (limtTimer != nil && [limtTimer isValid])
    {
        [limtTimer invalidate];
        self.limtTimer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 프라이빗 메서드
- (void)reImportAuthorizeCode
{
    
}
// 인증번호 가져오기.
- (void)importAuthorizeCode
{
    
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@%@?SVer=%@&Action=REQ_AUTHCODE&Size=%d",PROTOCOL_HTTPS,REAL_CERT_IMPORT_IP,CERT_IMPORT_URL,@"1.1",8]];
    
    
    /* 인증번호 수신 */
    //NSData *url_out = [[[NSData alloc] initWithContentsOfURL:url] autorelease];
    NSError *error;
    NSData *url_out = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    //통신이 안되거나 데이터가 잘못된 경우
    if ([url_out length] <= 0 || url_out == nil)
    {
        //재 호출
        //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(importAuthorizeCode) userInfo:nil repeats:NO];
        //return;
        [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:@"인증번호 수신 로우데이터가 null 입니다."]];
        NSString *msg = @"PC로부터 인증번호 수신에 실패했습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다.";
        msg = [NSString stringWithFormat:@"%@\n[%@]",msg,[error localizedDescription]];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg];
        return;
    }
    
    NSString *outStr = [[[NSString alloc] initWithData:url_out encoding:NSUTF8StringEncoding] autorelease];
    
    if(outStr == nil || [outStr length] == 0)
    {
        //outStr = [[[NSString alloc] initWithData:url_out encoding:NSEUCKRStringEncoding] autorelease];
        [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:@"인증번호 로우데이터 UTF8 인코딩 결과가 null 입니다."]];
        NSString *msg = @"PC로부터 인증번호 수신에 실패했습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다.";
        msg = [NSString stringWithFormat:@"%@\n[%@]",msg,[error localizedDescription]];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg];
        return;
    }
    
    //NSLog(@"outStr [%@]", outStr);
    NSArray *parsedStr = [outStr componentsSeparatedByString:@"$"];
    if ([parsedStr count] > 0)
    {
        if([[parsedStr objectAtIndex:0] isEqualToString:@"OK"]){
            self.authcode = [[parsedStr objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            
            //NSLog(@"authcode:[%@]", self.authcode);
            self.firstAuthCode.text = [self.authcode substringToIndex:4];
            self.secondAuthCode.text = [self.authcode substringFromIndex:4];
            
            [self getCertfromServer];
        }
        else {
            //        errcode = [parsedStr objectAtIndex:1];
            //        errmsg = [[parsedStr objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"UTF8 인코딩 문자열 파싱결과에 ok 없습니다.\n%@", outStr]]];
            NSString *msg = @"PC로부터 인증번호 수신에 실패했습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다.";
            msg = [NSString stringWithFormat:@"%@\n[%@]",msg,[error localizedDescription]];
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg];
            return;
        }
    } else
    {
        [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"UTF8 인코딩 문자열 파싱결과에 $ 없습니다.\n%@", outStr]]];
        NSString *msg = @"PC로부터 인증번호 수신에 실패했습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다.";
        msg = [NSString stringWithFormat:@"%@\n[%@]",msg,[error localizedDescription]];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg];
        return;
    }
    
    
    
}

- (void) startImport:(NSTimer *)theTimer
{
	
	[self getCertfromServer];
}

- (void) getCertfromServer
{
    //
    unsigned char *encrypted_cert_key = NULL;
	int encrypted_cert_key_len = 0;
	char *c_authcode = NULL;
	NSString *errcode = nil;
	NSString *errmsg = nil;
	int ret = -1;
	NSString *msg = nil;
	//UIAlertView *alert = nil;
	
	NSString *enc_cert_key = nil;
    if (self.authcode == nil || [self.authcode length] == 0)
    {
        NSString *msg = @"PC로부터 인증번호 수신에 실패했습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다.";
        [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"authcode 가 없습니다.\n%@", self.authcode]]];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg];
        return;
    }
    
    //NSLog(@"authcode:%@", self.authcode);
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@%@?SVer=%@&Action=IMPORT&AuthNum=%@",PROTOCOL_HTTPS,REAL_CERT_IMPORT_IP,CERT_IMPORT_URL,@"1.1",self.authcode]];
    
    //NSLog(@"url:%@",[NSString stringWithFormat:@"%@%@%@?SVer=%@&Action=IMPORT&AuthNum=%@",PROTOCOL_HTTPS,REAL_CERT_IMPORT_IP,CERT_IMPORT_URL,@"1.1",self.authcode]);
    
    //NSData *url_out = [[[NSData alloc] initWithContentsOfURL:url] autorelease];
    NSError *error;
    NSData *url_out = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    
    NSString *outStr = [[[NSString alloc] initWithData:url_out encoding:NSEUCKRStringEncoding] autorelease];
    //NSLog(@"outStr:%@",outStr);
    //[SHBUtility writeErrorLog:[NSString stringWithFormat:@"인증서 가져오기해서 $ 문자열을 찾는데 실패했습니다.\n%@", outStr]];
    
    if (![SHBUtility isFindString:outStr find:@"$"])
    {
        msg = @"인증서 가져오기가 중단되었습니다.\n무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다.\n잠시 후 인증서 가져오기를 다시 시도해 주시기 바랍니다.";
        [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 가져오기해서 $ 문자열을 찾는데 실패했습니다.\n%@", outStr]]];
        msg = [NSString stringWithFormat:@"%@\n[%@]",msg,[error localizedDescription]];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg];
        return;
    }
    
    NSArray *parsedStr = [outStr componentsSeparatedByString:@"$"];
    
    
    if ([parsedStr count] > 0)
    {
        if([[parsedStr objectAtIndex:0] isEqualToString:@"OK"])
        {
            enc_cert_key = [parsedStr objectAtIndex:1];
            //NSLog(@"cert&key=\n%@", enc_cert_key);
            // base64 encode 되어 있기 때문에 인코딩 상관없음.
            encrypted_cert_key = [enc_cert_key UTF8String];
            
            encrypted_cert_key_len = [enc_cert_key length];
            // 숫자 문자열이라 인코딩 상관없음.
            c_authcode = [self.authcode UTF8String];
            
            /* 키체인에 인증서&키 저장 : 가져오기 간소화인경우 주민번호에 NULL 을 */
            ret = IXL_DecryptAndSave(encrypted_cert_key, encrypted_cert_key_len, NULL, c_authcode);
            if(ret != 0)
            {
                
                //NSString *msgString = [NSString stringWithCString:IXL_GetErrorString(ret) encoding:NSEUCKRStringEncoding];
                //msg = [NSString stringWithFormat: @"[%d][%@]", ret, msgString];
                msg = @"Error 발생";
                goto end;
                
            }
            else
            {
                //[SHBUtility writeErrorLog:[NSString stringWithFormat:@"인증서 가져오기가 성공했습니다.\n%@", outStr]];
                if (AppInfo.isLogin == LoginTypeCert)
                {
                    [AppInfo loadCertificates];
                    msg = @"인증서 복사가 완료되었습니다.\n메인화면으로 이동합니다.";
                    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1891 title:nil message:msg];
                    
                    if (timer != nil && [timer isValid])
                    {
                        [timer invalidate];
                        self.timer = nil;
                    }
                    if (limtTimer != nil && [limtTimer isValid])
                    {
                        [limtTimer invalidate];
                        self.limtTimer = nil;
                    }
                    
                    return;
                }
                
                if (!self.isFirstLoginSetting)
                {
                    //AppInfo.certificateCount = [[AppInfo loadCertificates] count];
                    [AppInfo loadCertificates];
                    NSString *message;
                    if (AppInfo.certificateCount > 1 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificateSelected)
                    {
                        
                        if (AppInfo.LanguageProcessType == EnglishLan)
                        {
                            message =@"A copy of the digital certificate has been completed.\nContinue the login process.";
                        }else if (AppInfo.LanguageProcessType == JapanLan)
                        {
                            message =@"電子証明書コピーが完了しました。\nログインします。";
                        }else
                        {
                            message =@"인증서 복사가 완료되었습니다.\n스마트폰에서 사용하는 인증서가\n2개 이상일 경우\n환경설정에서 로그인 설정을\n선택하여 사용하실 수 있습니다.로그인을 진행 합니다.";
                        }
                        
                    } else
                    {
                        if (AppInfo.LanguageProcessType == EnglishLan)
                        {
                            message =@"A copy of the digital certificate has been completed.\nContinue the login process.";
                        }else if (AppInfo.LanguageProcessType == JapanLan)
                        {
                            message =@"電子証明書コピーが完了しました。\nログインします。";
                        }else
                        {
                            message = @"인증서 복사가 완료되었습니다.\n로그인을 진행 합니다.";
                        }
                        
                        
                    }
                    
                    if (timer != nil && [timer isValid])
                    {
                        [timer invalidate];
                        self.timer = nil;
                    }
                    if (limtTimer != nil && [limtTimer isValid])
                    {
                        [limtTimer invalidate];
                        self.limtTimer = nil;
                    }
                    [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:10 title:@"" message:message language:AppInfo.LanguageProcessType];
                    
                } else //최초 로그인 세팅 화면이면....
                {
                    
                    SHBFirstLogInSettingType1ViewController *viewController = [[SHBFirstLogInSettingType1ViewController alloc] initWithNibName:@"SHBFirstLogInSettingType1ViewController" bundle:nil];
                    [viewController navigationViewHidden];
                    [self presentModalViewController:viewController animated:NO];
                    
                    [viewController release];
                }
                
                
            }
        }
        else {
            if ([parsedStr count] > 1)
            {
                
                errcode = [parsedStr objectAtIndex:1];
                
                if([errcode isEqualToString:@"NO_CERT"])
                {
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(startImport:) userInfo:nil repeats:NO];
                    
                    msg = @"";
                }
                else
                {
                    //errmsg = [[parsedStr objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    //msg = [NSString stringWithFormat: @"[%@][%@]", errcode, errmsg];
                    [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 가져오기해서 NO_CERT 문자열을 찾는데 실패했습니다.\n%@", outStr]]];
                    msg = @"Error 발생";
                    goto end;
                }
                
            } else
            {
                if (timer != nil && [timer isValid])
                {
                    [timer invalidate];
                    self.timer = nil;
                }
                if (limtTimer != nil && [limtTimer isValid])
                {
                    [limtTimer invalidate];
                    self.limtTimer = nil;
                }
                [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 가져오기 파싱에 실패했습니다.\n%@", outStr]]];
                msg = @"인증서 가져오기가 중단되었습니다.\n무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다.\n잠시 후 인증서 가져오기를 다시 시도해 주시기 바랍니다.";
                msg = [NSString stringWithFormat:@"%@\n[%@]",msg,[error localizedDescription]];
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg];
                return;
            }
            
        }
    } else
    {
        if (timer != nil && [timer isValid])
        {
            [timer invalidate];
            self.timer = nil;
        }
        if (limtTimer != nil && [limtTimer isValid])
        {
            [limtTimer invalidate];
            self.limtTimer = nil;
        }
        [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 가져오기 파싱에 실패했습니다.\n%@", outStr]]];
        msg = @"인증서 가져오기가 중단되었습니다.\n무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다.\n잠시 후 인증서 가져오기를 다시 시도해 주시기 바랍니다.";
        msg = [NSString stringWithFormat:@"%@\n[%@]",msg,[error localizedDescription]];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg];
        return;
    }
    
end:
    
	if ([msg length] > 0)
    {
        @try
        {
            if (timer != nil && [timer isValid])
            {
                [timer invalidate];
                self.timer = nil;
            }
            if (limtTimer != nil && [limtTimer isValid])
            {
                [limtTimer invalidate];
                self.limtTimer = nil;
            }
            
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                msg = @"You have failed to have a digital certificate be imported.\nPlease try again";
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                msg = @"電子証明書インポートを失敗しました。電子証明書インポートをもう一度押してください。";
            }else
            {
                switch (ret)
                {
                    case PRIVKEY_BASE64_DECODING_ERROR:
                        msg = @"파싱된 개인키가 base64 디코딩에 실패했습니다.";
                        break;
                    case IXL_MALLOC_ERROR:
                        msg = @"메모리 할당에 실패했습니다.";
                        break;
                    case ENC_CERTANDKEY_DECRYPT_ERROR:
                        msg = @"인증서 가져오기중 복호화에 실패했습니다.";
                        break;
                    case ENC_CERTANDKEY_PARSE_ERROR:
                        msg = @"복호화된 개인키 및 인증서 정보 파싱에 실패했습니다.";
                        break;
                    case DECRYPT_ERROR:
                        msg = @"인증서 복호화에 실패했습니다.";
                        break;
                    case LOAD_X509_ERROR:
                        msg = @"정보 파싱에 실패했습니다.";
                        break;
                    case FAIL_SAVE_TO_IPHONE_KEYCHAIN:
                        msg = @"아이폰 키체인에 인증서 및 키를 저장하는데 실패했습니다.";
                        break;
                    default:
                        msg = @"인증서 가져오기를 실패하였습니다.\n인증서 가져오기를 다시 시도해 주시기 바랍니다.";
                        break;
                }
                
            }
            
            if (ret == FAIL_SAVE_TO_IPHONE_KEYCHAIN)
            {
                int keychainStatusPugy = 0;
                int result = IXL_PurgeKeychainGroup("HQ59H9US6W.com.initech.KeychainSuite", &keychainStatusPugy);
                if (0 != result) {
                    
                    msg = [NSString stringWithFormat:@"인증서데이터 오류가 발생되어\n인증서데이터 초기화를 시도\n했으나 실패하였습니다.\n신한S뱅크를 종료 하시겠습니까?\n고객센터(1577-8000)로\n문의주시기 바랍니다.\n(%d)\n(%d)",ret,keychainStatusPugy];
                    [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:4444 title:@"" message:msg];
                    
                }else
                {
                    msg = @"인증서데이터 오류가 발생되어\n인증서데이터를 초기화했습니다.\n고객님의 안전한 거래를 위하여\n공인인증센터 메뉴에서 인증서를\n다시 복사해 주십시오.";
                    msg = [NSString stringWithFormat:@"%@\n(%d)",msg,ret];
                    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1891 title:@"" message:msg];
                }
            }else
            {
                [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 저장시 error가 발생했습니다.\n%@", msg]]];
                msg = [NSString stringWithFormat:@"%@\n[Error Code:%i]",msg,ret];
                [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg language:AppInfo.LanguageProcessType];
            }
            
            
            
        }
        @catch (NSException *exception)
        {
            [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 저장시 알수없는 오류가 발생했습니다.\n%@", outStr]]];
            msg = [NSString stringWithFormat:@"알수없는 오류가 발생했습니다.\n[Error Code:%i]",ret];
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg];
        }
        
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex:%i",alertView.tag);
    
    if (alertView.tag == 20)
    {
        [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
        
    } else if (alertView.tag == 10)
    {
        
        
        //NSLog(@"certificateCount:%i",AppInfo.certificateCount);
        
        //AppInfo.certProcessType == CertProcessTypeLogin;
        
        [AppDelegate.navigationController fadePopToRootViewController];   //본인
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
            SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] init];
            viewController.isSignupProcess = YES;
            [AppDelegate.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }else if (alertView.tag == 1891)
    {
        [AppDelegate.navigationController fadePopToRootViewController];
        
    }else if (alertView.tag == 4444 && buttonIndex == 0)
    {
        exit(-1);
    }
    
    
    
}

- (void) timeLimt
{
    
    NSString *msg;
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        msg = @"Certificate Import processing time has been exceeded.\nPlease try again.";
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        msg = @"電子証明書インポート処理時間が超過しました。\n電子証明書インポートをもう一度押してください。";
    }else
    {
        msg = @"인증서 가져오기 처리시간이 초과되었습니다.\n인증서 가져오기를 다시 시도해 주시기 바랍니다.";
    }
    [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"시간초과입니다.\n%@", @"인증서 가져오기 처리시간이 초과되었습니다.\n인증서 가져오기를 다시 시도해 주시기 바랍니다."]]];
    [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg language:AppInfo.LanguageProcessType];
}
@end
