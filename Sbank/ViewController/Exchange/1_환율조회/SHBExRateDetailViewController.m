//
//  SHBExRateDetailViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBExRateDetailViewController.h"

@interface SHBExRateDetailViewController ()

@end

@implementation SHBExRateDetailViewController

#pragma mark - Button
/// 확인
- (IBAction)okBtn:(UIButton *)sender
{
    NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]);
    if([strController isEqualToString:@"SHBExRateListViewController"])
    {
        [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(refresh)];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else
    {
        [self.navigationController fadePopToRootViewController];
    }
}

- (void)dealloc
{
    self.detailData = nil;
    
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
    
    self.title = @"환율조회";
    
    self.strBackButtonTitle = @"환율조회 상세";
    
    [self.binder bind:self dataSet:_detailData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
