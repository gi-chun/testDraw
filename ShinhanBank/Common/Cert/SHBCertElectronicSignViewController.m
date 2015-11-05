//
//  SHBCertElectronicSignViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 10. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertElectronicSignViewController.h"
#import "SHBBankingService.h"
#import "MoaSignSDK.h"
#import "INISAFEXSafe.h"
#import "SHBNoCertForCertLogInViewController.h"

#import "SHBAccountService.h"

@interface SHBCertElectronicSignViewController ()
{
    NSMutableArray *signDataArr;
    NSString *signDataStr;
    NSString *encrypteES;
    NSString *realPwd;
    int remineCount;
    int rowcount;
    int processStep;
    BOOL isMoasign;
    NSString *networkErrorMsg;
    BOOL retryCheck;
    int retryCnt;
}

@property (nonatomic, retain) NSMutableArray *marrCertificates;		// 공인인증서 배열


- (int)doSignOnPasswrod:(NSString*)ns_password vidText:(NSString*)ns_Vid signedData:(NSString**)ns_signedData;
- (int)doSendSignedDataString:(NSString*)ns_signedDataString vidText:(NSString*)ns_Vid outString:(NSString**)ns_outString;
- (NSString *)encodeStringXML:(NSString *)stringXML;
- (NSString *)stringSafeForXML:(NSString *)elementValue;

@end

@implementation SHBCertElectronicSignViewController
@synthesize mycertList;
@synthesize marrCertificates;
@synthesize certPWTextField;
@synthesize electronicsignTable;
@synthesize electronicsignTitle;
@synthesize httpBody;
@synthesize serviceUrl;
@synthesize confirmBtn;
@synthesize cancelBtn;

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mycertList release];
    [marrCertificates release];
    electronicsignTable = nil; [electronicsignTable release];
    certPWTextField = nil; [certPWTextField release];
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
    
    if (AppInfo.certProcessType == CertProcessTypeMoasignSign)
    {
        isMoasign = YES;
        
    } else
    {
        AppInfo.certProcessType = CertProcessTypeSign;
    }
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
}
- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (AppInfo.isLogin == LoginTypeIDPW)
    {
        AppInfo.selectedCertificate = nil;
    }
    AppInfo.certProcessType = CertProcessTypeNo;
    [mycertList release];
    [marrCertificates release];
    electronicsignTable = nil; [electronicsignTable release];
    certPWTextField = nil; [certPWTextField release];
    confirmBtn = nil; [confirmBtn release];
    cancelBtn = nil; [cancelBtn release];
    electronicsignTitle = nil;
    httpBody = nil; serviceUrl = nil;
    AppInfo.eccData = nil;
    retryCheck = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
//    {
//        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y - 20, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
//    }
    
    [self navigationBackButtonHidden];
    
    self.title = AppInfo.eSignNVBarTitle;
    remineCount = 5;
    retryCnt = 5;
    startTextFieldTag = 10;
    endTextFieldTag = 10;
    
    contentViewHeight = self.contentScrollView.frame.size.height;
    
    retryCheck = NO;
    //인증서 암호.
    [self.certPWTextField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:50];
    
    if (AppInfo.certProcessType == CertProcessTypeMoasignSign) //모아사인 처리
    {
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            self.title = @"Digital Certificate";
            [self navigationBackButtonEnglish];
        } else
        {
            self.title = @"전자 서명";
        }
        
        isMoasign = YES;
        NSString *originalString = nil;
        NSString *signTitleString = nil;
        NSString *displayType = nil;
        [MoaSignSDK getOriginalText:&originalString signTitle:&signTitleString displayType:&displayType];
       
        //NSArray *tmpArr = [AppDelegate.moaSignUrl componentsSeparatedByString:@"&"];
        
        if (nil != displayType && [@"1" isEqualToString:displayType]) {
            NSArray *tempArray = [originalString componentsSeparatedByString:@"\n"];
            //signDataArr = [[NSMutableArray alloc] initWithCapacity:[tempArray count]];
            signDataArr = [[NSMutableArray alloc] initWithCapacity:0];
            if  ([signTitleString length] > 0)
            {
                [signDataArr addObject:signTitleString];
            }
            
            for (int i=0; i < [tempArray count]; i++) {
                [signDataArr addObject:[tempArray objectAtIndex:i]];
            }
            
            [electronicsignTable reloadData];
        }else
            if (nil != displayType && [@"2" isEqualToString:displayType]) {
                
                //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:originalString];
                NSArray *tempArray = [originalString componentsSeparatedByString:@"\n"];
                //signDataArr = [[NSMutableArray alloc] initWithCapacity:[tempArray count]];
                signDataArr = [[NSMutableArray alloc] initWithCapacity:0];
                if  ([signTitleString length] > 0)
                {
                    [signDataArr addObject:signTitleString];
                }
                for (int i=0; i < [tempArray count]; i++)
                {
                    [signDataArr addObject:[tempArray objectAtIndex:i]];
                }
                
                [electronicsignTable reloadData];
            }
        
        
    } else
    {
        /*
        //서명될 내용을 보여준다.
        NSArray *tempArray = [[NSArray alloc] initWithArray:[AppInfo.electronicSignString componentsSeparatedByString:@"\n"]];
        signDataArr = [[NSMutableArray alloc] initWithCapacity:[tempArray count]];
        
        if ([tempArray count] == 0) {
            NSString *msg = @"전자서명데이터 생성 실패";
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
            
        } else {
            
 
            for (int i = 0; i < [tempArray count]; i++) {
                [signDataArr addObject:[tempArray objectAtIndex:i]];
            }
            
            [electronicsignTable reloadData];
        }
        */
        
        AppInfo.certProcessType = CertProcessTypeSign;
        
        //서버방식의 전자서명 변경건 처리
        //[self show]
        //수취인계좌명이 20Byte를 넘겨서 깨진 문자열로 넘어오는 경우 처리..2014.09.01
        if ([SHBUtility isFindString:AppInfo.electronicSignString find:@"�"])
        {
            AppInfo.electronicSignString = [AppInfo.electronicSignString stringByReplacingOccurrencesOfString:@"�" withString:@"?"];
        }
        
        NSArray *tempArray = [[NSArray alloc] initWithArray:[AppInfo.electronicSignString componentsSeparatedByString:@"\n"]];
        NSString *serviceUrl1 = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, SIGN_REQUEST_URL,AppInfo.electronicSignCode]; //기존
        //NSString *serviceUrl1 = [NSString stringWithFormat:@"%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, SIGN_REQUEST_URL]; //기존
        
        //NSLog(@"aaaa:%@",serviceUrl1);
        NSMutableString *rootElement = [NSMutableString string];
        [rootElement appendFormat:@"<FORMMSG signCode=\"%@\">", AppInfo.electronicSignCode];
        if (AppInfo.electronicSignTitle == nil) AppInfo.electronicSignTitle = @"";
        [rootElement appendFormat:@"<__signTitle__ value=\"%@\"/>", AppInfo.electronicSignTitle];
        [rootElement appendFormat:@"<__signData__ value=\""];
        
        for (int i = 0; i < ([tempArray count] - 1); i++)
        {
            //NSLog(@"tempArray%i:%@",i,[tempArray objectAtIndex:i]);
            if (i == ([tempArray count] - 2))
            {
                //[rootElement appendFormat:@"%@",[tempArray objectAtIndex:i]];
                [rootElement appendFormat:@"%@",[self stringSafeForXML:[tempArray objectAtIndex:i]]];
            } else
            {
                //[rootElement appendFormat:@"%@\n",[tempArray objectAtIndex:i]];
                [rootElement appendFormat:@"%@\n",[self stringSafeForXML:[tempArray objectAtIndex:i]]];
            }
            
            
        }
        // release 처리
        [tempArray release];
        [rootElement appendFormat:@"\"/>"];
        
        AppInfo.serviceOption = nil;
        
        [rootElement appendFormat:@"</FORMMSG>"];
        
        //Debug(@"보낼전자서명 생성:%@",rootElement);
        NSURL *theURL = [NSURL URLWithString:serviceUrl1];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];
        //NSString *httpBody = [self encodeStringXML:rootElement];
        NSString *httpBody1 = [NSString stringWithFormat:@"plainXML=%@",[self encodeStringXML:rootElement]];
        Debug(@"보낼전자서명 생성:%@",[NSString stringWithFormat:@"plainXML=%@",rootElement]);
        [request setHTTPMethod:OFHTTPMethodPOST];   // !!! 보낼때는 EUC-KR, 받을 때는 UTF-8.
        [request setValue:OFMIMETypeFormURLEncoded forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[NSData dataWithBytes:[httpBody1 UTF8String] length:[httpBody1 length]]];
     
        if (httpBody1 == nil || [httpBody1 length] == 0)
        {
            Debug(@"\n------------------------------------------------------------------\
                  \n서버에 보낼 전자 서명 HTTP BODY 값이 널임 --> 비정상적 상황 발생\
                  \n------------------------------------------------------------------");
            return;
        }
        [HTTPClient requestServerSign:request obj:self];
        processStep = 1;
        
    }
    if (AppInfo.isLogin == LoginTypeIDPW)
    {
        AppInfo.selectedCertificate = nil;
        self.mycertList = [NSMutableArray array];
        self.mycertList = [AppInfo loadCertificates];		// 공인인증서 목록 가져오기
        self.marrCertificates = [NSMutableArray array];

        if (AppInfo.selectedCertificate == nil && AppInfo.certificateCount > 0)
        {
            //유효한 인증서가 여러개이고 지정인증서가 없는경우
        }else if (AppInfo.selectedCertificate == nil && AppInfo.certificateCount == 0)
        {
            //유효한 인증서가 없는 경우 인증서 가져오기 화면으로 보내나?
        }else if (AppInfo.selectedCertificate != nil && AppInfo.certificateCount > 0)
        {
            //유효한 인증서가 한개이거나 지정인증서가 있는경우
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginClose) name:@"loginClose" object:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerEletronicSign:(id)sender
{
    
    NSString *msg;
    
    if (self.certPWTextField.text == nil || [self.certPWTextField.text length] == 0)
    {
        msg = @"인증서 암호를 입력하여 주십시오";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
		return;
    }
    //if (AppInfo.certProcessType == CertProcessTypeMoasignSign)
    if (isMoasign)
    {
        int nReturn = IXL_nFilterKeyCheck();
        int rtnCode = -1;
        if(nReturn == 0)
        {
            rtnCode = [MoaSignSDK runCheckPKeyPasswordData:AppInfo.eccData cert:AppInfo.selectCertificateInfomation];
        }else
        {
            rtnCode = [MoaSignSDK runCheckPKeyPassword:self.certPWTextField.text cert:AppInfo.selectCertificateInfomation];
        }
        
        if(0 == rtnCode)
        {
            int nReturn = IXL_nFilterKeyCheck();
            if(nReturn == 0)
            {
                [MoaSignSDK sendSignToServer:AppInfo.selectCertificateInfomation passwordData:AppInfo.eccData delegate:self];
            }else
            {
                [MoaSignSDK sendSignToServer:AppInfo.selectCertificateInfomation password:self.certPWTextField.text delegate:self];
            }
            
            return;
        } else
        {
            NSString *message = @"인증서 비밀번호가 잘못되었습니다.";
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:message];
            return;
        }
    }
    
    NSString *signDataString = nil;
    NSString *outMsg = nil;
    msg = nil;
    
    if (remineCount  < 1) {
        msg = [NSString stringWithFormat:@"인증서 최대 암호입력시도회수(5번)를 초과하였습니다."];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"암호 입력 오류" message:msg];
        return;
    }
    
    // 스마트이체 변경시에는 해지 후 등록해야 함 2014.10.08
    if ([AppInfo.commonDic[@"스마트이체등록변경"] isEqualToString:@"1"] && AppInfo.commonDic[@"해지전문"]) {
        
        AppInfo.serviceOption = @"스마트이체등록변경";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(E5083Error) name:@"notiServerError" object:nil];
        
        self.service = nil;
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"E5083" viewController:self] autorelease];
        
        self.service.requestData = AppInfo.commonDic[@"해지전문"];
        [self.service start];
        
        return;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiServerError" object:nil];
    
    //20byte 제약에 걸려 한글이 짤려서 1byte 이상한 기호로 들어오는것 치환 ///
    AppInfo.electronicSignString = [AppInfo.electronicSignString stringByReplacingOccurrencesOfString:@"�" withString:@"?"];
    
    AppDelegate.window.userInteractionEnabled = NO;
    Debug(@"업무단에서 받은 전자서명원문:%@",AppInfo.electronicSignString);
    int rtn = [self doSignOnPasswrod:self.certPWTextField.text orginalText:AppInfo.electronicSignString signedData:&signDataString];
    AppDelegate.window.userInteractionEnabled = YES;
    if (rtn == -2)
    {
        msg = @"거래진행이 중단되었습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다. 이체실행중이셨으면 반드시 예금거래내역조회를 통하여 처리결과를 먼저 확인하시기 바랍니다.";
        msg = [NSString stringWithFormat:@"%@\n[%@]",msg,networkErrorMsg];
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:@"" message:msg];
        return;
    }
    //NSLog(@"signDataString:%@",signDataString);
    if (rtn == 0)
    {
        rtn = [self doSendSignedDataString:signDataString outString:&outMsg];
        
    }
    
    if(rtn == 0)
    {
        //NSLog(@"Password is valid ");
//        msg = @"인증서 제출에 성공하였습니다.";
        //alertTag = 100;
        
    }else
    {
        if (outMsg)
        {
//            msg = outMsg;
        }else
        {
            //msg = [NSString stringWithFormat:@"[오류가 발생하였습니다.]\n[ErrorCd:%d]",rtn];
            if (rtn == 1052013) {
//                msg = @"인증서 암호가 올바르지 않습니다.";
                
                //전자서명 인증서 비밀번호 오류 방어코드
                if ([self checkPKeyPassword] == 0)
                {
                    [self registerEletronicSign:nil];
                    return;
                }else
                {
                    retryCheck = NO;
                }
                remineCount--;
                if (remineCount > 0) {
                    AppInfo.certProcessType = CertProcessTypeSign;
                    msg = [NSString stringWithFormat:@"선택된 인증서 암호가 맞지 않습니다. 암호를 다시 입력하십시오.\n(남은재시도횟수:%d)", remineCount];
                    [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"암호 입력 오류" message:msg];
                }
                
                
            }
        }
        //alertTag = 200;
        self.certPWTextField.text = @"";
        //[self.contentScrollView setContentOffset:CGPointZero animated:YES];
        //[self.certPWTextField becomeFirstResponder];
    }
    
}

- (IBAction)cancelEletronicSign:(id)sender
{
    
    if (isMoasign)
    {
        int nReturn = IXL_nFilterKeyCheck();
        if(nReturn == 0)
        {
            [MoaSignSDK sendSignToServer:nil passwordData:nil delegate:self];
        }else
        {
            [MoaSignSDK sendSignToServer:nil password:nil delegate:self];
        }
        
        
    }
    
    // 스마트이체 변경시에는 해지 후 등록해야 함 2014.10.08
    if ([AppInfo.commonDic[@"스마트이체등록변경"] isEqualToString:@"1"] && AppInfo.commonDic[@"해지전문"]) {
        
        AppInfo.serviceOption = @"";
        
        AppInfo.commonDic = nil;
    }
    
    Debug(@"전자서명 noti 날림");
    AppInfo.certProcessType = CertProcessTypeNo;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"eSignCancel" object:nil];
    [self.navigationController popViewControllerAnimated:NO];
    
    
}

- (void) loginClose
{
    //confirmBtn.hidden = NO;
    //cancelBtn.hidden = NO;
    //self.contentScrollView.scrollEnabled = YES;
    [self.contentScrollView setContentSize:CGSizeMake(self.contentScrollView.frame.size.width, contentViewHeight)];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self performSelector:@selector(scrollForce) withObject:nil afterDelay:0.1];
        
    }else
    {
        [self.contentScrollView setContentOffset:CGPointZero animated:YES];
    }
    
}
- (void)scrollForce
{
    AppInfo.scrollBlock = YES;
    [self.contentScrollView setContentOffset:CGPointMake(0, -20) animated:YES];
    
}

- (void)E5083Error
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiServerError" object:nil];
    
    [self cancelEletronicSign:nil];
}

#pragma mark - initech process
/**
 * @brief	: doSignOnPasswrod:vidText:signedData:		[ 서명된 데이터를 취득한다. ]
 * @param	: [IN] NSString* ns_password				[ 인증서 암호 ]
 * @param	: [IN] NSString* ns_Vid						[ 서명원문 ]
 * @param	: [OUT]NSString** ns_signedData				[ 제출할 서명 데이터 (base64) ]
 * @return
 *		성공 : 0
 *		실패 : 에러코드(XSafe, Core)
 */
- (int)checkPKeyPassword
{
    NSString *strPKeypass = self.certPWTextField.text;
	int ret = -1;
    ret = IXL_CheckPOP([AppInfo.selectedCertificate index], (char *)[strPKeypass UTF8String], (int)[strPKeypass length]);
    
    if (ret == 0 && retryCnt == 5)
    {
        retryCheck = YES;
        retryCnt--;
    }else
    {
        ret = -1;
        retryCnt = 5;
        
    }
    return ret;
}

- (int)doSignOnPasswrod:(NSString*)ns_password orginalText:(NSString*)ns_originalText signedData:(NSString**)ns_signedData{
    
    // 테스트용 인증서로 할수 있게 우회 방법 찾은 후 주석 풀어야 함
    //통신처리
//    NSURL *url = [NSURL URLWithString:
//                  [NSString stringWithFormat:@"%@%@%@",PROTOCOL_HTTPS,REAL_SERVER_IP,CERT_TIME_URL]];
    NSURL *url = [NSURL URLWithString:
                      [NSString stringWithFormat:@"%@%@%@",PROTOCOL_HTTPS,AppInfo.serverIP,CERT_TIME_URL]];
    
    
    //NSLog(@"url:%@",[NSString stringWithFormat:@"%@%@%@",PROTOCOL_HTTPS,REAL_CERT_IMPORT_IP,CERT_TIME_URL]);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSString* in_vd;
    NSData *url_out = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error];
    
    // release 처리
    NSString *sTime = [[[NSString alloc] initWithData:url_out encoding:NSUTF8StringEncoding] autorelease];
    
    NSRange range1 = [sTime rangeOfString:@"<TOLBA01>"];
    
    if (range1.location > 0)
    {
        NSString *serverTime = [sTime substringFromIndex:(range1.location + 22)];
        
        NSRange range2 = [serverTime rangeOfString:@"\"/></TOLBA01>"];
        
        if (range2.location > 0)
        {
            serverTime = [serverTime substringToIndex:range2.location];
            
            url_out = [serverTime dataUsingEncoding:NSUTF8StringEncoding];
        }
        
    }
    
    
    if (nil != url_out && 0 < [url_out length]) {
        in_vd = [[[NSString alloc] initWithData:url_out
                                       encoding:NSUTF8StringEncoding]
                 autorelease];
        if(nil == in_vd) {
            in_vd = [[[NSString alloc] initWithData:url_out
                                           encoding:NSEUCKRStringEncoding]
                     autorelease];
        }
    }
    else
    {
        //NSString *msg = [NSString stringWithFormat: @"서버시간을 가져오지 못하였습니다."];
        
        //*ns_outString = msg;
        networkErrorMsg = [error localizedDescription];
        return -2;
    }
    
    
    //서버시간 취득
    time_t tm;
    struct tm *recv_tim;
    int ret = IXL_Get_Server_Time((char*)[in_vd UTF8String], &tm);
    
    if( -1 == ret)
    {
        //#if DEBUG // 서버시간을 가져오지 못하여 에러 처리할 경우
        //msg = [NSString stringWithFormat: @"서버시간을 가져오지 못하였습니다."];
        //*ns_outString = msg;
        //return -1;
        //#else // 단말기 시간을 설정하여 진행할 경우
        time(&tm);
        //#endif
    }
    //타임존이 외국으로 설정되어 있는경우 대비
    tzset();
    setenv("TZ", "Asia/Seoul", 1);
    
    recv_tim = localtime(&tm);
    
    NSLog(@"오늘은 %d년 %d월 %d일 %d요일 입니다. \n 현재 %d시 %d분 %d초 입니다."
          , recv_tim->tm_year+1900
          , recv_tim->tm_mon+1
          , recv_tim->tm_mday
          , recv_tim->tm_wday
          ,recv_tim->tm_hour
          , recv_tim->tm_min
          , recv_tim->tm_sec);
    
    unsigned char *outcertdata = NULL;
    unsigned char *outsigndata = NULL;
    //unsigned char *outrandom = NULL;
    int outcertdata_len = 0;
    int outsigndata_len = 0;
    //int outrandom_len = 0;
    
    //서명원문
    //NSString *ns_indata = [NSString stringWithFormat:@"%@",ns_originalText];
    //char *indata = [ns_indata UTF8String];
    
    NSString *ns_indata = [NSString stringWithFormat:@"%@",ns_originalText];
    char *indata = (char*)[ns_indata cStringUsingEncoding:NSEUCKRStringEncoding];
    
    int indata_len = strlen(indata);
    char *password = (char*)[ns_password UTF8String];
    int password_len = strlen(password);
    
    //취득 인증서의 키체인 인덱스
    if (AppInfo.loginCertificate != nil)
    {
        AppInfo.selectedCertificate = AppInfo.loginCertificate;
    }
    int cert_index = [AppInfo.selectedCertificate index];
    
    //서명원문의 암호화
//    ret = IXL_PKCS7_Cert_With_Random(cert_index/* cert index */, 0 /* with random flag */, recv_tim, (unsigned char*)password, password_len, (unsigned char *)indata, indata_len, 1 /* base64 encoding flag */, &outcertdata, &outcertdata_len, &outsigndata, &outsigndata_len);
    
    int nReturn = IXL_nFilterKeyCheck();
    
    if (retryCheck)
    {
        //예전방법으로 서명
        nReturn = -1;
        AppInfo.isNfilterPK = NO;
    }
    
    if(nReturn == 0)
    {
        ret = IXL_PKCS7_Cert_With_Random(cert_index/* cert index */, 1 /* with random flag */, recv_tim, AppInfo.eccData, (unsigned char *)indata, indata_len, 1 /* base64 encoding flag */, &outcertdata, &outcertdata_len, &outsigndata, &outsigndata_len);
    }else
    {
        ret = IXL_PKCS7_Cert_With_Random(cert_index/* cert index */, 1 /* with random flag */, recv_tim, (unsigned char*)password, password_len, (unsigned char *)indata, indata_len, 1 /* base64 encoding flag */, &outcertdata, &outcertdata_len, &outsigndata, &outsigndata_len);
    }
    
    if (0 != ret) {
        return ret;
    }
    *ns_signedData = [NSString stringWithCString:(char*)outsigndata encoding:NSEUCKRStringEncoding];

    
    return 0;
}


/**
 * @brief	: doSendSignedDataString:outString:	[ 제출할 인증서를 전송한다. ]
 * @param	: [IN] NSString* ns_signedDataString[ 인증서 암호 ]
 * @param	: [OUT]NSString** ns_outString		[ 인증서 제출결과 ]
 * @return
 *		성공 : 0
 *		실패 : -1
 */
- (int)doSendSignedDataString:(NSString*)ns_signedDataString outString:(NSString**)ns_outString
{
    
    char *signdataUrlEnc = IXL_URLEncode((char*)[ns_signedDataString UTF8String]); //URL디코딩이 필요함.
    //char *signdataUrlEnc = IXL_URLEncode(ns_signedDataString); //URL디코딩이 필요함.
    
    NSString *postString = [NSString stringWithFormat:@"PKCS7SignedData=%s", signdataUrlEnc];
    
    //NSString *postString = [NSString stringWithFormat:@"PKCS7SignedData=%@", ns_signedDataString];
    AppInfo.signedData = nil;
    AppInfo.signedData = postString;
    
    //NSLog(@"AppInfo.signedData:%@",AppInfo.signedData);
    //20byte 제약에 걸려 한글이 짤려서 1byte 이상한 기호로 들어오는것 치환 ///
    self.httpBody = [self.httpBody stringByReplacingOccurrencesOfString:@"�" withString:@"?"];
    //NSLog(@"aaaa:%@",self.httpBody);
    [self.client request:self.serviceUrl postBody:self.httpBody signText:AppInfo.electronicSignString signTitle:AppInfo.electronicSignTitle];
    
    return 0;
}

- (void)client:(OFHTTPClient *)client didReceiveDataSet:(OFDataSet *)aDataSet
{
//    if (processStep == 1)
//    {
//        
//    } else
//    {
        Debug(@"전자서명 noti 날림");
        AppInfo.certProcessType = CertProcessTypeNo;
        [self.navigationController fadePopViewController];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"eSignFinalData" object:nil userInfo:aDataSet];
//    }
    
}

- (void)client:(OFHTTPClient *)client didReceiveString:(NSString *)string
{
    Debug(@"서버에서 받은 전자서명 원문:%@",string);
    NSArray *tempArray = [string componentsSeparatedByString:@">"];
    //NSLog(@"tempArray:%@",tempArray);
//    for (int i = 0; i < [tempArray count]; i++)
//    {
//        NSLog(@"string%i:%@",i,[tempArray objectAtIndex:i]);
//    }
    signDataArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *signTitle = [tempArray objectAtIndex:2];
    signTitle = [signTitle stringByReplacingOccurrencesOfString:@"<signTitle value=\"" withString:@""];
    signTitle = [signTitle stringByReplacingOccurrencesOfString:@"\"/" withString:@""];
    [signDataArr addObject:signTitle];
    /*
    NSString *signStr = [tempArray objectAtIndex:4];
    signStr = [signStr stringByReplacingOccurrencesOfString:@"<![CDATA[" withString:@""];
    signStr = [signStr stringByReplacingOccurrencesOfString:@"]]" withString:@""];
    */
    
    //NSLog(@"signStr:%@",signStr);
    NSRange find1, find2;
    find1 = [string rangeOfString:@"<![CDATA["];
    find2 = [string rangeOfString:@"]]></signData>"];
    NSRange range = {(find1.location + 9),((find2.location - find1.location) - 9)};
    
    NSString *signStr = @"";
    
    @try {
        signStr = [string substringWithRange:range];
    }
    @catch (NSException *exception) {
        signStr = string;
    }
    
    NSArray *tempArray2 = [signStr componentsSeparatedByString:@"\n"];
    
    
    //signDataArr = [[NSMutableArray alloc] initWithCapacity:0];
    //NSLog(@"signStr:%@",tempArray2);
   
    for (int i = 0; i < [tempArray2 count]; i++)
    {
        //[AppInfo addElectronicSign:[tempArray2 objectAtIndex:i]];
        //NSLog(@"signStr%i:%@",i,[tempArray2 objectAtIndex:i]);
        //if (![[tempArray2 objectAtIndex:i] isEqualToString:@""])
        //{
           [signDataArr addObject:[tempArray2 objectAtIndex:i]];
            
        //}
    }
    [electronicsignTable reloadData];
     
    AppInfo.electronicSignString = signStr;
    
}

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    // 스마트이체 변경시에는 해지 후 등록해야 함 2014.10.08
    if ([AppInfo.commonDic[@"스마트이체등록변경"] isEqualToString:@"1"] && AppInfo.commonDic[@"해지전문"]) {
        
        AppInfo.commonDic = nil;
        
        [self registerEletronicSign:nil];
        
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [[signDataArr objectAtIndex:indexPath.row] sizeWithFont:[UIFont systemFontOfSize:14]
                                                        constrainedToSize:CGSizeMake(300, 999)
                                                            lineBreakMode:NSLineBreakByTruncatingTail];
    
    if (size.height < 20.f) {
        return 20.f;
    }
//    else if (size.height > 75.f) {
//        return 75.f;
//    }
    else {
        return size.height;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (signDataArr == nil || [signDataArr count] == 0) {
		return 0;
	}
	else {
		return [signDataArr count];
	}
    
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	//NSLog(@"%d",indexPath.row);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [cell.textLabel setTextColor:RGB(44, 44, 44)];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    [cell.textLabel setNumberOfLines:0];
    [cell.textLabel setText:[signDataArr objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - SHBSecureDelegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    //[super textField:textField didEncriptedVaule:value];
    AppInfo.eccData = nil;
    realPwd = textField.text;
    AppInfo.eccData = aData;
    //Debug(@"EncriptedVaule: %@", textField.text);
//    if (!AppInfo.isiPhoneFive)
//    {
//      [self.contentScrollView setContentOffset:CGPointZero animated:YES];    
//    }
    [self.certPWTextField resignFirstResponder];
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self performSelector:@selector(scrollForce) withObject:nil afterDelay:0.1];
    }else
    {
        [self.contentScrollView setContentOffset:CGPointZero animated:YES];
    }
    
    [self registerEletronicSign:nil];
}


- (NSString *)encodeStringXML:(NSString *)stringXML
{
    // TODO: 추가 인코딩 사항이 있는지 확인할 것(현재는 기존 내용 그대로 임)!
    //stringXML = [stringXML stringByAddingPercentEscapesUsingEncoding:-2147482590];
    
    stringXML = [stringXML stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
//    
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"[" withString:@"%5B"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"]" withString:@"%5D"];
    
    return stringXML;
}

#pragma mark - Moasign
- (void)finishSign:(NSString*)errorCode
{
    NSString *resultString = nil;
    AppInfo.certProcessType = CertProcessTypeNo;
    if ([@"0" isEqualToString:errorCode]) {
        //인증서 데이터 전송처리와 동시에 제출처리 완료가 되므로 따로 처리를 호출할 필요가 없음.
        //화면위치 초기화
        [self.navigationController fadePopToRootViewController];
        //종료처리는 별도로 호출해야함
        [MoaSignSDK callbackWebPage];
    }else{
        resultString = [NSString stringWithFormat: @"서명 제출에 실패하였습니다.\n(error code:%@)",errorCode];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"전자서명 제출"
                              message:resultString
                              delegate:nil
                              cancelButtonTitle:@"확인"
                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];        // release 처리
    }
    
}
-(void) getElectronicSignCancel
{
    AppInfo.certProcessType = CertProcessTypeSign;
}
#pragma mark - UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[super alertView:alertView clickedButtonAtIndex:buttonIndex];
	
    if (alertView.tag == EXIT_ALERT_VIEW_TAG)
    {
        // 앱 종료.
        //exit(-1);
        [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
        
    }else if (alertView.tag == 1982)
    {
        [AppDelegate.navigationController fadePopToRootViewController];
        SHBNoCertForCertLogInViewController *viewController = [[SHBNoCertForCertLogInViewController alloc] initWithNibName:@"SHBNoCertForCertLogInViewController" bundle:nil];
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
        return;
    }else
    {
        [self.certPWTextField becomeFirstResponder];
    }
}

//서버에서 받아 들이지 못하는 문자열 치환
- (NSString *)stringSafeForXML:(NSString *)elementValue
{
    if ([SHBUtility isFindString:elementValue find:@"<E2K_CHAR="] || [SHBUtility isFindString:elementValue find:@"<E2K_NUM="])
    {
        return elementValue;
    }
    if (elementValue == nil || [elementValue length] == 0)
    {
        
        elementValue = @"";
    }
    
    NSString *tmpStr;
    tmpStr = [elementValue stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    if (tmpStr == nil)
    {
        elementValue = @"";
    }
    
    /*
    NSMutableString *str = [NSMutableString stringWithString:elementValue];
    NSRange all = NSMakeRange (0, [str length]);
    [str replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:all];
    [str replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:all];
    [str replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:all];
    [str replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:all];
    [str replaceOccurrencesOfString:@"'" withString:@"&apos;" options:NSLiteralSearch range:all];
    [str replaceOccurrencesOfString:@"�" withString:@"?" options:NSLiteralSearch range:all];
    return str;
    */
    
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    elementValue = [elementValue stringByReplacingOccurrencesOfString:@"�" withString:@"?"];
    return elementValue;
}

- (void)secureTextFieldDidBeginEditing:(SHBSecureTextField *)textField
{
    if (AppInfo.isLogin == LoginTypeCert)
    {
        [super secureTextFieldDidBeginEditing:textField];
    }else if (AppInfo.isLogin == LoginTypeIDPW && AppInfo.selectedCertificate == nil)
    {
        //인증서 리스트 팝업을 뛰운다.
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        NSString *dday;
        for (int i = 0; i < [self.mycertList count]; i++)
        {
            dday = [[self.mycertList objectAtIndex:i] expire];
            int dDay = [SHBUtility getDDay:dday];
            if (dDay < 0) //만료일이 지났으면...
            {
            }else
            {
                [tmpArray addObject:[self.mycertList objectAtIndex:i]];
            }
        }
        
        self.mycertList = tmpArray;
        
        [self.marrCertificates removeAllObjects];
       
        for (int i = 0; i < [self.mycertList count]; i++)
        {
            CertificateInfo *ci = self.mycertList[i];
            NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
            [mdic setObject:ci.user forKey:@"1"];
            [mdic setObject:[NSString stringWithFormat:@"발급자 : %@",ci.issuer] forKey:@"2"];
            [mdic setObject:[NSString stringWithFormat:@"만료일 : %@",ci.expire] forKey:@"3"];
            [mdic setObject:ci.type forKey:@"4"];
            [self.marrCertificates addObject:mdic];
        }
        
        [self showPopupView];
        
    }else
    {
        [super secureTextFieldDidBeginEditing:textField];
    }
}

- (void)showPopupView
{
	
	if ([self.marrCertificates count]) {
		SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"인증서 목록"
																	   options:self.marrCertificates
																	   CellNib:@"SHBLoginSettingCell"
																		 CellH:69
																   CellDispCnt:5
																	CellOptCnt:3] autorelease];
		[popupView setDelegate:self];
		[popupView showInView:self.navigationController.view animated:YES];
	}
	else
	{
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:1982 title:@"" message:@"보유중인 인증서가 없습니다.\n인증서 가져오기 후 재시도해 주십시오."];
        
	}
}

#pragma mark - SHBListPopupView Delegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    
//    NSLog(@"bbbb:%@",self.marrCertificates);
//    NSLog(@"cccc:%i",anIndex);
//    NSLog(@"bbbb:%@",self.mycertList);
    
    CertificateInfo *certificate = [self.mycertList objectAtIndex:anIndex];
    AppInfo.selectedCertificate = certificate;
    //NSLog(@"dddd:%@",[certificate user]);
}

- (void)listPopupViewDidCancel
{
	AppInfo.selectedCertificate = nil;
}
@end
