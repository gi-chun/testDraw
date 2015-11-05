//
//  SHBFirstLogInSettingViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFirstLogInSettingViewController.h"
#import "SHBCertMovePhoneViewController.h"
#import "SHBCertCopyQRViewController.h"
#import "SHBLoginViewController.h"
#import "SHBCertIssueStep1ViewController.h"

@interface SHBFirstLogInSettingViewController ()

@end

@implementation SHBFirstLogInSettingViewController
@synthesize certCopyPCBtnLabel;
@synthesize certCopyQRBtnLabel;
@synthesize certIssueBtnLabel;

- (void) dealloc
{
    [certCopyPCBtnLabel release];
    [certCopyQRBtnLabel release];
    [certIssueBtnLabel release];
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
    // Do any additional setup after loading the view from its nib.
    self.title = @"로그인 설정";
    
    //self.certCopyPCBtnLabel.text = @"PC➞스마트폰\n인증서 복사";
    //self.certCopyQRBtnLabel.text = @"인증서 간편복사";
    //self.certIssueBtnLabel.text = @"인증서 발급/\n재발급";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) certCopyPCClick:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
    AppInfo.certProcessType = CertProcessTypeCopySmart;
    SHBCertMovePhoneViewController *viewController = [[SHBCertMovePhoneViewController alloc] initWithNibName:@"SHBCertMovePhoneViewController" bundle:nil];
    viewController.isFirstLoginSetting = YES;
    [AppDelegate.navigationController pushFadeViewController:viewController];
    [viewController release];
}
- (IBAction) certCopyQRClick:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
    AppInfo.certProcessType = CertProcessTypeCopyQR;
    SHBCertCopyQRViewController *viewController = [[SHBCertCopyQRViewController alloc] initWithNibName:@"SHBCertCopyQRViewController" bundle:nil];
    viewController.isFirstLoginSetting = YES;
    [AppDelegate.navigationController pushFadeViewController:viewController];
    [viewController release];
}
- (IBAction) certIssueClick:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
    AppInfo.certProcessType = CertProcessTypeIssue;
    SHBCertIssueStep1ViewController *viewController = [[SHBCertIssueStep1ViewController alloc] initWithNibName:@"SHBCertIssueStep1ViewController" bundle:nil];
    viewController.isFirstLoginSetting = YES;
    [AppDelegate.navigationController pushFadeViewController:viewController];
    [viewController release];
}
- (IBAction) idpwdClick:(id)sender
{
    [self dismissModalViewControllerAnimated:NO];
    //id/pwd 로그인 지정
    [[NSUserDefaults standardUserDefaults]setLoginTypeForSetting:SettingsLoginTypeDefault];
    SHBLoginViewController *viewController = [[SHBLoginViewController alloc] initWithNibName:@"SHBLoginViewController" bundle:nil];
    [AppDelegate.navigationController pushFadeViewController:viewController];
    [viewController release];
    
}
- (IBAction) cancelClick:(id)sender
{
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
