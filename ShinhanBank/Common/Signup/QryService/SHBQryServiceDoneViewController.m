//
//  SHBQryServiceDoneViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 27..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBQryServiceDoneViewController.h"
#import "SHBLoginViewController.h"
#import "SHBCertManageViewController.h"

@interface SHBQryServiceDoneViewController ()

@end

@implementation SHBQryServiceDoneViewController

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
	
	self.title = @"회원가입";
	self.strBackButtonTitle = @"회원가입 4단계";
	[self navigationBackButtonHidden];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed:(UIButton*)sender{
	[AppDelegate.navigationController fadePopToRootViewController];
    
    AppInfo.lastViewController = nil;
    
    //인증서 있으면 인증서 목록 화면으로 이동 2014.08.26
    if (AppInfo.validCertCount > 0 && [[NSUserDefaults standardUserDefaults]loginTypeForSetting] == SettingsLoginTypeNone)
    {
        AppInfo.certProcessType = CertProcessTypeLogin;
        //인증서가 한개이면 인증서 상세 화면
        if (AppInfo.validCertCount == 1 && AppInfo.selectedCertificate != nil)
        {
            SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertDetailViewController") class] alloc] initWithNibName:@"SHBCertDetailViewController" bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:viewController];
            [viewController release];
        }else
        {
            SHBBaseViewController *viewController = [[[NSClassFromString(@"SHBCertManageViewController") class] alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
            [AppDelegate.navigationController pushFadeViewController:viewController];
            [viewController release];
        }
    }else
    {
        SHBLoginViewController *viewController = [[SHBLoginViewController alloc] initWithNibName:@"SHBLoginViewController" bundle:nil];
        
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
    }
    
}

@end
