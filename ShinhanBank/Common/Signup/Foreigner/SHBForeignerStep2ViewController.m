//
//  SHBForeignerStep2ViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForeignerStep2ViewController.h"
#import "SHBAttentionLabel.h"
#import "SHBForeignerStep3ViewController.h"
#import "SHBSignupService.h"

@interface SHBForeignerStep2ViewController ()

@end

@implementation SHBForeignerStep2ViewController

@synthesize accountPassword, idPassword1, idPassword2, userName;


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
	if (alertView.tag == 9999998 && buttonIndex == 0) {
        [self clearData];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppInfo.isUserPwdRegister = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.title = @"회원가입";
	self.strBackButtonTitle = @"회원가입 2단계";
	// 상단의 라벨 셋팅
	SHBAttentionLabel* descTopLabel = [[SHBAttentionLabel alloc] initWithFrame:CGRectMake(8.0f, 7.0f, 300.0f, 55.0f)];
	descTopLabel.backgroundColor = [UIColor clearColor];
	//descTopLabel.offsety = -7;
    descTopLabel.offsety = 0;
	descTopLabel.text = @"<midBlue_13>신한은행은 고객님의 개인정보 보호를 위해 실명 확인제를 실시하고 있습니다. 외국인등록번호와 계좌번호가 일치하는 경우에만 가입이 가능합니다.</midBlue_13>";
	[mainView addSubview:descTopLabel];
	[descTopLabel release];
	
	// 스크롤뷰에 뷰 추가
	mainView.frame = CGRectMake(0, 0, 317, 508);
	[scrollView addSubview:mainView];
	[scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, mainView.frame.size.height)];
	
	// 일반 텍스트필드
	[idx2TextField setAccDelegate:self];
	[idx4TextField setAccDelegate:self];
	
	// 보안 필드
    [idx1TextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:13];
	[idx3SecureField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
	[idx5SecureField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:16];
	[idx6SecureField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:16];
	
	
	indexCurrentField = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.encJumin = nil;
    [super dealloc];
}

#pragma mark - Method
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

- (void)clearData{
	isCheckAccount = NO;
	isCheckDupliID = NO;
	
	idx1TextField.text = @"";
	idx2TextField.text = @"";
	idx3SecureField.text = @"";
	idx4TextField.text = @"";
	idx5SecureField.text = @"";
	idx6SecureField.text = @"";
	
	[scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)closeiOSKeyPad{
    AppInfo.isUserPwdRegister = NO;
	[idx2TextField focusSetWithLoss:NO];
	[idx4TextField focusSetWithLoss:NO];
	
	[idx1TextField resignFirstResponder];
	[idx2TextField resignFirstResponder];
	[idx4TextField resignFirstResponder];
	
	[idx1TextField closeSecureKeyPad];
	[idx3SecureField closeSecureKeyPad];
	[idx5SecureField closeSecureKeyPad];
	[idx6SecureField closeSecureKeyPad];
	
}

- (BOOL)checkID:(NSString *)str{
	char *chars;
	int len;
	int i;
	BOOL containAlphabet;
	BOOL containNumeric;
	
	if (str == nil) return NO;
	
	if ([str length] == 0 && [str isEqualToString:@""]) return NO;
	
	chars = (char*)[str UTF8String];
	len = strlen(chars);
	
	containNumeric = containAlphabet = NO;
	
	for (i = 0; i < len; i++){
		if (
			!(
			  (chars[i] >= '0' && chars[i] <= '9')
			  ||
			  (chars[i] >= 'a' && chars[i] <= 'z')
			  ||
			  (chars[i] >= 'A' && chars[i] <= 'Z')
			  )
			) return NO;
		
		if (chars[i] >= '0' && chars[i] <= '9'){
			containNumeric = YES;
			continue;
		}
		
		if (chars[i] >= 'a' && chars[i] <= 'z'){
			containAlphabet = YES;
			continue;
		}
		
		if (chars[i] >= 'A' && chars[i] <= 'Z'){
			containAlphabet = YES;
			continue;
		}
		
	}
	
	return containNumeric || containAlphabet;
	
}

- (BOOL)checkPw:(NSString *)str
{
	char *chars;
	int len;
	int i;
	BOOL containAlphabet;
	BOOL containNumeric;
	
	if (str == nil) return NO;
	
	if ([str length] == 0 && [str isEqualToString:@""]) return NO;
	
	chars = (char*)[str UTF8String];
	len = strlen(chars);
	
	containNumeric = containAlphabet = NO;
	
	for (i = 0; i < len; i++){
		if (
			!(
			  (chars[i] >= '0' && chars[i] <= '9')
			  ||
			  (chars[i] >= 'a' && chars[i] <= 'z')
			  ||
			  (chars[i] >= 'A' && chars[i] <= 'Z')
			  )
			) return NO;
		
		if (chars[i] >= '0' && chars[i] <= '9'){
			containNumeric = YES;
			continue;
		}
		
		if (chars[i] >= 'a' && chars[i] <= 'z'){
			containAlphabet = YES;
			continue;
		}
		
		if (chars[i] >= 'A' && chars[i] <= 'Z'){
			containAlphabet = YES;
			continue;
		}
		
	}
	
	return containNumeric && containAlphabet;
		
}

- (BOOL)checkAccountCompulsory{
	// 계좌확인시 필수사항
	if ([idx1TextField.text length] < 13){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"외국인등록번호 13자리를 입력하여 주십시오."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	/*
	if (idx2TextField.text == nil || [idx2TextField.text length] == 0){
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
    
    if ([idx2TextField.text length] < 11 || [idx2TextField.text isEqualToString:@""] || idx2TextField.text == nil)
    {
        NSString *msg = @"출금계좌번호 11자에서 12자리를 입력해 주십시요.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        return NO;
    }
    
	if (idx3SecureField.text == nil || [idx3SecureField.text length] != 4){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"계좌비밀번호를 입력하여 주십시오."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
    
	return YES;
}

- (BOOL)checkDuplicateID{
	// 아이디 중복확인시 필수사항
	if (idx4TextField.text == nil || [idx4TextField.text length] < 6 || [idx4TextField.text length] > 16 || ![self checkID:idx4TextField.text]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"이용자아이디는 영문,숫자,대소문자 구분없이 6~16자 이내로 설정 가능합니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	return YES;
}

- (BOOL)checkSignupForeigner{
	// 외국인 화원가입시 필수사항
	if (!isCheckAccount){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"상단의 '계좌확인' 버튼을 선택하여\n계좌확인을 진행하여 주십시오."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	if (!isCheckDupliID){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"이용자아이디 란의 '중복확인' 버튼을 선택하여 아이디 중복여부를 확인하여 주십시오."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	if (idx5SecureField.text == nil || [idx5SecureField.text length] < 6 || [idx5SecureField.text length] > 16 || ![self checkPw:idx5SecureField.text]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"이용자 비밀번호는 영문,숫자의 조합으로 6~16자 이내로 설정 가능합니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	if (![idx5SecureField.text isEqualToString:idx6SecureField.text]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"이용자 비밀번호와 이용자 비밀번호확인이 일치하지 않습니다. 다시한번 입력하여 주십시오."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	return YES;
}

- (void)requestAccountCheck{
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
							   @{
								@"주민등록번호" : _encJumin,
								@"실명번호" : _encJumin,
								@"출금계좌번호" : idx2TextField.text,
								@"출금계좌비밀번호" : accountPassword,
								@"반복횟수" : @"1",
								@"은행구분" : @"1",
								@"reservationField10" : @"계좌확인",
							   }] autorelease];
	
    AppInfo.serviceOption = @"계좌확인";
    self.service = nil;
	self.service = [[[SHBSignupService alloc] initWithServiceId:SIGNUP_FOREIGNER_ACCOUNT_CHECK viewController:self] autorelease];
    self.service.previousData = forwardData;
    [self.service start];
}

- (void)requestDuplicateIDcheck{
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
							   @{
							TASK_NAME_KEY : @"sfg.sphone.task.common.MemberUtil",
							TASK_ACTION_KEY : @"getIDDupChk",
							   @"userid" : [idx4TextField.text uppercaseString],
							   }] autorelease];
    self.service = nil;
    self.service = [[[SHBSignupService alloc] initWithServiceId:SIGNUP_CHECK_DUPLICATE_ID viewController:self] autorelease];
    self.service.previousData = forwardData;
    [self.service start];
}

- (void)requestSignupForeigner{
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
							   @{
							   @"회원구분" : @"1",
							   @"MEMBER_ID" : [idx4TextField.text uppercaseString],
							   @"비밀번호" : idPassword1,
							   @"성명" : userName,
							   //@"주민등록번호1" : [idx1TextField.text substringWithRange:NSMakeRange(0, 6)],
							   //@"주민등록번호2" : [idx1TextField.text substringWithRange:NSMakeRange(6, 7)],
                               @"주민번호" : _encJumin,
							   @"비밀번호힌트" : @"",
							   @"비밀번호힌트정답" : @"",
							   @"reservationField1" : @"외국인회원가입",
							   }] autorelease];
    self.service = nil;
    self.service = [[[SHBSignupService alloc] initWithServiceId:SIGNUP_FOREIGNER_REQUEST_JOIN viewController:self] autorelease];
    self.service.previousData = forwardData;
    [self.service start];
}


#pragma mark - HTTP Delegate
- (BOOL)onBind:(OFDataSet *)aDataSet{
	if ([[aDataSet objectForKey:@"Result"] isEqualToString:@"1"]){
		// 이용자 아이디 중복확인
		isCheckDupliID = YES;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"사용 가능한 아이디 입니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		
	}else if ([[aDataSet objectForKey:@"Result"] isEqualToString:@"2"]){
		// 이용자 아이디 중복확인
		isCheckDupliID = NO;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"중복된 아이디입니다.\n다른 아이디를 입력하여 주십시오."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		
	}else if([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"C2097"] && [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"]){
		// 계좌확인
		isCheckAccount = YES;
		SafeRelease(userName);
		userName = [[NSString alloc] initWithString:[aDataSet objectForKey:@"출금계좌성명"]];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"계좌확인에 성공하였습니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		
	}else if([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"H0011"] && [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"]){
		// 가입성공
		// 완료단계로 이동
		SHBForeignerStep3ViewController *step3Controller = [[SHBForeignerStep3ViewController alloc] initWithNibName:@"SHBForeignerStep3ViewController" bundle:nil];
		[self.navigationController pushFadeViewController:step3Controller];
		[step3Controller release];

	}
	
	
	return NO;
}


#pragma mark - IBAction
- (IBAction)buttonPressed:(UIButton *)sender{
	if (sender.tag == 10){
		// 계좌확인
		if (![self checkAccountCompulsory]) return;
		
		[self closeiOSKeyPad];
		[self requestAccountCheck];
		
	}else if (sender.tag == 20){
		// 중복확인
		if (![self checkDuplicateID]) return;
		
		[self closeiOSKeyPad];
		[self requestDuplicateIDcheck];
		
	}else if (sender.tag == 30){
		// 확인
		if (![self checkSignupForeigner]) return;
		
		[self closeiOSKeyPad];
		[self requestSignupForeigner];
				
	}else if (sender.tag == 40){
		// 다시작성
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"다시 작성할 경우 입력된 모든 정보가 초기화 됩니다.\n다시 작성하시겠습니까?"
													   delegate:self
											  cancelButtonTitle:nil
											  otherButtonTitles:@"예", @"아니오",nil];
		alert.tag = 9999998;
		[alert show];
		[alert release];
		
	}
}

- (IBAction)closeNormalPad0:(id)sender
{
    [super closeNormalPad:nil];
    
    [self closeiOSKeyPad];
    
    [idx1TextField becomeFirstResponder];
}

- (IBAction)closeNormalPad1:(id)sender
{
    [super closeNormalPad:nil];
    
    [self closeiOSKeyPad];
    
    [idx3SecureField becomeFirstResponder];
}

- (IBAction)closeNormalPad2:(id)sender
{
    [super closeNormalPad:nil];
    
    [self closeiOSKeyPad];
    
    AppInfo.isUserPwdRegister = YES;
    [idx5SecureField becomeFirstResponder];
}

- (IBAction)closeNormalPad3:(id)sender
{
    [super closeNormalPad:nil];
    
    [self closeiOSKeyPad];
    AppInfo.isUserPwdRegister = YES;
    [idx6SecureField becomeFirstResponder];
}

#pragma mark - Delegate : SHBTextFieldAccDelegate
- (void)didPrevButtonTouch{
	[self closeiOSKeyPad];
	
	switch (indexCurrentField) {
		case 2:
			// 계좌번호
			[idx1TextField becomeFirstResponder];
			break;
		case 4:
			// 이용자아이디
			[idx3SecureField becomeFirstResponder];
			break;
			
		default:
			break;
	}

};		// 이전버튼
- (void)didNextButtonTouch{
	
	
	switch (indexCurrentField) {
		case 1:
			// 외국인등록번호
            [self closeiOSKeyPad];
			[idx2TextField becomeFirstResponder];
			break;
		case 2:
			// 계좌번호
            [self closeiOSKeyPad];
			[idx3SecureField becomeFirstResponder];
			break;
		case 4:
			// 이용자아이디
            [self closeiOSKeyPad];
			[idx5SecureField becomeFirstResponder];
			break;
		default:
			break;
	}


};		// 다음버튼
- (void)didCompleteButtonTouch{
	[self closeiOSKeyPad];
	[self scrollMainView:0];
	
	
};	// 완료버튼

#pragma mark - Delegate : UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	int txtLen = [textField.text length];
    
	if (textField == idx1TextField){
		isCheckAccount = NO;
		if (txtLen >= 13 && range.length == 0) return NO;
		
	}else if (textField == idx2TextField){
		isCheckAccount = NO;
        
        if ([string length] > 1) return NO;
        
		if (txtLen >= 12 && range.length == 0) return NO;
		
	}else if (textField == idx4TextField){
		isCheckDupliID = NO;
		if (txtLen >= 16 && range.length == 0) return NO;
		
	}
    
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	indexCurrentField = textField.tag;
	
	[scrollView setContentOffset:CGPointMake(0, 0)];
	
	int scrollY = 0;
	switch (indexCurrentField) {
		case 2:
			// 계좌번호
			scrollY = 25;
			break;
        case 3:
            isCheckAccount = NO;
			scrollY = 70;
            break;
		case 4:
			// 이용자아이디
			scrollY = 160;
			[scrollView setContentOffset:CGPointMake(0, 115)];
			break;
        case 5:
            // 이용자비밀번호
            scrollY = 260;
            break;
        case 6:
            // 이용자비밀번호확인
			scrollY = 325;
			[scrollView setContentOffset:CGPointMake(0, 115)];
		case 7:
		case 8:
		case 9:
			// 휴대폰번호 3
			scrollY = 335;
			[scrollView setContentOffset:CGPointMake(0, 115)];
			break;
		default:
			break;
	}
	
	float posY = scrollView.contentOffset.y - scrollY;
	switch (indexCurrentField) {
        
		case 2:
        case 3:
		case 4:
        case 5:
        case 6:
		case 7:
		case 8:
		case 9:
			[self scrollMainView:posY];
			break;
		default:
			break;
	}
	
    if (indexCurrentField != 3 && indexCurrentField != 5 && indexCurrentField != 6)
    {
        [(SHBTextField*)textField focusSetWithLoss:YES];
    }
	

	if (indexCurrentField == 1) {
		[(SHBTextField*)textField enableAccButtons:NO Next:YES];
	}else if (indexCurrentField == 6) {
		[(SHBTextField*)textField enableAccButtons:YES Next:NO];
	}else{
		[(SHBTextField*)textField enableAccButtons:YES Next:YES];
	}
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self closeiOSKeyPad];
	
	switch (indexCurrentField) {
		case 2:
		case 4:
		case 7:
		case 8:
		case 9:
			[self scrollMainView:0];
			break;
		default:
			break;
	}
	
	return YES;
}


#pragma mark - Delegate : SHBSecureDelegate
- (void)secureTextFieldDidBeginEditing:(SHBSecureTextField *)textField{
	indexCurrentField = textField.tag;
	
	[scrollView setContentOffset:CGPointMake(0, 0)];
	
	int scrollY = 0;
	switch (indexCurrentField) {
        case 1:
            [textField enableAccButtons:NO Next:YES];
            break;
		case 3:
			// 계좌비밀번호
			isCheckAccount = NO;
			scrollY = 70;
			break;
		case 5:
			// 이용자비밀번호
			scrollY = 260;
			[scrollView setContentOffset:CGPointMake(0, 115)];
			break;
		case 6:
			// 이용자비밀번호확인
			scrollY = 325;
			[scrollView setContentOffset:CGPointMake(0, 115)];
            
            [textField enableAccButtons:YES Next:NO];
			break;
		default:
			break;
	}
	
	float posY = scrollView.contentOffset.y - scrollY;
	switch (indexCurrentField) {
        case 1:
		case 3:
		case 5:
		case 6:
			[self scrollMainView:posY];
			break;
		default:
			break;
	}
	
	
}
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    if (textField == idx1TextField) {
        self.encJumin = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
    }
	if (textField == idx3SecureField){
		SafeRelease(accountPassword);
		accountPassword = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_NUM=%@>", value]];
	}else if (textField == idx5SecureField){
		SafeRelease(idPassword1);
		idPassword1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_CHAR=%@>", value]];
	}else if (textField == idx6SecureField){
		SafeRelease(idPassword2);
		idPassword2 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_CHAR=%@>", value]];
	}
	
	switch (indexCurrentField) {
        case 1:
		case 3:
		case 5:
		case 6:
			[self scrollMainView:0];
			break;
		default:
			break;
	}
	
}

- (void)onPreviousClick:(NSString*)pPlainText encText:(NSString*)pEncText{
	[self closeiOSKeyPad];
	
    if (indexCurrentField == 1) {
        self.encJumin = [NSString stringWithFormat:@"<E2K_NUM=%@>", pEncText];
    }
	else if (indexCurrentField == 3) {
		// 계좌비밀번호
		SafeRelease(accountPassword);
		accountPassword = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_NUM=%@>", pEncText]];
		
		[idx2TextField becomeFirstResponder];
	}else if (indexCurrentField == 5) {
		// 이용자비밀번호
		SafeRelease(idPassword1);
		idPassword1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_CHAR=%@>", pEncText]];
		
		[idx4TextField becomeFirstResponder];
	}else if (indexCurrentField == 6) {
		// 이용자비밀번호확인
		SafeRelease(idPassword2);
		idPassword2 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_CHAR=%@>", pEncText]];
		
		[idx5SecureField becomeFirstResponder];
	}
}
- (void)onNextClick:(NSString*)pPlainText encText:(NSString*)pEncText{
	[self closeiOSKeyPad];
	
	switch (indexCurrentField) {
        case 1:
            self.encJumin = [NSString stringWithFormat:@"<E2K_NUM=%@>", pEncText];
            [idx2TextField becomeFirstResponder];
            break;
		case 3:
			// 계좌비밀번호
			SafeRelease(accountPassword);
			accountPassword = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_NUM=%@>", pEncText]];
			[idx4TextField becomeFirstResponder];
			break;
		case 5:
			// 이용자비밀번호
			SafeRelease(idPassword1);
			idPassword1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_CHAR=%@>", pEncText]];
			[idx6SecureField becomeFirstResponder];
			break;
		case 6:
			// 이용자비밀번호확인
			SafeRelease(idPassword2);
			idPassword2 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_CHAR=%@>", pEncText]];
			break;
		default:
			break;
	}
}


@end
