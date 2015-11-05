//
//  SHBUserPWRegCompleteViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUserPWRegCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBLoginViewController.h"

@interface SHBUserPWRegCompleteViewController ()

@end

@implementation SHBUserPWRegCompleteViewController
@synthesize showView;

- (void)dealloc
{
    [showView release];
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
	[self setTitle:@"이용자 비밀번호 등록"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이용자 비밀번호 등록완료" maxStep:5 focusStepNumber:5]autorelease]];
	[self navigationBackButtonHidden];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.showView setFrame:CGRectMake(self.showView.frame.origin.x, self.showView.frame.origin.y - 20, self.showView.frame.size.width, self.showView.frame.size.height)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)confirmBtnAction:(SHBButton *)sender
{
	[self.navigationController fadePopToRootViewController];

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
        UIViewController *viewController = [[[NSClassFromString(LOGIN_CLASS) class] alloc] initWithNibName:LOGIN_CLASS bundle:nil];
        [SHBAppInfo sharedSHBAppInfo].lastViewController = viewController;
        [AppDelegate.navigationController pushFadeViewController:viewController];
        [viewController release];
    }
	
}

@end
