//
//  SHBUDreamMoneyRateViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUDreamMoneyRateViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBUDreamMoneyRateViewController ()

@end

@implementation SHBUDreamMoneyRateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"U드림 저축예금 전환"];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"금리보기" maxStep:0 focusStepNumber:0]autorelease]];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.strURL]];
	[self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
