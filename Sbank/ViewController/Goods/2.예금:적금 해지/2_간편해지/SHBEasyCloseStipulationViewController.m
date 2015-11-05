//
//  SHBEasyCloseStipulationViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 23..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBEasyCloseStipulationViewController.h"

@interface SHBEasyCloseStipulationViewController ()

@end

@implementation SHBEasyCloseStipulationViewController

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
    
    [self setTitle:@"신한e-간편해지"];
    
    [_mainSV addSubview:_mainView];
    [_mainSV setContentSize:_mainView.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_mainSV release];
    [_mainView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainSV:nil];
    [self setMainView:nil];
    [super viewDidUnload];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.navigationController fadePopViewController];
}

@end
