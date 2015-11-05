//
//  SHBUrgencyCancelCompleteViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUrgencyCancelCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBUrgencyCancelCompleteViewController ()

@end

@implementation SHBUrgencyCancelCompleteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_lblAccountNum release];
    [_lblAmount release];
    [_lblPhoneNum release];
    [_lblCancelDate release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblAccountNum:nil];
    [self setLblAmount:nil];
    [self setLblPhoneNum:nil];
    [self setLblCancelDate:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
    }
	[self setTitle:@"ATM긴급출금등록"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"ATM긴급출금취소 완료" maxStep:0 focusStepNumber:0]autorelease]];
	[self navigationBackButtonHidden];
	
	[self.lblAccountNum setText:[self.data objectForKey:@"2"]];
	[self.lblAmount setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"거래금액"]]];
	[self.lblPhoneNum setText:[self.data objectForKey:@"SMS송신휴대폰번호"]];
	[self.lblCancelDate setText:[self.data objectForKey:@"등록취소일자"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)confirmBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopToRootViewController];
}

@end
