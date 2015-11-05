//
//  SHBSShieldFinishViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 6. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSShieldFinishViewController.h"

@interface SHBSShieldFinishViewController ()

@end

@implementation SHBSShieldFinishViewController

- (void)dealloc
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
    [self setTitle:@"S-Shield"];
    [self navigationBackButtonHidden];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmClick:(id)sender
{
    AppInfo.lastViewController = nil;
    [AppDelegate.navigationController fadePopToRootViewController];
}
@end
