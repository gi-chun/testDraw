//
//  SHBCardAcknowledgmentInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCardAcknowledgmentInputViewController.h"
#import "SHBUtility.h" // 유틸
#import "SHBCardService.h" // 서비스

#import "SHBListPopupView.h" // list popup

#import "SHBCardAcknowledgmentDetailViewController.h" // 승인내역조회 완료

enum CARDUSEINPUT_PEROIDBTN {
    CARDUSEINPUT_ONEWEEK = 100,
    CARDUSEINPUT_ONEMONTH
};

@interface SHBCardAcknowledgmentInputViewController ()
<SHBListPopupViewDelegate>

@property (retain, nonatomic) NSMutableDictionary *selectCardDic; // 선택한 카드번호
@property (retain, nonatomic) NSDate *tempStartDate; // 기간선택 종료 임시
@property (retain, nonatomic) NSDate *tempEndDate; // 기간선택 종료 임시

@end

@implementation SHBCardAcknowledgmentInputViewController

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
    
    [self setTitle:@"승인내역조회"];
    self.strBackButtonTitle = @"승인내역조회 정보입력";
    
    self.selectCardDic = [NSMutableDictionary dictionary];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    // 기간지정 시작
    [_startDateField initFrame:_startDateField.frame];
    [_startDateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_startDateField.textField setTextColor:RGB(44, 44, 44)];
    [_startDateField.textField setTextAlignment:UITextAlignmentLeft];
    [_startDateField setDelegate:self];
    [_startDateField setmaximumDate:[dateFormatter dateFromString:AppInfo.tran_Date]];
    [_startDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:-1 toDay:0]] animated:NO];
    
    // 기간지정 종료
    [_endDateField initFrame:_endDateField.frame];
    [_endDateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_endDateField.textField setTextColor:RGB(44, 44, 44)];
    [_endDateField.textField setTextAlignment:UITextAlignmentLeft];
    [_endDateField setDelegate:self];
    [_endDateField setmaximumDate:[dateFormatter dateFromString:AppInfo.tran_Date]];
    [_endDateField selectDate:[dateFormatter dateFromString:AppInfo.tran_Date] animated:NO];
    
    // 카드가 1개인 경우
    if ([AppInfo.codeList.cardList count] == 1) {
        self.selectCardDic = AppInfo.codeList.cardList[0];
        
        [_cardNumber setTitle:_selectCardDic[@"2"] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.selectCardDic = nil;
    self.tempStartDate = nil;
    self.tempEndDate = nil;
    
    [_domestic release];
    [_foreignCountry release];
    [_cardNumber release];
    [_startDateField release];
    [_endDateField release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setDomestic:nil];
    [self setForeignCountry:nil];
    [self setCardNumber:nil];
    [self setStartDateField:nil];
    [self setEndDateField:nil];
    [super viewDidUnload];
}

#pragma mark - Button
/// 카드번호
- (IBAction)cardNumberBtn:(UIButton *)sender
{
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"카드목록"
                                                                   options:AppInfo.codeList.cardList
                                                                   CellNib:@"SHBAccountListPopupCell"
                                                                     CellH:50
                                                               CellDispCnt:5
                                                                CellOptCnt:4] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
}

/// 국내, 국외
- (IBAction)useLocation:(UIButton *)sender
{
    if (sender == _domestic) {
        [_domestic setSelected:YES];
        [_foreignCountry setSelected:NO];
    }
    else if (sender == _foreignCountry) {
        [_domestic setSelected:NO];
        [_foreignCountry setSelected:YES];
    }
}

/// 1주일, 1개월
- (IBAction)periodBtn:(UIButton *)sender
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    switch ([sender tag]) {
        case CARDUSEINPUT_ONEWEEK:
            [_startDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:0 toDay:-7]] animated:NO];
            
            break;
        case CARDUSEINPUT_ONEMONTH:
            [_startDateField selectDate:[dateFormatter dateFromString:[SHBUtility dateStringToMonth:-1 toDay:0]] animated:NO];
            
            break;
            
        default:
            break;
    }
    [_endDateField selectDate:[dateFormatter dateFromString:AppInfo.tran_Date] animated:NO];
}

/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    if ([_cardNumber.titleLabel.text length] == 0 || [_cardNumber.titleLabel.text isEqualToString:@"선택하세요"]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"카드번호를 선택해 주십시오."];
        return;
    }
    
    NSString *startDate = [_startDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *endDate = [_endDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ([startDate integerValue] > [endDate integerValue]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"'조회종료일'이 '조회시작일'보다 빠를 수 없습니다."];
        return;
    }
    
    if ([endDate integerValue] > [[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"오늘까지만 조회가 가능합니다."];
        return;
    }
    
    NSString *monthDate = [[SHBUtility dateStringToDate:_endDateField.textField.text toMonth:-1 toDay:0] stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ([startDate integerValue] < [monthDate integerValue]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"조회는 1개월 단위로 가능합니다."];
        return;
    }
    
    SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                           @{
                           @"신한카드번호" : _selectCardDic[@"카드번호"],
                           @"사용지역" : [_domestic isSelected] ? @"1" : @"2",
                           @"조회시작일" : startDate,
                           @"조회종료일" : endDate,
                           @"시작index" : @"1",
                           @"한페이지데이타수" : @"10",
                           }];
    
    NSDictionary *infoDic = @{
                            @"카드명" : _selectCardDic[@"1"],
                            @"카드번호" : _selectCardDic[@"2"],
                            };
    
    AppInfo.commonDic = @{
                        @"dataSet" : dataSet,
                        @"infoDic" : infoDic,
                        };
    
    SHBCardAcknowledgmentDetailViewController *viewController = [[[SHBCardAcknowledgmentDetailViewController alloc] initWithNibName:@"SHBCardAcknowledgmentDetailViewController" bundle:nil] autorelease];
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.selectCardDic = AppInfo.codeList.cardList[anIndex];
    
    [_cardNumber setTitle:_selectCardDic[@"2"] forState:UIControlStateNormal];
}

- (void)listPopupViewDidCancel
{
    
}

#pragma mark - SHBDateField

- (void)currentDateField:(SHBDateField *)dateField
{
    if (dateField == _startDateField) {
        self.tempStartDate = _startDateField.date;
    }
    else if (dateField == _startDateField) {
        self.tempEndDate = _endDateField.date;
    }
}

- (void)dateField:(SHBDateField *)dateField didConfirmWithDate:(NSDate *)date
{
    NSString *startDate = [_startDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *endDate = [_endDateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ([startDate integerValue] > [[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"오늘까지만 조회가 가능합니다."];
        
        [_startDateField selectDate:_tempStartDate animated:NO];
        [_endDateField selectDate:_tempEndDate animated:NO];
        
        return;
    }
    
    if ([endDate integerValue] > [[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"오늘까지만 조회가 가능합니다."];
        
        [_startDateField selectDate:_tempStartDate animated:NO];
        [_endDateField selectDate:_tempEndDate animated:NO];
        
        return;
    }
}

@end
