//
//  SHBOldSecurityEndViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 8. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBOldSecurityEndViewController.h"
#import "SHBDeviceRegistServiceViewController.h"

@interface SHBOldSecurityEndViewController ()

@end

@implementation SHBOldSecurityEndViewController

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
    
    [self setTitle:@"구 이용PC 사전등록 변경"];
    
    self.strBackButtonTitle = @"구 이용PC 사전등록 변경";
     [self navigationBackButtonHidden];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okButton:(id)sender
{
    [self.navigationController fadePopToRootViewController];
    
}

@end
