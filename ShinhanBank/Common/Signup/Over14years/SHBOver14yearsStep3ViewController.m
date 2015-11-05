//
//  SHBOver14yesrsStep3ViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBOver14yearsStep3ViewController.h"
#import "SHBWebViewConfirmViewController.h"
#import "SHBIdentity1ViewController.h"
#import "SHBAskStaffViewController.h"
#import "SHBSignupService.h"
#import "SHBOver14yearsStep4ViewController.h"

@interface SHBOver14yearsStep3ViewController () <SHBIdentity1Delegate>

@end

@implementation SHBOver14yearsStep3ViewController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 9999996 && buttonIndex == 0) {
        // 회원가입 초기 화면으로 이동
		[AppDelegate.navigationController fadePopViewController];	//조회서비스 가입
		[AppDelegate.navigationController fadePopViewController];	//사용자 정보입력
		[AppDelegate.navigationController fadePopViewController];	//약관동의
		
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
	SafeRelease(svcH1009Dic);
	
	[super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"회원가입";
    self.strBackButtonTitle = @"회원가입 3단계";
	[self navigationBackButtonHidden];
	
	boxTopImageView.image = [[UIImage imageNamed:@"box_infor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	boxBtmImageView.image = [[UIImage imageNamed:@"box_2.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	
	// 스크롤뷰에 뷰 추가
	mainView.frame = CGRectMake(0, 0, 317, 518);
	[scrollView addSubview:mainView];
	[scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, mainView.frame.size.height)];
	
	[empTextField setAccDelegate:self];
	
	if (AppInfo.loginID)
		_userIdLabel.text = AppInfo.loginID;
	
	if (AppInfo.loginName)
		_userNmLabel.text = AppInfo.loginName;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method
- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic{
	[super viewControllerDidSelectDataWithDic:mDic];
	
	if (mDic){
		empTextField.text = [mDic objectForKey:@"행번"];
	}else{
		// 조회서비스 가입전문 요청
		[self requestQryService];
	}
}

- (BOOL)checkCompulsory{
	if (!isViewContract){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"홈페이지 회원서비스 이용약관, 신한온라인 서비스 이용약관, 신한S뱅크서비스 유의사항을 읽고 확인버튼을 선택하시기 바랍니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	if (!isCheckAgreement){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"조회서비스 가입에 동의하셔야 신한S뱅크 조회서비스 이용이 가능합니다."
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
- (void)scrollMainView:(float)posY{
	//animation set
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:scrollView];
	
	//scroll set
	[scrollView setFrame:CGRectMake(0, 81 + posY, scrollView.frame.size.width, scrollView.frame.size.height)];
	
	//animation run
	[UIView commitAnimations];
}
- (void)setH1009Dic:(NSMutableDictionary*)mDic{
	SafeRelease(svcH1009Dic);
	svcH1009Dic = [[NSMutableDictionary alloc] initWithDictionary:mDic];
	
	NSString *empNo = (empTextField.text == nil)?@"":empTextField.text;
	[svcH1009Dic setObject:empNo forKey:@"권유자행번"];
}

- (void)requestQryService{
	if (svcH1009Dic){
        // release 처리
		SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								   @{
								   @"고객번호" : [svcH1009Dic objectForKey:@"고객번호"],
								   @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [svcH1009Dic objectForKey:@"주민번호"] : @"",
								   @"이름" : AppInfo.loginName,
								   @"아이디" : [AppInfo.loginID uppercaseString],
								   @"인증계좌관리점" : [svcH1009Dic objectForKey:@"인증계좌관리점"],
								   @"인증계좌번호" : [svcH1009Dic objectForKey:@"인증계좌번호"],
								   @"신규일자" : [svcH1009Dic objectForKey:@"신규일자"],
								   @"신규채널" : @"DT",
								   @"권유자행번" : [svcH1009Dic objectForKey:@"권유자행번"],
								   }] autorelease];
		
        // release 처리
        self.service = nil;
		self.service = [[[SHBSignupService alloc] initWithServiceId:SIGNUP_QRY_SERVICE viewController:self] autorelease];
		self.service.previousData = forwardData;
		[self.service start];
	}
}


#pragma mark - HTTP Delegate
- (BOOL)onBind:(OFDataSet *)aDataSet{
	if([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"H1009"] && [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"]){
		
		[AppDelegate.navigationController fadePopViewController];	// 휴대폰인증1
		[AppDelegate.navigationController fadePopViewController];	// 휴대폰인증2
		
		SHBOver14yearsStep4ViewController *doneViewController = [[SHBOver14yearsStep4ViewController alloc] initWithNibName:@"SHBOver14yearsStep4ViewController" bundle:nil];
		[self.navigationController pushFadeViewController:doneViewController];
		[doneViewController release];
	}
	
	return NO;
}



#pragma mark - IBAction
- (IBAction)buttonPressed:(UIButton*)sender{
	if (sender.tag == 101) {
		// 유의사항 보기
		SHBWebViewConfirmViewController *webViewController = [[SHBWebViewConfirmViewController alloc] initWithNibName:@"SHBWebViewConfirmViewController" bundle:nil];
		[webViewController executeWithTitle:@"회원가입" SubTitle:@"조회서비스가입 이용약관" RequestURL:[NSString stringWithFormat:@"%@/sbank/prod/s_yak_mjoin.html", URL_IMAGE]];
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
		// 권유직원 조회
		SHBAskStaffViewController *staffViewController = [[SHBAskStaffViewController alloc] initWithNibName:@"SHBAskStaffViewController" bundle:nil];
		[staffViewController executeWithTitle:@"회원가입" ReturnViewController:self];
		[self.navigationController pushFadeViewController:staffViewController];
		[staffViewController release];
		
	}else if (sender.tag == 104) {
		// 확인
		// 필수 항목 체크
		if (![self checkCompulsory]) return;
		
		// 다음 단계로 이동(휴대폰인증화면)
        
        /*
		SHBMobileCertificateViewController *mCertViewController = [[SHBMobileCertificateViewController alloc] initWithNibName:@"SHBMobileCertificateViewController" bundle:nil];
		mCertViewController.needsLogin = NO;
		mCertViewController.serviceSeq = SERVICE_SIGN_UP;
		
        [self.navigationController pushFadeViewController:mCertViewController];
        
		// Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
		[mCertViewController executeWithTitle:@"회원가입" Step:4 StepCnt:6 NextControllerName:nil];
        [mCertViewController subTitle:@"휴대폰 가입인증" infoViewCount:MOBILE_INFOVIEW_1];
		[mCertViewController release];
         */
        
        AppInfo.transferDic = @{ @"서비스코드" : @"H1009" };
        
        SHBIdentity1ViewController *viewController = [[SHBIdentity1ViewController alloc]initWithNibName:@"SHBIdentity1ViewController" bundle:nil];
        viewController.needsLogin = NO;
        viewController.serviceSeq = SERVICE_SIGN_UP;
        viewController.delegate = self;
        [self.navigationController pushFadeViewController:viewController];
        
        // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
        [viewController executeWithTitle:@"회원가입" Step:4 StepCnt:6 NextControllerName:nil];
        [viewController subTitle:@"추가인증 방법 선택"];
        [viewController release];

        
        
        
		
	}else if (sender.tag == 105) {
		// 취소
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"조회서비스 가입을 취소하시겠습니까?\n(이전 화면에서 회원가입은 완료되었습니다.)"
													   delegate:self
											  cancelButtonTitle:nil
											  otherButtonTitles:@"예", @"아니오",nil];
		alert.tag = 9999996;
		[alert show];
		[alert release];
		
	}
}

#pragma mark - Delegate : SHBTextFieldAccDelegate
- (void)didCompleteButtonTouch{
	[self scrollMainView:0];
	
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
	float posY = scrollView.contentOffset.y - 250;
	[self scrollMainView:posY];
	
	[(SHBTextField*)textField focusSetWithLoss:YES];
	
	[(SHBTextField*)textField enableAccButtons:NO Next:NO];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self scrollMainView:0];
	
	[empTextField focusSetWithLoss:NO];
	[empTextField resignFirstResponder];
	
	return YES;
}


#pragma mark - identity1 delegate

- (void)identity1ViewControllerCancel
{
    // 취소시 입력값 초기화 필요한 경우
}


@end
