//
//  SHBQryServiceViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBQryServiceViewController.h"
#import "SHBWebViewConfirmViewController.h"
#import "SHBAskStaffViewController.h"
#import "SHBIdentity1ViewController.h"
#import "SHBSignupService.h"
#import "SHBQryServiceDoneViewController.h"

#import "Encryption.h"

@interface SHBQryServiceViewController () <SHBIdentity1Delegate>

@end

@implementation SHBQryServiceViewController

@synthesize accountPassword;


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
	boxTopImageView.image = [[UIImage imageNamed:@"box_infor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	boxMidImageView.image = [[UIImage imageNamed:@"box_2.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	boxBtmImageView.image = [[UIImage imageNamed:@"box_1.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3];
	
	// 스크롤뷰에 뷰 추가
	mainView.frame = CGRectMake(0, 0, 317, 638);
	[scrollView addSubview:mainView];
	[scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, mainView.frame.size.height)];
	
	[empTextField setAccDelegate:self];
	[accTextField setAccDelegate:self];
	[pssSecureField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
	
	if (AppInfo.commonDic[@"아이디"])
		_userIdLabel.text = AppInfo.commonDic[@"아이디"];
	
	if (AppInfo.commonDic[@"고객명"])
		_userNmLabel.text = AppInfo.commonDic[@"고객명"];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Method
- (void)executeWithUser:(NSString*)aUserId UserName:(NSString*)aUserNm{
	NSLog(@"executeWithUser: %@, %@",aUserId,aUserNm);
	
	_userIdLabel.text = aUserId;
	_userNmLabel.text = aUserNm;
}
- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic{
	[super viewControllerDidSelectDataWithDic:mDic];
	
	if (mDic){
		empTextField.text = [mDic objectForKey:@"행번"];
	}else{		
		// 조회서비스 가입전문 요청
		[self requestQryService];
	}
}

- (void)navigationButtonPressed:(id)sender{
	UIButton *btnSender = (UIButton*)sender;
	if (btnSender.tag == NAVI_BACK_BTN_TAG){
		[[[AppDelegate.navigationController viewControllers] objectAtIndex:[[AppDelegate.navigationController viewControllers] count]-2] setNeedClearData:YES];
		
	}
	
	[super navigationButtonPressed:sender];
}

- (void)closeiOSKeyPad{
	[empTextField focusSetWithLoss:NO];
	[accTextField focusSetWithLoss:NO];
	
	[empTextField resignFirstResponder];
	[accTextField resignFirstResponder];
	
	[pssSecureField closeSecureKeyPad];
	
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
	/*
	if (accTextField.text == nil || [accTextField.text length] == 0){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"계좌번호를 입력하여 주십시오."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	*/
    if ([accTextField.text length] < 11 || [accTextField.text isEqualToString:@""] || accTextField.text == nil)
    {
        NSString *msg = @"출금계좌번호 11자에서 12자리를 입력해 주십시요.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        return NO;
    }
    
	if (pssSecureField.text == nil || [pssSecureField.text length] < 4){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"계좌비밀번호를 입력하여 주십시오."
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

- (void)requestQryService{
    // release 처리
    self.service = nil;
	self.service = [[[SHBSignupService alloc] initWithServiceId:SIGNUP_QRY_SERVICE viewController:self] autorelease];
	self.service.previousData = svcH1009Dic;
	[self.service start];
}

- (void)requestCheckAccount{
    
    
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								@{
                                  //@"주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? AppInfo.commonDic[@"실명번호"] : @"",
                                  //@"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? AppInfo.commonDic[@"실명번호"] : @"",
                                  @"고객번호" : [SHBUtility nilToString:AppInfo.commonDic[@"고객번호"]],
                                  @"출금계좌번호" : accTextField.text,
                                  @"출금계좌비밀번호" : accountPassword,
                                  @"반복횟수" : @"1",
                                  @"은행구분" : @"1",
                                  @"reservationField13" : @"조회서비스가입",
                                  }] autorelease];
	
    // release 처리
    self.service = nil;
	self.service = [[[SHBSignupService alloc] initWithServiceId:SIGNUP_QRY_ACCOUNT_CHECK viewController:self] autorelease];
	self.service.previousData = forwardData;
	[self.service start];
}

#pragma mark - HTTP Delegate
- (BOOL)onBind:(OFDataSet *)aDataSet{
	if([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"C2094"] && [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"]){
		// 계좌확인
		
		// 가입정보 셋팅
		NSString *empNo = (empTextField.text == nil) ? @"" : empTextField.text;
		
		SafeRelease(svcH1009Dic);
        
		svcH1009Dic = [[SHBDataSet alloc] initWithDictionary:
					   @{
					   @"고객번호" : [aDataSet objectForKey:@"고객번호"],
					   @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [aDataSet objectForKey:@"실명번호->originalValue"] : @"",
					   @"이름" : [aDataSet objectForKey:@"출금계좌성명"],
					   //@"아이디" : _userIdLabel.text,
                       @"아이디" : [AppInfo.commonDic[@"아이디"] uppercaseString],
					   @"인증계좌관리점" : [SHBUtility nilToString:[aDataSet objectForKey:@"계좌관리점"]],
					   @"인증계좌번호" : [aDataSet objectForKey:@"출금계좌번호->originalValue"],
					   @"신규일자" : [[aDataSet objectForKey:@"COM_TRAN_DATE"] stringByReplacingOccurrencesOfString:@"." withString:@""],
					   @"신규채널" : @"DT",
					   @"권유자행번" : empNo,
					   }];
		
		
		if (AppInfo.customerNo == nil || [AppInfo.customerNo length] == 0)
        {
            //AppInfo.customerNo = [aDataSet objectForKey:@"고객번호"];
            if ([[aDataSet objectForKey:@"고객번호"] length] == 9)
            {
                AppInfo.customerNo = [NSString stringWithFormat:@"0%@",[aDataSet objectForKey:@"고객번호"]];
            }else
            {
                AppInfo.customerNo = [aDataSet objectForKey:@"고객번호"];
            }
        }
			
		
		// 다음 단계로 이동(휴대폰인증화면)
        
        /*
		SHBMobileCertificateViewController *mCertViewController = [[SHBMobileCertificateViewController alloc] initWithNibName:@"SHBMobileCertificateViewController" bundle:nil];
		mCertViewController.needsLogin = NO;
		mCertViewController.serviceSeq = SERVICE_SIGN_UP;
		
        [self.navigationController pushFadeViewController:mCertViewController];
        
		// Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
		[mCertViewController executeWithTitle:@"회원가입" Step:2 StepCnt:4 NextControllerName:nil];
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
        [viewController executeWithTitle:@"회원가입" Step:2 StepCnt:4 NextControllerName:nil];
        [viewController subTitle:@"추가인증 방법 선택"];
        [viewController release];

		
		
	}else if([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"H1009"] && [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"]){
		
		[AppDelegate.navigationController fadePopViewController];	// 휴대폰인증1
		[AppDelegate.navigationController fadePopViewController];	// 휴대폰인증2
		
		SHBQryServiceDoneViewController *doneViewController = [[SHBQryServiceDoneViewController alloc] initWithNibName:@"SHBQryServiceDoneViewController" bundle:nil];
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
		
		[self requestCheckAccount];
		
	}else if (sender.tag == 105) {
		// 취소
		[[[self.navigationController viewControllers] objectAtIndex:[[self.navigationController viewControllers] count]-2] setNeedClearData:YES];
		[self.navigationController fadePopViewController];
		
	}
}

#pragma mark - Delegate : SHBTextFieldAccDelegate
- (void)didPrevButtonTouch{
	[self closeiOSKeyPad];
	
	switch (indexCurrentField) {
		case 3:
			// 권유직원조회
			[pssSecureField becomeFirstResponder];
			break;
		default:
			break;
	}
	
};		// 이전버튼
- (void)didNextButtonTouch{
	[self closeiOSKeyPad];
	
	switch (indexCurrentField) {
		case 1:
			// 게좌번호
			[pssSecureField becomeFirstResponder];
			break;
		default:
			break;
	}
	
	
};		// 다음버튼
- (void)didCompleteButtonTouch{
	[self closeiOSKeyPad];
	
	[self scrollMainView:0];
	
	if (indexCurrentField == 1){
		[accTextField focusSetWithLoss:NO];
	}else{
		[empTextField focusSetWithLoss:NO];
	}
	
};	// 완료버튼

#pragma mark - Delegate : UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
	int txtLen = [textField.text length];
	
    if (textField == accTextField)
    {
        if ([string length] > 1) return NO;
    }
	if (textField == empTextField){
		if (txtLen >= 8 && range.length == 0) return NO;
	}else{
		if (txtLen >= 12 && range.length == 0) return NO;
	}
	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	indexCurrentField = textField.tag;
	[scrollView setContentOffset:CGPointMake(0, 190)];
	
	float posY = 0;
	
	if (textField == accTextField){
		posY = scrollView.contentOffset.y - 285;
		[(SHBTextField*)textField enableAccButtons:NO Next:YES];
	}else{
		posY = scrollView.contentOffset.y - 375;
		[(SHBTextField*)textField enableAccButtons:YES Next:NO];
	}
	
	[self scrollMainView:posY];
	[(SHBTextField*)textField focusSetWithLoss:YES];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self scrollMainView:0];
	
	[empTextField focusSetWithLoss:NO];
	[empTextField resignFirstResponder];
	
	return YES;
}


#pragma mark - Delegate : SHBSecureDelegate
- (void)secureTextFieldDidBeginEditing:(SHBSecureTextField *)textField{
	indexCurrentField = textField.tag;
	
	[scrollView setContentOffset:CGPointMake(0, 190)];
	
	float posY = scrollView.contentOffset.y - 320;
	[self scrollMainView:posY];
}

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
	if (textField == pssSecureField){
		SafeRelease(accountPassword);
		accountPassword = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_NUM=%@>", value]];
		[self scrollMainView:0];
	}
	
}

- (void)onPreviousClick:(NSString*)pPlainText encText:(NSString*)pEncText{
	[self closeiOSKeyPad];
	
	if (indexCurrentField == 2) {
		// 계좌비밀번호
		SafeRelease(accountPassword);
		accountPassword = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_NUM=%@>", pEncText]];
		
		[accTextField becomeFirstResponder];
		
	}
}

- (void)onNextClick:(NSString*)pPlainText encText:(NSString*)pEncText{
	[self closeiOSKeyPad];
	
	if (indexCurrentField == 2) {
		// 계좌비밀번호
		SafeRelease(accountPassword);
		accountPassword = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_NUM=%@>", pEncText]];
		[empTextField becomeFirstResponder];
		
	}
}



#pragma mark - identity1 delegate

- (void)identity1ViewControllerCancel
{
    // 취소시 입력값 초기화 필요한 경우
}

@end
