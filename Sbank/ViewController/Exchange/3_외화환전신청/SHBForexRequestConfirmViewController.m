//
//  SHBForexRequestConfirmViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexRequestConfirmViewController.h"
#import "SHBExchangeService.h" // 서비스

#import "SHBForexRequestCompleteViewController.h" // 외화환전신청 완료
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

@interface SHBForexRequestConfirmViewController ()
<SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP

/// Notification 등록
- (void)initNotification;


@end

@implementation SHBForexRequestConfirmViewController

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
    
    [self setTitle:@"외화환전신청"];
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType integerValue] == 5) { // OTP
        self.secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        [_secretOTPViewController setTargetViewController:self];
        [_secretOTPViewController setDelegate:self];
        _secretOTPViewController.nextSVC = EXCHANGE_F3512;
        
        [_securityView setFrame:CGRectMake(0,
                                           37 + _infoView.frame.size.height,
                                           _securityView.frame.size.width,
                                           _secretOTPViewController.view.bounds.size.height + 1)];
        [_secretOTPViewController setSelfPosY:_securityView.frame.origin.y + 37];
        
        [_securityView addSubview:_secretOTPViewController.view];
        
        [_secretOTPViewController.view setFrame:CGRectMake(0,
                                                           1,
                                                           _secretOTPViewController.view.bounds.size.width,
                                                           _secretOTPViewController.view.bounds.size.height)];
    }
    else {
        self.secretCardViewController = [[[SHBSecretCardViewController alloc] init] autorelease];
        [_secretCardViewController setTargetViewController:self];
        [_secretCardViewController setDelegate:self];
        _secretCardViewController.nextSVC = EXCHANGE_F3512;
        
        [_securityView setFrame:CGRectMake(0,
                                           37 + _infoView.frame.size.height,
                                           _securityView.frame.size.width,
                                           _secretCardViewController.view.bounds.size.height + 1)];
        [_secretCardViewController setSelfPosY:_securityView.frame.origin.y + 37];
        
        [_securityView addSubview:_secretCardViewController.view];
        
        [_secretCardViewController setMediaCode:[secutryType integerValue] previousData:nil];
        [_secretCardViewController.view setFrame:CGRectMake(0,
                                                            1,
                                                            _secretCardViewController.view.bounds.size.width,
                                                            _secretCardViewController.view.bounds.size.height)];
    }
    
    [_securityView bringSubviewToFront:_lineView];
    
    [_mainView setFrame:CGRectMake(0,
                                   0,
                                   _mainView.frame.size.width,
                                   37 + _infoView.frame.size.height + _securityView.frame.size.height)];
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    [self.binder bind:self dataSet:_exchangeDataInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.secretOTPViewController = nil;
    self.secretCardViewController = nil;
    
    self.exchangeDataInfo = nil;
    
    [_mainView release];
    [_securityView release];
    [_infoView release];
    [_lineView release];
	[super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setSecurityView:nil];
    [self setInfoView:nil];
    [self setLineView:nil];
	[super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // dealloc bug 관련
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBForexRequestCouponInputViewController") class]] ||
            [viewController isKindOfClass:[NSClassFromString(@"SHBForexRequestInputViewController") class]]) {
            [[NSNotificationCenter defaultCenter] removeObserver:viewController];
        }
    }
    
    if (!AppInfo.errorType) {
        [_exchangeDataInfo insertObject:[SHBUtility nilToString:[notification userInfo][@"환전번호"]]
                                 forKey:@"환전번호"
                                atIndex:0];
        
        AppInfo.commonDic = [NSMutableDictionary dictionaryWithDictionary:_exchangeDataInfo];
        
        SHBForexRequestCompleteViewController *viewController = [[[SHBForexRequestCompleteViewController alloc] initWithNibName:@"SHBForexRequestCompleteViewController" bundle:nil] autorelease];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    BOOL isPop = NO;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(@"SHBForexRequestInfoViewController")]) {
            isPop = YES;
            
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
    
    if (!isPop) {
        [self.navigationController fadePopToRootViewController];
    }
}

#pragma mark -

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

#pragma mark - SHBSecretMedia

- (void)confirmSecretMedia:(OFDataSet *)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if (confirm) {
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"외화환전신청";
        
        AppInfo.electronicSignCode = EXCHANGE_F3512;
        AppInfo.electronicSignTitle = @"환전 거래 내용";
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)우대서비스: %@", _exchangeDataInfo[@"_우대서비스"]]];
        [AppInfo addElectronicSign:@"(4)환전구분: 외화현찰"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)환전통화: %@", _exchangeDataInfo[@"_환전통화"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)적용환율: %@", _exchangeDataInfo[@"_적용환율"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)환전금액: %@", _exchangeDataInfo[@"_환전금액"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)외화수령지점: %@", _exchangeDataInfo[@"_외화수령지점"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)외화수령일: %@", _exchangeDataInfo[@"_외화수령일"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)환전목적: %@", _exchangeDataInfo[@"_환전목적"]]];
//        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)환전신청인 주민등록번호: %@-*******",
//                                    [AppInfo.ssn substringToIndex:6]]];
//        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)환전신청인 주민등록번호: %@-*******",
//                                            [[AppInfo getPersonalPK] substringToIndex:6]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)환전신청인 주민등록번호: %@",@""]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(12)환전신청인 연락전화번호: %@", _exchangeDataInfo[@"_연락전화번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(13)결제계좌번호: %@", _exchangeDataInfo[@"_출금계좌번호"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(14)환전수령인 성명: %@", _exchangeDataInfo[@"_수령인성명"]]];
//        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(15)환전수령인 주민등록번호: %@-*******",
//                                    [AppInfo.ssn substringToIndex:6]]];
//        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(15)환전수령인 주민등록번호: %@-*******",
//                                        [[AppInfo getPersonalPK] substringToIndex:6]]];
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(15)환전수령인 주민등록번호: %@",@""]];
        [AppInfo addElectronicSign:@"(16)서비스명: 환전신청"];
        
        self.service = nil;
        self.service = [[[SHBExchangeService alloc] initWithServiceId:EXCHANGE_F3512_SERVICE
                                                       viewController:self] autorelease];
        [self.service start];
        
    }
}

- (void)cancelSecretMedia
{
    [self getElectronicSignCancel];
}

@end
