//
//  SHBSmartTransferAddInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 24..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSmartTransferAddInputViewController.h"
#import "SHBAccountService.h" // service
#import "SHBListPopupView.h" // list popup
#import "SHBAccidentPopupView.h" // popup

#import "SHBSmartTransferAddCompleteViewController.h" // 스마트 이체 조회/등록/변경 완료

/// list popup tag
enum SMART_TRANSFER_LISTPOPUP_TAG {
    
    SMART_TRANSFER_LISTPOPUP_ACCOUNT = 3301,
    SMART_TRANSFER_LISTPOPUP_DATE,
    SMART_TRANSFER_LISTPOPUP_TIME
};

@interface SHBSmartTransferAddInputViewController () <SHBListPopupViewDelegate>

@property (retain ,nonatomic) NSMutableArray *accountList; // 알림 계좌번호
@property (retain, nonatomic) NSMutableArray *noticeDateList; // 통지 일자(매월)
@property (retain, nonatomic) NSMutableArray *noticeTimeList; // 통지 시간

@property (retain ,nonatomic) NSMutableDictionary *selectAccountDic; // 알림 계좌번호
@property (retain ,nonatomic) NSMutableDictionary *selectNoticeDateDic; // 통지 일자(매월)
@property (retain ,nonatomic) NSMutableDictionary *selectNoticeTimeDic; // 통지 시간

@end

@implementation SHBSmartTransferAddInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [self initNotification];
    
    [super viewDidLoad];
    
    [self setTitle:@"스마트 이체 조회/등록/변경"];
    self.strBackButtonTitle = @"스마트 이체 조회/등록/변경";
    
    [self.contentScrollView addSubview:_mainV];
    [self.contentScrollView setContentSize:_mainV.frame.size];
    
    [self setTextFieldTagOrder:@[ _standardAmount, _rate, _amount, _transferAmount ]];
    
    contentViewHeight = _mainV.frame.size.height;
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    [_info initFrame:_info.frame];
    [_info setText:@"<midRed_13>『스마트이체』 </midRed_13><midGray_13>란 고객님이 설정하신 기준금액 이상 해당 계좌에 입금되는 경우(또는 특정시점에) 스마트폰의 알림 메시지(Push)를 통해 안내하고 간편하게 이체할 수 있도록 지원하는 서비스입니다.</midGray_13>"];
    
    [_topInfo initFrame:_topInfo.frame];
    [_topInfo setText:@"<midLightBlue_13>알림 설정에 따라 </midLightBlue_13><midRed_13>『신한Smail』 </midRed_13><midLightBlue_13>앱의 알림(Push) 메시지가 발송되며 간편하게 이체거래를 하실 수 있습니다.</midLightBlue_13>"];
    
    [_bottomInfo initFrame:_bottomInfo.frame];
    [_bottomInfo setText:@"<midRed_13>『스마트이체』 </midRed_13><midGray_13>를 설정하시면 </midGray_13><midRed_13>『신한Smail』 </midRed_13><midGray_13>의 알림(Push) 메시지를 통해 간편하게 이체하실 수 있습니다.</midGray_13>"];
    
    [self resetUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.accountList = nil;
    self.noticeDateList = nil;
    self.noticeTimeList = nil;
    
    self.selectAccountDic = nil;
    self.selectNoticeDateDic = nil;
    self.selectNoticeTimeDic = nil;
    
    [_mainV release];
    [_account release];
    
    [_incomeTransfer release];
    [_standardAmount release];
    [_rateBtn release];
    [_rate release];
    [_amountBtn release];
    [_amount release];
    
    [_noticeTransfer release];
    [_noticeDate release];
    [_noticeTime release];
    [_transferAmount release];
    
    [_smartTransferSet release];
    [_smartTransferCancel release];
    [_infoView release];
    [_info release];
    [_topInfo release];
    [_bottomInfo release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainV:nil];
    [self setAccount:nil];
    
    [self setIncomeTransfer:nil];
    [self setStandardAmount:nil];
    [self setRateBtn:nil];
    [self setRate:nil];
    [self setAmountBtn:nil];
    [self setAmount:nil];
    
    [self setNoticeTransfer:nil];
    [self setNoticeDate:nil];
    [self setNoticeTime:nil];
    [self setTransferAmount:nil];
    
    [self setSmartTransferSet:nil];
    [self setSmartTransferCancel:nil];
    [self setInfoView:nil];
    [self setInfo:nil];
    [self setTopInfo:nil];
    [self setBottomInfo:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        
        SHBSmartTransferAddCompleteViewController *viewController = [[[SHBSmartTransferAddCompleteViewController alloc] initWithNibName:@"SHBSmartTransferAddCompleteViewController" bundle:nil] autorelease];
        
        viewController.data = self.data;
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)getElectronicSignCancel
{
    [self.navigationController fadePopViewController];
}

#pragma mark - Method

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 전자서명 확인
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignResult:)
                                                 name:@"eSignFinalData"
                                               object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
}

- (void)resetUI
{
    [self setListData];
    
    [self buttonPressed:_incomeTransfer];
    [self buttonPressed:_rateBtn];
    [self buttonPressed:_smartTransferSet];
    
    [_standardAmount setText:@""];
    [_rate setText:@""];
    [_amount setText:@""];
    [_transferAmount setText:@""];
    
    NSDictionary *dataDic = nil;
    
    for (NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"]) {
        
        if ([dic[@"상품코드"] isEqualToString:@"230011831"]) {
            
            dataDic = dic;
            
            break;
        }
    }
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              @"고객번호" : AppInfo.customerNo,
                              @"적금계좌번호" : [dataDic[@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""]
                              }];
    self.service = nil;
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"E5082" viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)setListData
{
    self.accountList = [NSMutableArray array];
    
    // 계좌이체의 본인계좌 버튼과 동일
    
    self.accountList = [self outAccountList];
    
    self.noticeDateList = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 31; i++) {
        
        [_noticeDateList addObject:@{ @"1" : [NSString stringWithFormat:@"%d일", i + 1],
                                      @"CODE" : [NSString stringWithFormat:@"%02d", i + 1] }];
    }
    
    [_noticeDateList addObject:@{ @"1" : @"매일", @"CODE" : @"90" }];
    [_noticeDateList addObject:@{ @"1" : @"매월말일", @"CODE" : @"91" }];
    
    self.selectNoticeDateDic = _noticeDateList[0];
    
    [self setButton:_noticeDate withTitle:_selectNoticeDateDic[@"1"]];
    
    self.noticeTimeList = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 24; i++) {
        
        [_noticeTimeList addObject:@{ @"1" : [NSString stringWithFormat:@"%02d:00", i + 1],
                                      @"eSign" : [NSString stringWithFormat:@"%02d시", i + 1],
                                      @"CODE" : [NSString stringWithFormat:@"%02d00", i + 1] }];
        
        if (i + 1 == 12) {
            
            self.selectNoticeTimeDic = _noticeTimeList[i];
        }
    }
    
    [self setButton:_noticeTime withTitle:_selectNoticeTimeDic[@"1"]];
    
}

- (void)setButton:(UIButton *)button withTitle:(NSString *)title
{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateDisabled];
}

- (void)showPopupView:(NSString *)title withOptions:(NSMutableArray *)options withTag:(NSInteger)tag
{
    NSInteger dispCnt = [options count];
    
    if (dispCnt >= 7) {
        
        dispCnt = 7;
    }
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:title
                                                                   options:options
                                                                   CellNib:@"SHBExchangePopupNoMoreCell"
                                                                     CellH:32
                                                               CellDispCnt:dispCnt
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView setTag:tag];
    [popupView showInView:self.navigationController.view animated:YES];
}

- (NSString *)getErrorMessage
{
    if ([_smartTransferCancel isSelected]) {
        
        if (![self.data[@"상태구분"] isEqualToString:@"1"]) {
            
            return @"이미 스마트이체 설정을 해제한 상태입니다.";
        }
        
        return @"";
    }
    
    if ([_account.titleLabel.text isEqualToString:@"선택하세요"] ||
        [_account.titleLabel.text length] == 0 ||
        _selectAccountDic == nil) {
        
        return @"푸쉬알림계좌를 선택해 주십시오.";
    }
    
    if ([_incomeTransfer isSelected]) {
        
        NSString *standardAmountText = [_standardAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if ([standardAmountText length] == 0) {
            
            return @"기준금액을 입력해 주세요.";
        }
        
        if ([standardAmountText longLongValue] < 10000) {
            
            return @"기준금액은 일만원 이상이어야 합니다.";
        }
        
        if ([_rateBtn isSelected]) {
            
            if ([_rate.text length] == 0) {
                
                return @"기준금액>비율을 설정해 주세요.";
            }
            
            if ([_rate.text integerValue] == 0 || [_rate.text integerValue] > 100) {
                
                return @"기준금액 비율 설정은 1~100 이하 가능합니다.";
            }
            
            CGFloat rate = [_rate.text floatValue] / 100.f;
            
            if ([standardAmountText longLongValue] * rate < 1000.f) {
                
                return @"이체금액은 일천원 이상이어야 합니다.\n비율설정을 다시 확인해 주세요.";
            }
        }
        else {
            
            NSString *amountText = [_amount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            if ([amountText length] == 0) {
                
                return @"기준금액>금액을 입력해 주세요.";
            }
            
            if ([amountText longLongValue] < 1000) {
                
                return @"기준금액>금액설정은 일천원 이상이어야 합니다.";
            }
            
            if ([standardAmountText longLongValue] < [amountText longLongValue]) {
                
                return @"금액설정이 기준 금액을 초과하였습니다.";
            }
        }
    }
    else {
        
        NSString *transferAmountText = [_transferAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        if ([transferAmountText length] == 0) {
            
            return @"이체금액을 입력해 주세요.";
        }
        
        if ([transferAmountText longLongValue] < 1000) {
            
            return @"이체금액은 일천원 이상이어야 합니다.";
        }
    }
    
    return @"";
}

- (void)requestE5081
{
    if ([self.data[@"상태구분"] isEqualToString:@"1"]) {
        
        // 변경의 경우 해지 후 등록을 해야됨 E5083
        
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                                 @"푸쉬계좌번호" : [self.data[@"푸쉬계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                 @"적금계좌번호" : [self.data[@"_계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                 @"은행구분" : @"1",
                                 @"등록해제구분" : @"2",
                                 @"등록해제코드" : @"22328", // !@#$
                                 @"고객번호" : AppInfo.customerNo
                                 }];
        
        AppInfo.commonDic = [NSMutableDictionary dictionaryWithDictionary:@{ @"스마트이체등록변경" : @"1",
                                                                             @"해지전문" : dataSet }];
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.data];
    
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"스마트이체 조회/등록/변경";
    
    AppInfo.electronicSignTitle = @"스마트이체 조회/등록/변경";
    
    [AppInfo addElectronicSign:@"1.신청내용"];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)일자: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)시간: %@", AppInfo.tran_Time]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)알림계좌번호: %@", _selectAccountDic[@"2"]]];
    
    [dic setObject:_selectAccountDic[@"2"] forKey:@"_알림계좌번호"];
    
    if ([_incomeTransfer isSelected]) {
        
        // 소득이체방식
        
        [AppInfo addElectronicSign:@"(4)이체방식: 소득이체방식"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)기준금액: %@원", _standardAmount.text]];
        
        [dic setObject:[NSString stringWithFormat:@"%@원", _standardAmount.text] forKey:@"_기준금액"];
        
        if ([_rateBtn isSelected]) {
            
            // 비율 설정(%)
            
            AppInfo.electronicSignCode = @"E5081_A";
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)비율설정: %@%%", _rate.text]];
            
            [dic setObject:[NSString stringWithFormat:@"%@%%", _rate.text] forKey:@"_비율설정"];
        }
        else {
            
            // 금액 설정(원)
            
            AppInfo.electronicSignCode = @"E5081_B";
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)금액설정: %@원", _amount.text]];
            
            [dic setObject:[NSString stringWithFormat:@"%@원", _amount.text] forKey:@"_금액설정"];
        }
        
        [AppInfo addElectronicSign:@"(7)스마트이체설정: 설정"];
    }
    else {
        
        // 알림이체방식
        
        AppInfo.electronicSignCode = @"E5081_C";
        
        [AppInfo addElectronicSign:@"(4)이체방식: 알림이체방식"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)통지일자(매월): %@", _selectNoticeDateDic[@"1"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)통지시간: %@", _selectNoticeTimeDic[@"eSign"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)이체금액: %@원", _transferAmount.text]];
        [AppInfo addElectronicSign:@"(8)스마트이체설정: 설정"];
        
        [dic setObject:[NSString stringWithFormat:@"%@", _selectNoticeDateDic[@"1"]] forKey:@"_통지일자"];
        [dic setObject:[NSString stringWithFormat:@"%@", _selectNoticeTimeDic[@"1"]] forKey:@"_통지시간"];
        [dic setObject:[NSString stringWithFormat:@"%@원", _transferAmount.text] forKey:@"_이체금액"];
    }
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              @"푸쉬계좌번호" : [_selectAccountDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                              @"푸쉬구계좌번호" : [_selectAccountDic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                              @"은행구분" : @"1",
                              @"등록해제구분" : @"1",
                              @"등록해제코드" : @"22328", // !@#$
                              @"고객번호" : AppInfo.customerNo,
                              @"적금계좌번호" : [self.data[@"_계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                              @"적금만기일자" : [self.data[@"_만기일"] stringByReplacingOccurrencesOfString:@"." withString:@""]
                              }];
    
    if ([_incomeTransfer isSelected]) {
        
        // 소득이체방식
        
        [aDataSet insertObject:@"1"
                        forKey:@"이체방식설정"
                       atIndex:0];
        
        [aDataSet insertObject:_standardAmount.text
                        forKey:@"이체기준금액"
                       atIndex:0];
        
        if ([_rateBtn isSelected]) {
            
            // 비율 설정(%)
            
            [aDataSet insertObject:@"1"
                            forKey:@"이체금액설정구분"
                           atIndex:0];
            
            [aDataSet insertObject:_rate.text
                            forKey:@"이체비율"
                           atIndex:0];
        }
        else {
            
            // 금액 설정(원)
            
            [aDataSet insertObject:@"2"
                            forKey:@"이체금액설정구분"
                           atIndex:0];
            
            [aDataSet insertObject:_amount.text
                            forKey:@"이체금액"
                           atIndex:0];
        }
    }
    else {
        
        // 알림이체방식
        
        [aDataSet insertObject:@"2"
                        forKey:@"이체방식설정"
                       atIndex:0];
        
        [aDataSet insertObject:_selectNoticeDateDic[@"CODE"]
                        forKey:@"통지일자"
                       atIndex:0];
        
        [aDataSet insertObject:_selectNoticeTimeDic[@"CODE"]
                        forKey:@"통지시간"
                       atIndex:0];
        
        [aDataSet insertObject:@"2"
                        forKey:@"이체금액설정구분"
                       atIndex:0];
        
        [aDataSet insertObject:_transferAmount.text
                        forKey:@"이체금액"
                       atIndex:0];
    }
    
    
    self.service = nil;
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"E5081" viewController:self] autorelease];
    
    self.service.requestData = aDataSet;
    [self.service start];
    
    self.data = (NSDictionary *)dic;
}

- (void)requestE5083
{
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"스마트이체 조회/등록/변경";
    
    AppInfo.electronicSignCode = @"E5083";
    AppInfo.electronicSignTitle = @"스마트이체 조회/등록/변경";
    
    [AppInfo addElectronicSign:@"1.신청내용"];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)일자: %@", AppInfo.tran_Date]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)시간: %@", AppInfo.tran_Time]];
    [AppInfo addElectronicSign:@"(3)스마트이체설정: 해제"];
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              @"푸쉬계좌번호" : [_selectAccountDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                              @"적금계좌번호" : [self.data[@"_계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                              @"은행구분" : @"1",
                              @"등록해제구분" : @"2",
                              @"등록해제코드" : @"22328", // !@#$
                              @"고객번호" : AppInfo.customerNo
                              }];
    
    self.service = nil;
    self.service = [[[SHBAccountService alloc] initWithServiceCode:@"E5083" viewController:self] autorelease];
    
    self.service.requestData = aDataSet;
    [self.service start];
}

#pragma mark - Button

- (void)navigationButtonPressed:(id)sender
{
    if ([sender tag] == NAVI_BACK_BTN_TAG) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self.navigationController fadePopToRootViewController];
        
        return;
    }
    
    [super navigationButtonPressed:sender];
}

- (IBAction)buttonPressed:(id)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
            
        case 10: {
            
            // 설정안내
            
            SHBAccidentPopupView *popupView = [[[SHBAccidentPopupView alloc] initWithTitle:@"설정안내"
                                                                             SubViewHeight:_infoView.frame.size.height + 6
                                                                            setContentView:_infoView] autorelease];
            
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
            
        case 20: {
            
            // 알림 계좌번호
            
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"알림 계좌번호"
                                                                           options:_accountList
                                                                           CellNib:@"SHBAccountListPopupCell"
                                                                             CellH:50
                                                                       CellDispCnt:5
                                                                        CellOptCnt:4] autorelease];
            [popupView setDelegate:self];
            [popupView setTag:SMART_TRANSFER_LISTPOPUP_ACCOUNT];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
            
        case 30: {
            
            // 소득이체방식
            
            [_incomeTransfer setSelected:YES];
            [_standardAmount setEnabled:YES];
            [_rateBtn setEnabled:YES];
            [_amountBtn setEnabled:YES];
            
            if ([_rateBtn isSelected]) {
                
                [_rate setEnabled:YES];
                [_amount setEnabled:NO];
            }
            else {
                
                [_rate setEnabled:NO];
                [_amount setEnabled:YES];
            }
            
            [_noticeTransfer setSelected:NO];
            [_noticeDate setEnabled:NO];
            [_noticeTime setEnabled:NO];
            [_transferAmount setEnabled:NO];
            
            self.selectNoticeDateDic = _noticeDateList[0];
            
            [self setButton:_noticeDate withTitle:_selectNoticeDateDic[@"1"]];
            
            self.selectNoticeTimeDic = _noticeTimeList[11];
            
            [self setButton:_noticeTime withTitle:_selectNoticeTimeDic[@"1"]];
            
            [_transferAmount setText:@""];
            
            [self setTextFieldTagOrder:@[ _standardAmount, _rate, _amount, _transferAmount ]];
        }
            break;
            
        case 40: {
            
            // 비율 설정(%)
            
            [_rateBtn setSelected:YES];
            [_rate setEnabled:YES];
            [_amountBtn setSelected:NO];
            [_amount setEnabled:NO];
            
            [self setTextFieldTagOrder:@[ _standardAmount, _rate, _amount, _transferAmount ]];
        }
            break;
            
        case 50: {
            
            // 금액 설정(원)
            
            [_rateBtn setSelected:NO];
            [_rate setEnabled:NO];
            [_amountBtn setSelected:YES];
            [_amount setEnabled:YES];
            
            [self setTextFieldTagOrder:@[ _standardAmount, _rate, _amount, _transferAmount ]];
        }
            break;
            
        case 60: {
            
            // 알림이체방식
            
            [_incomeTransfer setSelected:NO];
            [_standardAmount setEnabled:NO];
            [_rateBtn setEnabled:NO];
            [_rate setEnabled:NO];
            [_amountBtn setEnabled:NO];
            [_amount setEnabled:NO];
            
            [_standardAmount setText:@""];
            [_rate setText:@""];
            [_amount setText:@""];
            
            [_noticeTransfer setSelected:YES];
            [_noticeDate setEnabled:YES];
            [_noticeTime setEnabled:YES];
            [_transferAmount setEnabled:YES];
            
            [self setTextFieldTagOrder:@[ _standardAmount, _rate, _amount, _transferAmount ]];
        }
            break;
            
        case 70: {
            
            // 통지 일자(매월)
            
            [self showPopupView:@"통지 일자" withOptions:_noticeDateList withTag:SMART_TRANSFER_LISTPOPUP_DATE];
        }
            break;
            
        case 80: {
            
            // 통지 시간
            
            [self showPopupView:@"통지 시간" withOptions:_noticeTimeList withTag:SMART_TRANSFER_LISTPOPUP_TIME];
        }
            break;
            
        case 90: {
            
            // 스마트이체 설정 설정
            
            [_incomeTransfer setEnabled:YES];
            [_noticeTransfer setEnabled:YES];
            
            [self buttonPressed:_incomeTransfer];
            [self buttonPressed:_rateBtn];
            
            [_smartTransferSet setSelected:YES];
            [_smartTransferCancel setSelected:NO];
        }
            break;
            
        case 100: {
            
            // 스마트이체 설정 해제
            
            [_incomeTransfer setEnabled:NO];
            [_standardAmount setEnabled:NO];
            [_rateBtn setEnabled:NO];
            [_rate setEnabled:NO];
            [_amountBtn setEnabled:NO];
            [_amount setEnabled:NO];
            
            [_noticeTransfer setEnabled:NO];
            [_noticeDate setEnabled:NO];
            [_noticeTime setEnabled:NO];
            [_transferAmount setEnabled:NO];
            
            [_smartTransferSet setSelected:NO];
            [_smartTransferCancel setSelected:YES];
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"『스마트이체』 설정을 해제하시면 『신한 저축습관만들기 적금』 의 주요 서비스인 『스마트이체』 알림(Push) 메시지는 제공되지 않습니다.\n단, 신한 저축습관 만들기 적금은 일반 적금과 동일하게 유지"];
        }
            break;
            
        case 1000: {
            
            // 등록/변경
            
            NSString *message = [self getErrorMessage];
            
            if ([message length] > 0) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:message];
                return;
            }
            
            if ([_smartTransferSet isSelected]) {
                
                // 등록/변경
                
                [self requestE5081];
            }
            else {
                
                // 취소
                
                [self requestE5083];
            }
        }
            break;
            
        case 2000: {
            
            // 취소
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [self.navigationController fadePopViewController];
            
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
    
    if ([self.service.strServiceCode isEqualToString:@"E5082"]) {
        
        NSDictionary *dataDic = nil;
        
        for (NSDictionary *dic in [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"]) {
            
            if ([dic[@"상품코드"] isEqualToString:@"230011831"]) {
                
                dataDic = dic;
                
                break;
            }
        }
        
        if (dataDic) {
            
            [aDataSet insertObject:[SHBUtility setAccountNumberMinus:dataDic[@"계좌번호"]]
                            forKey:@"_계좌번호"
                           atIndex:0];
            
            [aDataSet insertObject:[SHBUtility getDateWithDash:dataDic[@"신규일자"]]
                            forKey:@"_신규일"
                           atIndex:0];
            
            [aDataSet insertObject:[SHBUtility getDateWithDash:dataDic[@"만기일자"]]
                            forKey:@"_만기일"
                           atIndex:0];
        }
        else {
            
            [aDataSet insertObject:[SHBUtility setAccountNumberMinus:aDataSet[@"적금계좌번호"]]
                            forKey:@"_계좌번호"
                           atIndex:0];
            
            [aDataSet insertObject:[SHBUtility getDateWithDash:aDataSet[@"등록일자"]]
                            forKey:@"_신규일"
                           atIndex:0];
            
            [aDataSet insertObject:[SHBUtility getDateWithDash:aDataSet[@"적금만기일자"]]
                            forKey:@"_만기일"
                           atIndex:0];
        }
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if ([self.service.strServiceCode isEqualToString:@"E5082"]) {
        
        self.data = aDataSet;
        
        if ([aDataSet[@"상태구분"] isEqualToString:@"1"]) {
            
            // 등록
            
            [_smartTransferSet setSelected:YES];
            [_smartTransferCancel setSelected:NO];
            
            NSString *acc = [aDataSet[@"푸쉬계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            for (NSMutableDictionary *dic in _accountList) {
                
                NSString *oldAcc = [dic[@"구출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                NSString *newAcc = [dic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                if ([acc isEqualToString:oldAcc] || [acc isEqualToString:newAcc]) {
                    
                    self.selectAccountDic = dic;
                    [self setButton:_account withTitle:_selectAccountDic[@"2"]];
                    
                    break;
                }
            }
            
            if ([aDataSet[@"이체방식설정"] isEqualToString:@"1"]) {
                
                // 소득이체방식
                
                [self buttonPressed:_incomeTransfer];
                
                [_standardAmount setText:aDataSet[@"이체기준금액"]];
                
                if ([aDataSet[@"이체금액설정구분"] isEqualToString:@"1"]) {
                    
                    // 비율 설정(%)
                    
                    [self buttonPressed:_rateBtn];
                    
                    [_rate setText:aDataSet[@"이체비율"]];
                }
                else if ([aDataSet[@"이체금액설정구분"] isEqualToString:@"2"]) {
                    
                    // 금액 설정(원)
                    
                    [self buttonPressed:_amountBtn];
                    
                    [_amount setText:aDataSet[@"이체금액"]];
                }
            }
            else if ([aDataSet[@"이체방식설정"] isEqualToString:@"2"]) {
                
                // 알림이체방식
                
                [self buttonPressed:_noticeTransfer];
                
                for (NSMutableDictionary *dic in _noticeDateList) {
                    
                    if ([dic[@"CODE"] isEqualToString:aDataSet[@"통지일자"]]) {
                        
                        self.selectNoticeDateDic = dic;
                        
                        break;
                    }
                }
                
                [self setButton:_noticeDate withTitle:_selectNoticeDateDic[@"1"]];
                
                for (NSMutableDictionary *dic in _noticeTimeList) {
                    
                    if ([dic[@"CODE"] isEqualToString:aDataSet[@"통지시간"]]) {
                        
                        self.selectNoticeTimeDic = dic;
                        
                        break;
                    }
                }
                
                [self setButton:_noticeTime withTitle:_selectNoticeTimeDic[@"1"]];
                
                [_transferAmount setText:aDataSet[@"이체금액"]];
            }
        }
    }
    
    return YES;
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    switch ([listPopView tag]) {
            
        case SMART_TRANSFER_LISTPOPUP_ACCOUNT: {
            
            // 알림 계좌번호
            
            self.selectAccountDic = _accountList[anIndex];
            
            [self setButton:_account withTitle:_selectAccountDic[@"2"]];
        }
            break;
            
        case SMART_TRANSFER_LISTPOPUP_DATE: {
            
            // 통지 일자(매월)
            
            self.selectNoticeDateDic = _noticeDateList[anIndex];
            
            [self setButton:_noticeDate withTitle:_selectNoticeDateDic[@"1"]];
        }
            break;
            
        case SMART_TRANSFER_LISTPOPUP_TIME: {
            
            // 통지 시간
            
            self.selectNoticeTimeDic = _noticeTimeList[anIndex];
            
            [self setButton:_noticeTime withTitle:_selectNoticeTimeDic[@"1"]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    NSString *number = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _standardAmount || textField == _amount || textField == _transferAmount) {
        
        if ([number length] <= 14) {
            
            number = [number stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            [textField setText:[SHBUtility normalStringTocommaString:number]];
        }
        
        return NO;
    }
    else if (textField == _rate) {
        
        if ([number length] <= 3) {
            
            [textField setText:number];
        }
        
        return NO;
    }
    
    
    return YES;
}

@end
