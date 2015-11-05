//
//  SHBForexRequestInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexRequestInputViewController.h"
#import "SHBExchangeService.h" // 서비스
#import "SHBUtility.h" // 유틸

#import "SHBSearchAccountViewController.h" // 출금계좌목록
#import "SHBForexRequestConfirmViewController.h" // 외화환전신청 확인

#import "SHBListPopupView.h" // list popup

/// list popup tag
enum FOREXREQUEST_LISTPOPUP_TAG {
    FOREXREQUEST_LISTPOPUP_PLACE1 = 1001,
    FOREXREQUEST_LISTPOPUP_PLACE2,
    FOREXREQUEST_LISTPOPUP_PLACE3,
    FOREXREQUEST_LISTPOPUP_ACCOUNTNUMBER
};

@interface SHBForexRequestInputViewController ()
<SHBListPopupViewDelegate>
{
    BOOL _isPlaceSelected; // 외화수령지점 선택여부
}

@property (retain, nonatomic) NSString *encriptedPassword; // 계좌비밀번호
@property (retain, nonatomic) NSMutableArray *placeList1; // 외화수령지점1
@property (retain, nonatomic) NSMutableArray *placeList2; // 외화수령지점2
@property (retain, nonatomic) NSMutableArray *placeList3; // 외화수령지점3
@property (retain, nonatomic) NSMutableArray *accountList; // 출금계좌
@property (retain, nonatomic) NSMutableDictionary *selectPlace1Dic; // 선택한 외화수령지점1
@property (retain, nonatomic) NSMutableDictionary *selectPlace2Dic; // 선택한 외화수령지점2
@property (retain, nonatomic) NSMutableDictionary *selectPlace3Dic; // 선택한 외화수령지점3
@property (retain, nonatomic) NSMutableDictionary *selectAccountDic; // 선택한 계좌
@property (retain, nonatomic) NSDictionary *placeInfoDic; // 외화수령지점 안내

/**
 숫자에 , 넣기
 @param number 변환할 숫자
 @param isPoint 소수점 필요 여부
 @return , 가 있는 숫자
 */
- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint;

/// 외화수령지점1 데이터 설정
- (void)setPlace1Data;

/// 외화수령지점 선택시 안내문구 추가
- (void)setPlaceInfoView:(NSString *)place;

@end

@implementation SHBForexRequestInputViewController

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
    
    // 서버통신 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serverError)
                                                 name:@"notiServerError"
                                               object:nil];
    
    [self setTitle:@"외화환전신청"];
    self.strBackButtonTitle = @"외화환전신청 4단계";
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    startTextFieldTag = 30300;
    endTextFieldTag = 30303;
    
    _isPlaceSelected = NO;
    
    self.encriptedPassword = @"";
    self.placeList1 = [NSMutableArray array];
    self.placeList2 = [NSMutableArray array];
    self.placeList3 = [NSMutableArray array];
    self.accountList = [NSMutableArray array];
    self.selectPlace1Dic = [NSMutableDictionary dictionary];
    self.selectPlace2Dic = [NSMutableDictionary dictionary];
    self.selectPlace3Dic = [NSMutableDictionary dictionary];
    self.selectAccountDic = [NSMutableDictionary dictionary];
    
    [self setPlace1Data];
    
    // 외화수령일
    [_dateField initFrame:_dateField.frame];
    [_dateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_dateField.textField setTextColor:RGB(44, 44, 44)];
    [_dateField.textField setTextAlignment:UITextAlignmentLeft];
    [_dateField.textField setAccessibilityLabel:@"외화수령일 입력창"];
    [_dateField setDelegate:self];
    
    // 계좌비밀번호
    [_passwd showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    
    // 출금계좌번호
    self.accountList = [self outAccountList];
    
    if ([_accountList count] != 0) {
        self.selectAccountDic = _accountList[0];
        
        [_accountNumber setTitle:_selectAccountDic[@"2"] forState:UIControlStateNormal];
    }
    else if ([_accountList count] == 0) {
        [_accountNumber setTitle:@"출금계좌정보가 없습니다." forState:UIControlStateNormal];
    }
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:AppInfo.commonDic];
    [self.binder bind:self dataSet:dataSet];
    
    if ([dataSet[@"_지점번호"] integerValue] >= 1100) {
        _isPlaceSelected = YES;
        
        self.selectPlace3Dic = [NSMutableDictionary dictionaryWithDictionary:
                                @{
                                @"지점번호" : dataSet[@"_지점번호"],
                                @"1" : dataSet[@"_등록지점"]
                                }];
        
        [_place1 setEnabled:NO];
        [_place2 setEnabled:NO];
        
        [_place3 setEnabled:NO];
        [_place3 setTitle:_selectPlace3Dic[@"1"] forState:UIControlStateNormal];
        [_place3 setTitleColor:RGB(44, 44, 44) forState:UIControlStateDisabled];
    }
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_TASK4_SERVICE viewController:self] autorelease];
    
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.dataSetF3780 = nil;
    self.encriptedPassword = nil;
    self.placeList1 = nil;
    self.placeList2 = nil;
    self.placeList3 = nil;
    self.accountList = nil;
    self.selectPlace1Dic = nil;
    self.selectPlace2Dic = nil;
    self.selectPlace3Dic = nil;
    self.selectAccountDic = nil;
    self.placeInfoDic = nil;
    
    [_tourPurposeBtn release];
    [_savePurposeBtn release];
    [_mainView release];
    [_balance release];
    [_dateField release];
    [_passwd release];
    [_phoneNumber1 release];
    [_phoneNumber2 release];
    [_phoneNumber3 release];
    [_place1 release];
    [_place2 release];
    [_place3 release];
    [_accountNumber release];
    [_placeInfo release];
    [_placeInfoDot release];
    [_placeInfoLabel release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setTourPurposeBtn:nil];
    [self setSavePurposeBtn:nil];
    [self setMainView:nil];
    [self setBalance:nil];
    [self setDateField:nil];
    [self setPasswd:nil];
    [self setPhoneNumber1:nil];
    [self setPhoneNumber2:nil];
    [self setPhoneNumber3:nil];
    [self setPlace1:nil];
    [self setPlace2:nil];
    [self setPlace3:nil];
    [self setAccountNumber:nil];
    [self setPlaceInfo:nil];
	[super viewDidUnload];
}

#pragma mark - Notification

- (void)serverError
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 서버통신 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(serverError)
                                                 name:@"notiServerError"
                                               object:nil];
    
    [_passwd setText:@""];
    self.encriptedPassword = @"";
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

- (void)setPlace1Data
{
    self.placeList1 = [NSMutableArray array];
    
    NSArray *nameArray = @[
                         @"인천국제공항", @"김포공항", @"본점영업부", @"광교영업부", @"강남역",
                         @"서울", @"부산", @"대구", @"인천", @"광주",
                         @"대전", @"울산", @"경기", @"강원", @"충북",
                         @"충남", @"전북", @"전남", @"경북", @"경남",
                         @"제주",
                         ];
        
    NSArray *codeArray = @[
                         @"7057", @"7020", @"1100", @"1101", @"5284",
                         @"708", @"709", @"710", @"711", @"712",
                         @"713", @"714", @"715", @"716", @"717",
                         @"718", @"719", @"720", @"721", @"722",
                         @"723",
                         ];
    
    NSInteger count = [nameArray count];
    
    if (![AppInfo.commonDic[@"_환전통화"] isEqualToString:@"USD"] &&
        ![AppInfo.commonDic[@"_환전통화"] isEqualToString:@"JPY"] &&
        ![AppInfo.commonDic[@"_환전통화"] isEqualToString:@"EUR"] &&
        ![AppInfo.commonDic[@"_환전통화"] isEqualToString:@"CNY"]) {
        count = 5;
    }
    
    for (NSInteger i = 0; i < count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:
                                    @{
                                    @"1" : nameArray[i],
                                    @"code" : codeArray[i],
                                    }];
        
        [_placeList1 addObject:dic];
    }
}

- (void)setPlaceInfoView:(NSString *)place
{
    [_placeInfo removeFromSuperview];
    
    NSString *message = @"";
    
    if ([place length] == 0) {
        
        message = @"";
    }
    else if ([place isEqualToString:@"7057"]) {
        
        message = @"메시지1";
    }
    else if ([place isEqualToString:@"7020"]) {
        
        message = @"메시지2";
    }
    else {
        
        message = @"메시지3";
    }
    
    if ([message length] == 0 || [_placeInfoDic[message] length] == 0) {
        
        FrameResize(_mainView, _mainView.frame.size.width, 506);
    }
    else {
        
        [_placeInfoLabel setText:_placeInfoDic[message]];
        
        CGSize labelSize = [_placeInfoLabel.text sizeWithFont:_placeInfoLabel.font
                                            constrainedToSize:CGSizeMake(width(_placeInfoLabel), 999)
                                                lineBreakMode:_placeInfoLabel.lineBreakMode];
        
        if (labelSize.height > 20) {
            
            FrameReposition(_placeInfoDot, 8, 6);
        }
        else {
            
            FrameReposition(_placeInfoDot, 8, 5);
        }
        
        FrameResize(_placeInfoLabel, width(_placeInfoLabel), labelSize.height + 2);
        
        FrameReposition(_placeInfo, 0, 217);
        FrameResize(_placeInfo, width(_placeInfo), top(_placeInfoLabel) + height(_placeInfoLabel) + 10);
        
        FrameResize(_mainView, _mainView.frame.size.width, 506 + height(_placeInfo));
        
        [_mainView addSubview:_placeInfo];
    }
    
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
}

#pragma mark - Button

/// 외화수령지점1
- (IBAction)placeBtn1:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    NSString *title = @"기본지점 및 지역";
    
    if ([_placeList1 count] == 5) {
        title = @"기본지점";
    }
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:title
                                                                   options:_placeList1
                                                                   CellNib:@"SHBExchangePopupNoMoreCell"
                                                                     CellH:32
                                                               CellDispCnt:7
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView setTag:FOREXREQUEST_LISTPOPUP_PLACE1];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 외화수령지점2
- (IBAction)placeBtn2:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKCommon",
                            TASK_ACTION_KEY : @"getCityList",
                            @"지역코드" : _selectPlace1Dic[@"code"],
                            }];
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_TASK2_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

/// 외화수령지점3
- (IBAction)placeBtn3:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKCommon",
                            TASK_ACTION_KEY : @"getCityByExBranch",
                            @"시도명" : _selectPlace1Dic[@"1"],
                            @"시군구명" : _selectPlace2Dic[@"1"],
                            }];
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_TASK3_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

/// 환전목적
- (IBAction)purposeBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if (sender == _tourPurposeBtn) {
        [_tourPurposeBtn setSelected:YES];
        [_savePurposeBtn setSelected:NO];
    }
    else if (sender == _savePurposeBtn) {
        [_tourPurposeBtn setSelected:NO];
        [_savePurposeBtn setSelected:YES];
    }
}

/// 출금계좌번호
- (IBAction)accountBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    self.accountList = [self outAccountList];
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"출금계좌"
                                                                   options:_accountList
                                                                   CellNib:@"SHBAccountListPopupCell"
                                                                     CellH:50
                                                               CellDispCnt:5
                                                                CellOptCnt:2] autorelease];
    [popupView setDelegate:self];
    [popupView setTag:FOREXREQUEST_LISTPOPUP_ACCOUNTNUMBER];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 잔액조회
- (IBAction)balanceBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if ([_accountNumber.titleLabel.text length] == 0 ||
        [_accountNumber.titleLabel.text isEqualToString:@"선택하세요"]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"출금계좌번호를 선택해 주세요."];
        
        return;
    }
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"출금계좌번호" : _accountNumber.titleLabel.text,
                            }];
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_D2004_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

/// 계좌비밀번호
- (IBAction)closeNormalPad:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [_passwd becomeFirstResponder];
}

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if (!_isPlaceSelected) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"외화수령지점을 선택하여 주십시오."];
        return;
    }
    
    NSString *exchangeDate = [_dateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ([exchangeDate length] == 0 || [exchangeDate length] != 8) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"외화수령일을 선택하여 주십시오."];
        return;
    }
    
    NSString *tranDate = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *nextDate = [[SHBUtility dateStringToMonth:1 toDay:0] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ([exchangeDate integerValue] > [nextDate integerValue] ||
        [exchangeDate integerValue] <= [tranDate integerValue]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"외화수령일은 신청일 다음날부터 1개월 이내의 기간까지 가능합니다."];
        return;
    }
    
    if (![_place1.titleLabel.text isEqualToString:@"인천국제공항"] &&
        ![_place1.titleLabel.text isEqualToString:@"김포공항"] &&
        ![SHBUtility isOPDate:exchangeDate]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"외화수령지점이 영업점인 경우 외화수령일은 토,일요일,휴일로 불가합니다. 다시 선택하여 주십시오."];
        return;
    }
    
    if ([_passwd.text length] != 4) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"계좌비밀번호를 입력하여 주십시오."];
        return;
    }
    
    if ([_phoneNumber1.text length] == 0 && [_phoneNumber2.text length] == 0 && [_phoneNumber3.text length] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"연락전화번호를 입력하여 주십시오."];
        return;
    }
    
    if ([_phoneNumber1.text length] < 2) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"연락전화번호 첫번째 입력칸은 2자리 이상 입력하여 주십시오."];
        return;
    }
    
    if ([_phoneNumber2.text length] < 3) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"연락전화번호 두번째 입력칸은 3자리 이상 입력하여 주십시오."];
        return;
    }
    
    if ([_phoneNumber3.text length] != 4) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"연락전화번호 세번째 입력칸은 4자리를 입력하여 주십시오."];
        return;
    }
    
    NSString *phoneNumber = [NSString stringWithFormat:@"%@%@%@",
                             _phoneNumber1.text, _phoneNumber2.text, _phoneNumber3.text];
    
    if (![SHBUtility isPhoneNumberCheck:phoneNumber]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"잘못된 전화번호 형식입니다. 확인 후 다시 입력하여 주십시오."];
        return;
    }
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                            @"출금계좌번호" : _accountNumber.titleLabel.text,
                            @"출금계좌비밀번호" : _encriptedPassword,
                            }];
    
    self.service = nil;
    self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_C2092_SERVICE
                                                   viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

/// 취소
- (IBAction)cancelBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    [self.navigationController fadePopViewController];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"forexRequestInputCancel"
                                                        object:nil];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    switch (self.service.serviceId) {
        case EXCHANGE_TASK4_SERVICE:
        {
            
        }
            break;
        case EXCHANGE_TASK2_SERVICE:
        {
            for (NSMutableDictionary *dic in [aDataSet arrayWithForKeyPath:@"data"]) {
                [dic setObject:dic[@"시군구명"]
                        forKey:@"1"];
            }
        }
            break;
        case EXCHANGE_TASK3_SERVICE:
        {
            for (NSMutableDictionary *dic in [aDataSet arrayWithForKeyPath:@"data"]) {
                [dic setObject:dic[@"지점명"]
                        forKey:@"1"];
            }
        }
            break;
        case EXCHANGE_C2092_SERVICE:
        {
            
        }
            break;
        case EXCHANGE_F3511_SERVICE:
        {
            [aDataSet insertObject:AppInfo.commonDic[@"_환전통화"]
                            forKey:@"_환전통화"
                           atIndex:0];
            [aDataSet insertObject:AppInfo.commonDic[@"_환전금액"]
                            forKey:@"_환전금액"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@원", self.service.requestData[@"현재환율1"]]
                            forKey:@"_현재고시환율"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@원",
                                    [self addComma:[aDataSet[@"고객환율->originalValue"] doubleValue] isPoint:YES]]
                            forKey:@"_우대적용환율"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@",
                                    [self addComma:[aDataSet[@"고객환율->originalValue"] doubleValue] isPoint:YES]]
                            forKey:@"_적용환율"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@%%", aDataSet[@"환율우대율1"]]
                            forKey:@"_우대율"
                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@원", aDataSet[@"원화환산금액"]]
                            forKey:@"_원화금액"
                           atIndex:0];
            [aDataSet insertObject:_selectAccountDic[@"2"]
                            forKey:@"_출금계좌번호"
                           atIndex:0];
            
            if ([_placeList1 count] == 5) {
                [aDataSet insertObject:_selectPlace1Dic[@"1"]
                                forKey:@"_외화수령지점"
                               atIndex:0];
            }
            else {
                if (!_selectPlace3Dic[@"1"]) {
                    [aDataSet insertObject:_selectPlace1Dic[@"1"]
                                    forKey:@"_외화수령지점"
                                   atIndex:0];
                }
                else {
                    [aDataSet insertObject:_selectPlace3Dic[@"1"]
                                    forKey:@"_외화수령지점"
                                   atIndex:0];
                }
            }
            
            [aDataSet insertObject:_dateField.textField.text
                            forKey:@"_외화수령일"
                           atIndex:0];
            [aDataSet insertObject:([_tourPurposeBtn isSelected]) ? @"여행비용" : @"외화보유"
                            forKey:@"_환전목적"
                           atIndex:0];
//            [aDataSet insertObject:[NSString stringWithFormat:@"%@-*******", [AppInfo.ssn substringToIndex:6]]
//                            forKey:@"_주민등록번호"
//                           atIndex:0];
            [aDataSet insertObject:[NSString stringWithFormat:@"%@-*******", [[AppInfo getPersonalPK] substringToIndex:6]]
                                        forKey:@"_주민등록번호"
                                       atIndex:0];
            
            [aDataSet insertObject:AppInfo.userInfo[@"고객성명"]
                            forKey:@"_수령인성명"
                           atIndex:0];
            
            NSString *phoneNumber = [NSString stringWithFormat:@"%@%@%@",
                                     _phoneNumber1.text, _phoneNumber2.text, _phoneNumber3.text];
            
            [aDataSet insertObject:phoneNumber
                            forKey:@"_연락전화번호"
                           atIndex:0];
            [aDataSet insertObject:([AppInfo.commonDic[@"_쿠폰번호"] length] > 0) ? @"환율우대쿠폰" : @"환전수수료 기본 환율우대"
                            forKey:@"_우대서비스"
                           atIndex:0];
            [aDataSet insertObject:AppInfo.commonDic[@"_쿠폰번호"]
                            forKey:@"_쿠폰번호"
                           atIndex:0];
        }
            break;
        default:
            break;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    Debug(@"%@", aDataSet);
    
    switch (self.service.serviceId) {
        case EXCHANGE_TASK4_SERVICE:
        {
            self.placeInfoDic = [NSDictionary dictionaryWithDictionary:aDataSet];
            
            if (_isPlaceSelected) {
                
                [self setPlaceInfoView:_selectPlace1Dic[@"code"]];
            }
        }
            break;
        case EXCHANGE_TASK2_SERVICE:
        {
            self.placeList2 = [aDataSet arrayWithForKeyPath:@"data"];
            
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"시/군/구"
                                                                           options:_placeList2
                                                                           CellNib:@"SHBExchangePopupCell"
                                                                             CellH:32
                                                                       CellDispCnt:7
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView setTag:FOREXREQUEST_LISTPOPUP_PLACE2];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case EXCHANGE_TASK3_SERVICE:
        {
            self.placeList3 = [aDataSet arrayWithForKeyPath:@"data"];
            
            if ([_placeList3 count] == 0) {
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"해당지역엔 외화수령이 가능한 영업점이 없습니다."];
                return NO;
            }
            
            SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"지점"
                                                                           options:_placeList3
                                                                           CellNib:@"SHBExchangePopupCell"
                                                                             CellH:32
                                                                       CellDispCnt:7
                                                                        CellOptCnt:1] autorelease];
            [popupView setDelegate:self];
            [popupView setTag:FOREXREQUEST_LISTPOPUP_PLACE3];
            [popupView showInView:self.navigationController.view animated:YES];
        }
            break;
        case EXCHANGE_D2004_SERVICE:
        {
            if ([aDataSet[@"COM_RESULT_CD"] isEqualToString:@"0"]) {
                [_balance setText:[NSString stringWithFormat:@"출금가능잔액 %@원", aDataSet[@"지불가능잔액"]]];
            }
        }
            break;
        case EXCHANGE_E2610_SERVICE:
        {
            
        }
            break;
        case EXCHANGE_C2092_SERVICE:
        {
            NSString *exchangeDate = [_dateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
            SInt64 money = [[AppInfo.commonDic[@"_환전금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
            NSString *phoneNumber = [NSString stringWithFormat:@"%@%@%@",
                                    _phoneNumber1.text, _phoneNumber2.text, _phoneNumber3.text];
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    @"결제원화계좌" : _selectAccountDic[@"2"],
                                    //@"주민등록번호" : AppInfo.ssn,
                                    //@"주민등록번호" : [AppInfo getPersonalPK],
                                    @"주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                    @"거래자성명" : AppInfo.userInfo[@"고객성명"],
                                    @"환전통화_1" : AppInfo.commonDic[@"_환전통화"],
                                    @"환전금액_1" : [NSString stringWithFormat:@"%lld", money],
                                    @"환전목적" : ([_tourPurposeBtn isSelected]) ? @"1" : @"2",
                                    @"출국일자" : exchangeDate,
                                    @"원화비밀번호" : _encriptedPassword,
                                    @"연락전화번호" : phoneNumber,
                                    //@"수령인주민번호" : AppInfo.ssn,
                                    //@"수령인주민번호" : [AppInfo getPersonalPK],
                                    @"수령인주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                    @"수령인성명" : AppInfo.userInfo[@"고객성명"],
                                    @"환전구분" : @"1",
                                    @"우대서비스구분" : @"0",
                                    @"환율적용구분" : ([AppInfo.commonDic[@"_쿠폰번호"] length] != 0) ? @"7" : @"1",
                                    }];
            
            if ([_selectAccountDic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                [aDataSet insertObject:@"1"
                                forKey:@"원화구은행구분"
                               atIndex:0];
            }
            else {
                [aDataSet insertObject:_selectAccountDic[@"은행코드"]
                                forKey:@"원화구은행구분"
                               atIndex:0];
            }
            
            if ([_placeList1 count] == 5) {
                [aDataSet insertObject:_selectPlace1Dic[@"code"]
                                forKey:@"수령점번호"
                               atIndex:0];
            }
            else {
                if (!_selectPlace3Dic[@"지점번호"]) {
                    [aDataSet insertObject:_selectPlace1Dic[@"code"]
                                    forKey:@"수령점번호"
                                   atIndex:0];
                }
                else {
                    [aDataSet insertObject:_selectPlace3Dic[@"지점번호"]
                                    forKey:@"수령점번호"
                                   atIndex:0];
                }
            }
            
            for(NSDictionary *dic in [_dataSetF3780 arrayWithForKey:@"조회내역"])
            {
                if (([dic[@"통화코드"] isEqualToString:@"USD"] ||
                     [dic[@"통화코드"] isEqualToString:@"JPY"] ||
                     [dic[@"통화코드"] isEqualToString:@"EUR"]) &&
                    [dic[@"통화코드"] isEqualToString:AppInfo.commonDic[@"_환전통화"]]) {
                    if ([AppInfo.commonDic[@"_우대율"] length] > 0) {
                        NSString *keyValue = [NSString stringWithFormat:@"지폐우대매도율%@", AppInfo.commonDic[@"_우대율"]];
                        
                        [aDataSet insertObject:dic[keyValue]
                                        forKey:@"고객환율"
                                       atIndex:0];
                        [aDataSet insertObject:dic[keyValue]
                                        forKey:@"거래환율1"
                                       atIndex:0];
                    }
                    else {
                        [aDataSet insertObject:dic[@"지폐우대매도율50"]
                                        forKey:@"고객환율"
                                       atIndex:0];
                        [aDataSet insertObject:dic[@"지폐우대매도율50"]
                                        forKey:@"거래환율1"
                                       atIndex:0];
                    }
                    
                    [aDataSet insertObject:dic[@"지폐매도율"]
                                    forKey:@"현재환율1"
                                   atIndex:0];
                    
                    break;
                }
                else if (([dic[@"통화코드"] isEqualToString:@"GBP"] ||
                          [dic[@"통화코드"] isEqualToString:@"CAD"] ||
                          [dic[@"통화코드"] isEqualToString:@"CHF"] ||
                          [dic[@"통화코드"] isEqualToString:@"HKD"] ||
                          [dic[@"통화코드"] isEqualToString:@"AUD"] ||
                          [dic[@"통화코드"] isEqualToString:@"SGD"] ||
                          [dic[@"통화코드"] isEqualToString:@"NZD"]) &&
                         [dic[@"통화코드"] isEqualToString:AppInfo.commonDic[@"_환전통화"]]) {
                    [aDataSet insertObject:dic[@"지폐우대매도율30"]
                                    forKey:@"고객환율"
                                   atIndex:0];
                    [aDataSet insertObject:dic[@"지폐우대매도율30"]
                                    forKey:@"거래환율1"
                                   atIndex:0];
                    [aDataSet insertObject:dic[@"지폐매도율"]
                                    forKey:@"현재환율1"
                                   atIndex:0];
                    break;
                }
                else if (([dic[@"통화코드"] isEqualToString:@"CNY"] ||
                          [dic[@"통화코드"] isEqualToString:@"THB"] ||
                          [dic[@"통화코드"] isEqualToString:@"MYR"]) &&
                         [dic[@"통화코드"] isEqualToString:AppInfo.commonDic[@"_환전통화"]]) {
                    [aDataSet insertObject:dic[@"지폐우대매도율20"]
                                    forKey:@"고객환율"
                                   atIndex:0];
                    [aDataSet insertObject:dic[@"지폐우대매도율20"]
                                    forKey:@"거래환율1"
                                   atIndex:0];
                    [aDataSet insertObject:dic[@"지폐매도율"]
                                    forKey:@"현재환율1"
                                   atIndex:0];
                    break;
                }
                else if ([dic[@"통화코드"] isEqualToString:AppInfo.commonDic[@"_환전통화"]]) {
                    [aDataSet insertObject:dic[@"지폐매도율"]
                                    forKey:@"고객환율"
                                   atIndex:0];
                    [aDataSet insertObject:dic[@"지폐매도율"]
                                    forKey:@"거래환율1"
                                   atIndex:0];
                    [aDataSet insertObject:dic[@"지폐매도율"]
                                    forKey:@"현재환율1"
                                   atIndex:0];
                    break;
                }
            }
            
            if ([AppInfo.commonDic[@"_환전통화"] isEqualToString:@"EUR"]) {
                [aDataSet insertObject:@"FR"
                                forKey:@"여행국가_1"
                               atIndex:0];
            }
            else {
                [aDataSet insertObject:[AppInfo.commonDic[@"_환전통화"] substringToIndex:2]
                                forKey:@"여행국가_1"
                               atIndex:0];
            }
            
            self.service = nil;
            self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F3511_SERVICE
                                                           viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
        case EXCHANGE_F3511_SERVICE:
        {
            [_passwd setText:@""];
            self.encriptedPassword = @"";
            
            SHBForexRequestConfirmViewController *viewController = [[[SHBForexRequestConfirmViewController alloc] initWithNibName:@"SHBForexRequestConfirmViewController" bundle:nil] autorelease];
            [viewController setExchangeDataInfo:aDataSet];
            [self checkLoginBeforePushViewController:viewController animated:YES];
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
    switch ([listPopView tag]) {
        case FOREXREQUEST_LISTPOPUP_PLACE1:
        {
            self.selectPlace2Dic = [NSMutableDictionary dictionary];
            self.selectPlace3Dic = [NSMutableDictionary dictionary];
            
            self.selectPlace1Dic = _placeList1[anIndex];
            [_place1 setTitle:_selectPlace1Dic[@"1"] forState:UIControlStateNormal];
            
            [self setPlaceInfoView:_selectPlace1Dic[@"code"]];
            
            if (anIndex > 4) {
                _isPlaceSelected = NO;
                
                [_place2 setEnabled:YES];
                [_place2 setTitle:@"시/군/구 선택" forState:UIControlStateNormal];
            }
            else {
                _isPlaceSelected = YES;
                
                [_place2 setEnabled:NO];
                [_place2 setTitle:@"시/군/구 선택" forState:UIControlStateNormal];
                
                [_place3 setEnabled:NO];
                [_place3 setTitle:@"지점선택" forState:UIControlStateNormal];
            }
        }
            break;
        case FOREXREQUEST_LISTPOPUP_PLACE2:
        {
            self.selectPlace2Dic = _placeList2[anIndex];
            [_place2 setTitle:_selectPlace2Dic[@"1"] forState:UIControlStateNormal];
            
            [_place3 setEnabled:YES];
            [_place3 setTitle:@"지점선택" forState:UIControlStateNormal];
            
            [self setPlaceInfoView:_selectPlace2Dic[@"1"]];
        }
            break;
        case FOREXREQUEST_LISTPOPUP_PLACE3:
        {
            _isPlaceSelected = YES;
            
            self.selectPlace3Dic = _placeList3[anIndex];
            [_place3 setTitle:_selectPlace3Dic[@"1"] forState:UIControlStateNormal];
            
            [self setPlaceInfoView:_selectPlace3Dic[@"지점번호"]];
        }
            break;
        case FOREXREQUEST_LISTPOPUP_ACCOUNTNUMBER:
        {
            self.selectAccountDic = _accountList[anIndex];
            
            [_accountNumber setTitle:_selectAccountDic[@"2"] forState:UIControlStateNormal];
            [_balance setText:@""];
            
            [_passwd setText:@""];
            self.encriptedPassword = @"";
            
        }
            break;
        default:
            break;
    }
}

- (void)listPopupViewDidCancel
{
    
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    if (textField == _phoneNumber1 || textField == _phoneNumber2 || textField == _phoneNumber3) {
        if ([textField.text length] >= 4 && range.length == 0) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - SHBSecureTextField

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    self.encriptedPassword = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
    
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
}

#pragma mark - SHBDateField

- (void)currentDateField:(SHBDateField *)dateField
{
    [self.curTextField resignFirstResponder];
    
    if ([_dateField.textField.text length] == 0) {
        NSString *nextDate = [SHBUtility dateStringToMonth:0 toDay:1];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        
        [_dateField setDate:[dateFormatter dateFromString:nextDate]];
    }
}

@end
