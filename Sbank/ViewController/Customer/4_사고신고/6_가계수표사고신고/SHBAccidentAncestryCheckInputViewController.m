//
//  SHBAccidentAncestryCheckInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccidentAncestryCheckInputViewController.h"
#import "SHBCustomerService.h" // 서비스
#import "SHBUtility.h" // 유틸

#import "SHBListPopupView.h" // list popup

#import "SHBAccidentAncestryCompleteViewController.h" // 가계수표 사고신고 완료

@interface SHBAccidentAncestryCheckInputViewController ()
<SHBListPopupViewDelegate>

@property (retain, nonatomic) NSMutableArray *bankList; // 발행은행
@property (retain, nonatomic) NSMutableDictionary *selectBankDic; // 선택된 발행은행

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

@implementation SHBAccidentAncestryCheckInputViewController

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
    startTextFieldTag = 30300;
    endTextFieldTag = 30302;
    
    self.bankList = [NSMutableArray arrayWithArray:
                     @[
                     @{ @"1" : @"신한은행(88)", @"code" : @"88", },
                     @{ @"1" : @"구 조흥은행(21)", @"code" : @"21", },
                     @{ @"1" : @"구 신한은행(26)", @"code" : @"26", },
                     ]];
    
    self.selectBankDic = _bankList[0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_mainView release];
    [_accountNumber release];
    [_bank release];
    [_checkNumber release];
    [_checkMoney release];
    [_checkMoneyKor release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setAccountNumber:nil];
    [self setBank:nil];
    [self setCheckNumber:nil];
    [self setCheckMoney:nil];
    [self setCheckMoneyKor:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        AppInfo.commonDic = @{
                            @"_계좌번호" : _accountNumber.text,
                            @"_수표번호" : _checkNumber.text,
                            @"_사고종류" : @"분실도난",
                            @"_수표금액" : [NSString stringWithFormat:@"%@원", _checkMoney.text],
                            };
        
        SHBAccidentAncestryCompleteViewController *viewController = [[[SHBAccidentAncestryCompleteViewController alloc] initWithNibName:@"SHBAccidentAncestryCompleteViewController" bundle:nil] autorelease];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)getElectronicSignCancel
{
    [self initNotification];
    
    [self.navigationController fadePopViewController];
    
    self.selectBankDic = _bankList[0];
    
    [_bank setTitle:_selectBankDic[@"1"] forState:UIControlStateNormal];
    
    [_accountNumber setText:@""];
    [_checkNumber setText:@""];
    [_checkMoney setText:@""];
    [_checkMoneyKor setText:@""];
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

/// 발행은행
- (IBAction)bankBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"발행은행"
                                                                   options:_bankList
                                                                   CellNib:@"SHBExchangePopupCell"
                                                                     CellH:32
                                                               CellDispCnt:3
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 예
- (IBAction)yesBtn:(UIButton *)sender
{
    [self.curTextField resignFirstResponder];
    
    if ([_accountNumber.text length] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"계좌번호를 입력하여 주십시오."];
        return;
    }
    
    if ([_checkNumber.text length] != 8) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"수표번호 8자리를 입력하여 주십시오."];
        return;
    }
    
    if ([_checkMoney.text length] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"수표금액을 입력하여 주십시오."];
        return;
    }
    
    AppInfo.electronicSignString = @"";
    AppInfo.eSignNVBarTitle = @"사고신고";
    
    AppInfo.electronicSignCode = CUSTOMER_E4151;
    AppInfo.electronicSignTitle = @"가계수표 사고신고";
    
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)계좌번호: %@", _accountNumber.text]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)발행은행: %@", _selectBankDic[@"1"]]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)수표번호: %@", _checkNumber.text]];
    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)수표금액: %@원", _checkMoney.text]];
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"예금계좌번호" : _accountNumber.text,
                           @"은행구분" : [_selectBankDic[@"code"] isEqualToString:@"88"] ? @"1" : @"2",
                           @"업무구분" : @"2",
                           @"등록구분" : @"1",
                           @"사고종류" : @"1",
                           @"반복횟수" : @"00001",
                           @"종류" : @"03",
                           @"수표번호" : _checkNumber.text,
                           @"수표금액" : _checkMoney.text,
                           @"수수료징수구분" : @"2",
                           @"영수증발급" : @"1",
                           @"수수료우대방법" : @"02",
                           @"증명원발급여부" : @"0",
                           @"사고접수내용" : @"2",
                           }];
    
    self.service = nil;
    self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_E4151
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
    
    if (textField == _accountNumber) {
        if ([textField.text length] >= 12 && range.length == 0) {
            return NO;
        }
    }
    else if (textField == _checkNumber) {
        if ([textField.text length] >= 8 && range.length == 0) {
            return NO;
        }
    }
    else if (textField == _checkMoney) {
        NSString *number = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([number length] <= 14) {
            number = [number stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            [textField setText:[self addComma:[number doubleValue] isPoint:NO]];
        }
        
        return NO;
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

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.selectBankDic = _bankList[anIndex];
    
    [_bank setTitle:_selectBankDic[@"1"] forState:UIControlStateNormal];
}

- (void)listPopupViewDidCancel
{
    
}

@end
