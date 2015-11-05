//
//  SHBNoCertForCertLogInViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNoCertForCertLogInViewController.h"
#import "SHBLoginViewController.h"
#import "SHBCertMovePhoneViewController.h"
#import "SHBCertCopyQRViewController.h"
#import "SHBCertIssueStep1ViewController.h"
@interface SHBNoCertForCertLogInViewController ()

@end

@implementation SHBNoCertForCertLogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (AppInfo.isLogin == LoginTypeIDPW)
    {
        self.idBtn.hidden = YES;
    }else
    {
        self.idBtn.hidden = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.certCopyPCBtnLabel.text = @"PC➞스마트폰\n인증서 복사";
    //self.certCopyQRBtnLabel.text = @"인증서 간편복사";
    //self.certIssueBtnLabel.text = @"인증서 발급/\n재발급";
    //self.title = @"인증서 관리";
    self.title = @"공인인증서 로그인";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) certCopyPCClick:(id)sender
{
    AppInfo.certProcessType = CertProcessTypeCopySmart;
    
    SHBCertMovePhoneViewController *viewController = [[SHBCertMovePhoneViewController alloc] initWithNibName:@"SHBCertMovePhoneViewController" bundle:nil];
    //viewController.isFirstLoginSetting = YES;
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}
- (IBAction) certCopyQRClick:(id)sender
{
    AppInfo.certProcessType = CertProcessTypeCopyQR;
    SHBCertCopyQRViewController *viewController = [[SHBCertCopyQRViewController alloc] initWithNibName:@"SHBCertCopyQRViewController" bundle:nil];
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}
- (IBAction) certIssueClick:(id)sender
{
    AppInfo.certProcessType = CertProcessTypeIssue;
    SHBCertIssueStep1ViewController *viewController = [[SHBCertIssueStep1ViewController alloc] initWithNibName:@"SHBCertIssueStep1ViewController" bundle:nil];
    //viewController.isFirstLoginSetting = YES;
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}

- (IBAction) idpwdClick:(id)sender
{
    [AppDelegate.navigationController fadePopViewController];
    
    SHBLoginViewController *viewController = [[SHBLoginViewController alloc] initWithNibName:@"SHBLoginViewController" bundle:nil];
    [AppDelegate.navigationController pushFadeViewController:viewController];
    [viewController release];
}

@end
