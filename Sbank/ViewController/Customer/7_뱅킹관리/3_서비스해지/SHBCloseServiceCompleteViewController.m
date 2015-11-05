//
//  SHBCloseServiceCompleteViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCloseServiceCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBCloseServiceCompleteViewController ()

@end

@implementation SHBCloseServiceCompleteViewController

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
    [AppInfo logout];
	[self setTitle:@"서비스해지"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"서비스해지 완료" maxStep:0 focusStepNumber:0]autorelease]];
    [self navigationBackButtonHidden];
    [self changeQuickLogin:NO];
    
    //if (floor(NSFoundationVersionNumber)  <= NSFoundationVersionNumber_iOS_6_1)
    //{
        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y - 20, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
    //}
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
    
	[self.navigationController fadePopToRootViewController];
}

@end
