//
//  SHBForexRequestCouponInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexRequestCouponInputViewController.h"
#import "SHBExchangeService.h" // 서비스
#import "SHBUtility.h" // 유틸

#import "SHBListPopupView.h" // list popup
#import "SHBExchangePopupView.h" // list popup

#import "SHBForexRequestCouponInputCell.h" // 쿠폰조회 cell
#import "SHBForexRequestInputViewController.h" // 외화환전신청 정보입력(2)


@interface SHBForexRequestCouponInputViewController ()
<SHBListPopupViewDelegate>
{
    BOOL _isCouponBtn;
}

@property (retain, nonatomic) OFDataSet *dataSetF3780; // F3780
@property (retain, nonatomic) NSMutableArray *currencyList; // 환전통화
@property (retain, nonatomic) NSMutableArray *couponList; // 쿠폰
@property (retain, nonatomic) NSMutableDictionary *selectCurrencyDic; // 선택한 환전통화

@property (retain, nonatomic) SHBExchangePopupView *couponPopupView; // 쿠폰

/**
 숫자에 , 넣기
 @param number 변환할 숫자
 @param isPoint 소수점 필요 여부
 @return , 가 있는 숫자
 */
- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint;

/**
 통화금액 알럿
 @param currencyCode 통화코드
 @param money 금액
 @param currency 비교할 통화코드
 @param unit 단위
 */
- (BOOL)showAlertWithCurrencyCode:(NSString *)currencyCode
                            money:(SInt64)money
                         currency:(NSString *)currency
                             unit:(NSInteger)unit;

@end

@implementation SHBForexRequestCouponInputViewController

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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"forexRequestInputCancel" object:nil];
    
    // 외화환전신청 정보입력(2) 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(forexRequestInputCancel)
                                                 name:@"forexRequestInputCancel"
                                               object:nil];
    
    [self setTitle:@"외화환전신청"];
    self.strBackButtonTitle = @"외화환전신청 3단계";
    
    self.currencyList = [NSMutableArray arrayWithArray:
                         @[
                         @{ @"value" : @"미국달러", @"code" : @"USD", @"1" : @"미국달러(USD)", },
                         @{ @"value" : @"유럽유로", @"code" : @"EUR", @"1" : @"유럽유로(EUR)",  },
                         @{ @"value" : @"일본엔", @"code" : @"JPY", @"1" : @"일본엔(JPY)",  },
                         @{ @"value" : @"영국파운드", @"code" : @"GBP", @"1" : @"영국파운드(GBP)",  },
                         @{ @"value" : @"캐나다달러", @"code" : @"CAD", @"1" : @"캐나다달러(CAD)",  },
                         @{ @"value" : @"스위스프랑", @"code" : @"CHF", @"1" : @"스위스프랑(CHF)",  },
                         @{ @"value" : @"홍콩달러", @"code" : @"HKD", @"1" : @"홍콩달러(HKD)",  },
                         @{ @"value" : @"호주달러", @"code" : @"AUD", @"1" : @"호주달러(AUD)",  },
                         @{ @"value" : @"싱가폴달러", @"code" : @"SGD", @"1" : @"싱가폴달러(SGD)",  },
                         @{ @"value" : @"뉴질랜드달러", @"code" : @"NZD", @"1" : @"뉴질랜드달러(NZD)",  },
                         @{ @"value" : @"중국위안", @"code" : @"CNY", @"1" : @"중국위안(CNY)",  },
                         @{ @"value" : @"태국바트", @"code" : @"THB", @"1" : @"태국바트(THB)",  },
                         @{ @"value" : @"말레이지아링기트", @"code" : @"MYR", @"1" : @"말레이지아링기트(MYR)",  },
                         @{ @"value" : @"대만달러", @"code" : @"TWD", @"1" : @"대만달러(TWD)",  },
                         @{ @"value" : @"필리핀페소", @"code" : @"PHP", @"1" : @"필리핀페소(PHP)",  },
                         ]];
    self.couponList = [NSMutableArray array];
    self.selectCurrencyDic = [NSMutableDictionary dictionary];
    
    if(!self.isPushAndScheme) {
        if (_selectCouponDic) {
            if (_selectCouponDic[@"등록점"]) {
                [_selectCouponDic setObject:_selectCouponDic[@"등록점"]
                                     forKey:@"등록지점"];
            }
            
            if (_selectCouponDic[@"등록점명"]) {
                [_selectCouponDic setObject:_selectCouponDic[@"등록점명"]
                                     forKey:@"등록지점명"];
            }
            
            if (_selectCouponDic[@"일련번호"]) {
                [_selectCouponDic setObject:_selectCouponDic[@"일련번호"]
                                     forKey:@"쿠폰일련번호"];
            }
            
            [_coupon setText:[NSString stringWithFormat:@"%@%% 우대", _selectCouponDic[@"환전우대율"]]];
        }
        else {
            self.selectCouponDic = [NSMutableDictionary dictionary];
        }
        
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
        
        self.service = nil;
        self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F3780_SERVICE
                                                       viewController:self] autorelease];
        [self.service start];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"forexRequestInputCancel" object:nil];
    
    self.dataSetF3780 = nil;
    self.currencyList = nil;
    self.couponList = nil;
    self.selectCurrencyDic = nil;
    self.selectCouponDic = nil;
    
    self.couponPopupView = nil;
    
	[super dealloc];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

#pragma mark - Notification Center

- (void)forexRequestInputCancel
{
    self.selectCurrencyDic = [NSMutableDictionary dictionary];
    self.selectCouponDic = [NSMutableDictionary dictionary];
    
    [_currency setTitle:@"선택하세요" forState:UIControlStateNormal];
    [_money setText:@""];
    [_coupon setText:@""];
}

#pragma mark - Push

- (void)executeWithDic:(NSMutableDictionary *)mDic
{
	[super executeWithDic:mDic];
    
    if (mDic) {
        
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
        
        self.service = nil;
        self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_E2610_SERVICE
                                                       viewController:self] autorelease];
        [self.service start];
        
        self.data = mDic;
    }
}

#pragma mark -

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

- (BOOL)showAlertWithCurrencyCode:(NSString *)currencyCode
                            money:(SInt64)money
                         currency:(NSString *)currency
                             unit:(NSInteger)unit
{
    if ([currencyCode isEqualToString:currency] && money % unit != 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:[NSString stringWithFormat:@"%@ 환전금액은 %@이상, %@단위로 입력하시기 바랍니다.",
                                currency,
                                [self addComma:(Float64)unit isPoint:NO],
                                [self addComma:(Float64)unit isPoint:NO]]];
        return YES;
    }
    
    return NO;
}

#pragma mark - Button

/// 환전통화
- (IBAction)currencyBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"통화구분"
                                                                   options:_currencyList
                                                                   CellNib:@"SHBExchangePopupNoMoreCell"
                                                                     CellH:32
                                                               CellDispCnt:7
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 환율우대쿠폰
- (IBAction)couponBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if (![_selectCurrencyDic[@"code"] isEqualToString:@"USD"] &&
        ![_selectCurrencyDic[@"code"] isEqualToString:@"EUR"] &&
        ![_selectCurrencyDic[@"code"] isEqualToString:@"JPY"] &&
        (![_currency.titleLabel.text isEqualToString:@"선택하세요"] || [_currency.titleLabel.text length] != 0)) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"환율우대쿠폰은 USD,EUR,JPY만 환전 가능합니다."];
        
        return;
    }
    
    _isCouponBtn = YES;
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_E2610_SERVICE
                                                   viewController:self] autorelease];
    [self.service start];
}

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if ([_selectCurrencyDic[@"code"] length] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"환전통화를 선택하여 주십시오."];
        return;
    }
    
    SInt64 money = [[_money.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
    
    if (money == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"환전금액을 입력하여 주십시오."];
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"USD"
                                   unit:10]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"JPY"
                                   unit:1000]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"EUR"
                                   unit:10]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"GBP"
                                   unit:20]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"AUD"
                                   unit:20]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"NZD"
                                   unit:20]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"CAD"
                                   unit:20]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"HKD"
                                   unit:100]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"SGD"
                                   unit:10]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"CNY"
                                   unit:100]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"CHF"
                                   unit:100]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"MYR"
                                   unit:50]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"THB"
                                   unit:100]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"TWD"
                                   unit:100]) {
        return;
    }
    
    if ([self showAlertWithCurrencyCode:_selectCurrencyDic[@"code"]
                                  money:money
                               currency:@"PHP"
                                   unit:500]) {
        return;
    }
    
    for (NSDictionary *dic in [_dataSetF3780 arrayWithForKey:@"조회내역"])
    {
        if ([dic[@"통화코드"] isEqualToString:_selectCurrencyDic[@"code"]]) {
            
            NSInteger max = 50000;
            
            NSString *date = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSInteger time = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
            
            if (![SHBUtility isOPDate:date] || time < 90000 || time > 160000) {
                max = 5000;
            }
            
            // 통화코드가 JPY(엔화)인 경우에는 서버에서 대미환산율을 100으로 나눠서 내려줌
            Float64 checkValue = (Float64)money * [dic[@"대미환산율"] doubleValue];
            
            NSLog(@"%@", dic);
            NSLog(@"%@", dic[@"대미환산율"]);
            NSLog(@"%lld %lf", money, checkValue);
            
            // 영업시간내(09:00~16:00) : USD 300~50,000
            // 영업시간외 : USD 300~5,000
            if (checkValue < 300 || checkValue > max) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"모바일뱅킹 환전서비스 신청 가능한도는 영업시간내(09시 00분~16시 00분)에는 USD 300~50,000상당액이며, 영업시간외에는 USD 300~5,000상당액 입니다."];
                return;
            }
            
            break;
        }
    }
    
    AppInfo.commonDic = @{
                        @"_환전통화" : _selectCurrencyDic[@"code"],
                        @"_환전금액" : _money.text,
                        @"_쿠폰번호" : [SHBUtility nilToString:_selectCouponDic[@"일련번호"]],
                        @"_우대율" : [SHBUtility nilToString:_selectCouponDic[@"환전우대율"]],
                        @"_등록지점" : [SHBUtility nilToString:_selectCouponDic[@"등록지점명"]],
                        @"_지점번호" : [SHBUtility nilToString:_selectCouponDic[@"등록지점"]],
                        };
    
    SHBForexRequestInputViewController *viewController = [[[SHBForexRequestInputViewController alloc] initWithNibName:@"SHBForexRequestInputViewController" bundle:nil] autorelease];
    viewController.dataSetF3780 = _dataSetF3780;
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

/// 취소
- (IBAction)cancelBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.curTextField resignFirstResponder];
    
    [self.navigationController fadePopViewController];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    switch (self.service.serviceId) {
        case EXCHANGE_E2610_SERVICE:
        {
            for (NSMutableDictionary *dic in [aDataSet arrayWithForKey:@"쿠폰목록"]) {
                [dic setObject:@"대상통화 : USD,EUR,JPY"
                        forKey:@"_대상통화"];
                [dic setObject:[NSString stringWithFormat:@"우대율 : %@%%", dic[@"환전우대율"]]
                        forKey:@"_우대율"];
                [dic setObject:[NSString stringWithFormat:@"등록지점 : %@", dic[@"등록지점명"]]
                        forKey:@"_등록지점"];
                [dic setObject:[NSString stringWithFormat:@"유효기간 : %@", [SHBUtility getDateWithDash:dic[@"쿠폰유효일자"]]]
                        forKey:@"_유효기간"];
            }
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    switch (self.service.serviceId) {
        case EXCHANGE_E2610_SERVICE:
        {
            self.couponList = [aDataSet arrayWithForKey:@"쿠폰목록"];
            
            if ([_couponList count] == 0) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"쿠폰이 존재하지 않습니다."];
                return NO;
            }
            
            if (self.isPushAndScheme && !_isCouponBtn) {
                
                if ([self.data[@"couponCode"] length] > 0) {
                    
                    BOOL isCouponUse = YES;
                    
                    for (NSInteger i = 0; i < [_couponList count] ; i++) {
                        
                        if ([_couponList[i][@"일련번호"] integerValue] == [self.data[@"couponCode"] integerValue]) {
                            isCouponUse = NO;
                            
                            self.selectCouponDic = [NSMutableDictionary dictionaryWithDictionary:_couponList[i]];
                            
                            [_coupon setText:[NSString stringWithFormat:@"%@%% 우대", _selectCouponDic[@"환전우대율"]]];
                            
                            for (NSInteger j = 0; j < [_currencyList count]; j++) {
                                
                                if ([_currencyList[j][@"code"] isEqualToString:self.data[@"currencyCode"]]) {
                                    
                                    self.selectCurrencyDic = _currencyList[j];
                                    [_currency setTitle:_selectCurrencyDic[@"1"] forState:UIControlStateNormal];
                                    
                                    break;
                                }
                            }
                            
                            break;
                        }
                    }
                    
                    if (isCouponUse) {
                        
                        [UIAlertView showAlert:self
                                          type:ONFAlertTypeOneButton
                                           tag:3330
                                         title:@""
                                       message:@"이미 사용하신 쿠폰입니다."];
                        return NO;
                    }
                }
                
                self.service = nil;
                self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F3780_SERVICE
                                                               viewController:self] autorelease];
                [self.service start];
            }
            else {
                self.couponPopupView = [[[SHBExchangePopupView alloc] initWithTitle:@"환율우대쿠폰"
                                                                      SubViewHeight:274] autorelease];
                [_couponPopupView.tableView setDataSource:self];
                [_couponPopupView.tableView setDelegate:self];
                
                [_couponPopupView showInView:self.navigationController.view animated:YES];
            }
        }
            break;
        case EXCHANGE_F3780_SERVICE:
        {
            self.dataSetF3780 = aDataSet;
        }
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_couponList count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHBForexRequestCouponInputCell *cell = (SHBForexRequestCouponInputCell *)[tableView dequeueReusableCellWithIdentifier:@"SHBForexRequestCouponInputCell"];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SHBForexRequestCouponInputCell"
                                                       owner:self options:nil];
        cell = (SHBForexRequestCouponInputCell *)array[0];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    OFDataSet *cellDataSet = _couponList[indexPath.row];
    [self.binder bindForAnnotation:cell dataSet:cellDataSet depth:0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectCouponDic = _couponList[indexPath.row];
    
    [_couponPopupView close];
    [_coupon setText:[NSString stringWithFormat:@"%@%% 우대", _selectCouponDic[@"환전우대율"]]];
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    if (![_currencyList[anIndex][@"code"] isEqualToString:@"USD"] &&
        ![_currencyList[anIndex][@"code"] isEqualToString:@"EUR"] &&
        ![_currencyList[anIndex][@"code"] isEqualToString:@"JPY"] &&
        [_coupon.text length] > 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"환율우대쿠폰선택시 USD,EUR,JPY만 환전 가능합니다."];
        
        [self forexRequestInputCancel];
        
        return;
    }
    
    self.selectCurrencyDic = _currencyList[anIndex];
    
    [_currency setTitle:_selectCurrencyDic[@"1"] forState:UIControlStateNormal];
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    NSString *number = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _money) {
        if ([number length] <= 14) {
            number = [number stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            [textField setText:[self addComma:[number doubleValue] isPoint:NO]];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3330) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self.navigationController fadePopViewController];
    }
}

@end
