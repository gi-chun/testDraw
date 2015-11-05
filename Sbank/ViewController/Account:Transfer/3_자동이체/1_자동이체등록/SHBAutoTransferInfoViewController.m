//
//  SHBAutoTransferInfoViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAutoTransferInfoViewController.h"

@interface SHBAutoTransferInfoViewController ()

@end

@implementation SHBAutoTransferInfoViewController

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    switch ([sender tag]) {
        case 100:
        {
            [self.navigationController fadePopViewController];
        }
            break;
            
        default:
            break;
    }
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

    self.title = @"자동이체";
    self.contentScrollView.contentSize = CGSizeMake(317, 837);
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
