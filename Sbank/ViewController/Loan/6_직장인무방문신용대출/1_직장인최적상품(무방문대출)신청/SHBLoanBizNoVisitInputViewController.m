//
//  SHBLoanBizNoVisitInputViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitInputViewController.h"
#import "SHBLoanService.h" // service
#import "SHBListPopupView.h" // list popup

#import "SHBLoanBizNoVisitStipulationViewController.h" // 약관동의
#import "SHBLoanBizNoVisitInput2ViewController.h" // 직장인 최적상품(무방문대출) 신청 대출관련사항

/// list popup tag
enum BIZ_NOVISIT_INPUT_LISTPOPUP_TAG {
    
    BIZ_NOVISIT_INPUT_LISTPOPUP_DWELLING = 1601,
    BIZ_NOVISIT_INPUT_LISTPOPUP_POSTDELIVERY,
    BIZ_NOVISIT_INPUT_LISTPOPUP_JOB_FAMILY,
    BIZ_NOVISIT_INPUT_LISTPOPUP_JOB1,
    BIZ_NOVISIT_INPUT_LISTPOPUP_JOB2,
    BIZ_NOVISIT_INPUT_LISTPOPUP_JOB3,
    BIZ_NOVISIT_INPUT_LISTPOPUP_JOB4,
    BIZ_NOVISIT_INPUT_LISTPOPUP_POSITION,
    BIZ_NOVISIT_INPUT_LISTPOPUP_DUTY,
    BIZ_NOVISIT_INPUT_LISTPOPUP_JOBCLASS
};

@interface SHBLoanBizNoVisitInputViewController () <SHBListPopupViewDelegate>

@property (retain, nonatomic) NSMutableArray *dwellingList; // 주거소유
@property (retain, nonatomic) NSMutableArray *postDeliveryList; // 우편 송달
@property (retain, nonatomic) NSMutableArray *jobFamilyList; // 직종
@property (retain, nonatomic) NSMutableArray *job1List; // 직업1
@property (retain, nonatomic) NSMutableArray *job2List; // 직업2
@property (retain, nonatomic) NSMutableArray *job3List; // 직업3
@property (retain, nonatomic) NSMutableArray *job4List; // 직업4
@property (retain, nonatomic) NSMutableArray *positionList; // 직위
@property (retain, nonatomic) NSMutableArray *dutyList; // 직무
@property (retain, nonatomic) NSMutableArray *jobClassList; // 직업구분

@property (retain, nonatomic) NSMutableDictionary *selectDwellingDic; // 주거소유
@property (retain, nonatomic) NSMutableDictionary *selectPostDeliveryDic; // 우편 송달
@property (retain, nonatomic) NSMutableDictionary *selectJobFamilyDic; // 직종
@property (retain, nonatomic) NSMutableDictionary *selectJob1Dic; // 직업1
@property (retain, nonatomic) NSMutableDictionary *selectJob2Dic; // 직업2
@property (retain, nonatomic) NSMutableDictionary *selectJob3Dic; // 직업3
@property (retain, nonatomic) NSMutableDictionary *selectJob4Dic; // 직업4
@property (retain, nonatomic) NSMutableDictionary *selectPositionDic; // 직위
@property (retain, nonatomic) NSMutableDictionary *selectDutyDic; // 직무
@property (retain, nonatomic) NSMutableDictionary *selectJobClassDic; // 직업구분

@property (retain, nonatomic) NSArray *textFieldList;

@end

@implementation SHBLoanBizNoVisitInputViewController

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
    
    [self setTitle:@"직장인 무방문 신용대출"];
    self.strBackButtonTitle = @"직장인 최적상품(무방문대출) 신청 인적사항 확인";
    
    [_subTitleView initFrame:_subTitleView.frame];
    [_subTitleView setCaptionText:@"직장인 최적상품(무방문대출) 신청"];
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    self.textFieldList = @[ _email, _child, _bizLicense, _companyName, _department, _employee ];
    
    [self setTextFieldTagOrder:_textFieldList];
    
    [self setListData];
    
    // 입사일자
    [_dateField initFrame:_dateField.frame];
    [_dateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_dateField.textField setTextColor:RGB(44, 44, 44)];
    [_dateField.textField setTextAlignment:UITextAlignmentLeft];
    [_dateField.textField setPlaceholder:@"(필수)"];
    [_dateField.textField setAccessibilityLabel:@"입사일자 입력창"];
    [_dateField setDelegate:self];
    
    [self clearViewData];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:self.data];
    [self.binder bind:self dataSet:dataSet];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
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
    self.C2800Dic = nil;
    
    self.dwellingList = nil;
    self.postDeliveryList = nil;
    self.jobFamilyList = nil;
    self.job1List = nil;
    self.job2List = nil;
    self.job3List = nil;
    self.job4List = nil;
    self.positionList = nil;
    self.dutyList = nil;
    self.jobClassList = nil;
    
    self.selectDwellingDic = nil;
    self.selectPostDeliveryDic = nil;
    self.selectJobFamilyDic = nil;
    self.selectJob1Dic = nil;
    self.selectJob2Dic = nil;
    self.selectJob3Dic = nil;
    self.selectJob4Dic = nil;
    self.selectPositionDic = nil;
    self.selectDutyDic = nil;
    self.selectJobClassDic = nil;
    
    self.textFieldList = nil;
    
    [_subTitleView release];
    [_mainView release];
    [_email release];
    [_dwellingBtn release];
    [_smsChkBtn release];
    [_postDeliveryBtn release];
    [_spouseChkBtn release];
    [_fatherChkBtn release];
    [_motherChkBtn release];
    [_childChkBtn release];
    [_child release];
    [_brotherChkBtn release];
    [_otherChkBtn release];
    [_noneChkBtn release];
    [_bizLicense release];
    [_publicOfficialChkBtn release];
    [_jobFamilyBtn release];
    [_job1Btn release];
    [_job2Btn release];
    [_job3Btn release];
    [_job4Btn release];
    [_positionBtn release];
    [_dutyBtn release];
    [_dateField release];
    [_jobClassBtn release];
    [_companyName release];
    [_department release];
    [_employee release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSubTitleView:nil];
    [self setMainView:nil];
    [self setEmail:nil];
    [self setDwellingBtn:nil];
    [self setSmsChkBtn:nil];
    [self setPostDeliveryBtn:nil];
    [self setFatherChkBtn:nil];
    [self setMotherChkBtn:nil];
    [self setChildChkBtn:nil];
    [self setChild:nil];
    [self setBrotherChkBtn:nil];
    [self setOtherChkBtn:nil];
    [self setNoneChkBtn:nil];
    [self setBizLicense:nil];
    [self setPublicOfficialChkBtn:nil];
    [self setJobFamilyBtn:nil];
    [self setJob1Btn:nil];
    [self setJob2Btn:nil];
    [self setJob3Btn:nil];
    [self setJob4Btn:nil];
    [self setPositionBtn:nil];
    [self setDutyBtn:nil];
    [self setDateField:nil];
    [self setJobClassBtn:nil];
    [self setCompanyName:nil];
    [self setDepartment:nil];
    [self setEmployee:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (void)clearViewData
{
    [self setListData];
    
    [_email setText:@""];
    
    // 주거소유
    self.selectDwellingDic = nil;
    
    [self setButton:_dwellingBtn withTitle:@"선택하세요"];
    
    for (NSMutableDictionary *dic in _dwellingList) {
        
        if ([dic[@"CODE"] isEqualToString:self.data[@"주거구분"]]) {
            
            self.selectDwellingDic = dic;
            
            [self setButton:_dwellingBtn withTitle:_selectDwellingDic[@"1"]];
            
            break;
        }
    }
    
    // 우편송달
    self.selectPostDeliveryDic = _postDeliveryList[0];
    
    [self setButton:_postDeliveryBtn withTitle:_selectPostDeliveryDic[@"1"]];
    
    for (NSMutableDictionary *dic in _postDeliveryList) {
        
        if ([dic[@"CODE"] isEqualToString:self.data[@"우편통지장소CODE"]]) {
            
            self.selectPostDeliveryDic = dic;
            
            [self setButton:_postDeliveryBtn withTitle:_selectPostDeliveryDic[@"1"]];
            
            break;
        }
    }
    
    [_spouseChkBtn setSelected:NO];
    [_fatherChkBtn setSelected:NO];
    [_motherChkBtn setSelected:NO];
    [_childChkBtn setSelected:NO];
    [_brotherChkBtn setSelected:NO];
    [_otherChkBtn setSelected:NO];
    [_noneChkBtn setSelected:NO];
    
    [_spouseChkBtn setEnabled:YES];
    [_fatherChkBtn setEnabled:YES];
    [_motherChkBtn setEnabled:YES];
    [_childChkBtn setEnabled:YES];
    [_child setEnabled:NO];
    [_brotherChkBtn setEnabled:YES];
    [_otherChkBtn setEnabled:YES];
    [_noneChkBtn setEnabled:YES];
    
    [_child setText:@""];
    
    if (_isSelectInfoAgree) {
        
        if ([self.data[@"동거인무여부"] isEqualToString:@"1"]) {
            
            [_noneChkBtn setSelected:YES];
        }
        else {
            
            if ([self.data[@"배우자동거여부"] isEqualToString:@"1"]) {
                
                [_spouseChkBtn setSelected:YES];
            }
            
            if ([self.data[@"부친동거여부"] isEqualToString:@"1"]) {
                
                [_fatherChkBtn setSelected:YES];
            }
            
            if ([self.data[@"모동거여부"] isEqualToString:@"1"]) {
                
                [_motherChkBtn setSelected:YES];
            }
            
            if ([self.data[@"자녀동거여부"] isEqualToString:@"1"]) {
                
                [_childChkBtn setSelected:YES];
                
                [_child setEnabled:YES];
                [_child setText:self.data[@"자녀인원수"]];
            }
            
            if ([self.data[@"형제자매동거여부"] isEqualToString:@"1"]) {
                
                [_brotherChkBtn setSelected:YES];
            }
            
            if ([self.data[@"기타동거여부"] isEqualToString:@"1"]) {
                
                [_otherChkBtn setSelected:YES];
            }
        }
    }
    else {
        
        [_spouseChkBtn setEnabled:NO];
        [_fatherChkBtn setEnabled:NO];
        [_motherChkBtn setEnabled:NO];
        [_childChkBtn setEnabled:NO];
        [_child setEnabled:NO];
        [_child setText:@""];
        [_brotherChkBtn setEnabled:NO];
        [_otherChkBtn setEnabled:NO];
        [_noneChkBtn setEnabled:NO];
    }
    
    // 본사 사업자 등록번호
    [_bizLicense setText:[NSString stringWithFormat:@"%@%@%@",
                          [SHBUtility nilToString:self.data[@"직장사업자번호1"]],
                          [SHBUtility nilToString:self.data[@"직장사업자번호2"]],
                          [SHBUtility nilToString:self.data[@"직장사업자번호3"]]]];
    
    // 공무원
    [_publicOfficialChkBtn setSelected:NO];
    
    // 직종구분
    self.selectJobFamilyDic = nil;
    
    [self setButton:_jobFamilyBtn withTitle:@"선택하세요"];
    
    for (NSMutableDictionary *dic in _jobFamilyList) {
        
        if ([dic[@"CODE"] isEqualToString:self.data[@"고용형태구분"]]) {
            
            self.selectJobFamilyDic = dic;
            
            [self setButton:_jobFamilyBtn withTitle:_selectJobFamilyDic[@"1"]];
            
            break;
        }
    }
    
    // 직업
    self.selectJob1Dic = nil;
    self.selectJob2Dic = nil;
    self.selectJob3Dic = nil;
    self.selectJob4Dic = nil;
    self.selectPositionDic = nil;
    
    [self setButton:_job1Btn withTitle:@"선택하세요"];
    [self setButton:_job2Btn withTitle:@"선택하세요"];
    [self setButton:_job3Btn withTitle:@"선택하세요"];
    [self setButton:_job4Btn withTitle:@"선택하세요"];
    [self setButton:_positionBtn withTitle:@"선택하세요"];
    
    [_job1Btn setEnabled:YES];
    [_job2Btn setEnabled:NO];
    [_job3Btn setEnabled:NO];
    [_job4Btn setEnabled:NO];
    [_positionBtn setEnabled:NO];
    
    // 직무
    self.selectDutyDic = nil;
    
    [self setButton:_dutyBtn withTitle:@"선택하세요"];
    
    for (NSMutableDictionary *dic in _dutyList) {
        
        if ([dic[@"CODE"] isEqualToString:self.data[@"직무CODE"]]) {
            
            self.selectDutyDic = dic;
            
            [self setButton:_dutyBtn withTitle:_selectDutyDic[@"1"]];
            
            break;
        }
    }
    
    [_dateField.textField setText:[SHBUtility getDateWithDash:self.data[@"입사일자"]]];
    
    // 직업구분
    self.selectJobClassDic = nil;
    
    [self setButton:_jobClassBtn withTitle:@"선택하세요"];
    
    for (NSMutableDictionary *dic in _jobClassList) {
        
        if ([dic[@"CODE"] isEqualToString:self.data[@"직업구분"]]) {
            
            self.selectJobClassDic = dic;
            
            [self setButton:_jobClassBtn withTitle:_selectJobClassDic[@"1"]];
            
            break;
        }
    }
    
    [_companyName setText:[SHBUtility nilToString:self.data[@"직장명"]]];
    [_department setText:[SHBUtility nilToString:self.data[@"직장부서명"]]];
    [_employee setText:[SHBUtility nilToString:self.data[@"직위명"]]];
}

- (void)setListData
{
    self.dwellingList = [NSMutableArray arrayWithArray:@[ @{ @"1" : @"무응답", @"CODE" : @"0", },
                                                          @{ @"1" : @"자택(본인소유)", @"CODE" : @"1", },
                                                          @{ @"1" : @"자택(배우자소유)", @"CODE" : @"2", },
                                                          @{ @"1" : @"자택(공동소유)", @"CODE" : @"3", },
                                                          @{ @"1" : @"자택(가족소유)", @"CODE" : @"4", },
                                                          @{ @"1" : @"전세", @"CODE" : @"5", },
                                                          @{ @"1" : @"월세", @"CODE" : @"6", },
                                                          @{ @"1" : @"기타(기숙사, 하숙 등)", @"CODE" : @"8", }, ]];
    self.postDeliveryList = [NSMutableArray arrayWithArray:@[ @{ @"1" : @"자택", @"CODE" : @"1", },
                                                              @{ @"1" : @"직장", @"CODE" : @"2", },
                                                              @{ @"1" : @"발송안함", @"CODE" : @"9", }, ]];
    self.jobFamilyList = [NSMutableArray arrayWithArray:@[ @{ @"1" : @"정규직", @"CODE" : @"1", },
                                                           @{ @"1" : @"기타직", @"CODE" : @"3", }, ]];
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
    self.jobClassList = [NSMutableArray arrayWithArray:@[ @{ @"1" : @"무응답", @"CODE" : @"0", },
                                                          @{ @"1" : @"급여소득자", @"CODE" : @"1", },
                                                          @{ @"1" : @"전문직(자격증보유)", @"CODE" : @"2", },
                                                          @{ @"1" : @"자영업자", @"CODE" : @"3", },
                                                          @{ @"1" : @"신한금융그룹", @"CODE" : @"4", },
                                                          @{ @"1" : @"연금소득자", @"CODE" : @"5", },
                                                          @{ @"1" : @"주부", @"CODE" : @"6", },
                                                          @{ @"1" : @"학생", @"CODE" : @"7", },
                                                          @{ @"1" : @"무직기타", @"CODE" : @"9", }, ]];
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
    if (!_selectJob1Dic || [_job1Btn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"직업을 선택해 주세요.";
    }
    
    if (!_selectJob2Dic || [_job2Btn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"직업을 선택해 주세요.";
    }
    
    if (!_selectJob3Dic || [_job3Btn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"직업을 선택해 주세요.";
    }
    
    if ([_job4Btn isEnabled] &&
        (!_selectJob4Dic || [_job4Btn.titleLabel.text isEqualToString:@"선택하세요"])) {
        
        return @"직업을 선택해 주세요.";
    }
    
    if (!_selectPositionDic || [_positionBtn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"직위를 선택해 주세요.";
    }
    
    return @"";
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
            
        case 10: {
            
            // 주거소유
            
            [self showPopupView:@"주거소유" withOptions:_dwellingList withTag:BIZ_NOVISIT_INPUT_LISTPOPUP_DWELLING];
        }
            break;
            
        case 20: {
            
            // SMS수신여부
            
            [sender setSelected:![sender isSelected]];
        }
            break;
            
        case 30: {
            
            // 우편 송달
            
            [self showPopupView:@"우편 송달" withOptions:_postDeliveryList withTag:BIZ_NOVISIT_INPUT_LISTPOPUP_POSTDELIVERY];
        }
            break;
            
        case 41: {
            
            // 배우자
            
            [sender setSelected:![sender isSelected]];
            
            if ([sender isSelected]) {
                
                [_noneChkBtn setSelected:NO];
            }
        }
            break;
            
        case 42: {
            
            // 부
            
            [sender setSelected:![sender isSelected]];
            
            if ([sender isSelected]) {
                
                [_noneChkBtn setSelected:NO];
            }
        }
            break;
            
        case 43: {
            
            // 모
            
            [sender setSelected:![sender isSelected]];
            
            if ([sender isSelected]) {
                
                [_noneChkBtn setSelected:NO];
            }
        }
            break;
            
        case 44: {
            
            // 자녀
            
            [sender setSelected:![sender isSelected]];
            
            if ([sender isSelected]) {
                
                [_child setText:@""];
                [_child setEnabled:YES];
                
                [_noneChkBtn setSelected:NO];
            }
            else {
                
                [_child setText:@"0"];
                [_child setEnabled:NO];
            }
            
            [self setTextFieldTagOrder:_textFieldList];
        }
            break;
            
        case 45: {
            
            // 형제자매
            
            [sender setSelected:![sender isSelected]];
            
            if ([sender isSelected]) {
                
                [_noneChkBtn setSelected:NO];
            }
        }
            break;
            
        case 46: {
            
            // 기타
            
            [sender setSelected:![sender isSelected]];
            
            if ([sender isSelected]) {
                
                [_noneChkBtn setSelected:NO];
            }
        }
            break;
            
        case 47: {
            
            // 없음
            
            [sender setSelected:![sender isSelected]];
            
            if ([sender isSelected]) {
                
                [_spouseChkBtn setSelected:NO];
                [_fatherChkBtn setSelected:NO];
                [_motherChkBtn setSelected:NO];
                [_childChkBtn setSelected:NO];
                [_brotherChkBtn setSelected:NO];
                [_otherChkBtn setSelected:NO];
                
                [_child setText:@"0"];
                [_child setEnabled:NO];
            }
            
            [self setTextFieldTagOrder:_textFieldList];
        }
            break;
            
        case 50: {
            
            // 공무원
            
            [sender setSelected:![sender isSelected]];
            
            if ([sender isSelected]) {
                
                [_bizLicense setText:@""];
            }
        }
            break;
            
        case 60: {
            
            // 직종
            
            [self showPopupView:@"직종" withOptions:_jobFamilyList withTag:BIZ_NOVISIT_INPUT_LISTPOPUP_JOB_FAMILY];
        }
            break;
            
        case 70: {
            
            // 직업1
            
            [self showPopupView:@"직업" withOptions:_job1List withTag:BIZ_NOVISIT_INPUT_LISTPOPUP_JOB1];
        }
            break;
            
        case 71: {
            
            // 직업2
            
            [self showPopupView:@"대분류" withOptions:_job2List withTag:BIZ_NOVISIT_INPUT_LISTPOPUP_JOB2];
        }
            break;
            
        case 72: {
            
            // 직업3
            
            [self showPopupView:@"중분류" withOptions:_job3List withTag:BIZ_NOVISIT_INPUT_LISTPOPUP_JOB3];
        }
            break;
            
        case 73: {
            
            // 직업4
            
            [self showPopupView:@"소분류" withOptions:_job4List withTag:BIZ_NOVISIT_INPUT_LISTPOPUP_JOB4];
        }
            break;
            
        case 80: {
            
            // 직위
            
            [self showPopupView:@"직위" withOptions:_positionList withTag:BIZ_NOVISIT_INPUT_LISTPOPUP_POSITION];
        }
            break;
            
        case 90: {
            
            // 직무
            
            [self showPopupView:@"직무" withOptions:_dutyList withTag:BIZ_NOVISIT_INPUT_LISTPOPUP_DUTY];
        }
            break;
            
        case 100: {
            
            // 직업구분
            
            [self showPopupView:@"직업구분" withOptions:_jobClassList withTag:BIZ_NOVISIT_INPUT_LISTPOPUP_JOBCLASS];
        }
            break;
            
        case 1000: {
            
            // 확인
            
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
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.sphone.task.loan.LoanTask",
                                      TASK_ACTION_KEY : @"L3661InChkStep1",
                                      @"g선택정보동의여부" : _isSelectInfoAgree ? @"Y" : @"N",
                                      @"고객번호" : AppInfo.customerNo,
                                      @"고객명" : [SHBUtility nilToString:self.data[@"고객명"]],
                                      @"직업CODE" : _selectJob4Dic ? [SHBUtility nilToString:_selectJob4Dic[@"JIKEOB_CODE"]]
                                      : [SHBUtility nilToString:_selectJob3Dic[@"JIKEOB_CODE"]],
                                      @"직위CODE" : jikwi,
                                      @"고용형태구분" : [SHBUtility nilToString:_selectJobFamilyDic[@"CODE"]],
                                      @"직장사업자번호" : [SHBUtility nilToString:_bizLicense.text],
                                      @"공무원여부" : [_publicOfficialChkBtn isSelected] ? @"1" : @"0",
                                      @"입사일자" : [SHBUtility nilToString:_dateField.textField.text],
                                      @"직무CODE" : [SHBUtility nilToString:_selectDutyDic[@"CODE"]],
                                      @"주거소유CODE" : [SHBUtility nilToString:_selectDwellingDic[@"CODE"]],
                                      @"우편통지장소CODE" : [SHBUtility nilToString:_selectPostDeliveryDic[@"CODE"]],
                                      @"배우자동거여부" : [_spouseChkBtn isSelected] ? @"1" : @"0",
                                      @"부친동거여부" : [_fatherChkBtn isSelected] ? @"1" : @"0",
                                      @"모동거여부" : [_motherChkBtn isSelected] ? @"1" : @"0",
                                      @"자녀동거여부" : [_childChkBtn isSelected] ? @"1" : @"0",
                                      @"자녀인원수" : [[SHBUtility nilToString:_child.text] length] != 0 ? [SHBUtility nilToString:_child.text]
                                      : @"0",
                                      @"형제자매동거여부" : [_brotherChkBtn isSelected] ? @"1" : @"0",
                                      @"기타동거여부" : [_otherChkBtn isSelected] ? @"1" : @"0",
                                      @"동거인무여부" : [_noneChkBtn isSelected] ? @"1" : @"0",
                                      @"직업구분" : [SHBUtility nilToString:_selectJobClassDic[@"CODE"]],
                                      @"직장명" : [SHBUtility nilToString:_companyName.text],
                                      @"직장부서명" : [SHBUtility nilToString:_department.text],
                                      @"직위명" : [SHBUtility nilToString:_employee.text],
                                      @"주거구분" : [SHBUtility nilToString:_selectDwellingDic[@"CODE"]],
                                      @"이메일주소" : [SHBUtility nilToString:_email.text],
                                      @"SMS수신여부" : @"1",
                                      @"이동통신번호_통신회사" : [SHBUtility nilToString:self.data[@"이동통신번호통신회사"]],
                                      @"이동통신번호_국" : [SHBUtility nilToString:self.data[@"이동통신번호국"]],
                                      @"이동통신번호_일련번호" : [SHBUtility nilToString:self.data[@"이동통신번호일련번호"]],
                                      @"자택전화지역번호" : [SHBUtility nilToString:self.data[@"자택전화지역번호"]],
                                      @"자택전화국번호" : [SHBUtility nilToString:self.data[@"자택전화국번호"]],
                                      @"자택전화통신일련번호" : [SHBUtility nilToString:self.data[@"자택전화통신일련번호"]],
                                      @"자택우편번호" : [SHBUtility nilToString:[self.data[@"_자택우편번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""]],
                                      @"자택주소동명" : [SHBUtility nilToString:self.data[@"자택동주소명"]],
                                      @"자택동미만주소" : [SHBUtility nilToString:self.data[@"자택동미만주소"]],
                                      @"자택주소종류" : [SHBUtility nilToString:self.data[@"고객_자택주소종류"]],
                                      @"자택도로명주소참조KEY번호" : [SHBUtility nilToString:self.data[@"고객_자택도로명주소참조KEY"]],
                                      @"직장전화지역번호" : [SHBUtility nilToString:self.data[@"직장전화지역번호"]],
                                      @"직장전화국번호" : [SHBUtility nilToString:self.data[@"직장전화국번호"]],
                                      @"직장전화통신일련번호" : [SHBUtility nilToString:self.data[@"직장전화통신일련번호"]],
                                      @"직장내선전화통신번호" : [SHBUtility nilToString:self.data[@"직장내선전화통신번호"]],
                                      @"직장우편번호" : [SHBUtility nilToString:[self.data[@"_직장우편번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""]],
                                      @"직장주소동명" : [SHBUtility nilToString:self.data[@"직장동주소명"]],
                                      @"직장동미만주소" : [SHBUtility nilToString:self.data[@"직장동미만주소"]],
                                      @"직장주소종류" : [SHBUtility nilToString:self.data[@"고객_직장주소종류"]],
                                      @"직장도로명주소참조KEY번호" : [SHBUtility nilToString:self.data[@"고객_직장도로명주소참조KEY"]],
                                      }];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_INPUT_CHECK1_SERVICE
                                                       viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case 2000: {
            
            // 취소
            
            for (SHBLoanBizNoVisitStipulationViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[SHBLoanBizNoVisitStipulationViewController class]]) {
                    
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
            
        case LOAN_INPUT_CHECK1_SERVICE: {
            
            NSString *jikwi = [SHBUtility nilToString:_selectPositionDic[@"JIKWI_CODE"]];
            
            if ([jikwi length] >= 1) {
                
                jikwi = [jikwi substringFromIndex:[_selectPositionDic[@"JIKWI_CODE"] length] - 1];
            }
            else {
                
                jikwi = @"0";
            }
            
            [aDataSet removeObjectForKey:@"VERSION"];
            [aDataSet removeObjectForKey:@"COM_SUBCHN_KBN"];
            
            SHBLoanBizNoVisitInput2ViewController *viewController = [[[SHBLoanBizNoVisitInput2ViewController alloc] initWithNibName:@"SHBLoanBizNoVisitInput2ViewController" bundle:nil] autorelease];
            
            viewController.data = self.data;
            viewController.inputData = [NSMutableDictionary dictionaryWithDictionary:aDataSet];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
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
            
        default:
            break;
    }
    
    return YES;
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    switch ([listPopView tag]) {
            
        case BIZ_NOVISIT_INPUT_LISTPOPUP_DWELLING: {
            
            // 주거소유
            
            self.selectDwellingDic = _dwellingList[anIndex];
            
            [self setButton:_dwellingBtn withTitle:_selectDwellingDic[@"1"]];
        }
            break;
            
        case BIZ_NOVISIT_INPUT_LISTPOPUP_POSTDELIVERY: {
            
            // 우편 송달
            
            self.selectPostDeliveryDic = _postDeliveryList[anIndex];
            
            [self setButton:_postDeliveryBtn withTitle:_selectPostDeliveryDic[@"1"]];
        }
            break;
            
        case BIZ_NOVISIT_INPUT_LISTPOPUP_JOB_FAMILY: {
            
            // 직종
            
            self.selectJobFamilyDic = _jobFamilyList[anIndex];
            
            [self setButton:_jobFamilyBtn withTitle:_selectJobFamilyDic[@"1"]];
        }
            break;
            
        case BIZ_NOVISIT_INPUT_LISTPOPUP_JOB1: {
            
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
            
        case BIZ_NOVISIT_INPUT_LISTPOPUP_JOB2: {
            
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
            
        case BIZ_NOVISIT_INPUT_LISTPOPUP_JOB3: {
            
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
            
        case BIZ_NOVISIT_INPUT_LISTPOPUP_JOB4: {
            
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
            
        case BIZ_NOVISIT_INPUT_LISTPOPUP_POSITION: {
            
            // 직위
            
            self.selectPositionDic = _positionList[anIndex];
            
            [self setButton:_positionBtn withTitle:_selectPositionDic[@"1"]];
        }
            break;
            
        case BIZ_NOVISIT_INPUT_LISTPOPUP_DUTY: {
            
            // 직무
            
            self.selectDutyDic = _dutyList[anIndex];
            
            [self setButton:_dutyBtn withTitle:_selectDutyDic[@"1"]];
        }
            break;
            
        case BIZ_NOVISIT_INPUT_LISTPOPUP_JOBCLASS: {
            
            // 직업구분
            
            self.selectJobClassDic = _jobClassList[anIndex];
            
            [self setButton:_jobClassBtn withTitle:_selectJobClassDic[@"1"]];
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
    
    if (textField == _email) {
        
        NSString *SPECIAL_CHAR2 = @"$₩€£¥•!#$%^&*()-_=+{}|[]\\;:\'\"<>?,/`~";
        
        NSCharacterSet *cs2 = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR2] invertedSet];
        NSString *filtered2 = [[string componentsSeparatedByCharactersInSet:cs2] componentsJoinedByString:@""];
        BOOL basicTest2 = [string isEqualToString:filtered2];
        
        if (basicTest2 && [string length] > 0) {
            
            return NO;
        }
        
        if (dataLength + dataLength2 > 50) {
            
            return NO;
        }
        
        return YES;
    }
    else if (textField == _child) {
        
        // 자녀수
        
        if ([textField.text length] >= 2 && range.length == 0) {
            
            return NO;
        }
    }
    else if (textField == _bizLicense) {
        
        // 본사 사업자 등록번호
        
        if ([textField.text length] >= 12 && range.length == 0) {
            
            return NO;
        }
    }
    else if (textField == _companyName || textField == _department || textField == _employee) {
        
        // 직장명/상호, 근무부서, 직원/직함
        
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

@end
