//
//  SHBSignupStep1ViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSignupStep1ViewController.h"
#import "SHBWebViewConfirmViewController.h"

@interface SHBSignupStep1ViewController ()

@end

@implementation SHBSignupStep1ViewController

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
	
	self.title = @"회원가입";
    self.strBackButtonTitle = @"회원가입 1단계";
	boxImageView.image = [[UIImage imageNamed:@"box_consent.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
	[_nextViewControlName release];
	
	[super dealloc];
}

#pragma mark - Method
- (void)executeWithStep:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString*)nextCtrlName{
	_nextViewControlName = [nextCtrlName copy];
	
	// Max 10개까지만 Step 단계표시
	if (stepCnt < 11){
		UIButton	*stepButtn;
		
		for (int i=stepCnt; i>=1; i --) {
			stepButtn = (UIButton*)[self.view viewWithTag:i];
			float stepWidth = stepButtn.frame.size.width;
			float stepX = 317 - ((stepWidth+2) * ((stepCnt+1) - i));
			[stepButtn setFrame:CGRectMake(stepX, stepButtn.frame.origin.y, stepWidth, stepButtn.frame.size.height)];
			[stepButtn setHidden:NO];
			
			if (step >= i){
				stepButtn.selected = YES;
			}else{
				stepButtn.selected = NO;
			}
		}
	}
	
}

- (BOOL)checkCompulsory{
	if (!isViewContract){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"홈페이지 회원서비스 이용약관, 개인정보 취급방침을 읽고 확인버튼을 선택하시기 바랍니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	if (!isCheckAgreement){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"약관에 동의하셔야 회원가입이 가능합니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	return YES;
}

#pragma mark - IBAction
- (IBAction)buttonPressed:(UIButton*)sender{
	if (sender.tag == 101) {
		// 유의사항 보기
		SHBWebViewConfirmViewController *webViewController = [[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil];
		[webViewController executeWithTitle:@"회원가입" SubTitle:@"회원가입 이용약관" RequestURL:[NSString stringWithFormat:@"%@/sbank/prod/s_yak_mjoin.html", URL_IMAGE]];
		[self.navigationController pushFadeViewController:webViewController];
		[webViewController release];
		
		isViewContract = YES;
		
	}else if (sender.tag == 102) {
		// 예, 동의합니다
		if (sender.selected){
			[sender setSelected:FALSE];
			isCheckAgreement = NO;
		}else{
			[sender setSelected:TRUE];
			isCheckAgreement = YES;
		}
	}else if (sender.tag == 103) {
		// 확인
		// 필수 항목 체크
		if (![self checkCompulsory]) return;
		
		// 다음 단계로 이동
		SHBBaseViewController *viewController = [[[NSClassFromString(_nextViewControlName) class] alloc] initWithNibName:_nextViewControlName bundle:nil];
		viewController.needsLogin = NO;
		[self checkLoginBeforePushViewController:viewController animated:NO];
		[viewController release];
		
	}else if (sender.tag == 104) {
		// 취소
		[self.navigationController fadePopViewController];
	}
}




@end
