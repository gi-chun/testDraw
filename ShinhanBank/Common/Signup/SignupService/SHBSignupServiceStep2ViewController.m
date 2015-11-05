//
//  SHBSignupServiceStep2ViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSignupServiceStep2ViewController.h"
#import "SHBWebViewConfirmViewController.h"
#import "SHBSignupServiceStep3ViewController.h"
#import "SHBSignupService.h"
#import "SHBSignupServiceStep1ViewController.h"
@interface SHBSignupServiceStep2ViewController ()

@end

@implementation SHBSignupServiceStep2ViewController

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
    self.strBackButtonTitle = @"신한S뱅크가입 2단계";
	boxInfoImageView.image = [[UIImage imageNamed:@"box_infor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	boxImageView.image = [[UIImage imageNamed:@"box_1.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	
	_mainView.frame = CGRectMake(0, 0, _mainView.frame.size.width, _mainView.frame.size.height);
	[_scrollView addSubview:_mainView];
	[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _mainView.frame.size.height)];
	
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiESignError" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignError) name:@"notiESignError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	
	[super dealloc];
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
	if ([notification userInfo]) {
		if (!AppInfo.errorType) {
            // release 처리
            SHBSignupServiceStep3ViewController *viewController = [[[SHBSignupServiceStep3ViewController alloc] initWithNibName:@"SHBSignupServiceStep3ViewController" bundle:nil] autorelease];
            
			[self.navigationController pushFadeViewController:viewController];
        }
    }else{
		[self.navigationController fadePopViewController];
	}
}
//취소 버튼
- (void)getElectronicSignCancel
{
    NSLog(@"getElectronicSignCancel !!!");
	//[self.navigationController fadePopViewController];
    //[AppDelegate.navigationController popViewControllerAnimated:NO];
    //[AppDelegate.navigationController popViewControllerAnimated:NO];
    [AppDelegate.navigationController fadePopToRootViewController];
    SHBSignupServiceStep1ViewController *viewController = [[SHBSignupServiceStep1ViewController alloc] initWithNibName:@"SHBSignupServiceStep1ViewController" bundle:nil];
    
    [AppDelegate.navigationController pushFadeViewController:viewController];
    [viewController release];
}
//전자서명에러
- (void)getElectronicSignError
{
    [AppDelegate.navigationController fadePopToRootViewController];
    SHBSignupServiceStep1ViewController *viewController = [[SHBSignupServiceStep1ViewController alloc] initWithNibName:@"SHBSignupServiceStep1ViewController" bundle:nil];
    
    [AppDelegate.navigationController pushFadeViewController:viewController];
    [viewController release];
}

#pragma mark - IBActions
- (BOOL)checkCompulsory{
	if (!isCheckAgreeviewer){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"'개인(신용)정보 수집•이용 동의서 (비여신\n금융거래) 및 고객권리 안내문' 보기를\n선택하여 확인하시기 바랍니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	if (compulsoryButton1.enabled){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"1번 필수적정보는 반드시 동의하셔야 합니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	if (idButton1.enabled){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"2번 고유식별정보는 반드시 동의하셔야 합니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	return YES;
}

- (void)requestElectronicSign{
	AppInfo.electronicSignString = @"";
	AppInfo.eSignNVBarTitle = @"신한S뱅크가입";
	
    AppInfo.electronicSignCode = @"E4302";
    AppInfo.electronicSignTitle = @"서비스 가입 및 개인신용정보 수집,이용에 동의합니다.";
	//[AppInfo addElectronicSign:@"서비스 가입 및 개인신용정보 수집,이용에 동의합니다."];
	[AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
	[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
	[AppInfo addElectronicSign:@"(3)서비스명 : 신한S뱅크 가입"];
	
    // release 처리
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
							   @{
							   @"휴대폰번호" : AppInfo.phoneNumber,
							   }] autorelease];
	self.service = nil;
	self.service = [[[SHBSignupService alloc] initWithServiceId:ELEC_SIGNUP viewController:self] autorelease];
	self.service.previousData = forwardData;
	[self.service start];
	
}

- (IBAction)buttonPressed:(UIButton*)sender{
	if (sender == viewAgreeButton) {
		// 유의사항 보기
		SHBWebViewConfirmViewController *webViewController = [[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil];
		[webViewController executeWithTitle:@"신한S뱅크가입" SubTitle:@"개인(신용)정보 수집•이용 동의서" RequestURL:[NSString stringWithFormat:@"%@/sbank/yak/pci_lending_02.html",URL_IMAGE]];
		[self.navigationController pushFadeViewController:webViewController];
		[webViewController release];
		
		isCheckAgreeviewer = YES;
		
	}else if (sender == compulsoryButton1 || sender == compulsoryButton2) {
		// 필수적 정보
		[compulsoryButton1 setEnabled:TRUE];
		[compulsoryButton2 setEnabled:TRUE];
		[sender setEnabled:FALSE];
	}else if (sender == optionButton1 || sender == optionButton2) {
		// 선택적 정보
		[optionButton1 setEnabled:TRUE];
		[optionButton2 setEnabled:TRUE];
		[sender setEnabled:FALSE];
	}else if (sender == idButton1 || sender == idButton2) {
		// 고유식별 정보
		[idButton1 setEnabled:TRUE];
		[idButton2 setEnabled:TRUE];
		[sender setEnabled:FALSE];
	}else if (sender == confirmButton) {
		// 확인
		// 필수 항목 체크
		if (![self checkCompulsory]) return;
		
		// 다음 단계로 이동(전자서명)
		[self requestElectronicSign];
		
	}else if (sender == cancelButton) {
		// 취소
		[[[self.navigationController viewControllers] objectAtIndex:[[self.navigationController viewControllers] count]-2] setNeedClearData:YES];
		[self.navigationController fadePopViewController];
	}
	
}

@end
