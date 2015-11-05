//
//  SHBIdentity1ViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 13. 8. 2..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBIdentity1ViewController.h"
#import "SHBMobileCertificateViewController.h"
#import "SHBARSCertificateViewController.h"
#import "Encryption.h"
#import "SHBMobileCertificateService.h"
#import "SHBForeignCertificateViewController.h"

@interface SHBIdentity1ViewController () <SHBMobileCertificateDelegate, SHBARSCertificateDelegate>
{
    int btnStatus;
    int nextStep;
	int totalStep;
    NSString *nextViewControlName;
    NSString *titleName;
}
- (void)requestPhoneNumber;
@end

@implementation SHBIdentity1ViewController
@synthesize serviceSeq;
@synthesize contentsView1;
@synthesize contentsView2;
@synthesize noCertificateButton;
@synthesize secureMediaCode;

- (void)dealloc
{
    [secureMediaCode release];
    [noCertificateButton release];
    [contentsView1 release];
    [contentsView2 release];
    [_confirmButton release];
    [_cancelButton release];
    [_foreignButton release];
    [_subTitleLabel release];
    [_arsButton release];
    [_smsButton release];
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
    
    self.noCertificateButton.hidden = YES;
    
    if (serviceSeq == SERVICE_DEVICE_REGIST || serviceSeq == SERVICE_USER_INFO)
    {
        btnStatus = 2;
        [self.arsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
        [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        [self.smsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        [self.noCertificateButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        self.smsButton.hidden = YES;
        [self.foreignButton setFrame:CGRectMake(self.foreignButton.frame.origin.x, self.smsButton.frame.origin.y + 32, self.foreignButton.frame.size.width, self.foreignButton.frame.size.height)];
        [self.arsButton setFrame:CGRectMake(self.arsButton.frame.origin.x, self.smsButton.frame.origin.y, self.arsButton.frame.size.width, self.arsButton.frame.size.height)];
        [self.arsButton setTitle:@" ARS 인증" forState:UIControlStateNormal];
    }else
    {
        if ([self.data[@"인증서추가인증신청여부"] isEqualToString:@"N"] && serviceSeq == SERVICE_CERT)
        //if ([self.data[@"인증서추가인증신청여부"] isEqualToString:@"Y"] && serviceSeq == SERVICE_CERT && ![self.secureMediaCode isEqualToString:@"1"])
        {
            btnStatus = 4;
            self.noCertificateButton.hidden = NO;
            [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.smsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.noCertificateButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
        }else
        {
            btnStatus = 1;
            [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.noCertificateButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.smsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
            [self.arsButton setTitle:@" 유선전화 ARS 인증" forState:UIControlStateNormal];
        }
        
    }
    
    if (serviceSeq == SERVICE_USER_INFO || serviceSeq == SERVICE_DEVICE_REGIST)
    {
        self.contentsView1.hidden = YES;
    }else
    {
        self.contentsView2.hidden = YES;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height + 20)];
    }
    if (serviceSeq == SERVICE_DEVICE_REGIST || serviceSeq == SERVICE_USER_INFO)
    {
        btnStatus = 2;
    }else
    {
        btnStatus = 1;
    }
    
    AppInfo.isAllIdentyDone = NO;
    AppInfo.isAllIdenty = NO;
    if (AppInfo.commonDic[@"고객번호"]) {
        //AppInfo.customerNo = AppInfo.commonDic[@"고객번호"];
        if ([AppInfo.commonDic[@"고객번호"] length] == 9)
        {
            AppInfo.customerNo = [NSString stringWithFormat:@"0%@",AppInfo.commonDic[@"고객번호"]];
        }else
        {
            AppInfo.customerNo = AppInfo.commonDic[@"고객번호"];
        }
    }
    
    if (AppInfo.commonDic[@"실명번호"]) {
        
        Encryption *encryptor = [[Encryption alloc] init];
        AppInfo.ssn = [encryptor aes128Encrypt:AppInfo.commonDic[@"실명번호"]];
        //AppInfo.ssn = AppInfo.commonDic[@"실명번호"]; //이미 암호화 되어있음
        [encryptor release];
        
        
    }
    
    [self requestPhoneNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)navigationButtonPressed:(id)sender{
    
    [super navigationButtonPressed:sender];
    
    if (serviceSeq == SERVICE_USER_INFO)
    {
        UIButton *btnSender = (UIButton*)sender;
        if (btnSender.tag == NAVI_BACK_BTN_TAG)
        {
            [AppDelegate.navigationController fadePopViewController];
        }
    }
	/*
    //ios7 + xcode5 대응
    isQuickMenuSlideIn = NO;
	switch (btnSender.tag) {
		case NAVI_BACK_BTN_TAG:
			// 이전버튼
            
			[self.navigationController fadePopViewController];
			break;
		case NAVI_CLOSE_BTN_TAG:
			[self.navigationController fadePopToRootViewController];
			break;
		case NAVI_MENU_BTN_TAG:
			// 퀵메뉴버튼
			if (self.view.frame.origin.x == 0) {
                //ios7 + xcode5 대응
                isQuickMenuSlideIn = YES;
                [self.view viewWithTag:NAVI_MENU_BTN_TAG].accessibilityLabel = @"퀵메뉴닫기";
				[self slideIn];
			}else{
                [self.view viewWithTag:NAVI_MENU_BTN_TAG].accessibilityLabel = @"퀵메뉴보기";
				[self slideOut];
			}
			break;
			
		case NAVI_DIMM_BTN_TAG:
		case MAIN_DIMM_BTN_TAG:
			// 딤버튼(퀵메뉴닫기)
            [self.view viewWithTag:NAVI_MENU_BTN_TAG].accessibilityLabel = @"퀵메뉴보기";
			[self slideOut];
			break;
			
		case QUICK_HOME_TAG:
			// 홈버튼
			AppInfo.indexQuickMenu = 0;
			[self.navigationController fadePopToRootViewController];
			break;
		case QUICK_NOTICE_TAG:	// 알림버튼
            AppInfo.indexQuickMenu = 1;
            [self pushViewControllerQuickMenu:btnSender.tag];
            break;
		case QUICK_MYMENU_TAG:	// 마이메뉴버튼
            AppInfo.indexQuickMenu = 2;
            [self pushViewControllerQuickMenu:btnSender.tag];
            break;
		case QUICK_APPMORE_TAG:	// 앱더보기버튼
            AppInfo.indexQuickMenu = 3;
            [self pushViewControllerQuickMenu:btnSender.tag];
            break;
		case QUICK_SETTING_TAG:	// 환경설정버튼
            AppInfo.indexQuickMenu = 4;
            [self pushViewControllerQuickMenu:btnSender.tag];
            break;
		case QUICK_LOGOUT_TAG:	// 로그아웃버튼
            isQuickLogin = YES;
			[self pushViewControllerQuickMenu:btnSender.tag];
			break;
			
		default:
			break;
	}
     */
}

- (IBAction)buttonTouched:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    switch (tmpBtn.tag)
    {
        case 1000:
        {
            btnStatus = 1;
            [self.noCertificateButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.smsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
        }
            break;
        case 1001:
        {
            btnStatus = 2;
            [self.arsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
            [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.smsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.noCertificateButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        }
            break;
        case 1002:
            
            if (btnStatus == 1)
            {
                SHBMobileCertificateViewController *viewController = [[SHBMobileCertificateViewController alloc]initWithNibName:@"SHBMobileCertificateViewController" bundle:nil];
                [viewController setServiceSeq:serviceSeq];
                viewController.delegate = self;
                viewController.data = self.data;
                [self.navigationController pushFadeViewController:viewController];
                
                // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
                [viewController executeWithTitle:titleName Step:nextStep StepCnt:totalStep NextControllerName:nextViewControlName];
                [viewController subTitle:@"추가인증 (SMS 인증)" infoViewCount:MOBILE_INFOVIEW_1];
                
                
                
                [viewController release];
            }else if (btnStatus == 2)
            {
                SHBARSCertificateViewController *viewController = [[SHBARSCertificateViewController alloc]initWithNibName:@"SHBARSCertificateViewController" bundle:nil];
                [viewController setServiceSeq:serviceSeq];
                viewController.delegate = self;
                viewController.data = self.data;
                [self.navigationController pushFadeViewController:viewController];
                
                // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
                [viewController executeWithTitle:titleName Step:nextStep StepCnt:totalStep NextControllerName:nextViewControlName];
                [viewController subTitle:@"추가인증 (ARS 인증)" infoViewCount:ARS_INFOVIEW_1];
                [viewController release];
            }else if (btnStatus == 3)
            {
                SHBForeignCertificateViewController *viewController = [[SHBForeignCertificateViewController alloc]initWithNibName:@"SHBForeignCertificateViewController" bundle:nil];
                [viewController setServiceSeq:serviceSeq];
                //viewController.delegate = self;
                viewController.data = self.data;
                [self.navigationController pushFadeViewController:viewController];
                
                // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
                [viewController executeWithTitle:titleName Step:nextStep StepCnt:totalStep NextControllerName:nextViewControlName];
                [viewController subTitle:@"해외체류확인" infoViewCount:ARS_INFOVIEW_1];
                
                
                
                [viewController release];
            }else if (btnStatus == 4)
            {
                //인증서 발급시 인증 생략
                int objectIndex = [[AppDelegate.navigationController viewControllers] count] - 2;
                [[[AppDelegate.navigationController viewControllers] objectAtIndex:objectIndex] viewControllerDidSelectDataWithDic:nil];
            }
            break;
        case 1003:
        {
            if ([_delegate respondsToSelector:@selector(identity1ViewControllerCancel)]) {
                [_delegate identity1ViewControllerCancel];
            }
            
            [self.navigationController fadePopViewController];
            if (serviceSeq == SERVICE_USER_INFO)
            {
                [AppDelegate.navigationController fadePopViewController];
            }
        }
            break;
        case 1004:
        {
            btnStatus = 3;
            [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.smsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.foreignButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
            [self.noCertificateButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        }
            break;
        case 1005:
        {
            btnStatus = 4;
            [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.smsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
            [self.noCertificateButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 퍼블릭메서드

- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName
{
	self.title = aTitle;
    self.strBackButtonTitle = [NSString stringWithFormat:@"%@ %d단계", aTitle, step];
	
	nextStep = step + 1;
	totalStep = stepCnt;
	
	if (nextCtrlName) {
		SafeRelease(nextViewControlName);
		nextViewControlName = [[NSString alloc] initWithString:nextCtrlName];
	}
    
    if (self.serviceSeq == SERVICE_DEVICE_REGIST) {
        if (stepCnt < 11){
            UIButton	*stepButtn;
            
            for (int i=stepCnt; i>=1; i --) {
                stepButtn = (UIButton*)[self.view viewWithTag:i];
                float stepWidth = stepButtn.frame.size.width;
                float stepX = 311 - ((stepWidth+2) * ((stepCnt+1) - i));
                [stepButtn setFrame:CGRectMake(stepX, stepButtn.frame.origin.y, stepWidth, stepButtn.frame.size.height)];
                [stepButtn setHidden:NO];
                
                if (step >= i){
                    stepButtn.selected = YES;
                }else{
                    stepButtn.selected = NO;
                }
            }
        }
    }
    
    titleName = [[NSString alloc] initWithString:aTitle];
	
}

- (void)subTitle:(NSString *)subTitle
{
    [self.subTitleLabel setText:subTitle];
    
}

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
      nextViewController:(NSString *)nextViewController
{
    [self executeWithTitle:aTitle Step:step StepCnt:stepCount NextControllerName:nextViewController];
    [self subTitle:subTitle];
}

#pragma mark - cancel delegate

- (void)mobileCertificateCancel
{
    btnStatus = 1;
    [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
    [self.smsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
    [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
    [self.noCertificateButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
}

- (void)ARSCertificateCancel
{
//    btnStatus = 1;
//    [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
//    [self.smsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
//    [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
    
    if (serviceSeq == SERVICE_DEVICE_REGIST || serviceSeq == SERVICE_USER_INFO)
    {
        btnStatus = 2;
        [self.arsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
        [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        [self.smsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        [self.noCertificateButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
//        self.smsButton.hidden = YES;
//        [self.foreignButton setFrame:CGRectMake(self.foreignButton.frame.origin.x, self.arsButton.frame.origin.y + 30, self.foreignButton.frame.size.width, self.foreignButton.frame.size.height)];
//        [self.arsButton setFrame:CGRectMake(self.arsButton.frame.origin.x, self.smsButton.frame.origin.y, self.arsButton.frame.size.width, self.arsButton.frame.size.height)];
    }else
    {
        btnStatus = 1;
//        [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
//        [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
//        [self.smsButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
    }
}


//인증할 번호를 가져온다.
- (void)requestPhoneNumber
{
//    NSString *ipAddr = [SHBUtilFile getGlobalIPAddress];
//    if ([ipAddr length] == 0)
//    {
//        
//        ipAddr = @"";
//    }
    
    NSString *hdd1 = [SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"];
    
    if ([hdd1 length] > 20) {
        hdd1 = [hdd1 substringToIndex:20];
    }
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"업무구분" : @"4",
                           @"검색구분" : @"1",
                           @"검색번호" : AppInfo.customerNo,
                           @"은행구분" : @"1",
                           @"거래구분" : @"02",
                           //@"공인IP" : ipAddr,
                           @"공인IP" : @"",
                           @"사설IP" : @"",
                           @"MACADDRESS1" : @"",
                           @"MACADDRESS2" : @"",
                           @"MACADDRESS3" : @"",
                           @"프록시사용유무" : @"",
                           @"프록시서버IP" : @"",
                           @"프록시서버PORT" : @"",
                           @"프록시설정상태" : @"",
                           @"하드디스크정보" : hdd1,
                           @"모바일뱅킹폰번호" : @"",
                           @"UID" : @"",
                           @"FILLER" : @"",
                           }];
    
    
    NSInteger serviceID = 0;
    
    if ([[self getCodeValue:3] isEqualToString:@"E2114"]) {
        serviceID = MOBILE_CERT_E2114;
    }
    else if ([[self getCodeValue:3] isEqualToString:@"E2116"]) {
        serviceID = MOBILE_CERT_E2116;
    }
    else if ([[self getCodeValue:3] isEqualToString:@"E4001"]) {
        serviceID = MOBILE_CERT_E4001;
    }
    
    self.service = [[[SHBMobileCertificateService alloc] initWithServiceId:serviceID
                                                            viewController:self] autorelease];
    
    if (![[self getCodeValue:3] isEqualToString:@"E2114"]) {
        self.service.requestData = dataSet;
    }
    
    [self.service start];
}

- (NSString *)getCodeValue:(NSInteger)value
{
    NSString *serviceCode = @""; // 서비스코드
    NSString *separation = @""; // 구분
    NSString *code = @""; // 전문코드
    
	switch (serviceSeq) {
		case SERVICE_CERT:                  // 인증서 발급/재발급
			serviceCode = @"C1101";
            separation = @"A1";
            code = @"E2116";
            //code = @"S00001";
			break;
		case SERVICE_SIGN_UP:               // 조회회원서비스 가입
			serviceCode = @"H1009";
            separation = @"A3";
            code = @"E4001";
            //code = @"S00001";
			break;
		case SERVICE_PASSWORD:              // 이용자 비밀번호 등록
			serviceCode = @"A0052";
            separation = @"A4";
            code = @"E4001";
            //code = @"S00001";
			break;
		case SERVICE_USER_INFO:             // 고객정보변경
			serviceCode = @"C2310";
            separation = @"A5";
            code = @"E2114";
            //code = @"S00002";
			break;
		case SERVICE_CANCEL_GOODS:      // 예/적금 전체해지
			serviceCode = @"D3286";
            separation = @"A6";
            code = @"E2114";
            //code = @"S00002";
			break;
            
		case SERVICE_LOAN:                  // 예/적금 담보대출
			serviceCode = @"L1310";
            separation = @"A7";
            code = @"E2114";
            //code = @"S00002";
			break;
		case SERVICE_DEVICE_REGIST:          // 이용기기 등록 서비스
			serviceCode = @"E3012";
            separation = @"A8";
            code = @"E2114";
            //code = @"S00002";
			break;
		case SERVICE_300_OVER:              // 300만원 이상 이체시
			//serviceCode = @"E3012";
            serviceCode = @"D2003"; //2014.08.05 수정
            separation = @"A9";
            code = @"E2114";
			break;
        case SERVICE_FRAUD_PREVENTION_SMS:  // 사기예방 SMS 통지 서비스 신청/해제
			serviceCode = @"E4149";
            separation = @"A10";
            code = @"E2114";
            break;
        case SERVICE_DEVICE_REGIST_ADD:     // 이용기기 외 추가인증 신청/해제
			serviceCode = @"E4149";
            separation = @"A11";
            code = @"E2114";
            break;
        case SERVICE_USER_INFO_USE_SUPPLY:   // 본인정보 이용제공 조회시스템
			serviceCode = @"C2310";
            separation = @"A5";
            code = @"E2114";
            break;
		case SERVICE_BIZ_LOAN_ITEMIZE:      // 직장인 무방문대출 신청 (건별)
			serviceCode = @"L3225";
            separation = @"A20";
            code = @"E2114";
			break;
		case SERVICE_BIZ_LOAN_LIMIT:        // 직장인 무방문대출 신청 (한도)
			serviceCode = @"L3224";
            separation = @"A20";
            code = @"E2114";
			break;
            
//        case SERVICE_CHEET_DEFENCE_RE: // 안심거래신청
//            serviceCode = @"E2811";
//            separation = @"A12";
//            code = @"E2114";
//            break;
//        case SERVICE_CHEET_DEFENCE_CA: // 안심거래해지
//            serviceCode = @"E2814";
//            separation = @"A12";
//            code = @"E2114";
//            break;
//        case SERVICE_CARDSSO_AGREE: //신한카드 SSO 인증
//            serviceCode = @"SSO012";
//            separation = @"A13";
//            code = @"E2114";
//            break;
//        case SERVICE_IP_CHECK: //신한카드 SSO 인증
//            serviceCode = @"C2407";
//            separation = @"A14";
//            code = @"E2114";
//            break;
		default:
			break;
	}
    
    NSString *returnValue = @"";
    
    switch (value) {
        case 1: // 서비스코드
            returnValue = serviceCode;
            
            break;
        case 2: // 구분
            returnValue = separation;
            
            break;
        case 3: // 전문코드
            returnValue = code;
            
            break;
            
        default:
            break;
    }
    
    return returnValue;
}

#pragma mark - Network

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    
    
    self.data = aDataSet;
    
    if ([aDataSet[@"해외IP여부"] isEqualToString:@"Y"])
    {
        //이체, 인증센터 해외체류중이라면
        if (serviceSeq == SERVICE_CERT || serviceSeq == SERVICE_300_OVER)
        {
            self.foreignButton.hidden = NO;
        }else
        {
            self.foreignButton.hidden = YES;
        }
        
        
    }else
    {
      //[self.confirmButton setFrame:CGRectMake(self.confirmButton.frame.origin.x, self.confirmButton.frame.origin.y - 20, self.confirmButton.frame.size.width, self.confirmButton.frame.size.height)];
      //[self.cancelButton setFrame:CGRectMake(self.cancelButton.frame.origin.x, self.cancelButton.frame.origin.y - 20, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height)];
    }
    
    if ([aDataSet[@"인증서추가인증신청여부"] isEqualToString:@"N"] && serviceSeq == SERVICE_CERT)
    //if ([aDataSet[@"인증서추가인증신청여부"] isEqualToString:@"Y"] && serviceSeq == SERVICE_CERT && ![self.secureMediaCode isEqualToString:@"1"])
    {
        btnStatus = 4;
        self.noCertificateButton.hidden = NO;
        
        [self.arsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        [self.smsButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        [self.foreignButton setImage:[UIImage imageNamed:@"radio_off.png"] forState:UIControlStateNormal];
        [self.noCertificateButton setImage:[UIImage imageNamed:@"radio_on.png"] forState:UIControlStateNormal];
        
        if (self.foreignButton.hidden == YES)
        {
            [self.noCertificateButton setFrame:CGRectMake(self.noCertificateButton.frame.origin.x, self.foreignButton.frame.origin.y, self.noCertificateButton.frame.size.width, self.noCertificateButton.frame.size.height)];
        }
    }
    return YES;
}
@end
