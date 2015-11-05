//
//  SHBCertIdentityViewController.m
//  ShinhanBank
//
//  Created by RedDragon on 12. 11. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCertIdentityViewController.h"

@interface SHBCertIdentityViewController ()

@end

@implementation SHBCertIdentityViewController

@synthesize subjectLabel;
@synthesize issuerAliasLabel;
@synthesize notAfterLabel;
@synthesize typeLabel;
@synthesize certImageView;
@synthesize confirmBtn;
@synthesize notAfterTitle;

- (void) dealloc
{
    [notAfterTitle release];
    [confirmBtn release];
    [subjectLabel release];
    [issuerAliasLabel release];
    [notAfterLabel release];
    [typeLabel release];
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
    
    self.subjectLabel.text = AppInfo.selectedCertificate.user;
    self.issuerAliasLabel.text = AppInfo.selectedCertificate.issuer;
    self.typeLabel.text = AppInfo.selectedCertificate.type;
    self.notAfterLabel.text = AppInfo.selectedCertificate.expire;
    
    int dDay = [SHBUtility getDDay:self.notAfterLabel.text];
    //int dDay = [SHBUtility getDDay:@"2012-11-23"];
    
    //만료된 인증서인지 확인하고 이미지와 색깔을 바꿔준다.
    if (dDay < 0)
    {
        self.notAfterTitle.textColor = RGB(209, 75, 75);
        self.notAfterLabel.textColor = RGB(209, 75, 75);
        certImageView.image = [UIImage imageNamed:@"icon_certificate_expire.png"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
