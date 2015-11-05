//
//  SHBNewProductTaxBreakViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 19..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBNewProductTaxBreakViewController.h"
#import "SHBProductService.h"
#import "SHBNewProductRegTopView.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductListViewController.h"
#import	"SHBNewProductReInputNotiPopupView.h"
#import "SHBNewProductSignUpViewController.h"
#import "SHBUtility.h"
#import "SHBNewProductStipulationViewController.h"

@interface SHBNewProductTaxBreakViewController ()
{
	CGFloat fCurrHeight;
	
	// 예외처리용
	BOOL tax;				// 세금우대
	int taxval;				// 0:일반과세, 1:세금우대, 2:비과세(생계형)
	BOOL isSendTaxFree;		// D4222 전문을 보냈는지?
	BOOL tax_On;			// taxval이 0이나 1일때 YES
	
	BOOL autotrans;			// 자동이체 여부
	int autotransval;		// 신청, 미신청
	BOOL autotrans_On;		// 자동이체 선택여부
	
	int	autoReInput;		// 재예치
	int reinputval;			// 0:신청안함(만기자동해지) , 1:원금만 자동재예치 , 2:원리금 자동재예치
	
	NSInteger nTextFieldTag;
    SHBButton *btnAutoEndType;
    NSDictionary *outAccInfoDic;
}

@property (nonatomic, retain) NSMutableArray *marrTaxRadioBtns;				// 세금우대관련 라디오버튼
@property (nonatomic, retain) NSMutableArray *marrAutoTransRadioBtns;		// 자동이체신청 라디오버튼
@property (nonatomic, retain) NSMutableArray *marrAutoReInputRadioBtns;		// 자동재예치 라디오버튼
@property (nonatomic, retain) SHBNewProductReInputNotiPopupView *popupView;	// 자동재예치 결과통지 팝업뷰
@property (nonatomic, retain) NSString *strAutoTransStartDate;	// 자동이체시작일 (YYYYMMdd)
@property (nonatomic, retain) NSString *strAutoTransEndDate;	// 자동이체종료일 (YYYYMMdd)
@property (nonatomic, retain) NSDictionary *outAccInfoDic;
/**
 자동이체 말일이체구분
 */

@property (retain, nonatomic) SHBButton *btnAutoEndType;

@end

@implementation SHBNewProductTaxBreakViewController

@synthesize btnAutoEndType;
@synthesize outAccInfoDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		tax = NO;
		autotrans = NO;
		autotrans_On = NO;
		tax_On = NO;
		autoReInput = -1;
		reinputval = -1;
		taxval = -1;
		autotransval = -1;
		
		nTextFieldTag = 222000;
    }
    return self;
}

- (void)dealloc {
    [_dicSmartNewData release];
	[_strAutoTransEndDate release];
	[_strAutoTransStartDate release];
	[_dfAutoTransEndDate release];
	[_dfAutoTransStartDate release];
	[_lblTopRow1Value release];
	[_lblTopRow2Value release];
	[_D4222 release];
	[_userItem release];
	[_popupView release];
	[_marrAutoReInputRadioBtns release];
	[_marrAutoTransRadioBtns release];
	[_marrTaxRadioBtns release];
	[_tfAutoTransAmount release];
//	[_tfAutoTransEndDate release];
//	[_tfAutoTransStartDate release];
	[_tfTaxBreakAmount release];
	[_D3602 release];
	[_D4220 release];
	[_dicSelectedData release];
	[_bottomBackView release];
    
    [btnAutoEndType release];
	[super dealloc];
}

- (void)viewDidUnload {
	self.dfAutoTransEndDate = nil;
	self.dfAutoTransStartDate = nil;
	self.lblTopRow1Value = nil;
	self.lblTopRow2Value = nil;
	self.popupView = nil;
	self.tfAutoTransAmount = nil;
//	self.tfAutoTransEndDate = nil;
//	self.tfAutoTransStartDate = nil;
	self.tfTaxBreakAmount = nil;
	[self setBottomBackView:nil];
    self.btnAutoEndType = nil;
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예금/적금 가입"];
  
    self.strBackButtonTitle =self.stepNumber; //4단계 (주택청약일때)
    

    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	BOOL isSubscription = [[self.dicSelectedData objectForKey:@"청약여부"]isEqualToString:@"1"];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 가입", [self.dicSelectedData objectForKey:@"상품명"]] maxStep:isSubscription ? 5+1 : 5 focusStepNumber:isSubscription ? 3+1 : 3]autorelease]];
	
	SHBNewProductRegTopView *topView = [[[SHBNewProductRegTopView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 320, 34*2) parentViewController:self]autorelease];
	[self.contentScrollView addSubview:topView];
	fCurrHeight += 34*2;
	
	if ([[self.dicSelectedData objectForKey:@"세금우대_일반과세가능여부"]isEqualToString:@"1"]
		|| [[self.dicSelectedData objectForKey:@"세금우대_세금우대가능여부"]isEqualToString:@"1"]
		|| [[self.dicSelectedData objectForKey:@"세금우대_생계형가능여부"]isEqualToString:@"1"])
    {
		
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
        
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   //@"주민번호" : AppInfo.ssn,
                               //@"주민번호" : [AppInfo getPersonalPK],
                               @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
							   @"세금우대_D4222저축종류" : [self.dicSelectedData objectForKey:@"세금우대_D4222저축종류"],
							   }];
		self.service = [[[SHBProductService alloc]initWithServiceId:kD4220Id viewController:self]autorelease];
		self.service.requestData = dataSet;
		[self.service start];
	}
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
- (void)setTaxView
{
	fCurrHeight += 10;
	UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 317-8, 21)]autorelease];
	[lblTitle1 setBackgroundColor:[UIColor clearColor]];
	[lblTitle1 setTextColor:RGB(74, 74, 74)];
	[lblTitle1 setFont:[UIFont systemFontOfSize:15]];
	[lblTitle1 setText:@"세금우대관련"];
	[self.contentScrollView addSubview:lblTitle1];
	fCurrHeight += 30;
	
	taxval = 0;
	NSMutableArray *marrRadios = [NSMutableArray array];
	if ([[self.dicSelectedData objectForKey:@"세금우대_일반과세가능여부"] isEqualToString:@"1"]) {
		[marrRadios addObject:@"일반과세"];
		
	}
	
	if ([[self.dicSelectedData objectForKey:@"세금우대_세금우대가능여부"] isEqualToString:@"1"]) {
		[marrRadios addObject:@"세금우대"];
	}
	
	if ([[self.dicSelectedData objectForKey:@"세금우대_생계형가능여부"] isEqualToString:@"1"]) {
		[marrRadios addObject:@"비과세(생계형)"];
	}
	
	self.marrTaxRadioBtns = [NSMutableArray array];
	for (int nIdx = 0; nIdx < [marrRadios count]; nIdx++) {
		UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
		[btnRadio addTarget:self action:@selector(taxRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentScrollView addSubview:btnRadio];
		[btnRadio setDataKey:[marrRadios objectAtIndex:nIdx]];
		[self.marrTaxRadioBtns addObject:btnRadio];
		
		UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
		[lblRadio setBackgroundColor:[UIColor clearColor]];
		[lblRadio setTextColor:RGB(74, 74, 74)];
		[lblRadio setFont:[UIFont systemFontOfSize:14]];
		[lblRadio setText:[marrRadios objectAtIndex:nIdx]];
		[self.contentScrollView addSubview:lblRadio];
		
		if (nIdx == 0) {
			[btnRadio setFrame:CGRectMake(8, fCurrHeight, 21, 21)];
			[btnRadio setSelected:YES];
		}
		else if (nIdx == 1) {
			[btnRadio setFrame:CGRectMake(320-3-8-200, fCurrHeight, 21, 21)];
		}
		else if (nIdx == 2) {
			[btnRadio setFrame:CGRectMake(204, fCurrHeight, 21, 21)];
		}
		
		[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, fCurrHeight, 84, 21)];
	}
	fCurrHeight += 30;
	
	if ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] ||
        [[self.userItem objectForKey:@"적립방식선택"]isEqualToString:@"자유적립식"])
    {
		UILabel *lblTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight += 10, 320-3-8-200-8, 30)]autorelease];
		[lblTitle2 setBackgroundColor:[UIColor clearColor]];
		[lblTitle2 setTextColor:RGB(74, 74, 74)];
		[lblTitle2 setFont:[UIFont systemFontOfSize:14]];
		[lblTitle2 setText:@"세금우대신청금액"];
		[self.contentScrollView addSubview:lblTitle2];
		
		SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(320-3-8-200, fCurrHeight, 200, 30)]autorelease];
		[tf setAutocorrectionType:UITextAutocorrectionTypeNo];
		[tf setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[tf setTextAlignment:NSTextAlignmentRight];
		[tf setDelegate:self];
		[tf setAccDelegate:self];
		[tf setKeyboardType:UIKeyboardTypeNumberPad];
		[tf setTag:nTextFieldTag];
		[tf setEnabled:NO];
		[self.contentScrollView addSubview:tf];
		self.tfTaxBreakAmount = tf;
		fCurrHeight += 30;
	}
}

- (void)setTaxGuideView
{
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[self.contentScrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 5;
	
	NSMutableArray *marrGuides = [NSMutableArray array];
	for (int nIdx = 1; nIdx <= 10; nIdx ++) {
		NSString *strKey = [NSString stringWithFormat:@"메시지%d", nIdx];
		NSString *strValue  = [self.D3602 objectForKey:strKey];
		NSString *strValue1 = [strValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
		
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
		
		fHeight += size.height + (strGuide == [marrGuides lastObject] ? 5 : 10);
	}
	
	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight += 10, 311, fHeight)];
	fCurrHeight += fHeight;
}

- (void)setAutoTransView
{
	// 자동이체신청
	UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight += 10, 320-3-8-200-8, 21)]autorelease];
	[lblTitle1 setBackgroundColor:[UIColor clearColor]];
	[lblTitle1 setTextColor:RGB(74, 74, 74)];
	[lblTitle1 setFont:[UIFont systemFontOfSize:15]];
	[lblTitle1 setText:@"자동이체신청"];
	[self.contentScrollView addSubview:lblTitle1];
	
	self.marrAutoTransRadioBtns = [NSMutableArray array];
	
	for (int nIdx = 0; nIdx < 3; nIdx++) {
		UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
		[btnRadio addTarget:self action:@selector(autoTransRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentScrollView addSubview:btnRadio];
		[self.marrAutoTransRadioBtns addObject:btnRadio];
		
		UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
		[lblRadio setBackgroundColor:[UIColor clearColor]];
		[lblRadio setTextColor:RGB(74, 74, 74)];
		[lblRadio setFont:[UIFont systemFontOfSize:14]];
		[self.contentScrollView addSubview:lblRadio];
		
		if (nIdx == 0) {
			[btnRadio setFrame:CGRectMake(320-3-8-200, fCurrHeight, 21, 21)];
			[btnRadio setSelected:YES];
			[btnRadio setDataKey:@"신청"];
			
			[lblRadio setText:@"신청"];
		}
		else if (nIdx == 1) {
			[btnRadio setFrame:CGRectMake(204, fCurrHeight, 21, 21)];
			[btnRadio setDataKey:@"미신청"];
			
			[lblRadio setText:@"미신청"];
		}
		
		[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, fCurrHeight, 80, 21)];
	}
    
	fCurrHeight += 21+3;
	
	if (![[self.dicSelectedData objectForKey:@"자동이체_분기별가능금액"]isEqualToString:@"0"]) {
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 21)]autorelease];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setTextColor:RGB(74, 74, 74)];
		[lbl setFont:[UIFont systemFontOfSize:13]];
		[lbl setText:[NSString stringWithFormat:@"* 분기별 %@원 이내 적립가능", [SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"자동이체_분기별가능금액"]]]];
		[self.contentScrollView addSubview:lbl];
	}
	fCurrHeight += 21+10;
	
	// 자동이체시작일, 자동이체종료일, 말일이체구분, 자동이체금액
	for (int nIdx = 0; nIdx < 5; nIdx++) {
		UIView *rowView = [[[UIView alloc]init]autorelease];
		[rowView setFrame:CGRectMake(0, fCurrHeight, 320, 40)];
		[rowView setUserInteractionEnabled:YES];
		[self.contentScrollView addSubview:rowView];
		
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 320-3-8-200-8, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:15]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[rowView addSubview:lblTitle];
		
//		SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(320-3-8-200, 0, 200, 30)]autorelease];
//		[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//		[tf setDelegate:self];
//		[tf setAccDelegate:self];
//		[tf setKeyboardType:UIKeyboardTypeNumberPad];
//		[rowView addSubview:tf];
		
		if (nIdx == 0) {
			[lblTitle setText:@"자동이체시작일"];
			NSDateFormatter *dateFormater = [[[NSDateFormatter alloc]init]autorelease];
			[dateFormater setDateFormat:@"yyyy.MM.dd"];
//			self.strAutoTransStartDate = [dateFormater stringFromDate:[NSDate date]];
			
			SHBDateField *df = [[[SHBDateField alloc]initWithFrame:CGRectMake(320-3-8-200, 0, 200, 30)]autorelease];
			[df.textField setTextAlignment:NSTextAlignmentLeft];
			[df.textField setFont:[UIFont systemFontOfSize:15]];
			[df setDelegate:self];
            
            if (![[self.dicSelectedData objectForKey:@"청약여부"] isEqualToString:@"1"])
            {
                [df selectDate:[dateFormater dateFromString:[SHBUtility dateStringToMonth:+1 toDay:0]] animated:YES];
			}
            
            [rowView addSubview:df];
			
			self.dfAutoTransStartDate = df;
            self.strAutoTransStartDate = [df.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
			
           
		}
		else if (nIdx == 1)
		{
			[lblTitle setText:@"자동이체종료일"];
            NSDateFormatter *dateFormater = [[[NSDateFormatter alloc]init]autorelease];
			[dateFormater setDateFormat:@"yyyy.MM.dd"];
//			self.strAutoTransStartDate = [dateFormater stringFromDate:[NSDate date]];
			
			SHBDateField *df = [[[SHBDateField alloc]initWithFrame:CGRectMake(320-3-8-200, 0, 200, 30)]autorelease];
			[df.textField setTextAlignment:NSTextAlignmentLeft];
			[df.textField setFont:[UIFont systemFontOfSize:15]];
			[df setDelegate:self];
            
            if (![[self.dicSelectedData objectForKey:@"청약여부"] isEqualToString:@"1"])
            {
                [df selectDate:[dateFormater dateFromString:[SHBUtility dateStringToMonth:[[self.userItem objectForKey:@"계약기간"] intValue] - 1 toDay:0]] animated:YES];
            }
//			[df selectDate:[NSDate date] animated:YES];
			[rowView addSubview:df];
			
			self.dfAutoTransEndDate = df;
            self.strAutoTransEndDate = [df.textField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
//			self.tfAutoTransEndDate = tf;
		}
        
        else if (nIdx == 2)   // 2014.3.14  자동이체 말일이체여부 추가.
		{
			[lblTitle setText:@"말일이체구분"];
            
            
            self.btnAutoEndType = [SHBButton buttonWithType:UIButtonTypeCustom];
            [self.btnAutoEndType setFrame:CGRectMake(320-3-8-200, 0, 200, 30)];
            [self.btnAutoEndType setBackgroundImage:[UIImage imageNamed:@"selectbox2_nor.png"] forState:UIControlStateNormal];
            [self.btnAutoEndType setBackgroundImage:[UIImage imageNamed:@"selectbox2_focus.png"] forState:UIControlStateHighlighted];
            [self.btnAutoEndType setBackgroundImage:[UIImage imageNamed:@"selectbox2_dim.png"] forState:UIControlStateDisabled];
            [self.btnAutoEndType.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
            [self.btnAutoEndType setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [self.btnAutoEndType setContentEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
            [self.btnAutoEndType setTitleColor:RGB(44, 44, 44) forState:UIControlStateNormal];
            [self.btnAutoEndType setTitle:@"아니오" forState:UIControlStateNormal];
            [self.btnAutoEndType addTarget:self action:@selector(autoAndType) forControlEvents:UIControlEventTouchUpInside];
            [rowView addSubview:self.btnAutoEndType];
            
            
            [self.btnAutoEndType setEnabled:NO];
            
            [self.userItem setObject:@"0" forKey:@"말일이체여부"];
            
		}
        
        else if (nIdx == 3)  // 2014.3.14  자동이체 말일이체여부 추가.
		{
			[lblTitle setText:@""];
            
            UILabel *autoEndTitle = [[[UILabel alloc]initWithFrame:CGRectMake(320-3-220, 0, 200, 34)]autorelease];
            [autoEndTitle setBackgroundColor:[UIColor clearColor]];
            [autoEndTitle setFont:[UIFont systemFontOfSize:13]];
            [autoEndTitle setTextColor:RGB(0, 0, 0)];
            [autoEndTitle setNumberOfLines:2];
            [autoEndTitle setTextAlignment:UITextAlignmentRight];
            [autoEndTitle setText:@"말일이체 설정시 날짜구분없이 매달 마지막날 이체가 실행됩니다."];
            [rowView addSubview:autoEndTitle];
            
            
		}

		else if (nIdx == 4)
		{
			[lblTitle setText:@"자동이체금액"];
			
			SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(320-3-8-200, 0, 200, 30)]autorelease];
			[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
			[tf setTextAlignment:NSTextAlignmentRight];
			[tf setDelegate:self];
			[tf setAccDelegate:self];
			[tf setKeyboardType:UIKeyboardTypeNumberPad];
			[tf setTag:++nTextFieldTag];
			[rowView addSubview:tf];
			self.tfAutoTransAmount =  tf;
            
            if ([[self.userItem objectForKey:@"적립방식선택"]length])
            {
                if ([[self.userItem objectForKey:@"적립방식선택"]isEqualToString:@"정기적립식"])
                {
                    self.tfAutoTransAmount.text = [self.userItem objectForKey:@"신규금액"];
                    [self.tfAutoTransAmount setEnabled:NO];
                }
                else {
                    if (_dicSmartNewData && [_dicSmartNewData[@"자동이체여부"] isEqualToString:@"1"])
                    {
                        [self.tfAutoTransAmount setText:[SHBUtility normalStringTocommaString:_dicSmartNewData[@"자동이체금액"]]];
                    }
                }
            }
            else {
                if (_dicSmartNewData && [_dicSmartNewData[@"자동이체여부"] isEqualToString:@"1"])
                {
                    [self.tfAutoTransAmount setText:[SHBUtility normalStringTocommaString:_dicSmartNewData[@"자동이체금액"]]];
                }
            }
		}
		
		fCurrHeight += 40;
	}
}

- (void)setAutoReInputView
{
	fCurrHeight += 10;
	
	UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 107-8, 21)]autorelease];
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[lblTitle setFont:[UIFont systemFontOfSize:15]];
	[lblTitle setTextColor:RGB(74, 74, 74)];
	[lblTitle setText:@"자동재예치신청"];
	[self.contentScrollView addSubview:lblTitle];
	
	NSUInteger nRadioCount = [[self.dicSelectedData objectForKey:@"재예치가능여부"] isEqualToString:@"1"] ? 3 : 2;	
	
	self.marrAutoReInputRadioBtns = [NSMutableArray array];
	for (int nIdx = 0; nIdx < nRadioCount; nIdx++) {
		UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
		[btnRadio addTarget:self action:@selector(autoReInputRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentScrollView addSubview:btnRadio];
		
		UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
		[lblRadio setBackgroundColor:[UIColor clearColor]];
		[lblRadio setTextColor:RGB(74, 74, 74)];
		[lblRadio setFont:[UIFont systemFontOfSize:15]];
		[self.contentScrollView addSubview:lblRadio];
		
		[btnRadio setFrame:CGRectMake(107, fCurrHeight, 21, 21)];
		[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, fCurrHeight, 170, 21)];
		
		if (nIdx == 0) {
			[lblRadio setText:@"신청안함(만기자동해지)"];
			[btnRadio setDataKey:@"신청안함(만기자동해지)"];
			[btnRadio setSelected:YES];
		}
		else if (nIdx == 1) {
			if ([[self.dicSelectedData objectForKey:@"재예치가능여부"] isEqualToString:@"1"]
				|| [[self.dicSelectedData objectForKey:@"재예치가능여부"] isEqualToString:@"4"])
			{
				[lblRadio setText:@"원금만 자동재예치"];
				[btnRadio setDataKey:@"원금만 자동재예치"];
			}
			else if ([[self.dicSelectedData objectForKey:@"재예치가능여부"] isEqualToString:@"5"])
			{
				[lblRadio setText:@"원리금 자동재예치"];
				[btnRadio setDataKey:@"원리금 자동재예치"];
			}
		}
		else if (nIdx == 2) {
			[lblRadio setText:@"원리금 자동재예치"];
			[btnRadio setDataKey:@"원리금 자동재예치"];
		}		
		
		[self.marrAutoReInputRadioBtns addObject:btnRadio];
		
		fCurrHeight += (nIdx != nRadioCount-1 ? 21+10 : 21);
	}
	
	// 안내 문구
	fCurrHeight += 10;
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[self.contentScrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 10;
	
	NSMutableArray *marrGuides = [NSMutableArray array];
	if ([[self.dicSelectedData objectForKey:@"재예치가능여부"] isEqualToString:@"1"]) {
		[marrGuides addObject:@"재예치 신청시 만기일에 자동으로 직전 계약조건과 동일하게 재예치됩니다."];
		[marrGuides addObject:@"최장 10년까지 자동재예치되며 약정 이율은 재예치시 결정"];
		[marrGuides addObject:@"세금우대/비과세(생계형)으로 가입하는 경우에는 원금만 자동재예치 가능합니다."];
	}
	else if ([[self.dicSelectedData objectForKey:@"재예치가능여부"] isEqualToString:@"4"]
			 || [[self.dicSelectedData objectForKey:@"재예치가능여부"] isEqualToString:@"5"]) {
		[marrGuides addObject:@"재예치 신청시 6개월 단위로 총2회 자동재예치 됩니다.(최장18개월까지)"];
		[marrGuides addObject:@"매 계약기간 만료일마다 만료일 전날까지 세후 원리금을 자동재예치 합니다."];
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
		[lblGuide setTextColor:RGB(114, 114, 114)];
		[lblGuide setFont:[UIFont systemFontOfSize:13]];
		[lblGuide setText:strGuide];
		[ivInfoBox addSubview:lblGuide];
		
		fHeight += size.height + (strGuide == [marrGuides lastObject] ? 10 : 18);
	}
	
	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight, 311, fHeight)];
	fCurrHeight += fHeight;
}

- (void)setInfoView
{
	fCurrHeight += 10;
	
	UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 107-8, 21)]autorelease];
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[lblTitle setFont:[UIFont systemFontOfSize:15]];
	[lblTitle setTextColor:RGB(74, 74, 74)];
	[lblTitle setText:@"안내"];
	[self.contentScrollView addSubview:lblTitle];
	
	fCurrHeight += 21+10;
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[self.contentScrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 10;
	
	NSMutableArray *marrGuides = [NSMutableArray array];
	[marrGuides addObject:@"자동이체 미 희망시는 월부금 한도 내에서 자유롭게 입금은 가능하나 지연 입금으로 인하여 청약순위 선정시 불이익을 받을 수 있습니다."];
	[marrGuides addObject:@"자동이체 신청 시 매월 자동이체금액만큼 출금계좌에서 자동이체 됩니다."];
	
	for (NSString *strGuide in marrGuides)
	{
		CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(284, 999) lineBreakMode:NSLineBreakByCharWrapping];
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(5, fHeight+4, 7, 7)];
		[ivInfoBox addSubview:ivBullet];
		
		UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5+7+3, fHeight, 284, size.height)]autorelease];
		[lblGuide setNumberOfLines:0];
		[lblGuide setBackgroundColor:[UIColor clearColor]];
		[lblGuide setTextColor:RGB(114, 114, 114)];
		[lblGuide setFont:[UIFont systemFontOfSize:13]];
		[lblGuide setText:strGuide];
		[ivInfoBox addSubview:lblGuide];
		
		fHeight += size.height + (strGuide == [marrGuides lastObject] ? 10 : 18);
	}
	
	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight, 311, fHeight)];
	fCurrHeight += fHeight;
}

- (void)setBottomView
{	
	// 확인/취소 버튼 및 스크롤뷰 컨텐트사이즈
	[self.bottomBackView setHidden:NO];
	FrameReposition(self.bottomBackView, 0, fCurrHeight += 12);
	fCurrHeight += 29;
	
	[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fCurrHeight+=12)];
	[self.contentScrollView flashScrollIndicators];
	
	contentViewHeight = contentViewHeight > fCurrHeight ? contentViewHeight : fCurrHeight;
    
    startTextFieldTag = 222000;
    endTextFieldTag = nTextFieldTag;
}


// 비과세(생계형) 라디오버튼 선택시에는 전문을 통해 새로 데이터를 가져오네
- (void)taxFreeOn
{
	for (UIButton *btn in self.marrTaxRadioBtns)
	{
		[btn setSelected:NO];
		
		if ([btn.dataKey isEqualToString:@"비과세(생계형)"]) {
			[btn setSelected:YES];
		}
	}
	
	taxval = 2;
	
	[self.lblTopRow1Title setText:@"비과세(생계형)가입총액"];
	[self.lblTopRow2Title setText:@"비과세(생계형)한도잔여"];
	
	[self.lblTopRow1Value setText:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[self.D4222 objectForKey:@"저축종류별가입금액"]]]];
	[self.lblTopRow2Value setText:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[self.D4222 objectForKey:@"저축종류별미사용금액"]]]];
	
	tax_On = NO;
	isSendTaxFree = YES;
	[self.tfTaxBreakAmount setEnabled:YES];
	[self.tfTaxBreakAmount setText:nil];
}



#pragma mark - autoAndType Delegate

- (IBAction)autoAndType
{

    self.btnAutoEndType.selected = YES;
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[
                                                             @{@"1" : @"아니오", @"2" : @"0"},
                                                             @{@"1" : @"예", @"2" : @"1"},
                                                             ]];
    
    self.dataList = (NSArray *)array;
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"말일이체구분"
                                                                   options:array
                                                                   CellNib:@"SHBBankListPopupCell"
                                                                     CellH:32
                                                               CellDispCnt:2
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];

	

}


#pragma mark - SHBListPopupViewDelegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.btnAutoEndType.selected = NO;
    [self.btnAutoEndType setTitle:self.dataList[anIndex][@"1"] forState:UIControlStateNormal];
    [self.userItem setObject:self.dataList[anIndex][@"2"] forKey:@"말일이체여부"];
}

- (void)listPopupViewDidCancel{
     self.btnAutoEndType.selected = NO;
}


- (void)defaultValueSetting
{
    if([self isMonthLastDate:self.dfAutoTransStartDate.textField.text])
    {
        [self.userItem setObject:@"1" forKey:@"말일이체여부"];
        [self.btnAutoEndType setTitle:@"예" forState:UIControlStateNormal];
        self.btnAutoEndType.enabled = YES;
    }
    else
    {
        [self.userItem setObject:@"0" forKey:@"말일이체여부"];
        [self.btnAutoEndType setTitle:@"아니오" forState:UIControlStateNormal];
        self.btnAutoEndType.enabled = NO;
    }
}

// 해당 달의 마지막 날 여부
- (BOOL)isMonthLastDate:(NSString *)aDate
{
    if (!aDate || ([aDate length] != 10 && [aDate length] != 8)) {
        return NO;
    }
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    NSDate *firstDate;
    
    if ([aDate length] == 8) {
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        
        firstDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@01", [aDate substringWithRange:NSMakeRange(0, 6)]]];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        
        firstDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@.01", [aDate substringWithRange:NSMakeRange(0, 7)]]];
    }
    
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	
	dateComponents.month = 1;
	dateComponents.day	 = -1;
	
	NSDate *dateMonthLastDate  = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
																			   toDate:firstDate
																			  options:0];
	[dateComponents release];
	dateComponents = nil;
    
    NSString *strLastDate = [dateFormatter stringFromDate:dateMonthLastDate];
    
	return [strLastDate isEqualToString:aDate] ? YES : NO;
}

#pragma mark - etc
- (void)showAutoReInputNotiPopupView
{
	if (!self.popupView) {
		self.popupView = [[[SHBNewProductReInputNotiPopupView alloc]initWithTitle:@"자동 재예치 결과 통지" SubViewHeight:276]autorelease];
	}
	
	[self.popupView showInView:self.navigationController.view animated:YES];
	
	for (UIButton *btn in self.popupView.marrNotiOptionBtns)
	{
		[btn addTarget:self action:@selector(autoReInputNotiOptionRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	}
}

#pragma mark - Action
- (void)taxRadioBtnAction:(UIButton *)sender
{
	NSString *dataKey = sender.dataKey;
	Debug(@"dataKey : %@", dataKey);
    
    for (UIButton *btn in self.marrTaxRadioBtns)
	{
		[btn setSelected:NO];
	}
	
	[sender setSelected:YES];
    

    
	if ([dataKey isEqualToString:@"일반과세"]) {
		[self.lblTopRow1Title setText:@"세금우대가입총액"];
		[self.lblTopRow2Title setText:@"세금우대한도잔여"];
		
		[self.lblTopRow1Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대가입총액"]]];
		[self.lblTopRow2Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대한도잔액"]]];
		
		taxval = 0;
		
		[self.tfTaxBreakAmount setEnabled:NO];
		[self.tfTaxBreakAmount setText:nil];
	}
	else if ([dataKey isEqualToString:@"세금우대"]) {
		
		if (![[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"]) {
			if ([[[self.userItem objectForKey:@"신규금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] >
				[[[self.D4220 objectForKey:@"세금우대한도잔액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] ) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:@"신규금액은 세금우대한도잔여액을 초과할 수 없습니다."
															   delegate:nil
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
                [sender setSelected:NO];
                [[self.marrTaxRadioBtns objectAtIndex:0]setSelected:YES];
                taxval = 0;
				return;
			}
		}
		
		if ( ([[self.dicSelectedData objectForKey:@"계약기간_고정여부"] isEqualToString:@"1"] || [[self.dicSelectedData objectForKey:@"계약기간_자유여부"] isEqualToString:@"1"]
			  || [[self.dicSelectedData objectForKey:@"계약기간_선택여부"] isEqualToString:@"1"] ) &&
			[[self.userItem objectForKey:@"계약기간"] intValue] < 12) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"세금우대로 가입하는 경우에는 계약기간이 12개월 이상 가능합니다."
														   delegate:nil
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
            [sender setSelected:NO];
            [[self.marrTaxRadioBtns objectAtIndex:0]setSelected:YES];
            [self.tfTaxBreakAmount setEnabled:NO];
            [self.tfTaxBreakAmount setText:nil];
            taxval = 0;
    
            return;
		}
		
		if (reinputval ==2 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"세금우대/비과세로 가입하는 경우에는 원금만 자동재예치 가능합니다."
														   delegate:nil
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
            [sender setSelected:NO];
            [[self.marrTaxRadioBtns objectAtIndex:0]setSelected:YES];
			return;
		}
		
		[self.lblTopRow1Title setText:@"세금우대가입총액"];
		[self.lblTopRow2Title setText:@"세금우대한도잔여"];
		
		[self.lblTopRow1Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대가입총액"]]];
		[self.lblTopRow2Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대한도잔액"]]];
		
		taxval = 1;
		
		[self.tfTaxBreakAmount setEnabled:YES];
		[self.tfTaxBreakAmount setText:nil];
		
		if ([[self.dicSelectedData objectForKey:@"적립방식_정기적립식여부"] isEqualToString:@"1"] &&
            [[self.userItem objectForKey:@"적립방식선택"]isEqualToString:@"정기적립식"])
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"신규금액을 기준으로 매월 만기까지 적립하기로 약정한 금액 전액이 세금우대 한도로 설정됩니다."
														   delegate:nil
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
           
			return;
		}
	}
	else if ([dataKey isEqualToString:@"비과세(생계형)"]) {
        
  
        
		if (reinputval == 2) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"세금우대/비과세로 가입하는 경우에는 원금만 자동재예치 가능합니다."
														   delegate:nil
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		
//        if ([[self.dicSelectedData objectForKey:@"적립방식_정기적립식여부"] isEqualToString:@"1"] &&
//            [[self.userItem objectForKey:@"적립방식선택"]isEqualToString:@"정기적립식"])
//        {
//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//															message:@"신규금액을 기준으로 매월 만기까지 적립하기로 약정한 금액 전액이 세금우대 한도로 설정됩니다."
//														   delegate:nil
//												  cancelButtonTitle:@"확인"
//												  otherButtonTitles:nil];
//			[alert show];
//			[alert release];
//            
//			return;
//		}

        
        if (isSendTaxFree == NO) {	// D4222 전문을 보내지 않았으면
            //D4222 전문을 보냄
			self.service = [[[SHBProductService alloc]initWithServiceId:kD4222Id viewController:self]autorelease];
			self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
										//@"주민번호" : AppInfo.ssn,
                                        //@"주민번호" : [AppInfo getPersonalPK],
                                        @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
										@"저축종류" : [self.dicSelectedData objectForKey:@"세금우대_D4222저축종류"],
										}];
			[self.service start];

            return;
        }
        else{
            [self taxFreeOn];
			return;
        }

	}
	
	
}

- (void)autoTransRadioBtnAction:(UIButton *)sender
{	
	for (UIButton *btn in self.marrAutoTransRadioBtns)
	{
		[btn setSelected:NO];
	}
	
	[sender setSelected:YES];
	
	NSString *dataKey = sender.dataKey;
	if ([dataKey isEqualToString:@"신청"]) {
		[self.dfAutoTransEndDate setEnabled:YES];
		[self.dfAutoTransStartDate setEnabled:YES];
//		[self.tfAutoTransEndDate setEnabled:YES];
//		[self.tfAutoTransStartDate setEnabled:YES];
		[self.tfAutoTransAmount setEnabled:YES];
		
		autotransval = 1;
		autotrans_On = YES;
        
        if ([[self.userItem objectForKey:@"적립방식선택"]length])
        {
            if ([[self.userItem objectForKey:@"적립방식선택"]isEqualToString:@"정기적립식"])
            {
                self.tfAutoTransAmount.text = [self.userItem objectForKey:@"신규금액"];
                [self.tfAutoTransAmount setEnabled:NO];
            }
            else {
                if (_dicSmartNewData && [_dicSmartNewData[@"자동이체여부"] isEqualToString:@"1"])
                {
                    [self.tfAutoTransAmount setText:[SHBUtility normalStringTocommaString:_dicSmartNewData[@"자동이체금액"]]];
                }
            }
        }
        else {
            if (_dicSmartNewData && [_dicSmartNewData[@"자동이체여부"] isEqualToString:@"1"])
            {
                [self.tfAutoTransAmount setText:[SHBUtility normalStringTocommaString:_dicSmartNewData[@"자동이체금액"]]];
            }
        }
    
	}
	else	// 미신청
	{
		// 가입입력 화면에서 정기적립식을 선택했을 경우에 미신청 선택시 얼럿 띄우기 (신한 그린애적금)
		if ([[self.userItem objectForKey:@"적립방식선택"]length]) {
			if ([[self.userItem objectForKey:@"적립방식선택"]isEqualToString:@"정기적립식"]) {
				[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"정기적립식인경우, 매월 신규일에 적립회차와 적립금이 입금되어야만 만기일이 이연되지 않습니다. 자동이체 미신청시 유의바랍니다."];
			}
		}
		
		[self.dfAutoTransEndDate setEnabled:NO];
		[self.dfAutoTransStartDate setEnabled:NO];
//		[self.tfAutoTransEndDate setEnabled:NO];
//		[self.tfAutoTransStartDate setEnabled:NO];
		[self.tfAutoTransAmount setEnabled:NO];
		
		autotransval = 2;
		autotrans_On = NO;
	}
}

- (void)autoReInputRadioBtnAction:(UIButton *)sender
{
	NSString *dataKey = sender.dataKey;
	
	if (![dataKey isEqualToString:@"신청안함(만기자동해지)"]) {
		
		// 쿠폰 금리우대이고 신청안함 이외의 버튼을 선택하면 얼럿 띄워줌
		if ([[self.dicSelectedData objectForKey:@"prodCode"]length]
			&& ([[self.dicSelectedData objectForKey:@"prodCode"]isEqualToString:@"560"] || [[self.dicSelectedData objectForKey:@"prodCode"]isEqualToString:@"561"])) {
			[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"온라인 특별금리우대 상품은 자동재예치 신청 불가합니다."];
			
			return;
		}
	}
	
	if ([dataKey isEqualToString:@"신청안함(만기자동해지)"]) {
		reinputval = 0;
	}
	else if ([dataKey isEqualToString:@"원금만 자동재예치"]) {
		reinputval = 1;
		
		[self showAutoReInputNotiPopupView];
	}
	else if ([dataKey isEqualToString:@"원리금 자동재예치"]) {
		if (taxval == 1 || taxval == 2) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:@"세금우대/비과세로 가입하는 경우에는 원금만 자동재예치 가능합니다."
														   delegate:self
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			[alert setTag:337337];
			[alert show];
			[alert release];
			
			return;
		}
		
		reinputval = 2;
		
		[self showAutoReInputNotiPopupView];
	}
	
	for (UIButton *btn in self.marrAutoReInputRadioBtns)
	{
		[btn setSelected:NO];
	}
	
	[sender setSelected:YES];
}

// 자동 재예치 결과 통지 팝업의 라디오버튼 선택되었을 때
// 1.원하지않음 2.SMS 신청 3.E-mail 신청
- (void)autoReInputNotiOptionRadioBtnAction:(UIButton *)sender
{
	for (UIButton *btn in self.popupView.marrNotiOptionBtns)
	{
		[btn setSelected:NO];
	}
	
	[sender setSelected:YES];
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
	// TODO: 입력값 예외처리
#if 1
	if (tax) {
		[self.userItem setObject:[NSString stringWithFormat:@"%d",taxval] forKey:@"세금우대"];
		
		
		//한도 validation
		if ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] ||
            [[self.userItem objectForKey:@"적립방식선택"]isEqualToString:@"자유적립식"])
        {     //세금우대 입력이 있는경우
			if (taxval == 1)
            {
//				if (![[item objectForKey:@"세금우대_분기당납입한도"] isEqualToString:@"0"] &&
//					[[[application.pmanager valueForRecvKey:@"세금우대한도잔액" Name:@"D4220"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] <
//					[[T_taxAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] intValue]) {
//					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//																	message:@"[세금우대] - 세금우대 신청금액이 분기당납입한도를 초과하였습니다."
//																   delegate: nil
//														  cancelButtonTitle:@"확인"
//														  otherButtonTitles:nil];
//					[alert show];
//					[alert release];
//					return;
//				}
				
				if ([[self.tfTaxBreakAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] >
					[[[self.D4220 objectForKey:@"세금우대한도잔액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																	message:@"세금우대 신청금액이 한도잔여액을 초과하였습니다."
																   delegate: nil
														  cancelButtonTitle:@"확인"
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
					return;
				}
				if (self.tfTaxBreakAmount.text == nil || [self.tfTaxBreakAmount.text length] == 0 || [self.tfTaxBreakAmount.text isEqualToString:@"0"]) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																	message:@"세금우대 신청금액을 정확히 입력해주세요."
																   delegate: nil
														  cancelButtonTitle:@"확인"
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
					return;
				}
				
				[self.userItem setObject:self.tfTaxBreakAmount.text forKey:@"세금우대_신청금액"];
			}
			
			
			if (taxval == 2) {
				
				
				if ([[self.tfTaxBreakAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] >
					[[[self.D4222 objectForKey:@"저축종류별미사용금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] ) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																	message:@"세금우대 신청금액은 비과세(생계형)한도 잔여액을 초과할 수 없습니다."
																   delegate:nil
														  cancelButtonTitle:@"확인"
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
					return;
				}
				
				
				// temp
				if ([self.tfTaxBreakAmount.text length] == 0 || [self.tfTaxBreakAmount.text isEqualToString:@"0"]) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																	message:@"세금우대 신청금액을 정확히 입력해주세요."
																   delegate: nil
														  cancelButtonTitle:@"확인"
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
					return;
				}
				
				// temp
				if (self.tfTaxBreakAmount.text) {
					[self.userItem setObject:self.tfTaxBreakAmount.text forKey:@"세금우대_신청금액"];
				}
				else
				{
					[self.userItem setObject:@"0" forKey:@"세금우대_신청금액"];
				}
				
			}			
			
		}
		else {    ///////////세금우대 입력이 없는 경우
			if (taxval == 1) {
				if ([[[self.userItem objectForKey:@"신규금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] >
					[[[self.D4220 objectForKey:@"세금우대한도잔액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																	message:@"신규금액이 한도잔여액을 초과하였습니다."
																   delegate: nil
														  cancelButtonTitle:@"확인"
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
					return;
				}
			}
			else if (taxval == 2){
				if ([[[self.userItem objectForKey:@"신규금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] >
					[[[self.D4222 objectForKey:@"저축종류별미사용금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] ) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																	message:@"신규금액은 비과세(생계형)한도 잔여액을 초과할 수 없습니다."
																   delegate:nil
														  cancelButtonTitle:@"확인"
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
					return;
				}
				
				
			}
			
			
		}
		
		
	}
	
	if (autotrans) {
		if(autotransval == 1){
			if(![self.dfAutoTransStartDate.textField.text length]){
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:@"자동이체 시작일은 8자리로 입력해주세요."
															   delegate: nil
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				return;
			}
			
//			if (![SHBUtility checkDateValidation:self.tfAutoTransStartDate.text]) {
//				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//																message:@"[자동이체 시작일] - 정확하지 않은 날짜입니다."
//															   delegate: nil
//													  cancelButtonTitle:@"확인"
//													  otherButtonTitles:nil];
//				[alert show];
//				[alert release];
//				return;
//			}
			//한달 구분 validation
			NSArray *dates = [SHBUtility getCurrentDateAgoYear:0 AgoMonth:1 AgoDay:0];
			
			if (dates == nil)
			{
				NSLog(@"dates nil");
				return;
			}
			
			NSString *currentDate = [dates objectAtIndex:1];
			//			NSString *nextDate = [dates objectAtIndex:0];
			if ([self.strAutoTransStartDate intValue] <= [currentDate intValue])
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:@"자동이체 시작일이 현재일이거나 과거일자 입니다."
															   delegate:nil
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				return;
			}
			
			if (![self.dfAutoTransEndDate.textField.text length]){
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:@"자동이체 종료일은 8자리로 입력해주세요."
															   delegate: nil
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				return;
			}
//
//			if (![SHBUtility checkDateValidation:self.tfAutoTransEndDate.text]) {
//				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//																message:@"[자동이체 종료일] - 정확하지 않은 날짜입니다."
//															   delegate: nil
//													  cancelButtonTitle:@"확인"
//													  otherButtonTitles:nil];
//				[alert show];
//				[alert release];
//				return;
//			}
			
			
			NSDateFormatter *formdatter = [[[NSDateFormatter alloc]init]autorelease];
			[formdatter setDateFormat:@"yyyyMMdd"];
			
			NSDate *startDate = [formdatter dateFromString:self.strAutoTransStartDate];
			NSDate *endDate = [formdatter dateFromString:self.strAutoTransEndDate];
			
			NSDateComponents *dateComponents = [[NSCalendar currentCalendar]components:NSMonthCalendarUnit fromDate:startDate toDate:endDate options:0];
			Debug(@"[dateComponents month] : %d", [dateComponents month])
			
//			Debug(@"%@",[SHBUtility getDateMonthAgo:self.strAutoTransStartDate month:-1]);
			
//			if ([self.strAutoTransEndDate intValue] < [ [SHBUtility getDateMonthAgo:self.strAutoTransStartDate month:-1] intValue] - 1)
			if ([dateComponents month] < 1) 
			{
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:@"자동이체 종료일은 적어도 자동이체 시작일의 한달 후가 입력되어야 합니다."
															   delegate:nil
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				return;
			}
            
            NSString *sMonth = [self.strAutoTransStartDate substringWithRange:NSMakeRange(4, 2)];
            NSString *cMonth = [[AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""] substringWithRange:NSMakeRange(4, 2)];
            
            
            
            
            if ([[self.userItem objectForKey:@"적립방식선택"] isEqualToString:@"정기적립식"])
            {
                if ([sMonth isEqualToString:cMonth] )
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"자동이체 시작월을 익월로 입력해 주세요."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"확인"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    return;
                }
                
            }

            
            
            if (taxval == 1 &&
                ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] ||
                [[self.userItem objectForKey:@"적립방식선택"] isEqualToString:@"자유적립식"]))
            {
                // (최초불입금 + 자동이체금액 * 자동이체개월수) > 세금우대 신청금액
                NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
                [outputFormatter setDateFormat:@"yyyyMMdd"];
                
                NSInteger sYear = [[self.strAutoTransStartDate substringToIndex:4] integerValue];
                NSInteger eYear = [[self.strAutoTransEndDate substringToIndex:4] integerValue];
                
                NSInteger sMonth = [[self.strAutoTransStartDate substringWithRange:NSMakeRange(4, 2)] integerValue];
                NSInteger eMonth = [[self.strAutoTransEndDate substringWithRange:NSMakeRange(4, 2)] integerValue];
                
                NSInteger rYear = eYear - sYear;
                NSInteger rMonth = eMonth - sMonth;
                
                NSInteger resultMonth = rYear * 12 + rMonth;
                
                // 신규금액
                long long tmp1 = [[[self.userItem objectForKey:@"신규금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
                // 자동이체금액
                long long tmp2 = [[self.tfAutoTransAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
                // 세금우대 신청금액
                long long tmp3 = [[self.tfTaxBreakAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue];
                
                if (tmp1 + (tmp2 * resultMonth) > tmp3) {
                    [UIAlertView showAlert:nil
                                      type:ONFAlertTypeOneButton
                                       tag:0
                                     title:@""
                                   message:@"신청하신 세금우대 금액 초과시 입금이 불가합니다. 자동이체 금액 또는 기간을 변경 바랍니다."];
                    return;
                }
            }
            
			if(self.tfAutoTransAmount.text == nil || [self.tfAutoTransAmount.text length] == 0){
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:@"자동이체 금액을 입력해주세요"
															   delegate: nil
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				return;
			}
			
			if ([[self.tfAutoTransAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]  <
				[[self.dicSelectedData objectForKey:@"자동이체_최소금액"] longLongValue] ) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:[NSString stringWithFormat:@"자동이체 금액은 %@원 미만이 될 수 없습니다.",
																		 [SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"자동이체_최소금액"]] ]
															   delegate: nil
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				return;
			}
			
			if ([[self.dicSelectedData objectForKey:@"자동이체_최대금액"] longLongValue] != 0  &&
				([[self.tfAutoTransAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]  >
				 [[self.dicSelectedData objectForKey:@"자동이체_최대금액"] longLongValue] )
				) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:[NSString stringWithFormat:@"자동이체 금액은 %@원 초과가 될 수 없습니다.",
																		 [SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"자동이체_최대금액"]] ]
															   delegate: nil
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
				return;
			}
			
			if (![[self.dicSelectedData objectForKey:@"자동이체_분기별가능금액"] isEqualToString:@"0"] &&
				([[self.tfAutoTransAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] * 3 >
				 [[self.dicSelectedData objectForKey:@"자동이체_분기별가능금액"] longLongValue] ) ) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																	message:[NSString stringWithFormat:@"자동이체 금액은 분기별 %@원을 넘을 수 없습니다.",
																			 [SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"자동이체_분기별가능금액"]] ]
																   delegate: nil
														  cancelButtonTitle:@"확인"
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
					return;
				}
			
			
			[self.userItem setObject:@"0" forKey:@"자동이체"];
			[self.userItem setObject:self.strAutoTransStartDate forKey:@"자동이체_시작일"];
			[self.userItem setObject:self.strAutoTransEndDate forKey:@"자동이체_종료일"];
//			[self.userItem setObject:self.tfAutoTransStartDate.text forKey:@"자동이체_시작일"];
//			[self.userItem setObject:self.tfAutoTransEndDate.text forKey:@"자동이체_종료일"];
			[self.userItem setObject:self.tfAutoTransAmount.text forKey:@"자동이체_금액"];
           
			
		}
		else {
			[self.userItem setObject:@"1" forKey:@"자동이체"];
		}
		
	}
	
	if (autoReInput == 1 || autoReInput == 4 || autoReInput == 5) {   //자동 재예치 뷰가 있을 경우 선택 값
		[self.userItem setObject:[NSString stringWithFormat:@"%d",reinputval] forKey:@"자동재예치"];
		
		for (UIButton *btn in self.popupView.marrNotiOptionBtns)
		{
			if ([btn isSelected]) {
				NSString *strOption = btn.dataKey;
				[self.userItem setObject:strOption forKey:@"자동재예치결과통지타입"];
				break;
			}
		}
	}
   	else if (autoReInput == 2){   //뷰없이 원금만 자동재예치
		[self.userItem setObject:@"1" forKey:@"자동재예치"];
		
		for (UIButton *btn in self.popupView.marrNotiOptionBtns)
		{
			if ([btn isSelected]) {
				NSString *strOption = btn.dataKey;
				[self.userItem setObject:strOption forKey:@"자동재예치결과통지타입"];
				break;
			}
		}
	}
	else if (autoReInput == 3){   //뷰없이 원리금 자동재예치
		[self.userItem setObject:@"2" forKey:@"자동재예치"];
		
		for (UIButton *btn in self.popupView.marrNotiOptionBtns)
		{
			if ([btn isSelected]) {
				NSString *strOption = btn.dataKey;
				[self.userItem setObject:strOption forKey:@"자동재예치결과통지타입"];
				break;
			}
		}
	}
	
	
	if (autotrans_On ==YES && tax_On == YES)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[NSString stringWithFormat:@"세금우대, 비과세(생계형) 설정액\n이상으로는 자동이체 및 불입이\n안됩니다."]
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
        alert.tag=100;
        [alert show];
        [alert release];
        return;
        
    }
#endif
    
    // 청약이 아니고, 자동이체가 가능하며, 자동이체를 신청한 경우
    if (![[self.dicSelectedData objectForKey:@"청약여부"] isEqualToString:@"1"]) {
        if (autotrans) {
            if(autotransval == 1) {
                NSString *endDate = [self.strAutoTransEndDate substringToIndex:6];
                
                NSString *expiryDate = [SHBUtility dateStringToMonth:[[self.userItem objectForKey:@"계약기간"] intValue] toDay:0];
                expiryDate = [expiryDate stringByReplacingOccurrencesOfString:@"." withString:@""];
                expiryDate = [expiryDate substringToIndex:6];
                
                self.service = [[[SHBProductService alloc] initWithServiceId:XDA_CHECK_MON viewController:self] autorelease];
                self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
                                                                                  TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
                                                                                  TASK_ACTION_KEY : @"getCheckMon",
                                                                                  @"종료월" : endDate,
                                                                                  @"만기월" : expiryDate }];
                [self.service start];
                
                return;
            }
        }
    }
    
    [self moveToNextView];
}

- (void)moveToNextView
{
    AppInfo.certProcessType = CertProcessTypeNo;
	SHBNewProductSignUpViewController *viewController = [[SHBNewProductSignUpViewController alloc]initWithNibName:@"SHBNewProductSignUpViewController" bundle:nil];
	viewController.dicSelectedData = self.dicSelectedData;
    viewController.dicSmartNewData = self.dicSmartNewData;
	viewController.userItem = self.userItem;
	viewController.needsLogin = YES;
    
    if([self.stepNumber isEqualToString:@"예금적금 가입 4단계" ])
    {
        viewController.stepNumber = @"예금적금 가입 5단계"; //5단계 (주택청약일때)
    }
    else
    {
        viewController.stepNumber = @"예금적금 가입 4단계";
    }
    
    
    
	[self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
//	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
//	{
//		if ([viewController isKindOfClass:[SHBNewProductStipulationViewController class]]) {
//			[self.navigationController popToViewController:viewController animated:YES];
//		}
//	}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewProductCancel" object:nil];
    
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
	if (alertView.tag == 337337) {
		//[self showAutoReInputNotiPopupView];
        return;
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
	
	if (textField == self.tfTaxBreakAmount) {	// 세금우대신청금액
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
	else if (textField == self.tfAutoTransAmount)	// 자동이체금액
	{
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


#pragma mark - SHBDateField Delegate
- (void)dateField:(SHBDateField*)dateField didConfirmWithDate:(NSDate*)date
{
	NSDateFormatter *dateFormater = [[[NSDateFormatter alloc]init]autorelease];
	[dateFormater setDateFormat:@"yyyyMMdd"];
	
	if (dateField == self.dfAutoTransStartDate) {
		self.strAutoTransStartDate = [dateFormater stringFromDate:date];
        
        [self defaultValueSetting];
	}
	else if (dateField == self.dfAutoTransEndDate) {
		self.strAutoTransEndDate = [dateFormater stringFromDate:date];
	}
	
}

- (void)dateField:(SHBDateField*)dateField changeDate:(NSDate*)date
{
}

- (void)currentDateField:(SHBDateField*)dateField
{
}

#pragma mark - Http Delegate
- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
	if (AppInfo.errorType != nil) {
		return NO;
	}
	
	return YES;
}

- (BOOL) onBind: (OFDataSet*) aDataSet
{
    Debug(@"aDataSet : %@", aDataSet);
	
	if (self.service.serviceId == kD4220Id) {
		self.D4220 = aDataSet;
		
		[self.lblTopRow1Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대가입총액"]]];
		[self.lblTopRow2Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대한도잔액"]]];
		
		[self setTaxView];
		
		tax = YES;
		
		self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00001_1 viewController:self]autorelease];	// D3602
		[self.service start];
	}
	else if (self.service.serviceId == XDA_S00001_1) {
		self.D3602 = aDataSet;
		
		[self setTaxGuideView];
		
		if ([[self.dicSelectedData objectForKey:@"자동이체_가능여부"] isEqualToString:@"1"]) {
			[self setAutoTransView];
			
			autotrans = YES;
			autotransval = 1;
			autotrans_On = YES;
		}
		
		if ([[self.dicSelectedData objectForKey:@"재예치가능여부"] isEqualToString:@"1"]
			|| [[self.dicSelectedData objectForKey:@"재예치가능여부"] isEqualToString:@"4"]
			|| [[self.dicSelectedData objectForKey:@"재예치가능여부"] isEqualToString:@"5"]) {
			[self setAutoReInputView];
			
			reinputval = 0;
			autoReInput = [[self.dicSelectedData objectForKey:@"재예치가능여부"]intValue];
		}
		
		if ([[self.dicSelectedData objectForKey:@"청약여부"] isEqualToString:@"1"]) {
			[self setInfoView];
		}
		
		[self setBottomView];
        
        if (_dicSmartNewData) { // 스마트신규인 경우 자동이체 신청여부에 따라 세팅
            for (UIButton *btn in self.marrAutoTransRadioBtns) {
                if ([btn.dataKey isEqualToString:_dicSmartNewData[@"_자동이체신청여부"]]) {
                    [self autoTransRadioBtnAction:btn];
                    
                    break;
                }
            }
        }
	}
	else if (self.service.serviceId == kD4222Id) {
		self.D4222 = aDataSet;
		[self taxFreeOn];
	}
    else if (self.service.serviceId == XDA_CHECK_MON) {
        [self moveToNextView];
    }
	
	/*		D4220
	  {
	 주민사업자구분 = 1;
	 세금우대중복여부 = 0;
	 COM_JSTAR_VALUE = SHB01          234          27;
	 COM_EF_TIME = 154550;
	 세금우대한도잔액 = 0;
	 응답코드 = 501;
	 COM_SEC_CHK = ;
	 COM_UPMU_GBN = R;
	 COM_JUMIN_NO = 7511271132228;
	 COM_CIF_NO = 604628380;
	 COM_WEB_DOMAIN = etcwb1t1;
	 COM_NO_SEND = ;
	 COM_SEC_CHAL1 = ;
	 거래건수->target = 세금우대한도;
	 고객명 = ;
	 주민사업자번호 = 0;
	 세금우대한도잔액->originalValue = 0;
	 COM_TRAN_TIME = 15:45:50;
	 COM_SUBCHN_KBN = 02;
	 COM_RESULT_CD = 0;
	 COM_CHANNEL_KBN = DT;
	 세금우대한도잔액->setSession = 세금우대한도잔액;
	 거래건수 = 1;
	 세금우대가입총액->originalValue = 0;
	 추가전문번호 = 0;
	 COM_EF_YOIL = 5;
	 COM_SYS_GBN = T;
	 세금우대등록건수 = 0;
	 COM_ECHO_TYPE = ;
	 COM_EF_DATE = 20121019;
	 COM_TRAN_DATE = 2012.10.19;
	 세금우대한도 = {
	 vector = {
	 data = {
	 R_RIBD4220_1 = {
	 변경일 = 0;
	 해지일->originalValue = 0;
	 상품구분 = ;
	 해지여부 = 0;
	 상속여부 = 0;
	 해지일 = 0;
	 이자배당지급액->originalValue = 0;
	 가입금액->originalValue = 0;
	 계좌번호->originalValue = ;
	 등록점포명 = ;
	 상품구분->getCode = good_code;
	 만기일->originalValue = 0;
	 가입금액 = 0;
	 이자배당지급액 = 0;
	 만기일 = 0;
	 신규일 = 0;
	 변경일->originalValue = 0;
	 신규일->originalValue = 0;
	 계좌번호 = ;
	 주택청약부금구분 = 0;
	 }
	 ;
	 }
	 ;
	 }
	 ;
	 }
	 ;
	 COM_USER_ERR = 0;
	 COM_YEYAK_ICHE = ;
	 COM_SVC_CODE = D4220;
	 세금우대총한도 = 0;
	 COM_ICHEPSWD_CHK = ;
	 정보주체구분 = 0;
	 COM_FILLER1 = ;
	 COM_SEC_CHAL2 = ;
	 COM_LANGUAGE = 1;
	 COM_EF_SERIALNO = 20346806;
	 COM_IP_ADDR = 59.7.254.139;
	 COM_TRAN_TIME->originalValue = 154550;
	 COM_PKTLEN = 426;
	 COM_TRAN_DATE->originalValue = 20121019;
	 상호 = ;
	 저소득자구분 = 0;
	 COM_PG_SERIAL = ;
	 세금우대총한도->originalValue = 0;
	 COM_FILLER2 = ;
	 COM_END_MARK = ZZ;
	 회보건수 = 0;
	 세금우대가입총액 = 0;
	 }
	 
	 */
	
	/**		D3602
	 세금우대_안내5 = ;
	 세금우대_안내1 = - 세금우대를 적용 받으려면 1년 이상 예치해야 하며, 전 금융기관에 세금우대 적용된 금액을 합하여 1인당 원금기준 1천만원 (장애인 또는 만60세 이상은 3천만원)까지 가입 가능합니다.;
	 COMBLOCK->reference = COMMON;
	 세금우대_안내4 = ;
	 세금우대_안내3 = - 2009.1.1일 개정된 조세특례제한법 기준 ;
	 세금우대_안내2 = - 생계형은 가입대상 (만60세 이상 또는 장애인 및 국가유공자 - 장애인 및 국가유공자는 영업점에서  대상등록 필요) 에 대해 세금우대한도 외 3천만원까지 가입 가능합니다.;
	 */
    return NO;
}

@end
