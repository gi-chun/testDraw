//
//  SHBFreqTransferRegCompleteViewController.m
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFreqTransferRegCompleteViewController.h"

@interface SHBFreqTransferRegCompleteViewController ()

@end

@implementation SHBFreqTransferRegCompleteViewController
@synthesize nType;

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(refresh)];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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

    self.title = @"계좌관리";
    
    if(nType == 0)
    {
        _lblTitle.text = @"스피드이체등록 완료";
        _lblData.text = @"스피드이체가 등록되었습니다.";
    }
    else
    {
        _lblTitle.text = @"스피드이체변경 완료";
        _lblData.text = @"스피드이체가 변경되었습니다.";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblTitle release];
    [_lblData release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblTitle:nil];
    [self setLblData:nil];
    [super viewDidUnload];
}
@end
