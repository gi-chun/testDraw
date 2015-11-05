//
//  SHBOverseasIPCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 3. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBOverseasIPCompleteViewController.h"

@interface SHBOverseasIPCompleteViewController ()

@end

@implementation SHBOverseasIPCompleteViewController

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
    
    [self setTitle:@"해외IP 차단신청"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button

- (void)buttonPressed:(UIButton *)sender
{
    [self.navigationController fadePopToRootViewController];
}

@end
