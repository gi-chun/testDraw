//
//  SHBUrgencyPaymentCompleteViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUrgencyPaymentCompleteViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBUrgencyPaymentCompleteViewController ()

@end

@implementation SHBUrgencyPaymentCompleteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_strRequestDate release];
    [_lblAccountNum release];
    [_lblAmount release];
    [_lblPhoneNum release];
    [_lblRequestDate release];
    [_ivBox release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblAccountNum:nil];
    [self setLblAmount:nil];
    [self setLblPhoneNum:nil];
    [self setLblRequestDate:nil];
    [self setIvBox:nil];
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
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"ATM긴급출금등록 완료" maxStep:3 focusStepNumber:3]autorelease]];
	[self navigationBackButtonHidden];
	[self.ivBox setImage:[[UIImage imageNamed:@"box_infor"]stretchableImageWithLeftCapWidth:2 topCapHeight:2]];
	
	self.lblAccountNum.text = [self.data objectForKey:@"2"];
	self.lblAmount.text = [NSString stringWithFormat:@"%@원", [self.data objectForKey:@"거래금액출력용"]];
	self.lblPhoneNum.text = [self.data objectForKey:@"SMS송신휴대폰번호"];
	self.lblRequestDate.text = self.strRequestDate;
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
