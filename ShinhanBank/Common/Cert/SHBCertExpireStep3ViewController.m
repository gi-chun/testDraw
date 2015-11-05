//
//  SHBCertExpireStep3ViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertExpireStep3ViewController.h"

@interface SHBCertExpireStep3ViewController ()

@end

@implementation SHBCertExpireStep3ViewController

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
        self.title = @"Certificate revokation";
        [self navigationBackButtonEnglish];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"電子証明書削除";
        [self navigationBackButtonJapnes];
    }else
    {
        self.title = @"인증서 폐기";
        self.strBackButtonTitle = @"인증서 폐기 3단계";
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
    [self.navigationController fadePopToRootViewController];
}
@end
