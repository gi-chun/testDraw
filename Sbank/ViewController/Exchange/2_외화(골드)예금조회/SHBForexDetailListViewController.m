//
//  SHBForexDetailListViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexDetailListViewController.h"
#import "SHBForexDetailListCell.h" // cell
#import "SHBUtility.h" // 유틸
#import "SHBExchangeService.h" // 서비스
#import "SHBPushInfo.h" // 푸시

#import "SHBListPopupView.h" // list popup
#import "SHBPeriodPopupView.h" // 기간 popup

#define FOREX_180 @"180" // 외화체인지업예금
#define FOREX_182 @"182" // 외화정기예금, 민트리볼빙외화예금, 민트Libor연동외화예금
#define FOREX_185 @"185" // Multiple외화정기예금
#define FOREX_184 @"184" // Tops외화적립예금
#define FOREX_181 @"181" // 외화당좌예금
#define FOREX_327 @"327" // 외화당좌예금

#define CELLHEIGHT 161
#define MORECOUNT 9999999 // 더보기 (구현시 숫자 수정하면 됨)

enum FOREXRDETAIL_ORDERBTN_TAG {
    FOREXRDETAIL_MONTH = 100,
    FOREXRDETAIL_THREEMONTH
};

@interface SHBForexDetailListViewController ()
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

@end

@implementation SHBForexDetailListViewController

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
    
    self.orderStandardList = [NSMutableArray arrayWithArray:
                              @[
                              @{@"1" : @"전체"},
                              @{@"1" : @"입금"},
                              @{@"1" : @"출금"},
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
    
    if ([_accountInfo[@"계좌번호"] hasPrefix:FOREX_180]) {
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
    
    [_infoView release];
    [_dataTable release];
    [_orderView release];
    [_tableHeaderView release];
    [_autoLabelView release];
    [_orderInfo release];
    [_orderStandard release];
    [_headerBtn1 release];
    [_headerBtn2 release];
    [_headerBtn3 release];
    [_accountName release];
    [_arrow release];
    [_orderStandardLabel release];
    [_moreView release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setInfoView:nil];
    [self setDataTable:nil];
    [self setOrderView:nil];
    [self setTableHeaderView:nil];
    [self setAutoLabelView:nil];
    [self setOrderInfo:nil];
    [self setOrderStandard:nil];
    [self setHeaderBtn1:nil];
    [self setHeaderBtn2:nil];
    [self setHeaderBtn3:nil];
    [self setAccountName:nil];
    [self setArrow:nil];
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
         @"거래점용계좌번호" : _accountInfo[@"계좌번호"],
         @"거래점용은행구분" : @"1",
         }];
    }
    else {
        [aDataSet setDictionary:
         @{
         @"계좌번호" : _accountInfo[@"구계좌번호"],
         @"은행구분" : _accountInfo[@"은행구분"],
         @"거래점용계좌번호" : _accountInfo[@"구계좌번호"],
         @"거래점용은행구분" : _accountInfo[@"은행구분"],
         }];
    }
    
    [aDataSet insertObject:_accountInfo[@"통화코드"]
                    forKey:@"통화코드"
                   atIndex:0];
    
    if ([_accountInfo[@"계좌번호"] hasPrefix:FOREX_185]) {
        [aDataSet insertObject:_accountInfo[@"회차"]
                        forKey:@"회차"
                       atIndex:0];
    }
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F1110_SERVICE
                                                   viewController:self] autorelease];
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
         @"거래점용계좌번호" : _accountInfo[@"계좌번호"],
         @"거래점용은행구분" : @"1",
         }];
    }
    else {
        [aDataSet setDictionary:
         @{
         @"계좌번호" : _accountInfo[@"구계좌번호"],
         @"은행구분" : _accountInfo[@"은행구분"],
         @"거래점용계좌번호" : _accountInfo[@"구계좌번호"],
         @"거래점용은행구분" : _accountInfo[@"은행구분"],
         }];
    }
    
    [aDataSet insertObject:@"1"
                    forKey:@"최근거래내역부터"
                   atIndex:0];
    [aDataSet insertObject:_accountInfo[@"통화코드"]
                    forKey:@"통화코드"
                   atIndex:0];
    
    if ([_accountInfo[@"계좌번호"] hasPrefix:FOREX_185]) {
        [aDataSet insertObject:_accountInfo[@"회차"]
                        forKey:@"회차"
                       atIndex:0];
    }
    
    if (isOrder) {
        _isOrderSearch = YES;
        
        [aDataSet insertObject:_startDate
                        forKey:@"조회시작일"
                       atIndex:0];
        [aDataSet insertObject:_endDate
                        forKey:@"조회종료일"
                       atIndex:0];
    }
    else {
        _isOrderSearch = NO;
    }
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F1113_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = aDataSet;
    
    [self.service start];
}

- (void)setOrderStandardData
{
    switch (_orderStandardIndex) {
        case 0:
            self.dataList = _orderTempList;
            
            break;
        case 1:
        {
            NSMutableArray *array = [NSMutableArray array];
            
            for (OFDataSet *dataSet in _orderTempList) {
                if ([dataSet[@"_입출금종류"] isEqualToString:@"입금"]) {
                    [array addObject:dataSet];
                }
            }
            
            self.dataList = (NSArray *)array;
        }
            break;
        case 2:
        {
            NSMutableArray *array = [NSMutableArray array];
            
            for (OFDataSet *dataSet in _orderTempList) {
                if ([dataSet[@"_입출금종류"] isEqualToString:@"출금"]) {
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

#pragma mark - Button

/// 상단버튼1, 2, 3
- (IBAction)headerBtn:(UIButton *)sender
{
    NSString *openBanking = @"";
    
    if (!AppInfo.realServer) {
        openBanking = [NSString stringWithFormat:@"%@/bank/forexgold/forex", URL_M_TEST];
    }
    else {
        openBanking = [NSString stringWithFormat:@"%@/bank/forexgold/forex", URL_M];
    }
    
    if ([sender.titleLabel.text isEqualToString:@"입금"]) {
        openBanking = [NSString stringWithFormat:@"%@/ex_transfer_purchase.jsp?EQUP_CD=SI", openBanking];
    }
    else if ([sender.titleLabel.text isEqualToString:@"이체"]) {
        openBanking = [NSString stringWithFormat:@"%@/ex_transfer_account.jsp?EQUP_CD=SI", openBanking];
    }
    else if ([sender.titleLabel.text isEqualToString:@"매도"]) {
        openBanking = [NSString stringWithFormat:@"%@/ex_transfer_sale.jsp?EQUP_CD=SI", openBanking];
    }
    
    [[SHBPushInfo instance] requestOpenURL:openBanking SSO:YES];
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
        case FOREXRDETAIL_MONTH:
            self.startDate = [SHBUtility dateStringToMonth:-1 toDay:0];
            
            break;
        case FOREXRDETAIL_THREEMONTH:
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
        case EXCHANGE_F1110_SERVICE:
        {
            [aDataSet insertObject:_accountInfo[@"_계좌번호"]
                            forKey:@"_계좌번호"
                           atIndex:0];
            
            if ([_accountInfo[@"계좌번호"] hasPrefix:FOREX_182] ||
                [_accountInfo[@"계좌번호"] hasPrefix:FOREX_185]) {
                [aDataSet insertObject:aDataSet[@"정기_적용이율"]
                                forKey:@"_이율"
                               atIndex:0];
            }
            else {
                [aDataSet insertObject:@""
                                forKey:@"_이율"
                               atIndex:0];
            }
            
            if ([_accountInfo[@"계좌번호"] hasPrefix:FOREX_185]) {
                if ([aDataSet[@"정기_자동재예치여부"] isEqualToString:@"YES"]) {
                    [aDataSet insertObject:@"신청"
                                    forKey:@"_자동재예치"
                                   atIndex:0];
                }
                else {
                    [aDataSet insertObject:@"신청안함"
                                    forKey:@"_자동재예치"
                                   atIndex:0];
                }
                
                if ([aDataSet[@"정기_자동해지신청여부"] isEqualToString:@"YES"]) {
                    [aDataSet insertObject:@"신청"
                                    forKey:@"_만기자동해지"
                                   atIndex:0];
                }
                else {
                    [aDataSet insertObject:@"신청안함"
                                    forKey:@"_만기자동해지"
                                   atIndex:0];
                }
            }
        }
            break;
        case EXCHANGE_F1113_SERVICE: // 실제전문은  f1114으로 리턴,  입금의뢰인명 추가임!,  2014.3.28일 추가
        {
            NSArray *array = [aDataSet arrayWithForKey:@"외화예금"];
            
            for (NSMutableDictionary *dic in array) {
                if ([dic[@"지급금액->originalValue"] doubleValue] == 0.0f) {
                    [dic setObject:@"입금"
                            forKey:@"_입출금종류"];
                    [dic setObject:dic[@"입금금액"]
                            forKey:@"_거래금액"];
                    [dic setObject:dic[@"입금의뢰인명"]  // 입금일때만 추가 2014. 3.31
                            forKey:@"_입금의뢰인명"];
                }
                else {
                    [dic setObject:@"출금"
                            forKey:@"_입출금종류"];
                    [dic setObject:dic[@"지급금액"]
                            forKey:@"_거래금액"];
                    [dic setObject:@"" // 출금일때는 값없음
                            forKey:@"_입금의뢰인명"];
                }
                
                if (![dic[@"회차"] isEqualToString:@"0"]) {
                    [dic setObject:[NSString stringWithFormat:@"%@(%0.2lf%%)", dic[@"회차"], [dic[@"회차별만기이율"] doubleValue]]
                            forKey:@"_회차(이율)"];
                }
                else {
                    [dic setObject:@""
                            forKey:@"_회차(이율)"];
                }
                
                if (![dic[@"정정취소구분"] isEqualToString:@"NO"]) {
                    [dic setObject:dic[@"정정취소구분"]
                            forKey:@"_정정취소"];
                }
                else {
                    [dic setObject:@""
                            forKey:@"_정정취소"];
                }
            }
            
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
        case EXCHANGE_F1110_SERVICE:
        {
            [self listDataRequest:NO];
            
            // 자동재예치, 만기자동해지 설정
            if ([_accountInfo[@"계좌번호"] hasPrefix:FOREX_185]) {
                [_autoLabelView setHidden:NO];
            }
            else {
                [_autoLabelView setHidden:YES];
                
                [_infoView setFrame:CGRectMake(_infoView.frame.origin.x,
                                               _infoView.frame.origin.y,
                                               _infoView.frame.size.width,
                                               _infoView.frame.size.height - _autoLabelView.frame.size.height)];
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
            
            // 상단버튼 설정
            [_headerBtn1 setHidden:YES];
            [_headerBtn1 setTitle:@"" forState:UIControlStateNormal];
            [_headerBtn2 setHidden:YES];
            [_headerBtn2 setTitle:@"" forState:UIControlStateNormal];
            [_headerBtn3 setHidden:YES];
            [_headerBtn3 setTitle:@"" forState:UIControlStateNormal];
            
            [_accountName setFrame:CGRectMake(_accountName.frame.origin.x,
                                              _accountName.frame.origin.y,
                                              _headerBtn3.frame.origin.x + _headerBtn3.frame.size.width,
                                              _accountName.frame.size.height)];
            
            if ([_accountInfo[@"계좌번호"] hasPrefix:FOREX_180]) {
                if (!_isAllAccountList) {
                    if ([_accountInfo[@"인터넷뱅킹출금계좌여부"] isEqualToString:@"1"]) {
                        [_headerBtn1 setHidden:NO];
                        [_headerBtn1 setTitle:@"이체" forState:UIControlStateNormal];
                        [_headerBtn2 setHidden:NO];
                        [_headerBtn2 setTitle:@"매도" forState:UIControlStateNormal];
                        [_headerBtn3 setHidden:NO];
                        [_headerBtn3 setTitle:@"입금" forState:UIControlStateNormal];
                        
                        [_accountName setFrame:CGRectMake(_accountName.frame.origin.x,
                                                          _accountName.frame.origin.y,
                                                          _headerBtn1.frame.origin.x - 4,
                                                          _accountName.frame.size.height)];
                    }
                    else {
                        [_headerBtn3 setHidden:NO];
                        [_headerBtn3 setTitle:@"입금" forState:UIControlStateNormal];
                        
                        [_accountName setFrame:CGRectMake(_accountName.frame.origin.x,
                                                          _accountName.frame.origin.y,
                                                          _headerBtn3.frame.origin.x - 4,
                                                          _accountName.frame.size.height)];
                    }
                }
            }
            else if ([_accountInfo[@"계좌번호"] hasPrefix:FOREX_181] ||
                     [_accountInfo[@"계좌번호"] hasPrefix:FOREX_327]) {
                if (!_isAllAccountList) {
                    [_headerBtn3 setHidden:NO];
                    [_headerBtn3 setTitle:@"입금" forState:UIControlStateNormal];
                    
                    [_accountName setFrame:CGRectMake(_accountName.frame.origin.x,
                                                      _accountName.frame.origin.y,
                                                      _headerBtn3.frame.origin.x - 4,
                                                      _accountName.frame.size.height)];
                }
            }
            
            // !@#$ 외환 임시 설정
            [_headerBtn1 setHidden:YES];
            [_headerBtn2 setHidden:YES];
            [_headerBtn3 setHidden:YES];
            [_accountName setFrame:CGRectMake(_accountName.frame.origin.x,
                                              _accountName.frame.origin.y,
                                              _headerBtn3.frame.origin.x + _headerBtn3.frame.size.width,
                                              _accountName.frame.size.height)];
            //
            
            [_accountName initFrame:_accountName.frame];
            [_accountName setCaptionText:aDataSet[@"공통_상품명"]];
            
        }
            break;
        case EXCHANGE_F1113_SERVICE:
        {
            self.dataList = [aDataSet arrayWithForKey:@"외화예금"];
            self.orderTempList = self.dataList;
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_accountInfo[@"계좌번호"] hasPrefix:FOREX_185]) {
        return CELLHEIGHT;
    }
    else {
        return CELLHEIGHT - 25;
    }
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
    
    SHBForexDetailListCell *cell = (SHBForexDetailListCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBForexDetailListCell"];
    
	if (cell == nil) {
		NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBForexDetailListCell"
                                                       owner:self options:nil];
		cell = (SHBForexDetailListCell *)array[0];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
	}
    
    if ([_accountInfo[@"계좌번호"] hasPrefix:FOREX_185]) {
        [cell.interestRateLabel setHidden:NO];
        [cell.interestRate setHidden:NO];
        
        [cell.cancelMoneyView setFrame:CGRectMake(cell.cancelMoneyView.frame.origin.x,
                                                  CELLHEIGHT - 50 - 1,
                                                  cell.cancelMoneyView.frame.size.width,
                                                  cell.cancelMoneyView.frame.size.height)];
    }
    else {
        [cell.interestRateLabel setHidden:YES];
        [cell.interestRate setHidden:YES];
        
        [cell.cancelMoneyView setFrame:CGRectMake(cell.cancelMoneyView.frame.origin.x,
                                                  CELLHEIGHT - 50 - 25 - 1,
                                                  cell.cancelMoneyView.frame.size.width,
                                                  cell.cancelMoneyView.frame.size.height)];
    }
    
    OFDataSet *cellDataSet = self.dataList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    if ([cellDataSet[@"_입출금종류"] isEqualToString:@"입금"]) {
        [cell.inOutValueLabel setTextColor:RGB(209, 75, 75)];
        [cell.inOutValue setTextColor:RGB(209, 75, 75)];
    }
    else {
        [cell.inOutValueLabel setTextColor:RGB(0, 137, 220)];
        [cell.inOutValue setTextColor:RGB(0, 137, 220)];
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
