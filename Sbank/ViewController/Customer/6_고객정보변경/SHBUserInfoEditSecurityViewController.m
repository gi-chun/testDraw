//
//  SHBUserInfoEditSecurityViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUserInfoEditSecurityViewController.h"
#import "SHBCustomerService.h" // 서비스

#import "SHBUserInfoEditInputViewController.h" // 고객정보변경
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBUserInfoEditSecurityViewController ()
<SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP

@end

@implementation SHBUserInfoEditSecurityViewController

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
    
    // 보안매체 입력 취소
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userInfoEditSecurityCancel)
                                                 name:@"userInfoEditSecurityCancel"
                                               object:nil];
    
    if ([AppInfo.transferDic[@"본인정보이용제공조회시스템"] isEqualToString:@"1"]) {
        
        [self setTitle:@"본인정보 이용제공 조회시스템"];
        
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc] initWithTitle:@"보안매체 입력" maxStep:0 focusStepNumber:0] autorelease]];
    }
    else {
        
        [self setTitle:@"고객정보변경"];
        
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc] initWithTitle:@"보안매체 입력" maxStep:6 focusStepNumber:4] autorelease]];
    }
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType integerValue] == 5) { // OTP
        self.secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        [_secretOTPViewController setTargetViewController:self];
        [_secretOTPViewController setDelegate:self];
        
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

#pragma mark - SHBSecretMedia

- (void)confirmSecretMedia:(OFDataSet *)confirmData result:(BOOL)confirm media:(int)mediaType
{
    if (confirm) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        SHBUserInfoEditInputViewController *viewController = [[[SHBUserInfoEditInputViewController alloc] initWithNibName:@"SHBUserInfoEditInputViewController" bundle:nil] autorelease];
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
}

- (void)cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSString *className = @"";
    
    if ([AppInfo.transferDic[@"본인정보이용제공조회시스템"] isEqualToString:@"1"]) {
        
        className = @"SHBUserInfoUseSupplyViewController";
    }
    else {
        
        className = @"SHBIdentity1ViewController";
    }
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        
        if ([viewController isKindOfClass:NSClassFromString(className)]) {
            
            [self.navigationController fadePopToViewController:viewController];
            
            break;
        }
    }
}

@end
