//
//  SHBLoanMyLimitInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 5. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanMyLimitInputViewController.h"
#import "SHBLoanService.h" // service
#import "SHBListPopupView.h" // list popup

#import "SHBLoanMyLimitInput2ViewController.h" // 예상 대출 한도 조회 - 대출관련사항

/// list popup tag
enum LOAN_MYLIMIT_LISTPOPUP_TAG {
    LOAN_MYLIMIT_LISTPOPUP_JOB_FAMILY = 1201,
    LOAN_MYLIMIT_LISTPOPUP_JOB1,
    LOAN_MYLIMIT_LISTPOPUP_JOB2,
    LOAN_MYLIMIT_LISTPOPUP_JOB3,
    LOAN_MYLIMIT_LISTPOPUP_JOB4,
    LOAN_MYLIMIT_LISTPOPUP_POSITION,
    LOAN_MYLIMIT_LISTPOPUP_DUTY
};

@interface SHBLoanMyLimitInputViewController () <SHBListPopupViewDelegate, SHBLoanMyLimitInput2Delegate>

@property (retain, nonatomic) NSMutableArray *jobFamilyList; // 직종
@property (retain, nonatomic) NSMutableArray *job1List; // 직업1
@property (retain, nonatomic) NSMutableArray *job2List; // 직업2
@property (retain, nonatomic) NSMutableArray *job3List; // 직업3
@property (retain, nonatomic) NSMutableArray *job4List; // 직업4
@property (retain, nonatomic) NSMutableArray *positionList; // 직위
@property (retain, nonatomic) NSMutableArray *dutyList; // 직무

@property (retain, nonatomic) NSMutableDictionary *selectJobFamilyDic; // 직종
@property (retain, nonatomic) NSMutableDictionary *selectJob1Dic; // 직업1
@property (retain, nonatomic) NSMutableDictionary *selectJob2Dic; // 직업2
@property (retain, nonatomic) NSMutableDictionary *selectJob3Dic; // 직업3
@property (retain, nonatomic) NSMutableDictionary *selectJob4Dic; // 직업4
@property (retain, nonatomic) NSMutableDictionary *selectPositionDic; // 직위
@property (retain, nonatomic) NSMutableDictionary *selectDutyDic; // 직무

@end

@implementation SHBLoanMyLimitInputViewController

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
    
    [self setTitle:@"예상 대출 한도 조회"];
    self.strBackButtonTitle = @"예상 대출 한도 조회 1단계";
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    startTextFieldTag = 30300;
    endTextFieldTag = 30300;
    
    [self setListData];
    
    // 입사일자
    [_dateField initFrame:_dateField.frame];
    [_dateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_dateField.textField setTextColor:RGB(44, 44, 44)];
    [_dateField.textField setTextAlignment:UITextAlignmentLeft];
    [_dateField.textField setAccessibilityLabel:@"입사일자 입력창"];
    [_dateField setDelegate:self];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              TASK_NAME_KEY : @"sfg.rib.task.common.DBTask",
                              TASK_ACTION_KEY : @"getJOB",
                              @"JIKEOB_CODE" : @"직업종류",
                              }];
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_MYLIMIT_JOB1_SERVICE
                                               viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.jobFamilyList = nil;
    self.job1List = nil;
    self.job2List = nil;
    self.job3List = nil;
    self.job4List = nil;
    self.positionList = nil;
    self.dutyList = nil;
    
    self.selectJobFamilyDic = nil;
    self.selectJob1Dic = nil;
    self.selectJob2Dic = nil;
    self.selectJob3Dic = nil;
    self.selectJob4Dic = nil;
    self.selectPositionDic = nil;
    self.selectDutyDic = nil;
    
    [_companyTF release];
    [_publicOfficialBtn release];
    [_jobFamilyBtn release];
    [_job1Btn release];
    [_job2Btn release];
    [_job3Btn release];
    [_job4Btn release];
    [_positionBtn release];
    [_dutyBtn release];
    [_dateField release];
    [_mainView release];
    [super dealloc];
}

#pragma mark - Method

- (void)setListData
{
    self.jobFamilyList = [NSMutableArray arrayWithArray:@[ @{ @"1" : @"정규직", @"CODE" : @"1", },
                                                           @{ @"1" : @"기타직", @"CODE" : @"3", }, ]];
    self.job1List = [NSMutableArray array];
    self.job2List = [NSMutableArray array];
    self.job3List = [NSMutableArray array];
    self.job4List = [NSMutableArray array];
    self.positionList = [NSMutableArray array];
    self.dutyList = [NSMutableArray arrayWithArray:@[ @{ @"1" : @"관리직", @"CODE" : @"1", },
                                                      @{ @"1" : @"사무직", @"CODE" : @"2", },
                                                      @{ @"1" : @"연구직", @"CODE" : @"3", },
                                                      @{ @"1" : @"전문직", @"CODE" : @"4", },
                                                      @{ @"1" : @"기술직", @"CODE" : @"5", },
                                                      @{ @"1" : @"생산직", @"CODE" : @"6", },
                                                      @{ @"1" : @"노무직", @"CODE" : @"7", },
                                                      @{ @"1" : @"영업직", @"CODE" : @"8", },
                                                      @{ @"1" : @"판매직", @"CODE" : @"9", }, ]];
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

#pragma mark - Button

- (IBAction)buttonPressed:(UIButton *)sender
{
    [_companyTF resignFirstResponder];
    
    switch ([sender tag]) {
        case 50: {
            
            // 공무원 (군인, 군무원 포함)
            
            [sender setSelected:![sender isSelected]];
            
            if ([sender isSelected]) {
                
                [_companyTF setText:@""];
            }
        }
            break;
            
        case 100: {
            
            [self showPopupView:@"직종" withOptions:_jobFamilyList withTag:LOAN_MYLIMIT_LISTPOPUP_JOB_FAMILY];
        }
            break;
            
        case 200: {
            
            [self showPopupView:@"직업" withOptions:_job1List withTag:LOAN_MYLIMIT_LISTPOPUP_JOB1];
        }
            break;
            
        case 210: {
            
            [self showPopupView:@"대분류" withOptions:_job2List withTag:LOAN_MYLIMIT_LISTPOPUP_JOB2];
        }
            break;
            
        case 220: {
            
            [self showPopupView:@"중분류" withOptions:_job3List withTag:LOAN_MYLIMIT_LISTPOPUP_JOB3];
        }
            break;
            
        case 230: {
            
            [self showPopupView:@"소분류" withOptions:_job4List withTag:LOAN_MYLIMIT_LISTPOPUP_JOB4];
        }
            break;
            
        case 300: {
            
            [self showPopupView:@"직위" withOptions:_positionList withTag:LOAN_MYLIMIT_LISTPOPUP_POSITION];
        }
            break;
            
        case 400: {
            
            [self showPopupView:@"직무" withOptions:_dutyList withTag:LOAN_MYLIMIT_LISTPOPUP_DUTY];
        }
            break;
            
        case 500: {
            
            // 다음
            
            if ([_companyTF.text length] != 0 && [_companyTF.text length] < 10) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"사업자 등록번호가 정확하지 않습니다."];
                return;
            }
            
            if (!_selectJobFamilyDic || [_jobFamilyBtn.titleLabel.text isEqualToString:@"선택하세요"]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"직종을 선택해 주세요."];
                return;
            }
            
            if (!_selectJob1Dic || [_job1Btn.titleLabel.text isEqualToString:@"선택하세요"]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"직업 및 직위를 입력해 주세요."];
                return;
            }
            
            if (!_selectJob2Dic || [_job2Btn.titleLabel.text isEqualToString:@"선택하세요"]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"직업 및 직위를 입력해 주세요."];
                return;
            }
            
            if (!_selectJob3Dic || [_job3Btn.titleLabel.text isEqualToString:@"선택하세요"]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"직업 및 직위를 입력해 주세요."];
                return;
            }
            
            if ([_job4Btn isEnabled] &&
                (!_selectJob4Dic || [_job4Btn.titleLabel.text isEqualToString:@"선택하세요"])) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"직업 및 직위를 입력해 주세요."];
                return;
            }
            
            if (!_selectPositionDic || [_positionBtn.titleLabel.text isEqualToString:@"선택하세요"]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"직업 및 직위를 입력해 주세요."];
                return;
            }
            
            if (!_selectDutyDic || [_dutyBtn.titleLabel.text isEqualToString:@"선택하세요"]) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"직무를 선택해 주세요."];
                return;
            }
            
            if ([_dateField.textField.text length] == 0) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"입사일자를 입력해 주세요."];
                return;
            }
            
            SHBLoanMyLimitInput2ViewController *viewController = [[[SHBLoanMyLimitInput2ViewController alloc] initWithNibName:@"SHBLoanMyLimitInput2ViewController" bundle:nil] autorelease];
            
            viewController.delegate = self;
            viewController.data = @{ @"_사업자등록번호" : [SHBUtility nilToString:_companyTF.text],
                                     @"_입사일자" : _dateField.textField.text,
                                     @"_직종" : _selectJobFamilyDic[@"CODE"],
                                     @"_직업" : _selectJob4Dic ? _selectJob4Dic[@"JIKEOB_CODE"] : _selectJob3Dic[@"JIKEOB_CODE"],
                                     @"_직위" : [_selectPositionDic[@"JIKWI_CODE"] substringFromIndex:[_selectPositionDic[@"JIKWI_CODE"] length] - 1],
                                     @"_직무" : _selectDutyDic[@"CODE"], };
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
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
    
    switch (self.service.serviceId) {
            
        case LOAN_MYLIMIT_JOB1_SERVICE: {
            
            // 직업1
            
            self.job1List = [aDataSet arrayWithForKeyPath:@"data"];
            
            for (NSMutableDictionary *dic in _job1List) {
                
                [dic setObject:[SHBUtility nilToString:dic[@"JIKEOB_NAME"]] forKey:@"1"];
            }
        }
            break;
        
        case LOAN_MYLIMIT_JOB2_SERVICE: {
            
            // 직업2
            
            self.job2List = [aDataSet arrayWithForKeyPath:@"data"];
            
            for (NSMutableDictionary *dic in _job2List) {
                
                [dic setObject:[SHBUtility nilToString:dic[@"JIKEOB_NAME"]] forKey:@"1"];
            }
            
            if ([_job2List count] > 0) {
                
                [_job2Btn setEnabled:YES];
            }
        }
            break;
            
        case LOAN_MYLIMIT_JOB3_SERVICE: {
            
            // 직업3
            
            self.job3List = [aDataSet arrayWithForKeyPath:@"data"];
            
            for (NSMutableDictionary *dic in _job3List) {
                
                [dic setObject:[SHBUtility nilToString:dic[@"JIKEOB_NAME"]] forKey:@"1"];
            }
            
            if ([_job3List count] > 0) {
                
                [_job3Btn setEnabled:YES];
            }
            else {
                
                [self setButton:_job3Btn withTitle:@"분류코드 없음"];
            }
        }
            break;
            
        case LOAN_MYLIMIT_JOB4_SERVICE: {
            
            // 직업4
            
            self.job4List = [aDataSet arrayWithForKeyPath:@"data"];
            
            for (NSMutableDictionary *dic in _job4List) {
                
                [dic setObject:[SHBUtility nilToString:dic[@"JIKEOB_NAME"]] forKey:@"1"];
            }
            
            if ([_job4List count] > 0) {
                
                [_job4Btn setEnabled:YES];
            }
            else {
                
                [self setButton:_job4Btn withTitle:@"분류코드 없음"];
                
                SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                        @{
                                          TASK_NAME_KEY : @"sfg.rib.task.common.DBTask",
                                          TASK_ACTION_KEY : @"getJikwiCode",
                                          @"FROM_JIKWI_CODE" : [NSString stringWithFormat:@"%d",
                                                                [_selectJob3Dic[@"JIKEOB_TYPE"] integerValue] * 10],
                                          @"TO_JIKWI_CODE" : [NSString stringWithFormat:@"%d",
                                                              [_selectJob3Dic[@"JIKEOB_TYPE"] integerValue] * 10 + 9],
                                          }];
                
                self.service = nil;
                self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_MYLIMIT_POSITION_SERVICE
                                                           viewController:self] autorelease];
                self.service.requestData = aDataSet;
                [self.service start];
            }
        }
            break;
            
        case LOAN_MYLIMIT_POSITION_SERVICE: {
            
            // 직위
            
            self.positionList = [aDataSet arrayWithForKeyPath:@"data"];
            
            for (NSMutableDictionary *dic in _positionList) {
                
                [dic setObject:[SHBUtility nilToString:dic[@"JIKWI_NAME"]] forKey:@"1"];
            }
            
            if ([_positionList count] > 0) {
                
                [_positionBtn setEnabled:YES];
            }
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
            
        case LOAN_MYLIMIT_LISTPOPUP_JOB_FAMILY: {
            
            // 직종
            
            self.selectJobFamilyDic = _jobFamilyList[anIndex];
            
            [self setButton:_jobFamilyBtn withTitle:_selectJobFamilyDic[@"1"]];
        }
            break;
            
        case LOAN_MYLIMIT_LISTPOPUP_JOB1: {
            
            // 직업1
            
            if (_selectJob1Dic) {
                
                self.selectJob2Dic = nil;
                self.selectJob3Dic = nil;
                self.selectJob4Dic = nil;
                self.selectPositionDic = nil;
                
                [self setButton:_job2Btn withTitle:@"선택하세요"];
                [self setButton:_job3Btn withTitle:@"선택하세요"];
                [self setButton:_job4Btn withTitle:@"선택하세요"];
                [self setButton:_positionBtn withTitle:@"선택하세요"];
                
                [_job2Btn setEnabled:NO];
                [_job3Btn setEnabled:NO];
                [_job4Btn setEnabled:NO];
                [_positionBtn setEnabled:NO];
            }
            
            self.selectJob1Dic = _job1List[anIndex];
            
            [self setButton:_job1Btn withTitle:_selectJob1Dic[@"1"]];
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.rib.task.common.DBTask",
                                      TASK_ACTION_KEY : @"getJOB",
                                      @"JIKEOB_CODE" : _selectJob1Dic[@"JIKEOB_CODE"],
                                      }];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_MYLIMIT_JOB2_SERVICE
                                                       viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case LOAN_MYLIMIT_LISTPOPUP_JOB2: {
            
            // 직업2
            
            if (_selectJob2Dic) {
                
                self.selectJob3Dic = nil;
                self.selectJob4Dic = nil;
                self.selectPositionDic = nil;
                
                [self setButton:_job3Btn withTitle:@"선택하세요"];
                [self setButton:_job4Btn withTitle:@"선택하세요"];
                [self setButton:_positionBtn withTitle:@"선택하세요"];
                
                [_job3Btn setEnabled:NO];
                [_job4Btn setEnabled:NO];
                [_positionBtn setEnabled:NO];
            }
            
            self.selectJob2Dic = _job2List[anIndex];
            
            [self setButton:_job2Btn withTitle:_selectJob2Dic[@"1"]];
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.rib.task.common.DBTask",
                                      TASK_ACTION_KEY : @"getJobCode",
                                      @"FROM_JIKEOB_CODE" : _selectJob2Dic[@"JIKEOB_CODE"],
                                      @"TO_JIKEOB_CODE" : [NSString stringWithFormat:@"%d",
                                                           [_selectJob2Dic[@"JIKEOB_CODE"] integerValue] + 100],
                                      @"JIKEOB_LEVEL" : @"3",
                                      }];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_MYLIMIT_JOB3_SERVICE
                                                       viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case LOAN_MYLIMIT_LISTPOPUP_JOB3: {
            
            // 직업3
            
            if (_selectJob3Dic) {
                
                self.selectJob4Dic = nil;
                self.selectPositionDic = nil;
                
                [self setButton:_job4Btn withTitle:@"선택하세요"];
                [self setButton:_positionBtn withTitle:@"선택하세요"];
                
                [_job4Btn setEnabled:NO];
                [_positionBtn setEnabled:NO];
            }
            
            self.selectJob3Dic = _job3List[anIndex];
            
            [self setButton:_job3Btn withTitle:_selectJob3Dic[@"1"]];
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.rib.task.common.DBTask",
                                      TASK_ACTION_KEY : @"getJobCode",
                                      @"FROM_JIKEOB_CODE" : _selectJob3Dic[@"JIKEOB_CODE"],
                                      @"TO_JIKEOB_CODE" : [NSString stringWithFormat:@"%d",
                                                           [_selectJob3Dic[@"JIKEOB_CODE"] integerValue] + 10],
                                      @"JIKEOB_LEVEL" : @"4",
                                      }];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_MYLIMIT_JOB4_SERVICE
                                                       viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case LOAN_MYLIMIT_LISTPOPUP_JOB4: {
            
            // 직업4
            
            if (_selectJob4Dic) {
                
                self.selectPositionDic = nil;
                
                [self setButton:_positionBtn withTitle:@"선택하세요"];
                
                [_positionBtn setEnabled:NO];
            }
            
            self.selectJob4Dic = _job4List[anIndex];
            
            [self setButton:_job4Btn withTitle:_selectJob4Dic[@"1"]];
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.rib.task.common.DBTask",
                                      TASK_ACTION_KEY : @"getJikwiCode",
                                      @"FROM_JIKWI_CODE" : [NSString stringWithFormat:@"%d",
                                                            [_selectJob4Dic[@"JIKEOB_TYPE"] integerValue] * 10],
                                      @"TO_JIKWI_CODE" : [NSString stringWithFormat:@"%d",
                                                           [_selectJob4Dic[@"JIKEOB_TYPE"] integerValue] * 10 + 9],
                                      }];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_MYLIMIT_POSITION_SERVICE
                                                       viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case LOAN_MYLIMIT_LISTPOPUP_POSITION: {
            
            // 직위
            
            self.selectPositionDic = _positionList[anIndex];
            
            [self setButton:_positionBtn withTitle:_selectPositionDic[@"1"]];
        }
            break;
            
        case LOAN_MYLIMIT_LISTPOPUP_DUTY: {
            
            // 직무
            
            self.selectDutyDic = _dutyList[anIndex];
            
            [self setButton:_dutyBtn withTitle:_selectDutyDic[@"1"]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - SHBDateField

- (void)currentDateField:(SHBDateField *)dateField
{
    [self.curTextField resignFirstResponder];
    
    if ([_dateField.textField.text length] == 0) {
        
        [_dateField setDate:[NSDate date]];
    }
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string]) {
        
        return NO;
    }
    
    NSInteger dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    NSInteger dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    BOOL basicTest = [string isEqualToString:filtered];
    
    if (!basicTest && [string length] > 0) {
        
        return NO;
    }
    
    if (dataLength + dataLength2 > 10) {
        
        return NO;
    }
    
    if (dataLength + dataLength2 > 0) {
        
        [_publicOfficialBtn setSelected:NO];
    }
    
    return YES;
}

#pragma mark - SHBLoanMyLimitInput2ViewController

- (void)loanMyLimitInput2Cancel
{
    [self.contentScrollView setContentOffset:CGPointZero];
    
    [_companyTF setText:@""];
    
    [_publicOfficialBtn setSelected:NO];
    
    [self setButton:_jobFamilyBtn withTitle:@"선택하세요"];
    [self setButton:_job1Btn withTitle:@"선택하세요"];
    [self setButton:_job2Btn withTitle:@"선택하세요"];
    [self setButton:_job3Btn withTitle:@"선택하세요"];
    [self setButton:_job4Btn withTitle:@"선택하세요"];
    [self setButton:_positionBtn withTitle:@"선택하세요"];
    [self setButton:_dutyBtn withTitle:@"선택하세요"];
    
    [_job2Btn setEnabled:NO];
    [_job3Btn setEnabled:NO];
    [_job4Btn setEnabled:NO];
    [_positionBtn setEnabled:NO];
    
    [_dateField.textField setText:@""];
    
    [self setListData];
    
    self.selectJobFamilyDic = nil;
    self.selectJob1Dic = nil;
    self.selectJob2Dic = nil;
    self.selectJob3Dic = nil;
    self.selectJob4Dic = nil;
    self.selectPositionDic = nil;
    self.selectDutyDic = nil;
}

@end
