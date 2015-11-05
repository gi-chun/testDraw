//
//  SHBOTPReplaceInputViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 9. 27..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBOTPReplaceInputViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBSettingsService.h"
#import "SHBOTPReplaceCompleteViewController.h"

@interface SHBOTPReplaceInputViewController ()

@property (nonatomic, retain) NSString *strEncryptedText;

@end

@implementation SHBOTPReplaceInputViewController

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
	[self setTitle:@"OTP 시간보정"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"OTP 시간보정" maxStep:0 focusStepNumber:0]autorelease]];
	[self.scrollView setContentSize:CGSizeMake(width(self.scrollView), 406)];
	
	[self.otpPWTextField showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:6];
}

- (void)dealloc {
	[_strEncryptedText release];
	[_otpPWTextField release];
	[_scrollView release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setOtpPWTextField:nil];
	[self setScrollView:nil];
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.scrollView flashScrollIndicators];
}

#pragma mark - Action
- (IBAction)confirmBtnAction:(UIButton *)sender {
	if ([self.otpPWTextField.text length] != 6) {
		[[[[UIAlertView alloc]initWithTitle:@"" message:@"OTP카드 비밀번호 6자리를 입력하여 주십시오." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil]autorelease]show];
		
		return;
	}
	
	self.service = [[[SHBSettingsService alloc]initWithServiceId:kE4125Id viewController:self]autorelease];
	self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{@"OTP카드비밀번호" : self.strEncryptedText}];
	[self.service start];
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
	[self.navigationController fadePopViewController];
}

//#pragma mark - UITextField Delegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
//	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
//	
//	if (textField == self.otpPWTextField) {
//		// 숫자이외에는 입력안되게 체크
//		NSString *NUMBER_SET = @"0123456789";
//		
//		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
//		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
//		BOOL basicTest = [string isEqualToString:filtered];
//		
//		if (!basicTest && [string length] > 0 )
//        {
//			return NO;
//		}
//		if (dataLength + dataLength2 > 6)
//        {
//			return NO;
//		}
//		
//	}
//	
//	return YES;
//}

#pragma mark - SHBSecureTextField Delegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
	[super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    Debug(@"EncriptedVaule: %@", value);
	
	if (textField == self.otpPWTextField) {
		self.strEncryptedText = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
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
	if (self.service.serviceId == kE4125Id)
	{
		SHBOTPReplaceCompleteViewController *viewController = [[SHBOTPReplaceCompleteViewController alloc]initWithNibName:@"SHBOTPReplaceCompleteViewController" bundle:nil];
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
	}
	
	return NO;
}


@end
