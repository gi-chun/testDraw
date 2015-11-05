//
//  SHBDeviceRegistServiceDeleteConfirmViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 1. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDeviceRegistServiceDeleteConfirmViewController.h"
#import "SHBSecurityCenterService.h" // 서비스

#import "SHBDeviceRegistServiceDeleteCompleteViewController.h" // 등록폰 삭제 완료

#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

@interface SHBDeviceRegistServiceDeleteConfirmViewController ()
<SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP

@end

@implementation SHBDeviceRegistServiceDeleteConfirmViewController

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
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 전자서명 확인
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignResult:)
                                                 name:@"eSignFinalData"
                                               object:nil];
    
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceRegistServiceCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceRegistServiceCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
    
    [self setTitle:@"이용기기 등록 서비스"];
    self.strBackButtonTitle = @"이용기기 등록 서비스 삭제 확인";
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType integerValue] == 5) { // OTP
        self.secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        [_secretOTPViewController setTargetViewController:self];
        [_secretOTPViewController setDelegate:self];
        [_secretOTPViewController setNextSVC:@"E3012"];
        
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
        [_secretCardViewController setNextSVC:@"E3012"];
        
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
    
    OFDataSet *dataSet = [OFDataSet dictionaryWithDictionary:AppInfo.commonDic];
    
    [dataSet insertObject:AppInfo.tran_Date
                   forKey:@"_삭제일"
                  atIndex:0];
    [dataSet insertObject:AppInfo.commonDic[@"selectData"][@"PC별명"]
                   forKey:@"_PC별명"
                  atIndex:0];
    
    AppInfo.commonDic = dataSet;
    
    [self.binder bind:self dataSet:dataSet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
        SHBDeviceRegistServiceDeleteCompleteViewController *viewController = [[[SHBDeviceRegistServiceDeleteCompleteViewController alloc] initWithNibName:@"SHBDeviceRegistServiceDeleteCompleteViewController" bundle:nil] autorelease];
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)deviceRegistServiceCancel
{
    [self cancelSecretMedia];
}

#pragma mark - SHBSecretMedia

- (void)confirmSecretMedia:(OFDataSet *)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if (confirm) {
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"이용기기 등록 서비스";
        
        AppInfo.electronicSignCode = @"E3012_B";
        AppInfo.electronicSignTitle = @"다음과 같이 이용기기가 삭제 됩니다.";
        
        [AppInfo addElectronicSign:@"신청내용"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)이용기기 별명: %@", AppInfo.commonDic[@"selectData"][@"PC별명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)이용기기 등록일: %@", AppInfo.commonDic[@"selectData"][@"등록일자"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)이용기기 삭제 신청일: %@", AppInfo.tran_Date]];
        
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                @"등록해지상태" : @"9",
                                @"PC별명" : AppInfo.commonDic[@"selectData"][@"PC별명"],
                                @"업무구분" : @"01",
                                @"MACADDRESS1" : AppInfo.commonDic[@"selectData"][@"MACADDRESS"],
                                @"HDD1" : AppInfo.commonDic[@"selectData"][@"HDD1"],
                                }];
        
        self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E3012_SERVICE viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
    }
}

- (void)cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBDeviceRegistServiceListViewController") class]]) {
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
}

@end
