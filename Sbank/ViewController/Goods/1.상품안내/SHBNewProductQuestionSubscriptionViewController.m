//
//  SHBNewProductQuestionSubscriptionViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNewProductQuestionSubscriptionViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductListViewController.h"
#import "SHBNewProductRegViewController.h"
#import "SHBSearchZipViewController.h"

@interface SHBNewProductQuestionSubscriptionViewController ()
{
	SHBTextField *currentTextField;
	
	// 사용자 선택 인덱스들
	NSInteger nHopeHouseTypeIndex;
	NSInteger nHopeHouseSizeIndex;
	NSInteger nJobIndex;
	NSInteger nLivingSortIndex;
	NSInteger nLivingTypeIndex;
}

@property (nonatomic, retain) NSMutableArray *marrHopeHouseTypes;	// 희망주택형 리스트
@property (nonatomic, retain) NSMutableArray *marrHopeHouseSizes;	// 희망주택면적 리스트
//@property (nonatomic, retain) NSMutableArray *marrJobs;				// 직업 리스트
//@property (nonatomic, retain) NSMutableArray *marrLivingSorts;		// 주거구분 리스트
//@property (nonatomic, retain) NSMutableArray *marrLivingTypes;		// 주거종류 리스트
@property (nonatomic, retain) NSString *strHopeTime;				// 희망입주시기

@end

@implementation SHBNewProductQuestionSubscriptionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_mdicPushInfo release];
//	[_marrJobs release];
//	[_marrLivingSorts release];
//	[_marrLivingTypes release];
	[_marrHopeHouseSizes release];
	[_marrHopeHouseTypes release];
	[_dicSelectedData release];
	[_userItem release];
    [_tfZipCodeLeft release];
    [_tfZipCodeRight release];
	//[_btnMarried release];
	//[_btnSingle release];
	[_mfHopeTime release];
	[_sbHopeHouseType release];
	[_sbHopeHouseSize release];
	//[_sbJob release];
	//[_sbLivingSort release];
	//[_sbLivingType release];
	[_ivInfoBox release];
	[super dealloc];
}
- (void)viewDidUnload {
    [self setTfZipCodeLeft:nil];
    [self setTfZipCodeRight:nil];
	//[self setBtnMarried:nil];
	//[self setBtnSingle:nil];
	[self setMfHopeTime:nil];
	[self setSbHopeHouseType:nil];
	[self setSbHopeHouseSize:nil];
	//[self setSbJob:nil];
	//[self setSbLivingSort:nil];
	//[self setSbLivingType:nil];
	[self setIvInfoBox:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예금/적금 가입"];
    self.strBackButtonTitle = @"예금적금 가입 2단계";
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), 570)];
	
	[self.sbHopeHouseSize setDelegate:self];
	[self.sbHopeHouseType setDelegate:self];
	//[self.sbJob setDelegate:self];
	//[self.sbLivingSort setDelegate:self];
	//[self.sbLivingType setDelegate:self];
	
	[self.sbHopeHouseSize setText:@"선택하세요."];
	[self.sbHopeHouseType setText:@"선택하세요."];
//	[self.sbJob setText:@"선택하세요."];
//	[self.sbLivingSort setText:@"선택하세요."];
//	[self.sbLivingType setText:@"선택하세요."];
	
	[self.tfZipCodeLeft setAccDelegate:self];
	[self.tfZipCodeRight setAccDelegate:self];
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
	
	Debug(@"AppInfo.tran_Date : %@", AppInfo.tran_Date);
	NSDate *currentDate = [dateFormatter dateFromString:AppInfo.tran_Date];
	
	[dateFormatter setDateFormat:@"yyyyMM"];
	self.strHopeTime = [dateFormatter stringFromDate:currentDate];
    

    
//    [self.mfHopeTime initWithFrame:self.mfHopeTime.frame];
	[self.mfHopeTime initFrame:self.mfHopeTime.frame];
    [self.mfHopeTime.textField setFont:[UIFont systemFontOfSize:15]];
    [self.mfHopeTime.textField setTextColor:RGB(44, 44, 44)];
    [self.mfHopeTime.textField setTextAlignment:UITextAlignmentCenter];
    [self.mfHopeTime setDelegate:self];
  //  [self.mfHopeTime selectDate:currentDate animated:NO];
    [self.mfHopeTime enableAccButtons:NO Next:NO];
	[self.mfHopeTime setMaximumYear:2099];

	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[self.dicSelectedData objectForKey:@"상품명"] maxStep:6 focusStepNumber:2]autorelease]];
	
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	[self.ivInfoBox setImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]];
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

#pragma mark - Etc.
- (void)closeKeyboard
{
	[self.tfZipCodeLeft resignFirstResponder];
	[self.tfZipCodeRight resignFirstResponder];
}

#pragma mark - 우편번호
- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic
{
	[self.tfZipCodeLeft setText:mDic[@"POST1"]];
	[self.tfZipCodeRight setText:mDic[@"POST2"]];
}

#pragma mark - Action
- (IBAction)zipCodeSearchAction:(SHBButton *)sender {
	// TODO: 우편번호 검색화면
	SHBSearchZipViewController *viewController = [[[SHBSearchZipViewController alloc]initWithNibName:@"SHBSearchZipViewController" bundle:nil]autorelease];
	[viewController executeWithTitle:@"예금/적금 가입" ReturnViewController:self];
	[self.navigationController pushFadeViewController:viewController];
	
	// TODO: 죽는데..
}

//- (IBAction)maritalStatusRadioBtnAction:(UIButton *)sender {
//	[self.btnMarried setSelected:NO];
//	[self.btnSingle setSelected:NO];
//	[sender setSelected:YES];
//}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
	NSString *strMsg = nil;
	
	NSString *strDate = AppInfo.tran_Date;
	NSInteger nYear = [[strDate substringWithRange:NSMakeRange(0, 4)]integerValue];
	NSInteger nMonth = [[strDate substringWithRange:NSMakeRange(5, 2)]integerValue];
	NSInteger nSelectedYear = [[self.strHopeTime substringWithRange:NSMakeRange(0, 4)]integerValue];
	NSInteger nSelectedMonth = [[self.strHopeTime substringWithRange:NSMakeRange(4, 2)]integerValue];
	
	if (![self.tfZipCodeLeft.text length]) {
		strMsg = @"희망입주지역을 선택하세요.";
	}
	else if ([self.sbHopeHouseType.text isEqualToString:@"선택하세요."]) {
		strMsg = @"희망주택형을 선택하세요.";
	}
	else if ([self.sbHopeHouseSize.text isEqualToString:@"선택하세요."]) {
		strMsg = @"희망주택면적을 선택하세요.";
	}
	else if (![self.strHopeTime length]) {
		strMsg = @"희망입주 년도를 입력하세요.";
	}
	else if (nSelectedYear < nYear || (nSelectedYear == nYear && nSelectedMonth <= nMonth)) {
		strMsg = @"미래의 희망입주 년/월을 입력하세요";
	}
//	else if ([self.sbJob.text isEqualToString:@"선택하세요."]) {   //항목삭제 2014. 5.15 요청
//		strMsg = @"직업을 선택하세요.";
//	}
//	else if ([self.sbLivingSort.text isEqualToString:@"선택하세요."]) {
//		strMsg = @"주거구분을 선택하세요.";
//	}
//	else if ([self.sbLivingType.text isEqualToString:@"선택하세요."]) {
//		strMsg = @"주거종류를 선택하세요.";
//	}
	
	if (strMsg) {
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:strMsg];
		
		return;
	}
	
	[self.userItem setObject:[NSString stringWithFormat:@"%d", nHopeHouseTypeIndex] forKey:@"청약희망주택형"];
	[self.userItem setObject:[NSString stringWithFormat:@"%d", nHopeHouseSizeIndex] forKey:@"청약희망주택면적"];
	[self.userItem setObject:[NSString stringWithFormat:@"%d", nLivingSortIndex] forKey:@"청약주거구분"];
	[self.userItem setObject:[NSString stringWithFormat:@"%d", nLivingTypeIndex] forKey:@"청약주거종류"];
	[self.userItem setObject:[NSString stringWithFormat:@"%d", nJobIndex] forKey:@"청약직업구분"];
	//[self.userItem setObject:[self.btnMarried isSelected] ? @"2" : @"1" forKey:@"청약결혼여부"];
	
	[self.userItem setObject:[NSString stringWithFormat:@"%@%@", self.tfZipCodeLeft.text, self.tfZipCodeRight.text] forKey:@"청약희망입주지역"];
	[self.userItem setObject:[NSString stringWithFormat:@"%d%02d",nSelectedYear,nSelectedMonth] forKey:@"청약희망입주시기"];
	
	SHBNewProductRegViewController *viewController = [[SHBNewProductRegViewController alloc]initWithNibName:@"SHBNewProductRegViewController" bundle:nil];
	viewController.userItem = self.userItem;
	viewController.dicSelectedData = self.dicSelectedData;
    viewController.dicSmartNewData = self.dicSmartNewData;
	viewController.needsLogin = YES;
    viewController.stepNumber = @"예금적금 가입 3단계";
	[self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
//	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
//	{
//		if ([viewController isKindOfClass:[SHBNewProductListViewController class]]) {
//			[self.navigationController popToViewController:viewController animated:YES];
//		}
//	}
	[self.navigationController fadePopViewController];
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self.tfZipCodeLeft focusSetWithLoss:NO];
	[self.tfZipCodeRight focusSetWithLoss:NO];
    
    
   
	
	currentTextField = (SHBTextField *)textField;
	[currentTextField focusSetWithLoss:YES];
}

#pragma mark - SHBTextField Delegate
- (void)didPrevButtonTouch
{
}

- (void)didNextButtonTouch
{
}

- (void)didCompleteButtonTouch
{
	[self closeKeyboard];
	
	[currentTextField focusSetWithLoss:NO];
}

#pragma mark - SHBMonthField Delegate
- (void)monthField:(SHBMonthField*)monthField didConfirmWithMonth:(NSString*)month
{
//	NSDateFormatter *dateFormater = [[[NSDateFormatter alloc]init]autorelease];
//	[dateFormater setDateFormat:@"YYYYMM"];
//	
//	if (dateField == self.mfHopeTime) {
//		self.strHopeTime = [dateFormater stringFromDate:date];
//	}
	self.strHopeTime = month;
}

- (void)currentMonthField:(SHBMonthField*)monthField
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
	
	Debug(@"AppInfo.tran_Date : %@", AppInfo.tran_Date);
	NSDate *currentDate = [dateFormatter dateFromString:AppInfo.tran_Date];
	
	[dateFormatter setDateFormat:@"yyyyMM"];
    
    if ([self.mfHopeTime.textField.text length] ==0 )
    {
        [self.mfHopeTime setDate:currentDate];
    }
	self.strHopeTime = [dateFormatter stringFromDate:currentDate];
    [self.mfHopeTime selectDate:currentDate animated:NO];
    
}

#pragma mark - SHBSelectBox Delegate
- (void)didSelectSelectBox:(SHBSelectBox *)selectBox
{
	[self closeKeyboard];
	[selectBox setState:SHBSelectBoxStateSelected];
	
	if (selectBox == self.sbHopeHouseType) {		// 희망주택형
		self.marrHopeHouseTypes = [NSMutableArray array];
		[self.marrHopeHouseTypes addObject:@{@"1" : @"아파트(1)"}];
		[self.marrHopeHouseTypes addObject:@{@"1" : @"연립/빌라/다세대(2)"}];
		[self.marrHopeHouseTypes addObject:@{@"1" : @"단독주택(3)"}];
		
		SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"희망주택형"
																	   options:self.marrHopeHouseTypes
																	   CellNib:@"SHBExchangePopupCell"
																		 CellH:32
																   CellDispCnt:5
																	CellOptCnt:1] autorelease];
		[popupView setDelegate:self];
		[popupView setDataKey:@"희망주택형"];
		[popupView showInView:self.navigationController.view animated:YES];
	}
	else if (selectBox == self.sbHopeHouseSize) {		// 희망주택면적(전용면적)
		self.marrHopeHouseSizes = [NSMutableArray array];
		[self.marrHopeHouseSizes addObject:@{@"1" : @"40㎡ 이하(1)"}];
		[self.marrHopeHouseSizes addObject:@{@"1" : @"40㎡ 초과 60㎡ 이하(2)"}];
		[self.marrHopeHouseSizes addObject:@{@"1" : @"60㎡ 초과 85㎡ 이하(3)"}];
		[self.marrHopeHouseSizes addObject:@{@"1" : @"85㎡ 초과 102㎡ 이하(4)"}];
		[self.marrHopeHouseSizes addObject:@{@"1" : @"102㎡ 초과 135㎡ 이하(5)"}];
		[self.marrHopeHouseSizes addObject:@{@"1" : @"135㎡ 초과(6)"}];
		
		SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"희망주택면적(전용면적)"
																	   options:self.marrHopeHouseSizes
																	   CellNib:@"SHBExchangePopupCell"
																		 CellH:32
																   CellDispCnt:5
																	CellOptCnt:1] autorelease];
		[popupView setDelegate:self];
		[popupView setDataKey:@"희망주택면적(전용면적)"];
		[popupView showInView:self.navigationController.view animated:YES];
	}
    
	//	else if (textField == self.tfHopeTime) {		// 희망입주시기
	//		// 데이트피커
	//	}
    
    
    
    /* 항목삭제 2014.5.6
	else if (selectBox == self.sbJob) {		// 직업
		self.marrJobs = [NSMutableArray array];
		[self.marrJobs addObject:@{@"1" : @"회사원(1)"}];
		[self.marrJobs addObject:@{@"1" : @"자영업(2)"}];
		[self.marrJobs addObject:@{@"1" : @"공무원(3)"}];
		[self.marrJobs addObject:@{@"1" : @"전문직(4)"}];
		[self.marrJobs addObject:@{@"1" : @"주부(5)"}];
		[self.marrJobs addObject:@{@"1" : @"학생(6)"}];
		[self.marrJobs addObject:@{@"1" : @"기타(7)"}];
		
		SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"직업"
																	   options:self.marrJobs
																	   CellNib:@"SHBExchangePopupCell"
																		 CellH:32
																   CellDispCnt:5
																	CellOptCnt:1] autorelease];
		[popupView setDelegate:self];
		[popupView setDataKey:@"직업"];
		[popupView showInView:self.navigationController.view animated:YES];
	}
	else if (selectBox == self.sbLivingSort) {		// 주거구분
		self.marrLivingSorts = [NSMutableArray array];
		[self.marrLivingSorts addObject:@{@"1" : @"자택(1)"}];
		[self.marrLivingSorts addObject:@{@"1" : @"전세(2)"}];
		[self.marrLivingSorts addObject:@{@"1" : @"월세(3)"}];
		[self.marrLivingSorts addObject:@{@"1" : @"기타(4)"}];
		
		SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"주거구분"
																	   options:self.marrLivingSorts
																	   CellNib:@"SHBExchangePopupCell"
																		 CellH:32
																   CellDispCnt:5
																	CellOptCnt:1] autorelease];
		[popupView setDelegate:self];
		[popupView setDataKey:@"주거구분"];
		[popupView showInView:self.navigationController.view animated:YES];
	}
	else if (selectBox == self.sbLivingType) {		// 주거종류
		self.marrLivingTypes = [NSMutableArray array];
		[self.marrLivingTypes addObject:@{@"1" : @"아파트(1)"}];
		[self.marrLivingTypes addObject:@{@"1" : @"연립/빌라/다세대(2)"}];
		[self.marrLivingTypes addObject:@{@"1" : @"단독주택(3)"}];
		[self.marrLivingTypes addObject:@{@"1" : @"기타(4)"}];
		
		SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"주거종류"
																	   options:self.marrLivingTypes
																	   CellNib:@"SHBExchangePopupCell"
																		 CellH:32
																   CellDispCnt:5
																	CellOptCnt:1] autorelease];
		[popupView setDelegate:self];
		[popupView setDataKey:@"주거종류"];
		[popupView showInView:self.navigationController.view animated:YES];
	}
     */
	
}

#pragma mark - SHBListPopupView Delegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
	if ([listPopView.dataKey isEqualToString:@"희망주택형"]) {
		[self.sbHopeHouseType setText:[[self.marrHopeHouseTypes objectAtIndex:anIndex]objectForKey:@"1"]];
		nHopeHouseTypeIndex = anIndex+1;
		
		[self.sbHopeHouseType setState:SHBSelectBoxStateNormal];
	}
	else if ([listPopView.dataKey isEqualToString:@"희망주택면적(전용면적)"]) {
		[self.sbHopeHouseSize setText:[[self.marrHopeHouseSizes objectAtIndex:anIndex]objectForKey:@"1"]];
		nHopeHouseSizeIndex = anIndex+1;
		
		[self.sbHopeHouseSize setState:SHBSelectBoxStateNormal];
	}
//	else if ([listPopView.dataKey isEqualToString:@"직업"]) {
//		[self.sbJob setText:[[self.marrJobs objectAtIndex:anIndex]objectForKey:@"1"]];
//		nJobIndex = anIndex+1;
//		
//		[self.sbJob setState:SHBSelectBoxStateNormal];
//	}
//	else if ([listPopView.dataKey isEqualToString:@"주거구분"]) {
//		[self.sbLivingSort setText:[[self.marrLivingSorts objectAtIndex:anIndex]objectForKey:@"1"]];
//		nLivingSortIndex = anIndex+1;
//		
//		[self.sbLivingSort setState:SHBSelectBoxStateNormal];
//	}
//	else if ([listPopView.dataKey isEqualToString:@"주거종류"]) {
//		[self.sbLivingType setText:[[self.marrLivingTypes objectAtIndex:anIndex]objectForKey:@"1"]];
//		nLivingTypeIndex = anIndex+1;
//		
//		[self.sbLivingType setState:SHBSelectBoxStateNormal];
//	}
}

- (void)listPopupViewDidCancel
{
	[self.sbHopeHouseSize setState:SHBSelectBoxStateNormal];
	[self.sbHopeHouseType setState:SHBSelectBoxStateNormal];
	//[self.sbJob setState:SHBSelectBoxStateNormal];
	//[self.sbLivingSort setState:SHBSelectBoxStateNormal];
	//[self.sbLivingType setState:SHBSelectBoxStateNormal];
}

@end
