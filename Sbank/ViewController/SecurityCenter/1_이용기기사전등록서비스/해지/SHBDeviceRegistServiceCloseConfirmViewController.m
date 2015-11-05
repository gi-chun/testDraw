//
//  SHBDeviceRegistServiceCloseConfirmViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 7. 30..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBDeviceRegistServiceCloseConfirmViewController.h"
#import "SHBSecurityCenterService.h" // 서비스

#import "SHBDeviceRegistServiceCloseCompleteViewController.h" // 이용기기 등록 서비스 해지완료
#import "SHBDeviceRegistServiceCloseInfoViewController.h" // 이용기기 등록 서비스 해지

#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

@interface SHBDeviceRegistServiceCloseConfirmViewController ()
<SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP

@end

@implementation SHBDeviceRegistServiceCloseConfirmViewController

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
                                             selector:@selector(deviceRegistServiceCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    
    // 전자서명 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceRegistServiceCancel)
                                                 name:@"eSignCancel"
                                               object:nil];
    
    [self setTitle:@"이용기기 등록 서비스"];
    self.strBackButtonTitle = @"이용기기 등록 서비스 해지 확인";
    
    [_subTitle initFrame:_subTitle.frame];
    [_subTitle setCaptionText:@"이체비밀번호 및 보안매체 입력"];
    
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
                   forKey:@"_해지일"
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
    [_subTitle release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setSecurityView:nil];
    [self setSubTitle:nil];
    [super viewDidUnload];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (!AppInfo.errorType) {
        SHBDeviceRegistServiceCloseCompleteViewController *viewController = [[[SHBDeviceRegistServiceCloseCompleteViewController alloc] initWithNibName:@"SHBDeviceRegistServiceCloseCompleteViewController" bundle:nil] autorelease];
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
        
        AppInfo.electronicSignCode = @"E3012_C";
        AppInfo.electronicSignTitle = @"다음과 같이 이용기기 등록 서비스를 해지합니다.";
        
        [AppInfo addElectronicSign:@"신청내용"];
        [AppInfo addElectronicSign:@"(1)이용기기 등록 서비스 해지"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)해지일시: %@", AppInfo.tran_Date]];
        
        NSString *hdd1 = [SHBUtilFile getPhoneUUID2:@"HQ59H9US6W.com.ktb.KeychainSuite"];
        
        if ([hdd1 length] > 20) {
            hdd1 = [hdd1 substringToIndex:20];
        }
        
        SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                @{
                                @"등록해지상태" : @"4",
                                @"업무구분" : @"01",
                                @"MACADDRESS1" : [SHBUtilFile getPhoneUUID1:@"HQ59H9US6W.com.ktb.KeychainSuite"],
                                @"HDD1" : hdd1,
                                }];
        
        self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E3012_SERVICE viewController:self] autorelease];
        self.service.requestData = aDataSet;
        [self.service start];
    }
}

- (void)cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    for (SHBDeviceRegistServiceCloseInfoViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBDeviceRegistServiceCloseInfoViewController") class]]) {
            [viewController.checkBtn setSelected:NO];
            
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
}

@end
