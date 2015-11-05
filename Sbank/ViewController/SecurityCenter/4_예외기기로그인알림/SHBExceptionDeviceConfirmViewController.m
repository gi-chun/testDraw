//
//  SHBExceptionDeviceConfirmViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 2. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBExceptionDeviceConfirmViewController.h"
#import "SHBSecurityCenterService.h" // 서비스

#import "SHBExceptionDeviceViewController.h" // 예외 기기 로그인 알림 안내
#import "SHBExceptionDeviceCompleteViewController.h" // 예외 기기 로그인 알림 완료

#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

@interface SHBExceptionDeviceConfirmViewController ()
<SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP

@property (retain, nonatomic) OFDataSet *viewDataSet;

@end

@implementation SHBExceptionDeviceConfirmViewController

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
    
    [self setTitle:@"예외 기기 로그인 알림"];
    self.strBackButtonTitle = @"예외 기기 로그인 알림 확인";
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType integerValue] == 5) { // OTP
        self.secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        [_secretOTPViewController setTargetViewController:self];
        [_secretOTPViewController setDelegate:self];
        [_secretOTPViewController setNextSVC:@"E3021"];
        
        [_securityView setFrame:CGRectMake(0,
                                           _securityView.frame.origin.y,
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
        [_secretCardViewController setNextSVC:@"E3021"];
        
        [_securityView setFrame:CGRectMake(0,
                                           _securityView.frame.origin.y,
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
    
    self.viewDataSet = [OFDataSet dictionaryWithDictionary:@{ @"_등록일자" : AppInfo.tran_Date,
                                                              @"_등록시간" : AppInfo.tran_Time,
                                                              @"_휴대폰번호" : AppInfo.commonDic[@"휴대폰번호"],
                                                              @"_휴대폰번호표시용" : AppInfo.commonDic[@"휴대폰번호표시용"] }];
    [self.binder bind:self dataSet:_viewDataSet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.viewDataSet = nil;
    
    [_securityView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSecurityView:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        SHBExceptionDeviceCompleteViewController *viewController = [[[SHBExceptionDeviceCompleteViewController alloc] initWithNibName:@"SHBExceptionDeviceCompleteViewController" bundle:nil] autorelease];
        
        viewController.data = (NSDictionary *)_viewDataSet;
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)electronicSignCancel
{
    [self cancelSecretMedia];
}

#pragma mark - SHBSecretMedia

- (void)confirmSecretMedia:(OFDataSet *)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if (confirm) {
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"예외 기기 로그인 알림";
        
        AppInfo.electronicSignCode = @"E3021";
        AppInfo.electronicSignTitle = @"다음과 같이 예외 기기 로그인 알림을 신청합니다.";
        
        [AppInfo addElectronicSign:@"1.신청내용"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일자: %@", _viewDataSet[@"_신청일자"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)신청시간: %@", _viewDataSet[@"_신청시간"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)휴대폰번호(인증/통지): %@", _viewDataSet[@"_휴대폰번호표시용"]]];
        
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                      @"휴대폰번호" : _viewDataSet[@"_휴대폰번호"],
                                                                      @"MAC1" : [SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"] }];
        
        self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E3021_SERVICE viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
    }
}

- (void)cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (SHBExceptionDeviceViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBExceptionDeviceViewController") class]])
        {
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
}

@end
