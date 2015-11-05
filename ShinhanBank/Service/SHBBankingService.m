//
//  SHBBankingService.m
//  OrchestraNative
//
//  Created by Jang, Seyoung on 8/31/12.
//  Copyright (c) 2012 Finger Inc. All rights reserved.
//

#import "SHBBankingService.h"
#import "SHBCertElectronicSignViewController.h"

static NSMutableDictionary *serviceInfo = nil;
BOOL isElectronicSign;
BOOL isVectorProcess;

@implementation SHBBankingService

+ (NSDictionary *)serviceInfo {
    
	if (serviceInfo == nil) {
		serviceInfo = [[NSMutableDictionary alloc] init];
	}
	return serviceInfo;
}

+ (void) addServiceInfo: (NSDictionary*) aServiceInfo
{
    
    [[SHBBankingService serviceInfo] addEntriesFromDictionary: aServiceInfo];
}

//경로 세팅
+ (NSString*) urlForServiceId: (int) serviceId
{
    NSArray *array = [[SHBBankingService serviceInfo] objectForKey: [NSNumber numberWithInt: serviceId]];
    NSString* serviceCode = [array objectAtIndex: 1];
    
    //NSLog(@"urlForServiceId:%@",serviceCode);
    return serviceCode;
}

+ (NSString*) serviceCodeForServiceId: (int) serviceId
{
    
    NSArray *array = [[SHBBankingService serviceInfo] objectForKey: [NSNumber numberWithInt: serviceId]];
    NSString* serviceCode = [array objectAtIndex: 0];
    return serviceCode;
}

-(id) init
{
    self = [super init];
    if(self)
    {
        self.parser = (SHBXmlDataParser *)[OFDataParser dataParser];
        self.binder = (OFDataBinder *)[OFDataBinder dataBinder];
        //        self.client = (SHBHTTPClient *)[OFHTTPClient httpClient];
        self.client = [[[SHBHTTPClient alloc] init] autorelease];
        //self.client = HTTPClient;
        self.client.delegate = self;
        isElectronicSign = NO;
        isVectorProcess = NO;
    }
    return self;
}

- (id) initWithServiceId: (int) aServiceId viewController: (UIViewController*) aViewController
{
    self = [self init];
    if(self)
    {
        self.serviceId = aServiceId;
        self.strServiceCode = @"";
        self.viewController = aViewController;
    }
    return self;
}

- (id) initWithServiceCode:(NSString *) aServiceCode viewController:(UIViewController*) aViewController
{
    self = [self init];
    if(self)
    {
        //        AppInfo.serviceCode = aServiceCode;
        self.strServiceCode = aServiceCode;
        self.viewController = aViewController;
    }
    return self;
}

// 베이스 URL 생성.
+ (NSString *)urlForServiceCode:(NSString *)serviceCode
{
    //    // TODO: 서비스 코드(전문 코드)에 따라 baseURL 생성하는 코드 추가할 것!
    //    NSString *servicePath;
    //    if ([serviceCode isEqualToString:SC_H1001])
    //    {
    //        servicePath = IDPW_LOGIN_URL;
    //    }
    //    else
    //    {
    //         servicePath = SERVICE_URL;
    //    }
    //
    //    NSString *baseURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTP, SERVER_IP, servicePath, serviceCode];
    //    Debug(@"\n--------------------------------------------------------------------\
    //          \n Request URL: [%@]\
    //          \n--------------------------------------------------------------------", baseURL);
    //
    //    return baseURL;
    NSString *servicePath;
    if ([serviceCode isEqualToString:@"CODE"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = CODE_URL;
        
    } else if ([serviceCode isEqualToString:@"D3604"] ||
               [serviceCode isEqualToString:@"D2033"] )
    {
        isVectorProcess  = NO;
        isElectronicSign = YES;
        servicePath = NEW_DEPOSIT_SIGN_URL;
        //        servicePath = TRANSFER_URL;
        
    } else if ([serviceCode isEqualToString:@"D0011"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = D0011_SERVICE_URL;
        
    }
	else if ([serviceCode isEqualToString:@"D5020"])
	{
		isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = D5020_SERVICE_URL;
	}
    else if ([serviceCode isEqualToString:@"D5022"])
	{
        if ([AppInfo.serviceOption isEqualToString:@"재형저축"]) {
            isVectorProcess  = NO;
            isElectronicSign = NO;
            servicePath = SERVICE_URL;
            
        } else {
            isVectorProcess  = NO;
            isElectronicSign = NO;
            servicePath = D5022_SERVICE_URL;
        }
 
	}

	else if ([serviceCode isEqualToString:@"H0013"] ||
             [serviceCode isEqualToString:@"H0011"] ||
             [serviceCode isEqualToString:@"F3730"] ||
             [serviceCode isEqualToString:@"D5220"] ||
             [serviceCode isEqualToString:@"D5230"] ||
             [serviceCode isEqualToString:@"D3601"] ||
             [serviceCode isEqualToString:@"D3621"] ||
             [serviceCode isEqualToString:@"D3622"] ||
             [serviceCode isEqualToString:@"D3602"] ||
             [serviceCode isEqualToString:@"D5010"] ||
             [serviceCode isEqualToString:@"F3740"] ||
             [serviceCode isEqualToString:@"D3609"] ||
             [serviceCode isEqualToString:@"H1009"] ||
             [serviceCode isEqualToString:@"E3017"] ||
             [serviceCode isEqualToString:@"E3018"] ||
             [serviceCode isEqualToString:@"A0051"] ||
             [serviceCode isEqualToString:@"A0052"] ||
             [serviceCode isEqualToString:@"E4001"]
             )
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = GUEST_SERVICE_URL;
        
    } //else if ([serviceCode isEqualToString:@"A0010"])
    //개인화 이미지적용에 의한 변경
    else if ([serviceCode isEqualToString:@"A1000"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = LOGIN_URL;
        
    } else if ([serviceCode isEqualToString:@"A0050"] || [serviceCode isEqualToString:@"H1001"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = IDPW_LOGIN_URL;
        
    } else if ([serviceCode isEqualToString:@"D2003"] ||
               [serviceCode isEqualToString:@"D2013"] ||
               [serviceCode isEqualToString:@"D2023"] ||
               [serviceCode isEqualToString:@"D2043"] ||
               [serviceCode isEqualToString:@"D2103"] ||
               [serviceCode isEqualToString:@"D2203"] ||
               [serviceCode isEqualToString:@"D2223"] ||
               [serviceCode isEqualToString:@"D2226"] ||
               [serviceCode isEqualToString:@"D2212"] ||
               [serviceCode isEqualToString:@"D2233"] ||
               [serviceCode isEqualToString:@"D6230"] ||
               [serviceCode isEqualToString:@"D6340"] ||
               [serviceCode isEqualToString:@"D7032"] ||
               [serviceCode isEqualToString:@"D7131"] ||
               [serviceCode isEqualToString:@"D7141"] ||
               [serviceCode isEqualToString:@"D7431"] ||
               [serviceCode isEqualToString:@"D7441"] ||
               [serviceCode isEqualToString:@"L1211"] ||
               [serviceCode isEqualToString:@"L1222"] ||
               [serviceCode isEqualToString:@"E4302"] ||
               [serviceCode isEqualToString:@"E4303"] ||
               [serviceCode isEqualToString:@"G0113"] ||
               [serviceCode isEqualToString:@"G0163"] ||
               [serviceCode isEqualToString:@"G0123"] ||
               [serviceCode isEqualToString:@"D2037"] ||
               [serviceCode isEqualToString:@"F3512"] ||
               [serviceCode isEqualToString:@"F2028"] ||
               [serviceCode isEqualToString:@"E1700"] ||
               [serviceCode isEqualToString:@"E1702"] ||
               [serviceCode isEqualToString:@"E2917"] ||
               [serviceCode isEqualToString:@"E2918"] ||
               [serviceCode isEqualToString:@"E4304"] ||
               [serviceCode isEqualToString:@"D3282"] ||
               [serviceCode isEqualToString:@"D3286"] ||
               [serviceCode isEqualToString:@"D5520"] ||
               [serviceCode isEqualToString:@"D6250"] ||
               [serviceCode isEqualToString:@"D6360"] ||
               [serviceCode isEqualToString:@"E4122"] ||
               [serviceCode isEqualToString:@"C2810"] ||
               [serviceCode isEqualToString:@"G1414"] ||
               [serviceCode isEqualToString:@"L1312"] ||
               [serviceCode isEqualToString:@"L1411"] ||
               [serviceCode isEqualToString:@"L1241"] ||
               [serviceCode isEqualToString:@"E3012"] ||
               [serviceCode isEqualToString:@"C2311"] ||
               [serviceCode isEqualToString:@"L1231"] ||
               [serviceCode isEqualToString:@"E4112"] ||
               [serviceCode isEqualToString:@"E4131"] ||
               [serviceCode isEqualToString:@"E4151"] ||
               [serviceCode isEqualToString:@"E4161"] ||
               [serviceCode isEqualToString:@"D3300"] ||
               [serviceCode isEqualToString:@"D3112"] ||
               [serviceCode isEqualToString:@"D3321"] ||
               [serviceCode isEqualToString:@"D3343"] ||
               [serviceCode isEqualToString:@"E3025"] ||
               [serviceCode isEqualToString:@"E3026"] ||
               [serviceCode isEqualToString:@"D3250"] ||  //쿠폰상품신규
               [serviceCode isEqualToString:@"D7302"] ||
               [serviceCode isEqualToString:@"D3277"] ||
               [serviceCode isEqualToString:@"E3021"] ||
               [serviceCode isEqualToString:@"E7011"] ||
               [serviceCode isEqualToString:@"L3211"] ||
               [serviceCode isEqualToString:@"D3287"] ||
               [serviceCode isEqualToString:@"E1730"] ||
               [serviceCode isEqualToString:@"E1740"] ||
               [serviceCode isEqualToString:@"E5081"] ||
               [serviceCode isEqualToString:@"E5086"] ||
               [serviceCode isEqualToString:@"L3661"] ||
               [serviceCode isEqualToString:@"L3226"] ||
               [serviceCode isEqualToString:@"L3227"] ||
               [serviceCode isEqualToString:@"L3228"])
    {
        isVectorProcess  = NO;
        isElectronicSign = YES;
        servicePath = TRANSFER_URL;
        
    } else if ([serviceCode isEqualToString:@"E5083"]) {
        
        isVectorProcess  = NO;
        
        if ([AppInfo.serviceOption isEqualToString:@"스마트이체등록변경"]) {
            
            isElectronicSign = NO;
            servicePath = SERVICE_URL;
        }
        else {
            
            isElectronicSign = YES;
            servicePath = TRANSFER_URL;
        }
        
    } else if ([serviceCode isEqualToString:@"D6012"])
    {
        if ([AppInfo.serviceOption isEqualToString:@"BA17_5"]) {
            isVectorProcess  = NO;
            isElectronicSign = NO;
            servicePath = SERVICE_URL;
        }
        else {
            isVectorProcess  = NO;
            isElectronicSign = YES;
            servicePath = TRANSFER_URL;
        }
        
    } else if ([serviceCode isEqualToString:@"D2111"])
    {
        isVectorProcess  = YES;
        isElectronicSign = YES;
        servicePath = D2111_TRANSFER_URL;
        
    } else if ([serviceCode isEqualToString:@"D2211"] ||
               [serviceCode isEqualToString:@"E4141"])
    {
        isVectorProcess  = YES;
        isElectronicSign = YES;
        servicePath = TRANSFER_URL;
        
    } else if ([serviceCode isEqualToString:@"C2316"])
    {
        if ([AppInfo.serviceOption isEqualToString:@"정보동의"]) {
            isVectorProcess  = NO;
            isElectronicSign = YES;
            servicePath = TRANSFER_URL;
            
        } else {
            isVectorProcess  = NO;
            isElectronicSign = NO;
            servicePath = SERVICE_URL;
        }
    } else if ([serviceCode isEqualToString:@"E4301"] ||
               [serviceCode isEqualToString:@"E4305"] ||
               [serviceCode isEqualToString:@"E4307"] ||
               [serviceCode isEqualToString:@"E4306"] ||
			   [serviceCode isEqualToString:@"E4308"] ||
               [serviceCode isEqualToString:@"E4310"]
               )
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        //        servicePath = VERSION_CHECK_URL;
		servicePath = GUEST_SERVICE_URL;	// 20121207_sjbae : URL 바뀜.
        
    } else if ([serviceCode isEqualToString:@"G0161"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = G0161_SERVICE_URL;
        
    } else if ([serviceCode isEqualToString:@"G0321"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = TAX_SERVICE_URL;
        
    } else if ([serviceCode isEqualToString:@"E2114"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = E2114_SERVICE_URL;
    } else if ([serviceCode isEqualToString:@"E2902"] ||
               [serviceCode isEqualToString:@"E2904"] ||
               [serviceCode isEqualToString:@"E2905"] ||
               [serviceCode isEqualToString:@"E2906"]
               )
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = CARD_SERVICE_URL;
        
    } else if ([serviceCode isEqualToString:@"C2090"] || [serviceCode isEqualToString:@"C2096"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        if (AppInfo.certProcessType == CertProcessTypeIssue || AppInfo.certProcessType == CertProcessTypeDel) {
            servicePath = CERT_ISSUE_URL;
        } else if (AppInfo.certProcessType == CertProcessTypeRenew || AppInfo.certProcessType == CertProcessTypeRegOrExpire) {
            servicePath = CERT_VID_URL;
        } else {
            NSLog(@"C2090 occure");
            servicePath = SERVICE_URL;
        }
    } else if ([serviceCode isEqualToString:@"C1401"] || [serviceCode isEqualToString:@"C1411"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = CERT_VID_URL;
        
    } else if ([serviceCode isEqualToString:@"C1101"] || //인증서발급
               [serviceCode isEqualToString:@"C1102"] || //인증서 발급
               [serviceCode isEqualToString:@"C2079"] || //인증서 관련 OTP확인
               [serviceCode isEqualToString:@"C1201"] || //인증서 폐기
               [serviceCode isEqualToString:@"C1202"] || //인증서 폐기
               [serviceCode isEqualToString:@"C1301"] || //인증서 갱신
               [serviceCode isEqualToString:@"C1302"] || //인증서 갱신
               [serviceCode isEqualToString:@"C1402"] || //인증서x 등록 + 해지(타행)
               [serviceCode isEqualToString:@"C1412"]    //인증서 등록 + 해지(타기관)
               )
        
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = CERT_ISSUE_URL;
        
    } else if ([serviceCode isEqualToString:@"E1826"] ||
               [serviceCode isEqualToString:@"E2116"] || //권유직원 조회
               [serviceCode isEqualToString:@"L3660"] )  //예상 대출 한도 조회
    {
        if (AppInfo.isLogin)
        {
            servicePath = SERVICE_URL;
        } else
        {
            servicePath = GUEST_SERVICE_URL;
        }
        
    } else if ([serviceCode isEqualToString:@"E2611"] ||
               [serviceCode isEqualToString:@"E2411"] ||
               [serviceCode isEqualToString:@"E2425"] ||
               [serviceCode isEqualToString:@"C2828"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = SMARTLETTER_COUPON_URL;
        
    } else if ([serviceCode isEqualToString:@"E2412"])
    {
        isVectorProcess  = YES;
        isElectronicSign = NO;
        servicePath = SMARTLETTER_COUPON_URL;
        
    } else if ([serviceCode isEqualToString:@"D2210"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = @"/common/smt/jsp/callSmtD2210Service.jsp?serviceCode=";
        
    } else if ([serviceCode isEqualToString:@"D3276"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = ELD_SERVICE_URL;
        
    } else if ([serviceCode isEqualToString:@"D1125"])
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = ELD_STANDARDINDEX_URL;
        
    } else if ([AppInfo.serviceOption isEqualToString:@"직장인무방문대출"] &&
               ([serviceCode isEqualToString:@"L3665"] ||
                [serviceCode isEqualToString:@"L3664"] ||
                [serviceCode isEqualToString:@"D3220"] ||
                [serviceCode isEqualToString:@"L3668"] ||
                [serviceCode isEqualToString:@"L3662"] ||
                [serviceCode isEqualToString:@"L3223"] ||
                [serviceCode isEqualToString:@"L3224"] ||
                [serviceCode isEqualToString:@"L3225"]))
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        servicePath = LOAN_SERVICE_URL;
        
    } else if ([serviceCode isEqualToString:@"C2142"])
    {
        isVectorProcess  = NO;
        isElectronicSign = YES;
        servicePath = TRANSFER_URL;
        
    } else if ([serviceCode isEqualToString:@"E2811"] || [serviceCode isEqualToString:@"E2812"] || [serviceCode isEqualToString:@"E2813"] || [serviceCode isEqualToString:@"E2814"])
    {
        isVectorProcess  = NO;
        isElectronicSign = YES;
        servicePath = TRANSFER_URL;
        
    } else if ([serviceCode isEqualToString:@"E4124"])
    {
        isVectorProcess  = NO;
        if ([AppInfo.serviceOption isEqualToString:@"fishing_query"])
        {
            isElectronicSign = NO;
        }else
        {
            isElectronicSign = YES;
        }
        servicePath = TRANSFER_URL;//SERVICE_URL; //TRANSFER_URL
    }else //일반 서비스
    {
        isVectorProcess  = NO;
        isElectronicSign = NO;
        if ([serviceCode isEqualToString:@"C2097"] &&
            ([AppInfo.serviceOption isEqualToString:@"계좌확인"] || [AppInfo.serviceOption isEqualToString:@"이용자계좌확인"]))
        {
            servicePath = GUEST_SERVICE_URL;
            
        }
        else if ([serviceCode isEqualToString:@"C2094"]) {
            
            servicePath = GUEST_SERVICE_URL;
        }
        else if ([serviceCode isEqualToString:@"E4149"] && [AppInfo.serviceOption isEqualToString:@"전자서명"])
        {
            isElectronicSign = YES;
            servicePath = TRANSFER_URL;
        } else if ([serviceCode isEqualToString:@"C2098"] || [serviceCode isEqualToString:@"C2099"])
        {
            //C2098, C2099에서 prevProtocol이 A0051이면 게스트 유알엘 구현해야됨
            if ([AppInfo.serviceOption isEqualToString:@"A0051"]) {
                servicePath = GUEST_SERVICE_URL;
            } else {
                servicePath = SERVICE_URL;
            }
            
        } else if ([serviceCode isEqualToString:@"C2222"])
        {
            isVectorProcess  = YES;
            servicePath = SERVICE_URL;
            
        }
        else //그외에는 service url
        {
            servicePath = SERVICE_URL;
        }
    }
    
    //return servicePath;
    
    //NSString *baseURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, SERVER_IP, servicePath, serviceCode];
    NSString *baseURL = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, servicePath, serviceCode];
    /*
     Debug(@"\n--------------------------------------------------------------------\
     \n Request URL: [%@]\
     \n--------------------------------------------------------------------", baseURL);
     */
    return baseURL;
}

- (void) requestDataSet: (SHBDataSet *)aDataSet
{
    [AppDelegate.window setUserInteractionEnabled:NO];
    [self performSelector:@selector(delyRequestService:) withObject:aDataSet afterDelay:0.3];
}

- (void) delyRequestService:(SHBDataSet *)aDataSet;
{
#ifndef DEVELOPER_MODE
    disable_gdb();
#endif
     
    
    //[SVProgressHUD show];
    if([self.strServiceCode isEqualToString:@""])
    {
        aDataSet.serviceCode = [SHBBankingService serviceCodeForServiceId: self.serviceId];
    }
    else
    {
        aDataSet.serviceCode = self.strServiceCode;
    }
    
    //AppInfo.serviceCode = aDataSet.serviceCode;
    
    //NSLog(@"service code:%@",aDataSet.serviceCode);
    //NSLog(@"service data:%@",aDataSet);
    
    if ([aDataSet.serviceCode isEqualToString:@"TASK"]) { //TASK 전문처리
        
        if ([[aDataSet objectForKey:@"taskAction"] isEqualToString:@"insertSbankWhiteList"])
        {
            self.parser.eSign = YES;
        } else if ([[aDataSet objectForKey:@"taskAction"] isEqualToString:@"updatetSbankWhiteList"])
        {
            self.parser.eSign = YES;
        }else if ([[aDataSet objectForKey:@"taskAction"] isEqualToString:@"insertGroupSsoAgree"])
        {
            self.parser.eSign = YES;
        }else
        {
            self.parser.eSign = NO;
        }
        
        self.parser.vectorCode = NO;
        NSString *serviceUrl = [SHBBankingService urlForServiceId: self.serviceId];  //기존
        //serviceUrl = [NSString stringWithFormat:@"%@%@%@", PROTOCOL_HTTPS, SERVER_IP, serviceUrl]; //기존
        serviceUrl = [NSString stringWithFormat:@"%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, serviceUrl]; //기존
        NSArray *array = [[SHBBankingService serviceInfo] objectForKey: [NSNumber numberWithInt: self.serviceId]];
        aDataSet.serviceTaskCode = [array objectAtIndex: 2];
        
        if ([array count] == 4)
        {
            aDataSet.TaskAndVector = @"Y";
            //aDataSet.TaskVectorSet =
        } else
        {
            aDataSet.TaskAndVector = @"N";
        }
        
        NSString *body = [self.parser generate:aDataSet];
        
        if (self.parser.eSign == NO)
        {
            
            [self.client request:serviceUrl postBody:body signText:nil signTitle:nil];
            
        } else
        {
            //전자서명을 할 수 있는 뷰 컨트롤러를 호출한다.
            SHBCertElectronicSignViewController *eSignViewController = [[SHBCertElectronicSignViewController alloc] initWithNibName:@"SHBCertElectronicSignViewController" bundle:nil];
            
            eSignViewController.httpBody = body; //전문 재전송을 위해 생성된 전문을 넘겨준다.
            eSignViewController.serviceUrl = serviceUrl;
            [AppDelegate.navigationController pushFadeViewController:eSignViewController];
            [eSignViewController release];
        }
        
        
    } else if ([aDataSet.serviceCode isEqualToString:@"REQUEST"]) {
        
        self.parser.eSign = NO;
        self.parser.vectorCode = NO;
        NSString *serviceUrl = [SHBBankingService urlForServiceId: self.serviceId];  //기존
        serviceUrl = [NSString stringWithFormat:@"%@%@%@", PROTOCOL_HTTPS, AppInfo.serverIP, serviceUrl]; //기존
        NSString *body = [self.parser generate:aDataSet];
        
        [self.client request:serviceUrl postBody:body signText:nil signTitle:nil];
        
        
    } else {
        
        //NSString * servicePath = [SHBBankingService urlForServiceId: self.serviceId];  //기존
        NSString * serviceUrl = [SHBBankingService urlForServiceCode: aDataSet.serviceCode];
        
        //NSString *url = [NSString stringWithFormat:@"%@%@%@%@", PROTOCOL_HTTP, SERVER_IP, servicePath, aDataSet.serviceCode]; //기존
        
        if (isElectronicSign == NO)
        {
            self.parser.eSign = NO;
        } else
        {
            self.parser.eSign = YES;
        }
        
        if (isVectorProcess == NO)
        {
            self.parser.vectorCode = NO;
            
        } else
        {
            //            for (int i = 0; i < [aDataSet count]; i++) {
            //                NSString *tmp = [[[NSString alloc] initWithFormat:@"vector%i",i ] autorelease];
            //                NSLog(@"object %i:%@",i,[aDataSet objectForKey:tmp]);
            //            }
            //            return;
            self.parser.vectorCode = YES;
        }
        
        NSString *body = [self.parser generate:aDataSet];
        
        //NSLog(@"serviceRequest: %@ \n %@", serviceUrl, body);
        
        //        if ([aDataSet.serviceCode isEqualToString:@"D2111"]) {
        //            return;
        //        }
        
        //[self.client request: url postBody: body]; //기존
        
        if (isElectronicSign == NO) {
            
            
            [self.client request:serviceUrl postBody:body signText:nil signTitle:nil];
            
        }
        else {
            //이니텍 모듈 변경으로 전자 서명창을 뛰운다.
            //[self.client request:serviceUrl postBody:body signText:AppInfo.electronicSignString signTitle:@""];
            
            //전자서명을 할 수 있는 뷰 컨트롤러를 호출한다.
            SHBCertElectronicSignViewController *eSignViewController = [[SHBCertElectronicSignViewController alloc] initWithNibName:@"SHBCertElectronicSignViewController" bundle:nil];
            
            eSignViewController.httpBody = body; //전문 재전송을 위해 생성된 전문을 넘겨준다.
            eSignViewController.serviceUrl = serviceUrl;
            [AppDelegate.navigationController pushFadeViewController:eSignViewController];
            [eSignViewController release];
            
        }
    }
}
@end
