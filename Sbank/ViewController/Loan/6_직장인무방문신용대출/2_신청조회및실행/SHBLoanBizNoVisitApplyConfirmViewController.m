//
//  SHBLoanBizNoVisitApplyConfirmViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 14..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitApplyConfirmViewController.h"
#import "SHBLoanService.h" // service

#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

#import "SHBLoanBizNoVisitApplyCompleteViewController.h" // 신청 조회 및 실행 6단계 (실행 완료)

@interface SHBLoanBizNoVisitApplyConfirmViewController ()
<SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) NSString *encriptedPassword; // 계좌비밀번호

@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP

@end

@implementation SHBLoanBizNoVisitApplyConfirmViewController

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
    self.strBackButtonTitle = @"직장인 무방문 신용대출 신청 조회 및 실행 5단계 입력정보 확인";
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType integerValue] == 5) { // OTP
        
        self.secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        [_secretOTPViewController setTargetViewController:self];
        [_secretOTPViewController setDelegate:self];
        
        if ([self.data[@"_대출종류"] isEqualToString:@"한도"]) {
            
            _secretOTPViewController.nextSVC = @"L3226";
        }
        else {
            
            _secretOTPViewController.nextSVC = @"L3227";
        }
        
        FrameResize(_secureView, width(_secureView), _secretOTPViewController.view.bounds.size.height);
        
        [_secretOTPViewController setSelfPosY:top(_secureView) + 37];
        
        [_secureView addSubview:_secretOTPViewController.view];
    }
    else {
        
        self.secretCardViewController = [[[SHBSecretCardViewController alloc] init] autorelease];
        [_secretCardViewController setTargetViewController:self];
        [_secretCardViewController setDelegate:self];
        
        if ([self.data[@"_대출종류"] isEqualToString:@"한도"]) {
            
            _secretCardViewController.nextSVC = @"L3226";
        }
        else {
            
            _secretCardViewController.nextSVC = @"L3227";
        }
        
        FrameResize(_secureView, width(_secureView), _secretCardViewController.view.bounds.size.height);
        
        [_secretCardViewController setSelfPosY:top(_secureView) + 37];
        
        [_secureView addSubview:_secretCardViewController.view];
        
        [_secretCardViewController setMediaCode:[secutryType integerValue] previousData:nil];
    }
    
    FrameResize(_mainView, width(_mainView), top(_secureView) + height(_secureView));
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    contentViewHeight = height(_mainView);
    
    self.encriptedPassword = @"";
    
    // 계좌비밀번호
    [_passwordTF showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
    [_passwordTF enableAccButtons:NO Next:NO];
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:self.data];
    [self.binder bind:self dataSet:dataSet];
    
    [_productName initFrame:_productName.frame
               colorType:RGB(209, 75, 75)
                fontSize:15
               textAlign:2];
    [_productName setCaptionText:self.data[@"상품명"]];
    
    [_loanRate initFrame:_loanRate.frame
               colorType:RGB(209, 75, 75)
                fontSize:15
               textAlign:2];
    [_loanRate setCaptionText:self.data[@"금리명"]];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              TASK_NAME_KEY : @"sfg.sphone.task.loan.LoanTask",
                              TASK_ACTION_KEY : @"getDetail",
                              @"P_C_PROD_ID" :  self.data[@"상품CODE"]
                              }];
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_PRODUCT_DETAIL_SERVICE
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
    self.encriptedPassword = nil;
    
    [_passwordTF release];
    [_mainView release];
    [_secureView release];
    [_productName release];
    [_loanRate release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setSecureView:nil];
    [self setProductName:nil];
    [self setLoanRate:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[notification userInfo]];
        
        if ([self.data[@"_대출종류"] isEqualToString:@"한도"]) {
            
            [dic setObject:dic[@"계좌번호"] forKey:@"_대출계좌번호"];
            [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"대출한도금액"]] forKey:@"_대출금액"];
            [dic setObject:[SHBUtility getDateWithDash:dic[@"실행만기일자"]] forKey:@"_대출만기일"];
        }
        else {
            
            [dic setObject:dic[@"대출계좌번호"] forKey:@"_대출계좌번호"];
            [dic setObject:[NSString stringWithFormat:@"%@원", dic[@"실행금액"]] forKey:@"_대출금액"];
            [dic setObject:[SHBUtility getDateWithDash:dic[@"실행일자"]] forKey:@"_대출실행일"];
            [dic setObject:[SHBUtility getDateWithDash:dic[@"만기일자"]] forKey:@"_대출만기일"];
        }
        
        [dic setObject:self.data[@"상품명"] forKey:@"_상품명"];
        [dic setObject:self.data[@"금리명"] forKey:@"_대출금리"];
        [dic setObject:self.data[@"_대출"] forKey:@"_대출종류"];
        
        
        SHBLoanBizNoVisitApplyCompleteViewController *viewController = [[[SHBLoanBizNoVisitApplyCompleteViewController alloc] initWithNibName:@"SHBLoanBizNoVisitApplyCompleteViewController" bundle:nil] autorelease];
        
        viewController.data = [NSDictionary dictionaryWithDictionary:dic];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)getElectronicSignCancel
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
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
}

#pragma mark - Button

/// 계좌비밀번호
- (IBAction)closeNormalPad:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [_passwordTF becomeFirstResponder];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        
        return NO;
    }
    
    switch (self.service.serviceId) {
            
        case LOAN_PRODUCT_DETAIL_SERVICE: {
            
            CGFloat y = 311;
            
            if ([aDataSet[@"C_EXCHANGE_WAY"] length] > 0) {
                
                // 상환방법
                
                UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(8, y, 301, 16)] autorelease];
                [label setText:@"상환방법"];
                [label setFont:[UIFont systemFontOfSize:15]];
                [label setTextColor:RGB(74, 74, 74)];
                [_mainView addSubview:label];
                
                y += 25;
                
                UILabel *label2 = [[[UILabel alloc] initWithFrame:CGRectMake(8, y, 301, 16)] autorelease];
                [label2 setText:aDataSet[@"C_EXCHANGE_WAY"]];
                [label2 setFont:[UIFont systemFontOfSize:15]];
                [label2 setTextColor:RGB(209, 75, 75)];
                [label2 setNumberOfLines:0];
                
                CGSize labelSize = [label2.text sizeWithFont:label2.font
                                           constrainedToSize:CGSizeMake(label2.frame.size.width, 999)
                                               lineBreakMode:label2.lineBreakMode];
                
                FrameResize(label2, width(label2), labelSize.height);
                [_mainView addSubview:label2];
                
                y += height(label2) + 9;
            }
            
            // 중도상환수수료
            
            UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(8, y, 301, 16)] autorelease];
            [label setText:@"중도상환수수료"];
            [label setFont:[UIFont systemFontOfSize:15]];
            [label setTextColor:RGB(74, 74, 74)];
            [_mainView addSubview:label];
            
            y += 25;
            
            UILabel *label2 = [[[UILabel alloc] initWithFrame:CGRectMake(8, y, 301, 16)] autorelease];
            [label2 setFont:[UIFont systemFontOfSize:15]];
            [label2 setTextColor:RGB(209, 75, 75)];
            [label2 setNumberOfLines:0];
            
            if (aDataSet[@"C_EXCHANGE_FEE"]) {
                
                [label2 setText:aDataSet[@"C_EXCHANGE_FEE"]];
                
                CGSize labelSize = [label2.text sizeWithFont:label2.font
                                           constrainedToSize:CGSizeMake(label2.frame.size.width, 999)
                                               lineBreakMode:label2.lineBreakMode];
                FrameResize(label2, width(label2), labelSize.height);
            }
            else {
                
                [label2 setText:@"없음"];
            }
            
            [_mainView addSubview:label2];
            
            y += height(label2) + 9;
            
            UIView *line = [[[UIView alloc] initWithFrame:CGRectMake(0, y, 317, 1)] autorelease];
            [line setBackgroundColor:RGB(209, 209, 209)];
            [_mainView addSubview:line];
            
            y += 1;
            
            FrameResize(_mainView, width(_mainView), y + height(_secureView));
            FrameReposition(_secureView, 0, y);
            
            [self.contentScrollView setContentSize:_mainView.frame.size];
            contentViewHeight = height(_mainView);
            
        }
            break;
            
        case LOAN_C2092_SERVICE: {
            
            [_passwordTF setText:@""];
            self.encriptedPassword = @"";
            
            AppInfo.electronicSignString = @"";
            AppInfo.eSignNVBarTitle = @"직장인 무방문 신용대출";
            
            if ([self.data[@"_대출종류"] isEqualToString:@"한도"]) {
                
                AppInfo.electronicSignCode = @"L3226_A";
            }
            else {
                
                AppInfo.electronicSignCode = @"L3227_A";
            }
            
            AppInfo.electronicSignTitle = @"";
            
            [AppInfo addElectronicSign:@"다음 사항을 충분히 이해하고 본인(신용)정보의 수집, 이용, 제공에 동의하며 약정합니다."];
            [AppInfo addElectronicSign:@"1.은행여신거래기본약관(통장한도거래대출 및 가계당좌 대출의 경우 관련 수신거래약관 포함)이 적용됨을 승인하고 본 약관 및 대출거래 약정서(가계용)와 가계대출 상품설명서의 모든 내용에 대하여 충분히 이해하였음."];
            [AppInfo addElectronicSign:@"2.개인(신용)정보 수집, 이용, 제공 동의(금융거래 설정 등)"];
            [AppInfo addElectronicSign:@"3.약정 내용"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)대출일자: %@", AppInfo.tran_Date]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)성명: %@", AppInfo.userInfo[@"고객성명"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)대출과목: %@", self.data[@"상품명"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)거래구분: %@", self.data[@"_운용구분"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)상환방법: %@", self.data[@"_상환구분"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)대출금액: %@", self.data[@"_신청금액"]]];
            
            NSString *stampDuty = @""; // 인지세
            SInt64 money = [[self.data[@"_신청금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
            
            if (money > 40000000) {
                
                // 4천만 초과
                
                if (money > 100000000) {
                    
                    // 1억 초과
                    
                    stampDuty = @"75,000원";
                }
                else if (money > 50000000) {
                    
                    // 5천만 초과 ~ 1억 이하
                    
                    stampDuty = @"35,000원";
                }
                else {
                    
                    // 4천만 초과 ~ 5천만 이하
                    
                    stampDuty = @"20,000원";
                }
            }
            else {
                
                // 4천만 이하
                
                stampDuty = @"비과세";
            }
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)인지세: %@", stampDuty]];
            
            if ([self.data[@"_대출종류"] isEqualToString:@"한도"]) {
                
                if ([self.data[@"신청구분CODE"] isEqualToString:@"12"]) {
                    
                    [AppInfo addElectronicSign:@"(9)대출기간:"];
                }
                else {
                    
                    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)대출기간: %@", self.data[@"_대출기간만료일"]]];
                }
            }
            else {
                
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)대출기간: %@", self.data[@"_대출기간만료일"]]];
            }
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)채권보전: %@", self.data[@"_채권보전CODE"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)대출이자율: %@", self.data[@"금리명"]]];
            [AppInfo addElectronicSign:@"(12)이자 및 지연배상금 계산방법"];
            [AppInfo addElectronicSign:@"1.1년을 365일로 보고 1일 단위로 계산합니다."];
            [AppInfo addElectronicSign:@"2.지연배상금률은 제1조의 이자율(보증료)등에 연체가산금리를 더하여 최고 연 17%이내로 적용합니다. 단, 여신 이자율이 최고 지연배상금률 이상인 경우에는 여신 이자율에 2%를 가산하여 적용합니다."];
            [AppInfo addElectronicSign:@"3.연체가산금리는 연체기간이 1개월 이내에는 7%, 1개월 초과 3개월 이내에는 8%, 3개월을 초과하는 경우 9%를 적용합니다."];
            
            NSInteger index = 13;
            
            if ([self.data[@"_대출종류"] isEqualToString:@"건별"]) {
                
                // 건별
                [AppInfo addElectronicSign:@"(13)중도상환수수료: 시장금리부 및 (신)기준금리부 (Prime Rate연동, 원화 대출기준금리, 고정금리, 일반외화대출 포함)여신인 경우 중도상환 대출금 x 1.5% x (대출잔여일수/대출기간) 단, 대출기간 및 대출잔여일수는 3년을 초과하더라도 3년을 정함."];
                
                index++;
            }
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)변동금리대출은 상환을 완료할 때까지 이자율이 인상될 수 있으며, 대출이자율 인상 시 재무적 부담이 증가할 수 있음을 충분히 설명 듣고 이해하였음.", index]];
            
            self.service = nil;
            
            if ([self.data[@"_대출종류"] isEqualToString:@"한도"]) {
                
                self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3226_SERVICE viewController:self] autorelease];
                self.service.requestData = [SHBDataSet dictionaryWithDictionary:
                                            @{
                                              @"대출승인번호" : self.data[@"신청번호"],
                                              @"계좌번호" : self.data[@"_계좌번호"]
                                              }];
            }
            else {
                
                self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3227_SERVICE viewController:self] autorelease];
                self.service.requestData = [SHBDataSet dictionaryWithDictionary:
                                            @{
                                              @"신청점" : self.data[@"신청점번호"],
                                              @"대출승인번호" : self.data[@"신청번호"]
                                              }];
            }
            
            [self.service start];
        }
            break;
            
        default:
            break;
    }
    
    
    return YES;
}

#pragma mark - SHBSecretMedia

- (void)confirmSecretMedia:(OFDataSet *)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if (confirm) {
        
        if ([_encriptedPassword length] == 0 || [_passwordTF.text length] != 4) {
            
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"계좌비밀번호를 입력해 주세요."];
            return;
        }
        
        // 원클릭급여이체스마트론, 원클릭스마트론 인 경우 동의서 보기
        if ((([self.data[@"상품CODE"] isEqualToString:@"611111100"] || [self.data[@"상품CODE"] isEqualToString:@"611141100"]) &&
             [self.data[@"정책코드"] isEqualToString:@"6215"]) ||
            [self.data[@"상품CODE"] isEqualToString:@"611115700"] ||
            [self.data[@"상품CODE"] isEqualToString:@"611143700"]) {
            
        	[UIAlertView showAlert:self
                              type:ONFAlertTypeOneButton
                               tag:33110
                             title:@""
                           message:@"지인에게 추천하고 금리 감면 받으세요!!\n본인의 추천번호는 실행시 SMS문자로 발송됩니다. 지인에게 본인의 추천번호를 알려주시고, 지인이 그 추천번호를 통해 신규 시 본인 및 지인 모두 금리 0.1%%감면됩니다. 1인당 0.1%%가 감면되며, 최대 0.3%%까지 적용 가능합니다."];
            return;
    	}
        
        SHBDataSet *dataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                        @"출금계좌번호" : [self.data[@"_계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                                                        @"출금은행구분" : @"1",
                                                                        @"출금계좌비밀번호" : _encriptedPassword,
                                                                        @"납부금액" : [self.data[@"_신청금액"] stringByReplacingOccurrencesOfString:@"," withString:@""]
                                                                        }] autorelease];
        
        self.service = nil;
        self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_C2092_SERVICE viewController:self] autorelease];
        self.service.requestData = dataSet;
        [self.service start];
    }
}

- (void)cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController fadePopViewController];
}

#pragma mark - SHBSecureTextField

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    self.encriptedPassword = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
    
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 33110) {
        
        SHBDataSet *dataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                        @"출금계좌번호" : [self.data[@"_계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                                                        @"출금은행구분" : @"1",
                                                                        @"출금계좌비밀번호" : _encriptedPassword,
                                                                        @"납부금액" : [self.data[@"_신청금액"] stringByReplacingOccurrencesOfString:@"," withString:@""]
                                                                        }] autorelease];
        
        self.service = nil;
        self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_C2092_SERVICE viewController:self] autorelease];
        self.service.requestData = dataSet;
        [self.service start];
    }
}

@end
