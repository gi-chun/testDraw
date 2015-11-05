//
//  SHBCertIssueStep6ReViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertIssueStep6ReViewController.h"
#import "SHBCertIssueStep7ViewController.h"

@interface SHBCertIssueStep6ReViewController ()

@end

@implementation SHBCertIssueStep6ReViewController

@synthesize transDataSet;
@synthesize isFirstLoginSetting;

- (void) dealloc
{
    
    [transDataSet release];
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
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"Issue/ Reissue Digital Certificate";
        [self navigationBackButtonEnglish];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"電子証明書の発行・再発行";;
        [self navigationBackButtonJapnes];
    }else
    {
        self.title = @"인증서 발급/재발급";
        self.strBackButtonTitle = @"인증서 발급/재발급 6단계";
    }
    
    [self navigationBackButtonHidden];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) confirmClick:(id)sender
{
    
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        SHBCertIssueStep7ViewController *viewController = [[SHBCertIssueStep7ViewController alloc] initWithNibName:@"SHBCertIssueStep7ViewControllerEng" bundle:nil];
        
        viewController.transDataSet = self.transDataSet;
        viewController.isFirstLoginSetting = self.isFirstLoginSetting;
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        SHBCertIssueStep7ViewController *viewController = [[SHBCertIssueStep7ViewController alloc] initWithNibName:@"SHBCertIssueStep7ViewControllerJpn" bundle:nil];
        
        viewController.transDataSet = self.transDataSet;
        viewController.isFirstLoginSetting = self.isFirstLoginSetting;
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
    }else
    {
        SHBCertIssueStep7ViewController *viewController = [[SHBCertIssueStep7ViewController alloc] initWithNibName:@"SHBCertIssueStep7ViewController" bundle:nil];
        
        viewController.transDataSet = self.transDataSet;
        viewController.isFirstLoginSetting = self.isFirstLoginSetting;
        [self.navigationController pushFadeViewController:viewController];
        [viewController release];
    }
}
- (IBAction) cancelClick:(id)sender
{
    
}

@end
