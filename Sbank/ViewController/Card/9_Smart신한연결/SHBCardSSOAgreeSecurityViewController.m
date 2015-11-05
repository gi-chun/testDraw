//
//  SHBCardSSOAgreeSecurityViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 18..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBCardSSOAgreeSecurityViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBVersionService.h"
#import "SHBCardSSOAgreeCompleteViewController.h"

@interface SHBCardSSOAgreeSecurityViewController ()
<SHBSecretCardDelegate, SHBSecretOTPDelegate>
@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP
@end

@implementation SHBCardSSOAgreeSecurityViewController
@synthesize securityView;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.secretOTPViewController = nil;
    self.secretCardViewController = nil;
    
    [self.securityView release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setTitle:@"신한카드"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 전자서명 확인
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignResult:)
                                                 name:@"eSignFinalData"
                                               object:nil];
    
    //전자 서명 취소를 받는다
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"notiESignError" object:nil];
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType integerValue] == 5) { // OTP
        self.secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        [_secretOTPViewController setTargetViewController:self];
        [_secretOTPViewController setDelegate:self];
        [_secretOTPViewController setNextSVC:@"E4304"]; // 130819, 보안카드 사고예방 방어코드
        
        [self.securityView setFrame:CGRectMake(0,
                                           0,
                                           self.securityView.frame.size.width,
                                           _secretOTPViewController.view.bounds.size.height + 1)];
        [self.secretOTPViewController setSelfPosY:self.securityView.frame.origin.y + 37];
        
        [self.securityView addSubview:_secretOTPViewController.view];
        
        [self.secretOTPViewController.view setFrame:CGRectMake(0,
                                                           0,
                                                           _secretOTPViewController.view.bounds.size.width,
                                                           _secretOTPViewController.view.bounds.size.height)];
    }
    else {
        self.secretCardViewController = [[[SHBSecretCardViewController alloc] init] autorelease];
        [_secretCardViewController setTargetViewController:self];
        [_secretCardViewController setDelegate:self];
        [_secretCardViewController setNextSVC:@"E4304"]; // 130819, 보안카드 사고예방 방어코드
        
        [self.securityView setFrame:CGRectMake(0,
                                           0,
                                           self.securityView.frame.size.width,
                                           _secretCardViewController.view.bounds.size.height + 1)];
        [self.secretCardViewController setSelfPosY:self.securityView.frame.origin.y + 37];
        
        [self.securityView addSubview:_secretCardViewController.view];
        
        [_secretCardViewController setMediaCode:[secutryType integerValue] previousData:nil];
        [_secretCardViewController.view setFrame:CGRectMake(0,
                                                            0,
                                                            _secretCardViewController.view.bounds.size.width,
                                                            _secretCardViewController.view.bounds.size.height)];
    }
}

- (void)viewDidUnload
{
    [self setSecurityView:nil];
	[super viewDidUnload];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - SHBSecretMedia

- (void)confirmSecretMedia:(OFDataSet *)confirmData result:(BOOL)confirm media:(int)mediaType
{
    
    if (confirm) {

        
        AppInfo.electronicSignString = @"";
        AppInfo.eSignNVBarTitle = @"신한카드";
        //
        AppInfo.electronicSignCode = @"SSO012";
        AppInfo.electronicSignTitle = @"신한카드 이용약관 동의";
        
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
        [AppInfo addElectronicSign:@"(3)서비스명: 신한카드 이용약관동의"];
        
        SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                    @{
                                                           TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKSsoService",
                                                         TASK_ACTION_KEY : @"insertGroupSsoAgree",
                                    @"deviceId" : [AppDelegate getSSODeviceID],
                                    @"appStatus" : @"MAKE",
                                    @"GROUP_CODE" : @"S012",
                                    //@"COM_SUBCHN_KBN" :@"02",
                                    }] autorelease];
        
        self.service = nil;
        self.service = [[[SHBVersionService alloc] initWithServiceId:CARD_SSO_AGREE viewController:self] autorelease];
        self.service.previousData = forwardData;
        [self.service start];
    }
    
}

- (void)cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cardAgreeSecurityCancel"
                                                        object:nil];
    
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
}

- (void)getElectronicSignResult:(NSNotification *)notification
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // dealloc bug 관련
    for (UIViewController *viewController in self.navigationController.viewControllers)
    {
        if ([viewController isKindOfClass:[NSClassFromString(@"SHBCardAgreeViewController") class]])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:viewController];
            
            break;
        }
    }
    
    if (!AppInfo.errorType)
    {
        
        SHBCardSSOAgreeCompleteViewController *viewController = [[[SHBCardSSOAgreeCompleteViewController alloc] initWithNibName:@"SHBCardSSOAgreeCompleteViewController" bundle:nil] autorelease];
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
    
}

// 전자서명 취소시
- (void)getElectronicSignCancel
{
    
    if ([AppDelegate.navigationController.viewControllers count] == 6)
    {
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
        [AppDelegate.navigationController fadePopViewController];
    }
    
}
@end
