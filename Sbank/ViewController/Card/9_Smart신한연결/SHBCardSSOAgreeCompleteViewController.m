//
//  SHBCardSSOAgreeCompleteViewController.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 24..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBCardSSOAgreeCompleteViewController.h"

@interface SHBCardSSOAgreeCompleteViewController ()

@end

@implementation SHBCardSSOAgreeCompleteViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okBtn:(UIButton *)sender
{
    [self.navigationController fadePopToRootViewController];
}
@end
