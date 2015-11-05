//
//  SHBELD_BA17_7ViewController.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 28..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBELD_BA17_7ViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBELD_BA17_5ViewController.h"
#import "SHBELD_WebViewController.h"

#import "SHBProductService.h"

@interface SHBELD_BA17_7ViewController ()

- (void)validationCheck;
- (void)serviceStart:(NSMutableArray *)aArray;
- (void)nextPage;

@end

@implementation SHBELD_BA17_7ViewController

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	if (AppInfo.errorType != nil) {
		return NO;
	}
    
    // C2315전문 결과 처리
    if (self.service.serviceId == kC2315Id) {
        
        if (![aDataSet[@"필수정보동의여부"] isEqualToString:@"1"]) {
            
            _isShowStipulation = YES;
        }
        
        _isMarketingAgree = [aDataSet[@"마케팅활용동의여부"] integerValue];
        
        if (!_isShowStipulation) {
            
            [self.scrollView1 addSubview:self.view1];
            self.scrollView1.contentSize = self.view1.bounds.size;
            
            _collections = [[NSArray alloc] initWithObjects:self.collection1, self.collection2, self.collection3, self.collection4,
                            self.collection5, self.collection6, self.collection7, self.collection8, self.collection9, nil];
        }
        else {
            
            [self.scrollView1 addSubview:self.view2];
            [self.scrollView1 addSubview:self.view1];
            
            CGRect rectTemp = self.view1.frame;
            rectTemp.origin.y = self.view2.frame.origin.y + self.view2.frame.size.height;
            self.view1.frame = rectTemp;
            
            CGSize sizeTemp = self.view1.frame.size;
            sizeTemp.height += self.view1.frame.origin.y;
            self.scrollView1.contentSize = sizeTemp;
            
            _collections = [[NSArray alloc] initWithObjects:self.collection1, self.collection2, self.collection3, self.collection4,
                            self.collection5, self.collection6, self.collection7, self.collection8, self.collection9, self.collection10, self.collection11, self.collection12, nil];
        }
    }
    // C2316전문 결과 처리
    if (self.service.serviceId == kC2316Id) {
        
        [self nextPage];
    }
    
	return NO;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    return NO;
}

#pragma mark -
#pragma mark Notification Methods

- (void)getElectronicSignResult:(NSNotification *)notification
{
    if (!AppInfo.errorType) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        self.data = [notification userInfo];
        
        NSDictionary *dictionaryTemp = @{ @"안정형": @"5", @"안정추구형": @"4", @"위험중립형": @"3", @"적극투자형": @"2", @"공격투자형": @"1" };
        NSString *stringTemp = dictionaryTemp[notification.userInfo[@"PART2결과"]]; // 고객성향유형 결과
        
        NSInteger productType = 4; // 상품위험등급 (신한S뱅크에서 보여지는 등급은 모두 4 (ELD))
        
        // 골드 상품의 경우 상품위험등급이 2
        if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
            
            productType = 2;
        }
        
        if ([stringTemp integerValue] <= productType) {
            
            _isResult = NO;     // BA17-8-1, 고객성향 >= 가입
        }
        else {
            
            _isResult = YES;    // BA17-8-2, 고객성향 < 가입
        }
        
        // 골드상품
        if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
            
            [self nextPage];
            
            return;
        }
        
        if (_isShowStipulation) {
            
            // 전문요청
            self.service = nil;
            self.service = [[[SHBProductService alloc]initWithServiceId:kC2316Id viewController:self]autorelease];
            
            BOOL isSelectionInfoAgree = ((UIButton *)[self.view viewWithTag:110]).selected;
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                   @"은행구분" : @"1",
                                   @"검색구분" : @"1",
                                   @"고객번호" : AppInfo.customerNo,
                                   @"고객번호1" : AppInfo.customerNo,
                                   @"마케팅활용동의여부" : [NSString stringWithFormat:@"%d", _isMarketingAgree],
                                   @"장표출력SKIP여부" : @"1",
                                   @"인터넷수행여부" : @"2",
                                   @"필수정보동의여부" : @"1",
                                   @"선택정보동의여부" : [NSString stringWithFormat:@"%d", isSelectionInfoAgree],
                                   }];
            
            self.service.requestData = dataSet;
            [self.service start];
        }
        else {
            
            [self nextPage];
        }
    }
}

- (void)getElectronicSignServerError
{
    [self.navigationController fadePopViewController];
}


#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    // 나의 투자성향 결과보기 버튼 액션 이벤트
    if ([sender tag] == 0) {
        
        [self validationCheck];
    }
    // 보기 버튼
    else if ([sender tag] == 1) {
        
        _isReadStipulation = YES;
        
        // 웹뷰 - 이동 동의서 보기 화면 이동
        SHBELD_WebViewController *viewController = [[SHBELD_WebViewController alloc] initWithNibName:@"SHBELD_WebViewController" bundle:nil];
        
        NSString *URL = @"";
        
        // 골드상품
        if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
            
            URL = @"http://img.shinhan.com/sbank/yak/p_credit_agree.html";
        }
        else {
            
            URL = @"http://img.shinhan.com/sbank/yak/yak_agree.html";
        }
        
        viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:@{
                                         @"SUBTITLE" : @"약관보기",
                                         @"URL" : URL,
                                         @"BOTTOM_TYPE" : @"1" }]; // 하단 버튼 타입 - 1:확인 버튼
        
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
    }
    // 라디오 버튼, 체크박스 - 선택/해제
    else {
        
        NSUInteger index = ([sender tag] / 10) - 1;
        NSArray *arrayTemp = _collections[index];
        
        if (arrayTemp) {
            
            // 라디오 버튼
            if (arrayTemp != self.collection3 && arrayTemp != self.collection9) {
                
                for (UIButton *buttonTemp in arrayTemp) {
                    
                    buttonTemp.selected = NO;
                }
                
                UIButton *buttonTemp = (UIButton *)sender;
                buttonTemp.selected = YES;
            }
            // 체크박스
            else {
                
                UIButton *buttonTemp = (UIButton *)sender;
                buttonTemp.selected = !buttonTemp.selected;
            }
        }
    }
}

- (void)validationCheck
{
    // 골드상품
    if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
        
        if (!_isReadStipulation) {
            
            [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"‘개인(신용)정보 수집・이용・제공 동의서를 선택하시고 읽어보시기 바랍니다."];
            return;
        }
    }
    else {
        
        // 개인신용정보동의 뷰 표시할 경우에 대한 예외처리
        if (_isShowStipulation) {
            
            if (!_isReadStipulation) {
                
                [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"‘개인(신용)정보 수집・이용 동의서(비여신 금융거래) 및 고객권리 안내문’ 보기를 선택하여 확인하시기 바랍니다."];
                return;
            }
            
            UIButton *buttonTemp3 = (UIButton*)[self.view viewWithTag:100]; // 개인신용정보동의 필수적정보
            
            if (!buttonTemp3.selected) {
                
                [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"1번 필수적정보는 반드시 동의하셔야 합니다."];
                return;
            }
            
            UIButton *buttonTemp4 = (UIButton*)[self.view viewWithTag:120]; // 개인신용정보동의 고유식별정보
            
            if (!buttonTemp4.selected) {
                
                [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"2번 고유식별정보는 반드시 동의하셔야 합니다."];
                return;
            }
        }
    }
    
    // 선택한 항목 저장
    NSMutableArray *result = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    // 필수항목에 대한, 선택 여부 체크
    for (int index = 0; index < [_collections count]; index++) {
        
        BOOL isSelected = NO;
        
        for (UIButton *buttonTemp in _collections[index]) {
            
            if (buttonTemp.selected) {
                
                isSelected = YES;
                
                // Q1 ~ Q8에 대한 선택결과 저장
                if (buttonTemp.tag < 90) {
                    
                    [result addObject:[NSString stringWithFormat:@"part%d", buttonTemp.tag + 1]];
                }
            }
        }
        
        if (!isSelected) {
            
            NSString *stringTemp = nil;
            
            switch (index) {
                case 0:
                    stringTemp = @"Q1. 고객님의 연령대를 선택하여 주십시오.";
                    break;
                case 1:
                    stringTemp = @"Q2. 고객님의 수입원을 선택하여 주십시오.";
                    break;
                case 2:
                    stringTemp = @"Q3. 고객님의 투자경험을 선택하여 주십시오.";
                    break;
                case 3:
                    stringTemp = @"Q4. 고객님의 투자지식수준을 선택하여 주십시오.";
                    break;
                case 4:
                    stringTemp = @"Q5. 고객님의 감수할 수 있는 손실수준을 선택하여 주십시오.";
                    break;
                case 5:
                    stringTemp = @"Q6. 고객님의 투자가능 기간을 선택하여 주십시오.";
                    break;
                case 6:
                    stringTemp = @"Q7. 고객님의 투자경험을 선택하여 주십시오.";
                    break;
                case 7:
                    stringTemp = @"Q8. 고객님의 만65세 이상여부를 선택하여 주십시오.";
                    break;
                    
                default:
                    break;
            }
            
            if (stringTemp) {
                
                [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:stringTemp];
                return;
            }
        }
    }
    
    // Q1, Q8 선택값에 대한 예외처리
    UIButton *buttonTemp1 = (UIButton*)[self.view viewWithTag:15]; // Q1 - 60대 이상
    UIButton *buttonTemp2 = (UIButton*)[self.view viewWithTag:80]; // Q8 - 예
    
    if (!buttonTemp1.selected && buttonTemp2.selected == YES) {
        
        [UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"Q1. 고객님의 연령대를 확인해 주십시오.(Q1과 Q8이 같지 않음)"];
        return;
    }
    
    // 전문요청
    [self serviceStart:result];
}

- (void)serviceStart:(NSMutableArray *)aArray
{
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"예금/적금 가입";
    
    if (!_isShowStipulation) {
        
        AppInfo.electronicSignCode = @"D6012_A";
        AppInfo.electronicSignTitle = @"";
    }
    else {
        
        AppInfo.electronicSignCode = @"D6012_B";
        AppInfo.electronicSignTitle = @"개인(신용)정보 수집,이용동의서(비여신 금융거래)고객권리 안내문에 동의합니다.";
    }
    
    [AppInfo addElectronicSign:@"입력하신 기초정보, 투자경험 내용을 확인하고 투자성향분석을 진행하시겠습니까?"];
    
    // 선택한 결과에 대한 파라매터 생성
    NSMutableDictionary *dictionaryTemp = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    for (NSString *stringTemp in aArray) {
        
        [dictionaryTemp setObject:@"1" forKey:stringTemp];
    }
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:dictionaryTemp];
    
    // 전문요청
    self.service = nil;
    self.service = [[[SHBProductService alloc] initWithServiceId:kD6012Id viewController:self] autorelease];
    self.service.requestData = dataSet;
    
    [self.service start];
}

- (void)nextPage
{
    // 고객성향에 따른 CASE 정의
    NSString *stringTemp = nil;
    
    if (!_isResult) {
        
        stringTemp = @"BA17-8-1";   // BA17-8-1, 고객성향 >= 가입
    }
    else {
        
        stringTemp = @"BA17-8-2";   // BA17-8-2, 고객성향 < 가입
    }
    
    // 화면이동
    SHBELD_BA17_5ViewController *viewController = [[SHBELD_BA17_5ViewController alloc] initWithNibName:@"SHBELD_BA17_5ViewController" bundle:nil];
    [self.viewDataSource setObject:stringTemp forKey:@"CASE"];
    viewController.data = self.data;
    viewController.viewDataSource = self.viewDataSource;
    [viewController setNeedsCert:YES];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
    [viewController release];
}


#pragma mark -
#pragma mark init & dealloc

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.viewDataSource = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewDataSource = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_collections release]; _collections = nil;
    
    self.scrollView1 = nil;
    self.collection1 = nil;
    self.collection2 = nil;
    self.collection3 = nil;
    self.collection4 = nil;
    self.collection5 = nil;
    self.collection6 = nil;
    self.collection7 = nil;
    self.collection8 = nil;
    self.collection9 = nil;
    self.collection10 = nil;
    self.collection11 = nil;
    self.collection12 = nil;
    self.view1 = nil;
    self.view2 = nil;
    self.viewDataSource = nil;
    
    [_part5View release];
    [_part2Q3BtnLabel1 release];
    [_part2Q3BtnLabel2 release];
    [_part2Q3BtnLabel3 release];
    [_part2Q3BtnLabel4 release];
    [_part2Q3BtnLabel5 release];
    [_view3 release];
    [super dealloc];
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // TA-4, 전자서명에서 사용하는 옵저버 초기화 및 등록
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignServerError) name:@"notiESignError" object:nil];
    
    [self setTitle:@"예금/적금 가입"]; // 타이틀
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"투자성향분석" maxStep:0 focusStepNumber:0] autorelease]]; // 서브 타이틀
    
    // 골드상품
    if ([_viewDataSource[@"상품코드"] isEqualToString:@"187000101"]) {
        
        [_part5View setHidden:YES];
        FrameResize(self.view1, width(self.view1), height(self.view1) - height(_part5View));
        
        [_part2Q3BtnLabel1 setText:@"국채, 지방채, 보증채, 은행 예적금, MMF, CMA 등"];
        [_part2Q3BtnLabel2 setText:@"채권형 펀드, 원금보장형 ELF(ELS), ELD, 신용도가 높은 회사채, 금융채 등"];
        [_part2Q3BtnLabel3 setText:@"혼합형 펀드, 원금의 일부만 보장되는 ELF(ELS), 신용도 중간 등급의 회사채 등"];
        [_part2Q3BtnLabel4 setText:@"시장수익률 수준의 수익을 추구하는 주식형 펀드, 원금이 보장되지 않는 ELF(ELS), 신용도가 낮은 회사채 등"];
        [_part2Q3BtnLabel5 setText:@"시장수익률 이상의 수익을 추구하는 주식형 펀드, 파생상품에 투자하는 펀드, 주식 신용거래, ELW, 선물옵션 등"];
        
        [self.scrollView1 addSubview:self.view3];
        [self.scrollView1 addSubview:self.view1];
        
        FrameReposition(self.view1, 0, height(self.view3));
        
        CGSize sizeTemp = self.view1.frame.size;
        sizeTemp.height += top(self.view1);
        self.scrollView1.contentSize = sizeTemp;
        
        _collections = [[NSArray alloc] initWithObjects:self.collection1, self.collection2, self.collection3, self.collection4,
                        self.collection5, self.collection6, self.collection7, self.collection8, self.collection9, self.collection10, self.collection11, self.collection12, nil];
    }
    else {
        
        [_part2Q3BtnLabel1 setText:@"은행 예・적금, 국채, 지방채, 보증채, MMF, CMA 등"];
        [_part2Q3BtnLabel2 setText:@"금융채, 신용도가 높은 회사채, 채권형 펀드, 원금보장형 ELF(ELS), ELD 등"];
        [_part2Q3BtnLabel3 setText:@"신용도 중간 등급의 회사채, 원금의 일부만\n보장되는 ELF(ELS), 혼합형 펀드 등"];
        [_part2Q3BtnLabel4 setText:@"신용도가 낮은 회사채, 주식, 원금이 보장되지 않는 ELF(ELS), 시장수익률 수준의 수익을 추구하는 주식형 펀드 등"];
        [_part2Q3BtnLabel5 setText:@"ELW, 선물옵션, 시장수익률 이상의 수익을 추구하는 주식형펀드, 파생상품에 투자하는 펀드, 주식 신용거래 등"];
        
        
        // 전문요청
        self.service = nil;
        self.service = [[[SHBProductService alloc]initWithServiceId:kC2315Id viewController:self]autorelease];
        [self.service start];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
[self setView3:nil];
[super viewDidUnload];
}
@end
