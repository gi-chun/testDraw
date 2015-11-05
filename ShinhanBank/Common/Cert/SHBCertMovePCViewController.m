//
//  SHBCertMovePCViewController.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertMovePCViewController.h"
#import "INISAFEXSafe.h"


@interface SHBCertMovePCViewController ()
{
    NSTimer *limtTimer;
}

- (void) getAuthCodeFromServer;
- (void) getResponseFromServer;
- (void) recallFunction;
- (void) timeLimt;
@end

@implementation SHBCertMovePCViewController

@synthesize connectionForExportCertificate;
@synthesize response;
@synthesize receivedData;
@synthesize authCode;
@synthesize firstAuthCode;
@synthesize secondAuthCode;
@synthesize certPwd;
@synthesize timer;
@synthesize progressActive;

- (void)dealloc
{
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
    // Do any additional setup after loading the view from its nib.
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"Copy certificate smart phone➞pc";
        [self navigationBackButtonEnglish];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"スマートフォン➞PC　電子証明書コピー";
        [self navigationBackButtonJapnes];
    }else
    {
        self.title = @"스마트폰➞PC 인증서 복사";
    }
    self.progressActive.hidden = NO;
    limtTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(timeLimt) userInfo:nil repeats:NO];
    [self getAuthCodeFromServer];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.timer invalidate];
    //[limtTimer invalidate];
    //[self dismiss];
    
    if (self.timer != nil && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
        
    }
    if (limtTimer != nil && [limtTimer isValid])
    {
        [limtTimer invalidate];
        limtTimer = nil;
    }
    
    self.progressActive.hidden = YES;
//    [progressActive release];
//    [firstAuthCode release], firstAuthCode = nil;
//    [secondAuthCode release], secondAuthCode = nil;
//    [connectionForExportCertificate release], connectionForExportCertificate = nil;
//    [receivedData release], receivedData = nil;
//    [timer release], timer = nil;
    
}

/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void) getAuthCodeFromServer
{
    //[self show];
    
    unsigned char *pP12 = NULL;
	int nP12len = 0;
	int ret = -1;
	NSString *msg = nil;
    
    unsigned char *pPassword = (unsigned char*)[self.certPwd UTF8String];
	int nPasswordlen = [self.certPwd length];
    
    int nReturn = IXL_nFilterKeyCheck();
    if(nReturn == 0)
    {
        ret = IXL_Get_PFXBuf_KeyChain([AppInfo.selectedCertificate index], AppInfo.eccData, &pP12, &nP12len);
    }else
    {
        // 선택된 인증서 p12데이터로 추출
        ret = IXL_Get_PFXBuf_KeyChain([AppInfo.selectedCertificate index], pPassword, nPasswordlen, &pP12, &nP12len);
    }
    
	if(ret != 0){
		NSString *errMsg = [[[NSString alloc] initWithUTF8String:GetErrorString(ret)] autorelease];
		msg = [NSString stringWithFormat: @"[%d][%@]", ret, errMsg];
		[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:msg];
        //[self dismiss];
        self.progressActive.hidden = YES;
        [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 내보내기 p12데이터 추출 실패.\n%@", msg]]];
        return;
	}
    
    self.receivedData = [[NSMutableData alloc]init];
    
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@%@?SVer=%@&Action=EXPORT&Size=%d",PROTOCOL_HTTPS,REAL_CERT_IMPORT_IP,CERT_IMPORT_URL,@"1.2",8]];
    
    NSLog(@"cert export url:%@",[NSString stringWithFormat:@"%@%@%@?SVer=%@&Action=EXPORT&Size=%d",PROTOCOL_HTTPS,REAL_CERT_IMPORT_IP,CERT_IMPORT_URL,@"1.2",8]);
    
    NSString *base64EncodedPKCS12 = [NSString stringWithFormat:@"%s", pP12];
	NSString *urlEncodedbase64EncodedPKCS12 = [base64EncodedPKCS12 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	urlEncodedbase64EncodedPKCS12 = [urlEncodedbase64EncodedPKCS12 stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	NSString *postString = [NSString stringWithFormat:@"&EncCert=%@", urlEncodedbase64EncodedPKCS12];
	NSData* postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:postData];
	[request setHTTPMethod:@"POST"];
    
    connectionForExportCertificate = [[NSURLConnection alloc] initWithRequest:request
																	 delegate:self];
    
    //NSLog(@"Org Str:%@",postString);
	//NSLog(@"Post enc String:%@",[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"암호화 테스트 :%@",postString]]);
    //NSLog(@"Post dec String:%@",[AppInfo eunheeya0225:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"암호화 테스트 :%@",postString]]]);
	if(nil == connectionForExportCertificate) {
		// connection error
        [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"통신객체 생성 실패.\n%@\n%@", @"connectionForExportCertificate nil", postString]]];
	}
}
#pragma mark --
#pragma mark NSURLConnection delegate method
- (void)connection:(NSURLConnection*)connection
didReceiveResponse:(NSURLResponse*)response
{
    //    self.response = response;
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection*)connection
  didFailWithError:(NSError*)error
{
    NSString *msg;
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        msg = @"You have failed to transfer a digital certificate.\nPlease try again to transfer a digital certificate.";
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        msg = @"電子証明書転送に失敗しました。\n電子証明書転送をもう一度やり直してください。";
    }else
    {
        msg = @"인증서 전송에 실패하였습니다.\n인증서 전송을 다시 시도해주시기 바랍니다.";
        
        [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 전송 실패.\n%@" ,[error description]]]];
    }
    msg = [NSString stringWithFormat:@"%@\n%@", msg, [error localizedDescription]];
    [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
	NSString *msg = nil;
	NSString* receivedDataAsString = [[[NSString alloc] initWithData:self.receivedData
															encoding:NSUTF8StringEncoding]
									  autorelease];
	if(nil == receivedDataAsString) {
		receivedDataAsString = [[[NSString alloc] initWithData:self.receivedData
													  encoding:NSEUCKRStringEncoding]
								autorelease];
	}
	
	NSLog(@"receivedDataAsString [%@]", receivedDataAsString);
	
	NSArray *parsedStr = [receivedDataAsString componentsSeparatedByString:@"$"];
	if([[parsedStr objectAtIndex:0] isEqualToString:@"OK"]){
		self.authCode = [parsedStr objectAtIndex:1];
        
	}
	else {
		NSString *errcode = [parsedStr objectAtIndex:1];
		NSString *errmsg = [[parsedStr objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		
		msg = [NSString stringWithFormat: @"[%@][%@]", errcode, errmsg];
		[SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 내보내기 인증번호 추출 실패.\n%@", receivedDataAsString]]];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
	}
	
	if( 8 <= [self.authCode length] )
	{
		firstAuthCode.text = [self.authCode substringToIndex:4];
        secondAuthCode.text = [self.authCode substringFromIndex:4];
        [self recallFunction];
	}
}

- (void) recallFunction
{
    [self getResponseFromServer];
}

- (void) getResponseFromServer
{
    NSString *msg;
    NSURL *url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@%@%@?SVer=%@&Action=GET_STATUS&AuthNum=%@",PROTOCOL_HTTPS,REAL_CERT_IMPORT_IP,CERT_IMPORT_URL,@"1.2",self.authCode]];
    
    
    NSLog(@"내보내기 결과 받기:%@",[NSString stringWithFormat:@"%@%@%@?SVer=%@&Action=GET_STATUS&AuthNum=%@",PROTOCOL_HTTPS,REAL_CERT_IMPORT_IP,CERT_IMPORT_URL,@"1.2",self.authCode]);
    /* 인증번호 수신 */
    //[SVProgressHUD show];
    //NSData *url_out = [[[NSData alloc] initWithContentsOfURL:url] autorelease];
    NSError *error;
    NSData *url_out = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    
    if ([url_out length] <= 0) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(recallFunction) userInfo:nil repeats:NO];
        return;
    }
    
    NSString *outStr = [[[NSString alloc] initWithData:url_out encoding:NSUTF8StringEncoding] autorelease];
    
    if(outStr == nil){
        outStr = [[[NSString alloc] initWithData:url_out encoding:NSEUCKRStringEncoding] autorelease];
    }
    
    
    NSArray *parsedStr = [outStr componentsSeparatedByString:@"$"];
    NSLog(@"parsedStr:%@", parsedStr);
    if ([parsedStr count] > 0)
    {
        
        if ([[parsedStr objectAtIndex:0] isEqualToString:@"OK"])
        {
            
            if ([[parsedStr objectAtIndex:1] isEqualToString:@"RECEIVE"])
            {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recallFunction) userInfo:nil repeats:NO];
                
            } else if ([[parsedStr objectAtIndex:1] isEqualToString:@"SEND"])
            {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(recallFunction) userInfo:nil repeats:NO];
                
            } else if ([[parsedStr objectAtIndex:1] isEqualToString:@"CANCEL"])
            {
                if (AppInfo.LanguageProcessType == EnglishLan)
                {
                    msg = @"You have failed to transfer a digital certificate.\nPlease try again to transfer a digital certificate.";
                }else if (AppInfo.LanguageProcessType == JapanLan)
                {
                    msg = @"電子証明書転送に失敗しました。\n電子証明書転送をもう一度やり直してください。";
                }else
                {
                    msg = @"인증서 전송에 실패하였습니다.\n인증서 전송을 다시 시도해주시기 바랍니다.\n[Error Code:cancel]";
                }
                [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 전송 Cancel 요청.\n%@", outStr]]];
                [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
                
                
            } else if ([[parsedStr objectAtIndex:1] isEqualToString:@"COMPLETE"])
            {
                [timer invalidate];
                [limtTimer invalidate];
                timer = nil;
                limtTimer = nil;
                
                if (AppInfo.LanguageProcessType == EnglishLan)
                {
                    msg = @"The transmission of a digital certificate has been completed.";
                }else if (AppInfo.LanguageProcessType == JapanLan)
                {
                    msg = @"電子証明書の転送が完了しました。";
                }else
                {
                    msg = @"인증서 전송이 완료되었습니다.";
                }
                [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:10 title:@"" message:msg language:AppInfo.LanguageProcessType];
            } else
            {
                
            }
        } else{
            
            if (AppInfo.LanguageProcessType == EnglishLan)
            {
                msg = @"You have failed to transfer a digital certificate.\nPlease try again to transfer a digital certificate.";
            }else if (AppInfo.LanguageProcessType == JapanLan)
            {
                msg = @"電子証明書転送に失敗しました。\n電子証明書転送をもう一度やり直してください。";
            }else
            {
                msg = @"인증서 전송에 실패하였습니다.\n인증서 전송을 다시 시도해주시기 바랍니다.";
            }
            [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 전송 응답실패.\n%@", outStr]]];
            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
            
        }
    }else
    {
        if (error)
        {
            msg = @"거래진행이 중단되었습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다. 이체실행중이셨으면 반드시 예금거래내역조회를 통하여 처리결과를 먼저 확인하시기 바랍니다.";
            msg = [NSString stringWithFormat:@"%@\n[%@]",msg,[error localizedDescription]];
            [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        }
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex:%i",alertView.tag);
    [AppDelegate.navigationController fadePopViewController];
    
    
}

- (void) timeLimt
{
    if (self.timer != nil && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
        
    }
    if (limtTimer != nil && [limtTimer isValid])
    {
        [limtTimer invalidate];
        limtTimer = nil;
    }
    
    NSString *msg;
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        msg = @"Certificate transfer processing time has been exceeded.\nPlease try again to transfer a digital certificate.";
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        msg = @"電子証明書転送処理時間が超過されました。電子証明書転送をもう一度やり直してください。 ";
    }else
    {
        msg = @"인증서 전송 처리시간이 초과되었습니다.\n인증서 전송을 다시 시도해 주시기 바랍니다.";
    }
    [SHBUtility writeErrorLog:[AppInfo sungsikjunsik0402:[NSString stringWithFormat:@"인증서 전송 처리시간 초과."]]];
    [UIAlertView showAlertLan:self type:ONFAlertTypeOneButton tag:20 title:@"" message:msg language:AppInfo.LanguageProcessType];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
@end
