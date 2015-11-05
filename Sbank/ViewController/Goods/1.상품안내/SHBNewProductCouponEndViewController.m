//
//  SHBNewProductCouponEndViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 8. 26..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNewProductCouponEndViewController.h"

@interface SHBNewProductCouponEndViewController ()

@end

@implementation SHBNewProductCouponEndViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [self navigationBackButtonHidden];	// 완료화면에서는 이전버튼이 없단다.
    [self setTitle:@"쿠폰등록"];
    
}


- (IBAction)okButton:(id)sender
{
    [self.navigationController fadePopToRootViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
