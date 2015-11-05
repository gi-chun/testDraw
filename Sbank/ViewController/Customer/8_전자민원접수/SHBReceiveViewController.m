//
//  SHBReceiveViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 9. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBReceiveViewController.h"

@interface SHBReceiveViewController ()

@end

@implementation SHBReceiveViewController

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
    
     self.title = @"전자민원 접수";
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)okBtn:(UIButton *)sender
{
   NSString *strNumber = @"telprompt://080-023-0182";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strNumber]];
    
}
- (IBAction)cancelBtn:(UIButton *)sender 
{
    [self.navigationController fadePopToRootViewController];
}

@end
