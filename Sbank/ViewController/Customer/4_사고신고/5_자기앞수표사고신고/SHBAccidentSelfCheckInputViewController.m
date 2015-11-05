//
//  SHBAccidentSelfCheckInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentSelfCheckInputViewController.h"
#import "SHBCustomerService.h" // 서비스
#import "SHBUtility.h" // 유틸

#import "SHBListPopupView.h" // list popup
#import "SHBPopupView.h" // popup

#import "SHBAccidentSelfCheckCompleteViewController.h" // 자기앞수표 사고신고 완료

@interface SHBAccidentSelfCheckInputViewController ()
<SHBListPopupViewDelegate>

@property (retain, nonatomic) NSArray *textFieldList;
@property (retain, nonatomic) NSMutableArray *checkTypeList; // 수표종류
@property (retain, nonatomic) NSMutableDictionary *selectCheckTypeDic; // 선택된 수표종류

/// Notification 등록
- (void)initNotification;

/**
 숫자에 , 넣기
 @param number 변환할 숫자
 @param isPoint 소수점 필요 여부
 @return , 가 있는 숫자
 */
- (NSString *)addComma:(Float64)number isPoint:(BOOL)isPoint;

@end

@implementation SHBAccidentSelfCheckInputViewController

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
    
    [self initNotification];
    
    [self setTitle:@"사고신고"];
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    self.textFieldList = @[ _checkNumber, _branchCode, _checkMoney, _checkName, _phoneNumber, ];
    
    [self setTextFieldTagOrder:_textFieldList];
    
    self.checkTypeList = [NSMutableArray arrayWithArray:
                          @[
                          @{ @"1" : @"10만원권(13)", @"title" : @"10만원권", @"value" : @"100,000", @"code" : @"13", },
                          @{ @"1" : @"30만원권(14)", @"title" : @"30만원권", @"value" : @"300,000", @"code" : @"14", },
                          @{ @"1" : @"50만원권(15)", @"title" : @"50만원권", @"value" : @"500,000", @"code" : @"15", },
                          @{ @"1" : @"100만원권(16)", @"title" : @"100만원권", @"value" : @"1000,000", @"code" : @"16", },
                          @{ @"1" : @"일반수표(19)", @"title" : @"일반수표", @"value" : @"", @"code" : @"19", },
                          ]];
    
    self.selectCheckTypeDic = _checkTypeList[0];
    
    // 발행일
    [_dateField initFrame:_dateField.frame];
    [_dateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_dateField.textField setTextColor:RGB(44, 44, 44)];
    [_dateField.textField setTextAlignment:UITextAlignmentLeft];
    [_dateField setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.textFieldList = nil;
    self.checkTypeList = nil;
    self.selectCheckTypeDic = nil;
    
    [_mainView release];
    [_checkNumber release];
    [_branchCode release];
    [_dateField release];
    [_checkType release];
    [_checkMoney release];
    [_checkMoneyKor release];
    [_checkName release];
    [_phoneNumber release];
    [_helpView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setCheckNumber:nil];
    [self setBranchCode:nil];
    [self setDateField:nil];
    [self setCheckType:nil];
    [self setCheckMoney:nil];
    [self setCheckMoneyKor:nil];
    [self setCheckName:nil];
    [self setPhoneNumber:nil];
    [self setHelpView:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        AppInfo.commonDic = @{
                            @"_수표구분" : _selectCheckTypeDic[@"title"],
                            @"_수표번호" : _checkNumber.text,
                            @"_발행은행" : @"신한은행(88)",
                            @"_발행점지로코드" : _branchCode.text,
                            @"_수표금액" : [NSString stringWithFormat:@"%@원", _checkMoney.text],
                            @"_신청인성명" : _checkName.text,
                            @"_전화번호" : _phoneNumber.text,
                            };
        
        SHBAccidentSelfCheckCompleteViewController *viewController = [[[SHBAccidentSelfCheckCompleteViewController alloc] initWithNibName:@"SHBAccidentSelfCheckCompleteViewController" bundle:nil] autorelease];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)getElectronicSignCancel
{
    [self initNotification];
    
    [self.navigationController fadePopViewController];
    
    self.selectCheckTypeDic = _checkTypeList[0];
    
    [_checkType setTitle:_selectCheckTypeDic[@"title"] forState:UIControlStateNormal];
    
    [_checkNumber setText:@""];
    [_branchCode setText:@""];
    [_dateField.textField setText:@""];
    [_checkNumber setText:@""];
    [_checkMoney setText:@"100,000"];
    [_checkMoneyKor setText:@"십만 원"];
    [_checkName setText:@""];
    [_phoneNumber setText:@""];
}

#pragma mark -

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

/// 도움말
- (IBAction)helpBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    SHBPopupView *popupView = [[[SHBPopupView alloc] initWithTitle:@"도움말" subView:_helpView] autorelease];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 수표종류
- (IBAction)checkTypeBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"수표종류"
                                                                   options:_checkTypeList
                                                                   CellNib:@"SHBExchangePopupCell"
                                                                     CellH:32
                                                               CellDispCnt:5
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 예
- (IBAction)yesBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if ([_checkNumber.text length] != 8) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"수표번호 8자리를 입력하여 주십시오."];
        return;
    }
    
    if ([_branchCode.text length] != 6 && [_branchCode.text length] != 7) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"발행점 지로코드를 6~7자로 입력하여 주십시오."];
        return;
    }
    
    if ([_dateField.textField.text length] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"발행일을 선택하여 주십시오."];
        return;
    }
    
    if ([_checkMoney isEnabled] && [_checkMoney.text length] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"수표금액을 입력하여 주십시오."];
        return;
    }
    
    if ([_checkName.text length] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"신청인 성명을 입력하여 주십시오."];
        return;
    }
    
    if ([_phoneNumber.text length] < 9) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"신청인 전화번호를 9~12자 입력하여 주십시오."];
        return;
    }
    
    NSString *date = [_dateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"사고신고";
    
    AppInfo.electronicSignCode = CUSTOMER_E4161;
    AppInfo.electronicSignTitle = @"자기앞수표 사고신고";
    
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)수표번호: %@", _checkNumber.text]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)발행점지로코드: %@", _branchCode.text]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)수표종류: %@", _selectCheckTypeDic[@"title"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)수표금액: %@원", _checkMoney.text]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)전화번호: %@", _phoneNumber.text]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)발행일: %@", date]];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           //@"실명번호" : AppInfo.ssn,
                           //@"실명번호" : [AppInfo getPersonalPK],
                           @"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                           @"실명번호구분" : @"1",
                           @"업무구분" : @"10",
                           @"수표거래구분" : @"01",
                           @"수표어음사고사유CODE" : @"01",
                           @"매체CODE" : @"01",
                           @"수표권종구분" : _selectCheckTypeDic[@"code"],
                           @"수표시작번호" : _checkNumber.text,
                           @"수표금액" : _checkMoney.text,
                           @"은행구분" : @"88",
                           @"발행점지로코드" : _branchCode.text,
                           @"발행일자" : date,
                           @"신청인명" : _checkName.text,
                           @"신청인통신번호" : _phoneNumber.text,
                           @"수표종류" : _selectCheckTypeDic[@"title"],
                           }];
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_E4161
                                                     viewController:self] autorelease];
    self.service.requestData = dataSet;
    [self.service start];
}

/// 아니오
- (IBAction)noBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.curTextField resignFirstResponder];
    
    [self.navigationController fadePopViewController];
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
    NSString *number = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == _checkNumber) {
        if ([textField.text length] >= 8 && range.length == 0) {
            return NO;
        }
    }
    else if (textField == _branchCode) {
        if ([textField.text length] >= 7 && range.length == 0) {
            return NO;
        }
    }
    else if (textField == _checkMoney) {
        if ([number length] <= 14) {
            number = [number stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            [textField setText:[self addComma:[number doubleValue] isPoint:NO]];
        }
        
        return NO;
    }
    else if (textField == _checkName) {
        int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
        int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
        
        //특수문자 : ₩ $ £ ¥ • 은 입력 안됨
        NSString *SPECIAL_CHAR = @"$₩€£¥•";
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        
        if (basicTest && [string length] > 0 ) {
            return NO;
        }
        
        if (dataLength + dataLength2 > 20) {
            return NO;
        }
        
        return YES;
    }
    else if (textField == _phoneNumber) {
        if ([textField.text length] >= 12 && range.length == 0) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - SHBTextField

- (void)didCompleteButtonTouch
{
    if (self.curTextField == _checkMoney) {
        [_checkMoneyKor setText:[NSString stringWithFormat:@"%@ 원",
                                 [SHBUtility changeNumberStringToKoreaAmountString:_checkMoney.text]]];
    }
    
    [super didCompleteButtonTouch];
}

#pragma mark - SHBDateField

- (void)currentDateField:(SHBDateField *)dateField
{
    [self.curTextField resignFirstResponder];
    
    if ([_dateField.textField.text length] == 0) {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        
        [_dateField setDate:[dateFormatter dateFromString:AppInfo.tran_Date]];
    }
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.selectCheckTypeDic = _checkTypeList[anIndex];
    
    [_checkType setTitle:_selectCheckTypeDic[@"title"] forState:UIControlStateNormal];
    [_checkMoney setText:_selectCheckTypeDic[@"value"]];
    
    if ([_selectCheckTypeDic[@"value"] isEqualToString:@""]) {
        [_checkMoney setEnabled:YES];
        [_checkMoneyKor setText:@""];
    }
    else {
        [_checkMoney setEnabled:NO];
        [_checkMoneyKor setText:[NSString stringWithFormat:@"%@ 원",
                                 [SHBUtility changeNumberStringToKoreaAmountString:_checkMoney.text]]];
    }
    
    [self setTextFieldTagOrder:_textFieldList];
}

- (void)listPopupViewDidCancel
{
    
}

@end
