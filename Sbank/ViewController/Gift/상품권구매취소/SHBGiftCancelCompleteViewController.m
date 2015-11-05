//
//  SHBGiftCancelCompleteViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGiftCancelCompleteViewController.h"

@interface SHBGiftCancelCompleteViewController ()

@end

@implementation SHBGiftCancelCompleteViewController

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
    
    [self setTitle:@"모바일상품권 구매취소"];
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
