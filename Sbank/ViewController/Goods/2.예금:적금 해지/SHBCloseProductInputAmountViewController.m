//
//  SHBCloseProductInputAmountViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCloseProductInputAmountViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBCloseProductInfoViewController.h"
#import "SHBCloseProductConfirmViewController.h"
#import "SHBUtility.h"
#import "SHBProductService.h"

@interface SHBCloseProductInputAmountViewController ()

@end

@implementation SHBCloseProductInputAmountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_D3280 release];
	[_lblProductName release];
	[_lblAccountNumber release];
	[_lblBalance release];
	[_lblNewDate release];
	[_lblExpirationDate release];
	[_tfCloseAmount release];
	[_btnAllClose release];
	[_btnPartClose release];
	[_lblPartCloseCount release];
    [_ivInfoBox release];
	[_bottomView release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setLblProductName:nil];
	[self setLblAccountNumber:nil];
	[self setLblBalance:nil];
	[self setLblNewDate:nil];
	[self setLblExpirationDate:nil];
	[self setTfCloseAmount:nil];
	[self setBtnAllClose:nil];
	[self setBtnPartClose:nil];
	[self setLblPartCloseCount:nil];
    [self setIvInfoBox:nil];
	[self setBottomView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예금/적금 해지"];
    
    self.strBackButtonTitle = @"예금적금 해지 1단계";
	
    [self.view setBackgroundColor:RGB(244, 239, 233)];
	
	NSString *strName = [[self.D3280 objectForKey:@"상품부기명"]length] ? [self.D3280 objectForKey:@"상품부기명"] : [self.D3280 objectForKey:@"상품명"];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:strName maxStep:6 focusStepNumber:1]autorelease]];
	
	[self.lblProductName setText:strName];
	[self.lblAccountNumber setText:[self.D3280 objectForKey:@"신계좌번호"]];
	[self.lblBalance setText:[NSString stringWithFormat:@"%@원", [self.D3280 objectForKey:@"계좌잔액"]]];
	[self.lblNewDate setText:[self.D3280 objectForKey:@"신규일자"]];
	[self.lblExpirationDate setText:[self.D3280 objectForKey:@"만기일자"]];
	[self.lblPartCloseCount setText:[self.D3280 objectForKey:@"일부해지건수"]];
	
    [self.btnAllClose setSelected:YES];
	[self.btnPartClose setSelected:NO];
    
    [self.tfCloseAmount setAccDelegate:self];
	[self.tfCloseAmount setEnabled:NO];
    

    [self.tfCloseAmount setPlaceholder:@"일부해지(원금기준)"];
	
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	[self.ivInfoBox setImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]];
	
	CGFloat fGuideHeight = 5;
	
	NSMutableArray *marrGuides = [NSMutableArray array];
	[marrGuides addObject:@"만기해지 포함하여 3회 이내에서 일부해지가 가능하며, 일부해지 후 예금잔액은 최저가입금액 이상이어야 합니다. (만기일 이후 중도해지 불가)"];
	[marrGuides addObject:@"만기일 이전 일부해지한 금액에 대해서는 중도해지 금리를 적용합니다."];
	[marrGuides addObject:@"세금우대계좌를 일부해지 할 경우, 일부해지한 금액에 대해서는 일반과세 됩니다."];
	
	for (NSString *strGuide in marrGuides)
	{
		CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(284, 999) lineBreakMode:NSLineBreakByCharWrapping];
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(5, fGuideHeight+4, 7, 7)];
		[self.ivInfoBox addSubview:ivBullet];
		
		UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5+7+3, fGuideHeight, 284, size.height)]autorelease];
		[lblGuide setNumberOfLines:0];
		[lblGuide setBackgroundColor:[UIColor clearColor]];
		[lblGuide setTextColor:RGB(74, 74, 74)];
		[lblGuide setFont:[UIFont systemFontOfSize:13]];
		[lblGuide setText:strGuide];
		[self.ivInfoBox addSubview:lblGuide];
		
		fGuideHeight += size.height + (strGuide == [marrGuides lastObject] ? 5 : 10);
	}
	FrameResize(self.ivInfoBox, width(self.ivInfoBox), fGuideHeight);
	
//	NSString *strGuide = @"만기해지 포함하여 3회 이내에서 일부해지가 가능하며, 일부해지 후 예금잔액은 최저가입금액 이상이어야 합니다. (만기일 이후 중도해지 불가)\n\n만기일 이전 일부해지한 금액에 대해서는 중도해지 금리를 적용합니다.\n\n세금우대계좌를 일부해지 할 경우, 일부해지한 금액에 대해서는 일반과세 됩니다.";
//	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(304, 999) lineBreakMode:NSLineBreakByWordWrapping];
//	
//	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5, 10, 304, size.height)]autorelease];
//	[lblGuide setNumberOfLines:0];
//	[lblGuide setBackgroundColor:[UIColor clearColor]];
//	[lblGuide setTextColor:RGB(114, 114, 114)];
//	[lblGuide setFont:[UIFont systemFontOfSize:12]];
//	[lblGuide setText:strGuide];
//	[self.ivInfoBox addSubview:lblGuide];
//	FrameResize(self.ivInfoBox, width(self.ivInfoBox), 10+size.height+10);
	
	CGFloat fHeight = top(self.ivInfoBox)+fGuideHeight;
	FrameReposition(self.bottomView, left(self.bottomView), fHeight+=12);
	
	[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fHeight+=29+12)];
	
	contentViewHeight = contentViewHeight > fHeight ? contentViewHeight : fHeight;
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222000;
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

#pragma mark - Action
- (IBAction)closeTypeRadioBtnAction:(UIButton *)sender {
	
	if (sender == self.btnAllClose) {
		[self.tfCloseAmount setEnabled:NO];
		[self.tfCloseAmount setText:nil];
       [self.tfCloseAmount setPlaceholder:@"일부해지(원금기준)"];
        
        [self.btnAllClose setSelected:YES];
        [self.btnPartClose setSelected:NO];
	}
	else
	{
		[self.tfCloseAmount setEnabled:YES];
        [self.tfCloseAmount setPlaceholder:@"일부해지(원금기준)"];
        
        [self.btnAllClose setSelected:NO];
        [self.btnPartClose setSelected:YES];
        
	}
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
	if ([self.btnAllClose isSelected]) {	// 전액해지
		SHBCloseProductConfirmViewController *viewController = [[SHBCloseProductConfirmViewController alloc]initWithNibName:@"SHBCloseProductConfirmViewController" bundle:nil];
		viewController.nMaxStep = 6;
		viewController.nFocusStep = 2;
		viewController.D3280 = self.D3280;
		viewController.nServiceCode = kD3281Id;
		viewController.needsLogin = YES;
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
	}
	else if ([self.btnPartClose isSelected]) {	// 일부해지
		NSString *strMsg = nil;
		
		if (![self.tfCloseAmount.text length] || [self.tfCloseAmount.text isEqualToString:@"0"]) {
			strMsg = @"일부해지금액을 입력해 주세요.";
		}
		else if ([[SHBUtility commaStringToNormalString:self.tfCloseAmount.text]intValue] >= [[SHBUtility commaStringToNormalString:[self.D3280 objectForKey:@"계좌잔액"]]intValue])
		{
			strMsg = @"일부해지금액이 계좌잔액과 동일 또는 초과 하였습니다.";
		}
		
		if (strMsg) {
			[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:strMsg];
			
			return;
		}
		
		SHBCloseProductConfirmViewController *viewController = [[SHBCloseProductConfirmViewController alloc]initWithNibName:@"SHBCloseProductConfirmViewController" bundle:nil];
		viewController.nMaxStep = 6;
		viewController.nFocusStep = 2;
		viewController.D3280 = self.D3280;
		viewController.nServiceCode = kD3285Id;
		viewController.strPartCloseAmount = self.tfCloseAmount.text;
		viewController.needsLogin = YES;
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
	}
	else
	{
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"해지구분을 선택하세요."];
	}
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBCloseProductInfoViewController class]]) {
			[self.navigationController popToViewController:viewController animated:YES];
		}
	}

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
	
	if (textField == self.tfCloseAmount) {	// 세금우대신청금액
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 14)
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
	
	return YES;
}

@end
