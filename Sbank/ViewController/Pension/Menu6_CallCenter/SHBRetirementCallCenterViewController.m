//
//  SHBRetirementCallCenterViewController.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBRetirementCallCenterViewController.h"

@interface SHBRetirementCallCenterViewController ()

@end

@implementation SHBRetirementCallCenterViewController


#pragma mark -
#pragma mark Button Action

- (IBAction)buttonDidPush:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://1577-4114"]];
}


#pragma mark -
#pragma mark Xcode Generate

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
    
    // title 설정
    self.title = @"퇴직연금 콜센터";
    self.strBackButtonTitle = @"퇴직연금 콜센터";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
