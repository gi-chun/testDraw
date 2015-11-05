//
//  SHBCertCopyQRViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertCopyQRViewController.h"

#import "CryptoData.h"  //defined in the KeySharpiPhoneQR
#import "QRRelay_Error.h"  //defined in the KeySharpiPhoneQR
#import "Logger.h"  //defined in the KeySharpiPhone
#import "INISAFEXSafe.h"
#import "SHBCertManageViewController.h"
#import "SHBCertDetailViewController.h"
#import "SHBFirstLogInSettingType1ViewController.h"

@interface SHBCertCopyQRViewController ()

- (int) insertCert:(NSData*)certData KeyData:(NSData*)keyData;
- (UIView *)SHBCommonOverlay;
@end

@implementation SHBCertCopyQRViewController
@synthesize isFirstLoginSetting;

- (void) dealloc
{
    
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
    NSLog(@"self.frame.origin.y:%f",self.contentScrollView.frame.origin.y);
    // Do any additional setup after loading the view from its nib.
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"easy way to copy a digital certificate";
        [self navigationBackButtonEnglish];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"電子証明書簡単コピー";
        [self navigationBackButtonJapnes];
    }else
    {
        self.title = @"인증서 간편복사";
    }
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) confirmClick:(id)sender
{
    
    
    //ZBarReaderViewController *reader = [ZBarReaderViewController new];
    
    if (readerZ == nil)
    {
        readerZ = [ZBarReaderViewController new];
    }
    
    readerZ.readerDelegate = self;
    readerZ.supportedOrientationsMask = ZBarOrientationMask(UIInterfaceOrientationPortrait);
    readerZ.showsZBarControls = NO;
    readerZ.cameraOverlayView = [self SHBCommonOverlay];
    readerZ.videoQuality = 0;
    //readerZ.readerView.zoom = 2;
    
    ZBarImageScanner *scanner = readerZ.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    

    //[self presentModalViewController:readerZ animated:YES];
    [self.navigationController pushSlideUpViewController:readerZ];
}
- (UIView *)SHBCommonOverlay
{
    UIView *SHBView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];

    //UILabel *infoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 20)];
    UILabel *infoLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 20)];
    [infoLabel1 setFont:[UIFont systemFontOfSize:16]];
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
        [infoLabel1 setTextAlignment:NSTextAlignmentCenter];
    #else
        [infoLabel1 setTextAlignment:UITextAlignmentCenter];
    #endif
    [infoLabel1 setBackgroundColor:[UIColor clearColor]];
    [infoLabel1 setTextColor:RGB(255, 255, 255)];
    [infoLabel1 setNumberOfLines:1];
    [infoLabel1 setText:@"사각형 영역을 인증서 QR코드에 맞추면"];
    [SHBView addSubview:infoLabel1];
    [infoLabel1 release];
    
    //UILabel *infoLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 320, 20)];
    UILabel *infoLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 20)];
    [infoLabel2 setFont:[UIFont systemFontOfSize:16]];
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
        [infoLabel2 setTextAlignment:NSTextAlignmentCenter];
    #else
        [infoLabel2 setTextAlignment:UITextAlignmentCenter];
    #endif
    [infoLabel2 setBackgroundColor:[UIColor clearColor]];
    [infoLabel2 setTextColor:RGB(255, 255, 255)];
    [infoLabel2 setNumberOfLines:1];
    [infoLabel2 setText:@"자동으로 인식합니다."];
    [SHBView addSubview:infoLabel2];
    [infoLabel2 release];
    
    //UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(20, 110, 280, 2)];
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(20, 90, 280, 2)];
    [lineView1 setBackgroundColor:RGB(255, 255, 255)];
    [SHBView addSubview:lineView1];
    [lineView1 release];
    
    //UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 110, 2, 300)];
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(20, 90, 2, 300)];
    [lineView2 setBackgroundColor:RGB(255, 255, 255)];
    [SHBView addSubview:lineView2];
    [lineView2 release];
    
    //UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(300, 110, 2, 300)];
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(300, 90, 2, 300)];
    [lineView3 setBackgroundColor:RGB(255, 255, 255)];
    [SHBView addSubview:lineView3];
    [lineView3 release];
    
    //UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(20, 410, 280, 2)];
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(20, 390, 280, 2)];
    [lineView4 setBackgroundColor:RGB(255, 255, 255)];
    [SHBView addSubview:lineView4];
    [lineView4 release];
    
    UIButton	*closeButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 430, 94, 29)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_btype2.png"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_btype2_focus.png"] forState:UIControlStateHighlighted];
    [closeButton setTitle:@"취소" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeQR) forControlEvents: UIControlEventTouchUpInside];
    [SHBView addSubview:closeButton];
    [closeButton release];
    return SHBView;
}

- (void) closeQR
{
    //[readerZ dismissModalViewControllerAnimated:YES];
    [self.navigationController PopSlideDownViewController];
}

//QR 통신이 끝나고 난뒤 마지막으로 호출되는 Delegate함수
- (void) qrLogicEnd {
    
    if(qrRelay.qr_error.code == 1) { //복사 성공
        //아래 두 값을 저장합니다.
        //qrRelay.cryptoData.cert;
        //qrRelay.cryptoData.key;
        
        NSData *certData = qrRelay.cryptoData.cert;
        NSData *keyData = qrRelay.cryptoData.key;
        
        int ret = IXL_NOK;
        
        ret = [self insertCert:certData KeyData:keyData];
        
        if (ret == IXL_OK)
        {
            if (AppInfo.isLogin == LoginTypeCert)
            {
                [AppInfo loadCertificates];
                NSString *msg = @"인증서 복사가 완료되었습니다.\n메인화면으로 이동합니다.";
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:1892 title:nil message:msg];
                return;
            }
            
            if (!self.isFirstLoginSetting) //초기설정이 아니면 로그인 화면으로 이동
            {
                AppInfo.certificateCount = [[AppInfo loadCertificates] count];
                
                NSString *msg;
                if (AppInfo.certificateCount > 1 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeCertificateSelected)
                {
                    if (AppInfo.LanguageProcessType == EnglishLan)
                    {
                        msg =@"A copy of the digital certificate has been completed.\nContinue the login process.";
                    }else if (AppInfo.LanguageProcessType == JapanLan)
                    {
                        msg =@"電子証明書コピーが完了しました。\nログインします。";
                    }else
                    {
                       msg =@"인증서 복사가 완료되었습니다.\n스마트폰에서 사용하는 인증서가\n2개 이상일 경우\n환경설정에서 로그인 설정을\n선택하여 사용하실 수 있습니다.로그인을 진행 합니다."; 
                    }
                    
                    
                } else
                {
                    if (AppInfo.LanguageProcessType == EnglishLan)
                    {
                        msg =@"A copy of the digital certificate has been completed.\nContinue the login process.";
                    }else if (AppInfo.LanguageProcessType == JapanLan)
                    {
                        msg =@"電子証明書コピーが完了しました。\nログインします。";
                    }else
                    {
                        msg = @"인증서 복사가 완료되었습니다.\n로그인을 진행 합니다.";
                    }
                    
                }
                
                [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg language:AppInfo.LanguageProcessType];
                
            }else
            {
                
                SHBFirstLogInSettingType1ViewController *viewController = [[SHBFirstLogInSettingType1ViewController alloc] initWithNibName:@"SHBFirstLogInSettingType1ViewController" bundle:nil];
                [viewController navigationViewHidden];
                
                //[self presentModalViewController:viewController animated:NO];
                [self.navigationController pushSlideUpViewController:viewController];
                [viewController release];
            }
            
        }
    } else {  //복사 실패
        //[self popUpWithTitle:[NSString stringWithFormat:@"%d", qrRelay.qr_error.code] message:qrRelay.qr_error.message];
        NSString *msg;
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"You have failed to recognize the QR certificate.\nIt is not a valid QR code.";
        }else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"QR電子証明書認識に失敗しました。\n有効なQRコードではありません。";
        }else
        {
            msg = @"QR인증서 인식에 실패하였습니다.\n유효한 QR코드가 아닙니다.";
        }
        [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
    }
}

//카메라가 찍고 난뒤 호출되는 Delegate 함수
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
//#if DEBUG
//    지로 지방세 테스트 코드입니다.
//    NSLog(@"data = %@", symbol.data);
//    NSLog(@"data length:%i",[symbol.data length]);
//    
//    NSMutableString *qrJirojibangseData = [[NSMutableString alloc] initWithCapacity:0];
//    for (int i = 0; i < [symbol.data length]; i++)
//    {
//        NSRange range = NSMakeRange(i, 1);
//        NSString *tmpStr = [symbol.data substringWithRange:range];
//        NSLog(@"tmp:%@",tmpStr);
//        NSString *str = [tmpStr stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
//        
//        if (str == nil)
//        {
//            NSLog(@"str:%@",tmpStr);
//            break;
//        }else
//        {
//            [qrJirojibangseData appendString:tmpStr];
//        }
//        
//    }
//    
//    NSLog(@"qrJirojibangseData:%@",qrJirojibangseData);
//#endif
    
    qrRelay = [[QRRelay alloc] initWithServerCertReal:@"shinhan.cer" Test:@"lumentest.cer"];
    
#if DEBUG
    NSLog(@"data = %@", symbol.data);
#endif
    
    BOOL decodeRet = [qrRelay decodeQR:symbol.data]; //call method1: qr코드 분석
    if(decodeRet) {

    Debug(@"분석에 성공하였습니다.");

        
        [qrRelay requestCert:@selector(qrLogicEnd) delegate:self];
    } else {
        [self popUpWithTitle:[NSString stringWithFormat:@"%d", qrRelay.qr_error.code] message:qrRelay.qr_error.message];
    }
    
    //[reader dismissViewControllerAnimated: YES completion:nil];
    //[reader dismissModalViewControllerAnimated:YES];
    [self.navigationController PopSlideDownViewController];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex:%i",alertView.tag);
    
    if (alertView.tag == 20)
    {
        //[self.navigationController fadePopViewController];
        
    } else if (alertView.tag == 10)
    {
        
        
        //NSLog(@"certificateCount:%i",AppInfo.certificateCount);
        
        //AppInfo.certProcessType == CertProcessTypeLogin;
        
        [self.navigationController fadePopViewController];   //본인
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
    } else if (alertView.tag == 1892)
    {
        [AppDelegate.navigationController fadePopToRootViewController];
    }
    
    
    
}

#pragma mark - UTILS
- (void) popUpWithTitle:(NSString*)title message:(NSString*)message{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"확인", nil];
    [alert show];
    [alert release];
}

- (int) insertCert:(NSData*)certData KeyData:(NSData*)keyData

{
    
    int ret = -1;
    
    unsigned char *cert_str = NULL;
    
    unsigned char *priv_str = NULL;
    
    int cert_len = 0;
    
    int priv_len = 0;
    
    
    
    if(certData && keyData){
        
        
        
        cert_len = [certData length];
        
        cert_str = (unsigned char *)malloc(sizeof(unsigned char) * cert_len + 1);
        
        if(!cert_str){
            
            ret = IXL_MALLOC_ERROR; /* malloc error */
            
            if(ret != 0){
                
                if(priv_str){
                    
                    free(priv_str);
                    
                    priv_str = 0;
                    
                }
                
                if(cert_str){
                    
                    free(cert_str);
                    
                    cert_str = 0;
                    
                }
                
            }
            
            return ret;
            
        }
        
        memset(cert_str, 0x00, sizeof(unsigned char) * cert_len + 1);
        
        [certData getBytes:cert_str];
        
        
        
        priv_len = [keyData length];
        
        priv_str = (unsigned char *)malloc(sizeof(unsigned char) * priv_len + 1);
        
        if(!priv_str){
            
            ret = IXL_MALLOC_ERROR;
            
            return ret;
            
        }
        
        memset(priv_str, 0x00, sizeof(unsigned char) * priv_len + 1);
        
        [keyData getBytes:priv_str];
        
        ret = IXL_SaveCertPkey(11, NULL, NULL, cert_str, cert_len, priv_str, priv_len);
        
    }
    
    else {
        
        ret = GET_CERTPKEY_FROM_IPHONE_FAIL;
        return ret;
    }
    
    
    
    if(priv_str){
        
        free(priv_str);
        
        priv_str = 0;
        
    }
    
    if(cert_str){
        
        free(cert_str);
        
        cert_str = 0;
        
    }
    
    
    
    return IXL_OK;
    
}

@end
