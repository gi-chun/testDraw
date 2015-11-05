//
//  SHBBranchesSetDistanceViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBranchesSetDistanceViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBBranchesSetDistanceViewController ()

@end

@implementation SHBBranchesSetDistanceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_oneKilo release];
    [_twoKilo release];
    [_threeKilo release];
	[super dealloc];
}
- (void)viewDidUnload {
    [self setOneKilo:nil];
    [self setTwoKilo:nil];
    [self setThreeKilo:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self setTitle:@"영업점/ATM찾기"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc] initWithTitle:@"설정" maxStep:0 focusStepNumber:0] autorelease]];
	
	float distanceSettingValue = [[NSUserDefaults standardUserDefaults] distanceValue];
	
    if (distanceSettingValue == 0) {	// 셋팅된 적이 없으면 초기값 1.0으로 셋팅해줌.
		distanceSettingValue = 1.0;
		[[NSUserDefaults standardUserDefaults] setDistanceValue:distanceSettingValue];
	}
    
    if (distanceSettingValue == 1.0) {
        [_oneKilo setSelected:YES];
    }
    else if (distanceSettingValue == 2.0) {
        [_twoKilo setSelected:YES];
    }
    else if (distanceSettingValue == 3.0) {
        [_threeKilo setSelected:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)selectRadius:(UIButton *)sender
{
    [_oneKilo setSelected:NO];
    [_twoKilo setSelected:NO];
    [_threeKilo setSelected:NO];
    
    if (sender.tag == 1) {
        [_oneKilo setSelected:YES];
    }
    else if (sender.tag == 2) {
        [_twoKilo setSelected:YES];
    }
    else if (sender.tag == 3) {
        [_threeKilo setSelected:YES];
    }
    
    [[NSUserDefaults standardUserDefaults] setDistanceValue:(float)sender.tag];
}

- (IBAction)confirmBtnAction:(SHBButton *)sender
{
	[self.navigationController fadePopViewController];
}

@end
