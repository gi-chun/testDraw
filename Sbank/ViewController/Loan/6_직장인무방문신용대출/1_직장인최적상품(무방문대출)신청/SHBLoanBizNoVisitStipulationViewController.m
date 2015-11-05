//
//  SHBLoanBizNoVisitStipulationViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitStipulationViewController.h"
#import "SHBLoanService.h"

#import "SHBNewProductSeeStipulationViewController.h" // 약관내용
#import "SHBLoanBizNoVisitInputViewController.h" // 직장인 최적상품(무방문대출) 신청 인적사항 확인
#import "SHBLoanBizNoVisitResultViewController.h" // 직장인 최적상품(무방문대출) 신청

@interface SHBLoanBizNoVisitStipulationViewController ()
{
    BOOL _isSee1;
    BOOL _isSee2;
}

@property (retain, nonatomic) NSArray *collectionList;

@end

@implementation SHBLoanBizNoVisitStipulationViewController

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
    self.strBackButtonTitle = @"직장인 최적상품(무방문대출) 신청 약관";
    
    [_subTitleView initFrame:_subTitleView.frame];
    [_subTitleView setCaptionText:@"직장인 최적상품(무방문대출) 신청"];
    
    FrameReposition(_mainView, 0, 0);
    [_mainSV addSubview:_mainView];
    [_mainSV setContentSize:_mainView.frame.size];
    
    _isSee1 = NO;
    _isSee2 = NO;
    
    self.collectionList = @[ _collectionBtn1_1, _collectionBtn1_2, _collectionBtn2, _collectionBtn3, _collectionBtn4,
                             _collectionBtn5, _collectionBtn6, _collectionBtn7, _collectionBtn8, _collectionBtn9 ];
    
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
    self.collectionList = nil;
    
    [_subTitleView release];
    [_mainSV release];
    [_mainView release];
    [_agreeBtn release];
    [_collectionBtn1_1 release];
    [_collectionBtn1_2 release];
    [_collectionBtn2 release];
    [_collectionBtn3 release];
    [_collectionBtn4 release];
    [_collectionBtn5 release];
    [_collectionBtn6 release];
    [_collectionBtn7 release];
    [_collectionBtn8 release];
    [_collectionBtn9 release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSubTitleView:nil];
    [self setAgreeBtn:nil];
    [self setCollectionBtn1_1:nil];
    [self setCollectionBtn1_2:nil];
    [self setCollectionBtn2:nil];
    [self setCollectionBtn3:nil];
    [self setCollectionBtn4:nil];
    [self setCollectionBtn5:nil];
    [self setCollectionBtn6:nil];
    [self setCollectionBtn7:nil];
    [self setCollectionBtn8:nil];
    [self setCollectionBtn9:nil];
    [super viewDidUnload];
}

#pragma mark - Method

- (void)clearViewData
{
    if (_mainSV.contentOffset.y > 0) {
        
        [_mainSV setContentOffset:CGPointZero];
    }
    
    _isSee1 = NO;
    _isSee2 = NO;
    
    [_agreeBtn setSelected:NO];
    
    for (NSArray *buttonCollection in _collectionList) {
        
        [buttonCollection[0] setSelected:YES];
        [buttonCollection[1] setSelected:NO];
    }
    
    if ([self.data[@"선택정보동의여부"] isEqualToString:@"2"]) {
        
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
        
        return @"개인신용정보 조회 동의서 보기를 선택하여 확인하시기 바랍니다.";
    }
    
    if (![_agreeBtn isSelected]) {
        
        return @"개인신용정보 조회 동의서를 읽고 동의를 선택하시기 바랍니다.";
    }
    
    if (!_isSee2) {
        
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
            
            // 동의서 및 고객권리 안내문 보기
            
            _isSee1 = YES;
            
            NSString *strURL = [NSString stringWithFormat:@"%@p_credit_agree.html", AppInfo.realServer ? URL_YAK : URL_YAK_TEST];
            
            SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
            
            viewController.strUrl = strURL;
            viewController.strName = @"직장인 무방문 신용대출";
            viewController.strBackButtonTitle = @"약관보기";
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        case 20: {
            
            // 예, 동의합니다.
            
            [sender setSelected:![sender isSelected]];
        }
            break;
            
        case 30: {
            
            // 개인(신용)정보 조회 동의서 / 개인(신용)정보 수집, 이용, 제공 동의서 (여신 금융거래) 및 고객권리 안내문 보기
            
            _isSee2 = YES;
            
            NSString *strURL = [NSString stringWithFormat:@"%@pci_lending_01.html", AppInfo.realServer ? URL_YAK : URL_YAK_TEST];
            
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
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      @"업무구분" : @"1",
                                      @"은행구분" : @"1",
                                      @"검색구분" : @"1",
                                      @"고객번호" : AppInfo.customerNo,
                                      @"고객번호1" : AppInfo.customerNo,
                                      @"마케팅활용동의여부" : self.data[@"마케팅활용동의여부"],
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
            
        case 400: {
            
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
            
        case LOAN_L3210_SERVICE: {
            
            [aDataSet insertObject:[NSString stringWithFormat:@"%@-*******", aDataSet[@"주민번호1"]]
                            forKey:@"_주민등록번호"
                           atIndex:0];
            
            if (([aDataSet[@"자택우편번호1"] length] > 0 && [aDataSet[@"자택우편번호2"] length] > 0) &&
                ([aDataSet[@"자택동주소명"] length] > 0 || [aDataSet[@"자택동미만주소"] length] > 0)) {
                
                [aDataSet insertObject:[NSString stringWithFormat:@"%@-%@", aDataSet[@"자택우편번호1"], aDataSet[@"자택우편번호2"]]
                                forKey:@"_자택우편번호"
                               atIndex:0];
                
                [aDataSet insertObject:[NSString stringWithFormat:@"%@ %@", aDataSet[@"자택동주소명"], aDataSet[@"자택동미만주소"]]
                                forKey:@"_자택주소"
                               atIndex:0];
            }
            else {
                
                [aDataSet insertObject:@""
                                forKey:@"_자택우편번호"
                               atIndex:0];
                
                [aDataSet insertObject:@"정보없음"
                                forKey:@"_자택주소"
                               atIndex:0];
            }
            
            if ([aDataSet[@"자택전화지역번호"] length] > 0 && [aDataSet[@"자택전화국번호"] length] > 0 && [aDataSet[@"자택전화통신일련번호"] length] > 0) {
                
                [aDataSet insertObject:[NSString stringWithFormat:@"%@-%@-****", aDataSet[@"자택전화지역번호"], aDataSet[@"자택전화국번호"]]
                                forKey:@"_자택전화번호"
                               atIndex:0];
            }
            else {
                
                [aDataSet insertObject:@"정보없음"
                                forKey:@"_자택전화번호"
                               atIndex:0];
            }
            
            if ([aDataSet[@"이동통신번호통신회사"] length] > 0 && [aDataSet[@"이동통신번호국"] length] > 0 && [aDataSet[@"이동통신번호일련번호"] length] > 0) {
                
                [aDataSet insertObject:[NSString stringWithFormat:@"%@-%@-****", aDataSet[@"이동통신번호통신회사"], aDataSet[@"이동통신번호국"]]
                                forKey:@"_휴대폰번호"
                               atIndex:0];
            }
            else {
                
                [aDataSet insertObject:@"정보없음"
                                forKey:@"_휴대폰번호"
                               atIndex:0];
            }
            
            if (([aDataSet[@"직장우편번호1"] length] > 0 && [aDataSet[@"직장우편번호2"] length] > 0) &&
                ([aDataSet[@"직장동주소명"] length] > 0 || [aDataSet[@"직장동미만주소"] length] > 0)) {
                
                [aDataSet insertObject:[NSString stringWithFormat:@"%@-%@", aDataSet[@"직장우편번호1"], aDataSet[@"직장우편번호2"]]
                                forKey:@"_직장우편번호"
                               atIndex:0];
                
                [aDataSet insertObject:[NSString stringWithFormat:@"%@ %@", aDataSet[@"직장동주소명"], aDataSet[@"직장동미만주소"]]
                                forKey:@"_직장주소"
                               atIndex:0];
            }
            else {
                
                [aDataSet insertObject:@""
                                forKey:@"_직장우편번호"
                               atIndex:0];
                
                [aDataSet insertObject:@"정보없음"
                                forKey:@"_직장주소"
                               atIndex:0];
            }
            
            if ([aDataSet[@"직장전화지역번호"] length] > 0 && [aDataSet[@"직장전화국번호"] length] > 0 && [aDataSet[@"직장전화통신일련번호"] length] > 0) {
                
                [aDataSet insertObject:[NSString stringWithFormat:@"%@-%@-****", aDataSet[@"직장전화지역번호"], aDataSet[@"직장전화국번호"]]
                                forKey:@"_직장전화번호"
                               atIndex:0];
            }
            else {
                
                [aDataSet insertObject:@"정보없음"
                                forKey:@"_직장전화번호"
                               atIndex:0];
            }
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
            
        case LOAN_C2315_SERVICE: {
            
            self.data = [NSDictionary dictionaryWithDictionary:aDataSet];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_C2800_SERVICE viewController:self] autorelease];
            [self.service start];
        }
            break;
            
        case LOAN_C2800_SERVICE: {
            
            NSString *strMsg = nil;
            
            NSInteger nResult = [aDataSet[@"인터넷구분수행결과"] integerValue];
            
            if (nResult == 1 || nResult == 3 || nResult == 4) {
                
                strMsg = @"[특정금융거래보고법] 등 관련\n법률에 따라 고객확인이 필요한\n거래이오니 향후 영업점 내점 또는\n인터넷뱅킹 거래시 [고객확인절차]\n이행 됩니다.";
            }
            else if (nResult == 6) {
                
                strMsg = @"[특정금융거래보고법] 등 관련\n법률에 따라 고객확인이 필요한\n거래이오니 향후 영업점 내점 또는\n인터넷뱅킹 거래시 [고객확인절차]\n이행 됩니다.";
            }
            else if (nResult == 2 || nResult == 7) {
                
                strMsg = @"[특정금융거래보고법] 등 관련\n법률에 따라 고객확인이 필요한\n거래이오니 향후 영업점 내점 거래시\n[고객확인절차] 이행 됩니다.";
            }
            
            if (strMsg) {
                
                [UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:strMsg];
                break;
            }
        }
            break;
            
        case LOAN_C2316_SERVICE: {
            
            AppInfo.serviceOption = @"직장인무방문대출";
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                         @"거래구분" : @"5",
                                                                         }];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3668_SERVICE viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        }
            break;
            
        case LOAN_L3668_SERVICE: {
            
            if (![aDataSet[@"신청번호"] isEqualToString:@"0"]) {
                
                SHBLoanBizNoVisitResultViewController *viewController = [[[SHBLoanBizNoVisitResultViewController alloc] initWithNibName:@"SHBLoanBizNoVisitResultViewController" bundle:nil] autorelease];
                
                viewController.L3661Dic = [NSMutableDictionary dictionaryWithDictionary:aDataSet];
                
                [self checkLoginBeforePushViewController:viewController animated:YES];
                
                return NO;
            }
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                          @"거래구분" : @"3"
                                                                          }];
            
            self.service = nil;
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L3210_SERVICE viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case LOAN_L3210_SERVICE: {
            
            NSString *message = [self getErrorMessage2:aDataSet];
            
            if ([message length] > 0) {
                
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:10132
                                 title:@""
                               message:message];
                return NO;
            }
            
            SHBLoanBizNoVisitInputViewController *viewController = [[[SHBLoanBizNoVisitInputViewController alloc] initWithNibName:@"SHBLoanBizNoVisitInputViewController" bundle:nil] autorelease];
            
            viewController.data = [NSDictionary dictionaryWithDictionary:aDataSet];
            viewController.isSelectInfoAgree = [_collectionBtn1_2[0] isSelected] ? YES : NO;
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    return NO;
}

- (NSString *)getErrorMessage2:(OFDataSet *)aDataSet
{
    if ([aDataSet[@"_자택주소"] isEqualToString:@"정보없음"]) {
        
        return @"등록된 자택주소 정보가 없습니다. S뱅크> 고객센터> 고객정보변경을 통해 등록하신 후 이용해 주세요.";
    }
    
    if ([aDataSet[@"_자택전화번호"] isEqualToString:@"정보없음"]) {
        
        return @"등록된 자택전화번호 정보가 없습니다. 고객정보 정비는 가까운 영업점에서 가능합니다.";
    }
    
    if ([aDataSet[@"_휴대폰번호"] isEqualToString:@"정보없음"]) {
        
        return @"등록된 휴대폰번호 정보가 없습니다. 고객정보 정비는 가까운 영업점에서 가능합니다.";
    }
    
    if ([aDataSet[@"_직장주소"] isEqualToString:@"정보없음"]) {
        
        return @"등록된 직장주소 정보가 없습니다. S뱅크> 고객센터> 고객정보변경을 통해 등록하신 후 이용해 주세요.";
    }
    
    if ([aDataSet[@"_직장전화번호"] isEqualToString:@"정보없음"]) {
        
        return @"등록된 직장전화번호 정보가 없습니다. 고객정보 정비는 가까운 영업점에서 가능합니다.";
    }
    
    return @"";
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10132) {
        
        [self.navigationController fadePopToRootViewController];
    }
}

@end
