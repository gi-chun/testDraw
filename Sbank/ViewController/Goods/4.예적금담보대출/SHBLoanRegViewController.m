//
//  SHBLoanRegViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

typedef enum
{
	ListPopupViewTagAccountNo = 100,	// 담보예금 계좌번호
	ListPopupViewTagDepositAccountNo,	// 입금계좌번호
	ListPopupViewTagLoanPurpose,		// 대출용도
}ListPopupViewTag;

#import "SHBLoanRegViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"
#import "SHBAskStaffViewController.h"
#import "SHBLoanInfoViewController.h"
#import "SHBUtility.h"
#import "SHBIdentity3ViewController.h"
#import "SHBLoanSecurityViewController.h"

@interface SHBLoanRegViewController ()<SHBIdentity3Delegate>
{
	CGFloat fCurrHeight;
	
	SHBTextField *currentTextField;
	
	NSInteger nSelectedIndex;	// 선택한 담보예금계좌번호
	NSInteger nSelectedIndex2;	// 선택한 입금계좌번호
    NSDictionary *L1311;
    
}

@property (nonatomic, retain) NSMutableArray *marrAccounts;		// 담보대출 계좌 리스트
@property (nonatomic, retain) NSMutableArray *marrDepositAccounts;	// 입금계좌번호 리스트
@property (nonatomic, retain) NSMutableArray *marrLoanPurposeList;	// 대출용도 리스트
@property (nonatomic, retain) NSString *strLoanPurposeCode;			// 선택된 대출용도 코드
@property (nonatomic, retain) NSString *strEncryptedPW;				// Encrypt된 담보예금 비밀번호 스트링
@property (nonatomic, retain) NSDictionary *nextViewData;
@end

@implementation SHBLoanRegViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_userItem release];
	[_strLoanPurposeCode release];
	[_marrLoanPurposeList release];
	[_strEncryptedPW release];
	[_marrDepositAccounts release];
	[_marrAccounts release];
    [_bottomView release];
	[_bodyView release];
	[_sbAccountNo release];
	[_tfAccountPW release];
	[_tfLimitQuery release];
	[_sbDepositAccountNo release];
	[_tfEmployeeNo release];
	[_sbLoanPurpose release];
	[_tfInputLoanPurpose release];
	[_tfLoanAmount release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBottomView:nil];
	[self setBodyView:nil];
	[self setSbAccountNo:nil];
	[self setTfAccountPW:nil];
	[self setTfLimitQuery:nil];
	[self setSbDepositAccountNo:nil];
	[self setTfEmployeeNo:nil];
	[self setSbLoanPurpose:nil];
	[self setTfInputLoanPurpose:nil];
	[self setTfLoanAmount:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예적금담보대출"];
    self.strBackButtonTitle = @"예적금담보대출 신청 4단계";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예적금담보대출 신청" maxStep:6 focusStepNumber:2]autorelease]];
	
	
	
    if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
    {
        [self.typelable setText:@"입금계좌번호"];
        self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00001_2 viewController:self]autorelease];
        [self.service start];
    }
    else
    {
        [self.typelable setText:@"한도대출설정계좌"];
        self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00001_5 viewController:self]autorelease];
        [self.service start];
    }
    
	[self.sbAccountNo setDelegate:self];
	[self.sbDepositAccountNo setDelegate:self];
	[self.sbLoanPurpose setDelegate:self];
	[self.tfEmployeeNo setAccDelegate:self];
	[self.tfInputLoanPurpose setAccDelegate:self];
	[self.tfLimitQuery setAccDelegate:self];
	[self.tfLoanAmount setAccDelegate:self];
	[self.tfAccountPW showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
	
	[self setPawnAccountListData];
	[self setDepositAccountListData];
	[self setLoanPurposeListData];
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

#pragma mark - UI
- (void)setLoanGuideView
{
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[self.contentScrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 5;
	
	NSMutableArray *marrGuides = [NSMutableArray array];
	for (int nIdx = 1; nIdx < 10; nIdx ++) {
		NSString *strKey = [NSString stringWithFormat:@"메시지%d", nIdx];
		NSString *strValue  = [self.data objectForKey:strKey];
		NSString *strValue1 = [strValue stringByReplacingOccurrencesOfString:@"▶" withString:@""];
		
		if ([strValue1 length] > 0) {
			[marrGuides addObject:strValue1];
		}
	}
	
	for (NSString *strGuide in marrGuides)
	{
		CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(284, 999) lineBreakMode:NSLineBreakByCharWrapping];
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(5, fHeight+4, 7, 7)];
		[ivInfoBox addSubview:ivBullet];
		
		UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5+7+3, fHeight, 284, size.height)]autorelease];
		[lblGuide setNumberOfLines:0];
		[lblGuide setBackgroundColor:[UIColor clearColor]];
		[lblGuide setTextColor:RGB(74, 74, 74)];
		[lblGuide setFont:[UIFont systemFontOfSize:13]];
		[lblGuide setText:strGuide];
		[ivInfoBox addSubview:lblGuide];
		
		if ([strGuide isEqualToString:@"예금담보대출은 상환 시 중도상환수수료가 없습니다."]) {
			[lblGuide setTextColor:RGB(209, 75, 75)];
		}
		
		fHeight += size.height + (strGuide == [marrGuides lastObject] ? 5 : 10);
	}
	
	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight += 6, 311, fHeight)];
	fCurrHeight += fHeight;
}

#pragma mark - etc.
- (void)closeKeyboard
{
	[self.tfAccountPW resignFirstResponder];
	[self.tfEmployeeNo resignFirstResponder];
	[self.tfInputLoanPurpose resignFirstResponder];
	[self.tfLimitQuery resignFirstResponder];
	[self.tfLoanAmount resignFirstResponder];
}

- (void)setPawnAccountListData	// 담보예금 계좌번호 데이터 세팅
{
	//NSMutableArray *marr = [AppInfo.userInfo arrayWithForKey:@"예금계좌"];
	NSMutableArray *marr = [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"];
    
    NSLog(@"오늘 날짜==%d",[[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue]);
	self.marrAccounts = [NSMutableArray array];
	for (NSMutableDictionary *dic in marr)
	{
        
		if ([[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 223 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] > 199 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 280 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 281 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 282 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 283 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 284 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 285 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 286 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 287 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 289 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 290 &&
            [[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] != 299 &&
            [[dic objectForKey:@"만기일자->originalValue"]integerValue]  > [[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue])
		{
            
            {
                [dic setObject:([[dic objectForKey:@"상품부기명"] length] > 0) ? [dic objectForKey:@"상품부기명"] : [dic objectForKey:@"과목명"] forKey:@"1"];
                [dic setObject:([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? [dic objectForKey:@"계좌번호"] : [dic objectForKey:@"구계좌번호"] forKey:@"2"];
                [dic setObject:[dic objectForKey:@"계좌번호"] forKey:@"계좌번호"];
                [self.marrAccounts addObject:dic];
            }
            
		}
	}
    
    NSLog(@"marrAccounts %d",[self.marrAccounts count]);
    
    //	NSString *str = [[self.marrAccounts objectAtIndex:0]objectForKey:@"2"];
    //	[self.sbAccountNo setText:str];
	[self.sbAccountNo setText:@"선택하세요."];
}

- (void)setDepositAccountListData	// 입금계좌번호 데이터 세팅
{
	//NSMutableArray *marr = [AppInfo.userInfo arrayWithForKey:@"예금계좌"];
    NSMutableArray *marr = [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"];
	
	self.marrDepositAccounts = [NSMutableArray array];
	for (NSMutableDictionary *dic in marr)
	{
		if ([[[dic objectForKey:@"계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] < 160
			&& [[dic objectForKey:@"인터넷뱅킹출금계좌여부"] isEqualToString:@"1"])
		{
			[dic setObject:([[dic objectForKey:@"상품부기명"] length] > 0) ? [dic objectForKey:@"상품부기명"] : [dic objectForKey:@"과목명"] forKey:@"1"];
			[dic setObject:([[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"]) ? [dic objectForKey:@"계좌번호"] : [dic objectForKey:@"구계좌번호"] forKey:@"2"];
			[dic setObject:[dic objectForKey:@"계좌번호"] forKey:@"계좌번호"];
			[self.marrDepositAccounts addObject:dic];
		}
	}
	
    //	NSString *str = [[self.marrDepositAccounts objectAtIndex:0]objectForKey:@"2"];
    //	[self.sbDepositAccountNo setText:str];
	[self.sbDepositAccountNo setText:@"선택하세요."];
}

- (void)setLoanPurposeListData		// 대출용도 데이터 세팅
{
	self.marrLoanPurposeList = [NSMutableArray array];
	[self.marrLoanPurposeList addObject:@{@"1" : @"주택구입(소유권 이전등기일로부터 3개월이 경과하지 않은 대출)", @"code" : @"11"}];
	[self.marrLoanPurposeList addObject:@{@"1" : @"주택구입(분양주택 중도금대출 및 재건축주택 이주비 대출)", @"code" : @"12"}];
	[self.marrLoanPurposeList addObject:@{@"1" : @"주택구입(소유권 이전등기후 3개월경과, 여타주택 구입자금 등)", @"code" : @"13"}];
    [self.marrLoanPurposeList addObject:@{@"1" : @"전세자금반환용", @"code" : @"21"}];
    [self.marrLoanPurposeList addObject:@{@"1" : @"주택임차(전월세)", @"code" : @"22"}];
    [self.marrLoanPurposeList addObject:@{@"1" : @"주택신축 및 개량", @"code" : @"23"}];
    [self.marrLoanPurposeList addObject:@{@"1" : @"생계자금", @"code" : @"24"}];
    [self.marrLoanPurposeList addObject:@{@"1" : @"내구소비재 구입자금", @"code" : @"25"}];
    [self.marrLoanPurposeList addObject:@{@"1" : @"학자금", @"code" : @"26"}];
    [self.marrLoanPurposeList addObject:@{@"1" : @"사업자금", @"code" : @"27"}];
    [self.marrLoanPurposeList addObject:@{@"1" : @"투자자금", @"code" : @"28"}];
    [self.marrLoanPurposeList addObject:@{@"1" : @"기차입금 상환자금", @"code" : @"31"}];
    [self.marrLoanPurposeList addObject:@{@"1" : @"공과금 및 세금납부", @"code" : @"41"}];
    [self.marrLoanPurposeList addObject:@{@"1" : @"기타(세부자금용도 직접입력)", @"code" : @"99"}];
	
    //	NSString *str = [[self.marrLoanPurposeList objectAtIndex:0]objectForKey:@"1"];
    //	[self.sbLoanPurpose setText:str];
    //	self.strLoanPurposeCode = [[self.marrLoanPurposeList objectAtIndex:0]objectForKey:@"code"];
	[self.sbLoanPurpose setText:@"선택하세요."];
}


#pragma mark - Action
- (IBAction)limitQueryBtnAction:(SHBButton *)sender {
	[self closeKeyboard];
	
	if (![self.sbAccountNo.text length] || [self.sbAccountNo.text isEqualToString:@"선택하세요."]) {
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"예금담보 가능계좌를 선택하여 주십시오."];
		return;
	}
	
   
	NSString *newAccountNo = [[self.marrAccounts objectAtIndex:nSelectedIndex]objectForKey:@"계좌번호"];
	
    
    AppInfo.commonDic = @{
                          @"_L1310" : @"한도조회",
                          };
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"고객번호" : AppInfo.customerNo,
						   @"업무구분" : @"60",
						   @"반복횟수" : @"1",
						   @"담보계좌번호" : newAccountNo,
						   }];
	self.service = [[[SHBProductService alloc]initWithServiceId:kL1310Id viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
}

- (IBAction)employeeBtnAction:(SHBButton *)sender {
	SHBAskStaffViewController *staffViewController = [[SHBAskStaffViewController alloc] initWithNibName:@"SHBAskStaffViewController" bundle:nil];
	[staffViewController executeWithTitle:@"권유직원 조회" ReturnViewController:self];
	[self.navigationController pushFadeViewController:staffViewController];
	[staffViewController release];
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
	NSString *strMsg = nil;
	
	if ([self.sbAccountNo.text isEqualToString:@"선택하세요."] || ![self.sbAccountNo.text length]) {
		strMsg = @"대출신청 계좌번호를 선택하여 주십시오.";
	}
	else if ([self.tfAccountPW.text length] != 4) {
		strMsg = @"대출신청계좌 비밀번호 4자리를 입력하여 주십시오.";
	}
	else if (![self.tfAccountPW.text length]) {
		strMsg = @"대출신청계좌 비밀번호 4자리를 입력하여 주십시오.";
	}
	else if (![self.tfLoanAmount.text length] || [self.tfLoanAmount.text longLongValue] == 0) {
		strMsg = @"대출신청금액을 입력하여 주십시오.";
	}
	else if ([[SHBUtility commaStringToNormalString:self.tfLoanAmount.text]longLongValue] % 100000 != 0) {
		strMsg = @"대출신청금액은 10만원 단위로 입력하여 주십시오.";
	}
	else if ([[SHBUtility commaStringToNormalString:self.tfLoanAmount.text]longLongValue] > 50000000) {
		strMsg = @"대출신청금액은 5,000만원을 초과할 수 없습니다.";
	}
	else if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"] &&
             [self.sbDepositAccountNo.text isEqualToString:@"선택하세요."] ||
             ![self.sbDepositAccountNo.text length]) {
		strMsg = @"입금계좌번호를 선택하여 주십시오.";
	}
    
    else if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"B"] &&
             [self.sbDepositAccountNo.text isEqualToString:@"선택하세요."] ||
             ![self.sbDepositAccountNo.text length]) {
		strMsg = @"한도대출설정 계좌를 선택하여 주십시오.";
	}
    
    
    else if ([self.tfEmployeeNo.text length] > 0 && [self.tfEmployeeNo.text length] != 8)
    {
        strMsg = @"직원번호는 8자리 숫자입니다. 확인 후 입력하시기 바랍니다.";
	}
	else if ([self.sbLoanPurpose.text isEqualToString:@"선택하세요."] || ![self.sbLoanPurpose.text length]) {
		strMsg = @"대출용도를 선택하여 주십시오.";
	}
	else if ([self.sbLoanPurpose.text isEqualToString:@"기타(세부자금용도 직접입력)"]) {
		if (![self.tfInputLoanPurpose.text length]) {
            strMsg = @"기타 선택 시, 대출용도를 직접입력하여 주십시오.";
        }
	}
	
	if (strMsg) {
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:strMsg];
		
		return;
	}
	
    _tfAccountPW.text = @"";
    
	self.service = [[[SHBProductService alloc]initWithServiceId:kC2092Id viewController:self]autorelease];
	self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
								@"출금계좌번호" : self.sbAccountNo.text,
								@"출금계좌비밀번호" : self.strEncryptedPW,
								}];
	[self.service start];
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBLoanInfoViewController class]]) {
			[self.navigationController popToViewController:viewController animated:YES];
		}
	}
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if (textField == self.tfLimitQuery)
	{
		return NO;
	}
	
	return YES;
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
	
	if (textField == self.tfLoanAmount) {	// 대출받으실금액
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
	else if (textField == self.tfEmployeeNo) {	// 권유직원번호
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 8)
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
	
	if (textField == self.tfAccountPW) {
		self.strEncryptedPW = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
	}
}

#pragma mark - SHBSelectBox Delegate
- (void)didSelectSelectBox:(SHBSelectBox *)selectBox
{
	[self closeKeyboard];
	[selectBox setState:SHBSelectBoxStateSelected];
	
	if (selectBox == self.sbAccountNo) {		// 담보예금 계좌번호
		
		if ([self.marrAccounts count] == 0) {
			[UIAlertView showAlert:self
							  type:ONFAlertTypeOneButton
							   tag:0
							 title:@""
						   message:@"대출신청 계좌가 없습니다."];
		}
		else {
			SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"담보 예금 계좌"
																		   options:self.marrAccounts
																		   CellNib:@"SHBAccountListPopupCell"
																			 CellH:50
																	   CellDispCnt:5
																		CellOptCnt:4] autorelease];
			[popupView setDelegate:self];
			[popupView setTag:ListPopupViewTagAccountNo];
			[popupView showInView:self.navigationController.view animated:YES];
			
		}
	}
	else if (selectBox == self.sbDepositAccountNo) {		// 입금계좌번호
		
		SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"입금 계좌 번호"
																	   options:self.marrDepositAccounts
																	   CellNib:@"SHBAccountListPopupCell"
																		 CellH:50
																   CellDispCnt:5
																	CellOptCnt:4] autorelease];
		[popupView setDelegate:self];
		[popupView setTag:ListPopupViewTagDepositAccountNo];
		[popupView showInView:self.navigationController.view animated:YES];
	}
	else if (selectBox == self.sbLoanPurpose) {		// 대출용도
		
		SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"대출 용도"
																	   options:self.marrLoanPurposeList
																	   CellNib:@"SHBExchangePopupCell"
																		 CellH:32
																   CellDispCnt:5
																	CellOptCnt:1] autorelease];
		[popupView setDelegate:self];
		[popupView setTag:ListPopupViewTagLoanPurpose];
		[popupView showInView:self.navigationController.view animated:YES];
	}
}

#pragma mark - SHBListPopupView Delegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
	if (listPopView.tag == ListPopupViewTagAccountNo) {		// 담보예금 계좌번호
        [self.sbAccountNo setState:SHBSelectBoxStateNormal];
		[self.sbAccountNo setText:[[self.marrAccounts objectAtIndex:anIndex]objectForKey:@"2"]];
		_tfAccountPW.text = @"";    //비밀번호
        [self.tfLimitQuery setText:@""];  //대출가능금액
        [_tfLoanAmount setText:@""];  //대출받으실 금액
		nSelectedIndex = anIndex;
	}
	else if (listPopView.tag == ListPopupViewTagDepositAccountNo) {		// 입금계좌번호
		[self.sbDepositAccountNo setState:SHBSelectBoxStateNormal];
		[self.sbDepositAccountNo setText:[[self.marrDepositAccounts objectAtIndex:anIndex]objectForKey:@"2"]];
		
		nSelectedIndex2 = anIndex;
	}
	else if (listPopView.tag == ListPopupViewTagLoanPurpose) {		// 대출용도
		[self.sbLoanPurpose setState:SHBSelectBoxStateNormal];
		[self.sbLoanPurpose setText:[[self.marrLoanPurposeList objectAtIndex:anIndex]objectForKey:@"1"]];
		self.strLoanPurposeCode = [[self.marrLoanPurposeList objectAtIndex:anIndex]objectForKey:@"code"];
        
		if (anIndex == [self.marrLoanPurposeList indexOfObject:[self.marrLoanPurposeList lastObject]]) {
			[self.tfInputLoanPurpose setEnabled:YES];
		}
		else
		{
			[self.tfInputLoanPurpose setEnabled:NO];
			[self.tfInputLoanPurpose setText:nil];
		}
	}
}

- (void)listPopupViewDidCancel
{
	[self.sbAccountNo setState:SHBSelectBoxStateNormal];
	[self.sbDepositAccountNo setState:SHBSelectBoxStateNormal];
	[self.sbLoanPurpose setState:SHBSelectBoxStateNormal];
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
	if (self.service.serviceId == XDA_S00001_2)
	{
		/**	구분 = 1
		 등록일시 = 20121016092108;
		 금액3 = ;
		 구분 = 1;
		 메시지6 = ;
		 메시지2 = - 생계형은 가입대상 (만60세 이상 또는 장애인 및 국가유공자 - 장애인 및 국가유공자는 영업점에서  대상등록 필요) 에 대해 세금우대한도 외 3천만원까지 가입 가능합니다.;
		 메시지10 = ;
		 금액1 = ;
		 메시지9 = ;
		 메시지5 = ;
		 메시지1 = - 세금우대를 적용 받으려면 1년 이상 예치해야 하며, 전 금융기관에 세금우대 적용된 금액을 합하여 1인당 원금기준 1천만원 (장애인 또는 만60세 이상은 3천만원)까지 가입 가능합니다.;
		 금액4 = ;
		 수정일시 = ;
		 메시지8 = ;
		 메시지4 = ;
		 금액2 = ;
		 메시지7 = ;
		 메시지3 = - 2009.1.1일 개정된 조세특례제한법 기준;
		 */
		/**	구분 = 2
		 {
		 구분 = 2;
		 메시지1 = {
		 등록일시 = 20121016092226;
		 금액3 = ;
		 메시지6 = ▶만기일을 짧게 설정한 후 연장을 원하시는 경우 매번 연장등록을 해야하는 번거로움이 있으니 유의하시기 바랍니다.;
		 메시지2 = ▶1개월이 경과되지 않은 입금계좌는 대출취급이 불가능합니다.;
		 메시지10 = ;
		 금액1 = ;
		 메시지9 = ;
		 메시지5 = ▶예금담보대출은 상환 시 중도상환수수료가 없습니다.;
		 금액4 = ;
		 수정일시 = ;
		 메시지8 = ;
		 메시지4 = ▶대출/예,적금 만기시 담보예금에 대하여 5건 이하의 대출을 받은 경우에 한하여 상계처리 가능합니다.;
		 금액2 = ;
		 메시지7 = ;
		 메시지3 = ▶인터넷뱅킹 신규가입일로부터 4영업일이 경과하여야만 이용하실 수 있습니다.;
		 }
		 ;
		 }
		 */
		/**	구분 = 3
		 등록일시 = 20121016092410;
		 금액3 = ;
		 구분 = 3;
		 메시지6 = 재형저축 자금대출중 소액자금 대출은 3개월 이상, 적립신탁대출은 4개월 이상, 월적립금의 납입이 지체된 경우 대출기간 만료일 이전이더라도 통지에 의해서 관련 예금과 대출금을 상계할 수 있기로 합니다.;
		 메시지2 = 1년을 365일로 보고 1일 단위로 계산합니다.;
		 메시지10 = ;
		 금액1 = 40000;
		 메시지9 = ;
		 메시지5 = 최초이자는 대출개시일로부터 1개월이내에, 그 후의 이자는 지급한 이자의 계산최종일 익일부터 1개월 이내에 지급합니다.;
		 메시지1 = 변동(은행여신거래기본약관 제3조 제2항 제2호 선택);
		 금액4 = ;
		 수정일시 = ;
		 메시지8 = ;
		 메시지4 = 대출기간 만료일에 전액 상환합니다.;
		 금액2 = ;
		 메시지7 = ;
		 메시지3 = 대출개시일에 전액 실행합니다.;
		 */
		/**	구분 = 4
		 등록일시 = 20121016092536;
		 금액3 = ;
		 구분 = 4;
		 메시지6 = ;
		 메시지2 = ▶대출/예,적금 만기시 담보예금에 대하여 5건 이하의 대출을 받은 경우에 한하여 상계처리 가능합니다.;
		 메시지10 = ;
		 금액1 = ;
		 메시지9 = ;
		 메시지5 = ;
		 메시지1 = ▶담보계좌가 청약예금인 경우 만기시에 예금이 자동 재예치되더라도 대출만기일은 자동 연장되지 않습니다.;
		 금액4 = ;
		 수정일시 = ;
		 메시지8 = ;
		 메시지4 = ▶은행영업시간 마감이후 자동화기기 또는 전자금융매체를 통한 계좌입금분은 당일 중 상환으로 처리되지 않을 수 있습니다.;
		 금액2 = ;
		 메시지7 = ;
		 메시지3 = ▶담보예금에 대하여 &quot;잔액증명서&quot;를 발급받은 당일에는 대출금과 담보예금을 인터넷상에서 상계처리 하실 수 없으며, 영업점을 방문하여 처리하시기 바랍니다.;
		 */
		/**	D3606
		 COMBLOCK->reference = COMMON;
		 담보대출_안내1 = {
		 담보대출_안내6 = ▶만기일을 짧게 설정한 후 연장을 원하시는 경우 매번 연장등록을 해야하는 번거로움이 있으니 유의하시기 바랍니다.;
		 담보대출_안내5 = ▶예금담보대출은 상환 시 중도상환수수료가 없습니다.;
		 담보대출_안내9 = ;
		 담보대출_안내4 = ▶대출/예,적금 만기시 담보예금에 대하여 5건 이하의 대출을 받은 경우에 한하여 상계처리 가능합니다.;
		 담보대출_안내8 = ;
		 담보대출_안내3 = ▶인터넷뱅킹 신규가입일로부터 4영업일이 경과하여야만 이용하실 수 있습니다.;
		 담보대출_안내7 = ;
		 담보대출_안내10 = ;
		 담보대출_안내2 = ▶1개월이 경과되지 않은 입금계좌는 대출취급이 불가능합니다.;
		 */
		
		self.data = aDataSet;
		Debug(@"self.data : %@", self.data);
        //		self.data = [aDataSet objectForKey:@"메시지1"];
        //		Debug(@"self.data : %@", self.data);
        
		[self setLoanGuideView];
		FrameReposition(self.bodyView, left(self.bodyView), fCurrHeight);
		[self.bodyView setHidden:NO];
		[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fCurrHeight+=450)];
		[self.contentScrollView flashScrollIndicators];
		
		contentViewHeight = contentViewHeight > fCurrHeight ? contentViewHeight : fCurrHeight;
		
		startTextFieldTag = 222000;
		endTextFieldTag = 222003;
	}
    
    else if (self.service.serviceId == XDA_S00001_5)
	{
        self.data = aDataSet;
		Debug(@"self.data : %@", self.data);
        
		[self setLoanGuideView];
		FrameReposition(self.bodyView, left(self.bodyView), fCurrHeight);
		[self.bodyView setHidden:NO];
		[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fCurrHeight+=450)];
		[self.contentScrollView flashScrollIndicators];
		
		contentViewHeight = contentViewHeight > fCurrHeight ? contentViewHeight : fCurrHeight;
		
		startTextFieldTag = 222000;
		endTextFieldTag = 222003;
    }
	
	else if (self.service.serviceId == kC2092Id)
	{
		self.userItem = [NSMutableDictionary dictionary];
		[self.userItem setObject:self.strLoanPurposeCode forKey:@"금감원자금용도코드"];
		[self.userItem setObject:self.sbLoanPurpose.text forKey:@"대출용도출력용"];
		if ([self.tfInputLoanPurpose.text length]) {
			[self.userItem setObject:self.tfInputLoanPurpose.text forKey:@"금감원자금용도기타내용"];
		}
		
		NSString *str = nil;
		//NSMutableArray *marr = [AppInfo.userInfo arrayWithForKey:@"예금계좌"];
        NSMutableArray *marr = [AppInfo.accountD0011 arrayWithForKey:@"예금계좌"];
		for (NSDictionary *dic in marr)
		{
			if ([[dic objectForKey:@"계좌번호"]isEqualToString:self.sbAccountNo.text]) {
				str = @"1";
				
				if ([[dic objectForKey:@"상품부기명"]length]) {
					[self.userItem setObject:[dic objectForKey:@"상품부기명"] forKey:@"상품명"];
				}
				else
				{
					[self.userItem setObject:[dic objectForKey:@"과목명"] forKey:@"상품명"];
				}
				
				break;
			}
			else if ([[dic objectForKey:@"구계좌번호"]isEqualToString:self.sbAccountNo.text]) {
				str = [dic objectForKey:@"은행코드"];
				
				if ([[dic objectForKey:@"상품부기명"]length]) {
					[self.userItem setObject:[dic objectForKey:@"상품부기명"] forKey:@"상품명"];
				}
				else
				{
					[self.userItem setObject:[dic objectForKey:@"과목명"] forKey:@"상품명"];
				}
				
				break;
			}
		}
		
		[self.userItem setObject:@"1" forKey:@"담보계좌은행코드"];
        //		[self.userItem setObject:self.sbAccountNo.text forKey:@"담보계좌번호"];
		[self.userItem setObject:str forKey:@"담보계좌은행코드출력용"];
		[self.userItem setObject:self.sbAccountNo.text forKey:@"담보계좌번호출력용"];
		[self.userItem setObject:self.strEncryptedPW forKey:@"담보계좌비밀번호"];
		[self.userItem setObject:self.tfLoanAmount.text forKey:@"대출신청금액"];
		
		// 해당계좌의 신계좌번호로 셋팅해야 에러가 안남.
		NSString *newAccountNo = [[self.marrAccounts objectAtIndex:nSelectedIndex]objectForKey:@"계좌번호"];
		[self.userItem setObject:newAccountNo forKey:@"담보계좌번호"];
		Debug(@"newAccountNo : %@", newAccountNo);
		Debug(@"self.sbAccountNo.text : %@", self.sbAccountNo.text);
		// L1311
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   @"고객번호" : AppInfo.customerNo,
							   @"담보계좌번호" : /*self.sbAccountNo.text*/newAccountNo,
							   @"담보계좌은행구분" : str,
							   @"담보계좌비밀번호" : self.strEncryptedPW,
							   @"대출신청금액" : self.tfLoanAmount.text,
							   @"업무구분" : @"51",
                               //							   @"입금계좌번호" : self.sbDepositAccountNo.text,
							   @"입금계좌은행구분" : @"1",
							   }];
		
		NSString *str1 = nil;
		if ([self.tfEmployeeNo.text length]) {
			str1 = self.tfEmployeeNo.text;
			[self.userItem setObject:str1 forKey:@"권유자"];
			
			[dataSet insertObject:str1 forKey:@"권유자" atIndex:0];
		}
		
        
//		NSString *str2 = @"";
//		for (NSDictionary *dic in marr)
//		{
//			if ([[dic objectForKey:@"계좌번호"] isEqualToString:[self.sbDepositAccountNo.text stringByReplacingOccurrencesOfString:@"." withString:@""]])
//            {
//				str2 = @"1";
//				
//				break;
//			}
//			else if ([[dic objectForKey:@"구계좌번호"]isEqualToString:[self.sbDepositAccountNo.text stringByReplacingOccurrencesOfString:@"." withString:@""]]) {
//				str2 = [dic objectForKey:@"은행코드"];
//				
//				break;
//			}
//		}
        //		str2 = @"1";
		
		// 해당계좌의 신계좌번호로 셋팅해야 에러가 안남.
		newAccountNo = [[self.marrDepositAccounts objectAtIndex:nSelectedIndex2]objectForKey:@"계좌번호"];
		[dataSet insertObject:newAccountNo forKey:@"입금계좌번호" atIndex:0];
		[self.userItem setObject:newAccountNo forKey:@"입금계좌번호"];
		[self.userItem setObject:@"1" forKey:@"입금계좌은행코드"];
		[self.userItem setObject:self.sbDepositAccountNo.text forKey:@"입금계좌번호출력용"];
		//[self.userItem setObject:str2 forKey:@"입금계좌은행코드출력용"];
		[self.userItem setObject:self.tfLoanAmount.text forKey:@"실행금액"];
		[self.userItem setObject:aDataSet[@"COM_JUMIN_NO"] forKey:@"실명번호"];
        
        
        
        if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
        {
            self.service = [[[SHBProductService alloc]initWithServiceId:kL1311Id viewController:self]autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        }
        else
        {
            AppInfo.commonDic = @{
                                  @"_L1310" : @"한도대출",
                                  };
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                         @"고객번호" : AppInfo.customerNo,
                                                                         @"업무구분" : @"60",
                                                                         @"반복횟수" : @"1",
                                                                         @"담보계좌번호" : self.sbAccountNo.text,
                                                                         }];
            self.service = [[[SHBProductService alloc]initWithServiceId:kL1310Id viewController:self]autorelease];
            self.service.requestData = dataSet;
            [self.service start];
            
        }
        

        
        
	}
    
    else if (self.service.serviceId == kL1310Id)	// 담보대출 한도조회
	{
        
		self.nextViewData = [NSDictionary dictionary];
        self.nextViewData =aDataSet;
        
        if ([AppInfo.commonDic[@"_L1310"] isEqualToString:@"한도조회"])
        {
            NSString *str = [aDataSet objectForKey:@"대출가능금액"];
            [self.tfLimitQuery setText:str];
            
        }
        
        else
        {
            SHBIdentity3ViewController *viewController = [[SHBIdentity3ViewController alloc]initWithNibName:@"SHBIdentity3ViewController" bundle:nil];
        
            [viewController setServiceSeq:SERVICE_LOAN];
            viewController.needsLogin = YES;
            viewController.delegate = self;
            //if ([[SHBUtility commaStringToNormalString:self.tfLoanAmount.text]longLongValue] > 1000001)
            if ([[SHBUtility commaStringToNormalString:self.tfLoanAmount.text]longLongValue] > 1000000) //100만원보다 크면 Ars
            {
                viewController.is100Over = YES;
            }
            else
            {
                viewController.is100Over = NO;
            }
            [self checkLoginBeforePushViewController:viewController animated:YES];
        
            if ([self.Loantype isEqualToString:@"A"])
            {
                AppInfo.commonLoanDic = @{
                                      @"_대출타입" : @"A",
                                      
                                      };
            }
            else{
                AppInfo.commonLoanDic = @{
                                      @"_대출타입" : @"B",
                                      };
        }
        
        // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
        [viewController executeWithTitle:@"예적금담보대출" Step:2 StepCnt:6 NextControllerName:nil];
        [viewController subTitle:@"추가인증 방법 선택"];
        [viewController release];
        }
            
	}
    
	else if (self.service.serviceId == kL1311Id)
	{
        SHBIdentity3ViewController *viewController = [[SHBIdentity3ViewController alloc]initWithNibName:@"SHBIdentity3ViewController" bundle:nil];
        
        [viewController setServiceSeq:SERVICE_LOAN];
        viewController.needsLogin = YES;
        viewController.delegate = self;
        //if ([[SHBUtility commaStringToNormalString:self.tfLoanAmount.text]longLongValue] > 1000001)
        if ([[SHBUtility commaStringToNormalString:self.tfLoanAmount.text]longLongValue] > 1000000) //100만원보다 크면
        {
            viewController.is100Over = YES;
        }
        else
        {
            viewController.is100Over = NO;
        }
        [self checkLoginBeforePushViewController:viewController animated:YES];
        

        
        // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
        [viewController executeWithTitle:@"예적금담보대출" Step:3 StepCnt:6 NextControllerName:nil];
        [viewController subTitle:@"추가인증 방법 선택"];
        [viewController release];

       
	}
	
	return NO;
}
#pragma mark - Ask Staff
- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic{
	[super viewControllerDidSelectDataWithDic:mDic];
	
	Debug(@"mDic : %@", mDic);
	if (mDic){
		[self.tfEmployeeNo setText:[mDic objectForKey:@"행번"]];
	}
    else
    {
        if (self.service.serviceId == kL1310Id)	// 담보대출 한도조회
        {

            SHBLoanSecurityViewController *viewController = [[SHBLoanSecurityViewController   alloc]initWithNibName:@"SHBLoanSecurityViewController" bundle:nil];   // 한도대출 1단계
           viewController.L1311 = self.nextViewData;
           viewController.userItem = self.userItem;
           viewController.needsLogin  = YES;
           
           [self checkLoginBeforePushViewController:viewController animated:YES];
           [viewController release];
           
           [self.tfAccountPW setText:nil];

        }
        else if (self.service.serviceId == kL1311Id)
        {
            SHBLoanSecurityViewController *viewController = [[SHBLoanSecurityViewController alloc]initWithNibName:@"SHBLoanSecurityViewController" bundle:nil];
            viewController.L1311 = self.nextViewData;
            viewController.userItem = self.userItem;
            viewController.needsLogin  = YES;
           
            [self checkLoginBeforePushViewController:viewController animated:YES];
            [viewController release];
            
            [self.tfAccountPW setText:nil];
        }
    }
}


@end
