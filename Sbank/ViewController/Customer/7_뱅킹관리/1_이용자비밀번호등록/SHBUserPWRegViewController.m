//
//  SHBUserPWRegViewController.m
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUserPWRegViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBSettingsService.h"
#import "SHBUserPWRegInputViewController.h"

@interface SHBUserPWRegViewController ()
{
	SHBTextField *currentTextField;
}

@end

@implementation SHBUserPWRegViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	[_ssnTextField release];
	[_idTextField release];
	[_ivInfoBox release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setSsnTextField:nil];
	[self setIdTextField:nil];
	[self setIvInfoBox:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.contentScrollView.contentSize = CGSizeMake(317, 319);
    contentViewHeight = contentViewHeight > 319 ? contentViewHeight : 319;
    
    startTextFieldTag = 444000;
    endTextFieldTag = 444001;
	
    self.strBackButtonTitle = @"이용자 비밀번호 등록 1단계";
	[self setTitle:@"이용자 비밀번호 등록"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"이용자 정보입력(1)" maxStep:5 focusStepNumber:1]autorelease]];
	
	UIImage *image = [UIImage imageNamed:@"box_infor"];
	[self.ivInfoBox setImage:[image stretchableImageWithLeftCapWidth:2 topCapHeight:2]];
	
	[self.idTextField setAccDelegate:self];
    
    [_ssnTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:6];
    
	
	if ([AppInfo isLogin])
    {
        //로그아웃 버튼을 로그인 버튼으로 변경
        [AppInfo logout];
        [self changeQuickLogin:NO];
        [[[AppDelegate.navigationController viewControllers] objectAtIndex:1] changeQuickLogin:NO];
        
	}
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearInputData) name:@"cancelButtonSelected" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - noti
- (void)clearInputData
{
	[self.ssnTextField setText:nil];
	[self.idTextField setText:nil];
}

#pragma mark - Action

- (IBAction)closeNormalPad:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [_ssnTextField becomeFirstResponder];
}

- (IBAction)confirmButtonAction:(UIButton *)sender {
#if 0
	SHBUserPWRegInputViewController *viewController = [[SHBUserPWRegInputViewController alloc]initWithNibName:@"SHBUserPWRegInputViewController" bundle:nil];
	viewController.data = self.data;
	[self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
	
	return;
#endif
	if ([self.ssnTextField.text length] != 6) {
		[[[[UIAlertView alloc]initWithTitle:@"" message:@"생년월일 6자리를 입력하여 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil]autorelease]show];
		
		return;
	}
	
	if ([self.idTextField.text length] < 6) {
		[[[[UIAlertView alloc]initWithTitle:@"" message:@"이용자아이디는 영문,숫자,대소문자 구분없이 6~16자 이내입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil]autorelease]show];
		
		return;
	}

	self.service = [[[SHBSettingsService alloc]initWithServiceId:kA0051Id viewController:self]autorelease];
	self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
								@"주민등록번호" : [self.ssnTextField.text substringWithRange:NSMakeRange(0, 6)],
								@"이용자ID" : [self.idTextField.text uppercaseString],
								@"거래구분" : @"1",
								}];
	[self.service start];
}

- (IBAction)cancelButtonAction:(SHBButton *)sender {
	[self.navigationController fadePopViewController];
}

//#pragma mark - UITextField Delegate
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//	[self.ssnTextField focusSetWithLoss:NO];
//	[self.idTextField focusSetWithLoss:NO];
//	
//	[(SHBTextField *)textField focusSetWithLoss:YES];
//}

//#pragma mark - SHBTextField Delegate
//- (void)didPrevButtonTouch
//{
//}
//
//- (void)didNextButtonTouch
//{
//}
//
//- (void)didCompleteButtonTouch
//{
//	[self.ssnTextField resignFirstResponder];
//	[self.idTextField resignFirstResponder];
//	
//	[self.idTextField focusSetWithLoss:NO];
//}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == self.ssnTextField) {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 13)
        {
			return NO;
		}

	}
	else if (textField == self.idTextField)
	{
        //한글은 입력 못한다.
        if (dataLength2 > 1)
        {
            return NO;
        }
		
		//특수문자 : ₩ $ £ ¥ • 은 입력 안됨
		NSString *SPECIAL_CHAR = @"\\$₩€£¥•%#<>[]^{|}\"";
		
		NSCharacterSet *cs;
		cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 16)
        {
			return NO;
		}
	}
	
	return YES;
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
	if (self.service.serviceId == kA0051Id)
	{
		/**
		 COM_UPMU_GBN = R;
		 COM_SUBCHN_KBN = 02;
		 COM_CIF_NO = 640512923;
		 COM_NO_SEND = ;
		 COM_USER_ERR = ;
		 COM_EF_YOIL = 1;
		 보안카드질의번호1 = ;
		 COM_TRAN_DATE = 2012.12.03;
		 고객번호 = 0640512923;
		 이체비밀번호구분->getSession = system:이체비밀번호구분;
		 COM_SEC_CHK = ;
		 COM_SEC_CHAL1 = ;
		 COM_EF_TIME = 205118;
		 COM_FILLER2 = ;
		 COM_SYS_GBN = T;
		 보안카드질의번호2 = ;
		 COM_RESULT_CD = 0;
		 COM_LANGUAGE = 1;
		 보안카드정보->getSession = system:보안매체정보;
		 보안카드질의번호1->getSession = system:COM_SEC_CHAL1;
		 COM_FILLER1 = ;
		 COM_ICHEPSWD_CHK = ;
		 COM_SVC_CODE = A0051;
		 COM_JSTAR_VALUE = SHB01          395        9500;
		 COM_EF_DATE = 20121203;
		 COM_PKTLEN = 233;
		 보안매체 = 5;
		 COM_SEC_CHAL2 = ;
		 COM_TRAN_DATE->originalValue = 20121203;
		 COM_ECHO_TYPE = ;
		 COM_CHANNEL_KBN = DT;
		 COM_TRAN_TIME = 20:51:27;
		 COM_EF_SERIALNO = 20749882;
		 COM_PG_SERIAL = ;
		 COM_JUMIN_NO = 7401211117628;
		 COM_IP_ADDR = 59.7.254.139;
		 COM_WEB_DOMAIN = etcwb1t1;
		 COM_TRAN_TIME->originalValue = 205127;
		 COM_END_MARK = ZZ;
		 고객성명 = 코눈타;
		 COM_YEYAK_ICHE = ;
		 보안카드질의번호2->getSession = system:COM_SEC_CHAL2;
		 */
		
		if ([[self.data objectForKey:@"거래구분"]isEqualToString:@"1"]) {
			[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"고객님께서는 이용자 비밀번호를 이미 등록하셨습니다. 확인 후 거래하여 주시기 바랍니다."];
			
			return NO;
		}
		else
		{
			//[aDataSet setObject:[self.ssnTextField.text substringWithRange:NSMakeRange(0, 13)] forKey:@"주민등록번호"];
            [aDataSet setObject:[self.ssnTextField.text substringWithRange:NSMakeRange(0, 6)] forKey:@"주민등록번호"];
			[aDataSet setObject:[self.idTextField.text uppercaseString] forKey:@"아이디"];
			
			SHBUserPWRegInputViewController *viewController = [[SHBUserPWRegInputViewController alloc]initWithNibName:@"SHBUserPWRegInputViewController" bundle:nil];
			viewController.strServiceCode = @"A0051";
			viewController.data = aDataSet;
			[self checkLoginBeforePushViewController:viewController animated:YES];
			[viewController release];
		}
	}
	
	return NO;
}

#pragma mark - SHBSecureTextField

- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
}

@end
