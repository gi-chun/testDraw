//
//  SHBLoanMyLimitResultViewController.m
//  ShinhanBank
//
//  Created by Joon on 2014. 5. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanMyLimitResultViewController.h"

@interface SHBLoanMyLimitResultViewController ()

@end

@implementation SHBLoanMyLimitResultViewController

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
    
    [self setTitle:@"예상 대출 한도 조회"];
    
    [_attentionLabel initFrame:_attentionLabel.frame];
    [_attentionLabel setText:[NSString stringWithFormat:@"<midGray_13>고객님의 신용대출(예상) 가능 한도는</midGray_13><midLightBlue_13> %@원 </midLightBlue_13><midGray_13>입니다.</midGray_13>", self.data[@"_대출한도"]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_attentionLabel release];
    [super dealloc];
}

#pragma mark - Button

- (IBAction)buttonPressed:(id)sender
{
    [self.navigationController fadePopToRootViewController];
}

@end
