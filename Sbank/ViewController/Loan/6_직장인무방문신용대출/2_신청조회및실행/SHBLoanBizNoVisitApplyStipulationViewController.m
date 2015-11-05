//
//  SHBLoanBizNoVisitApplyStipulationViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 14..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitApplyStipulationViewController.h"
#import "SHBLoanService.h" // 서비스

#import "SHBNewProductSeeStipulationViewController.h" // 약관보기
#import "SHBLoanBizNoVisitApplyInfoViewController.h" // 신청 조회 및 실행 4단계 (인지세 부과 안내)
#import "SHBIdentity3ViewController.h" // 추가인증

@interface SHBLoanBizNoVisitApplyStipulationViewController () <SHBIdentity3Delegate>
{
    Boolean _isSee1;
    Boolean _isSee2;
    Boolean _isSee3;
}

@property (retain, nonatomic) NSArray *collectionList;
@property (retain, nonatomic) NSDictionary *C2315Dic;

@end

@implementation SHBLoanBizNoVisitApplyStipulationViewController

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
    self.strBackButtonTitle = @"직장인 무방문 신용대출 신청 조회 및 실행 1단계 신청내역";
    
    _isSee1 = NO;
    _isSee2 = NO;
    _isSee3 = NO;
    
    self.collectionList = @[ _collectionBtn1_1, _collectionBtn1_2, _collectionBtn2, _collectionBtn3, _collectionBtn4,
                             _collectionBtn5, _collectionBtn6, _collectionBtn7, _collectionBtn8, _collectionBtn9 ];
    
    [_contentSV addSubview:_contentView];
    [_contentSV setContentSize:_contentView.frame.size];
    
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_C2315_SERVICE viewController:self] autorelease];
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.selectDetailDic = nil;
    
    self.collectionList = nil;
    self.C2315Dic = nil;
    
    [_contentSV release];
    [_contentView release];
    [_agreeBtn release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setContentSV:nil];
    [self setContentView:nil];
    [self setAgreeBtn:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (void)clearViewData
{
    if (_contentSV.contentOffset.y > 0) {
        
        [_contentSV setContentOffset:CGPointZero];
    }
    
    _isSee1 = NO;
    _isSee2 = NO;
    _isSee3 = NO;
    
    [_agreeBtn setSelected:NO];
    
    for (NSArray *buttonCollection in _collectionList) {
        
        [buttonCollection[0] setSelected:YES];
        [buttonCollection[1] setSelected:NO];
    }
    
    if ([_C2315Dic[@"선택정보동의여부"] isEqualToString:@"2"]) {
        
        [_collectionBtn1_2[0] setSelected:NO];
        [_collectionBtn1_2[1] setSelected:YES];
    }
    else {
        
        [_collectionBtn1_2[0] setSelected:YES];
        [_collectionBtn1_2[1] setSelected:NO];
    }
}

- (NSString *)getErrorMessage
{
    if (!_isSee1) {
        
        return @"대출거래약정서(가계용), 은행여신거래약관 및 상품설명서를 선택하여 확인하시기 바랍니다.";
    }
    
    if (!_isSee2) {
        
        return @"추가약정서(가계대출 금리우대용)를 선택하여 확인하시기 바랍니다.";
    }
    
    if (![_agreeBtn isSelected]) {
        
        return @"은행 여신거래 기본약관, 은행대출거래약정서, 추가약정서(가계대출 금리우대용), 가계대출 상품 설명서, 개인 신용정보 조회 동의서를 읽고 동의를 선택하시기 바랍니다.";
    }
    
    if (!_isSee3) {
        
        return @"개인(신용)정보 조회 동의서 / 개인(신용)정보 수집, 이용, 제공 동의서 (여신 금융거래) 및 고객권리 안내문 보기를 선택하여 확인하시기 바랍니다.";
    }
    
    if (![_collectionBtn1_1[0] isSelected]) {
        
        return @"1번 필수적 정보는 반드시 동의하셔야 합니다.";
    }
    
    if (![_collectionBtn2[0] isSelected]) {
        
        return @"2번 고유식별정보는 반드시 동의하셔야 합니다.";
    }
    
    if (![_collectionBtn3[0] isSelected]) {
        
        return @"3번 개인정보제공은 반드시 동의하셔야 합니다.";
    }
    
    if (![_collectionBtn4[0] isSelected]) {
        
        return @"4번 고유식별정보는 반드시 동의하셔야 합니다.";
    }
    
    if (![_collectionBtn5[0] isSelected]) {
        
        return @"5번 개인정보 수집이용에 반드시 동의하셔야 합니다.";
    }
    
    if (![_collectionBtn6[0] isSelected]) {
        
        return @"6번 개인정보제공에 반드시 동의하셔야 합니다.";
    }
    
    if (![_collectionBtn7[0] isSelected]) {
        
        return @"7번 고유식별정보 수집이용에 반드시 동의하셔야 합니다.";
    }
    
    if (![_collectionBtn8[0] isSelected]) {
        
        return @"8번 고유식별정보 수집이용에 동의하셔야 합니다.";
    }
    
    if (![_collectionBtn9[0] isSelected]) {
        
        return @"9번 신한은행 사용정보 제공에 동의하셔야 합니다.";
    }
    
    return @"";
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    switch ([sender tag]) {
            
        case 10: {
            
            // 대출거래약정서(가계용), 은행여신거래약관 및 상품설명서
            
            _isSee1 = YES;
            
            NSString *strURL = [NSString stringWithFormat:@"%@loan_deal_agreement.html", AppInfo.realServer ? URL_YAK : URL_YAK_TEST];
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            viewController.strUrl = strURL;
            viewController.strName = @"직장인 무방문 신용대출";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 20: {
            
            // 추가약정서(가계대출 금리우대용) 보기
            
            _isSee2 = YES;
            
            NSString *strURL = [NSString stringWithFormat:@"%@loan_add_agreement.html", AppInfo.realServer ? URL_YAK : URL_YAK_TEST];
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            viewController.strUrl = strURL;
            viewController.strName = @"직장인 무방문 신용대출";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 30: {
            
            // 예, 동의합니다.
            
            [sender setSelected:![sender isSelected]];
        }
            break;
            
        case 40: {
            
            // 개인(신용)정보 조회 동의서 / 개인(신용)정보 수집, 이용, 제공 동의서 (여신 금융거래) 및 고객권리 안내문 보기
            
            _isSee3 = YES;
            
            NSString *strURL = [NSString stringWithFormat:@"%@loan_trust_consent.html", AppInfo.realServer ? URL_YAK : URL_YAK_TEST];
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            viewController.strUrl = strURL;
            viewController.strName = @"직장인 무방문 신용대출";
            viewController.strBackButtonTitle = @"약관보기";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 101: // 1. 필수적 정보 (동의함)
        case 102: // 1. 필수적 정보 (동의하지 않음)
        case 111: // 1. 선택적 정보 (동의함)
        case 112: // 1. 선택적 정보 (동의하지 않음)
        case 121: // 2. (동의함)
        case 122: // 2. (동의하지 않음)
        case 131: // 3. (동의함)
        case 132: // 3. (동의하지 않음)
        case 141: // 4. (동의함)
        case 142: // 4. (동의하지 않음)
        case 151: // 5. (동의함)
        case 152: // 5. (동의하지 않음)
        case 161: // 6. (동의함)
        case 162: // 6. (동의하지 않음)
        case 171: // 7. (동의함)
        case 172: // 7. (동의하지 않음)
        case 181: // 8. (동의함)
        case 182: // 8. (동의하지 않음)
        case 191: // 9. (동의함)
        case 192: // 9. (동의하지 않음)
        {
            NSUInteger index = ([sender tag] / 10) - 10;
            
            for (UIButton *button in _collectionList[index]) {
                
                [button setSelected:NO];
            }
            
            [sender setSelected:YES];
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
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      @"업무구분" : @"1",
                                      @"은행구분" : @"1",
                                      @"검색구분" : @"1",
                                      @"고객번호" : AppInfo.customerNo,
                                      @"고객번호1" : AppInfo.customerNo,
                                      @"마케팅활용동의여부" : _C2315Dic[@"마케팅활용동의여부"],
                                      @"장표출력SKIP여부" : @"1",
                                      @"필수정보동의여부" : @"1",
                                      @"선택정보동의여부" : [_collectionBtn1_2[0] isSelected] ? @"1" : @"2",
                                      @"인터넷수행여부" : @"1",
                                      }];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_C2316_SERVICE viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case 2000: {
            
            // 취소
            
            [self.navigationController fadePopViewController];
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
            
        case LOAN_C2315_SERVICE: {
            
            self.C2315Dic = [NSDictionary dictionaryWithDictionary:aDataSet];
        }
            break;
            
        case LOAN_C2316_SERVICE: {
            
            NSString *serviceCode = @"";
            
            AppInfo.commonDic = [NSDictionary dictionaryWithDictionary:self.data];
            
            if ([self.data[@"_대출종류"] isEqualToString:@"한도"]) {
                
                serviceCode = @"L3224";
            }
            else {
                
                serviceCode = @"L3225";
            }
            
            AppInfo.transferDic = @{ @"계좌번호_상품코드" : @"최적상품대출",
                                     @"거래금액" : @"",
                                     @"서비스코드" : serviceCode };
            
            SHBIdentity3ViewController *viewController = [[SHBIdentity3ViewController alloc] initWithNibName:@"SHBIdentity3ViewController" bundle:nil];
            
            viewController.is100Over = YES;
            
            if ([self.data[@"_대출종류"] isEqualToString:@"한도"]) {
                
                [viewController setServiceSeq:SERVICE_BIZ_LOAN_LIMIT];
            }
            else {
                
                [viewController setServiceSeq:SERVICE_BIZ_LOAN_ITEMIZE];
            }
            
            viewController.needsLogin = YES;
            viewController.delegate = self;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
            
            // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
            [viewController executeWithTitle:@"직장인 무방문 신용대출" Step:2 StepCnt:6 NextControllerName:@"SHBLoanBizNoVisitApplyInfoViewController"];
            [viewController subTitle:@"추가인증 방법 선택"];
            [viewController release];
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

#pragma mark - SHBIdentity3Delegate

- (void)identity3ViewControllerCancel
{
    _isSee1 = NO;
    _isSee2 = NO;
    _isSee3 = NO;
    
    [_agreeBtn setSelected:NO];
}

@end
