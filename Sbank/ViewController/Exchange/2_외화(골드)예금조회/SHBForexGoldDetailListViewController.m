//
//  SHBForexGoldDetailListViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexGoldDetailListViewController.h"
#import "SHBGoldDepositInfoViewController.h"
#import "SHBGoldPaymentInfoViewController.h"

#import "SHBForexGoldDetailListCell.h" // cell
#import "SHBUtility.h" // 유틸
#import "SHBExchangeService.h" // 서비스
#import "SHBPushInfo.h" // 푸시

#import "SHBListPopupView.h" // list popup
#import "SHBPeriodPopupView.h" // 기간 popup

#define INFOVIEW_HEIGHT 260 // infoView 높이

#define MORECOUNT 9999999 // 더보기 (구현시 숫자 수정하면 됨)

#define GOLD_186 @"186" // 신한골드리슈금적립
#define GOLD_187 @"187" // U드림Gold모어통장, 신한골드리슈골드테크
#define GOLD_188 @"188" // 달러&골드테크통장

enum FOREXRGOLDDETAIL_ORDERBTN_TAG {
    FOREXRGOLDDETAIL_MONTH = 100,
    FOREXRGOLDDETAIL_THREEMONTH
};

@interface SHBForexGoldDetailListViewController ()
<SHBListPopupViewDelegate, SHBPopupViewDelegate>
{
    BOOL _isOrderSearch; // 기간 검색 여부
    NSInteger _orderStandardIndex; // 조회기준
    NSInteger _moreCount; // 더보기 갯수
}

@property (retain, nonatomic) NSString *startDate; // 조회시작일
@property (retain, nonatomic) NSString *endDate; // 조회종료일
@property (retain, nonatomic) NSMutableArray *orderStandardList; // 조회기준
@property (retain, nonatomic) NSArray *orderTempList; // 조회기준 정렬시 사용할 임시 리스트

/// 상단 정보 데이터 요청
- (void)infoDataRequest;

/**
 하단 리스트 데이터 요청
 @param isOrder 기간 검색 여부
 */
- (void)listDataRequest:(BOOL)isOrder;

/// 조회기준 데이터 설정
- (void)setOrderStandardData;

/// 데이터 reverse
- (void)setReverseData;

/**
 숫자에 , 넣기
 @param number 변환할 숫자
 @param isPoint 소수점 필요 여부
 @return , 가 있는 숫자
 */
- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint;

@end

@implementation SHBForexGoldDetailListViewController

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
    
    [self setTitle:@"외화골드예금조회"];
    
    CGSize labelSize = [_accountNumberLabel.text sizeWithFont:_accountNumberLabel.font
                                            constrainedToSize:CGSizeMake(999, 13)
                                                lineBreakMode:_accountNumberLabel.lineBreakMode];
    [_accountNumberLabel setFrame:CGRectMake(_accountNumberLabel.frame.origin.x,
                                             _accountNumberLabel.frame.origin.y,
                                             labelSize.width,
                                             _accountNumberLabel.frame.size.height)];
    [_detailBtn setFrame:CGRectMake(_accountNumberLabel.frame.origin.x + labelSize.width + 12,
                                    _detailBtn.frame.origin.y,
                                    _detailBtn.frame.size.width,
                                    _detailBtn.frame.size.height)];
    
    self.orderStandardList = [NSMutableArray arrayWithArray:
                              @[
                              @{@"1" : @"전체"},
                              @{@"1" : @"맡기신금"},
                              @{@"1" : @"찾으신금"},
                              ]];
    
    if (!_accountInfo[@"_계좌번호"]) {
        if ([_accountInfo[@"신계좌변환여부"] isEqualToString:@"1"]) {
            [_accountInfo setObject:_accountInfo[@"계좌번호"]
                             forKey:@"_계좌번호"];
        }
        else {
            [_accountInfo setObject:_accountInfo[@"구계좌번호"]
                             forKey:@"_계좌번호"];
        }
    }
         
    if ([_accountInfo[@"계좌번호"] hasPrefix:GOLD_187] ||
        [_accountInfo[@"계좌번호"] hasPrefix:GOLD_188]) {
        [_orderStandardLabel setHidden:YES];
        [_orderStandard setHidden:NO];
    }
    else {
        [_orderStandardLabel setHidden:NO];
        [_orderStandard setHidden:YES];
    }
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    [self infoDataRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.accountInfo = nil;
    
    self.startDate = nil;
    self.endDate = nil;
    self.orderStandardList = nil;
    self.orderTempList = nil;
    
    [_dataTable release];
    [_accountNumberLabel release];
    [_infoView release];
    [_tableHeaderView release];
    [_infoMoreView release];
    [_goldKeeperView release];
    [_orderView release];
    [_detailBtn release];
    [_orderInfo release];
    [_orderStandard release];
    [_inputMoney release];
    [_outputMoney release];
    [_outMoneyCount release];
    [_outMoney release];
    [_inMoneyCount release];
    [_inMoney release];
    [_arrow release];
    [_accountName release];
    [_orderStandardLabel release];
    [_moreView release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setDataTable:nil];
    [self setAccountNumberLabel:nil];
    [self setInfoView:nil];
    [self setTableHeaderView:nil];
    [self setInfoMoreView:nil];
    [self setGoldKeeperView:nil];
    [self setOrderView:nil];
    [self setDetailBtn:nil];
    [self setOrderInfo:nil];
    [self setOrderStandard:nil];
    [self setInputMoney:nil];
    [self setOutputMoney:nil];
    [self setOutMoneyCount:nil];
    [self setOutMoney:nil];
    [self setInMoneyCount:nil];
    [self setInMoney:nil];
    [self setArrow:nil];
    [self setAccountName:nil];
    [self setOrderStandardLabel:nil];
    [self setMoreView:nil];
	[super viewDidUnload];
}

#pragma mark -

- (void)infoDataRequest
{
    SHBDataSet *aDataSet = [SHBDataSet dictionary];
    
    if ([_accountInfo[@"신계좌변환여부"] isEqualToString:@"1"]) {
        [aDataSet setDictionary:
         @{
         @"계좌번호" : _accountInfo[@"계좌번호"],
         @"은행구분" : @"1",
         }];
    }
    else {
        [aDataSet setDictionary:
         @{
         @"계좌번호" : _accountInfo[@"구계좌번호"],
         @"은행구분" : _accountInfo[@"은행구분"],
         }];
    }
    
    [aDataSet insertObject:_accountInfo[@"통화코드"]
                    forKey:@"통화코드"
                   atIndex:0];
    
    if ([_accountInfo[@"계좌번호"] hasPrefix:GOLD_188]) {
        self.service = nil;
        self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_D7013_SERVICE
                                                       viewController:self] autorelease];
    }
    else {
        self.service = nil;
        self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_D7012_SERVICE
                                                       viewController:self] autorelease];
    }
    
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)listDataRequest:(BOOL)isOrder
{
    self.dataList = [NSArray array];
    
    [_dataTable setTableFooterView:nil];
    [_dataTable reloadData];
    
    _moreCount = MORECOUNT;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionary];
    
    if ([_accountInfo[@"신계좌변환여부"] isEqualToString:@"1"]) {
        [aDataSet setDictionary:
         @{
         @"계좌번호" : _accountInfo[@"계좌번호"],
         @"은행구분" : @"1",
         }];
    }
    else {
        [aDataSet setDictionary:
         @{
         @"계좌번호" : _accountInfo[@"구계좌번호"],
         @"은행구분" : _accountInfo[@"은행구분"],
         }];
    }
    
    [aDataSet insertObject:@"1"
                    forKey:@"정렬구분"
                   atIndex:0];
    [aDataSet insertObject:_accountInfo[@"통화코드"]
                    forKey:@"통화코드"
                   atIndex:0];
    
    if (isOrder) {
        _isOrderSearch = YES;
        
        [aDataSet insertObject:_startDate
                        forKey:@"조회시작일자"
                       atIndex:0];
        [aDataSet insertObject:_endDate
                        forKey:@"조회종료일자"
                       atIndex:0];
    }
    else {
        _isOrderSearch = NO;
    }
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_D7011_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)setOrderStandardData
{
    switch (_orderStandardIndex) {
        case 0:
            [_orderStandard setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, 17)];
            
            self.dataList = _orderTempList;
            
            break;
        case 1:
        {
            [_orderStandard setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 2, 17)];
            NSMutableArray *array = [NSMutableArray array];
            
            for (OFDataSet *dataSet in _orderTempList) {
                if ([dataSet[@"_거래종류"] isEqualToString:@"맡기신금(gram)"]) {
                    [array addObject:dataSet];
                }
            }
            
            self.dataList = (NSArray *)array;
        }
            break;
        case 2:
        {
            [_orderStandard setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 2, 17)];
            
            NSMutableArray *array = [NSMutableArray array];
            
            for (OFDataSet *dataSet in _orderTempList) {
                if ([dataSet[@"_거래종류"] isEqualToString:@"찾으신금(gram)"]) {
                    [array addObject:dataSet];
                }
            }
            
            self.dataList = (NSArray *)array;
        }
            break;
            
        default:
            break;
    }
    
    [self setReverseData];
}

- (void)setReverseData
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataList];
    
    NSSortDescriptor *sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"거래일자" ascending:[_arrow isSelected]];
    [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:sortOrder, nil]];
    
    self.dataList = (NSArray *)tempArray;
    
    [_dataTable reloadData];
}

- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint
{
    NSString *string = @"";
    
    if (isPoint) {
        string = [NSString stringWithFormat:@"%.2lf", number];
    }
    else {
        string = [NSString stringWithFormat:@"%.lf", number];
    }
    
    NSString *str = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSNumber *num = [NSNumber numberWithDouble:[str doubleValue]];
    
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSeparator:@","];
    [numberFormatter setAllowsFloats:YES];
    
    NSString *commaString = [numberFormatter stringForObjectValue:num];
    
    if (isPoint) {
        NSRange range = [commaString rangeOfString:@"."];
        
        if (range.location == NSNotFound) {
            commaString = [NSString stringWithFormat:@"%@.00", commaString];
        }
        else {
            if ([commaString length] - 1 == range.location + 1) {
                commaString = [NSString stringWithFormat:@"%@0", commaString];
            }
        }
    }
    
    return commaString;
}

#pragma mark - Button

/// 상단버튼 1, 2
- (IBAction)headerBtn:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"입금"]) {
        SHBGoldDepositInfoViewController *viewController = [[[SHBGoldDepositInfoViewController alloc] initWithNibName:@"SHBGoldDepositInfoViewController" bundle:nil] autorelease];
        viewController.needsCert = YES;
        viewController.accountInfo = self.accountInfo;
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
    else if ([sender.titleLabel.text isEqualToString:@"출금"]) {
        SHBGoldPaymentInfoViewController *viewController = [[[SHBGoldPaymentInfoViewController alloc] initWithNibName:@"SHBGoldPaymentInfoViewController" bundle:nil] autorelease];
        viewController.accountInfo = self.accountInfo;
        viewController.needsCert = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
    else if ([sender.titleLabel.text isEqualToString:@"적립"]) {
        SHBGoldDepositInfoViewController *viewController = [[[SHBGoldDepositInfoViewController alloc] initWithNibName:@"SHBGoldDepositInfoViewController" bundle:nil] autorelease];
        viewController.accountInfo = self.accountInfo;
        viewController.needsCert = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
    
    
//    NSString *openBanking = @"";
//    
//    if (!AppInfo.realServer) {
//        openBanking = [NSString stringWithFormat:@"%@/bank/forexgold/gold", URL_M_TEST];
//    }
//    else {
//        openBanking = [NSString stringWithFormat:@"%@/bank/forexgold/gold", URL_M];
//    }
//    
//    if ([sender.titleLabel.text isEqualToString:@"입금"]) {
//        openBanking = [NSString stringWithFormat:@"%@/gold_deposit.jsp?EQUP_CD=SI", openBanking];
//    }
//    else if ([sender.titleLabel.text isEqualToString:@"출금"]) {
//        openBanking = [NSString stringWithFormat:@"%@/gold_withdraw.jsp?EQUP_CD=SI", openBanking];
//    }
//    else if ([sender.titleLabel.text isEqualToString:@"적립"]) {
//        openBanking = [NSString stringWithFormat:@"%@/gold_save.jsp?EQUP_CD=SI", openBanking];
//    }
//    
//    [[SHBPushInfo instance] requestOpenURL:openBanking SSO:YES];
}

/// 상세보기
- (IBAction)detailInfoBtn:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
    [_infoMoreView setHidden:![sender isSelected]];
    
    if ([sender isSelected]) {
        [sender setAccessibilityLabel:@"상세닫기"];
    }
    else {
        [sender setAccessibilityLabel:@"상세보기"];
    }
    
    if (![sender isSelected]) {
        if ([_accountInfo[@"계좌번호"] hasPrefix:GOLD_186]) {
            [_infoView setFrame:CGRectMake(_infoView.frame.origin.x,
                                           _infoView.frame.origin.y,
                                           _infoView.frame.size.width,
                                           INFOVIEW_HEIGHT)];
        }
        else {
            [_infoView setFrame:CGRectMake(_infoView.frame.origin.x,
                                           _infoView.frame.origin.y,
                                           _infoView.frame.size.width,
                                           INFOVIEW_HEIGHT - _goldKeeperView.frame.size.height)];
        }
        
        [_orderView setFrame:CGRectMake(_orderView.frame.origin.x,
                                        _infoView.frame.origin.y + _infoView.frame.size.height,
                                        _orderView.frame.size.width,
                                        _orderView.frame.size.height)];
        [_tableHeaderView setFrame:CGRectMake(_tableHeaderView.frame.origin.x,
                                              _tableHeaderView.frame.origin.y,
                                              _tableHeaderView.frame.size.width,
                                              _orderView.frame.origin.y + _orderView.frame.size.height)];
        
        [_dataTable setTableHeaderView:_tableHeaderView];
    }
    else {
        if ([_accountInfo[@"계좌번호"] hasPrefix:GOLD_186]) {
            [_infoView setFrame:CGRectMake(_infoView.frame.origin.x,
                                           _infoView.frame.origin.y,
                                           _infoView.frame.size.width,
                                           INFOVIEW_HEIGHT)];
        }
        else {
            [_infoView setFrame:CGRectMake(_infoView.frame.origin.x,
                                           _infoView.frame.origin.y,
                                           _infoView.frame.size.width,
                                           INFOVIEW_HEIGHT - _goldKeeperView.frame.size.height)];
        }
        
        [_infoMoreView setFrame:CGRectMake(_infoMoreView.frame.origin.x,
                                           _infoView.frame.origin.y + _infoView.frame.size.height,
                                           _infoMoreView.frame.size.width,
                                           _infoMoreView.frame.size.height)];
        [_orderView setFrame:CGRectMake(_orderView.frame.origin.x,
                                        _infoMoreView.frame.origin.y + _infoMoreView.frame.size.height,
                                        _orderView.frame.size.width,
                                        _orderView.frame.size.height)];
        [_tableHeaderView setFrame:CGRectMake(_tableHeaderView.frame.origin.x,
                                              _tableHeaderView.frame.origin.y,
                                              _tableHeaderView.frame.size.width,
                                              _orderView.frame.origin.y + _orderView.frame.size.height)];
        
        [_dataTable setTableHeaderView:_tableHeaderView];
    }
}

/// 조회기준
- (IBAction)orderStandard:(UIButton *)sender
{
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"조회기준"
                                                                   options:_orderStandardList
                                                                   CellNib:@"SHBExchangePopupCell"
                                                                     CellH:32
                                                               CellDispCnt:3
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 1개월, 3개월
- (IBAction)orderBtn:(UIButton *)sender
{
    self.endDate = AppInfo.tran_Date;
    
    switch ([sender tag]) {
        case FOREXRGOLDDETAIL_MONTH:
            self.startDate = [SHBUtility dateStringToMonth:-1 toDay:0];
            
            break;
        case FOREXRGOLDDETAIL_THREEMONTH:
            self.startDate = [SHBUtility dateStringToMonth:-3 toDay:0];
            
            break;
            
        default:
            break;
    }
    
    [self listDataRequest:YES];
}

/// 기간선택
- (IBAction)orderSelectBtn:(UIButton *)sender
{
    SHBPeriodPopupView *popupView = [[[SHBPeriodPopupView alloc] initWithTitle:@"기간선택" SubViewHeight:70] autorelease];
    [popupView setDelegate:self];
    [popupView periodModeForDate:YES];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 화살표
- (IBAction)reverseBtn:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
    
    if ([sender isSelected]) {
        [sender setAccessibilityLabel:@"최근 거래순 정렬"];
    }
    else {
        [sender setAccessibilityLabel:@"과거 거래순 정렬"];
    }
    
    [self setReverseData];
}

/// 더보기
- (IBAction)moreBtn:(UIButton *)sender
{
    if ([self.dataList count] > _moreCount) {
        _moreCount += MORECOUNT;
        
        if (_moreCount > [self.dataList count]) {
            _moreCount = [self.dataList count];
        }
        
        if ([self.dataList count] == _moreCount) {
            [_dataTable setTableFooterView:nil];
        }
        
        [_dataTable reloadData];
    }
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    switch (self.service.serviceId) {
        case EXCHANGE_D7012_SERVICE:
        case EXCHANGE_D7013_SERVICE:
        {
            [aDataSet insertObject:[NSString stringWithFormat:@"%@g", aDataSet[@"잔고량"]]
                            forKey:@"_잔량"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@%%", aDataSet[@"수익률"]]
                            forKey:@"_평가수익률"
                           atIndex:0];
            [aDataSet insertObject:[aDataSet[@"선물환가입건수"] isEqualToString:@"0"] ? @"미가입" : @"가입"
                            forKey:@"_골드키퍼서비스"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@%%", aDataSet[@"선물환포함수익률"]]
                            forKey:@"_선물환포함수익률"
                           atIndex:0];
            [aDataSet insertObject:_accountInfo[@"과목명"]
                            forKey:@"_과목명"
                           atIndex:0];
            [aDataSet insertObject:_accountInfo[@"_계좌번호"]
                            forKey:@"_계좌번호"
                           atIndex:0];
        }
            break;
        case EXCHANGE_D7011_SERVICE:
        {
            Float64 inSum = 0.0f;
            Float64 outSum = 0.0f;
            
            NSInteger inCount = 0;
            NSInteger outCount = 0;
            
            NSArray *array = [aDataSet arrayWithForKey:@"골드리슈"];
            
            for (NSMutableDictionary *dic in array) {
                if ([dic[@"지급금액"] doubleValue] == 0.0f) {
                    [dic setObject:@"맡기신금(gram)"
                            forKey:@"_거래종류"];
                    
                    if ([dic[@"거래금액"] doubleValue] != 0.0f) {
                        inSum += [dic[@"거래원화금액->originalValue"] doubleValue];
                        inCount ++;
                    }
                }
                else {
                    [dic setObject:@"찾으신금(gram)"
                            forKey:@"_거래종류"];
                    
                    if ([dic[@"거래금액"] doubleValue] != 0.0f) {
                        outSum += [dic[@"거래원화금액->originalValue"] doubleValue];
                        outCount ++;
                    }
                }
                
                [dic setObject:[NSString stringWithFormat:@"%@g", dic[@"거래금액"]]
                        forKey:@"_거래금액(g)"];
                [dic setObject:[NSString stringWithFormat:@"%@g", dic[@"잔고량"]]
                        forKey:@"_잔량"];
                
                if ([_accountInfo[@"계좌번호"] hasPrefix:GOLD_188]) {
                    [dic setObject:@"적용가격($AU)" forKey:@"_적용가격"];
                    [dic setObject:@"외화금액(USD)" forKey:@"_환산금액"];
                }
                else {
                    [dic setObject:@"적용가격(XAU)" forKey:@"_적용가격"];
                    [dic setObject:@"환산금액(원)" forKey:@"_환산금액"];
                }
            }
            
            if ([_accountInfo[@"계좌번호"] hasPrefix:GOLD_188]) {
                [aDataSet insertObject:@"골드리슈평가금액(USD)"
                                forKey:@"_골드리슈평가금액라벨"
                               atIndex:0];
                [aDataSet insertObject:@"납입원금(USD)"
                                forKey:@"_투자원화금액라벨"
                               atIndex:0];
                [aDataSet insertObject:[NSString stringWithFormat:@"%@$", [self addComma:outSum isPoint:YES]]
                                forKey:@"_찾으신금액합계"
                               atIndex:0];
                [aDataSet insertObject:[NSString stringWithFormat:@"%@$", [self addComma:inSum isPoint:YES]]
                                forKey:@"_맡기신금액합계"
                               atIndex:0];
            }
            else {
                [aDataSet insertObject:@"골드리슈평가금액(원)"
                                forKey:@"_골드리슈평가금액라벨"
                               atIndex:0];
                [aDataSet insertObject:@"투자원화금액(원)"
                                forKey:@"_투자원화금액라벨"
                               atIndex:0];
                [aDataSet insertObject:[NSString stringWithFormat:@"%@원", [self addComma:outSum isPoint:NO]]
                                forKey:@"_찾으신금액합계"
                               atIndex:0];
                [aDataSet insertObject:[NSString stringWithFormat:@"%@원", [self addComma:inSum isPoint:NO]]
                                forKey:@"_맡기신금액합계"
                               atIndex:0];
            }
            [aDataSet insertObject:@"찾으신금액합계"
                            forKey:@"_찾으신금액합계라벨"
                           atIndex:0];
            [aDataSet insertObject:@"맡기신금액합계"
                            forKey:@"_맡기신금액합계라벨"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"(%d건)", outCount]
                            forKey:@"_찾으신금액건수"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"(%d건)", inCount]
                            forKey:@"_맡기신금액건수"
                           atIndex:0];
            
            if (_isOrderSearch) {
                [aDataSet insertObject:[NSString stringWithFormat:@"조회기간:%@~%@[%d건]", _startDate, _endDate, [array count]]
                                forKey:@"_조회정보"
                               atIndex:0];
            }
            else {
                [aDataSet insertObject:[NSString stringWithFormat:@"최근거래내역 %d건이 조회되었습니다.", [array count]]
                                forKey:@"_조회정보"
                               atIndex:0];
            }
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet*)aDataSet
{
    switch (self.service.serviceId) {
        case EXCHANGE_D7012_SERVICE:
        case EXCHANGE_D7013_SERVICE:
        {
            [self listDataRequest:NO];
            
            [_infoMoreView setHidden:YES];
            
            [_inputMoney setHidden:YES];
            [_outputMoney setHidden:YES];
            
            // 선물환관련 내용 설정
            if ([_accountInfo[@"계좌번호"] hasPrefix:GOLD_186]) {
                if (!_isAllAccountList) {
                    if ([_accountInfo[@"추가적립가능여부"] isEqualToString:@"1"]) {
                        [_outputMoney setHidden:NO];
                        [_outputMoney setTitle:@"적립" forState:UIControlStateNormal];
                        
                        [_accountName setFrame:CGRectMake(_accountName.frame.origin.x,
                                                          _accountName.frame.origin.y,
                                                          _outputMoney.frame.origin.x - 4,
                                                          _accountName.frame.size.height)];
                    }
                }
                [_goldKeeperView setHidden:NO];
                
                [_infoView setFrame:CGRectMake(_infoView.frame.origin.x,
                                               _infoView.frame.origin.y,
                                               _infoView.frame.size.width,
                                               INFOVIEW_HEIGHT)];
            }
            else {
                if (!_isAllAccountList) {
                    [_inputMoney setHidden:NO];
                    
                    [_outputMoney setHidden:NO];
                    [_outputMoney setTitle:@"출금" forState:UIControlStateNormal];
                    
                    [_accountName setFrame:CGRectMake(_accountName.frame.origin.x,
                                                      _accountName.frame.origin.y,
                                                      _inputMoney.frame.origin.x - 4,
                                                      _accountName.frame.size.height)];
                }
                
                [_goldKeeperView setHidden:YES];
                
                [_infoView setFrame:CGRectMake(_infoView.frame.origin.x,
                                               _infoView.frame.origin.y,
                                               _infoView.frame.size.width,
                                               INFOVIEW_HEIGHT - _goldKeeperView.frame.size.height)];
            }
            
            // !@#$ 외환 임시 설정
//            [_inputMoney setHidden:YES];
//            [_outputMoney setHidden:YES];
            [_accountName setFrame:CGRectMake(_accountName.frame.origin.x,
                                              _accountName.frame.origin.y,
                                              _outputMoney.frame.origin.x + _outputMoney.frame.size.width,
                                              _accountName.frame.size.height)];
            //
            
            [_orderView setFrame:CGRectMake(_orderView.frame.origin.x,
                                            _infoView.frame.origin.y + _infoView.frame.size.height,
                                            _orderView.frame.size.width,
                                            _orderView.frame.size.height)];
            [_tableHeaderView setFrame:CGRectMake(_tableHeaderView.frame.origin.x,
                                                  _tableHeaderView.frame.origin.y,
                                                  _tableHeaderView.frame.size.width,
                                                  _orderView.frame.origin.y + _orderView.frame.size.height)];
            
            [_dataTable setTableHeaderView:_tableHeaderView];
            
            [_accountName initFrame:_accountName.frame];
            [_accountName setCaptionText:aDataSet[@"_과목명"]];
        }
            break;
        case EXCHANGE_D7011_SERVICE:
        {
            self.dataList = [aDataSet arrayWithForKey:@"골드리슈"];
            self.orderTempList = self.dataList;
            
            [_outMoneyCount setText:aDataSet[@"_찾으신금액건수"]];
            [_outMoney setText:aDataSet[@"_찾으신금액합계"]];
            [_inMoneyCount setText:aDataSet[@"_맡기신금액건수"]];
            [_inMoney setText:aDataSet[@"_맡기신금액합계"]];
            [_orderInfo setText:aDataSet[@"_조회정보"]];
            
            if ([self.dataList count] > _moreCount) {
                [_dataTable setTableFooterView:_moreView];
            }
            else {
                [_dataTable setTableFooterView:nil];
            }
            
            [self setOrderStandardData];
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    _orderStandardIndex = anIndex;
    
    [_orderStandard setTitle:_orderStandardList[_orderStandardIndex][@"1"]
                    forState:UIControlStateNormal];
    [_orderStandard.titleLabel setMinimumFontSize:9];
    [_orderStandard.titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    [self setOrderStandardData];
}

- (void)listPopupViewDidCancel
{
    
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.dataList count] == 0) {
        return 1;
    }
    
    if ([self.dataList count] > _moreCount) {
        return _moreCount;
    }
    
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataList count] == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.contentView setBackgroundColor:[UIColor clearColor]];
        }
        
        [cell.textLabel setText:@"조회된 거래내역이 없습니다."];
        [cell.textLabel setTextColor:RGB(74, 74, 74)];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
        
        return cell;
    }
    
    SHBForexGoldDetailListCell *cell = (SHBForexGoldDetailListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBForexGoldDetailListCell"];
    
    if (cell == nil) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBForexGoldDetailListCell"
                                                       owner:self options:nil];
		cell = (SHBForexGoldDetailListCell *)array[0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    if ([cellDataSet[@"_거래종류"] isEqualToString:@"맡기신금(gram)"]) {
        [cell.tradeMoneyLabel setTextColor:RGB(209, 75, 75)];
        [cell.tradeMoney setTextColor:RGB(209, 75, 75)];
    }
    else {
        [cell.tradeMoneyLabel setTextColor:RGB(0, 137, 220)];
        [cell.tradeMoney setTextColor:RGB(0, 137, 220)];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SHBPeriodPopupView

- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary *)mDic
{
    if ([mDic[@"from"] integerValue] >
        [[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"오늘까지만 조회가 가능합니다."];
        return;
    }
    
    if ([mDic[@"to"] integerValue] >
        [[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"오늘까지만 조회가 가능합니다."];
        return;
    }
    
    self.startDate = [SHBUtility getDateWithDash:mDic[@"from"]];
    self.endDate = [SHBUtility getDateWithDash:mDic[@"to"]];
    
    [self listDataRequest:YES];
}

- (void)popupViewDidCancel
{
    
}

@end
