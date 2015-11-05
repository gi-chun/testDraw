//
//  SHBSimpleLoanInput3ViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 16..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSimpleLoanInput3ViewController.h"
#import "SHBLoanService.h" // service
#import "SHBListPopupView.h" // list popup

#import "SHBSimpleLoanStipulationViewController.h" // 약정업체 간편대출 약관동의
#import "SHBSimpleLoanCompleteViewController.h" // 약정업체 간편대출 완료

@interface SHBSimpleLoanInput3ViewController () <SHBListPopupViewDelegate>

@property (retain, nonatomic) NSMutableArray *useList; // 자금용도
@property (retain, nonatomic) NSMutableArray *planList; // 상환계획

@property (retain, nonatomic) NSMutableDictionary *selectUseDic; // 자금용도
@property (retain, nonatomic) NSMutableDictionary *selectPlanDic; // 상환계획

@end

@implementation SHBSimpleLoanInput3ViewController

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
    
    [self setTitle:@"약정업체 간편대출"];
    self.strBackButtonTitle = @"약정업체 간편대출 정보입력(3)";
    
    [_mainView setFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height)];
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    contentViewHeight = _mainView.frame.size.height;
    
    startTextFieldTag = 3330;
    endTextFieldTag = 3333;
    
    // 대출희망일
    [_dateField initFrame:_dateField.frame];
    [_dateField.textField setFont:[UIFont systemFontOfSize:15]];
    [_dateField.textField setTextColor:RGB(44, 44, 44)];
    [_dateField.textField setTextAlignment:UITextAlignmentLeft];
    [_dateField setDate:[NSDate date]];
    [_dateField.textField setPlaceholder:@"(필수)"];
    [_dateField.textField setAccessibilityLabel:@"대출희망일 입력창"];
    [_dateField setDelegate:self];
    
    [self setListData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.inputData = nil;
    
    self.useList = nil;
    self.planList = nil;
    
    self.selectUseDic = nil;
    self.selectPlanDic = nil;
    
    [_mainView release];
    [_textField1 release];
    [_textField2 release];
    [_textField3 release];
    [_textField4 release];
    [_useBtn release];
    [_useTF release];
    [_planBtn release];
    [_planTF release];
    [_dateField release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setTextField1:nil];
    [self setTextField2:nil];
    [self setTextField3:nil];
    [self setTextField4:nil];
    [self setUseBtn:nil];
    [self setUseTF:nil];
    [self setPlanBtn:nil];
    [self setPlanTF:nil];
    [self setDateField:nil];
    [super viewDidUnload];
}

#pragma mark - Notification

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        
        SHBSimpleLoanCompleteViewController *viewController = [[[SHBSimpleLoanCompleteViewController alloc] initWithNibName:@"SHBSimpleLoanCompleteViewController" bundle:nil] autorelease];
        viewController.data = notification.userInfo;
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)electronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (SHBSimpleLoanStipulationViewController *viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:[SHBSimpleLoanStipulationViewController class]]) {
            
            [viewController clearViewData];
            
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
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
                                                                   CellNib:@"SHBExchangePopupCell"
                                                                     CellH:32
                                                               CellDispCnt:dispCnt
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView setTag:tag];
    [popupView showInView:self.navigationController.view animated:YES];
}

- (NSString *)getErrorMessage
{
    /*
     textField1 // 연근로소득
     textField2 // 신한은행 총 대출금액
     textField3 // 신한은행 신용대출금
     textField4 // 대출 신청금액
     */
    
    NSInteger integer1 = [[_textField1.text stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue];
    NSInteger integer2 = [[_textField2.text stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue];
    NSInteger integer3 = [[_textField3.text stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue];
    NSInteger integer4 = [[_textField4.text stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue];
    
    if (integer1 == 0) {
        
        return @"연 근로소득을 입력해 주세요.";
    }
    
    if (integer2 == 0 && integer3 > 0) {
        
        return @"신한은행 총 대출금액을 입력해 주세요.";
    }
    
    if (integer2 < integer3) {
        
        return @"입력하신 신용 대출금액이 총 대출금액을 초과합니다. 확인 후 입력해 주세요.";
    }
    
    if (integer4 == 0) {
        
        return @"대출 신청 금액을 입력해 주세요.";
    }
    
    if (integer4 > 10000) {
        
        return @"대출 신청 금액은 1억까지 입력 가능합니다. (5자리)";
    }
    
    if (!_selectUseDic || [_useBtn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"자금용도를 선택해 주세요.";
    }
    
    if ([_selectUseDic[@"CODE"] isEqualToString:@"99"] && [_useTF.text length] == 0) {
        
        return @"기타 입력 영역에 상세 내용을 입력해 주세요.";
    }
    
    if (!_selectPlanDic || [_planBtn.titleLabel.text isEqualToString:@"선택하세요"]) {
        
        return @"상환계획을 선택해 주세요.";
    }
    
    if ([_selectPlanDic[@"CODE"] isEqualToString:@"99"] && [_planTF.text length] == 0) {
        
        return @"기타 입력 영역에 상세 내용을 입력해 주세요.";
    }
    
    if ([_dateField.textField.text length] == 0) {
        
        return @"대출 희망일을 입력해 주세요.";
    }
    
    return @"";
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.curTextField resignFirstResponder];
    
    switch ([sender tag]) {
            
        case 100: {
            
            // 자금용도
            
            [self showPopupView:@"자금용도" withOptions:_useList withTag:100];
        }
            break;
            
        case 200: {
            
            // 상환계획
            
            [self showPopupView:@"상환계획" withOptions:_planList withTag:200];
        }
            break;
            
        case 300: {
            
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
            
            AppInfo.electronicSignString = @"";
            AppInfo.eSignNVBarTitle = @"약정업체 간편대출";
            
            AppInfo.electronicSignCode = @"L3211_A";
            AppInfo.electronicSignTitle = @"대출신청";
            
            [AppInfo addElectronicSign:@"1.개인신용정보의 제공 조회 동의"];
            [AppInfo addElectronicSign:@"2.신청내용"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일자: %@", AppInfo.tran_Date]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)성명: %@", AppInfo.userInfo[@"고객성명"]]];
            
            if ([[AppInfo getPersonalPK] length] >= 6) {
                
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)실명번호: %@*******", [[AppInfo getPersonalPK] substringToIndex:6]]];
            }
            else {
                
                [AppInfo addElectronicSign:@"(4)실명번호: *************"];
            }
            
            [AppInfo addElectronicSign:@"(5)신청정보: 대출신청"];
            
            NSString *money = [_textField4.text stringByReplacingOccurrencesOfString:@"," withString:@""];
            
            money = [NSString stringWithFormat:@"%lld", [money longLongValue] * 10000];
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)대출신청금액: %@원", [SHBUtility normalStringTocommaString:money]]];
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      @"업무구분" : @"D",
                                      @"담보구분" : @"1",
                                      @"담보종류" : @"0",
                                      @"접수구분" : @"5",
                                      @"대출구분" : @"1",
                                      @"신청점" : [SHBUtility nilToString:_inputData[@"_지점"]],
                                      @"신청일" : [SHBUtility nilToString:AppInfo.tran_Date],
                                      @"고객명" : [SHBUtility nilToString:AppInfo.userInfo[@"고객성명"]],
                                      @"우편물송달장소" : [SHBUtility nilToString:_inputData[@"_우편물송달장소"]],
                                      @"자택우편번호1" : [SHBUtility nilToString:_inputData[@"_자택우편번호1"]],
                                      @"자택우편번호2" : [SHBUtility nilToString:_inputData[@"_자택우편번호2"]],
                                      @"자택동주소명" : [SHBUtility nilToString:_inputData[@"_자택동주소명"]],
                                      @"자택동미만주소" : [SHBUtility nilToString:_inputData[@"_자택동미만주소"]],
                                      @"자택전화지역번호" : [SHBUtility nilToString:_inputData[@"_자택전화지역번호"]],
                                      @"자택전화국번호" : [SHBUtility nilToString:_inputData[@"_자택전화국번호"]],
                                      @"자택전화통신일련번호" : [SHBUtility nilToString:_inputData[@"_자택전화통신일련번호"]],
                                      @"이동통신번호통신회사" : [SHBUtility nilToString:_inputData[@"_이동통신번호통신회사"]],
                                      @"이동통신번호국" : [SHBUtility nilToString:_inputData[@"_이동통신번호국"]],
                                      @"이동통신번호일련번호" : [SHBUtility nilToString:_inputData[@"_이동통신번호일련번호"]],
                                      @"직장명" : [SHBUtility nilToString:_inputData[@"_기관선택"]],
                                      @"사업자등록번호1" : [SHBUtility nilToString:_inputData[@"_사업자등록번호1"]],
                                      @"사업자등록번호2" : [SHBUtility nilToString:_inputData[@"_사업자등록번호2"]],
                                      @"사업자등록번호3" : [SHBUtility nilToString:_inputData[@"_사업자등록번호3"]],
                                      @"근무부서" : [SHBUtility nilToString:_inputData[@"_근무부서"]],
                                      @"직위" : [SHBUtility nilToString:_inputData[@"_직위"]],
                                      @"직업코드" : [SHBUtility nilToString:_inputData[@"_직업코드"]],
                                      @"직위코드" : [SHBUtility nilToString:_inputData[@"_직위코드"]],
                                      @"고용형태구분" : [SHBUtility nilToString:_inputData[@"_직종"]],
                                      @"직장우편번호1" : [SHBUtility nilToString:_inputData[@"_직장우편번호1"]],
                                      @"직장우편번호2" : [SHBUtility nilToString:_inputData[@"_직장우편번호2"]],
                                      @"직장주소" : [SHBUtility nilToString:_inputData[@"_직장동주소명"]],
                                      @"직장번지이하주소" : [SHBUtility nilToString:_inputData[@"_직장동미만주소"]],
                                      @"입사년월일" : [SHBUtility nilToString:_inputData[@"_입사일자"]],
                                      @"직장전화지역번호" : [SHBUtility nilToString:_inputData[@"_직장전화지역번호"]],
                                      @"직장전화국번" : [SHBUtility nilToString:_inputData[@"_직장전화국번호"]],
                                      @"직장전화번호" : [SHBUtility nilToString:_inputData[@"_직장전화통신일련번호"]],
                                      @"직장교환번호" : @"",
                                      @"연소득" : [SHBUtility nilToString:_textField1.text],
                                      @"총대출금액" : [SHBUtility nilToString:_textField2.text],
                                      @"총신용대출금액" : [SHBUtility nilToString:_textField3.text],
                                      @"신청금액" : [SHBUtility nilToString:_textField4.text],
                                      @"email주소" : [SHBUtility nilToString:_inputData[@"_이메일주소"]],
                                      @"고객_자택주소종류" : [SHBUtility nilToString:_inputData[@"_자택주소종류"]],
                                      @"고객_직장주소종류" : [SHBUtility nilToString:_inputData[@"_직장주소종류"]],
                                      @"자금용도" : [SHBUtility nilToString:_selectUseDic[@"CODE"]],
                                      @"금감원자금용도CODE" : [SHBUtility nilToString:_selectUseDic[@"CODE"]],
                                      @"상환계획CODE" : [SHBUtility nilToString:_selectPlanDic[@"CODE"]],
                                      @"취급희망일" : [SHBUtility nilToString:_dateField.textField.text],
                                      @"big_gubun" : [SHBUtility nilToString:_inputData[@"_대분류"]],
                                      @"mid_gubun" : [SHBUtility nilToString:_inputData[@"_중분류"]],
                                      @"sml_gubun" : [SHBUtility nilToString:_inputData[@"_소분류"]],
//                                      @"직업구분" : _inputData[@"_직업"], // 서버에서 넣어줌
//                                      @"주민번호1" : _inputData[@"_주민번호1"], // 서버에서 넣어줌
//                                      @"주민번호2" : _inputData[@"_주민번호2"], // 서버에서 넣어줌
//                                      @"주거소유" : @"0",
//                                      @"자가승용차" : @"0",
//                                      @"주거종류" : @"0",
//                                      @"주거면적" : @"0",
//                                      @"현주소거주_년" : self.data[@"현주소거주_년"],
//                                      @"현주소거주_월" : self.data[@"현주소거주_월"],
//                                      @"결혼여부" : @"0",
//                                      @"맞벌이여부" : @"0",
//                                      @"동거인_배우자_유무" : @"0",
//                                      @"동거인_부_유무" : @"0",
//                                      @"동거인_모_유무" : @"0",
//                                      @"동거인_자녀_유무" : @"0",
//                                      @"자녀수" : @"0",
//                                      @"동거인_형재자매_유무" : @"0",
//                                      @"동거인_기타_유무" : @"0",
//                                      @"동거인_없음_유무" : @"0",
//                                      @"학력" : @"0",
//                                      @"직무" : @"2",
//                                      @"신청구분" : @"10",
//                                      @"정책금융코드" : @"0",
//                                      @"금리구분" : @"4",
//                                      @"시장금리종류" : @"0",
//                                      @"시장기간물종류" : @"0",
//                                      @"관련계좌번호" : @"",
//                                      @"증가금액" : @"0",
//                                      @"업체번호" : @"0",
//                                      @"전직장명" : @"",
//                                      @"전직직위" : @"",
//                                      @"전직직업코드" : @"0",
//                                      @"전직직위코드" : @"0",
//                                      @"전직재직기각년" : @"0",
//                                      @"전직재직기간월" : @"0",
//                                      @"전직퇴사년월" : @"",
//                                      @"연소득_T" : @"0",
//                                      @"종합소득세" : @"0",
//                                      @"종합소득세_T" : @"0",
//                                      @"기타연소득_유무" : @"0",
//                                      @"기타연소득합계" : @"0",
//                                      @"기타연소득합계_T" : @"0",
//                                      @"연금소득_유무" : @"0",
//                                      @"이자소득_유무" : @"0",
//                                      @"배당소득_유무" : @"0",
//                                      @"임대소득_유무" : @"0",
//                                      @"배우자소득금액" : @"0",
//                                      @"배우자소득금액_T" : @"0",
//                                      @"기타소득_유무" : @"0",
//                                      @"타기관대출_유무" : @"0",
//                                      @"타기관대출금액_신고" : @"0",
//                                      @"타기관대출금액_신고_T" : @"0",
//                                      @"타기관담보대출금액_신고" : @"0",
//                                      @"타기관담보대출금액_신고_T" : @"0",
//                                      @"타대출기관수_신고" : @"0",
//                                      @"신청금액_T" : @"0",
//                                      @"가용담보가액" : @"0",
//                                      @"가용담보가액_T" : @"0",
//                                      @"총대출금액_T" : @"0",
//                                      @"총신용대출금액_T" : @"0",
//                                      @"기보증금액" : @"0",
//                                      @"기보증금액_T" : @"0",
//                                      @"담보물위치" : @"",
//                                      @"추정시가" : @"0",
//                                      @"추정시가_T" : @"0",
//                                      @"총방수" : @"0",
//                                      @"임대방수" : @"0",
//                                      @"설정최고액" : @"0",
//                                      @"설정최고액_T" : @"0",
//                                      @"임대차금액" : @"0",
//                                      @"임대차금액_T" : @"0",
//                                      @"타행대출상환금액" : @"0",
//                                      @"퇴직금액" : @"0",
//                                      @"보험가입여부" : @"0",
//                                      @"노블레스론직업번호" : @"0",
//                                      @"접속SITE경로" : @"",
//                                      @"고객_자택도로명주소참조KEY" : @"",
//                                      @"고객_직장도로명주소참조KEY" : @"",
                                      }];
            
            if ([_selectUseDic[@"CODE"] isEqualToString:@"99"] && [_useTF.text length] > 0) {
                
                [aDataSet insertObject:_useTF.text forKey:@"금감원자금용도기타내용" atIndex:0];
            }
            else {
                
                [aDataSet insertObject:@"" forKey:@"금감원자금용도기타내용" atIndex:0];
            }
            
            if ([_selectPlanDic[@"CODE"] isEqualToString:@"99"] && [_planTF.text length] > 0) {
                
                [aDataSet insertObject:_planTF.text forKey:@"상환계획" atIndex:0];
            }
            else {
                
                [aDataSet insertObject:@"" forKey:@"상환계획" atIndex:0];
            }
            
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3211_SERVICE viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case 400: {
            
            // 취소
            
            [self electronicSignCancel];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    switch ([listPopView tag]) {
            
        case 100: {
            
            // 자금용도
            
            self.selectUseDic = _useList[anIndex];
            
            [self setButton:_useBtn withTitle:_selectUseDic[@"1"]];
            
            [_useTF setText:@""];
            
            if ([_selectUseDic[@"CODE"] isEqualToString:@"99"]) {
                
                [_useTF setEnabled:YES];
            }
            else {
                
                [_useTF setEnabled:NO];
            }
        }
            break;
            
        case 200: {
            
            // 상환계획
            
            self.selectPlanDic = _planList[anIndex];
            
            [self setButton:_planBtn withTitle:_selectPlanDic[@"1"]];
            
            [_planTF setText:@""];
            
            if ([_selectPlanDic[@"CODE"] isEqualToString:@"99"]) {
                
                [_planTF setEnabled:YES];
            }
            else {
                
                [_planTF setEnabled:NO];
            }
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
    
    int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
    
    //특수문자 : ₩ $ £ ¥ • 은 입력 안됨
    NSString *SPECIAL_CHAR = @"$₩€£¥•!@#$%^&*()_=+{}|[]\\;:\'\"<>?,./`~";
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    
    if (textField == _useTF || textField == _planTF) {
        
        if (basicTest && [string length] > 0) {
            
            return NO;
        }
        
        if (dataLength + dataLength2 > 100) {
            
            return NO;
        }
        
        return YES;
    }
    
    NSString *number = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([number length] <= 6) {
        
        number = [number stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        [textField setText:[SHBUtility normalStringTocommaString:number]];
    }
    
    return NO;
}

@end
