//
//  SHBOverseasIPConfirmViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 3. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBOverseasIPConfirmViewController.h"
#import "SHBSecurityCenterService.h" // 서비스

#import "SHBOverseasIPCompleteViewController.h" // 해외IP 차단신청 확인

#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"


@interface SHBOverseasIPConfirmViewController ()
<SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) SHBSecretCardViewController *secretCardViewController; // 보안카드
@property (retain, nonatomic) SHBSecretOTPViewController *secretOTPViewController; // OTP

@end

@implementation SHBOverseasIPConfirmViewController

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
    
    [self setTitle:@"해외IP 차단신청"];
    self.strBackButtonTitle = @"해외IP 차단신청 확인";
    
    NSString *secutryType = AppInfo.userInfo[@"보안매체정보"];
    
    if ([secutryType integerValue] == 5) { // OTP
        self.secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        [_secretOTPViewController setTargetViewController:self];
        [_secretOTPViewController setDelegate:self];
        [_secretOTPViewController setNextSVC:@"E3021"]; // !!@@ 수정필요
        
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
        [_secretCardViewController setNextSVC:@"E3021"]; // !!@@ 수정필요
        
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
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
        // !!@@ 수정필요
        
//        self.service = [[[SHBSecurityCenterService alloc] initWithServiceId:SECURITY_E3021_SERVICE viewController:self] autorelease];
//        [self.service start];
    }
}

- (void)cancelSecretMedia
{
    [self.navigationController fadePopViewController];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    if (AppInfo.errorType) {
        return NO;
    }
    
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    SHBOverseasIPCompleteViewController *viewController = [[[SHBOverseasIPCompleteViewController alloc] initWithNibName:@"SHBOverseasIPCompleteViewController" bundle:nil] autorelease];
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
    
    return YES;
}

@end
