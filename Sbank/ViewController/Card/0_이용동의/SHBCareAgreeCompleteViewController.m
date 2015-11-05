//
//  SHBCareAgreeCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCareAgreeCompleteViewController.h"

@interface SHBCareAgreeCompleteViewController ()

@end

@implementation SHBCareAgreeCompleteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"신한카드"];
    [self navigationBackButtonHidden];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button

- (IBAction)okBtn:(UIButton *)sender
{
    [self.navigationController fadePopToRootViewController];
}

@end
