//
//  SHBUDreamStipulationViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUDreamStipulationViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"
#import "SHBUDreamStipulationView.h"
#import "SHBUdreamSecurityViewController.h"
#import "SHBNewProductSeeStipulationViewController.h"

@interface SHBUDreamStipulationViewController ()
{
	CGFloat fCurrHeight;
	
	BOOL isEssentialAgree;		// 필수정보동의여부
	BOOL isMarketingAgree;		// 마케팅활용동의여부
    BOOL _isBackMarketingAgree;
	
	BOOL isReadStipulation1;	// 약관
	BOOL isReadStipulation2;	// 마케팅 약관
	BOOL isReadStipulation3;	// 필수정보 약관
	BOOL isLastAgreeCheck;
}

@property (nonatomic, retain) NSMutableArray *marrEssentialRadioBtns1_1;	// 필수적 정보
@property (nonatomic, retain) NSMutableArray *marrEssentialRadioBtns1_2;	// 선택적 정보
@property (nonatomic, retain) NSMutableArray *marrEssentialRadioBtns2;		// 고유식별 정보
@property (nonatomic, retain) NSMutableArray *marrMarketingRadioBtns;		// 마케팅활용동의 라디오버튼
@property (retain, nonatomic) NSDictionary *marketingAgreeDic;      // 마케팅활용동의, 필수정보동의 웹뷰에서 넘어온 데이터

@end

@implementation SHBUDreamStipulationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		isEssentialAgree = YES;
		isMarketingAgree = YES;
    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
    
    self.marketingAgreeDic = nil;
    
	[_marrEssentialRadioBtns1_1 release];
	[_marrEssentialRadioBtns1_2 release];
	[_marrEssentialRadioBtns2 release];
	[_marrMarketingRadioBtns release];
	[_userItem release];
	[_questionView release];
	[_bottomView release];
	[_scrollView release];
    [_marketingWV release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setQuestionView:nil];
	[self setBottomView:nil];
	[self setScrollView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"U드림 저축예금 전환"];
    self.strBackButtonTitle = @"U드림 저축예금 전환 1단계";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.marketingWV.delegate = self;
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"약관동의 및 상품 설명서" maxStep:3 focusStepNumber:1]autorelease]];
	
	self.service = [[[SHBProductService alloc]initWithServiceId:kC2800Id viewController:self]autorelease];
	[self.service start];
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userReadStipulation:) name:@"UserPressedConfirmButton" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];
}


- (void)getElectronicSignCancel
{
	Debug(@"getElectronicSignCancel");
    
    isReadStipulation1 = NO;
    isReadStipulation2 = NO;
    isReadStipulation3 = NO;
    isLastAgreeCheck = NO;
    
    [self.btn_lastAgreeCheck setSelected:NO];
    
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBUDreamStipulationViewController class]]) {
			[self.navigationController fadePopToViewController:viewController];
            
            
		}
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
	[self.scrollView flashScrollIndicators];
}

#pragma mark - Notification
- (void)userReadStipulation:(NSNotification *)noti
{	
	NSString *strUrl = [[noti userInfo]objectForKey:@"url"];
	
	if ([strUrl hasSuffix:@"yak_agree.html"]) {
		isReadStipulation2 = YES;
	}
	else if ([strUrl hasSuffix:@"pci_lending_02.html"]) {
		isReadStipulation3 = YES;
	}
	else
	{
		isReadStipulation1 = YES;
	}
}

#pragma mark - UI
- (void)setStipulationView
{
	CGFloat fHeight = 20;
	
	NSString *strGuide = @"아래의 설명서 및 약관 선택하여 내용을 본 후 약관에 동의 해야 다음단계로 진행할 수 있습니다.";
	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByWordWrapping];
	
	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(8, fHeight, 301, size.height)]autorelease];
	[lblGuide setNumberOfLines:0];
	[lblGuide setBackgroundColor:[UIColor clearColor]];
	[lblGuide setTextColor:RGB(44, 44, 44)];
	[lblGuide setFont:[UIFont systemFontOfSize:14]];
	[lblGuide setText:strGuide];
	[self.scrollView addSubview:lblGuide];
	fHeight += size.height + 8;
	
	UIImage *image = [UIImage imageNamed:@"box_consent.png"];
	UIImageView *ivStipulationBG = [[[UIImageView alloc]initWithImage:[image stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[ivStipulationBG setBackgroundColor:[UIColor clearColor]];
	[ivStipulationBG setFrame:CGRectMake(10, fHeight, 300, 4 * kRowHeight)];
	[ivStipulationBG setUserInteractionEnabled:YES];
	[self.scrollView addSubview:ivStipulationBG];
	
	SHBUDreamStipulationView *stipulationView = [[[SHBUDreamStipulationView alloc]initWithFrame:CGRectMake(0, 0, 300, 4 * kRowHeight)]autorelease];
	[stipulationView setParentViewController:self];
	[ivStipulationBG addSubview:stipulationView];
	fHeight += (4 * kRowHeight);
	
	fCurrHeight = fHeight + 9;
	FrameReposition(self.questionView, left(self.questionView), fCurrHeight);
	fCurrHeight += 68;
	
	[self repositionBottomView];
}

- (void)setEssentialView	// 필수정보동의
{
    /*
	UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=12, 317, 1)]autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[self.scrollView addSubview:lineView];
	
	UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight+= 4, 301, 34+10+10)]autorelease];
	[lblTitle setNumberOfLines:0];
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[lblTitle setTextColor:RGB(44, 44, 44)];
	[lblTitle setFont:[UIFont systemFontOfSize:15]];
	[lblTitle setText:@"개인(신용)정보 수집,이용,동의서(비여신 금융거래)및 고객권리 안내문"];
	[self.scrollView addSubview:lblTitle];
	fCurrHeight += 34+10;
	
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[ivInfoBox setUserInteractionEnabled:YES];
	[self.scrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 5;
	
	UILabel *lblYakTitle = [[[UILabel alloc]initWithFrame:CGRectMake(5, fHeight, 235, 29)]autorelease];
	[lblYakTitle setNumberOfLines:0];
	[lblYakTitle setBackgroundColor:[UIColor clearColor]];
	[lblYakTitle setTextColor:RGB(44, 44, 44)];
	[lblYakTitle setFont:[UIFont systemFontOfSize:15]];
	[lblYakTitle setText:@"개인(신용)정보 수집,이용 동의서"];
	[ivInfoBox addSubview:lblYakTitle];
	
	SHBButton *btnSee = [SHBButton buttonWithType:UIButtonTypeCustom];
	[btnSee setFrame:CGRectMake(245, fHeight, 60, 29)];
	[btnSee setBackgroundImage:[UIImage imageNamed:@"btn_ctype3"] forState:UIControlStateNormal];
	[btnSee setBackgroundImage:[UIImage imageNamed:@"btn_ctype3_focus"] forState:UIControlStateHighlighted];
	[btnSee.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
	[btnSee.titleLabel setTextColor:[UIColor whiteColor]];
	[btnSee setTitle:@"보기" forState:UIControlStateNormal];
	[btnSee addTarget:self action:@selector(essentialStipulationBtnAction) forControlEvents:UIControlEventTouchUpInside];
	[ivInfoBox addSubview:btnSee];
	
	fHeight += 29+5;
	
	NSString *strGuide = @"'개인(신용) 정보 수집, 이용 및 제공(비여신금융거래)' 중 고유 식별정보(주민번호 등), 필수 정보(이름, 전화번호, 이메일 등) 및 선택적 정보(주거, 가족사항, 결혼여부 등)의 수집 및 이용등 처리에 동의하셔야 합니다.";
	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
	
	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5, fHeight, 301, size.height)]autorelease];
	[lblGuide setNumberOfLines:0];
	[lblGuide setBackgroundColor:[UIColor clearColor]];
	[lblGuide setTextColor:RGB(74, 74, 74)];
	[lblGuide setFont:[UIFont systemFontOfSize:13]];
	[lblGuide setText:strGuide];
	[ivInfoBox addSubview:lblGuide];
	
	fHeight += size.height + 5;
	
	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight+=10, 311, fHeight)];
	fCurrHeight += fHeight;
	
	NSString *str1 = @"1. 신한은행이 개인정보 수집, 이용, 제공 동의서(비여신 금융거래)와 같이 본인의 개인정보를 수집, 이용하는 것에 동의합니다.";
	size = [str1 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
	UILabel *lbl1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 10+size.height+10)]autorelease];
	[lbl1 setNumberOfLines:0];
	[lbl1 setBackgroundColor:[UIColor clearColor]];
	[lbl1 setTextColor:RGB(44, 44, 44)];
	[lbl1 setFont:[UIFont systemFontOfSize:15]];
	[lbl1 setText:str1];
	[self.scrollView addSubview:lbl1];
	fCurrHeight += 10+size.height+10;
	
	{	// 필수적 정보
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 10+15+10+21+10)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 10+15+10+21+10;
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(12, 9+4, 7, 7)];
		[ivBox2 addSubview:ivBullet];
		
		UILabel *lblRequired = [[[UILabel alloc]initWithFrame:CGRectMake(left(ivBullet)+7+3, 0, 301, 10+15+10)]autorelease];
		[lblRequired setNumberOfLines:0];
		[lblRequired setBackgroundColor:[UIColor clearColor]];
		[lblRequired setTextColor:RGB(44, 44, 44)];
		[lblRequired setFont:[UIFont systemFontOfSize:15]];
		[lblRequired setText:@"필수적 정보"];
		[ivBox2 addSubview:lblRequired];
		
		self.marrEssentialRadioBtns1_1 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(essential1_1RadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrEssentialRadioBtns1_1 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 10+15+10, 21, 21)];
				[btnRadio setSelected:YES];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 10+15+10, 21, 21)];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 10+15+10, 100, 21)];
		}
	}
	
	fCurrHeight += 5;
	{	// 선택적 정보
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 10+15+10+21+10)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 10+15+10+21+10;
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(12, 10+4, 7, 7)];
		[ivBox2 addSubview:ivBullet];
		
		UILabel *lblOptional = [[[UILabel alloc]initWithFrame:CGRectMake(left(ivBullet)+7+3, 0, 301, 10+15+10)]autorelease];
		[lblOptional setNumberOfLines:0];
		[lblOptional setBackgroundColor:[UIColor clearColor]];
		[lblOptional setTextColor:RGB(44, 44, 44)];
		[lblOptional setFont:[UIFont systemFontOfSize:15]];
		[lblOptional setText:@"선택적 정보"];
		[ivBox2 addSubview:lblOptional];
		
		self.marrEssentialRadioBtns1_2 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(essential1_2RadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrEssentialRadioBtns1_2 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 10+15+10, 21, 21)];
				
//				if ([[self.data objectForKey:@"선택정보동의여부"]isEqualToString:@"1"]) {
//					[btnRadio setSelected:YES];
//				}
//				else
//				{
//					[btnRadio setSelected:NO];
//				}
				
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 10+15+10, 21, 21)];
				
//				if (![[self.data objectForKey:@"선택정보동의여부"]isEqualToString:@"1"]) {
//					[btnRadio setSelected:YES];
//				}
//				else
//				{
//					[btnRadio setSelected:NO];
//				}
				[btnRadio setSelected:YES];
				
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 10+15+10, 100, 21)];
		}
	}
	
	NSString *str2 = @"2. 신한은행이 개인정보 수집, 이용, 제공 동의서(비여신금융거래)와 같이 본인의 고유 식별 정보를 수집, 이용하는 것에 동의 합니다.";
	size = [str2 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
	UILabel *lbl2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 10+size.height+10)]autorelease];
	[lbl2 setNumberOfLines:0];
	[lbl2 setBackgroundColor:[UIColor clearColor]];
	[lbl2 setTextColor:RGB(44, 44, 44)];
	[lbl2 setFont:[UIFont systemFontOfSize:15]];
	[lbl2 setText:str2];
	[self.scrollView addSubview:lbl2];
	fCurrHeight += 10+size.height+10;
	
	{	// 고유식별 정보
		NSString *strDistinct = @"고유식별 정보 : 주민등록번호, 여권번호, 운전면허번호, 외국인등록번호";
		size = [strDistinct sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(260, 999) lineBreakMode:NSLineBreakByWordWrapping];
		
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 10+size.height+10+21+10)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 10+size.height+10+21+10;
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(12, 10+4, 7, 7)];
		[ivBox2 addSubview:ivBullet];
		
		
		UILabel *lblDistinct = [[[UILabel alloc]initWithFrame:CGRectMake(left(ivBullet)+7+3, 0, 260, 10+size.height+10)]autorelease];
		[lblDistinct setNumberOfLines:0];
		[lblDistinct setBackgroundColor:[UIColor clearColor]];
		[lblDistinct setTextColor:RGB(44, 44, 44)];
		[lblDistinct setFont:[UIFont systemFontOfSize:15]];
		[lblDistinct setText:strDistinct];
		[ivBox2 addSubview:lblDistinct];
		
		self.marrEssentialRadioBtns2 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(essential2RadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrEssentialRadioBtns2 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 10+size.height+10, 21, 21)];
				[btnRadio setSelected:YES];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 10+size.height+10, 21, 21)];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 10+size.height+10, 100, 21)];
		}
	}
     */
}

- (void)setMarketingView
{
    // 마케팅활용동의
    
    [self navigationBackButtonHidden];
    
    NSMutableString *URL = [NSMutableString stringWithFormat:@"https://%@.shinhan.com/sbank/marketing/marketing_info.jsp?", AppInfo.realServer ? @"m" : @"dev-m"];
    
    NSDictionary *dic = @{ @"마케팅활용동의여부" : self.data[@"마케팅활용동의여부"],
                           @"필수정보동의여부" : self.data[@"필수정보동의여부"],
                           @"선택정보동의여부" : self.data[@"선택정보동의여부"],
                           @"자택TM통지요청구분" : self.data[@"자택TM통지요청구분"],
                           @"직장TM통지요청구분" : self.data[@"직장TM통지요청구분"],
                           @"휴대폰통지요청구분" : self.data[@"휴대폰통지요청구분"],
                           @"SMS통지요청구분" : self.data[@"SMS통지요청구분"],
                           @"EMAIL통지요청구분" : self.data[@"EMAIL통지요청구분"],
                           @"DM희망지주소구분" : self.data[@"DM희망지주소구분"],
                           @"VERSION" : [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                           @"COM_SUBCHN_KBN" : CHANNEL_CODE };
    
    BOOL isFirst = YES;
    
    for (NSString *key in [dic allKeys]) {
        
        if (isFirst) {
            
            isFirst = NO;
            
            [URL appendFormat:@"%@=%@", key, dic[key]];
        }
        else {
            
            [URL appendFormat:@"&%@=%@", key, dic[key]];
        }
    }
    
    NSString *strURL = [(NSString *)URL stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    
    [_marketingWV loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strURL]]]];
    
    [[[_marketingWV subviews] lastObject] setBounces:NO];
    [_marketingWV setHidden:NO];
    
    [_scrollView setHidden:YES];
    
    /*
	UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=12, 317, 1)]autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[self.scrollView addSubview:lineView];
	
	UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight+= 4, 301, 34+10+10)]autorelease];
	[lblTitle setNumberOfLines:0];
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[lblTitle setTextColor:RGB(44, 44, 44)];
	[lblTitle setFont:[UIFont systemFontOfSize:15]];
	[lblTitle setText:@"개인(신용)정보 수집,이용,제공 동의서(상품서비스 안내 등)및 관련 고객권리 안내문"];
	[self.scrollView addSubview:lblTitle];
	fCurrHeight += 34+10;
	
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[ivInfoBox setUserInteractionEnabled:YES];
	[self.scrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 5;
	NSString *strGuide = @"개인(신용)정보 수집,이용,제공 동의서";
	
	UILabel *lblYakTitle = [[[UILabel alloc]initWithFrame:CGRectMake(5, fHeight, 235, 29)]autorelease];
	[lblYakTitle setNumberOfLines:0];
	[lblYakTitle setBackgroundColor:[UIColor clearColor]];
	[lblYakTitle setTextColor:RGB(44, 44, 44)];
	[lblYakTitle setFont:[UIFont systemFontOfSize:15]];
	[lblYakTitle setText:strGuide];
	[ivInfoBox addSubview:lblYakTitle];
	
	SHBButton *btnSee = [SHBButton buttonWithType:UIButtonTypeCustom];
	[btnSee setFrame:CGRectMake(245, fHeight, 60, 29)];
	[btnSee setBackgroundImage:[UIImage imageNamed:@"btn_ctype3"] forState:UIControlStateNormal];
	[btnSee setBackgroundImage:[UIImage imageNamed:@"btn_ctype3_focus"] forState:UIControlStateHighlighted];
	[btnSee.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
	[btnSee.titleLabel setTextColor:[UIColor whiteColor]];
	[btnSee setTitle:@"보기" forState:UIControlStateNormal];
	[btnSee addTarget:self action:@selector(marketingStipulationBtnAction) forControlEvents:UIControlEventTouchUpInside];
	[ivInfoBox addSubview:btnSee];
	
	fHeight += 29 + 5;
	
	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight+=12, 311, fHeight)];
	fCurrHeight += fHeight;
	
	
	UILabel *lblQuestion = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 10+15+10)]autorelease];
	[lblQuestion setBackgroundColor:[UIColor clearColor]];
	[lblQuestion setTextColor:RGB(44, 44, 44)];
	[lblQuestion setFont:[UIFont systemFontOfSize:15]];
	[lblQuestion setText:@"위 약관에 동의 하십니까?"];
	[self.scrollView addSubview:lblQuestion];
	fCurrHeight += 10+15+10;
	
	self.marrMarketingRadioBtns = [NSMutableArray array];
	for (int nIdx=0; nIdx<2; nIdx++) {
		UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
		[btnRadio addTarget:self action:@selector(marketingRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.scrollView addSubview:btnRadio];
		[self.marrMarketingRadioBtns addObject:btnRadio];
		
		UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
		[lblRadio setBackgroundColor:[UIColor clearColor]];
		[lblRadio setTextColor:RGB(74, 74, 74)];
		[lblRadio setFont:[UIFont systemFontOfSize:15]];
		[self.scrollView addSubview:lblRadio];
		
		if (nIdx == 0) {
			[btnRadio setFrame:CGRectMake(23, fCurrHeight, 21, 21)];
			[lblRadio setText:@"동의함"];
		}
		else if (nIdx == 1) {
			[btnRadio setFrame:CGRectMake(155, fCurrHeight, 21, 21)];
			[lblRadio setText:@"동의하지 않음"];
		}
		
		[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, fCurrHeight, 100, 21)];
	}
	
	fCurrHeight += 21;
     */
}

- (void)repositionBottomView
{
	CGFloat fBottomHeight = fCurrHeight;
	FrameReposition(self.bottomView, left(self.bottomView), fBottomHeight += 22);
	[self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, fBottomHeight += 29+12)];
	[self.scrollView flashScrollIndicators];
}

#pragma mark - Action

- (void)navigationButtonPressed:(id)sender
{
    if ([sender tag] == NAVI_BACK_BTN_TAG) {
        
        if (_isBackMarketingAgree && [_marketingWV isHidden]) {
            
            _isBackMarketingAgree = NO;
            isReadStipulation1 = NO;
            isReadStipulation2 = NO;
            isLastAgreeCheck = NO;
            
            [self.btn_lastAgreeCheck setSelected:NO];
            
            [self navigationBackButtonHidden];
            
            [_marketingWV setHidden:NO];
            [_scrollView setHidden:YES];
            
            return;
        }
    }
    
    [super navigationButtonPressed:sender];
}

- (void)stipulationItemPressed:(UITapGestureRecognizer *)sender
{
	Debug(@"sender : %@", sender);
	Debug(@"sender.view.tag : %d", sender.view.tag);
	// 각 약관 눌렀을때의 처리 구현 : 안하기로 함.
}

- (void)seeBtnAction:(UIButton *)sender {
	NSString *strUrl;
     if (!AppInfo.realServer)
     {
         strUrl = [NSString stringWithFormat:@"%@yak_110000501.html", URL_YAK_TEST];
	 }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@yak_110000501.html", URL_YAK];
    }
	SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc]initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil]autorelease];
	viewController.strUrl = strUrl;
    viewController.strName = @"U드림저축예금 전환";
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

- (IBAction)agreeCheckBtnAction:(UIButton *)sender {
	[sender setSelected:!sender.selected];
	
	isLastAgreeCheck = [sender isSelected];
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
#if 1
	NSString *strMsg = nil;
//    UIButton *Market_btn1 = (UIButton *)[self.marrMarketingRadioBtns objectAtIndex:0];
//    UIButton *Market_btn2 = (UIButton *)[self.marrMarketingRadioBtns objectAtIndex:1];
    
	if (!isReadStipulation1) {
		strMsg = @"약관을 읽고 \"확인\"을 눌러주시길 바랍니다.";
	}
	else if (!isLastAgreeCheck) {
		strMsg = @"동의하기를 체크해야 다음 단계로 넘어갈 수 있습니다.";
	}
    /*
	else if (isMarketingAgree == NO && !isReadStipulation2) {
	
        strMsg = @"개인(신용)정보 수집•이용•제공 동의서(상품서비스 안내 등) 및 관련 고객권리 안내문을 선택하여 확인하시기 바랍니다.";
	}
    
    else if (isReadStipulation2 && [Market_btn1 isSelected] == NO  &&  [Market_btn2 isSelected] == NO ) {     //마케팅동의
            strMsg = @"개인(신용)정보 수집•이용•제공 이용동의 여부를 선택하시기 바랍니다.";
    }
	else if (isEssentialAgree == NO) {
		if (!isReadStipulation3) {
			strMsg = @"개인(신용)정보 조회 동의서 / 개인(신용) 정보수집•이용•제공 동의서(비여신 금융거래) 및 고객권리 안내문을 선택하여 확인하시기 바랍니다.";
		}
		else
		{
			UIButton *btn = (UIButton *)[self.marrEssentialRadioBtns1_1 objectAtIndex:0];
			if ([btn isSelected] == NO) {
				strMsg = @"1번 필수적정보는 반드시 동의하셔야 합니다.";
			}
			
			btn = (UIButton *)[self.marrEssentialRadioBtns2 objectAtIndex:0];
			if ([btn isSelected] == NO) {
				strMsg = @"2번 고유식별정보는 반드시 동의하셔야 합니다.";
			}
		}
	}
	*/
	if (strMsg) {
		[[[[UIAlertView alloc]initWithTitle:@"" message:strMsg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil]autorelease]show];
		
		return;
	}
#endif
	
	self.userItem = [NSMutableDictionary dictionary];
//	if (isMarketingAgree == NO) {
//		NSString *strVal = [(UIButton *)[self.marrMarketingRadioBtns objectAtIndex:0]isSelected] ? @"1" : @"2";
//		[self.userItem setObject:strVal forKey:@"정보동의"];		// 가입확인 페이지에서 C2316 전문 보낼때 사용
//	}
    
    
    
    if (isMarketingAgree == NO && isEssentialAgree == YES) {
        
        // 마케팅 동의만 그릴 때
        
		[self.userItem setObject:_marketingAgreeDic[@"마케팅활용동의여부"] forKey:@"정보동의"];
		[self.userItem setObject:_marketingAgreeDic[@"자택TM통지요청구분"] forKey:@"_자택TM통지요청구분"];
        [self.userItem setObject:_marketingAgreeDic[@"직장TM통지요청구분"] forKey:@"_직장TM통지요청구분"];
        [self.userItem setObject:_marketingAgreeDic[@"휴대폰통지요청구분"] forKey:@"_휴대폰통지요청구분"];
        [self.userItem setObject:_marketingAgreeDic[@"SMS통지요청구분"] forKey:@"_SMS통지요청구분"];
        [self.userItem setObject:_marketingAgreeDic[@"EMAIL통지요청구분"] forKey:@"_EMAIL통지요청구분"];
        [self.userItem setObject:_marketingAgreeDic[@"DM희망지주소구분"] forKey:@"_DM희망지주소구분"];
        
		if ([_marketingAgreeDic[@"마케팅활용동의여부"] isEqualToString:@"1"]) {
            
			[self.userItem setObject:@"마케팅동의구분" forKey:@"동의구분"];
		}
		else {
            
			[self.userItem setObject:@"마케팅동의안함" forKey:@"동의구분"];
		}
        
        // C2315 내려온 값 그대로 셋팅
		[self.userItem setObject:self.data[@"필수정보동의여부"] forKey:@"필수정보동의여부"];
		[self.userItem setObject:self.data[@"선택정보동의여부"] forKey:@"선택정보동의여부"];
	}
	else if (isMarketingAgree == YES && isEssentialAgree == NO) {
        
        // 필수적 동의만 그릴 때
        
		[self.userItem setObject:_marketingAgreeDic[@"필수정보동의여부"] forKey:@"필수적정보동의"];
		[self.userItem setObject:_marketingAgreeDic[@"선택정보동의여부"] forKey:@"선택정보동의여부"];
		[self.userItem setObject:@"필수적정보동의구분" forKey:@"동의구분"];
        
        // C2315 내려온 값 그대로 셋팅
		[self.userItem setObject:self.data[@"마케팅활용동의여부"] forKey:@"마케팅활용동의여부"];
        [self.userItem setObject:self.data[@"자택TM통지요청구분"] forKey:@"_자택TM통지요청구분"];
        [self.userItem setObject:self.data[@"직장TM통지요청구분"] forKey:@"_직장TM통지요청구분"];
        [self.userItem setObject:self.data[@"휴대폰통지요청구분"] forKey:@"_휴대폰통지요청구분"];
        [self.userItem setObject:self.data[@"SMS통지요청구분"] forKey:@"_SMS통지요청구분"];
        [self.userItem setObject:self.data[@"EMAIL통지요청구분"] forKey:@"_EMAIL통지요청구분"];
        [self.userItem setObject:self.data[@"DM희망지주소구분"] forKey:@"_DM희망지주소구분"];
	}
	else if (isMarketingAgree == NO && isEssentialAgree == NO) {
        
        // 둘다 그릴 때
        
		[self.userItem setObject:_marketingAgreeDic[@"마케팅활용동의여부"] forKey:@"정보동의"];
		
		if ([_marketingAgreeDic[@"마케팅활용동의여부"] isEqualToString:@"2"]) {
            
			[self.userItem setObject:@"필수적정보동의구분" forKey:@"동의구분"];
		}
		else {
            
			[self.userItem setObject:@"마케팅과필수적정보동의구분" forKey:@"동의구분"];
		}
		
		[self.userItem setObject:_marketingAgreeDic[@"필수정보동의여부"] forKey:@"필수적정보동의"];
		[self.userItem setObject:_marketingAgreeDic[@"선택정보동의여부"] forKey:@"선택정보동의여부"];
        [self.userItem setObject:_marketingAgreeDic[@"자택TM통지요청구분"] forKey:@"_자택TM통지요청구분"];
        [self.userItem setObject:_marketingAgreeDic[@"직장TM통지요청구분"] forKey:@"_직장TM통지요청구분"];
        [self.userItem setObject:_marketingAgreeDic[@"휴대폰통지요청구분"] forKey:@"_휴대폰통지요청구분"];
        [self.userItem setObject:_marketingAgreeDic[@"SMS통지요청구분"] forKey:@"_SMS통지요청구분"];
        [self.userItem setObject:_marketingAgreeDic[@"EMAIL통지요청구분"] forKey:@"_EMAIL통지요청구분"];
        [self.userItem setObject:_marketingAgreeDic[@"DM희망지주소구분"] forKey:@"_DM희망지주소구분"];
	}

    
    
	
	SHBUdreamSecurityViewController *viewController = [[SHBUdreamSecurityViewController alloc]initWithNibName:@"SHBUdreamSecurityViewController" bundle:nil];
	viewController.userItem = self.userItem;
	viewController.needsLogin = YES;
	[self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
}

- (IBAction)cancelBtnAction:(SHBButton *)sender
{
    if (_isBackMarketingAgree && [_marketingWV isHidden]) {
        
        _isBackMarketingAgree = NO;
        
        isReadStipulation1 = NO;
        isReadStipulation2 = NO;
        isLastAgreeCheck = NO;
        
        [self.btn_lastAgreeCheck setSelected:NO];
        
        [self setMarketingView];
        
        return;
    }
    
	[self.navigationController fadePopToRootViewController];
}

- (void)essential1_1RadioBtnAction:(UIButton *)sender	// 1-1. 필수적정보 라디오버튼
{
	for (UIButton *btn in self.marrEssentialRadioBtns1_1)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)essential1_2RadioBtnAction:(UIButton *)sender	// 1-2. 선택적정보 라디오버튼
{
	for (UIButton *btn in self.marrEssentialRadioBtns1_2)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)essential2RadioBtnAction:(UIButton *)sender		// 2. 고유식별정보 라디오버튼
{
	for (UIButton *btn in self.marrEssentialRadioBtns2)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)marketingRadioBtnAction:(UIButton *)sender		// 마케팅 라디오버튼
{
	for (UIButton *btn in self.marrMarketingRadioBtns)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

// 약관 보기 버튼액션
- (void)marketingStipulationBtnAction
{
    NSString *strUrl;
	 if (!AppInfo.realServer) {
         strUrl = [NSString stringWithFormat:@"%@yak_agree.html", URL_YAK_TEST];
     }
     else{
         strUrl = [NSString stringWithFormat:@"%@yak_agree.html", URL_YAK];
     }
	SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc]initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil]autorelease];
	viewController.strUrl = strUrl;
    viewController.strName = @"U드림저축예금 전환";
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

- (void)essentialStipulationBtnAction
{
    NSString *strUrl;
     if (!AppInfo.realServer) {
         strUrl = [NSString stringWithFormat:@"%@pci_lending_02.html", URL_YAK_TEST];
     }
     else{
         strUrl = [NSString stringWithFormat:@"%@pci_lending_02.html", URL_YAK];
     }
	SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc]initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil]autorelease];
	viewController.strUrl = strUrl;
    viewController.strName = @"U드림저축예금 전환";
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 8214) {
		self.service = [[[SHBProductService alloc]initWithServiceId:kC2315Id viewController:self]autorelease];
		[self.service start];
		
		[self.questionView setHidden:NO];
		[self.bottomView setHidden:NO];
		[self setStipulationView];
	}
}

#pragma mark - Http
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
	if (self.service.serviceId == kC2800Id) {
		NSString *strMsg = nil;
		
		NSInteger nResult = [[aDataSet objectForKey:@"인터넷구분수행결과"]intValue];
		if (nResult == 1 || nResult == 3 || nResult == 4) {
			strMsg = @"[특정금융거래보고법] 등 관련\n법률에 따라 고객확인이 필요한\n거래이오니 향후 영업점 내점 또는\n인터넷뱅킹 거래시 [고객확인절차]\n이행 됩니다.";
		}
		else if (nResult == 6)
		{
			strMsg = @"[특정금융거래보고법] 등 관련\n법률에 따라 고객확인이 필요한\n거래이오니 향후 영업점 내점 또는\n인터넷뱅킹 거래시 [고객확인절차]\n이행 됩니다.";
		}
		else if (nResult == 2 || nResult == 7)
		{
			strMsg = @"[특정금융거래보고법] 등 관련\n법률에 따라 고객확인이 필요한\n거래이오니 향후 영업점 내점 거래시\n[고객확인절차] 이행 됩니다.";
		}
		
		if (strMsg) {
			UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"" message:strMsg delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil]autorelease];
			[alert setTag:8214];
			[alert show];
		}
		else
		{
			self.service = [[[SHBProductService alloc]initWithServiceId:kC2315Id viewController:self]autorelease];
			[self.service start];
			
			[self.questionView setHidden:NO];
			[self.bottomView setHidden:NO];
			[self setStipulationView];
		}
			
	}
	else if (self.service.serviceId == kC2315Id) {
        
        self.data = aDataSet;
        
		if ([aDataSet[@"마케팅활용동의여부"] isEqualToString:@"1"] ||
            [aDataSet[@"마케팅활용동의여부"] isEqualToString:@"2"]) {
            
			isMarketingAgree = YES;
		}
		else {
            
			isMarketingAgree = NO;
		}
		
		if ([aDataSet[@"필수정보동의여부"] isEqualToString:@"1"]) {
            
			isEssentialAgree = YES;
		}
		else {
            
			isEssentialAgree = NO;
		}
        
        if (!isMarketingAgree || !isEssentialAgree) {
            
            [self setMarketingView];
        }
        else {
            
            [_scrollView setHidden:NO];
            [_marketingWV setHidden:YES];
        }
        
		[self repositionBottomView];
	}
	
	return NO;
}

#pragma mark - UIWebView

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [AppDelegate showProgressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [AppDelegate closeProgressView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[AppDelegate closeProgressView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
	//Debug(@"webViewDidStartLoad !!!");
    AppInfo.isWebSchemeCall = YES;
    NSString *urlStr = [[request URL] absoluteString];
    NSLog(@"urlStr:%@",urlStr);
    if ([urlStr isEqualToString:@"about:blank"])
    {
        return NO;
    }
    if ([SHBUtility isFindString:urlStr find:@"C2315_WEB=Y"])
    {
        NSArray *schemeArr = [urlStr componentsSeparatedByString:@"?"];
        
        if ([schemeArr count] == 2) {
            
            NSArray *tmpArr = [schemeArr[1] componentsSeparatedByString:@"&"];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            for (NSString *str in tmpArr) {
                
                NSArray *array = [str componentsSeparatedByString:@"="];
                
                if ([array count] == 2) {
                    
                    NSString *key = [array[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSString *value = [array[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    [dic setObject:value forKey:key];
                }
            }
            
            self.marketingAgreeDic = dic;
            
            NSLog(@"urlStr : %@", urlStr);
            NSLog(@"marketingAgreeDic : %@", _marketingAgreeDic);
            
            _isBackMarketingAgree = YES;
            
            [self navigationBackButtonShow];
            
            [_scrollView setHidden:NO];
            [_marketingWV setHidden:YES];
            
            return NO;
        }
        else {
            
            return NO;
        }
        
        return NO;
    }
    if ([SHBUtility isFindString:urlStr find:@"sbankapplink://?"])
    {
        //웹뷰안에서 타 앱으로 sso링크 태울때 사용한다.
        NSArray *schemeArr =  [urlStr componentsSeparatedByString:@"://?"];
        
        if ([schemeArr count] == 2)
        {
            NSString *tmpSar = schemeArr[1];
            NSArray *appArr = [tmpSar componentsSeparatedByString:@"="];
            if ([appArr count] == 2)
            {
                
                SHBPushInfo *pushInfo = [SHBPushInfo instance];
                [pushInfo requestOpenURL:[SHBUtility nilToString:appArr[1]] Parm:nil];
            }else
            {
                return NO;
            }
        }else
        {
            return NO;
        }
    }
    if ([SHBUtility isFindString:urlStr find:@"iVer="])
    {
        NSMutableDictionary *dataDic    = [[NSMutableDictionary alloc] init];
        NSArray *screenArr =  [urlStr componentsSeparatedByString:@"?"];
        
        if( [screenArr count] == 2 )
        {
            [dataDic removeAllObjects];
            
            
            NSArray *argArr =  [[screenArr objectAtIndex:1] componentsSeparatedByString:@"&"];
            for( int i=0;i < [argArr count];i++){
                NSArray *ArrKeyVal = [[argArr objectAtIndex:i] componentsSeparatedByString:@"="];
                
                if ([ArrKeyVal count] < 2) break;
                
                [dataDic setObject:[ArrKeyVal objectAtIndex:1] forKey:[ArrKeyVal objectAtIndex:0]];
                
            }
        }
        
        NSString *tmpStr = [dataDic objectForKey:@"iVer"];
        
        if ([tmpStr length] > 0)
        {
            tmpStr = [tmpStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            versionNumber = [versionNumber stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            if ([tmpStr intValue] > [versionNumber intValue])
            {
                [AppInfo updateAlert:[dataDic objectForKey:@"iVer"]];
                return NO;
            }
        }
        
    }
    
    if ([SHBUtility isFindString:urlStr find:@"goMain=Y"])
    {
        //메인 이동
        [AppDelegate.navigationController fadePopToRootViewController];
        return NO;
    }
    
    if ([SHBUtility isFindString:urlStr find:@"goBack=Y"])
    {
        //이전화면이동
        [AppDelegate.navigationController fadePopViewController];
        return NO;
    }
    
    //사파리로 열어야 될 경우 처리
    if ([SHBUtility isFindString:urlStr find:@"browser=Y"])
    {
        [[SHBPushInfo instance] requestOpenURL:urlStr SSO:NO];
        return NO;
    }
    //웹뷰안에 버튼 클릭시 스키마 유알엘을 타지 못하는 문제 해결(ios6은 문제 없음)
    if ([SHBUtility isFindString:[SHBUtilFile getOSVersion] find:@"5."] || [SHBUtility isFindString:[SHBUtilFile getOSVersion] find:@"4."])
    {
        if ([SHBUtility isFindString:urlStr find:@"iphonesbank://"])
        {
            [[SHBPushInfo instance] requestOpenURL:urlStr SSO:NO];
            return NO;
        }
    }
	return YES;
}

@end
