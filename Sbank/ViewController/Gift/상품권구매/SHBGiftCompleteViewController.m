//
//  SHBGiftCompleteViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 23..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGiftCompleteViewController.h"

@interface SHBGiftCompleteViewController ()

@end

@implementation SHBGiftCompleteViewController

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
    
    [self setTitle:@"모바일상품권"];
    [self navigationBackButtonHidden];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.navigationController fadePopToRootViewController];
}

@end