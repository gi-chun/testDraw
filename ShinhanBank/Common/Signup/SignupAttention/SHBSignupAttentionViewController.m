//
//  SHBSignupAttentionViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSignupAttentionViewController.h"

@interface SHBSignupAttentionViewController ()

@end

@implementation SHBSignupAttentionViewController

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

- (IBAction)buttonPressed:(UIButton*)sender{
	[self.navigationController fadePopViewController];
}


@end
