//
//  SHBNoticeCuponStoreViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 10. 15..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBNoticeCuponStoreViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"         // string 변환 관련 util


@interface SHBNoticeCuponStoreViewController ()

@end

@implementation SHBNoticeCuponStoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"쿠폰조회";
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"금리우대설계서" maxStep:0 focusStepNumber:0] autorelease]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
