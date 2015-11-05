//
//  SHBCertIssueStep6ViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertIssueStep6ViewController.h"
#import "SHBCertIssueStep7ViewController.h"
@interface SHBCertIssueStep6ViewController ()

@end

@implementation SHBCertIssueStep6ViewController
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
    
//    NSString *tmp = self.transDataSet[@"발급_재발급여부"];
//    if (![tmp isEqualToString:@"1"])
//    {
//        //self.view = self.reView;
//        //[self.view bringSubviewToFront:self.reView];
//        [self.view addSubview:self.reView];
//    } else
//    {
//        //self.view = self.firstView;
//        //[self.view bringSubviewToFront:self.firstView];
//        [self.view addSubview:self.firstView];
//    }
    
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
