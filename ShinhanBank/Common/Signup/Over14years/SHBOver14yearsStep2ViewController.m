//
//  SHBOver14yearsStep2ViewController.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBOver14yearsStep2ViewController.h"
#import "SHBAttentionLabel.h"
#import "SHBOver14yearsStep3ViewController.h"
#import "SHBSignupService.h"

@interface SHBOver14yearsStep2ViewController ()

@end

@implementation SHBOver14yearsStep2ViewController

@synthesize accountPassword, idPassword1, idPassword2;


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
	if (alertView.tag == 9999997 && buttonIndex == 0) {
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
	SHBAttentionLabel* descTopLabel = [[SHBAttentionLabel alloc] initWithFrame:CGRectMake(8.0f, 3.0f, 301.0f, 45.0f)];
	descTopLabel.backgroundColor = [UIColor clearColor];
	descTopLabel.offsety = -7;
	descTopLabel.text = @"<midBlue_13>신한은행은 고객님의 개인정보 보호를 위해 실명 확인제를\n실시하고 있습니다. 실명과 주민등록번호가 일치하는\n경우에만 가입이 가능합니다.</midBlue_13>";
	[mainView addSubview:descTopLabel];
	[descTopLabel release];
	
	// 스크롤뷰에 뷰 추가
	mainView.frame = CGRectMake(0, 0, 317, 530);
    
    [self.contentScrollView addSubview:mainView];
    [self.contentScrollView setContentSize:mainView.frame.size];
    
    contentViewHeight = mainView.frame.size.height;
    
    NSArray *array = @[ idx1TextField, idx2TextField, idx3TextField, idx4SecureField, idx5TextField,
                        idx6SecureField, idx7SecureField, ];
    
    [self setTextFieldTagOrder:array];
	
	// 보안 필드
    [idx2TextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:13];
	[idx4SecureField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
	[idx6SecureField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:16];
	[idx7SecureField showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:16];
	
	indexCurrentField = 0;
	
	svcH1009Dic = [[NSMutableDictionary alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.encJumin = nil;
	[svcH1009Dic release];
	
	[super dealloc];
}


#pragma mark - Method

- (void)clearData{
	isCheckAccount = NO;
	isCheckDupliID = NO;
	
	idx1TextField.text = @"";
	idx2TextField.text = @"";
	idx3TextField.text = @"";
	idx4SecureField.text = @"";
	idx5TextField.text = @"";
	idx6SecureField.text = @"";
	idx7SecureField.text = @"";
	//idx8TextField.text = @"";
	//idx9TextField.text = @"";
	//idx10TextField.text = @"";
	
	[self.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
	if (idx1TextField.text == nil || [idx1TextField.text length] < 2){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"이름(실명)을 입력하여 주십시오."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	
	if (idx2TextField.text == nil || [idx2TextField.text length] < 13){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"주민등록번호 13자리를 입력하여 주십시오."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	/*
	if (idx3TextField.text == nil || [idx3TextField.text length] == 0){
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
    if ([idx3TextField.text length] < 11 || [idx3TextField.text isEqualToString:@""] || idx3TextField.text == nil)
    {
        NSString *msg = @"출금계좌번호 11자에서 12자리를 입력해 주십시요.";
        [UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
        return NO;
    }
    
	if (idx4SecureField.text == nil || [idx4SecureField.text length] != 4){
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
	if (idx5TextField.text == nil || [idx5TextField.text length] < 6 || [idx5TextField.text length] > 16 || ![self checkID:idx5TextField.text]){
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

- (BOOL)checkSignupPersonal{
	// 개인 화원가입시 필수사항
	if (!isCheckAccount){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"상단의 '실명 및 계좌확인' 버튼을 선택하여 계좌확인을 진행하여 주십시오."
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
    
    
	if (idx6SecureField.text == nil || [idx6SecureField.text length] < 6 || [idx6SecureField.text length] > 16 || ![self checkPw:idx6SecureField.text]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"이용자 비밀번호는 영문,숫자의 조합으로 6~16자 이내로 설정 가능합니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
	if (![idx7SecureField.text isEqualToString:idx6SecureField.text]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"이용자 비밀번호와 이용자 비밀번호확인이 일치하지 않습니다. 다시한번 입력하여 주십시오."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		return NO;
	}
//	if ([idx8TextField.text length] + [idx9TextField.text length] + [idx10TextField.text length] < 10){
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//														message:@"휴대전화 10~11자리를 입력하여 주십시오."
//													   delegate:self
//											  cancelButtonTitle:@"확인"
//											  otherButtonTitles:nil];
//		
//		[alert show];
//		[alert release];
//		return NO;
//	}
	
	return YES;
}

- (void)requestAccountCheck{
/*
//	// 계좌확인 하기 전에 실명확인을 요청을 보내고 정상일때 계좌확인 전문을 보냄.
//	isRequestNameCert = YES;
//	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
//								@{
//								TASK_NAME_KEY : @"sfg.sphone.task.common.MemberUtil",
//								TASK_ACTION_KEY : @"getNameCert",
//								@"userIdentifier" : idx2TextField.text,
//								@"username" : idx1TextField.text,
//								}] autorelease];
//    self.service = [[SHBSignupService alloc] initWithServiceId:SIGNUP_CHECK_REAL_NAME viewController:self];
//    self.service.previousData = forwardData;
//    [self.service start];
	
	// Test시 실명확인은 패쓰
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								@{
								@"주민등록번호" : idx2TextField.text,
								@"실명번호" : idx2TextField.text,
								@"출금계좌번호" : idx3TextField.text,
								@"출금계좌비밀번호" : accountPassword,
								@"반복횟수" : @"1",
								@"은행구분" : @"1",
								@"reservationField10" : @"계좌확인",
								}] autorelease];
	
    
	AppInfo.serviceOption = @"계좌확인";
	self.service = [[SHBSignupService alloc] initWithServiceId:SIGNUP_PERSONAL_ACCOUNT_CHECK viewController:self];
	self.service.previousData = forwardData;
	[self.service start];
*/	
    SHBDataSet *forwardData;
    
    if (!AppInfo.realServer)
    {
        forwardData = [[[SHBDataSet alloc] initWithDictionary:
                        @{
                        @"주민등록번호" : _encJumin,
                        @"실명번호" : _encJumin,
                        @"출금계좌번호" : idx3TextField.text,
                        @"출금계좌비밀번호" : accountPassword,
                        @"반복횟수" : @"1",
                        @"은행구분" : @"1",
                        @"reservationField10" : @"계좌확인",
                        }] autorelease];
        
        
        AppInfo.serviceOption = @"계좌확인";
        // release 처리
        self.service = nil;
        self.service = [[[SHBSignupService alloc] initWithServiceId:SIGNUP_PERSONAL_ACCOUNT_CHECK viewController:self] autorelease];
        self.service.previousData = forwardData;
        [self.service start];
    } else
    {
        isRequestNameCert = YES;
        forwardData = [[[SHBDataSet alloc] initWithDictionary:
                        @{
                                               TASK_NAME_KEY : @"sfg.sphone.task.common.MemberUtil",
                                             TASK_ACTION_KEY : @"getNameCert",
                        @"userIdentifier" : _encJumin,
                        @"username" : idx1TextField.text,
                        }] autorelease];
        self.service = nil;
        self.service = [[[SHBSignupService alloc] initWithServiceId:SIGNUP_CHECK_REAL_NAME viewController:self] autorelease];
        self.service.previousData = forwardData;
        [self.service start];
    }
    
    
}

- (void)requestDuplicateIDcheck{
	isRequestNameCert = NO;
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								@{
								TASK_NAME_KEY : @"sfg.sphone.task.common.MemberUtil",
								TASK_ACTION_KEY : @"getIDDupChk",
								@"userid" : [idx5TextField.text uppercaseString],
								}] autorelease];
    // release 처리
    self.service = nil;
    self.service = [[[SHBSignupService alloc] initWithServiceId:SIGNUP_CHECK_DUPLICATE_ID viewController:self] autorelease];
    self.service.previousData = forwardData;
    [self.service start];
}

- (void)requestSignupPersonal{
	isRequestNameCert = NO;
	SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
								@{
								@"회원구분" : @"1",
								@"MEMBER_ID" : [idx5TextField.text uppercaseString],
								@"비밀번호" : idPassword1,
								@"성명" : idx1TextField.text,
								//@"주민등록번호1" : [idx2TextField.text substringWithRange:NSMakeRange(0, 6)],
								//@"주민등록번호2" : [idx2TextField.text substringWithRange:NSMakeRange(6, 7)],
                                @"주민번호" : _encJumin,
								@"비밀번호힌트" : @"",
								@"비밀번호힌트정답" : @"",
								//@"핸드폰1" : idx8TextField.text,
								//@"핸드폰2" : idx9TextField.text,
								//@"핸드폰3" : idx10TextField.text,
								@"추천인ID" : @"",
								@"reservationField1" : @"내국인회원가입",
								}] autorelease];
    
    // release 처리
    self.service = nil;
    self.service = [[[SHBSignupService alloc] initWithServiceId:SIGNUP_PERSONAL_REQUEST_JOIN viewController:self] autorelease];
    self.service.previousData = forwardData;
    [self.service start];
}


#pragma mark - HTTP Delegate
- (BOOL)onBind:(OFDataSet *)aDataSet{
	if (isRequestNameCert && [[aDataSet objectForKey:@"Result"] isEqualToString:@"1"]){
		// 실명인증 정상
		isRequestNameCert = NO;
		SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
									@{
									@"주민등록번호" : _encJumin,
									@"실명번호" : _encJumin,
									@"출금계좌번호" : idx3TextField.text,
									@"출금계좌비밀번호" : accountPassword,
									@"반복횟수" : @"1",
									@"은행구분" : @"1",
									@"reservationField10" : @"계좌확인",
									}] autorelease];
		
		AppInfo.serviceOption = @"계좌확인";
        // release 처리
        self.service = nil;
		self.service = [[[SHBSignupService alloc] initWithServiceId:SIGNUP_PERSONAL_ACCOUNT_CHECK viewController:self] autorelease];
		self.service.previousData = forwardData;
		[self.service start];
	}else if (isRequestNameCert && [[aDataSet objectForKey:@"Result"] isEqualToString:@"2"]){
		// 실명인증 (Error)
		isRequestNameCert = NO;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:[aDataSet objectForKey:@"ErrorMsg"]
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		
	}else if (isRequestNameCert && [[aDataSet objectForKey:@"Result"] isEqualToString:@"3"]){
		// 실명인증 (기가입고객)
		isRequestNameCert = NO;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"이미 가입하신 회원입니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		
	}else if (!isRequestNameCert && [[aDataSet objectForKey:@"Result"] isEqualToString:@"1"]){
		// 이용자 아이디 중복확인
        idx5TextField.text = [idx5TextField.text uppercaseString];
		isCheckDupliID = YES;
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"사용 가능한 아이디 입니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		
	}else if (!isRequestNameCert && [[aDataSet objectForKey:@"Result"] isEqualToString:@"2"]){
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
		
		//AppInfo.customerNo = [aDataSet objectForKey:@"고객번호"];
        if ([[aDataSet objectForKey:@"고객번호"] length] == 9)
        {
            AppInfo.customerNo = [NSString stringWithFormat:@"0%@",[aDataSet objectForKey:@"고객번호"]];
        }else
        {
            AppInfo.customerNo = [aDataSet objectForKey:@"고객번호"];
        }
		AppInfo.loginName = idx1TextField.text;
		
		
		[svcH1009Dic setObject:[aDataSet objectForKey:@"고객번호"] forKey:@"고객번호"];
		[svcH1009Dic setObject:[aDataSet objectForKey:@"실명번호->originalValue"] forKey:@"주민번호"];
		[svcH1009Dic setObject:[aDataSet objectForKey:@"계좌관리점"] forKey:@"인증계좌관리점"];
		[svcH1009Dic setObject:[aDataSet objectForKey:@"출금계좌번호->originalValue"] forKey:@"인증계좌번호"];
		[svcH1009Dic setObject:[[aDataSet objectForKey:@"COM_TRAN_DATE->originalValue"] stringByReplacingOccurrencesOfString:@"." withString:@""] forKey:@"신규일자"];
		[svcH1009Dic setObject:@"" forKey:@"권유자행번"];
		
		isCheckAccount = YES;
		
        AppInfo.commonDic = nil;
        AppInfo.commonDic = @{
        @"고객번호" : aDataSet[@"고객번호"],
        @"출금계좌번호" : aDataSet[@"출금계좌번호->originalValue"],
        //@"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? aDataSet[@"실명번호->originalValue"] : @"",
        @"실명번호" : aDataSet[@"실명번호->originalValue"],
        @"고객명"   : idx1TextField.text,
        };
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"실명 및 계좌확인에 성공하였습니다."
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		
	}else if([[aDataSet objectForKey:@"COM_SVC_CODE"] isEqualToString:@"H0011"] && [[aDataSet objectForKey:@"COM_RESULT_CD"] isEqualToString:@"0"]){
		// 가입성공
		// 완료단계로 이동
		AppInfo.loginID = idx5TextField.text;
		
		SHBOver14yearsStep3ViewController *step3Controller = [[SHBOver14yearsStep3ViewController alloc] initWithNibName:@"SHBOver14yearsStep3ViewController" bundle:nil];
		[self.navigationController pushFadeViewController:step3Controller];
		[step3Controller setH1009Dic:svcH1009Dic];
		[step3Controller release];
		
	}
	
	
	return NO;
}


#pragma mark - IBAction
- (IBAction)buttonPressed:(UIButton *)sender{
	if (sender.tag == 100){
		// 계좌확인
		if (![self checkAccountCompulsory]) return;
		
		[self.curTextField resignFirstResponder];
		[self requestAccountCheck];
		
	}else if (sender.tag == 200){
		// 중복확인
		if (![self checkDuplicateID]) return;
		
		[self.curTextField resignFirstResponder];
		[self requestDuplicateIDcheck];
		
	}else if (sender.tag == 300){
		// 확인
		if (![self checkSignupPersonal]) return;
		
		[self.curTextField resignFirstResponder];
		[self requestSignupPersonal];
		
	}else if (sender.tag == 400){
		// 다시작성
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"다시 작성할 경우 입력된 모든 정보가 초기화 됩니다.\n다시 작성하시겠습니까?"
													   delegate:self
											  cancelButtonTitle:nil
											  otherButtonTitles:@"예", @"아니오",nil];
		alert.tag = 9999997;
		[alert show];
		[alert release];
		
	}
}


- (IBAction)closeNormalPad:(id)sender
{
    [super closeNormalPad:sender];
    
    
    UIButton *btn = sender;
    AppInfo.isUserPwdRegister = NO;
    if (btn.tag == 100)
    {
        [idx2TextField becomeFirstResponder];
    } else if (btn.tag == 101)
    {
        [idx4SecureField becomeFirstResponder];
    } else if (btn.tag == 102)
    {
         AppInfo.isUserPwdRegister = YES;
        [idx6SecureField becomeFirstResponder];
    } else if (btn.tag == 103)
    {
        AppInfo.isUserPwdRegister = YES;
        [idx7SecureField becomeFirstResponder];
    }
}


#pragma mark - Delegate : UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	int txtLen = [textField.text length];
	NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	if (textField == idx1TextField){
		isCheckAccount = NO;
		if (txtLen >= 15 && range.length == 0) return NO;
		
	}else if (textField == idx2TextField){
		isCheckAccount = NO;
		if (txtLen >= 13 && range.length == 0) return NO;
		
	}else if (textField == idx3TextField){

        
        if ([string length] > 1) return NO;
        
		if (txtLen >= 12 && range.length == 0) return NO;
		
	}else if (textField == idx5TextField){
		isCheckDupliID = NO;
		if (txtLen >= 16 && range.length == 0) return NO;
		
	}else if (textField == idx8TextField){
		if (txtLen >= 3 && range.length == 0) return NO;
		
	}else if (textField == idx9TextField){
		if (txtLen >= 4 && range.length == 0) return NO;
		
	}else if (textField == idx10TextField){
		if (txtLen >= 4 && range.length == 0) return NO;
		
	}
	
    if (textField == idx8TextField) {
        if ([textField.text length] >= 2 && range.length == 0) {
            if ([textString length] <= 3) {
                [idx8TextField setText:textString];
            }
            
            [super didNextButtonTouch];
            
            return NO;
        }
    }
    else if (textField == idx9TextField) {
        if ([textField.text length] >= 3 && range.length == 0) {
            if ([textString length] <= 4) {
                [idx9TextField setText:textString];
            }
            
            [super didNextButtonTouch];
            
            return NO;
        }
    }
    else if (textField == idx10TextField) {
        if ([textField.text length] >= 4 && range.length == 0) {
            return NO;
        }
    }
    
	return YES;
}

#pragma mark - Delegate : SHBSecureDelegate
- (void)secureTextFieldDidBeginEditing:(SHBSecureTextField *)textField{
    [super secureTextFieldDidBeginEditing:textField];
    
    if (textField == idx4SecureField) {
        isCheckAccount = NO;
    }
}

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    if (textField == idx2TextField) {
        self.encJumin = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
    }
	else if (textField == idx4SecureField){
		SafeRelease(accountPassword);
		accountPassword = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_NUM=%@>", value]];
	}else if (textField == idx6SecureField){
		SafeRelease(idPassword1);
		idPassword1 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_CHAR=%@>", value]];
	}else if (textField == idx7SecureField){
		SafeRelease(idPassword2);
		idPassword2 = [[NSString alloc] initWithString:[NSString stringWithFormat:@"<E2K_CHAR=%@>", value]];
	}
	
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
}

@end
