//
//  SHBOTPReplaceCompleteViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBOTPReplaceCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBSettingsViewController.h"

@interface SHBOTPReplaceCompleteViewController ()

@end

@implementation SHBOTPReplaceCompleteViewController

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
	[self setTitle:@"OTP 시간보정"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"OTP 시간보정 완료" maxStep:0 focusStepNumber:0]autorelease]];
	[self navigationBackButtonHidden];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)confirmBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopToRootViewController];
}

@end
