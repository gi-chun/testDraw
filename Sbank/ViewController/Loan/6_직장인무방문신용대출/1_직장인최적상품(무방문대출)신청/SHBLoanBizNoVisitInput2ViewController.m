//
//  SHBLoanBizNoVisitInput2ViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitInput2ViewController.h"
#import "SHBLoanService.h" // service
#import "SHBListPopupView.h" // list popup
#import "SHBAccidentPopupView.h" // popup

#import "SHBLoanBizNoVisitInputViewController.h" // 직장인 최적상품(무방문대출) 신청 인적사항 확인
#import "SHBSimpleLoanBranchSearchViewController.h" // 약정업체 간편대출 - 영업점조회
#import "SHBAskStaffViewController.h" // 권유직원조회
#import "SHBLoanBizNoVisitResultViewController.h" // 직장인 최적상품(무방문대출) 신청

/// list popup tag
enum BIZ_NOVISIT_INPUT2_LISTPOPUP_TAG {
    
    BIZ_NOVISIT_INPUT2_LISTPOPUP_LOANTYPE = 1701,
    BIZ_NOVISIT_INPUT2_LISTPOPUP_USE,
    BIZ_NOVISIT_INPUT2_LISTPOPUP_PLAN,
    BIZ_NOVISIT_INPUT2_LISTPOPUP_TRANSFER_ACCOUNT
};

@interface SHBLoanBizNoVisitInput2ViewController () <SHBListPopupViewDelegate, SHBSimpleLoanBranchSearchDelegate>

@property (retain, nonatomic) SHBAccidentPopupView *popupView;

@property (retain, nonatomic) NSMutableArray *loanTypeList; // 대출방식
@property (retain, nonatomic) NSMutableArray *useList; // 자금용도
@property (retain, nonatomic) NSMutableArray *planList; // 상환계획
@property (retain, nonatomic) NSMutableArray *transferAccountList; // 입금계좌번호

@property (retain, nonatomic) NSMutableDictionary *selectLoanTypeDic; // 대출방식
@property (retain, nonatomic) NSMutableDictionary *selectUseDic; // 자금용도
@property (retain, nonatomic) NSMutableDictionary *selectPlanDic; // 상환계획
@property (retain, nonatomic) NSMutableDictionary *selectTransferAccountDic; // 입금계좌번호
@property (retain, nonatomic) NSMutableDictionary *selectCanvarsser; // 권유자행번
@property (retain, nonatomic) NSMutableDictionary *selectBranch; // 대출희망지점

@property (retain, nonatomic) SHBDataSet *L3661SendDic;

@property (retain, nonatomic) NSArray *textFieldList;

@end

@implementation SHBLoanBizNoVisitInput2ViewController

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
    
    [self setTitle:@"직장인 무방문 신용대출"];
    self.strBackButtonTitle = @"직장인 최적상품(무방문대출) 신청 대출관련사항";
    
    [_subTitleView initFrame:_subTitleView.frame];
    [_subTitleView setCaptionText:@"직장인 최적상품(무방문대출) 신청"];
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    self.textFieldList = @[ _annualIncome, _generalIncomeTax,
                            _shbTotalLoan, _shbBizLoan,
                            _otherLoanCount, _otherTotalLoan, _otherBizLoan,
                            _use, _wishBranch, _plan, _canvasserNo ];
    
    [self setTextFieldTagOrder:_textFieldList];
    
    [self setListData];
    
    // 대출희망일자
    [_wishDate initFrame:_wishDate.frame];
    [_wishDate.textField setFont:[UIFont systemFontOfSize:15]];
    [_wishDate.textField setTextColor:RGB(44, 44, 44)];
    [_wishDate.textField setTextAlignment:UITextAlignmentLeft];
    [_wishDate.textField setPlaceholder:@"(필수)"];
    [_wishDate.textField setAccessibilityLabel:@"대출희망일자 입력창"];
    [_wishDate setDelegate:self];
    
    // 이자이체일자
    [_transferDate initFrame:_transferDate.frame];
    [_transferDate.textField setFont:[UIFont systemFontOfSize:15]];
    [_transferDate.textField setTextColor:RGB(44, 44, 44)];
    [_transferDate.textField setTextAlignment:UITextAlignmentLeft];
    [_transferDate.textField setPlaceholder:@"(필수)"];
    [_transferDate.textField setAccessibilityLabel:@"이자이체일자 입력창"];
    [_transferDate setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.inputData = nil;
    self.C2800Dic = nil;
    
    self.loanTypeList = nil;
    self.useList = nil;
    self.planList = nil;
    self.transferAccountList = nil;
    
    self.selectLoanTypeDic = nil;
    self.selectUseDic = nil;
    self.selectPlanDic = nil;
    self.selectTransferAccountDic = nil;
    self.selectCanvarsser = nil;
    self.selectBranch = nil;
    
    self.L3661SendDic = nil;
    
    self.textFieldList = nil;
    
    [_subTitleView release];
    [_mainView release];
    [_annualIncome release];
    [_generalIncomeTax release];
    [_shbTotalLoan release];
    [_shbBizLoan release];
    [_otherLoanCount release];
    [_otherTotalLoan release];
    [_otherBizLoan release];
    [_loanTypeBtn release];
    [_wishDate release];
    [_useBtn release];
    [_wishBranch release];
    [_planBtn release];
    [_transferAccount release];
    [_transferDate release];
    [_canvasserNo release];
    [_use release];
    [_plan release];
    [_infoView1 release];
    [_infoView2 release];
    [_infoView3 release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSubTitleView:nil];
    [self setMainView:nil];
    [self setAnnualIncome:nil];
    [self setGeneralIncomeTax:nil];
    [self setShbTotalLoan:nil];
    [self setShbBizLoan:nil];
    [self setOtherLoanCount:nil];
    [self setOtherTotalLoan:nil];
    [self setOtherBizLoan:nil];
    [self setLoanTypeBtn:nil];
    [self setWishDate:nil];
    [self setUseBtn:nil];
    [self setWishBranch:nil];
    [self setPlanBtn:nil];
    [self setTransferDate:nil];
    [self setCanvasserNo:nil];
    [super viewDidUnload];
}

#pragma mark - Notification

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        
        SHBLoanBizNoVisitResultViewController *viewController = [[[SHBLoanBizNoVisitResultViewController alloc] initWithNibName:@"SHBLoanBizNoVisitResultViewController" bundle:nil] autorelease];
        viewController.L3661Dic = [NSMutableDictionary dictionaryWithDictionary:notification.userInfo];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)electronicSignCancel
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
                                             selector:@selector(electronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(electronicSignCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
}

- (void)setListData
{
    self.loanTypeList = [NSMutableArray arrayWithArray:@[ @{ @"1" : @"한도(마이너스)대출", @"CODE" : @"3" },
                                                          @{ @"1" : @"건별대출", @"CODE" : @"1" } ]];
    
    self.useList = [NSMutableArray arrayWithArray:@[ @{ @"1" : @"주택구입(소유권 이전등기일로부터 3개월이 경과하지 않은 대출)", @"CODE" : @"11" },
                                                     @{ @"1" : @"주택구입(분양주택 중도금대출 및 재건축주택 이주비 대출)", @"CODE" : @"12" },
                                                     @{ @"1" : @"주택구입(소유권 이전등기후 3개월경과, 여타주택 구입자금 등)", @"CODE" : @"13" },
                                                     @{ @"1" : @"전세자금반환용", @"CODE" : @"21" },
                                                     @{ @"1" : @"주택임차(전월세)", @"CODE" : @"22" },
                                                     @{ @"1" : @"주택신축 및 개량", @"CODE" : @"23" },
                                                     @{ @"1" : @"생계자금", @"CODE" : @"24" },
                                                     @{ @"1" : @"내구소비재 구입자금", @"CODE" : @"25" },
                                                     @{ @"1" : @"학자금", @"CODE" : @"26" },
                                                     @{ @"1" : @"사업자금", @"CODE" : @"27" },
                                                     @{ @"1" : @"투자자금", @"CODE" : @"28" },
                                                     @{ @"1" : @"기차입금 상환자금", @"CODE" : @"31" },
                                                     @{ @"1" : @"공과금 및 세금납부", @"CODE" : @"41" },
                                                     @{ @"1" : @"기타(세부자금용도 입력필요)", @"CODE" : @"99" } ]];
    
    self.planList = [NSMutableArray arrayWithArray:@[ @{ @"1" : @"급여수익금", @"CODE" : @"1" },
                                                      @{ @"1" : @"사업소득", @"CODE" : @"2" },
                                                      @{ @"1" : @"퇴직금/연금", @"CODE" : @"3" },
                                                      @{ @"1" : @"예적금", @"CODE" : @"4" },
                                                      @{ @"1" : @"배당/임대소득", @"CODE" : @"5" },
                                                      @{ @"1" : @"부동산 매매대금", @"CODE" : @"6" },
                                                      @{ @"1" : @"기타(상환계획 입력필요)", @"CODE" : @"99" } ]];
    
    self.transferAccountList = [NSMutableArray array];
    
    for (NSMutableDictionary *dic in [self outAccountList]) {
        
        // S-more 계좌 제외
        if (![dic[@"상품코드"] isEqualToString:@"110003101"]) {
            
            [_transferAccountList addObject:dic];
        }
    }
    
    if ([_transferAccountList count] > 0) {
        
        self.selectTransferAccountDic = _transferAccountList[0];
        
        [self setButton:_transferAccount withTitle:_selectTransferAccountDic[@"2"]];
    }
    else {
        
        self.selectTransferAccountDic = nil;
        
        [self setButton:_transferAccount withTitle:@"계좌정보가 없습니다."];
    }
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
    
    NSString *cellNib = @"SHBExchangePopupNoMoreCell";
    NSInteger cellH = 32;
    NSInteger optCnt = 1;
    
    if (tag == BIZ_NOVISIT_INPUT2_LISTPOPUP_TRANSFER_ACCOUNT) {
        
        cellNib = @"SHBAccountListPopupCell";
        cellH = 50;
        optCnt = 2;
    }
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:title
                                                                   options:options
                                                                   CellNib:cellNib
                                                                     CellH:cellH
                                                               CellDispCnt:dispCnt
                                                                CellOptCnt:optCnt] autorelease];
    [popupView setDelegate:self];
    [popupView setTag:tag];
    [popupView showInView:self.navigationController.view animated:YES];
}

- (void)setDataDic:(SHBDataSet *)dataSet withTitle:(NSString *)title withData:(NSString *)data
{
    NSString *str = [[SHBUtility nilToString:data] stringByReplacingOccurrencesOfString:@"," withString:@""];
    SInt64 money = [str longLongValue];
    
    if (money == 0) {
        
        [dataSet insertObject:@"0" forKey:title atIndex:0];
    }
    else {
        
        if (![title isEqualToString:@"종합소득세금액"]) {
            
            money *= 1000000;
        }
        
        [dataSet insertObject:[NSString stringWithFormat:@"%lld", money]
                       forKey:title
                      atIndex:0];
    }
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
            
        case 10: {
            
            // 대출방식
            
            [self showPopupView:@"대출방식" withOptions:_loanTypeList withTag:BIZ_NOVISIT_INPUT2_LISTPOPUP_LOANTYPE];
        }
            break;
            
        case 20: {
            
            // 자금용도
            
            [self showPopupView:@"자금용도" withOptions:_useList withTag:BIZ_NOVISIT_INPUT2_LISTPOPUP_USE];
        }
            break;
            
        case 30: {
            
            // 대출희망지점 조회
            
            SHBSimpleLoanBranchSearchViewController *viewController = [[[SHBSimpleLoanBranchSearchViewController alloc] initWithNibName:@"SHBSimpleLoanBranchSearchViewController" bundle:nil] autorelease];
            
            [viewController setTitle:@"직장인 무방문 신용대출"];
            viewController.delegate = self;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 40: {
            
            // 상환계획
            
            [self showPopupView:@"상환계획" withOptions:_planList withTag:BIZ_NOVISIT_INPUT2_LISTPOPUP_PLAN];
        }
            break;
            
        case 50: {
            
            // 입금계좌번호
            
            [self showPopupView:@"입금계좌번호" withOptions:_transferAccountList withTag:BIZ_NOVISIT_INPUT2_LISTPOPUP_TRANSFER_ACCOUNT];
        }
            break;
            
        case 60: {
            
            // 권유자행번 조회
            
            SHBAskStaffViewController *staffViewController = [[[SHBAskStaffViewController alloc] initWithNibName:@"SHBAskStaffViewController" bundle:nil] autorelease];
            
            [staffViewController executeWithTitle:@"권유직원 조회" ReturnViewController:self];
            
            [self.navigationController pushFadeViewController:staffViewController];
        }
            break;
            
        case 1000: {
            
            // 조회
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                                   @{
                                     TASK_NAME_KEY : @"sfg.sphone.task.loan.LoanTask",
                                     TASK_ACTION_KEY : @"L3661InChkStep2",
                                     @"거래구분" : @"4",
                                     @"운용구분" : [SHBUtility nilToString:_selectLoanTypeDic[@"CODE"]],
                                     @"결혼구분" : [SHBUtility nilToString:self.data[@"결혼구분"]],
                                     @"학력구분" : [SHBUtility nilToString:self.data[@"학력구분"]],
                                     @"타행담보대출상환금액" : @"0",
                                     @"타행신용대출상환금액" : @"0",
                                     @"국민연금발급번호" : @"",
                                     @"국민연금발급일자" : @"",
                                     @"국민연금검증번호" : @"",
                                     @"홈택스발급번호" : @"",
                                     @"신청점번호" : [SHBUtility nilToString:_selectBranch[@"지점번호"]],
                                     @"신청번호" : @"",
                                     @"주거종류" : @"",
                                     @"주거면적" : [SHBUtility nilToString:self.data[@"주거면적"]],
                                     @"현주소거주기간" : @"",
                                     @"맞벌이구분" : [SHBUtility nilToString:self.data[@"맞벌이구분"]],
                                     @"자가승용차CODE" : [SHBUtility nilToString:self.data[@"자가승용차CODE"]],
                                     @"현주거래등급평가점수" : [SHBUtility nilToString:self.data[@"현주거래등급평가점수"]],
                                     @"취급희망일자" : [SHBUtility nilToString:_wishDate.textField.text],
                                     @"자금용도CODE" : [SHBUtility nilToString:_selectUseDic[@"CODE"]],
                                     @"입금계좌번호" : [SHBUtility nilToString:[_selectTransferAccountDic[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""]],
                                     @"이체일자" : [_selectLoanTypeDic[@"CODE"] isEqualToString:@"3"] ? @"" : [SHBUtility nilToString:_transferDate.textField.text],
                                     @"금감원자금용도CODE" : [SHBUtility nilToString:_selectUseDic[@"CODE"]],
                                     @"상환계획CODE" : [SHBUtility nilToString:_selectPlanDic[@"CODE"]],
                                     }];
            
            [dataSet addEntriesFromDictionary:_inputData];
            
            // 연소득금액
            [self setDataDic:dataSet withTitle:@"연소득금액" withData:_annualIncome.text];
            
            // 종합소득세
            [self setDataDic:dataSet withTitle:@"종합소득세금액" withData:_generalIncomeTax.text];
            
            // 신한은행 총 대출금액
            [self setDataDic:dataSet withTitle:@"총대출금액" withData:_shbTotalLoan.text];
            
            // 신한은행 총 담보대출금액
            [self setDataDic:dataSet withTitle:@"총담보대출금액" withData:_shbBizLoan.text];
            
            // 타 금융기관 대출받은 기관 수
            NSString *otherLoanCount = [SHBUtility nilToString:_otherLoanCount.text];
            
            if ([otherLoanCount length] == 0) {
                
                [dataSet insertObject:@"0" forKey:@"타기관대출신고건수" atIndex:0];
            }
            else {
                
                [dataSet insertObject:otherLoanCount forKey:@"타기관대출신고건수" atIndex:0];
            }
            
            // 타 금융기관 총 대출금액
            [self setDataDic:dataSet withTitle:@"타기관대출신고금액" withData:_otherTotalLoan.text];
            
            // 타 금융기관 담보대출금액
            [self setDataDic:dataSet withTitle:@"타기관담보대출금액" withData:_otherBizLoan.text];
            
            // 자금용도
            if ([_selectUseDic[@"CODE"] isEqualToString:@"99"] && [_use.text length] > 0) {
                
                [dataSet insertObject:_use.text forKey:@"금감원자금용도기타내용" atIndex:0];
            }
            else {
                
                [dataSet insertObject:@"" forKey:@"금감원자금용도기타내용" atIndex:0];
            }
            
            // 상환계획
            if ([_selectPlanDic[@"CODE"] isEqualToString:@"99"] && [_plan.text length] > 0) {
                
                [dataSet insertObject:_plan.text forKey:@"상환계획" atIndex:0];
            }
            else {
                
                [dataSet insertObject:@"" forKey:@"상환계획" atIndex:0];
            }
            
            // 권유자행번
            if (_selectCanvarsser && [_canvasserNo.text length] > 0) {
                
                [dataSet insertObject:_selectCanvarsser[@"행번"] forKey:@"권유자" atIndex:0];
            }
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_INPUT_CHECK2_SERVICE
                                                       viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        }
            break;
            
        case 2000: {
            
            // 취소
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            for (SHBLoanBizNoVisitInputViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[SHBLoanBizNoVisitInputViewController class]]) {
                    
                    [viewController clearViewData];
                    
                    [self.navigationController fadePopToViewController:viewController];
                    
                    break;
                }
            }
        }
            break;
            
        case 3001: {
            
            // 확인사항 확인
            
            [_popupView fadeOut];
            
            if ([_selectLoanTypeDic[@"CODE"] isEqualToString:@"3"]) {
                
                // 한도대출
                self.popupView = [[[SHBAccidentPopupView alloc] initWithTitle:@"확인사항"
                                                                SubViewHeight:_infoView3.frame.size.height + 6
                                                               setContentView:_infoView3] autorelease];
            }
            else {
                
                // 건별대출
                self.popupView = [[[SHBAccidentPopupView alloc] initWithTitle:@"확인사항"
                                                                SubViewHeight:_infoView2.frame.size.height + 6
                                                               setContentView:_infoView2] autorelease];
            }
            
            [_popupView showInView:self.navigationController.view animated:YES];
        }
            break;
            
        case 3002: {
            
            // 확인사항 수정
            
            [_popupView fadeOut];
        }
            break;
            
        case 3003: {
            
            // 건별대출, 한도대출 확인사항 확인
            
            [_popupView fadeOut];
            
            AppInfo.electronicSignString = @"";
            AppInfo.eSignNVBarTitle = @"직장인 무방문 신용대출";
            
            AppInfo.electronicSignCode = @"L3661";
            AppInfo.electronicSignTitle = @"최적상품 신용대출을 신규신청합니다.";
            
            [AppInfo addElectronicSign:@"다음 사항을 충분히 이해하고 본인 신용정보의 제공 및 조회에 동의하며 약정합니다."];
            [AppInfo addElectronicSign:@"1.은행여신거래기본약관(통장한도거래대출 및 가계당좌대출의 경우 관련 수신거래약관 포함)이 적용됨을 승인하고 본 약관 및 대출거래약정서(가계용)의 모든 내용에 대하여 충분히 이해하였음."];
            [AppInfo addElectronicSign:@"2.개인신용정보의 제공・조회 동의"];
            [AppInfo addElectronicSign:@"3.신청내용"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)대출일자: %@", [SHBUtility nilToString:_wishDate.textField.text]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)성명: %@", [SHBUtility nilToString:self.data[@"고객명"]]]];
            [AppInfo addElectronicSign:@"(4)신청정보: 최적상품신용대출 신규신청"];
            [AppInfo addElectronicSign:@"4.차입기관"];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceCode:@"L3661" viewController:self] autorelease];
            self.service.requestData = _L3661SendDic;
            [self.service start];
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
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if (self.service.serviceId == LOAN_INPUT_CHECK2_SERVICE) {
        
        [aDataSet removeObjectForKey:@"VERSION"];
        [aDataSet removeObjectForKey:@"COM_SUBCHN_KBN"];
        
        self.L3661SendDic = [SHBDataSet dictionaryWithDictionary:aDataSet];
        
        self.popupView = [[[SHBAccidentPopupView alloc] initWithTitle:@"확인사항"
                                                        SubViewHeight:_infoView1.frame.size.height + 6
                                                       setContentView:_infoView1] autorelease];
        
        [_popupView showInView:self.navigationController.view animated:YES];
    }
    
    return YES;
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    switch ([listPopView tag]) {
            
        case BIZ_NOVISIT_INPUT2_LISTPOPUP_LOANTYPE: {
            
            // 대출방식
            
            self.selectLoanTypeDic = _loanTypeList[anIndex];
            
            [self setButton:_loanTypeBtn withTitle:_selectLoanTypeDic[@"1"]];
            
            if ([_selectLoanTypeDic[@"CODE"] isEqualToString:@"3"]) {
                
                // 한도(마이너스)대출
                [_transferDate setEnabled:NO];
                [_transferDate.textField setText:@""];
                [_transferDate.textField setPlaceholder:@"(해당사항 없음)"];
            }
            else {
                
                [_transferDate setEnabled:YES];
                [_transferDate.textField setText:@""];
                [_transferDate.textField setPlaceholder:@"(필수)"];
            }
        }
            break;
            
        case BIZ_NOVISIT_INPUT2_LISTPOPUP_USE: {
            
            // 자금용도
            
            self.selectUseDic = _useList[anIndex];
            
            [self setButton:_useBtn withTitle:_selectUseDic[@"1"]];
            
            [_use setText:@""];
            
            if ([_selectUseDic[@"CODE"] isEqualToString:@"99"]) {
                
                [_use setEnabled:YES];
            }
            else {
                
                [_use setEnabled:NO];
            }
        }
            break;
            
        case BIZ_NOVISIT_INPUT2_LISTPOPUP_PLAN: {
            
            // 상환계획
            
            self.selectPlanDic = _planList[anIndex];
            
            [self setButton:_planBtn withTitle:_selectPlanDic[@"1"]];
            
            [_plan setText:@""];
            
            if ([_selectPlanDic[@"CODE"] isEqualToString:@"99"]) {
                
                [_plan setEnabled:YES];
            }
            else {
                
                [_plan setEnabled:NO];
            }
        }
            break;
            
        case BIZ_NOVISIT_INPUT2_LISTPOPUP_TRANSFER_ACCOUNT: {
            
            // 입금계좌번호
            
            self.selectTransferAccountDic = _transferAccountList[anIndex];
            
            [self setButton:_transferAccount withTitle:_selectTransferAccountDic[@"2"]];
        }
            
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
    
    if (textField == _use || textField == _plan) {
        
        if (basicTest && [string length] > 0) {
            
            return NO;
        }
        
        if (dataLength + dataLength2 > 100) {
            
            return NO;
        }
        
        return YES;
    }
    
    NSString *number = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // maxLength는 , 포함하여 계산
    NSInteger maxLength = 6;
    
    if (textField == _generalIncomeTax) {
        
        maxLength = 12;
    }
    
    if (textField == _otherLoanCount) {
        
        maxLength = 2;
    }
    
    if ([number length] <= maxLength) {
        
        number = [number stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        [textField setText:[SHBUtility normalStringTocommaString:number]];
    }
    
    return NO;
}

#pragma mark - SHBDateField

- (void)currentDateField:(SHBDateField *)dateField
{
    [self.curTextField resignFirstResponder];
    
    if ([dateField.textField.text length] == 0) {
        
        [dateField setDate:[NSDate date]];
    }
}

#pragma mark - SHBSimpleLoanBranchSearchDelegate

- (void)simpleLoanBranchSearchSelectIndexPath:(NSIndexPath *)indexPath withData:(NSDictionary *)data
{
    [_wishBranch setText:data[@"지점명"]];
    
    self.selectBranch = [NSMutableDictionary dictionaryWithDictionary:data];
}

#pragma mark - SHBAskStaffViewController

- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic
{
	[super viewControllerDidSelectDataWithDic:mDic];
	
	if (mDic && [mDic[@"행번"] length] > 0) {
        
        self.selectCanvarsser = mDic;
        
        [_canvasserNo setText:_selectCanvarsser[@"행번"]];
	}
}

@end
