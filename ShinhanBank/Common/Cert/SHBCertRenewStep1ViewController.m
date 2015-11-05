//
//  SHBCertRenewStep1ViewController.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertRenewStep1ViewController.h"
#import "SHBCertManageViewController.h"

@interface SHBCertRenewStep1ViewController ()

@end

@implementation SHBCertRenewStep1ViewController
@synthesize infoStr1;
@synthesize infoStr2;
@synthesize isFirstLoginSetting;
- (void) dealloc
{
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
        self.title = @"Certificate renewal";
        [self navigationBackButtonEnglish];
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        self.title = @"電子証明書更新";
        [self navigationBackButtonJapnes];
    }else
    {
        self.title = @"인증서 갱신";
        self.infoStr1.text = @"스마트폰에서 인증서를 갱신하는 경우 스마트폰에서\n갱신한 인증서를 '스마트폰→PC 인증서 복사' 후\n사용하실수 있습니다.";
        self.infoStr2.text = @"PC등에 저장된 인증서를 계속 사용하시려면\nPC에서 인증서 갱신 후 스마트폰으로\n복사하십시오.";
        self.strBackButtonTitle = @"인증서 갱신 1단계";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) confirmClick:(id)sender
{
    SHBCertManageViewController *viewController = [[SHBCertManageViewController alloc] initWithNibName:@"SHBCertManageViewController" bundle:nil];
    [self.navigationController pushFadeViewController:viewController];
    AppInfo.certProcessType = CertProcessTypeRenew;
    if (AppInfo.LanguageProcessType == EnglishLan)
    {
        viewController.title = @"Certificate renewal";
    }else if (AppInfo.LanguageProcessType == JapanLan)
    {
        viewController.title = @"電子証明書更新";
    }else
    {
        viewController.title = @"인증서 갱신";
    }
    
    [viewController release];
}
- (IBAction) cancelClick:(id)sender
{
    [self.navigationController fadePopViewController];
}

@end
