//
//  SHBCardAgreeSecurityViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCardAgreeSecurityViewController.h"
#import "SHBCardService.h" // 서비스

#import "SHBCareAgreeCompleteViewController.h" // 신한카드 서비스 이용동의 완료
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

@interface SHBCardAgreeSecurityViewController ()
<SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP

@end

@implementation SHBCardAgreeSecurityViewController

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
    
    [self setTitle:@"신한카드"];
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType integerValue] == 5) { // OTP
        self.secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        [_secretOTPViewController setTargetViewController:self];
        [_secretOTPViewController setDelegate:self];
        [_secretOTPViewController setNextSVC:@"E4304"]; // 130819, 보안카드 사고예방 방어코드
        
        [_securityView setFrame:CGRectMake(0,
                                           0,
                                           _securityView.frame.size.width,
                                           _secretOTPViewController.view.bounds.size.height + 1)];
        [_secretOTPViewController setSelfPosY:_securityView.frame.origin.y + 37];
        
        [_securityView addSubview:_secretOTPViewController.view];
        
        [_secretOTPViewController.view setFrame:CGRectMake(0,
                                                           0,
                                                           _secretOTPViewController.view.bounds.size.width,
                                                           _secretOTPViewController.view.bounds.size.height)];
    }
    else {
        self.secretCardViewController = [[[SHBSecretCardViewController alloc] init] autorelease];
        [_secretCardViewController setTargetViewController:self];
        [_secretCardViewController setDelegate:self];
        [_secretCardViewController setNextSVC:@"E4304"]; // 130819, 보안카드 사고예방 방어코드
        
        [_securityView setFrame:CGRectMake(0,
                                           0,
                                           _securityView.frame.size.width,
                                           _secretCardViewController.view.bounds.size.height + 1)];
        [_secretCardViewController setSelfPosY:_securityView.frame.origin.y + 37];
        
        [_securityView addSubview:_secretCardViewController.view];
        
        [_secretCardViewController setMediaCode:[secutryType integerValue] previousData:nil];
        [_secretCardViewController.view setFrame:CGRectMake(0,
                                                            0,
                                                            _secretCardViewController.view.bounds.size.width,
                                                            _secretCardViewController.view.bounds.size.height)];
    }
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
    
    // dealloc bug 관련
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBCardAgreeViewController") class]]) {
            [[NSNotificationCenter defaultCenter] removeObserver:viewController];
            
            break;
        }
    }
    
    if (!AppInfo.errorType) {
        AppInfo.isCardAgree = YES; // 카드이용동의여부 체크
        
        SHBCareAgreeCompleteViewController *viewController = [[[SHBCareAgreeCompleteViewController alloc] initWithNibName:@"SHBCareAgreeCompleteViewController" bundle:nil] autorelease];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

#pragma mark - SHBSecretMedia

- (void)confirmSecretMedia:(OFDataSet *)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if (confirm) {
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"신한카드";
        
        AppInfo.electronicSignCode = CARD_E4304;
        AppInfo.electronicSignTitle = @"신한카드 이용약관 동의";
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
        [AppInfo addElectronicSign:@"(3)서비스명: 신한카드 이용약관동의"];
        
        self.service = nil;
        self.service = [[[SHBCardService alloc] initWithServiceCode:CARD_E4304
                                                     viewController:self] autorelease];
        [self.service start];
    }
}

- (void)cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cardAgreeSecurityCancel"
                                                        object:nil];
}

@end
