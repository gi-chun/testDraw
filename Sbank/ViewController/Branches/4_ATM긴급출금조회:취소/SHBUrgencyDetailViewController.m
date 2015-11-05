//
//  SHBUrgencyDetailViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUrgencyDetailViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBBranchesService.h"
#import "SHBUrgencyCancelConfirmViewController.h"

@interface SHBUrgencyDetailViewController ()

@end

@implementation SHBUrgencyDetailViewController

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
    [_lblRequestDate release];
    [_lblRequestCnt release];
    [_lblPWErrorCnt release];
    [_lblPaymentDate release];
    [_lblCancelDate release];
	[_vOneBtn release];
	[_vTwoBtn release];
	[_btnSendSMS release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLblAccountNum:nil];
    [self setLblAmount:nil];
    [self setLblPhoneNum:nil];
    [self setLblRequestDate:nil];
    [self setLblRequestCnt:nil];
    [self setLblPWErrorCnt:nil];
    [self setLblPaymentDate:nil];
    [self setLblCancelDate:nil];
	[self setVOneBtn:nil];
	[self setVTwoBtn:nil];
	[self setBtnSendSMS:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        [self.contentScrollView setFrame:CGRectMake(self.contentScrollView.frame.origin.x, self.contentScrollView.frame.origin.y, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height - 20)];
    }
	[self setTitle:@"ATM긴급출금조회/취소"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
    
    // ios7상단 스크롤
    FrameResize(self.scrollView, 317, height(self.scrollView));
    FrameReposition(self.scrollView, 0, 77);
    
    
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"ATM긴급출금 조회" maxStep:0 focusStepNumber:0]autorelease]];
	
	[self.lblAccountNum setText:[self.data objectForKey:@"2"]];
	[self.lblAmount setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"거래금액"]]];
	[self.lblPhoneNum setText:[self.data objectForKey:@"SMS송신휴대폰번호"]];
	[self.lblRequestDate setText:[self.data objectForKey:@"등록일자"]];
	[self.lblRequestCnt setText:[self.data objectForKey:@"등록회차"]];
	[self.lblPWErrorCnt setText:[self.data objectForKey:@"비밀번호오류횟수"]];
	[self.lblPaymentDate setText:[self.data objectForKey:@"지급일자"]];
	[self.lblCancelDate setText:[self.data objectForKey:@"등록취소일자"]];
	
	if ([[self.data objectForKey:@"지급일자"]length] || [[self.data objectForKey:@"등록취소일자"]length]) {
		[self.vOneBtn setHidden:NO];
	}
	else
	{
		[self.btnSendSMS setHidden:NO];
		[self.vTwoBtn setHidden:NO];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)sendSMSBtnAction:(SHBButton *)sender {
	self.service = [[[SHBBranchesService alloc]initWithServiceId:kE1703Id viewController:self]autorelease];
	self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
								@"SMS송신휴대폰번호" : [self.data objectForKey:@"SMS송신휴대폰번호"],
								@"지급번호" : [self.data objectForKey:@"지급번호"],
								}];
	[self.service start];
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopViewController];
}

- (IBAction)cancelPaymentBtnAction:(SHBButton *)sender {
	SHBUrgencyCancelConfirmViewController *viewController = [[[SHBUrgencyCancelConfirmViewController alloc]initWithNibName:@"SHBUrgencyCancelConfirmViewController" bundle:nil]autorelease];
	viewController.data = self.data;
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

#pragma mark - Http Delegate
- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	if (AppInfo.errorType != nil) {
		return NO;
	}
	
	return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
	Debug(@"aDataSet : %@", aDataSet);
	if (self.service.serviceId == kE1703Id) {
		NSString *strPhoneNum = [aDataSet objectForKey:@"SMS송신휴대폰번호"];
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:[NSString stringWithFormat:@"고객님께서 요청하신 긴급출금서비스의 \"긴급출금 인증번호\"를 휴대폰번호(%@)로 전송하였습니다.", strPhoneNum]];
	}
	
	return NO;
}

@end
