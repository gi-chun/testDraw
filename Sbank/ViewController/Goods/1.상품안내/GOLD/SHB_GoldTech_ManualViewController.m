//
//  SHB_GoldTech_ManualViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 11..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHB_GoldTech_ManualViewController.h"
#import "SHBProductService.h" // 서비스
#import "SHBAccountService.h" // 서비스

#import "SHBGoodsSubTitleView.h" // 서브타이틀
#import "SHBNewProductSeeStipulationViewController.h" // 약관보기
#import "SHBNewProductListViewController.h" // 상품리스트
#import "SHB_GoldTech_ManualInfoViewController.h" // 안내
#import "SHB_GoldTech_ProductInfoViewcontroller.h"

@interface SHB_GoldTech_ManualViewController ()
{
    BOOL isBackMarketingAgree;
	BOOL isEssentialAgree; // 필수정보동의여부
	BOOL isMarketingAgree; // 마케팅활용동의여부
    BOOL isRead1; // 투자설명서 보기
    BOOL isRead2; // 간이투저설명서 보기
    BOOL isRead3; // 설명확인서 보기
}

@property (nonatomic, retain) NSString *xda_age; // 나이정보
@property (retain, nonatomic) NSDictionary *marketingAgreeDic; // 마케팅활용동의, 필수정보동의 웹뷰에서 넘어온 데이터

@property (retain, nonatomic) SHBGoodsSubTitleView *subTitleView;

@end

@implementation SHB_GoldTech_ManualViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"NewProductCancel" object:nil];
    
	[self setTitle:@"예금/적금 가입"];
    self.strBackButtonTitle = @"예금적금 가입 1단계";
    
    self.subTitleView = [[[SHBGoodsSubTitleView alloc] initWithTitle:@"투자설명서 및 간이투자설명서"
                                                             maxStep:5
                                                     focusStepNumber:1] autorelease];
    [self.view addSubview:_subTitleView];
    
    [_contentSV addSubview:_contentView];
    [_contentSV setContentSize:_contentView.frame.size];
    
    NSString *class = _dicSelectedData[@"_위험등급"];
    
    NSArray *classArray = [class componentsSeparatedByString:@":"];
    
    if ([classArray count] > 0) {
        
        class = classArray[0];
    }
    
    NSString *date = AppInfo.tran_Date;
    
    NSArray *dateArray = [date componentsSeparatedByString:@"."];
    
    if ([dateArray count] >= 3) {
        
        date = [NSString stringWithFormat:@"%@년 %@월 %@일", dateArray[0], dateArray[1], dateArray[2]];
    }
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:@{
                                                               @"_상품명" : _dicSelectedData[@"상품명"],
                                                               @"_등급" : class,
                                                               @"_날짜" : date
                                                               }];
    [self.binder bind:self dataSet:dataSet];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    //나이 xda추가
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    // 전문 요청
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                  TASK_NAME_KEY : @"",
                                                                  TASK_ACTION_KEY : @"",
                                                                  @"VERSION" : version,
                                                                  }];
    
    self.service = [[[SHBProductService alloc] initWithServiceId:XDA_AGE viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.dicSelectedData = nil;
    self.userItem = nil;
    
    self.xda_age = nil;
    self.marketingAgreeDic = nil;
    
    self.subTitleView = nil;
    
    [_contentView release];
    [_marketingWV release];
    [_contentSV release];
    [_checkBtnCollection release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Notification

- (void)getElectronicSignCancel
{
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers) {
        
		if ([viewController isKindOfClass:[SHB_GoldTech_ManualViewController class]]) {
            
			[self.navigationController fadePopToViewController:viewController];
            
            break;
		}
	}
    
    [self resetUI];
}

#pragma mark - Method

- (void)resetUI
{
    isRead1 = NO;
    isRead2 = NO;
    
    for (UIButton *button in _checkBtnCollection) {
        
        [button setSelected:NO];
    }
}

// 상품가입 가능 여부 체크
- (BOOL)isPossibleJoiningProduct
{
    Debug(@"AppInfo.ssn : %@", [AppInfo getPersonalPK]);
    
    Debug(@"나이 : %@", self.xda_age);
    
    NSString *age = [NSString stringWithFormat:@"%@", self.xda_age];
    NSInteger nAge =  [age integerValue];
    NSInteger nMinAge = [self.dicSelectedData[@"가입가능나이최소"] integerValue];
    NSInteger nMaxAge = [self.dicSelectedData[@"가입가능나이최대"] integerValue];
    
    if (nAge < nMinAge) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:[NSString stringWithFormat:@"만 %d세 이상 가입 가능합니다.", nMinAge]];
        return NO;
    }
	
    if (nAge < nMinAge || nAge > nMaxAge) {
        
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:[NSString stringWithFormat:@"만 %d세 이상 만 %d세 이하 가입 가능합니다.", nMinAge, nMaxAge]];
        return NO;
    }
    
    if ([self.dicSelectedData[@"상품가입불가코드"] length]) {
        
        // 불가코드가 있으면 체크
        
        NSString *str = self.dicSelectedData[@"상품가입불가코드"];
        NSArray *arrImpossibleCodes = [str componentsSeparatedByString:@","];
        
        NSMutableArray *marrAcounts = [self.data arrayWithForKey:@"예금계좌"];
        
        for (NSDictionary *dicAccount in marrAcounts) {
            
            Debug(@"dicAccount : %@", dicAccount);
            
            for (NSString *strImpossibleCode in arrImpossibleCodes) {
                
                if ([strImpossibleCode isEqualToString:dicAccount[@"상품코드"]]) {
                    
					[UIAlertView showAlert:self
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:[NSString stringWithFormat:@"1인 1계좌만 가입 가능합니다. 기 가입여부를 확인하세요. 기 가입계좌가 존재합니다."]];
                    return NO;
                }
            }
        }
    }
	
    if ([self.dicSelectedData[@"상품가입가능코드"] length]) {
        
        // 가능코드가 있으면 체크
        
        NSString *str = self.dicSelectedData[@"상품가입가능코드"];
        NSArray *arrPossibleCodes = [str componentsSeparatedByString:@","];
		
        NSMutableArray *marrAcounts = [self.data arrayWithForKey:@"예금계좌"];
		
        BOOL isFound = NO;
        
        for (NSDictionary *dicAccount in marrAcounts) {
            
            Debug(@"dicAccount : %@", dicAccount);
            
            for (NSString *strPossibleCode in arrPossibleCodes) {
                
                if ([strPossibleCode isEqualToString:dicAccount[@"상품코드"]]) {
                    
                    isFound = YES;
					
                    break;
                }
            }
			
            if (isFound) {
                
                break;
            }
        }
		
        if (!isFound) {
            
            [UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"Tops직장인플랜 저축예금 또는 신한 직장인통장(구,김대리 통장) 보유고객만 가입 가능합니다."];
            return NO;
        }
    }
    
    return YES;
}

- (void)showContentView
{
    [self navigationBackButtonShow];
    
    [_subTitleView removeFromSuperview];
    
    self.subTitleView = [[[SHBGoodsSubTitleView alloc] initWithTitle:@"투자설명서 및 간이투자설명서"
                                                             maxStep:5
                                                     focusStepNumber:1] autorelease];
    [self.view addSubview:_subTitleView];
    
    [_contentSV setHidden:NO];
    [_marketingWV setHidden:YES];
}

- (void)setMarketingView
{
    // 마케팅활용동의
    
    [self navigationBackButtonHidden];
    
    [_subTitleView removeFromSuperview];
    
    self.subTitleView = [[[SHBGoodsSubTitleView alloc] initWithTitle:@"개인(신용)정보 동의"
                                                             maxStep:0
                                                     focusStepNumber:0] autorelease];
	[self.view addSubview:_subTitleView];
    
    NSMutableString *URL = [NSMutableString stringWithFormat:@"https://%@.shinhan.com/sbank/marketing/marketing_info.jsp?", AppInfo.realServer ? @"m" : @"dev-m"];
    
    NSDictionary *dic = @{ @"마케팅활용동의여부" : self.data[@"마케팅활용동의여부"],
                           @"필수정보동의여부" : self.data[@"필수정보동의여부"],
                           @"선택정보동의여부" : self.data[@"선택정보동의여부"],
                           @"자택TM통지요청구분" : self.data[@"자택TM통지요청구분"],
                           @"직장TM통지요청구분" : self.data[@"직장TM통지요청구분"],
                           @"휴대폰통지요청구분" : self.data[@"휴대폰통지요청구분"],
                           @"SMS통지요청구분" : self.data[@"SMS통지요청구분"],
                           @"EMAIL통지요청구분" : self.data[@"EMAIL통지요청구분"],
                           @"DM희망지주소구분" : self.data[@"DM희망지주소구분"],
                           @"VERSION" : [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                           @"COM_SUBCHN_KBN" : CHANNEL_CODE };
    
    BOOL isFirst = YES;
    
    for (NSString *key in [dic allKeys]) {
        
        if (isFirst) {
            
            isFirst = NO;
            
            [URL appendFormat:@"%@=%@", key, dic[key]];
        }
        else {
            
            [URL appendFormat:@"&%@=%@", key, dic[key]];
        }
    }
    
    NSString *strURL = [(NSString *)URL stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    
    [_marketingWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strURL]]]];
    
    [[[_marketingWV subviews] lastObject] setBounces:NO];
    [_marketingWV setHidden:NO];
    
    [_contentSV setHidden:YES];
}

- (NSString *)getErrorMessage
{
    if (!isRead1) {
        
        return @"투자설명서 보기를 선택하시고 읽어보시기 바랍니다.";
    }
    
    if (!isRead2) {
        
        return @"간이투자설명서 보기를 선택하시고 읽어보시기 바랍니다.";
    }
    
    if (!isRead3) {
        
        return @"설명확인서 보기를 읽고 확인을 선택하시기 바랍니다.";
    }
    
    
    for (UIButton *button in _checkBtnCollection) {
        
        if (![button isSelected]) {
            
            return [NSString stringWithFormat:@"%d번 항목에 체크해 주시기 바랍니다.", button.tag - 100];
        }
    }
    
    return @"";
}

#pragma mark - Button

- (void)navigationButtonPressed:(id)sender
{
    if ([sender tag] == NAVI_BACK_BTN_TAG) {
        
        if (isBackMarketingAgree && [_marketingWV isHidden]) {
            
            isBackMarketingAgree = NO;
            
            [self navigationBackButtonHidden];
            
            [self resetUI];
            
            [_marketingWV setHidden:NO];
            [_contentSV setHidden:YES];
            
            return;
        }
    }
    
    [super navigationButtonPressed:sender];
}

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 10: {
            
            // 투자설명서 보기
            
            isRead1 = YES;
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            NSString *URL = @"";
            
            if (AppInfo.realServer) {
                
                URL = [NSString stringWithFormat:@"%@/nexrib2/ko/data/dm/gold_%@_seol1.pdf", URL_IMAGE, _dicSelectedData[@"상품코드"]];
            }
            else {
                
                URL = [NSString stringWithFormat:@"%@/nexrib2/ko/data/dm/gold_%@_seol1.pdf", URL_IMAGE_TEST, _dicSelectedData[@"상품코드"]];;
            }
            
            viewController.strUrl = URL;
            viewController.strName = @"예금/적금 가입";
            viewController.strBackButtonTitle = @"보기";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 20: {
            
            // 간이투자설명서 보기
            
            isRead2 = YES;
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            NSString *URL = @"";
            
            if (AppInfo.realServer) {
                
                URL = [NSString stringWithFormat:@"%@/nexrib2/ko/data/dm/gold_%@_seol2.pdf", URL_IMAGE, _dicSelectedData[@"상품코드"]];
            }
            else {
                
                URL = [NSString stringWithFormat:@"%@/nexrib2/ko/data/dm/gold_%@_seol2.pdf", URL_IMAGE_TEST, _dicSelectedData[@"상품코드"]];;
            }
            
            viewController.strUrl = URL;
            viewController.strName = @"예금/적금 가입";
            viewController.strBackButtonTitle = @"보기";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 30: {
            
            // 설명확인서  보기
            
            isRead3 = YES;
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            NSString *URL = @"";
            
            if (AppInfo.realServer) {
                URL = [NSString stringWithFormat:@"http://img.shinhan.com/sbank/yak/borrowed_name_prohibition.html"];
            }
            else {
                URL = [NSString stringWithFormat:@"http://imgdev.shinhan.com/sbank/yak/borrowed_name_prohibition.html"];
            }
            
            viewController.strUrl = URL;
            viewController.strName = @"예금/적금 가입";
            viewController.strBackButtonTitle = @"보기";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
    
            
        case 101:
        case 102:
        case 103:
        case 104:
        case 105:
        case 106:
        case 107:
        case 108:
        case 109:
        case 110: {
            
            // 동의 체크
            
            [sender setSelected:![sender isSelected]];
        }
            break;
            
        case 1000: {
            
            // 확인
            
            NSString *message = [self getErrorMessage];
            
            if ([message length] > 0) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:message];
                return;
            }
            
            // 동의구분 키값으로 추후 전자서명때 보여질 내용 및 전문구성을 달리한다.
            self.userItem = [NSMutableDictionary dictionary];
            
            if (isMarketingAgree == NO && isEssentialAgree == YES) {
                
                // 마케팅 동의만 그릴 때
                
                [self.userItem setObject:_marketingAgreeDic[@"마케팅활용동의여부"] forKey:@"정보동의"];
                [self.userItem setObject:_marketingAgreeDic[@"자택TM통지요청구분"] forKey:@"_자택TM통지요청구분"];
                [self.userItem setObject:_marketingAgreeDic[@"직장TM통지요청구분"] forKey:@"_직장TM통지요청구분"];
                [self.userItem setObject:_marketingAgreeDic[@"휴대폰통지요청구분"] forKey:@"_휴대폰통지요청구분"];
                [self.userItem setObject:_marketingAgreeDic[@"SMS통지요청구분"] forKey:@"_SMS통지요청구분"];
                [self.userItem setObject:_marketingAgreeDic[@"EMAIL통지요청구분"] forKey:@"_EMAIL통지요청구분"];
                [self.userItem setObject:_marketingAgreeDic[@"DM희망지주소구분"] forKey:@"_DM희망지주소구분"];
                
                if ([_marketingAgreeDic[@"마케팅활용동의여부"] isEqualToString:@"1"]) {
                    
                    [self.userItem setObject:@"마케팅동의구분" forKey:@"동의구분"];
                }
                else {
                    
                    [self.userItem setObject:@"마케팅동의안함" forKey:@"동의구분"];
                }
                
                // C2315 내려온 값 그대로 셋팅
                [self.userItem setObject:self.data[@"필수정보동의여부"] forKey:@"필수정보동의여부"];
                [self.userItem setObject:self.data[@"선택정보동의여부"] forKey:@"선택정보동의여부"];
            }
            else if (isMarketingAgree == YES && isEssentialAgree == NO) {
                
                // 필수적 동의만 그릴 때
                
                [self.userItem setObject:_marketingAgreeDic[@"필수정보동의여부"] forKey:@"필수적정보동의"];
                [self.userItem setObject:_marketingAgreeDic[@"선택정보동의여부"] forKey:@"선택정보동의여부"];
                [self.userItem setObject:@"필수적정보동의구분" forKey:@"동의구분"];
                
                // C2315 내려온 값 그대로 셋팅
                [self.userItem setObject:self.data[@"마케팅활용동의여부"] forKey:@"마케팅활용동의여부"];
                [self.userItem setObject:self.data[@"자택TM통지요청구분"] forKey:@"_자택TM통지요청구분"];
                [self.userItem setObject:self.data[@"직장TM통지요청구분"] forKey:@"_직장TM통지요청구분"];
                [self.userItem setObject:self.data[@"휴대폰통지요청구분"] forKey:@"_휴대폰통지요청구분"];
                [self.userItem setObject:self.data[@"SMS통지요청구분"] forKey:@"_SMS통지요청구분"];
                [self.userItem setObject:self.data[@"EMAIL통지요청구분"] forKey:@"_EMAIL통지요청구분"];
                [self.userItem setObject:self.data[@"DM희망지주소구분"] forKey:@"_DM희망지주소구분"];
            }
            else if (isMarketingAgree == NO && isEssentialAgree == NO) {
                
                // 둘다 그릴 때
                
                [self.userItem setObject:_marketingAgreeDic[@"마케팅활용동의여부"] forKey:@"정보동의"];
                
                if ([_marketingAgreeDic[@"마케팅활용동의여부"] isEqualToString:@"2"]) {
                    
                    [self.userItem setObject:@"필수적정보동의구분" forKey:@"동의구분"];
                }
                else {
                    
                    [self.userItem setObject:@"마케팅과필수적정보동의구분" forKey:@"동의구분"];
                }
                
                [self.userItem setObject:_marketingAgreeDic[@"필수정보동의여부"] forKey:@"필수적정보동의"];
                [self.userItem setObject:_marketingAgreeDic[@"선택정보동의여부"] forKey:@"선택정보동의여부"];
                [self.userItem setObject:_marketingAgreeDic[@"자택TM통지요청구분"] forKey:@"_자택TM통지요청구분"];
                [self.userItem setObject:_marketingAgreeDic[@"직장TM통지요청구분"] forKey:@"_직장TM통지요청구분"];
                [self.userItem setObject:_marketingAgreeDic[@"휴대폰통지요청구분"] forKey:@"_휴대폰통지요청구분"];
                [self.userItem setObject:_marketingAgreeDic[@"SMS통지요청구분"] forKey:@"_SMS통지요청구분"];
                [self.userItem setObject:_marketingAgreeDic[@"EMAIL통지요청구분"] forKey:@"_EMAIL통지요청구분"];
                [self.userItem setObject:_marketingAgreeDic[@"DM희망지주소구분"] forKey:@"_DM희망지주소구분"];
            }
            
            SHB_GoldTech_ManualInfoViewController *viewController = [[[SHB_GoldTech_ManualInfoViewController alloc] initWithNibName:@"SHB_GoldTech_ManualInfoViewController" bundle:nil] autorelease];
            
            viewController.dicSelectedData = self.dicSelectedData;
            viewController.userItem = self.userItem;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
            
        }
            break;
            
        case 2000: {
            
            // 취소
            
            for (SHB_GoldTech_ProductInfoViewcontroller *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[SHB_GoldTech_ProductInfoViewcontroller class]]) {
                    
                    [viewController.btn_lastAgreeCheck setSelected:NO];
                    viewController.lastAgreeCheck = NO;
                    
                    [self.navigationController fadePopToViewController:viewController];
                    
                    break;
                }
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if (self.service.serviceId == XDA_AGE) {
        
        self.xda_age = [aDataSet objectForKey:@"AGE"];
        
        // 계좌를 가져와서 상품가입불가/가능 코드를 비교
        
        self.service = nil;
        self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D0011" viewController:self] autorelease];
        self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{ @"A" : @"A" }] autorelease];
        [self.service start];
    }
    else if ([self.service.strServiceCode isEqualToString:@"D0011"]) {
        
		self.data = aDataSet;
		
		if ([self isPossibleJoiningProduct] == NO) {
            
            // 상품가입가능한지 여부 체크하여 불가능 상품이면 리스트화면으로 튕겨준다.
            
			for (SHBBaseViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[SHBNewProductListViewController class]]) {
                    
                    [self.navigationController fadePopToViewController:viewController];
                    
                    break;
                }
			}
		}
		else {
            
            // 가입가능하면 그 다음단계로 진행
            
            self.service = nil;
			self.service = [[[SHBProductService alloc] initWithServiceId:kC2800Id viewController:self] autorelease];
			[self.service start];
		}
	}
	else if (self.service.serviceId == kC2800Id) {
        
		NSString *strMsg = nil;
		
		NSInteger nResult = [aDataSet[@"인터넷구분수행결과"] intValue];
        
		if (nResult == 1 || nResult == 3 || nResult == 4) {
            
			strMsg = @"[특정금융거래보고법] 등 관련\n법률에 따라 고객확인이 필요한\n거래이오니 향후 영업점 내점 또는\n인터넷뱅킹 거래시 [고객확인절차]\n이행 됩니다.";
		}
		else if (nResult == 6) {
            
			strMsg = @"[특정금융거래보고법] 등 관련\n법률에 따라 고객확인이 필요한\n거래이오니 향후 영업점 내점 또는\n인터넷뱅킹 거래시 [고객확인절차]\n이행 됩니다.";
		}
		else if (nResult == 2 || nResult == 7) {
            
			strMsg = @"[특정금융거래보고법] 등 관련\n법률에 따라 고객확인이 필요한\n거래이오니 향후 영업점 내점 거래시\n[고객확인절차] 이행 됩니다.";
		}
		
		if (strMsg) {
            
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@""
                                                             message:strMsg
                                                            delegate:self
                                                   cancelButtonTitle:@"확인"
                                                   otherButtonTitles:nil] autorelease];
			[alert setTag:8214];
			[alert show];
		}
		else {
            
            self.service = nil;
			self.service = [[[SHBProductService alloc] initWithServiceId:kC2315Id viewController:self] autorelease];
			[self.service start];
		}
	}
	else if (self.service.serviceId == kC2315Id) {
        
		self.data = aDataSet;
        
		if ([aDataSet[@"마케팅활용동의여부"]isEqualToString:@"1"] ||
            [aDataSet[@"마케팅활용동의여부"]isEqualToString:@"2"]) {
            
			isMarketingAgree = YES;
		}
		else {
            
			isMarketingAgree = NO;
		}
		
		if ([aDataSet[@"필수정보동의여부"]isEqualToString:@"1"]) {
            
			isEssentialAgree = YES;
		}
		else {
            
			isEssentialAgree = NO;
		}
        
        if (!isMarketingAgree || !isEssentialAgree) {
            
            [self setMarketingView];
        }
        else {
            
            [self showContentView];
        }
	}
    
    return YES;
}

#pragma mark - UIWebView

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [AppDelegate showProgressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [AppDelegate closeProgressView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[AppDelegate closeProgressView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
	//Debug(@"webViewDidStartLoad !!!");
    AppInfo.isWebSchemeCall = YES;
    NSString *urlStr = [[request URL] absoluteString];
    NSLog(@"urlStr:%@",urlStr);
    if ([urlStr isEqualToString:@"about:blank"])
    {
        return NO;
    }
    if ([SHBUtility isFindString:urlStr find:@"C2315_WEB=Y"])
    {
        NSArray *schemeArr = [urlStr componentsSeparatedByString:@"?"];
        
        if ([schemeArr count] == 2) {
            
            NSArray *tmpArr = [schemeArr[1] componentsSeparatedByString:@"&"];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            for (NSString *str in tmpArr) {
                
                NSArray *array = [str componentsSeparatedByString:@"="];
                
                if ([array count] == 2) {
                    
                    NSString *key = [array[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSString *value = [array[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    [dic setObject:value forKey:key];
                }
            }
            
            self.marketingAgreeDic = dic;
            
            NSLog(@"urlStr : %@", urlStr);
            NSLog(@"marketingAgreeDic : %@", _marketingAgreeDic);
            
            isBackMarketingAgree = YES;
            
            [self showContentView];
            
            return NO;
        }
        else {
            
            return NO;
        }
        
        return NO;
    }
    if ([SHBUtility isFindString:urlStr find:@"sbankapplink://?"])
    {
        //웹뷰안에서 타 앱으로 sso링크 태울때 사용한다.
        NSArray *schemeArr =  [urlStr componentsSeparatedByString:@"://?"];
        
        if ([schemeArr count] == 2)
        {
            NSString *tmpSar = schemeArr[1];
            NSArray *appArr = [tmpSar componentsSeparatedByString:@"="];
            if ([appArr count] == 2)
            {
                
                SHBPushInfo *pushInfo = [SHBPushInfo instance];
                [pushInfo requestOpenURL:[SHBUtility nilToString:appArr[1]] Parm:nil];
            }else
            {
                return NO;
            }
        }else
        {
            return NO;
        }
    }
    if ([SHBUtility isFindString:urlStr find:@"iVer="])
    {
        NSMutableDictionary *dataDic    = [[NSMutableDictionary alloc] init];
        NSArray *screenArr =  [urlStr componentsSeparatedByString:@"?"];
        
        if( [screenArr count] == 2 )
        {
            [dataDic removeAllObjects];
            
            
            NSArray *argArr =  [[screenArr objectAtIndex:1] componentsSeparatedByString:@"&"];
            for( int i=0;i < [argArr count];i++){
                NSArray *ArrKeyVal = [[argArr objectAtIndex:i] componentsSeparatedByString:@"="];
                
                if ([ArrKeyVal count] < 2) break;
                
                [dataDic setObject:[ArrKeyVal objectAtIndex:1] forKey:[ArrKeyVal objectAtIndex:0]];
                
            }
        }
        
        NSString *tmpStr = [dataDic objectForKey:@"iVer"];
        
        if ([tmpStr length] > 0)
        {
            tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            versionNumber = [versionNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            if ([tmpStr intValue] > [versionNumber intValue])
            {
                [AppInfo updateAlert:[dataDic objectForKey:@"iVer"]];
                return NO;
            }
        }
        
    }
    
    if ([SHBUtility isFindString:urlStr find:@"goMain=Y"])
    {
        //메인 이동
        [AppDelegate.navigationController fadePopToRootViewController];
        return NO;
    }
    
    if ([SHBUtility isFindString:urlStr find:@"goBack=Y"])
    {
        //이전화면이동
        [AppDelegate.navigationController fadePopViewController];
        return NO;
    }
    
    //사파리로 열어야 될 경우 처리
    if ([SHBUtility isFindString:urlStr find:@"browser=Y"])
    {
        [[SHBPushInfo instance] requestOpenURL:urlStr SSO:NO];
        return NO;
    }
    //웹뷰안에 버튼 클릭시 스키마 유알엘을 타지 못하는 문제 해결(ios6은 문제 없음)
    if ([SHBUtility isFindString:[SHBUtilFile getOSVersion] find:@"5."] || [SHBUtility isFindString:[SHBUtilFile getOSVersion] find:@"4."])
    {
        if ([SHBUtility isFindString:urlStr find:@"iphonesbank://"])
        {
            [[SHBPushInfo instance] requestOpenURL:urlStr SSO:NO];
            return NO;
        }
    }
	return YES;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView.tag == 8214) {
        self.service = nil;
        self.service = [[[SHBProductService alloc]initWithServiceId:kC2315Id viewController:self] autorelease];
        [self.service start];
    }
}

@end
