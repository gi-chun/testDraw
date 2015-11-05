//
//  SHBMobileCertificateViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBMobileCertificateViewController.h"
#import "SHBMobileCertificateStep2ViewController.h"
#import "SHBMobileCertificateService.h"
#import "Encryption.h"
@interface SHBMobileCertificateViewController ()
<SHBMoblieCertificateStep2Delegate>

@property (retain, nonatomic) NSString *customerName;
@property (retain, nonatomic) NSString *phoneNumber;

- (BOOL)checkPhoneNumber;

- (NSString *)getCodeValue:(NSInteger)value;

- (void)requestMobileCert;

@end

@implementation SHBMobileCertificateViewController

@synthesize serviceSeq;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)navigationButtonPressed:(id)sender
{
    [super navigationButtonPressed:sender];
    
    if (AppInfo.isAllIdenty || AppInfo.isAllIdentyDone)
    {
        UIButton *btnSender = (UIButton*)sender;
        switch (btnSender.tag)
        {
            case NAVI_BACK_BTN_TAG:
            {
                AppInfo.isAllIdenty = NO;
                AppInfo.isAllIdentyDone = NO;
                AppInfo.isSMSIdenty = NO;
                AppInfo.isARSIdenty = NO;
                [AppDelegate.navigationController fadePopViewController];
            }
                break;
            case NAVI_CLOSE_BTN_TAG:
            {
                AppInfo.isAllIdenty = NO;
                AppInfo.isAllIdentyDone = NO;
                AppInfo.isSMSIdenty = NO;
                AppInfo.isARSIdenty = NO;
            }
                break;
            case QUICK_HOME_TAG:
            {
                AppInfo.isAllIdenty = NO;
                AppInfo.isAllIdentyDone = NO;
                AppInfo.isSMSIdenty = NO;
                AppInfo.isARSIdenty = NO;
            }
                break;
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        [self navigationBackButtonEnglish];
    } else if (AppInfo.LanguageProcessType == JapanLan)
    {
        [self navigationBackButtonJapnes];
    }else
    {
        
    }
    
    contentViewHeight = self.contentScrollView.contentSize.height;
    startTextFieldTag = 3331;
    endTextFieldTag = 3333;
    //NSLog(@"aaaa:%@",self.data);
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
        AppInfo.ssn = [encryptor aes128Encrypt:[AppInfo.commonDic[@"실명번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        [encryptor release];
    }
    
    if (AppInfo.isLogin == LoginTypeNo)
    {
        if (AppInfo.commonDic[@"고객명"]) {
            self.customerName = AppInfo.commonDic[@"고객명"];
        }
        else {
            if (self.data[@"고객성명"])
            {
                self.customerName = self.data[@"고객성명"];
            }else
            {
                self.customerName = @"";
            }
            
        }
    }else
    {
        self.customerName = AppInfo.userInfo[@"고객성명"];
    }
    
    
    if ([self.data[@"휴대폰상이"] isEqualToString:@"1"] ||
        [self.data[@"휴대폰번호"] length] == 0)
    {
        self.phoneNumber = @"등록된 전화번호가 없습니다.";
        
        [phoneNumberTF setText:_phoneNumber];
    }
    else
    {
        self.phoneNumber = self.data[@"휴대폰번호"];
        
        if ([_phoneNumber length] > 4) {
            NSString *number = [_phoneNumber substringWithRange:NSMakeRange(0, [_phoneNumber length] - 4)];
            [phoneNumberTF setText:[NSString stringWithFormat:@"%@****", number]];
        }
        else {
            [phoneNumberTF setText:_phoneNumber];
        }
    }
}

- (void)dealloc
{
    self.customerName = nil;
    self.phoneNumber = nil;
    
    [titleName release];
	[_nextViewControlName release];
	[mobileInfoDic release];
    
    [_stepView release];
    [phoneNumberTF release];
    [agreeButton release];
    [confirmButton release];
    [cancelButton release];
	
    [subTitleLabel release];
    [bottomView release];

    [infoView2 release];
    [infoView1 release];
    [bottomLabel release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Method

- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName
{
	self.title = aTitle;
    self.strBackButtonTitle = [NSString stringWithFormat:@"%@ %d단계", aTitle, step];
	
	nextStep = step + 1;
	totalStep = stepCnt;
	
	if (nextCtrlName) {
		SafeRelease(_nextViewControlName);
		_nextViewControlName = [[NSString alloc] initWithString:nextCtrlName];
	}
	
	// Max 10개까지만 Step 단계표시
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
	
    titleName = [[NSString alloc] initWithString:aTitle];
	mobileInfoDic = [[NSMutableDictionary alloc] initWithCapacity:0];
}

- (void)subTitle:(NSString *)subTitle infoViewCount:(MOBILE_INFOVIEW_COUNT)infoViewCount
{
    [subTitleLabel setText:subTitle];
    
    if (AppInfo.isAllIdenty)
    {
        infoView1 = infoView2;
    }
    [self.contentScrollView addSubview:infoView1];
    [self.contentScrollView addSubview:bottomView];
    
    [bottomView setFrame:CGRectMake(0,
                                    infoView1.frame.size.height,
                                    bottomView.frame.size.width,
                                    bottomView.frame.size.height)];
    
    [self.contentScrollView setContentSize:CGSizeMake(317, bottomView.frame.origin.y + bottomView.frame.size.height)];
    
    contentViewHeight = self.contentScrollView.contentSize.height;
}

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
           infoViewCount:(MOBILE_INFOVIEW_COUNT)infoViewCount
      nextViewController:(NSString *)nextViewController
{
    [self executeWithTitle:aTitle Step:step StepCnt:stepCount NextControllerName:nextViewController];
    [self subTitle:subTitle infoViewCount:infoViewCount];
}

#pragma mark -

- (NSString *)getCodeValue:(NSInteger)value
{
    NSString *serviceCode = @"";            // 서비스코드
    NSString *separation = @"";             // 구분
    NSString *code = @"";                   // 전문코드
    
	switch (serviceSeq) {
		case SERVICE_CERT:                  // 인증서 발급/재발급
			serviceCode = @"C1102";
            separation = @"S1";
            code = @"E2116";
			break;
		case SERVICE_OTHER_CERT:            // 타기관 공인인증서 등록/해지
			serviceCode = @"C1101";
            separation = @"S2";
            code = @"E2116";
			break;
		case SERVICE_SIGN_UP:               // 조회회원서비스 가입
			serviceCode = @"H1009";
            separation = @"S3";
            code = @"E4001";
			break;
		case SERVICE_PASSWORD:              // 이용자 비밀번호 등록
			serviceCode = @"A0052";
            separation = @"S4";
            code = @"E4001";
			break;
		case SERVICE_USER_INFO:             // 고객정보변경
			serviceCode = @"C2310";
            separation = @"S5";
            code = @"E2114";
			break;
		case SERVICE_CANCEL_GOODS:          // 예/적금 해지
			serviceCode = @"D3286";
            separation = @"S6";
            code = @"E2114";
			break;
		case SERVICE_LOAN:                  // 예/적금 담보대출
			serviceCode = @"L1310";
            separation = @"S7";
            code = @"E2114";
			break;
		case SERVICE_DEVICE_REGIST:         // 이용기기 등록 서비스
			serviceCode = @"E3012";
            separation = @"S8";
            code = @"E2114";
			break;
		case SERVICE_300_OVER:              // 300만원 이상 이체시
			//serviceCode = @"E3012";
            serviceCode = @"D2003"; //2014.08.05 수정
            separation = @"S9";
            code = @"E2114";
			break;
        case SERVICE_FRAUD_PREVENTION_SMS:  // 사기예방 SMS 통지 서비스 신청/해제
			serviceCode = @"E4149";
            separation = @"S10";
            code = @"E2114";
            break;
        case SERVICE_DEVICE_REGIST_ADD:     // 이용기기 외 추가인증 신청/해제
			serviceCode = @"E4149";
            separation = @"S11";
            code = @"E2114";
            break;
        case SERVICE_CHEET_DEFENCE_RE: // 안심거래신청
            serviceCode = @"E2811";
            separation = @"S12";
            code = @"E2114";
            break;
        case SERVICE_CHEET_DEFENCE_CA: // 안심거래해지
            serviceCode = @"E2814";
            separation = @"S12";
            code = @"E2114";
            break;
        case SERVICE_CARDSSO_AGREE: //신한카드 SSO 인증
            serviceCode = @"SSO012";
            separation = @"S13";
            code = @"E2114";
            break;
        case SERVICE_EXCEPTION_DEVICE: // 예외 기기 로그인 알림
            serviceCode = @"E3021";
            separation = @"S8";
            code = @"E2114";
            break;
        case SERVICE_USER_INFO_USE_SUPPLY:   // 본인정보 이용제공 조회시스템
			serviceCode = @"C2310";
            separation = @"A5";
            code = @"E2114";
            break;
		case SERVICE_BIZ_LOAN_ITEMIZE:      // 직장인 무방문대출 신청 (건별)
			serviceCode = @"L3225";
            separation = @"S20";
            code = @"E2114";
			break;
		case SERVICE_BIZ_LOAN_LIMIT:        // 직장인 무방문대출 신청 (한도)
			serviceCode = @"L3224";
            separation = @"S20";
            code = @"E2114";
			break;
		default:
			break;
	}
    
    NSString *returnValue = @"";
    
    switch (value) {
        case 1:                             // 서비스코드
            returnValue = serviceCode;
            
            break;
        case 2:                             // 구분
            returnValue = separation;
            
            break;
        case 3:                             // 전문코드
            returnValue = code;
            
            break;
            
        default:
            break;
    }
    
    return returnValue;
}

- (BOOL)checkPhoneNumber
{
    if (!agreeButton.selected) {
        NSString *msg;
        
        if (AppInfo.LanguageProcessType == EnglishLan)
        {
            msg = @"Please check the \"Consent to provision of of the phones information\" button.";
        }
        else if (AppInfo.LanguageProcessType == JapanLan)
        {
            msg = @"携帯電話情報提供同意にチェックしてください。";
        }
        else
        {
            msg = @"추가인증 진행에 동의하신 후, 진행하실 수 있습니다.";
        }
        
        [UIAlertView showAlertLan:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:msg language:AppInfo.LanguageProcessType];
        
        return NO;
    }
    
    if ([_phoneNumber isEqualToString:@"등록된 전화번호가 없습니다."]) {
        [UIAlertView showAlertLan:nil
                             type:ONFAlertTypeOneButton
                              tag:0
                            title:@""
                          message:@"고객정보에 등록된 전화번호가 없습니다. 인근 신한은행 영업점에서 고객정보를 변경하신 후 진행하시기 바랍니다."
                         language:AppInfo.LanguageProcessType];
        
        return NO;
    }
	
	return YES;
}

- (void)requestMobileCert
{
    AppInfo.serviceCode = @"MOBILE_CERT";
    //NSLog(@"aaaaa:%@",_customerName);
    if (self.serviceSeq == SERVICE_300_OVER)
    {
        //AppInfo.serviceCode = @"E3029";
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"업무별인증시간" : @"3",
                               @"업무별오류횟수" :@"3",
                               @"추가이체여부" : AppInfo.transferDic[@"추가이체여부"],
                               @"입금은행명" : AppInfo.transferDic[@"입금은행명"],
                               @"추가이체건수" : AppInfo.transferDic[@"추가이체건수"],
                               @"추가_입금은행코드" : AppInfo.transferDic[@"추가_입금은행코드"],
                               @"추가_입금은행명" : AppInfo.transferDic[@"추가_입금은행명"],
                               @"추가_입금계좌번호" : AppInfo.transferDic[@"추가_입금계좌번호"],
                               @"추가_입금계좌성명" : AppInfo.transferDic[@"추가_입금계좌성명"],
                               @"추가_이체금액" : AppInfo.transferDic[@"추가_이체금액"],
                               //@"구분" : [self getCodeValue:2],
                               @"휴대폰번호" : _phoneNumber,
                               @"고객번호" : AppInfo.customerNo,
                               //@"주민번호" : [AppInfo getPersonalPK],
                               @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                               @"성명"    : _customerName,
                               //@"서비스코드" : [self getCodeValue:1],
                               @"서비스코드" : AppInfo.transferDic[@"서비스코드"],
                               }];
        
        SendData(SHBTRTypeServiceCode, @"E3029", MOBILE_CERT_300OVER_SMSARS_URL, self, dataSet);
        Debug(@"request : %@", dataSet);
    }else
    {
        NSLog(@"고객번호:%@",AppInfo.customerNo);
        NSLog(@"주민번호:%@",[AppInfo getPersonalPK]);
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"구분" : [self getCodeValue:2],
                               @"휴대폰번호" : _phoneNumber,
                               @"고객번호" : AppInfo.customerNo,
                               //@"주민번호" : [AppInfo getPersonalPK],
                               @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                               @"서비스코드" : [self getCodeValue:1],
                               @"성명"    : _customerName,
                               }];
        
        
        if (AppInfo.isLogin != 0) {
            SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMSARS_URL, self, dataSet);
        }
        else {
            SendData(SHBTRTypeRequst, nil, MOBILE_CERT_SMSARS_GUEST_URL, self, dataSet);
        }
        Debug(@"request : %@", dataSet);
    }
    
}

#pragma mark - Button

- (IBAction)buttonPressed:(UIButton*)sender
{
	if (sender == agreeButton) {
		if (sender.selected) {
			[sender setSelected:NO];
		} else {
			[sender setSelected:YES];
		}
	}else if (sender == confirmButton) {
		// 휴대전화번호 및 동의여부 체크
		if ([self checkPhoneNumber] == NO) return;
		
		// 휴대폰인증 전문 통신 START
        [self requestMobileCert];
        
	}else if (sender == cancelButton)
    {
		[self.navigationController fadePopViewController];
        
        if ([self.delegate respondsToSelector:@selector(mobileCertificateCancel)]) {
            [self.delegate mobileCertificateCancel];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mobileCertificateCancel"
                                                            object:nil];
        if (AppInfo.isAllIdenty || AppInfo.isAllIdentyDone)
        {
            
            AppInfo.isAllIdenty = NO;
            AppInfo.isAllIdentyDone = NO;
            AppInfo.isSMSIdenty = NO;
            AppInfo.isARSIdenty = NO;
            [AppDelegate.navigationController fadePopViewController];
            
        }
	}
	
}

#pragma mark - Response

- (void)client:(OFHTTPClient *)client didReceiveDataSet:(OFDataSet *)dataSet
{
    [mobileInfoDic setObject:_phoneNumber forKey:@"phoneNumber"];
    
    if (self.serviceSeq != SERVICE_300_OVER)
    {
        if (![dataSet[@"result"] isEqualToString:@"0"]) {
            return;
        }
        Debug(@"인증번호 : [ %@ ]", dataSet[@"인증번호"]);
        //[mobileInfoDic setObject:_customerName forKey:@"name"];
        [mobileInfoDic setObject:[self getCodeValue:2] forKey:@"separation"];
    }
    
    [mobileInfoDic setObject:_customerName forKey:@"name"];
    if (self.serviceSeq == SERVICE_300_OVER)
    {
        [mobileInfoDic setObject:AppInfo.transferDic[@"서비스코드"] forKey:@"serviceCode"];
        //[mobileInfoDic setObject:[self getCodeValue:1] forKey:@"serviceCode"];
    }else
    {
        [mobileInfoDic setObject:[self getCodeValue:1] forKey:@"serviceCode"];
    }
    

    NSString *nibName;
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        nibName = @"SHBMobileCertificateStep2ViewControllerEng";
    } else if (AppInfo.LanguageProcessType == JapanLan)
    {
        nibName = @"SHBMobileCertificateStep2ViewControllerJpn";
    }
    else
    {
        nibName = @"SHBMobileCertificateStep2ViewController";
    }
    
    SHBMobileCertificateStep2ViewController *mCertViewController = [[[SHBMobileCertificateStep2ViewController alloc] initWithNibName:nibName bundle:nil] autorelease];
    
    mCertViewController.needsLogin = NO;
    mCertViewController.delegate = self;
    mCertViewController.serviceSeq = serviceSeq;
    
    [self checkLoginBeforePushViewController:mCertViewController animated:NO];
    
    [mCertViewController executeWithTitle:titleName
                                     Step:nextStep
                                  StepCnt:totalStep
                       NextControllerName:_nextViewControlName
                                     Info:mobileInfoDic];
    
    [mCertViewController.subTitleLabel setText:subTitleLabel.text];

    if (!AppInfo.realServer)
    {
        [mCertViewController.certTextField setText:dataSet[@"인증번호"]];
    }
}

#pragma mark - SHBMobileCertificateStop2

- (void)mobileCertificateStep2Back
{
    [agreeButton setSelected:NO];
}

@end
