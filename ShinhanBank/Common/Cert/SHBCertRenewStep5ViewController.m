//
//  SHBCertRenewStep4ViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertRenewStep5ViewController.h"

@interface SHBCertRenewStep5ViewController ()

@end


@implementation SHBCertRenewStep5ViewController
@synthesize isFirstLoginSetting;

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
        self.title = @"Certificate renewal";
        [self navigationBackButtonEnglish];
        [self navigationBackButtonHidden];
    } else if(AppInfo.LanguageProcessType == EnglishLan)
    {
        self.title = @"Certificate renewal";
        [self navigationBackButtonEnglish];
        [self navigationBackButtonHidden];
    }else
    {
        self.title = @"인증서 갱신";
        self.strBackButtonTitle = @"인증서 갱신 5단계";
        [self navigationBackButtonHidden];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) confirmClick:(id)sender
{
    AppInfo.certProcessType = CertProcessTypeNo;
    [self.navigationController fadePopToRootViewController];
}

@end
