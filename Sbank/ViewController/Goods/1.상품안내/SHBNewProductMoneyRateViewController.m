//
//  SHBNewProductMoneyRateViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNewProductMoneyRateViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"

@interface SHBNewProductMoneyRateViewController ()

@end

@implementation SHBNewProductMoneyRateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_dicSelectedData release];
	[_strURL release];
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
	[self setTitle:@"예금/적금 가입"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[self.dicSelectedData objectForKey:@"상품명"] maxStep:0 focusStepNumber:0]autorelease]];
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:self.strURL]]];
	[self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
