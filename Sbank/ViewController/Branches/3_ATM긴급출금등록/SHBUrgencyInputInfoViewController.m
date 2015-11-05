//
//  SHBUrgencyInputInfoViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUrgencyInputInfoViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBAccountService.h"
#import "SHBBranchesService.h"
#import "SHBUrgencyInputConfirmViewController.h"
#import "SHBNewProductSeeStipulationViewController.h"

@interface SHBUrgencyInputInfoViewController ()

@property (nonatomic, retain) NSMutableArray *marrAccounts;	// 출금계좌번호 배열
@property (nonatomic, retain) NSDictionary *selectedData;	// 선택된 출금계좌
@property (nonatomic, retain) NSString *strEncryptedNum1;	// Encrypt된 계좌비밀번호
@property (nonatomic, retain) NSString *strEncryptedNum2;	// Encrypt된 1회용비밀번호
@property (nonatomic, retain) NSString *strEncryptedNum3;	// Encrypt된 1회용비밀번호 확인

@end

@implementation SHBUrgencyInputInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_atmInfoBtn release];
	[_strEncryptedNum1 release];
	[_strEncryptedNum2 release];
	[_strEncryptedNum3 release];
	[_marrAccounts release];
	[_selectedData release];
	[_sbAccountNum release];
	[_lblBalance release];
	[_tfAccountPW release];
	[_tfWithdrawAmount release];
	[_lblAmountKor release];
	[_tfInstantPW release];
	[_tfInstantPWConfirm release];
	[_tfPhoneNum1 release];
	[_tfPhoneNum2 release];
	[_tfPhoneNum3 release];
	[super dealloc];
}
- (void)viewDidUnload {
    [self setAtmInfoBtn:nil];
	[self setSbAccountNum:nil];
	[self setLblBalance:nil];
	[self setTfAccountPW:nil];
	[self setTfWithdrawAmount:nil];
	[self setLblAmountKor:nil];
	[self setTfInstantPW:nil];
	[self setTfInstantPWConfirm:nil];
	[self setTfPhoneNum1:nil];
	[self setTfPhoneNum2:nil];
	[self setTfPhoneNum3:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"ATM긴급출금등록"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"ATM긴급출금등록 정보입력" maxStep:3 focusStepNumber:1]autorelease]];
	
	[self.sbAccountNum setDelegate:self];
	[self.tfAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
	[self.tfInstantPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:6];
	[self.tfInstantPWConfirm showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:6];
	
	self.contentScrollView.contentSize = CGSizeMake(317, 452);
    contentViewHeight = contentViewHeight > 452 ? contentViewHeight : 452;
    
    startTextFieldTag = 444000;
    endTextFieldTag = 444006;
	
	self.marrAccounts = [self outAccountList];
    
    if ([self.marrAccounts count] > 0) {
        
        self.selectedData = [self.marrAccounts objectAtIndex:0];
        [self.sbAccountNum setText:[self.selectedData objectForKey:@"2"]];
    }
    
    [_atmInfoBtn.titleLabel setNumberOfLines:0];
    [_atmInfoBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - etc
- (void)initializeData
{
	self.marrAccounts = [self outAccountList];
    
    if ([self.marrAccounts count] > 0) {
        
        self.selectedData = [self.marrAccounts objectAtIndex:0];
        [self.sbAccountNum setText:[self.selectedData objectForKey:@"2"]];
    }
	
	[self.lblBalance setText:nil];
	[self.tfAccountPW setText:nil];
	[self.tfWithdrawAmount setText:nil];
	[self.lblAmountKor setText:nil];
	[self.tfInstantPW setText:nil];
	[self.tfInstantPWConfirm setText:nil];
	[self.tfPhoneNum1 setText:nil];
	[self.tfPhoneNum2 setText:nil];
	[self.tfPhoneNum3 setText:nil];
}

#pragma mark - Action

- (IBAction)atmInfoButtonPressed:(id)sender
{
    [sender setTag:1111];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/sbank/atm/atm_info.jsp", AppInfo.realServer ? URL_M : URL_M_TEST];
    
    SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc] initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil] autorelease];
    
    viewController.strUrl = strUrl;
    viewController.strName = @"ATM긴급출금등록";
    viewController.strBackButtonTitle = @"ATM긴급출금 유의사항";
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

- (IBAction)inquiryBalanceBtnAction:(UIButton *)sender {
	self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2004" viewController:self]autorelease];
	self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : self.sbAccountNum.text}] autorelease];
	[self.service start];
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
	NSString *strMsg = nil;
    
    if (_atmInfoBtn.tag != 1111) {
        
        strMsg = @"상단의\nATM 긴급출금 유의사항을\n읽고 확인을\n선택하시기 바랍니다.";
    }
    else if (!self.selectedData[@"2"] || [self.sbAccountNum.text length] == 0) {
        
        strMsg = @"출금계좌번호를 선택하여 주십시오.";
    }
	else if ([self.tfAccountPW.text length] != 4) {
		strMsg = @"계좌비밀번호를 입력하여 주십시오.";
	}
	else if (![self.tfWithdrawAmount.text length] || [self.tfWithdrawAmount.text hasPrefix:@"0"])
	{
		strMsg = @"출금금액을 0원 이상 30만원 미만으로 입력하여 주십시오.";
	}
	else if ([[self.tfWithdrawAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""]integerValue] % 10000 != 0)
	{
		strMsg = @"출금금액은 만원단위로 입력하여 주십시오.";
	}
	else if ([[self.tfWithdrawAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""]integerValue] > 300000)
	{
		strMsg = @"출금금액의 최대 가능금액은 30만원입니다.";
	}
	else if ([self.tfInstantPW.text length] != 6) {
		strMsg = @"1회용비밀번호를 입력하여 주십시오(6자리입력).";
	}
	else if ([self.tfInstantPWConfirm.text length] != 6) {
		strMsg = @"1회용비밀번호확인을 입력하여 주십시오(6자리입력).";
	}
	else if (![self.tfInstantPW.text isEqualToString:self.tfInstantPWConfirm.text]) {
		strMsg = @"1회용비밀번호와 1회용비밀번호확인이 일치하지 않습니다.";
	}
	else if (![self.tfPhoneNum1.text length] && ![self.tfPhoneNum2.text length] && ![self.tfPhoneNum3.text length]) {
		strMsg = @"휴대폰 번호를 입력하여 주십시오.";
	}
	else if ([self.tfPhoneNum1.text length] < 3) {
		strMsg = @"휴대폰번호 첫번째 입력칸은 3자리 이상 입력하여 주십시오.";
	}
	else if ([self.tfPhoneNum2.text length] < 3) {
		strMsg = @"휴대폰번호 두번째 입력칸은 3자리 이상 입력하여 주십시오.";
	}
	else if ([self.tfPhoneNum3.text length] < 4) {
		strMsg = @"휴대폰번호 세번째 입력칸은 4자리를 입력하여 주십시오.";
	}
	
	
	if (strMsg) {
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:strMsg];
		
		return;
	}
	
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"출금계좌비밀번호" : self.strEncryptedNum1,
						   @"출금계좌번호" : [SHBUtility nilToString:[self.selectedData objectForKey:@"2"]],
						   @"은행구분" : [SHBUtility nilToString:[self.selectedData objectForKey:@"은행구분"]],
						   @"납부금액" : self.tfWithdrawAmount.text,
						   }];
	self.service = [[[SHBBranchesService alloc]initWithServiceId:kC2090Id viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
    self.tfAccountPW.text = @"";
    self.tfInstantPW.text = @"";
    self.tfInstantPWConfirm.text = @"";
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopToRootViewController];
}

/// 계좌비밀번호
- (IBAction)closeNormalPad:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [self.tfAccountPW becomeFirstResponder];
}

/// 1회용비밀번호 
- (IBAction)closeNormalPad_1:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [self.tfInstantPW becomeFirstResponder];
}


/// 1회용비밀번호 확인
- (IBAction)closeNormalPad_2:(UIButton *)sender
{
    [super closeNormalPad:sender];
    [self.tfInstantPWConfirm becomeFirstResponder];
}

#pragma mark - SHBSelectBox Delegate
- (void)didSelectSelectBox:(SHBSelectBox *)selectBox
{
	[self.tfPhoneNum1 resignFirstResponder];
	[self.tfPhoneNum2 resignFirstResponder];
	[self.tfPhoneNum3 resignFirstResponder];
	[self.tfWithdrawAmount resignFirstResponder];
	
	[selectBox setState:SHBSelectBoxStateSelected];
	
	if (selectBox == self.sbAccountNum) {
		if ([self.marrAccounts count]) {
			SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"출금계좌"
																		   options:self.marrAccounts
																		   CellNib:@"SHBAccountListPopupCell"
																			 CellH:50
																	   CellDispCnt:5
																		CellOptCnt:2] autorelease];
			[popupView setDelegate:self];
			[popupView showInView:self.navigationController.view animated:YES];
		}
	}
}

#pragma mark - SHBListPopupView Delegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
	[self.sbAccountNum setState:SHBSelectBoxStateNormal];
	
	self.selectedData = [self.marrAccounts objectAtIndex:anIndex];
	
	[self.sbAccountNum setText:[self.selectedData objectForKey:@"2"]];
	
	[self.lblBalance setText:nil];
    
    [self.tfAccountPW setText:@""];
    self.strEncryptedNum1 = @"";
}

- (void)listPopupViewDidCancel
{
	[self.sbAccountNum setState:SHBSelectBoxStateNormal];
}

#pragma mark - SHBSecureTextField Delegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    Debug(@"EncriptedVaule: %@", value);
	
    
	if (textField == self.tfAccountPW) {
		self.strEncryptedNum1 = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
	}
	else if (textField == self.tfInstantPW) {
		self.strEncryptedNum2 = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
	}
	else if (textField == self.tfInstantPWConfirm) {
		self.strEncryptedNum3 = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
	}
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	Debug(@"range.length : %d\nrange.location : %d", range.length, range.location);
	
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	
	if (textField == self.tfWithdrawAmount) {
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 7)
        {
			return NO;
		}
		else
        {
			if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
            {
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
				return NO;
			}
            else
            {
				int nLen = [textField.text length];
				NSString *strStr = [textField.text substringToIndex:nLen - 1];
				textField.text = strStr;
                
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
				return NO;
			}
		}
	}
	
	else if (textField == self.tfPhoneNum1 || textField == self.tfPhoneNum2 || textField == self.tfPhoneNum3)
	{
		NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
		
		if (textField == self.tfPhoneNum1) {
			if ([textField.text length] >= 2 && range.length == 0) {
				if ([textString length] <= 3) {
                    [self.tfPhoneNum1 setText:textString];
                }
                
				[super didNextButtonTouch];
				
				return NO;
			}
		}
		else if (textField == self.tfPhoneNum2) {
			if ([textField.text length] >= 3 && range.length == 0) {
                if ([textString length] <= 4) {
                    [self.tfPhoneNum2 setText:textString];
                }
				
				[super didNextButtonTouch];
				
				return NO;
			}
		}
		else if (textField == self.tfPhoneNum3) {
			if ([textField.text length] >= 4 && range.length == 0) {
				return NO;
			}
		}
	}
//	else if (textField == self.tfPhoneNum1)
//	{
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
//		
//		if (dataLength + dataLength2 > 3)
//        {
//			return NO;
//		}
//	}
//	else if (textField == self.tfPhoneNum2 || textField == self.tfPhoneNum3)
//	{
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
//		
//		if (dataLength + dataLength2 > 4)
//        {
//			return NO;
//		}
//	}
	
	return YES;
}

- (void)textFieldDidBeginEditing:(SHBTextField *)textField
{
	[super textFieldDidBeginEditing:textField];
	
	if (textField == self.tfWithdrawAmount) {
		[self.lblAmountKor setText:nil];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[super textFieldDidEndEditing:textField];
	
	if (textField == self.tfWithdrawAmount) {
		[self.lblAmountKor setText:[NSString stringWithFormat:@"%@원", [SHBUtility changeNumberStringToKoreaAmountString:self.tfWithdrawAmount.text]]];
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

	if ([AppInfo.serviceCode isEqualToString:@"D2004"])
	{
		NSString *strBalance = [aDataSet objectForKey:@"지불가능잔액"];
		[self.lblBalance setText:[NSString stringWithFormat:@"출금가능잔액 %@원", strBalance]];
		
	}
	else if (self.service.serviceId == kC2090Id)
	{
		NSString *strPhoneNum = [NSString stringWithFormat:@"%@-%@-%@", self.tfPhoneNum1.text, self.tfPhoneNum2.text, self.tfPhoneNum3.text];
		NSDictionary *dicData = @{
        @"2" : [SHBUtility nilToString:[self.selectedData objectForKey:@"2"]],
        @"출금계좌번호" : [SHBUtility nilToString:[self.selectedData objectForKey:@"출금계좌번호"]],
		@"본인확인번호" : self.strEncryptedNum2,
		@"거래금액" : self.tfWithdrawAmount.text,
		@"SMS송신휴대폰번호" : strPhoneNum,
		@"거래금액출력용" : [aDataSet objectForKey:@"납부금액"],
		};
		
		SHBUrgencyInputConfirmViewController *viewController = [[[SHBUrgencyInputConfirmViewController alloc]initWithNibName:@"SHBUrgencyInputConfirmViewController" bundle:nil]autorelease];
		viewController.data = dicData;
		[self checkLoginBeforePushViewController:viewController animated:YES];
	}
	
	return NO;
}

@end
