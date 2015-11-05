//
//  SHBSimpleLoanStipulationViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSimpleLoanStipulationViewController.h"
#import "SHBLoanService.h" // service

#import "SHBSimpleLoanInfoViewController.h" // 약정업체 간편대출 안내
#import "SHBNewProductSeeStipulationViewController.h" // 약관내용
#import "SHBSimpleLoanInputViewController.h" // 약정업체 간편대출 - 정보입력(1)

@interface SHBSimpleLoanStipulationViewController ()
{
    BOOL _isSee1;
    BOOL _isSee2;
}

@property (retain, nonatomic) NSArray *collectionList;

@end

@implementation SHBSimpleLoanStipulationViewController

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
    self.strBackButtonTitle = @"약정업체 간편대출 약관동의";
    
    [_mainView setFrame:CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height)];
    [_mainSV addSubview:_mainView];
    [_mainSV setContentSize:_mainView.frame.size];
    
    _isSee1 = NO;
    _isSee2 = NO;
    
    self.collectionList = @[ _collectionBtn1_1, _collectionBtn1_2, _collectionBtn2, _collectionBtn3, _collectionBtn4,
                             _collectionBtn5, _collectionBtn6, _collectionBtn7, _collectionBtn8, _collectionBtn9 ];
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동
    AppInfo.isNeedBackWhenError = YES;
    
    SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                            @{
                              @"고객번호" : AppInfo.customerNo,
                              }];
    
    self.service = nil;
    self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L1550_SERVICE viewController:self] autorelease];
    self.service.requestData = aDataSet;
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.collectionList = nil;
    
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
        
        if ([buttonCollection count] >= 2) {
            
            [buttonCollection[0] setSelected:YES];
            [buttonCollection[1] setSelected:NO];
        }
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
            viewController.strName = @"약정업체 간편대출";
            viewController.strBackButtonTitle = @"상세보기";
            
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
            viewController.strName = @"약정업체 간편대출";
            viewController.strBackButtonTitle = @"상세보기";
            
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
            self.service = [[[SHBLoanService alloc] initWithServiceId:LOAN_L1560_SERVICE viewController:self] autorelease];
            self.service.requestData = aDataSet;
            [self.service start];
        }
            break;
            
        case 400: {
            
            // 취소
            
            for (SHBSimpleLoanInfoViewController *viewController in self.navigationController.viewControllers) {
                
                if ([viewController isKindOfClass:[SHBSimpleLoanInfoViewController class]]) {
                    
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
        
        case LOAN_L1550_SERVICE: {
            
            self.data = [NSDictionary dictionaryWithDictionary:aDataSet];
        }
            break;
            
        case LOAN_L1560_SERVICE: {
            
            SHBSimpleLoanInputViewController *viewController = [[[SHBSimpleLoanInputViewController alloc] initWithNibName:@"SHBSimpleLoanInputViewController" bundle:nil] autorelease];
            
            [self checkLoginBeforePushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

@end
