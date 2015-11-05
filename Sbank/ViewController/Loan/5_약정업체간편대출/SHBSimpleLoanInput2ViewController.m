//
//  SHBSimpleLoanInput2ViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 16..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSimpleLoanInput2ViewController.h"
#import "SHBLoanService.h" // service
#import "SHBListPopupView.h" // list popup
#import "SHBSearchZipViewController.h" // 우편번호 검색

#import "SHBSimpleLoanStipulationViewController.h" // 약정업체 간편대출 약관동의
#import "SHBSimpleLoanBranchSearchViewController.h" // 약정업체 간편대출 - 영업점조회
#import "SHBSimpleLoanInput3ViewController.h" // 약정업체 간편대출 - 정보입력(3)

/// list popup tag
enum SIMPLELOAN_INPUT2_LISTPOPUP_TAG {
    
    SIMPLELOAN_INPUT2_LISTPOPUP_ORGAN_SEARCH = 1301,
    SIMPLELOAN_INPUT2_LISTPOPUP_JOB_FAMILY,
    SIMPLELOAN_INPUT2_LISTPOPUP_JOB1,
    SIMPLELOAN_INPUT2_LISTPOPUP_JOB2,
    SIMPLELOAN_INPUT2_LISTPOPUP_JOB3,
    SIMPLELOAN_INPUT2_LISTPOPUP_JOB4,
    SIMPLELOAN_INPUT2_LISTPOPUP_POSITION
};

@interface SHBSimpleLoanInput2ViewController () <SHBListPopupViewDelegate, SHBSimpleLoanBranchSearchDelegate>
{
    BOOL _isOldAddress;
}

@property (retain, nonatomic) NSMutableArray *organSelectList; // 기관선택
@property (retain, nonatomic) NSMutableArray *jobFamilyList; // 직종
@property (retain, nonatomic) NSMutableArray *job1List; // 직업1
@property (retain, nonatomic) NSMutableArray *job2List; // 직업2
@property (retain, nonatomic) NSMutableArray *job3List; // 직업3
@property (retain, nonatomic) NSMutableArray *job4List; // 직업4
@property (retain, nonatomic) NSMutableArray *positionList; // 직위

@property (retain, nonatomic) NSMutableDictionary *selectOrganSelectDic; // 기관선택
@property (retain, nonatomic) NSMutableDictionary *selectJobFamilyDic; // 직종
@property (retain, nonatomic) NSMutableDictionary *selectJob1Dic; // 직업1
@property (retain, nonatomic) NSMutableDictionary *selectJob2Dic; // 직업2
@property (retain, nonatomic) NSMutableDictionary *selectJob3Dic; // 직업3
@property (retain, nonatomic) NSMutableDictionary *selectJob4Dic; // 직업4
@property (retain, nonatomic) NSMutableDictionary *selectPositionDic; // 직위

@end

@implementation SHBSimpleLoanInput2ViewController

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
    
    [self setTitle:@"약정업체 간편대출"];
    self.strBackButtonTitle = @"약정업체 간편대출 정보입력(2)";
    
    [_mainView setFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height)];
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    startTextFieldTag = 3330;
    endTextFieldTag = 3335;
    
    [self setListData];
    
    // 입사일자
    [_dateField initFrame:_dateField.frame];
    [_dateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_dateField.textField setTextColor:RGB(44, 44, 44)];
    [_dateField.textField setTextAlignment:UITextAlignmentLeft];
    [_dateField.textField setPlaceholder:@"(선택)"];
    [_dateField.textField setAccessibilityLabel:@"입사일자 입력창"];
    [_dateField setDelegate:self];
    
    [_department setText:[SHBUtility nilToString:self.data[@"직장부서명"]]];
    [_zipCode1 setText:[SHBUtility nilToString:self.data[@"직장우편번호1"]]];
    [_zipCode2 setText:[SHBUtility nilToString:self.data[@"직장우편번호2"]]];
    
    [_address1 setText:[SHBUtility nilToString:self.data[@"직장동주소명"]]];
    [_address2 setText:[SHBUtility nilToString:self.data[@"직장동미만주소"]]];
    
    [_number1 setText:[SHBUtility nilToString:self.data[@"직장전화지역번호"]]];
    [_number2 setText:[SHBUtility nilToString:self.data[@"직장전화국번호"]]];
    [_number3 setText:[SHBUtility nilToString:self.data[@"직장전화통신일련번호"]]];
    
    if ([self.data[@"고객_직장주소종류"] isEqualToString:@"2"]) {
        
        _isOldAddress = NO;
    }
    else {
        
        _isOldAddress = YES;
    }
    
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
    self.inputData = nil;
    
    self.organSelectList = nil;
    self.jobFamilyList = nil;
    self.job1List = nil;
    self.job2List = nil;
    self.job3List = nil;
    self.job4List = nil;
    self.positionList = nil;
    
    self.selectOrganSelectDic = nil;
    self.selectJobFamilyDic = nil;
    self.selectJob1Dic = nil;
    self.selectJob2Dic = nil;
    self.selectJob3Dic = nil;
    self.selectJob4Dic = nil;
    self.selectPositionDic = nil;
    
    [_mainView release];
    [_organSearch release];
    [_organSelectBtn release];
    [_branch release];
    [_jobFamilyBtn release];
    [_job1Btn release];
    [_job2Btn release];
    [_job3Btn release];
    [_job4Btn release];
    [_positionBtn release];
    [_department release];
    [_zipCode1 release];
    [_zipCode2 release];
    [_address1 release];
    [_address2 release];
    [_number1 release];
    [_number2 release];
    [_number3 release];
    [_dateField release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setOrganSearch:nil];
    [self setOrganSelectBtn:nil];
    [self setBranch:nil];
    [self setJobFamilyBtn:nil];
    [self setJob1Btn:nil];
    [self setJob2Btn:nil];
    [self setJob3Btn:nil];
    [self setJob4Btn:nil];
    [self setPositionBtn:nil];
    [self setDepartment:nil];
    [self setZipCode1:nil];
    [self setZipCode2:nil];
    [self setAddress1:nil];
    [self setAddress2:nil];
    [self setNumber1:nil];
    [self setNumber2:nil];
    [self setNumber3:nil];
    [self setDateField:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (void)setListData
{
    self.organSelectList = [NSMutableArray array];
    self.jobFamilyList = [NSMutableArray arrayWithArray:@[ @{ @"1" : @"정규직", @"CODE" : @"1", },
                                                           @{ @"1" : @"기타직", @"CODE" : @"3", }, ]];
    self.job1List = [NSMutableArray array];
    self.job2List = [NSMutableArray array];
    self.job3List = [NSMutableArray array];
    self.job4List = [NSMutableArray array];
    self.positionList = [NSMutableArray array];
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
    if (!_selectOrganSelectDic || [_organSelectBtn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"기관을 선택해 주세요.";
    }
    
    if ([_branch.text length] == 0) {
        
        return @"대출희망지점 입력을 위해 영업점 조회버튼을 선택해 주세요.";
    }
    
    if (!_selectJobFamilyDic || [_jobFamilyBtn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"직종을 선택해 주세요.";
    }
    
    if (!_selectJob1Dic || [_job1Btn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"직업 및 직위를 선택해 주세요.";
    }
    
    if (!_selectJob2Dic || [_job2Btn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"직업 및 직위를 선택해 주세요.";
    }
    
    if (!_selectJob3Dic || [_job3Btn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"직업 및 직위를 선택해 주세요.";
    }
    
    if ([_job4Btn isEnabled] &&
        (!_selectJob4Dic || [_job4Btn.titleLabel.text isEqualToString:@"선택하세요"])) {
        
        return @"직업 및 직위를 선택해 주세요.";
    }
    
    if (!_selectPositionDic || [_positionBtn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"직업 및 직위를 선택해 주세요.";
    }
    
    if ([_department.text length] == 0) {
        
        return @"근무부서를 입력해 주세요.";
    }
    
    if ([_zipCode1.text length] != 3 || [_zipCode2.text length] != 3) {
        
        return @"직장 우편번호를 입력해 주세요.";
    }
    
    if ([_address1.text length] == 0 || [_address2.text length] == 0) {
        
        return @"직장 주소를 입력해 주세요.";
    }
    
    if ([_number1.text length] < 2 || [_number2.text length] < 3 || [_number3.text length] < 4) {
        
        return @"직장 전화번호를 입력해 주세요.";
    }
    
    if ([_dateField.textField.text length] > 0) {
        
        NSInteger date = [[_dateField.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
        NSInteger today = [[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
        
        if (date > today) {
            
            return @"입사일자는 현재일이거나 과거일자만 가능합니다.";
        }
    }
    
    return @"";
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
            
        case 10: {
            
            // 기관검색 조회
            
            if ([_organSearch.text length] == 0) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"기관 검색어를 입력하신 후 조회 버튼을 선택해 주세요."];
                return;
            }
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                      TASK_ACTION_KEY : @"selectEasyLoan",
                                      @"P_BIZNMS" : _organSearch.text,
                                      }];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_SIMPLELOAN_SEARCH_SERVICE viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case 20: {
            
            // 기관선택
            
            [self showPopupView:@"기관선택" withOptions:_organSelectList withTag:SIMPLELOAN_INPUT2_LISTPOPUP_ORGAN_SEARCH];
        }
            break;
            
        case 30: {
            
            // 영업점 조회
            
            SHBSimpleLoanBranchSearchViewController *viewController = [[[SHBSimpleLoanBranchSearchViewController alloc] initWithNibName:@"SHBSimpleLoanBranchSearchViewController" bundle:nil] autorelease];
            
            viewController.delegate = self;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 40: {
            
            // 직종
            
            [self showPopupView:@"직종" withOptions:_jobFamilyList withTag:SIMPLELOAN_INPUT2_LISTPOPUP_JOB_FAMILY];
        }
            break;
            
        case 50: {
            
            // 직업1
            
            [self showPopupView:@"직업" withOptions:_job1List withTag:SIMPLELOAN_INPUT2_LISTPOPUP_JOB1];
        }
            break;
            
        case 51: {
            
            // 직업2
            
            [self showPopupView:@"대분류" withOptions:_job2List withTag:SIMPLELOAN_INPUT2_LISTPOPUP_JOB2];
        }
            break;
            
        case 52: {
            
            // 직업3
            
            [self showPopupView:@"중분류" withOptions:_job3List withTag:SIMPLELOAN_INPUT2_LISTPOPUP_JOB3];
        }
            break;
            
        case 53: {
            
            // 직업4
            
            [self showPopupView:@"소분류" withOptions:_job4List withTag:SIMPLELOAN_INPUT2_LISTPOPUP_JOB4];
        }
            break;
            
        case 60: {
            
            // 직위
            
            [self showPopupView:@"직위" withOptions:_positionList withTag:SIMPLELOAN_INPUT2_LISTPOPUP_POSITION];
        }
            break;
            
        case 70: {
            
            // 우편번호 검색
            
            SHBSearchZipViewController *viewController = [[[SHBSearchZipViewController alloc] initWithNibName:@"SHBSearchZipViewController" bundle:nil] autorelease];
            
            [viewController executeWithTitle:@"약정업체 간편대출" ReturnViewController:self];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 80: {
            
            // 다음
            
            NSString *message = [self getErrorMessage];
            
            if ([message length] > 0) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:message];
                return;
            }
            
            NSString *jikwi = [SHBUtility nilToString:_selectPositionDic[@"JIKWI_CODE"]];
            
            if ([jikwi length] >= 1) {
                
                jikwi = [jikwi substringFromIndex:[_selectPositionDic[@"JIKWI_CODE"] length] - 1];
            }
            else {
                
                jikwi = @"0";
            }
            
            [_inputData addEntriesFromDictionary:@{
                                                   @"_기관선택" : [SHBUtility nilToString:_organSelectBtn.titleLabel.text],
                                                   @"_대출희망지점" : [SHBUtility nilToString:_branch.text],
                                                   @"_직종" : [SHBUtility nilToString:_selectJobFamilyDic[@"CODE"]],
                                                   @"_직업코드" : _selectJob4Dic ? [SHBUtility nilToString:_selectJob4Dic[@"JIKEOB_CODE"]]
                                                                               : [SHBUtility nilToString:_selectJob3Dic[@"JIKEOB_CODE"]],
                                                   @"_직위" : [SHBUtility nilToString:_positionBtn.titleLabel.text],
                                                   @"_직위코드" : jikwi,
                                                   @"_근무부서" : [SHBUtility nilToString:_department.text],
                                                   @"_직장우편번호1" : [SHBUtility nilToString:_zipCode1.text],
                                                   @"_직장우편번호2" : [SHBUtility nilToString:_zipCode2.text],
                                                   @"_직장동주소명" : [SHBUtility nilToString:_address1.text],
                                                   @"_직장동미만주소" : [SHBUtility nilToString:_address2.text],
                                                   @"_직장전화지역번호" : [SHBUtility nilToString:_number1.text],
                                                   @"_직장전화국번호" : [SHBUtility nilToString:_number2.text],
                                                   @"_직장전화통신일련번호" : [SHBUtility nilToString:_number3.text],
                                                   @"_입사일자" : [SHBUtility nilToString:_dateField.textField.text],
                                                   @"_직장주소종류" : _isOldAddress ? @"1" : @"2",
                                                   @"_대분류" : [SHBUtility nilToString:_selectJob2Dic[@"JIKEOB_CODE"]],
                                                   @"_중분류" : [SHBUtility nilToString:_selectJob3Dic[@"JIKEOB_CODE"]],
                                                   @"_소분류" : _selectJob4Dic ? [SHBUtility nilToString:_selectJob4Dic[@"JIKEOB_CODE"]] : @"",
                                                   }];
            
            if ([_selectOrganSelectDic[@"BIZNO"] length] >= 10) {
                
                NSString *number = [_selectOrganSelectDic[@"BIZNO"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                [_inputData setObject:[number substringWithRange:NSMakeRange(0, 3)]
                               forKey:@"_사업자등록번호1"];
                
                [_inputData setObject:[number substringWithRange:NSMakeRange(3, 2)]
                               forKey:@"_사업자등록번호2"];
                
                [_inputData setObject:[number substringWithRange:NSMakeRange(5, 5)]
                               forKey:@"_사업자등록번호3"];
            }
            else {
                
                [_inputData setObject:@"" forKey:@"_사업자등록번호1"];
                [_inputData setObject:@"" forKey:@"_사업자등록번호2"];
                [_inputData setObject:@"" forKey:@"_사업자등록번호3"];
            }
            
            SHBSimpleLoanInput3ViewController *viewController = [[[SHBSimpleLoanInput3ViewController alloc] initWithNibName:@"SHBSimpleLoanInput3ViewController" bundle:nil] autorelease];
            
            viewController.inputData = _inputData;
            viewController.data = self.data;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 90: {
            
            // 취소
            
            for (SHBSimpleLoanStipulationViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[SHBSimpleLoanStipulationViewController class]]) {
                    
                    [viewController clearViewData];
                    
                    [self.navigationController fadePopToViewController:viewController];
                    
                    break;
                }
            }
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
            
        case LOAN_SIMPLELOAN_SEARCH_SERVICE: {
            
            // 기관검색
            
            self.organSelectList = [aDataSet arrayWithForKeyPath:@"data"];
            
            for (NSMutableDictionary *dic in _organSelectList) {
                
                [dic setObject:[SHBUtility nilToString:dic[@"BIZNM"]] forKey:@"1"];
            }
            
            if ([_organSelectList count] > 0) {
                
                if ([_organSelectList[0][@"BRNM"] length] > 0) {
                    
                    [_branch setText:_organSelectList[0][@"BRNM"]];
                    
                    [_inputData setObject:_organSelectList[0][@"BRNO"] forKey:@"_지점"];
                }
                else {
                    
                    [_branch setText:@""];
                    
                    [_inputData setObject:@"" forKey:@"_지점"];
                }
                
                self.selectOrganSelectDic = _organSelectList[0];
                
                [self setButton:_organSelectBtn withTitle:_selectOrganSelectDic[@"1"]];
                [_organSelectBtn setEnabled:YES];
            }
            else {
                
                [self setButton:_organSelectBtn withTitle:@"선택하세요"];
                [_organSelectBtn setEnabled:NO];
            }
        }
            break;
            
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
            
        case SIMPLELOAN_INPUT2_LISTPOPUP_ORGAN_SEARCH: {
            
            // 기관선택
            
            self.selectOrganSelectDic = _organSelectList[anIndex];
            
            [self setButton:_organSelectBtn withTitle:_selectOrganSelectDic[@"1"]];
        }
            break;
            
        case SIMPLELOAN_INPUT2_LISTPOPUP_JOB_FAMILY: {
            
            // 직종
            
            self.selectJobFamilyDic = _jobFamilyList[anIndex];
            
            [self setButton:_jobFamilyBtn withTitle:_selectJobFamilyDic[@"1"]];
        }
            break;
            
        case SIMPLELOAN_INPUT2_LISTPOPUP_JOB1: {
            
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
            
        case SIMPLELOAN_INPUT2_LISTPOPUP_JOB2: {
            
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
            
        case SIMPLELOAN_INPUT2_LISTPOPUP_JOB3: {
            
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
            
        case SIMPLELOAN_INPUT2_LISTPOPUP_JOB4: {
            
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
            
        case SIMPLELOAN_INPUT2_LISTPOPUP_POSITION: {
            
            // 직위
            
            self.selectPositionDic = _positionList[anIndex];
            
            [self setButton:_positionBtn withTitle:_selectPositionDic[@"1"]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string]) {
        
        return NO;
    }
    
    int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    
    //특수문자 : ₩ $ £ ¥ • 은 입력 안됨
    NSString *SPECIAL_CHAR = @"$₩€£¥•!@#$%^&*()_=+{}|[]\\;:\'\"<>?,./`~";
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    
    if (textField == _number1 || textField == _number2 || textField == _number3) {
        
        if ([textField.text length] >= 4 && range.length == 0) {
            
            return NO;
        }
    }
    else if (textField == _address2) {
        
        if (basicTest && [string length] > 0) {
            
            return NO;
        }
        
        if (dataLength + dataLength2 > 45) {
            
            return NO;
        }
        
        return YES;
    }
    else if (textField == _department) {
        
        if (basicTest && [string length] > 0) {
            
            return NO;
        }
        
        if (dataLength + dataLength2 > 20) {
            
            return NO;
        }
        
        return YES;
    }
    
    return YES;
}

#pragma mark - SHBDateField

- (void)currentDateField:(SHBDateField *)dateField
{
    [self.curTextField resignFirstResponder];
    
    if ([_dateField.textField.text length] == 0) {
        
        [_dateField setDate:[NSDate date]];
    }
}

#pragma mark - SHBSearchZipViewController

- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic
{
    [_zipCode1 setText:mDic[@"POST1"]];
    [_zipCode2 setText:mDic[@"POST2"]];
    
    [_address1 setText:[NSString stringWithFormat:@"%@ %@", mDic[@"ADDR1"], mDic[@"ADDR2"]]];
    [_address2 setText:@""];
    
    [_address2 becomeFirstResponder];
    
    if ([mDic[@"주소종류"] isEqualToString:@"지번주소"]) {
        
        _isOldAddress = YES;
    }
    else {
        
        _isOldAddress = NO;
    }
}

#pragma mark - SHBSimpleLoanBranchSearchDelegate

- (void)simpleLoanBranchSearchSelectIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)data
{
    [_branch setText:data[@"지점명"]];
    
    [_inputData setObject:data[@"지점번호"] forKey:@"_지점"];
}

@end
