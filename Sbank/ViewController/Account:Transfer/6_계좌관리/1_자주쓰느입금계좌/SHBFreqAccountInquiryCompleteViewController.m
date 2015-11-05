//
//  SHBFreqAccountInquiryCompleteViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFreqAccountInquiryCompleteViewController.h"

@interface SHBFreqAccountInquiryCompleteViewController ()

@end

@implementation SHBFreqAccountInquiryCompleteViewController
@synthesize service;
@synthesize outAccInfoDic;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [self.navigationController fadePopToRootViewController];
    
//    NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]);
//    if([strController isEqualToString:@"SHBFreqAccountViewController"])
//    {
//        [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(refresh)];
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
//    } else {
//        [self.navigationController fadePopToRootViewController];
//    }
}

- (void)dealloc {
    [_okBtn release];
    
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

    self.title = @"계좌관리";
    [self navigationBackButtonHidden];

    _lblData01.text = AppInfo.commonDic[@"입금은행"];
    _lblData02.text = AppInfo.commonDic[@"입금계좌"];
	NSString *replaceValue = AppInfo.commonDic[@"계좌별명"];
	replaceValue = [replaceValue stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	replaceValue = [replaceValue stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];

    _lblData03.text = replaceValue;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
