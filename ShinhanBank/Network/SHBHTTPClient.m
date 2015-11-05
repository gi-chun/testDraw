//
//  SHBNetworkHandler.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBHTTPClient.h"
#import "TBXML.h"
#import "SHBXmlDataParser.h"
#import "SVProgressHUD.h"
#import "OFDataParser.h"
#import "SHBHTTPDummyClient.h"
#import "Encryption.h"
#import "SHBIdentity4ViewController.h"

/*
 #ifdef DEBUG
 //ssl 인증서가 유효하지 않아서 나는 오류일때 (테스트 서버에서만 사용 실제 배포시 주석처리 해야함)
 @interface NSMutableURLRequest (DummyInterface)
 +(BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host;
 +(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString *)host;
 @end
 #endif
 */

@interface SHBHTTPClient ()
{
    int limtTime;
    BOOL isPhoneinfo;
    BOOL isESign;
    BOOL isESignServerRequest;
    BOOL isSyncServerRequest;
    
}

- (void) showError:(NSString *)errorType error:(NSDictionary *)dict;
- (void) showSHTTPError:(int)statusCode;
- (NSString *) createBaseURL:(SHBTRType)trType serviceCode:(NSString *)aServiceCode path:(NSString *)urlPath;
- (NSString *) createXML:(SHBTRType)trType serviceCode:(NSString *)aServiceCode dictionary:(NSMutableDictionary *)dict;
- (NSString *) encodeStringXML:(NSString *)stringXML;

- (SHBDataSet *) parseXML:(NSData *)data;
- (void) certProcess:(NSError *)error;
- (void) checkReponseData;

@end

@implementation SHBHTTPClient

@synthesize delegate;
//@synthesize ssAgent;
@synthesize ssClient;

static SHBHTTPClient *sharedSHBHTTPClient = nil;

+ (SHBHTTPClient *)sharedSHBHTTPClient
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedSHBHTTPClient = [[self alloc] init];
    });
#else
    @synchronized(self)
    {
        if (sharedSHBHTTPClient == nil)
        {
            [[self alloc] init];
        }
    }
#endif
    
    return sharedSHBHTTPClient;
}

// 초기화.
- (id)init
{
    self = [super init];
	if (self)
    {
        
        
#if BOLCK_SMARTSAFE
        // 스마트세이프 에이전트/클라이언트 초기화;
        
        if (self.ssClient == nil)
        {   
            //self.ssAgent = [[SmartSafeAgent alloc] init];
            //self.ssClient = self.ssAgent.ssafeClient;
            self.ssClient = AppDelegate.ssAgent.ssafeClient;
        }
#endif
	}
    
	return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
	// 릴리즈되어서는 안될 객체 표시(또는 NSUIntegerMax, INT32_MAX 사용).
    return UINT_MAX;
}

- (void)release
{
    // 아무일도 안함.
}

- (id)autorelease
{
    return self;
}

#pragma mark - 프라이빗 메서드

// !!!: 안드로이드를 참고로 하였으므로, 실제 에러 전문 확인해야 함!
// 에러 전문 처리.
- (void)showError:(NSString *)errorType error:(NSDictionary *)dict
{
    
    Debug(@"\n------------------------------------------------------------------\
          \n에러 내용:%@\
          \n------------------------------------------------------------------", dict);
    
    if ([AppInfo.serviceCode isEqualToString:@"버젼정보"])
    {
        AppInfo.isGetVersionInfo = -1; //실패 상태
    }
    NSMutableString *errorMsg = [NSMutableString string];
    
    AppInfo.errorType = errorType;
    AppInfo.serviceOption = nil;
    AppInfo.isNfilterPK = NO;
    //서버에러가 발생되었다는것을 알려준다.
    [AppDelegate startTimer];
    
    if (isESign)
    {
        AppInfo.electronicSignString = @"";
        AppInfo.certProcessType = CertProcessTypeNo;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notiESignError" object:nil];
        isESign = NO;
    }
    /*
    if ([[dict objectForKey:SERVICE_CODE_XML_ELEMENT_KEY] isEqualToString:@"C2098"] ||
        [[dict objectForKey:SERVICE_CODE_XML_ELEMENT_KEY] isEqualToString:@"C2099"])
    {
        
    } else{
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notiServerError" object:dict];
        if (AppInfo.isBolckServerErrorDisplay)
        {
            AppInfo.isBolckServerErrorDisplay = NO;
            return;
        }
    }
    */
    
    if ([errorType isEqualToString:JSTAR_ERROR_XML_ELEMENT_KEY])
    {
        NSString *msg1 = [NSString stringWithFormat:@"%@\n",[dict objectForKey:@"ERR_DEFAULT_MSG1"]];
        NSString *msg2 = [dict objectForKey:@"ERR_DEFAULT_MSG2"];
        NSString *msg3 = [dict objectForKey:@"ERR_USER_MSG1"];
        NSString *msg4 = [dict objectForKey:@"ERR_USER_MSG2"];
        
		if ([msg1 isKindOfClass:[NSString class]]) {
			[msg1 isEmpty] ? : [errorMsg appendString:[msg1 stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"]];
		}
		if ([msg2 isKindOfClass:[NSString class]]) {
			[msg2 isEmpty] ? : [errorMsg appendString:[msg2 stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"]];
		}
		if ([msg3 isKindOfClass:[NSString class]]) {
			[msg3 isEmpty] ? : [errorMsg appendString:[msg3 stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"]];
		}
		if ([msg4 isKindOfClass:[NSString class]]) {
			[msg4 isEmpty] ? : [errorMsg appendString:[msg4 stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"]];
		}
        
    }
    else if ([errorType isEqualToString:WARNING_XML_ELEMENT_KEY])
    {
        NSString *msg;
        if ([[dict objectForKey:@"errorCode"] isEqualToString:@"0882"]) //실 인증서로 로그인
        {
            [[NSUserDefaults standardUserDefaults]settypeOfLoginCert:@"realCert"]; //실제 운영서버로 접속
            
            msg = @"운영 공인인증서를 제출하셨습니다. 지금부터는 운영 시스템으로 접속이 가능합니다.";
            //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:@"" message:msg];
            //custom alert 적용
            [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButtonServer tag:EXIT_ALERT_VIEW_TAG title:nil buttonTitle:nil message:msg];
            return;
        } else if  ([[dict objectForKey:@"errorCode"] isEqualToString:@"0881"]) //실 인증서로 로그인
        {
            [[NSUserDefaults standardUserDefaults]settypeOfLoginCert:@"testCert"]; //테스트 서버로 접속
            
            msg = @"테스트 공인인증서를 제출하셨습니다. 지금부터는 테스트 시스템으로 접속이 가능합니다.";
            //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:@"" message:msg];
            //custom alert 적용
            [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButtonServer tag:EXIT_ALERT_VIEW_TAG title:nil buttonTitle:nil message:msg];
            return;
            
        } else if  ([[dict objectForKey:@"errorCode"] isEqualToString:@"0008"])
        {
            
            msg = @"고객님의 안전한 금융거래를 보호하기 위해 자동 로그아웃 합니다.\n다시 로그인 해 주십시오.";
            //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:66666 title:@"" message:msg];
            //custom alert 적용
            [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButtonServer tag:66666 title:nil buttonTitle:nil message:msg];
            return;
            
        }else if  ([[dict objectForKey:@"errorCode"] isEqualToString:@"0016"])
        {
            NSString *tmpStr = [dict objectForKey:@"detail"];
            //NSLog(@"aaaa:%@",tmpStr);
            if (tmpStr == nil)
            {
                msg = @"고객님의 안전한 금융거래를 보호하기 위해 자동 로그아웃 합니다.\n다시 로그인 해 주십시오.";
            }else
            {
                msg = tmpStr;
            }
            [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButtonServer tag:66666 title:nil buttonTitle:nil message:msg];
            return;
        }else
        {
            NSString *msg = [dict objectForKey:@"msg"];
            msg = [msg stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"];
            //[errorMsg appendString:[NSString stringWithFormat:@"%@\n", [dict objectForKey:@"msg"]]];
            [errorMsg appendString:[NSString stringWithFormat:@"%@\n", msg]];
            NSString *msg2 = [dict objectForKey:@"detail"];
            [msg2 isEmpty] ? : [errorMsg appendString:[msg2 stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"]];
            
            if ([[dict objectForKey:@"errorCode"] isEqualToString:@"0014"]) // 다른 웹브라우저에서 로그인
            {
                //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:66666 title:@"" message:errorMsg];
                //custom alert 적용
                [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButtonServer tag:66666 title:nil buttonTitle:nil message:errorMsg];
                return;
            }
            
            if ([[dict objectForKey:@"errorCode"] isEqualToString:@"2222"]) {
                
                // 2222로 내려온 경우에는 일반 알럿으로 보여줘야 함 (에러알럿으로 보여주면 안됨)
                // 약관상품설명서에서 해당 상품의 약관설명서가 없어서 에러 난 경우 사용 (다른 전문에서도 사용될 가능성 있음)
                
                [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:errorMsg];
                return;
            }
        }
        
    }
    else if ([errorType isEqualToString:ERROR_XML_ELEMENT_KEY])
    {
        NSString *msg1 = [NSString stringWithFormat:@"[%@] ", [dict objectForKey:@"ErrorCode"]];
        NSString *msg2 = [dict objectForKey:@"ErrorMsg"];
        
        [msg1 isEmpty] ? : [errorMsg appendString:[msg1 stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"]];
        [msg2 isEmpty] ? : [errorMsg appendString:[msg2 stringByReplacingOccurrencesOfString:@"&#x0A;" withString:@"\n"]];
    }
    
    if ([[dict objectForKey:SERVICE_CODE_XML_ELEMENT_KEY] isEqualToString:@"C2098"] ||
        [[dict objectForKey:SERVICE_CODE_XML_ELEMENT_KEY] isEqualToString:@"C2099"])
    {
        
    } else{
        
        AppInfo.serverErrorMessage = errorMsg;
        
        
        if (AppInfo.isBolckServerErrorDisplay)
        {
            AppInfo.isBolckServerErrorDisplay = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiServerError" object:nil];
            return;
        } else
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notiServerError" object:nil];
        }
    }
    
    //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:errorMsg];
    //custom alert 적용
    if ([errorMsg isEqualToString:@"저장된 정보가 없습니다.\n신한S뱅크에서 다시 확인 부탁 드립니다."])
    {
        [AppDelegate.navigationController fadePopToRootViewController];
    }
    [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButtonServer tag:0 title:nil buttonTitle:nil message:errorMsg];
}

// S-HTTP-Status 에러 처리.
- (void)showSHTTPError:(int)statusCode
{
    NSString *errorMsg;
    
    switch (statusCode)
    {
        case 800:
            errorMsg = @"유효하지 않거나 등록되지 않은 인증서입니다. 확인후 이용하시기 바랍니다.";
            break;
            
        case 881:
            errorMsg = @"테스트 공인인증서를 제출하셨습니다. 지금부터는 테스트 시스템으로 접속이 가능합니다.";
            break;
            
        case 882:
            errorMsg = @"운영 공인인증서를 제출하셨습니다. 지금부터는 운영 시스템으로 접속이 가능합니다.";
            break;
            
        case 928:
            errorMsg = @"인증서 본인 확인에 실패했습니다.";
            break;
            
        case 900:
            errorMsg = @"10분동안 거래가 없어 고객님의 금융거래를 보호하기 위하여 자동으로 접속을 종료합니다. 확인을 누르시면 신한S뱅크가 종료됩니다. 재거래를 원하시면 프로그램을 다시 실행해주시기 바랍니다.[900]";
            break;
            
        case 904:
            errorMsg = @"거래진행이 중단되었습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다. 이체실행중이셨으면 반드시 예금거래내역조회를 통하여 처리결과를 먼저 확인하시기 바랍니다.";
            break;
            
        case 931:
            errorMsg = @"인증서가 만료되어 더 이상 사용할 수 없습니다.";
            break;
            
        default:
            errorMsg = [NSString stringWithFormat:@"알 수 없는 에러가 발생하였습니다[%d].", statusCode];
            break;
    }
    
    if ([AppInfo.serviceCode isEqualToString:@"버젼정보"])
    {
        AppInfo.isGetVersionInfo = -1; //실패 상태
    }
    // -------------------------------------------------------------------------
    // TODO: 화면 이동이 필요한 경우 UIAlertView의 델리게이트 추가해야 함!
    // -------------------------------------------------------------------------

    //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:statusCode title:@"" message:errorMsg];
    //custom alert 적용
    errorMsg = [NSString stringWithFormat:@"%@\n[Network Error Code:%i]",errorMsg,statusCode];
    [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButtonServer tag:statusCode title:nil buttonTitle:nil message:errorMsg];
    // -------------------------------------------------------------------------
}

// 서비스코드 유무에 따라 베이스 URL 생성.
- (NSString *)createBaseURL:(SHBTRType)trType serviceCode:(NSString *)aServiceCode path:(NSString *)urlPath
{
    NSString *baseURL;
    
    if (trType == SHBTRTypeServiceCode)
    {
        
        //baseURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, SERVER_IP, urlPath, aServiceCode];
        baseURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, urlPath, aServiceCode];
    }
    else
    {
        //baseURL = [NSString stringWithFormat:@"%@%@%@", PROTOCOL_HTTPS, SERVER_IP, urlPath];
        baseURL = [NSString stringWithFormat:@"%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, urlPath];
    }
    
    
    return baseURL;
}

// TODO: 누락된 전문 유형이 있는지 확인할 것!
// 전문유형에 따라 XML 포맷의 전문을 생성한다.
- (NSString *)createXML:(SHBTRType)trType serviceCode:(NSString *)aServiceCode dictionary:(NSMutableDictionary *)dict
{
    NSString *xml = @"";;
    SHBXmlDataParser *trGenerator = [[SHBXmlDataParser alloc] init];
    
    switch (trType)
    {
        case SHBTRTypeServiceCode:
        {
            SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                     dict] autorelease];
            aDataSet.serviceCode = aServiceCode;
            
            xml = [trGenerator generate:aDataSet];
        }
            break;
            
        case SHBTRTypeTask:
        {
            xml = [trGenerator genTaskTR:aServiceCode dictionary:dict];
        }
            break;
            
        case SHBTRTypeRequst:
        {
            xml = [trGenerator genRequestTR:dict];
        }
            break;
            
        case SHBTRTypeCert:
        {
            // TODO: 구현해야 함!
        }
            break;
            
        default:
            break;
    }
    
    [trGenerator release];
    
    return xml;
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
    
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"[" withString:@"%5B"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"]" withString:@"%5D"];
    
    return stringXML;
}

//- (void)parseXML:(NSData *)data
- (SHBDataSet *)parseXML:(NSData *)data
{
    
    
    // 델리게이트 실행.
    if ([self valueForKey:@"delegate"])
    {
        // 스탑와치 시작.
        #ifdef DEVELOPER_MODE
        [LPStopwatch start:@"전문 파싱"];
        #endif
        // 전문 파싱.
        NSError *error = nil;
        TBXML *tbxml = [[TBXML newTBXMLWithXMLData:data error:&error] autorelease];
        SHBDataSet *aDataSet = (SHBDataSet*)[[OFDataParser dataParser] parse: data];
        
        // 스탑와치 중지.
        #ifdef DEVELOPER_MODE
        [LPStopwatch stop:@"전문 파싱"];
        #endif
        
        
        
        //NSLog(@"TBXML elementName:%@",[TBXML elementName:tbxml.rootXMLElement]);
        
        if ([[TBXML elementName:tbxml.rootXMLElement] isEqualToString:JSTAR_ERROR_XML_ELEMENT_KEY] ||
            [[TBXML elementName:tbxml.rootXMLElement] isEqualToString:ERROR_XML_ELEMENT_KEY] ||
            [[TBXML elementName:tbxml.rootXMLElement] isEqualToString:WARNING_XML_ELEMENT_KEY])
        {
            
            // 에러 처리.
            DDLogError(@"Erase erro in service code: [%@]", [aDataSet objectForKey:SERVICE_CODE_XML_ELEMENT_KEY]);
            [self showError:[TBXML elementName:tbxml.rootXMLElement] error:aDataSet];
            AppInfo.serviceCode = nil;
            return nil;
        }
        
//        if (![AppInfo.serviceCode isEqualToString:@"앱정보전송"] &&
//            ![AppInfo.serviceCode isEqualToString:@"타이머블럭"] &&
//            ![AppInfo.serviceCode isEqualToString:@"알림설정"])
        if (![AppInfo.serviceCode isEqualToString:@"앱정보전송"] &&
            ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
        {
            AppInfo.serviceCode = [aDataSet objectForKey:SERVICE_CODE_XML_ELEMENT_KEY];
        }
        
        Debug(@"\n------------------------------------------------------------------\
              \n수신 전문 파싱 결과:%@\
              \n------------------------------------------------------------------", aDataSet);
        
        AppInfo.isBolckServerErrorDisplay = NO; // 서버에러를 노티로 받고 알럿을 직접 처리
        AppInfo.errorType = nil; //에러가 발생하지 않았다
        AppInfo.serviceOption = nil;
        //전문 실행날짜
        if([[aDataSet objectForKey:@"COM_TRAN_DATE"] length] > 0)
        {
            AppInfo.tran_Date = [aDataSet objectForKey:@"COM_TRAN_DATE"];
        }
        
        //전문 실행 시간
        if([[aDataSet objectForKey:@"COM_TRAN_TIME"] length] > 0)
        {
            AppInfo.tran_Time = [aDataSet objectForKey:@"COM_TRAN_TIME"];
        }
        
        BOOL isChange = NO;
        Encryption *encryptor = [[Encryption alloc] init];
        //보안 카드 번호 변경에 대비한 입력
        if ([[aDataSet objectForKey:@"COM_SEC_CHAL1"] length] > 0)
        {
            //보안카드 질의 번호 해킹에 대비한 암호화
            //AppInfo.secretChar1 = [aDataSet objectForKey:@"COM_SEC_CHAL1"];
            AppInfo.secretChar1 = [encryptor aes128Encrypt:[aDataSet objectForKey:@"COM_SEC_CHAL1"]];
            isChange = YES;
        }
        
        if ([[aDataSet objectForKey:@"COM_SEC_CHAL2"] length] > 0)
        {
            //AppInfo.secretChar2 = [aDataSet objectForKey:@"COM_SEC_CHAL2"];
            //보안카드 질의 번호 해킹에 대비한 암호화
            AppInfo.secretChar2 = [encryptor aes128Encrypt:[aDataSet objectForKey:@"COM_SEC_CHAL2"]];
            isChange = YES;
        }
        
        if (isChange)
        {
            //보안카드 질의값이 변경되었는지 알려준다.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSecureCard" object:nil];
        }
        
        if ([[aDataSet objectForKey:@"pub"] length] > 0)
        {
            
            //보안카드 질의 번호 해킹에 대비한 암호화
            AppInfo.nfilterPK = [aDataSet objectForKey:@"pub"];
            NSLog(@"서버에서 내려준 암호화 키값 :%@",AppInfo.nfilterPK);
        }
        
        [encryptor release];
        return aDataSet;
    }
    
    return nil;
    
}

// TODO: 공인인증센터 구현 시 마무리 해야햠! sFIlte 형식일경우
// 인증서 처리 과정.
- (void)certProcess:(NSError *)error
{
    
    
}

#pragma mark - 퍼블릭 메서드
//서비스를 거쳐서 처리할때
- (void)request:(NSString *)urlStr method: (NSString *)aMethod encoding: (NSStringEncoding)aEncoding mimeType:aMimeType postBody:(NSString *)aPostBody signText:(NSString *)eSignText signTitle:(NSString *)eSignTitle
{
    
       #ifndef DEVELOPER_MODE
        disable_gdb();
       #endif
   
    // 스탑와치 시작.
    #ifdef DEVELOPER_MODE
    [LPStopwatch start:@"전문 전송 <-> 수신"];
    #endif
    
    // TODO: 커스텀 액티비티 인디케이터 추가할 것!
    // 액티비티 인디게이터 시작.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [AppDelegate.window setUserInteractionEnabled:NO];
    
    //sso 로그인일 경우 무조건 로딩바 무조건 보이게 한다
    if ([AppInfo.serviceCode isEqualToString:@"autoLogin"])
    {
        isPhoneinfo = NO;
        [AppDelegate showProgressView];
    }else
    {
        if (!AppInfo.isStartApp && ![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"] && ![AppInfo.serviceCode isEqualToString:@"getAppList"])
        {
            isPhoneinfo = NO;
            [AppDelegate showProgressView];
            
            
        } else
        {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [AppDelegate.window setUserInteractionEnabled:YES];
            if ([AppInfo.serviceCode isEqualToString:@"앱정보전송"])
            {
                AppInfo.serviceCode = nil;
                isPhoneinfo = YES;
                
            }
        }
    }
    
    
    
    NSString *httpBody, *orgBody;
    if (eSignText == nil) {
        isESign = NO;
        
        orgBody = [NSString stringWithFormat:@"plainXML=%@", aPostBody];
        httpBody = [NSString stringWithFormat:@"plainXML=%@", [self encodeStringXML:aPostBody]];
        
    } else {
        isESign = YES;
        
        orgBody = [NSString stringWithFormat:@"%@&plainXML=%@&__signData__=%@&__signTitle__=%@",AppInfo.signedData,aPostBody,eSignText,eSignTitle];
        
        aPostBody = [self encodeStringXML:aPostBody];
        eSignText = [self encodeStringXML:eSignText];
        eSignTitle = [self encodeStringXML:eSignTitle];
         
        httpBody = [NSString stringWithFormat:@"%@&plainXML=%@&__signData__=%@&__signTitle__=%@",AppInfo.signedData,aPostBody,eSignText,eSignTitle];
        
    }
    
    Debug(@"\n------------------------------------------------------------------\
          \n전송 URL:%@\
          \n------------------------------------------------------------------", urlStr);
    Debug(@"\n------------------------------------------------------------------\
          \n전송 BODY:%@\
          \n------------------------------------------------------------------", orgBody);
    if (httpBody == nil || [httpBody length] == 0)
    {
        Debug(@"\n------------------------------------------------------------------\
              \nHTTP BODY 값이 널임 --> 비정상적 상황 발생\
              \n------------------------------------------------------------------");
        return;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    /*
     //ssl 인증서가 유효하지 않아서 나는 오류일때 (테스트 서버에서만 사용 실제 배포시 주석처리 해야함)
     #ifdef DEBUG
     [NSMutableURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
     NSLog(@"url : %@", url);
     #endif
     */
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:aMethod];   // !!! 보낼때는 EUC-KR, 받을 때는 UTF-8.
    [request setValue:OFMIMETypeFormURLEncoded forHTTPHeaderField:@"Content-Type"];
    
    //[request addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [request setHTTPBody:[NSData dataWithBytes:[httpBody UTF8String] length:[httpBody length]]];
    
    // SmartSafe 테스트.
#if BOLCK_SMARTSAFE
    //if (!AppInfo.isStartApp && ![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    if (![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    {
        [self.ssClient executeRequest:request delegate:self];
    }else
    {
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
#else
    [NSURLConnection connectionWithRequest:request delegate:self];
#endif
}

//서비스를 거치지 않고 다이렉트로 처리할때..(전자 서명이 필료한 전문은 사용 안됨 & 서명은 서비스 사용할것: RD가 친절히 알려줌^^)
- (void)sendData:(SHBTRType)trType serviceCode:(NSString *)aServiceCode path:(NSString *)urlPath obj:(id)delegateObj dictionary:(NSMutableDictionary *)dict
{
    
      #ifndef DEVELOPER_MODE
        disable_gdb();
      #endif
    
    // 스탑와치 시작.
    #ifdef DEVELOPER_MODE
    [LPStopwatch start:@"전문 전송 <-> 수신"];
    #endif
    if ((trType == SHBTRTypeServiceCode || trType == SHBTRTypeTask) && aServiceCode == nil)
    {
        return;
    }
    
    // TODO: 커스텀 액티비티 인디케이터 추가할 것!
    // 액티비티 인디게이터 시작.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [AppDelegate.window setUserInteractionEnabled:NO];
    
    //sso 로그인일 경우 무조건 로딩바 무조건 보이게 한다
    if ([AppInfo.serviceCode isEqualToString:@"autoLogin"])
    {
        AppInfo.isSSOLogin = YES;
        isPhoneinfo = NO;
        [AppDelegate showProgressView];
    }else
    {
        if (!AppInfo.isStartApp && ![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"] && ![AppInfo.serviceCode isEqualToString:@"getAppList"])
        {
            isPhoneinfo = NO;
            [AppDelegate showProgressView];
        }
        else
        {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [AppDelegate.window setUserInteractionEnabled:YES];
            if ([AppInfo.serviceCode isEqualToString:@"앱정보전송"])
            {
                AppInfo.serviceCode = nil;
                isPhoneinfo = YES;
            }
        }
    }
    
    
    
    // -------------------------------------------------------------------------
    // 델리게이트 설정(최종 데이터를 받을 화면).
    // -------------------------------------------------------------------------
    self.delegate = delegateObj;
    // -------------------------------------------------------------------------
    
    // 전문 생성.
    NSString *xml = [self createXML:trType serviceCode:aServiceCode dictionary:dict];
    
    // 전문 전송.
    NSString *httpBody, *orgBody;
    isESign = NO;
    //개인화 이미지적용에 의한 변경
    //if ([aServiceCode isEqualToString:@"A0010"]) {
    if ([aServiceCode isEqualToString:@"A1000"]) {
        orgBody = [NSString stringWithFormat:@"%@&plainXML=%@",AppInfo.signedData, xml];
        httpBody = [NSString stringWithFormat:@"%@&plainXML=%@",AppInfo.signedData, [self encodeStringXML:xml]];
        
    } else
    {
        if (([aServiceCode isEqualToString:@"C2090"] || [aServiceCode isEqualToString:@"C2096"]) && AppInfo.certProcessType == CertProcessTypeRenew) //인증서 갱신
        {
            orgBody = [NSString stringWithFormat:@"%@&plainXML=%@",AppInfo.signedData, xml];
            httpBody = [NSString stringWithFormat:@"%@&plainXML=%@",AppInfo.signedData, [self encodeStringXML:xml]];
            
        } else
        {
            orgBody = [NSString stringWithFormat:@"plainXML=%@", xml];
            httpBody = [NSString stringWithFormat:@"plainXML=%@", [self encodeStringXML:xml]];
        }
        
    }
    
    Debug(@"\n------------------------------------------------------------------\
          \n전송 URL:%@\
          \n------------------------------------------------------------------", urlPath);
    
    Debug(@"\n------------------------------------------------------------------\
          \n전송 BODY:%@\
          \n------------------------------------------------------------------", orgBody);
    
    if (httpBody == nil || [httpBody length] == 0)
    {
        Debug(@"\n------------------------------------------------------------------\
              \nHTTP BODY 값이 널임 --> 비정상적 상황 발생\
              \n------------------------------------------------------------------");
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[self createBaseURL:trType serviceCode:aServiceCode path:urlPath]];
    
    /*
     //ssl 인증서가 유효하지 않아서 나는 오류일때 (테스트 서버에서만 사용 실제 배포시 주석처리 해야함)
     #ifdef DEBUG
     [NSMutableURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
     #endif
     */
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:OFHTTPMethodPOST];   // !!! 보낼때는 EUC-KR, 받을 때는 UTF-8.
    [request setValue:OFMIMETypeFormURLEncoded forHTTPHeaderField:@"Content-Type"];
    
    //[request addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    
    [request setHTTPBody:[NSData dataWithBytes:[httpBody UTF8String] length:[httpBody length]]];
    
    
#if BOLCK_SMARTSAFE
    // SmartSafe 테스트.
    //if (!AppInfo.isStartApp && ![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    if (![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    {
        [self.ssClient executeRequest:request delegate:self];
    }else
    {
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
#else
    [NSURLConnection connectionWithRequest:request delegate:self];
#endif
}

// 전문 전송.
- (void)sendData:(SHBTRType)trType serviceCode:(NSString *)aServiceCode path:(NSString *)urlPath obj:(id)delegateObj data:(id)dict
{
    if (nil == dict)
    {
        // 전문의 헤더만 전송한다.
        [self sendData:trType serviceCode:aServiceCode path:urlPath obj:delegateObj dictionary:nil];
    }
    else
    {
        int bitSixSet = BIT_SIX_SET(dict);
        
        if (bitSixSet == 0)
        {
            // NSMutableDictionary.
            [self sendData:trType serviceCode:aServiceCode path:urlPath obj:delegateObj dictionary:dict];
        }
        else if (bitSixSet == 64)
        {
            // NSDictionary(NSMutableDictionary로 변환 후 사용.).
            [self sendData:trType serviceCode:aServiceCode path:urlPath obj:delegateObj dictionary:[NSMutableDictionary dictionaryWithDictionary:dict]];
        }
        else
        {
            DDLogCError(@"사용할 수 없는 데이터 타입 입니다!");
        }
    }
}
- (void)requestServerSign:(NSURLRequest *)request obj:(id)delegateObj
{
    
    [AppDelegate showProgressView];
    isESignServerRequest = YES;
    self.delegate = delegateObj;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [AppDelegate.window setUserInteractionEnabled:NO];
    //[NSURLConnection connectionWithRequest:request delegate:self];
#if BOLCK_SMARTSAFE
    //if (!AppInfo.isStartApp && ![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    if (![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    {
        [self.ssClient executeRequest:request delegate:self];
    }else
    {
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
#else
    [NSURLConnection connectionWithRequest:request delegate:self];
#endif
}

- (void)requestBlockED:(NSURLRequest *)request obj:(id)delegateObj
{
    //[AppDelegate showProgressView];
    isSyncServerRequest = YES;
    self.delegate = delegateObj;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [AppDelegate.window setUserInteractionEnabled:NO];
    //[NSURLConnection connectionWithRequest:request delegate:self];
#if BOLCK_SMARTSAFE
    //if (!AppInfo.isStartApp && ![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    if (![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    {
        [self.ssClient executeRequest:request delegate:self];
    }else
    {
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
#else
    [NSURLConnection connectionWithRequest:request delegate:self];
#endif
}

// 공인인증서 관련 전문을 전송한다.
- (void)requestCert:(NSURLRequest *)request
{
    // TODO: 커스텀 액티비티 인디케이터 추가할 것!
    // 액티비티 인디게이터 시작.
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDelegate 메서드

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
#if BOLCK_SMARTSAFE
    // SmartSafe 테스트.
    //if (!AppInfo.isStartApp && ![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    if (![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    {
        [self.ssClient connection:connection didFailWithError:error];
    }
    
#endif
    
    // TODO: 커스텀 액티비티 인디케이터 추가할 것!
    // 액티비티 인디케이터 중지.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (AppInfo.isSSOLogin)
    {
        AppInfo.isSSOLogin = NO;
    }
    
    [AppDelegate closeProgressView];
    
    [AppDelegate.window setUserInteractionEnabled:YES];
    
    
    Debug(@"통신 Error 발생:%@",[error localizedDescription]);
    
    if ([AppInfo.serviceCode isEqualToString:@"버젼정보"])
    {
        AppInfo.isGetVersionInfo = -1; //실패 상태
    }
    NSString *msg;
    msg = @"거래진행이 중단되었습니다. 무선통신(Wi-Fi 포함)망의 일시적인 문제일 수 있습니다. 확인을 누르시면 메인으로 이동합니다. 이체실행중이셨으면 반드시 예금거래내역조회를 통하여 처리결과를 먼저 확인하시기 바랍니다.";
    msg = [NSString stringWithFormat:@"%@\n[%@]",msg,[error localizedDescription]];
    //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:730603 title:@"" message:msg];
    //custom alert 적용
    [UIAlertView showAlertCustome:self type:ONFAlertTypeOneButtonServer tag:730603 title:nil buttonTitle:nil message:msg];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // SmartSafe 테스트.
    //[self.ssClient connection: connection didReceiveResponse: response];
    
    NSArray *cookies;
    NSDictionary *headers;
    
    // 받은 header들을 dictionary형태로 받고
    headers = [(NSHTTPURLResponse *)response allHeaderFields];
    

    if (headers != nil)
    {
        // headers에 포함되어 있는 항목들 출력
        for (NSString *key in headers)
        {
            //NSLog(@"Header: %@ = %@", key, [headers objectForKey:key]);
        }
        
        // cookies에 포함되어 있는 항목들 출력
        cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:[response URL]];
        
        if (cookies != nil)
        {
            NSLog(@"리턴 전문 Cookie 항목들 출력 !!");
            for (NSHTTPCookie *cookie in cookies)
            {
                //NSLog(@"Cookie: %@ = %@", [cookie name], [cookie value]);
                
                // 통신 상태 에러 처리.
                int statusCode = 0;
                if ([[[cookie name] lowercaseString] isEqualToString:@"s-http-status"])
                {
                    statusCode = [[cookie value] intValue];
                    [self showSHTTPError:statusCode];
                }
            }
        }
//        //쿠키를 저장한다.
//        NSLog(@"cooki dic:%@",[headers valueForKey:@"Set-Cookie"]);
//        
//        if([headers valueForKey:@"Set-Cookie"] != nil)
//        {
//            [[NSUserDefaults standardUserDefaults] setObject:[headers valueForKey:@"Set-Cookie"] forKey:@"Cookie"];
//        }
    }
    
    self.receivedData = [[[NSMutableData alloc] init] autorelease];
    [self.receivedData setLength:0];
    
#if BOLCK_SMARTSAFE
    // SmartSafe 테스트.
    //if (!AppInfo.isStartApp && ![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    if (![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    {
        [self.ssClient connection: connection didReceiveResponse: response];
    }
    
#endif
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
#if BOLCK_SMARTSAFE
    // SmartSafe 테스트.
    //if (!AppInfo.isStartApp && ![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    if (![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    {
        [self.ssClient connection: connection didReceiveData: data];
    }
    
#endif
    
    // 서버에서 받은 원 데이터.
    //DDLogInfo(@"did receive data %@", [NSString stringWithUTF8String:[data bytes]]);
    
    [super connection: connection didReceiveData: data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
#if BOLCK_SMARTSAFE
    // SamrtSafe 테스트.
    //if (!AppInfo.isStartApp && ![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    if (![AppInfo.serviceCode isEqualToString:@"앱정보전송"] && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    {
        [self.ssClient connectionDidFinishLoading: connection];
        if (self.ssClient.connectionDidFinished)
        {
            return;
        }
        
    }
    
#endif
    
    // TODO: 커스텀 액티비티 인디케이터 추가할 것!
    // 액티비티 인디케이터 중지.
    // 스탑와치 중지.
    #ifdef DEVELOPER_MODE
    [LPStopwatch stop:@"전문 전송 <-> 수신"];
    #endif
    AppInfo.serverErrorMessage = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
      #ifndef DEVELOPER_MODE
        disable_gdb();
      #endif
    
    
    if (!AppInfo.isStartApp && !isPhoneinfo) //앱 기동이 아니라면....
    {
        //[SVProgressHUD dismiss];
        if (!AppInfo.isSSOLogin)
        {
            [AppDelegate closeProgressView];
        }
    
    }
    
    [AppDelegate.window setUserInteractionEnabled:YES];
    
    if (self.receivedData == nil) {
        [self showSHTTPError:1000]; //알수 없는 에러
        return;
    }
    //NSString *s = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    //NSLog(@"return lowdata:%@",s);
    
    //NSString *flePath = [[SHBUtility getDocumentsDirectory] stringByAppendingPathComponent:@"autoBindData"];
    //[self.receivedData writeToFile:flePath atomically:YES];
    
    [self checkReponseData];
    
    SHBDataSet *aDataSet = nil;
    
    //엔필터pk값 가져오기
    if (isSyncServerRequest)
    {
        isSyncServerRequest = NO;
        if (delegate && [delegate respondsToSelector: @selector(client:didReceiveData:)])
        {
            [delegate client:self didReceiveData:self.receivedData];
            return;
        }
    }
    
    //전자서명 처리
    if (isESignServerRequest)
    {
        [AppDelegate startTimer];
        isESignServerRequest = NO;
        
        
        if (delegate && [delegate respondsToSelector: @selector(client:didReceiveString:)])
        {
            
            NSString *rtnStr = [[[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding] autorelease];
            
            if ([SHBUtility isFindString:rtnStr find:@"<WARNING errorCode="])
            {   isESign = YES;
                aDataSet = [self parseXML:self.receivedData];
                return;
            }else
            {
                [delegate client:self didReceiveString:rtnStr];
            }
            
            return;
        }
    } else
    {
        aDataSet = [self parseXML:self.receivedData];
    }
    
    //고객번호 항목이 잇는지 확인하고 잇으면 10자리인지 확인하고 9자리이면 앞에 0을 붙여 10자리로 만든다
    if (aDataSet[@"고객번호"])
    {
        if ([aDataSet[@"고객번호"] length] == 9)
        {
            aDataSet[@"고객번호"] = [NSString stringWithFormat:@"0%@",aDataSet[@"고객번호"]];
        }
    }
    
    // 2013.01.20 계좌 정보를 최신 정보로 교체
    if([AppInfo.serviceCode isEqualToString:@"D0011"] || [AppInfo.serviceCode isEqualToString:@"A1000"])
    {
        if ([AppInfo.serviceCode isEqualToString:@"D0011"])
        {
            [aDataSet setObject:AppInfo.userInfo[@"보안매체정보"] forKey:@"보안매체정보"];
            [aDataSet setObject:AppInfo.userInfo[@"최종접속시간"] forKey:@"최종접속시간"];
            [aDataSet setObject:AppInfo.userInfo[@"최종접속일자"] forKey:@"최종접속일자"];
            [aDataSet setObject:AppInfo.userInfo[@"고객성명"] forKey:@"고객성명"];
        }
        
        /*
        //정보추가 세팅(2014.06.10)
        [aDataSet setObject:AppInfo.userInfo[@"구PC등록동의여부"] forKey:@"구PC등록동의여부"];
        [aDataSet setObject:AppInfo.userInfo[@"안심거래서비스사용여부"] forKey:@"안심거래서비스사용여부"];
        [aDataSet setObject:AppInfo.userInfo[@"피싱방지이미지"] forKey:@"피싱방지이미지"];
        [aDataSet setObject:AppInfo.userInfo[@"피싱방지문구"] forKey:@"피싱방지문구"];
        [aDataSet setObject:AppInfo.userInfo[@"블랙리스트차단구분"] forKey:@"블랙리스트차단구분"];
        [aDataSet setObject:AppInfo.userInfo[@"이용기기등록여부"] forKey:@"이용기기등록여부"];
        [aDataSet setObject:AppInfo.userInfo[@"사기예방SMS통지여부"] forKey:@"사기예방SMS통지여부"];
        [aDataSet setObject:AppInfo.userInfo[@"안심거래가입여부"] forKey:@"안심거래가입여부"];
        [aDataSet setObject:AppInfo.userInfo[@"안심거래서비스팝업사용여부"] forKey:@"안심거래서비스팝업사용여부"];
        [aDataSet setObject:AppInfo.userInfo[@"카드이용동의여부"] forKey:@"카드이용동의여부"];
        */
        // 0216 추가
        if (AppInfo.userInfo[@"최종출금계좌"] && [AppInfo.serviceCode isEqualToString:@"D0011"])
        {
            [aDataSet setObject:AppInfo.userInfo[@"최종출금계좌"] forKey:@"최종출금계좌"];
        }
        //AppInfo.userInfo = [NSMutableDictionary dictionaryWithDictionary:aDataSet];
        AppInfo.accountD0011 = [NSMutableDictionary dictionaryWithDictionary:aDataSet];
        
    }
    
    //에러 발생
    if (aDataSet == nil)
    {
        return;
    }
    
    // 스마트이체 변경시에는 해지 후 등록해야 함 2014.10.08
    if (!([AppInfo.serviceCode isEqualToString:@"E5083"] && [AppInfo.commonDic[@"스마트이체등록변경"] isEqualToString:@"1"] && AppInfo.commonDic[@"해지전문"])) {
        
        // 스마트이체 변경시에는 전자서명 화면에서 전문을 두번 태우기 때문에 전자서명 문구를 초기화 하지 않아야 함
        
        AppInfo.electronicSignString = @"";
    }
    
    //타이머 시작
    if ([AppInfo.serviceCode isEqualToString:@"A0010"] || [AppInfo.serviceCode isEqualToString:@"A1000"] || [AppInfo.serviceCode isEqualToString:@"H1001"])
    {
        //개인화 이미지적용에 의한 변경
        //if ([AppInfo.serviceCode isEqualToString:@"A0010"])
        if (([AppInfo.serviceCode isEqualToString:@"A1000"] && [aDataSet[@"고객회원등급"] isEqualToString:@"1"]) || [aDataSet[@"COM_SVC_CODE"] isEqualToString:@"A0010"])
        {
            AppInfo.isLogin = LoginTypeCert;
        }else
        {
            AppInfo.isLogin = LoginTypeIDPW;
        }
        
        [AppDelegate startTimer];
        Debug(@"10분 타이머 시작");
        
        
        
    } else if (AppInfo.isLogin != LoginTypeNo && ![AppInfo.serviceCode isEqualToString:@"타이머블럭"] && !isPhoneinfo) //로그인 후 전문을 날리면 다시 초기화
    {
        
        [AppDelegate startTimer];
        
        
        Debug(@"10분 타이머 재시작");
        
    } else if (isPhoneinfo)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginNotice" object:nil];
    }
    
    if ([AppInfo.serviceCode isEqualToString:@"타이머블럭"])
    {
        AppInfo.serviceCode = @"";
    }
    
    //2014.07.25 3개월 이상 이체거래가 없을시 무조건 ARS 인증 로직을 태운다.
    //if (![aDataSet[@"블랙리스트차단구분"] isEqualToString:@"5"] && [AppInfo.serviceCode isEqualToString:@"D2001"] )
    if ([aDataSet[@"블랙리스트차단구분"] isEqualToString:@"5"])
    {
        //3개월 이상 이체 안한고객 ARS 인증 태움
        NSString *msg = @"전자금융 의심거래 방지를 위한\n본인확인절차 강화로\n추가인증을 진행하게\n되었습니다.\n추가인증 완료 후 거래하여\n주시기 바랍니다.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:10987 title:nil message:msg];
        return;
    }
    
    
    if (delegate && [delegate respondsToSelector: @selector(client:didReceiveDataSet:)])
    {
        
        [delegate client:self didReceiveDataSet:aDataSet];
    }
    else if (delegate && [delegate respondsToSelector: @selector(client:didReceiveData:)])
    {
        [delegate client:self didReceiveData:self.receivedData];
    }
    else if (delegate && [delegate respondsToSelector: @selector(client:didReceiveString:)])
    {
        
        [delegate client:self didReceiveString: [NSString stringWithCString: [self.receivedData bytes] encoding: self.encoding]];
    }
    
    AppInfo.isNeedBackWhenError = NO;    
}

- (void) checkReponseData
{
    //서버단도 못고치고 TBXML도 고치기 힘들고 기럼 내가 고쳐야지... 이게 최선인가??
    NSString *tmpstring = [[[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding] autorelease];
    
    NSArray *tmpArray = [tmpstring componentsSeparatedByString:@"/>"];
    
    NSMutableString *appendStr = [NSMutableString string];
    
    
    for (int i = 0; i < [tmpArray count]; i++)
    {
        //일반적인 케이스
        NSString *tmp = [tmpArray objectAtIndex:i];
        //NSLog(@"receive tmp:%@",tmp);
        
        NSRange range;
        range = [tmp rangeOfString:@"&lt;"];
        
        if (range.location != NSNotFound)
        {
            tmp = [tmpArray objectAtIndex:i];
            tmp = [tmp stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
        }
        
        range = [tmp rangeOfString:@">"];
        if (range.location != NSNotFound)
        {
            if ([SHBUtility isFindString:tmp find:@"value="])
            {
              //tmp = [tmp stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
              NSRange find1;
              find1 = [tmp rangeOfString:@"value="];
                //if (find1.location != NSNotFound)
                //{
                    NSString *tmpstr1 = [tmp substringFromIndex:find1.location];
                    //NSLog(@"tmpstr1:%@",tmpstr1);
                    if ([SHBUtility isFindString:tmpstr1 find:@">"])
                    {
                        
                        NSRange find2;
                        NSString *tmpstr2 = [tmpstr1 substringFromIndex:6];
                        
                        find2 = [tmpstr2 rangeOfString:@"value="];
                        if (find2.location == NSNotFound)
                        {
                            //NSLog(@"tmp:%@",tmp);
                            //NSLog(@"tmpstr2:%@",tmpstr2);
                            if (![SHBUtility isFindString:tmpstr2 find:@"<vector result="])
                            {
                            
                                tmp = [tmp stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]; 
                            }
                        
                        }
                        //tmp = [tmp stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
                    }
                //}
              
            }
        }
        
        range = [tmp rangeOfString:@"ErrorActivity=SendRequest"];
        
        if (range.location != NSNotFound)
        {
            
            tmp = [tmp stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
        }
        
        range = [tmp rangeOfString:@">>"];
        
        if (range.location != NSNotFound)
        {
            
            tmp = [tmp stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
        }
        
        range = [tmp rangeOfString:@"&apos;"];
        if (range.location != NSNotFound)
        {
            tmp = [tmp stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
            
        }
        
        //D3606 케이스
        range = [tmp rangeOfString:@"->"];
        if (range.location != NSNotFound)
        {
            
            NSRange range1;
            range1 = [tmp rangeOfString:@"<!"];
            
            if (range1.location == NSNotFound)
            {
                
                range1 = [tmp rangeOfString:@"-->"];
                if (range1.location == NSNotFound)
                {
                    tmp = [tmp stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
                }
                
            }
            
        }
        
        // F0010 케이스
        range = [tmp rangeOfString:@"&amp;"];
        if (range.location != NSNotFound)
        {
            tmp = [tmp stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            
        }
        
        tmp = [NSString stringWithFormat:@"%@/>",tmp];
        
        
        if (i == ([tmpArray count] - 1))
        {
            
            tmp = [tmp substringToIndex:([tmp length] - 2)];
        }
        
        [appendStr appendString:tmp];
        
    }
    
    self.receivedData = (NSMutableData *)[appendStr dataUsingEncoding:NSUTF8StringEncoding];
}

// self-signed certificates 처리를 위해...
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return [protectionSpace.authenticationMethod
			isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
        NSString *tmp = [SHBUtilFile getProxy];
        if ([tmp isEqualToString:@"y"])
        {
            NSLog(@"프록시 서버 접속!!");
            NSString *msg = @"비정상적인 접속으로 인해 서비스를\n종료합니다. 고객센터로 문의하여\n주시기 바랍니다.\n(문의:고객센터 1577-8000)";
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:nil message:msg];
            [[challenge sender] cancelAuthenticationChallenge:challenge];
            return;
        }else if ([tmp isEqualToString:@"n"])
        {
            
        }else
        {
            
        }
        
        SecTrustResultType result;
        SecTrustEvaluate(challenge.protectionSpace.serverTrust, &result);
        
        if(result == kSecTrustResultProceed || result == kSecTrustResultConfirm || result == kSecTrustResultUnspecified)
        {
            NSLog(@"정상 SSL 인증서");
            if ([challenge.protectionSpace.host isEqualToString:AppInfo.serverIP])
            {
                
                //호스트 검증
                NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
            }else
            {
                NSLog(@"신뢰되지 않는 호스트에 접속시도!!");
                NSString *msg = @"비정상적인 접속으로 인해 서비스를\n종료합니다. 고객센터로 문의하여\n주시기 바랍니다.\n(문의:고객센터 1577-8000)";
                [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:nil message:msg];
                [[challenge sender] cancelAuthenticationChallenge:challenge];
                return;
            }
        }
        else
        {
            NSLog(@"비정상 SSL 인증서");
            NSString *msg = @"비정상적인 접속으로 인해 서비스를\n종료합니다. 고객센터로 문의하여\n주시기 바랍니다.\n(문의:고객센터 1577-8000)";
            [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:EXIT_ALERT_VIEW_TAG title:nil message:msg];
            [[challenge sender] cancelAuthenticationChallenge:challenge];
            return;
        }
		// 다음 도메인만 신뢰한다.
		//if ([challenge.protectionSpace.host isEqualToString:REAL_SERVER_IP])
        //NSLog(@"aaaa:%@",AppInfo.serverIP);
//        if ([challenge.protectionSpace.host isEqualToString:AppInfo.serverIP])
//		{
//			NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//			[challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
//		}else
//        {
//            //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:nil message:@"신뢰되지 않은 호스트"];
//            NSLog(@"신뢰되지 않는 호스트에 접속시도!!");
//            [[challenge sender] cancelAuthenticationChallenge:challenge];
//            return;
//        }
	}
    
	//[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    
//    NSURLProtectionSpace *p = challenge.protectionSpace;
//    NSLog(@"1111:%i",p.isProxy);
//    NSLog(@"2222:%@",p.host);
//    NSLog(@"3333:%@",p.observationInfo);
//    NSLog(@"4444:%@",p.proxyType);
//    NSLog(@"5555:%@",p.description);
//    NSLog(@"6666:%@",p.debugDescription);
//    NSLog(@"7777:%@",p.protocol);
//    NSLog(@"8888:%@",p.realm);
//    
//    if (p.isProxy)
//    {
//        NSLog(@"Proxy connect");
//    }
    
}

/*
 - (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
 {
 NSURLProtectionSpace *p = challenge.protectionSpace;
 NSLog(@"1111:%i",p.isProxy);
 NSLog(@"2222:%@",p.host);
 NSLog(@"3333:%@",p.observationInfo);
 NSLog(@"4444:%@",p.proxyType);
 NSLog(@"5555:%@",p.description);
 
 if (p.isProxy)
 {
 NSLog(@"Proxy connect");
 }
 
 }
 */
#pragma mark - 얼럿뷰 델리게이트
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == EXIT_ALERT_VIEW_TAG)
    {
        // 앱 종료.
        exit(-1);
        return;
    }else if (alertView.tag == 66666)
    {
        //로그아웃 후 메인으로 이동
        
        [AppInfo logout];
        [AppDelegate initTimer];
        [AppDelegate.navigationController fadePopToRootViewController];
    }else if (alertView.tag == 730603)
    {
        [AppDelegate.navigationController popToRootViewControllerAnimated:NO];
    }else if (alertView.tag == 10987)
    {
        if (AppInfo.lastViewController != nil)
        {
            AppInfo.lastViewController = nil;
        }
        SHBIdentity4ViewController *viewController = [[SHBIdentity4ViewController alloc]initWithNibName:@"SHBIdentity4ViewController" bundle:nil];
        [viewController setServiceSeq:SERVICE_2MONTH_OVER];
        viewController.needsLogin = YES;
        [AppDelegate.navigationController.viewControllers[0] checkLoginBeforePushViewController:viewController animated:YES];
        //Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
        [viewController executeWithTitle:@"본인 확인절차 강화 서비스" Step:0 StepCnt:0 NextControllerName:@""];
        [viewController release];
    }
    
    if(AppInfo.isNeedBackWhenError)
    {
        AppInfo.isNeedBackWhenError = NO;
        [AppDelegate.navigationController fadePopViewController];
    }
}
#pragma mark - custome alertview
//- (void)showCustomAlert:(NSString *)errorMsg alertTag:(int)aTag
//{
//    //팝업뷰 오픈
//    SHBAlertPopupView *popupView = [[SHBAlertPopupView alloc] initWithString:errorMsg ButtonCount:1 SubViewHeight:160 alertTag:aTag];
//    popupView.delegate = self;
//    [popupView showInView:AppDelegate.window animated:YES];
//    [popupView release];
//    
//    
//}
- (void)confirmPopupViewWithButton:(UIButton*)sender
{
    NSLog(@"confirm");
}

- (void)popupViewDidCancel
{
    NSLog(@"cancel");
}


@end
