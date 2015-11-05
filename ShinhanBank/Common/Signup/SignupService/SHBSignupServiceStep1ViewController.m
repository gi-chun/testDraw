//
//  SHBSignupServiceStep1ViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSignupServiceStep1ViewController.h"
#import "SHBWebViewConfirmViewController.h"
#import "SHBAskStaffViewController.h"
#import "SHBSignupServiceStep2ViewController.h"

#define SCROLL_VIEW_HEIGHT	130

@interface SHBSignupServiceStep1ViewController ()

@end

@implementation SHBSignupServiceStep1ViewController

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
	
	self.title = @"신한S뱅크가입";
    self.strBackButtonTitle = @"신한S뱅크가입 1단계";
	
	[empTextField setAccDelegate:self];
	
}

- (void)clearData{
	isCheckAttention = NO;
	isCheckAgreement = NO;
	
	agreeButton.selected = NO;
	empTextField.text = @"";
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
	if (self.needClearData){
        self.needClearData = NO;
		[self clearData];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (BOOL)checkCompulsory{
	if (!isCheckAttention){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"신한S뱅크 가입 유의사항을 읽고 확인 버튼을 선택하시기 바랍니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	if (!isCheckAgreement){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"서비스 이용에 동의하셔야 신한S뱅크 서비스 가입이 가능합니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	if ([empTextField.text length] > 0 && [empTextField.text length] < 8){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"권유직원번호는 8자리를 입력하여 주십시오."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	return YES;
}
- (IBAction)buttonPressed:(UIButton*)sender{
	if (sender.tag == 10) {
		// 유의사항 보기
        if (self.needClearData)
        {
            self.needClearData = NO;
        }
		SHBWebViewConfirmViewController *webViewController = [[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil];
		[webViewController executeWithTitle:@"신한S뱅크가입" SubTitle:@"신한S뱅크 가입 유의사항 및 약관" RequestURL:[NSString stringWithFormat:@"%@/sbank/prod/s_yak_cautn.html",URL_IMAGE]];
		[self.navigationController pushFadeViewController:webViewController];
		[webViewController release];
		
		isCheckAttention = YES;
		
	}else if (sender.tag == 20) {
		// 예, 동의합니다
		if (sender.selected){
			[sender setSelected:FALSE];
			isCheckAgreement = NO;
		}else{
			[sender setSelected:TRUE];
			isCheckAgreement = YES;
		}
	}else if (sender.tag == 30) {
		// 권유직원 조회
		SHBAskStaffViewController *staffViewController = [[SHBAskStaffViewController alloc] initWithNibName:@"SHBAskStaffViewController" bundle:nil];
		[staffViewController executeWithTitle:@"신한S뱅크가입" ReturnViewController:self];
		[self.navigationController pushFadeViewController:staffViewController];
		[staffViewController release];
		
	}else if (sender.tag == 40) {
		// 확인
		// 필수 항목 체크
		if (![self checkCompulsory]) return;
		
		// 다음 단계로 이동
		SHBSignupServiceStep2ViewController *step2Controller = [[SHBSignupServiceStep2ViewController alloc] initWithNibName:@"SHBSignupServiceStep2ViewController" bundle:nil];
		[self.navigationController pushFadeViewController:step2Controller];
		[step2Controller release];
		
	}else if (sender.tag == 50) {
		// 취소
		[self.navigationController fadePopToRootViewController];
	}

}

#pragma mark - Method
- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic{
	[super viewControllerDidSelectDataWithDic:mDic];
	
	if (mDic){
		empTextField.text = [mDic objectForKey:@"행번"];
	}
}

- (void)scrollMainView:(float)posY{
	//animation set
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:mainView];
	
	//scroll set
	[mainView setFrame:CGRectMake(0, posY, mainView.frame.size.width, mainView.frame.size.height)];
	
	//animation run
	[UIView commitAnimations];
}
- (void)navigationButtonPressed:(id)sender
{
    
        
        //return;
    UIButton *btnSender = (UIButton*)sender;
    switch (btnSender.tag) {
        case NAVI_BACK_BTN_TAG:
            // 이전버튼
            
            [AppInfo logout];
            [AppDelegate.navigationController fadePopToRootViewController];
            break;
        default:
            [super navigationButtonPressed:sender];
            break;
    }
    
}
#pragma mark - Delegate : SHBTextFieldAccDelegate
- (void)didCompleteButtonTouch{
	float posY = mainView.frame.origin.y + SCROLL_VIEW_HEIGHT;
	[self scrollMainView:posY];
	
	[empTextField focusSetWithLoss:NO];
	[empTextField resignFirstResponder];
	
};	// 완료버튼

#pragma mark - Delegate : UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
	int txtLen = [textField.text length];
	
	if (txtLen >= 8 && range.length == 0) return NO;
	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	float posY = mainView.frame.origin.y - SCROLL_VIEW_HEIGHT;
	[self scrollMainView:posY];
	
	[(SHBTextField*)textField focusSetWithLoss:YES];
	
	[(SHBTextField*)textField enableAccButtons:NO Next:NO];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	float posY = mainView.frame.origin.y + SCROLL_VIEW_HEIGHT;
	[self scrollMainView:posY];
	
	[empTextField focusSetWithLoss:NO];
	[empTextField resignFirstResponder];
	
	return YES;
}

@end
