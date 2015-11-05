//
//  SHBSignupServiceStep3ViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSignupServiceStep3ViewController.h"
#import "SHBCertDetailViewController.h"
@interface SHBSignupServiceStep3ViewController ()

@end

@implementation SHBSignupServiceStep3ViewController

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
	self.title = @"신한S뱅크가입";
    self.strBackButtonTitle = @"신한S뱅크가입 3단계";
	[self navigationBackButtonHidden];
    //AppInfo.isRegisterAccountService = YES;
    //[AppInfo logout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100: {
            
            //    AppInfo.certProcessType = CertProcessTypeLogin;
            //	[AppDelegate.navigationController popViewControllerAnimated:NO];	// 서비스가입 Step3
            //	[AppDelegate.navigationController popViewControllerAnimated:NO];	// 서비스가입 Step2
            //	[AppDelegate.navigationController popViewControllerAnimated:NO];	// 서비스가입 Step1
            //[AppDelegate.navigationController fadePopToRootViewController];
            
            [AppDelegate.navigationController fadePopToRootViewController];
            AppInfo.certProcessType = CertProcessTypeLogin;
            AppInfo.lastViewController = nil;
            //상세 화면
            AppInfo.isSignupService = YES;
            SHBCertDetailViewController *viewController = [[SHBCertDetailViewController alloc] init];
            viewController.isSignupProcess = YES;
            [AppDelegate.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
            break;
            
        case 200: {
            
            SHBPushInfo *pushInfo = [SHBPushInfo instance];
            [pushInfo requestOpenURL:@"smartcaremgr://A201" Parm:nil];
        }
            break;
            
        default:
            break;
    }
}

@end
