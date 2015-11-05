//
//  SHBLoanInfoViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBLoanInfoViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBLoanStipulationViewController.h"
#import "SHBProductService.h"
#import "SHBLoanSecurityViewController.h"
#import "SHBTelephoneConsultationRequestViewController.h"

@interface SHBLoanInfoViewController ()

@end

@implementation SHBLoanInfoViewController

#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    // 전화상담요청 페이지로 이동
    SHBTelephoneConsultationRequestViewController *viewController = [[SHBTelephoneConsultationRequestViewController alloc] initWithNibName:@"SHBTelephoneConsultationRequestViewController" bundle:nil];
    
    if ([viewController isTelephoneConsultationRequest]) {
        
        AppInfo.commonDic = @{@"콜백서비스" : @"85",     // 대출
                              @"페이지정보" : @"P44000", // S뱅크 > 상품가입 > 대출 > 전화상담요청
                              @"상품코드" : @""};
        
        viewController.needsLogin = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
    
    [viewController release];
}

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
    [_bottomView release];
    self.button1 = nil;
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [self setBottomView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예적금담보대출"];
    self.strBackButtonTitle = @"예적금담보대출 안내";
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예적금담보대출 안내" maxStep:0 focusStepNumber:0]autorelease]];
    [self.view bringSubviewToFront:self.button1];
	
    NSString *strUrl;
    if (!AppInfo.realServer)
    {
        strUrl = [NSString stringWithFormat:@"%@sbank_intro_621111100.html",URL_PRODUCT_TEST];
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@sbank_intro_621111100.html", URL_PRODUCT];
    }
    
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strUrl]]]];		// temp
	
	FrameReposition(self.bottomView, left(self.bottomView), height(self.webView)+1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)applyBtnAction:(SHBButton *)sender {
#if 0
	SHBLoanSecurityViewController *vc = [[[SHBLoanSecurityViewController alloc]initWithNibName:@"SHBLoanSecurityViewController" bundle:nil]autorelease];
//	vc.needsCert = YES;
	[self checkLoginBeforePushViewController:vc animated:YES];
	
	return;
#endif
    
	SHBLoanStipulationViewController *viewController = [[SHBLoanStipulationViewController alloc]initWithNibName:@"SHBLoanStipulationViewController" bundle:nil];
	viewController.needsCert = YES;
    if (sender.tag == 100)
    {
        viewController.Loantype = @"A";   //건별
        AppInfo.commonDic = @{ @"_대출타입" : @"A"};
    }
    else{
        viewController.Loantype = @"B";   //한도
        AppInfo.commonDic = @{ @"_대출타입" : @"B"};
    }
	[self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
}

@end
