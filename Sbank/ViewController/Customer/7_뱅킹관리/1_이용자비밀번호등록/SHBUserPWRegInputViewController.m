//
//  SHBUserPWRegInputViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUserPWRegInputViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"
#import "SHBSettingsService.h"
#import "SHBIdentity1ViewController.h"
#import "SHBUserPWRegCompleteViewController.h"
#import "SHBUserPWRegViewController.h"
#import "Encryption.h"

@interface SHBUserPWRegInputViewController () <SHBIdentity1Delegate>

@property (nonatomic, retain) NSString *strEncryptedPW;	// 비밀번호
@property (nonatomic, retain) NSString *strEncryptedAccountPW;	// 출금계좌비밀번호

@end

@implementation SHBUserPWRegInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_strEncryptedPW release];
	[_strEncryptedAccountPW release];
	[_strServiceCode release];
	[_lblID release];
	[_lblName release];
	[_tfPW release];
	[_tfPWConfirm release];
	[_tfAccountNo release];
	[_tfAccountPW release];
	[_ivBox release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setLblID:nil];
	[self setLblName:nil];
	[self setTfPW:nil];
	[self setTfPWConfirm:nil];
	[self setTfAccountNo:nil];
	[self setTfAccountPW:nil];
	[self setIvBox:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.contentScrollView.contentSize = CGSizeMake(317, 506);
    contentViewHeight = contentViewHeight > 506 ? contentViewHeight : 506;
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222003;
    
    self.strBackButtonTitle = @"이용자 비밀번호 등록 2단계";
	[self setTitle:@"이용자 비밀번호 등록"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이용자 정보입력(2)" maxStep:5 focusStepNumber:2]autorelease]];
	[self.ivBox setImage:[[UIImage imageNamed:@"box_consent"]stretchableImageWithLeftCapWidth:2 topCapHeight:2]];
	
	[self.tfPW showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:16];
	[self.tfPWConfirm showKeyPadWitType:SHBSecureTextFieldTypeCharacter delegate:self target:self maximum:16];
	[self.tfAccountNo setAccDelegate:self];
	[self.tfAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
	
	[self.lblID setText:[self.data objectForKey:@"아이디"]];
	[self.lblName setText:[self.data objectForKey:@"고객성명"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.contentScrollView flashScrollIndicators];
}

#pragma mark - etc
- (BOOL)checkPw:(NSString *)str
{
	char *chars;
	int len;
	int i;
	BOOL containAlphabet;
	BOOL containNumeric;
	
	
	if (str == nil)
	{
		return NO;
	}
	
	if ([str length] == 0 && [str isEqualToString:@""])
	{
		return NO;
	}
	
	chars = (char*)[str UTF8String];
	len = strlen(chars);
	
	containNumeric = containAlphabet = NO;
	
	for (i = 0; i < len; i++)
	{
		if (
			!(
			  (chars[i] >= '0' && chars[i] <= '9')
			  ||
			  (chars[i] >= 'a' && chars[i] <= 'z')
			  ||
			  (chars[i] >= 'A' && chars[i] <= 'Z')
			  )
			)
		{
			return NO;
		}
		
		if (chars[i] >= '0' && chars[i] <= '9')
		{
			containNumeric = YES;
			continue;
		}
		
		if (chars[i] >= 'a' && chars[i] <= 'z')
		{
			containAlphabet = YES;
			continue;
		}
		
		if (chars[i] >= 'A' && chars[i] <= 'Z')
		{
			containAlphabet = YES;
			continue;
		}
		
	}
	
	return containNumeric && containAlphabet;
	
	
}

#pragma mark - Action

- (IBAction)closeNormalPad1:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [_tfPW becomeFirstResponder];
}

- (IBAction)closeNormalPad2:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [_tfPWConfirm becomeFirstResponder];
}

- (IBAction)closeNormalPad3:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [_tfAccountPW becomeFirstResponder];
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
	NSString *strMsg = nil;

	if ([self.tfPW.text length] < 6 || [self.tfPW.text length] > 15 || [self checkPw:self.tfPW.text] == NO) {
		strMsg = @"이용자 비밀번호는 영문,숫자의 조합으로 6~16자 이내로 설정 가능합니다.";
	}
	else if ([self.tfPW.text isEqualToString:self.tfPWConfirm.text] == NO)
	{
		strMsg = @"이용자 비밀번호와 이용자 비밀번호확인이 일치하지 않습니다. 다시한번 입력하여 주십시오.";
	}
	else if (![self.tfAccountNo.text length])
	{
		strMsg = @"계좌번호를 입력하여 주십시오.";
	}
	else if ([self.tfAccountPW.text length] != 4)
	{
		strMsg = @"계좌비밀번호를 입력하여 주십시오.";
	}
	
	if (strMsg) {
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:strMsg];
		
		return;
	}
	
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"출금계좌비밀번호" : self.strEncryptedAccountPW,
						   @"주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? [self.data objectForKey:@"주민등록번호"] : @"",
						   @"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? [self.data objectForKey:@"주민등록번호"] : @"",
						   @"반복횟수" : @"1",
						   @"은행구분" : @"1",
						   @"출금계좌번호" : self.tfAccountNo.text,
						   }];
	AppInfo.serviceOption = @"이용자계좌확인";
	self.service = [[[SHBSettingsService alloc]initWithServiceId:kC2097Id viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
	
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	[[NSNotificationCenter defaultCenter]postNotificationName:@"cancelButtonSelected" object:nil userInfo:nil];
	
	[self.navigationController fadePopViewController];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == self.tfAccountNo) {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 12)
        {
			return NO;
		}
		
	}
	
	return YES;
}

#pragma mark - SHBSecureTextField Delegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    Debug(@"EncriptedVaule: %@", value);
	
    if (textField == self.tfPW || textField == self.tfPWConfirm) {
        if ([self.tfPW.text isEqualToString:self.tfPWConfirm.text]) {
            self.strEncryptedPW = [NSString stringWithFormat:@"<E2K_CHAR=%@>", value];
        }
    }
    else if (textField == self.tfAccountPW) {
		self.strEncryptedAccountPW = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
	}
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
	if (self.service.serviceId == kC2097Id)
	{
		[self.tfAccountPW setText:nil];
		[self.tfPW setText:nil];
		[self.tfPWConfirm setText:nil];
		
		// 앱인포에 고객번호값 세팅, 휴대폰 인증때 필요
        Encryption *encryptor = [[Encryption alloc] init];
		//AppInfo.customerNo = [aDataSet objectForKey:@"고객번호"];
        if ([[aDataSet objectForKey:@"고객번호"] length] == 9)
        {
            AppInfo.customerNo = [NSString stringWithFormat:@"0%@",[aDataSet objectForKey:@"고객번호"]];
        }else
        {
            AppInfo.customerNo = [aDataSet objectForKey:@"고객번호"];
        }
        //AppInfo.ssn = [aDataSet objectForKey:@"실명번호->originalValue"];
        AppInfo.ssn = [encryptor aes128Encrypt:[aDataSet objectForKey:@"실명번호->originalValue"]];
        AppInfo.commonDic = @{ @"고객명" : [aDataSet objectForKey:@"출금계좌성명"], };
		[encryptor release];
        
        /*
		SHBMobileCertificateViewController *viewController = [[SHBMobileCertificateViewController alloc]initWithNibName:@"SHBMobileCertificateViewController" bundle:nil];
		viewController.serviceSeq = SERVICE_PASSWORD;
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
		
        
        
        
		// Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
		[viewController executeWithTitle:@"이용자 비밀번호 등록" Step:3 StepCnt:5 NextControllerName:nil];	// 휴대폰인증후 최종전문을 또 날려야하기에 NextController를 nil로.
		[viewController subTitle:@"휴대폰 가입인증" infoViewCount:MOBILE_INFOVIEW_1];
		
		[viewController release];
         */
        
        AppInfo.transferDic = @{ @"서비스코드" : @"A0052" };
        
        SHBIdentity1ViewController *viewController = [[SHBIdentity1ViewController alloc]initWithNibName:@"SHBIdentity1ViewController" bundle:nil];
        
        [viewController setServiceSeq:SERVICE_PASSWORD];
        viewController.delegate = self;
         [self checkLoginBeforePushViewController:viewController animated:YES];
        
        // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
        [viewController executeWithTitle:@"이용자 비밀번호 등록" Step:3 StepCnt:5 NextControllerName:nil];
        [viewController subTitle:@"추가인증 방법 선택"];
        [viewController release];

        
        
        
        
	}
	else if (self.service.serviceId == kA0052Id)
	{
		SHBUserPWRegCompleteViewController *viewController = [[SHBUserPWRegCompleteViewController alloc]initWithNibName:@"SHBUserPWRegCompleteViewController" bundle:nil];
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
	}
	
	return NO;
}

#pragma mark - 휴대폰인증 후 들어오는 메서드
- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic{
	[super viewControllerDidSelectDataWithDic:mDic];
	
	if (!mDic) {
		Debug(@"self.navigationController.viewControllers : %@", self.navigationController.viewControllers);
		[self.navigationController fadePopViewController];
		[self.navigationController fadePopViewController];
        
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   @"이용자ID" : self.lblID.text,
							   @"이용자PWD" : _strEncryptedPW,
							   @"주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? [self.data objectForKey:@"주민등록번호"] : @"",
							   }];
		self.service = [[[SHBSettingsService alloc]initWithServiceId:kA0052Id viewController:self]autorelease];
		self.service.requestData = dataSet;
		[self.service start];
	}
}


#pragma mark - identity1 delegate

- (void)identity1ViewControllerCancel
{
    // 취소시 입력값 초기화 필요한 경우
}

@end
