//
//  SHBELD_BA17_11ViewController.m
//  ShinhanBank
//
//  Created by Joon on 13. 6. 3..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBELD_BA17_11ViewController.h"
#import "SHBELD_BA17_12_inputViewcontroller.h"

#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"
#import "SHBNewProductSeeStipulationViewController.h"
#import "SHBELD_WebViewController.h"

@interface SHBELD_BA17_11ViewController ()
{
    BOOL _isTermsSee;
    BOOL _isTermsSee_1; //설명의무확인서
    BOOL _isELDSee;
    BOOL _isMarketingAgree; // 마케팅 동의여부
    BOOL _isEssentialAgree; // 개인정보 동의여부
    BOOL _isBackMarketingAgree;
    
    CGFloat fCurrHeight;
}

@property (getter = isReadStipulation2) BOOL readStipulation2;		// 마케팅활용동의 약관
@property (getter = isReadStipulation3) BOOL readStipulation3;		// 필수정보동의 약관
@property (nonatomic, retain) NSMutableArray *marrEssentialRadioBtns1_1;	// 필수적 정보
@property (nonatomic, retain) NSMutableArray *marrEssentialRadioBtns1_2;	// 선택적 정보
@property (nonatomic, retain) NSMutableArray *marrEssentialRadioBtns2;		// 고유식별 정보
@property (nonatomic, retain) NSMutableArray *marrMarketingRadioBtns;		// 마케팅활용동의 라디오버튼
@property (retain, nonatomic) NSDictionary *marketingAgreeDic;      // 마케팅활용동의, 필수정보동의 웹뷰에서 넘어온 데이터

/**
 마케팅활용동의 화면
 */
- (void)setMarketingView;

/**
 필수정보동의 화면
 */
- (void)setEssentialView;

/**
 마케팅 활용동의 약관 보기
 */
- (void)marketingStipulationBtnAction;

/**
 필수정보동의 약관 보기
 */
- (void)essentialStipulationBtnAction;

/**
 마케팅 라디오버튼
 */
- (void)marketingRadioBtnAction:(UIButton *)sender;

/**
 1-1. 필수적정보 라디오버튼
 */
- (void)essential1_1RadioBtnAction:(UIButton *)sender;

/**
 1-2. 선택적정보 라디오버튼
 */
- (void)essential1_2RadioBtnAction:(UIButton *)sender;

/**
 2. 고유식별정보 라디오버튼
 */
- (void)essential2RadioBtnAction:(UIButton *)sender;

@end

@implementation SHBELD_BA17_11ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"예금/적금 가입"];
    self.strBackButtonTitle = @"예금적금 가입 1단계";
    
    _isTermsSee = NO;
    _isTermsSee_1 = NO;
    _isELDSee = NO;
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:self.viewDataSource[@"상품한글명"]
                                                              maxStep:5
                                                      focusStepNumber:1] autorelease]];
    
    fCurrHeight = _mainView.frame.size.height - 39;
    
    [self.contentScrollView addSubview:_mainView];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    
    self.marketingWV.delegate = self;
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    self.service = nil;
    self.service = [[[SHBProductService alloc] initWithServiceId:kC2800Id viewController:self] autorelease];
    [self.service start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.viewDataSource = nil;
    self.marrEssentialRadioBtns1_1 = nil;
    self.marrEssentialRadioBtns1_2 = nil;
    self.marrEssentialRadioBtns2 = nil;
    self.marrMarketingRadioBtns = nil;
    self.marketingAgreeDic = nil;
    
    [_mainView release];
    [_termsCheck release];
    [_ELDCheck release];
    [_marketingWV release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setMainView:nil];
    [self setTermsCheck:nil];
    [self setELDCheck:nil];
    [super viewDidUnload];
}

#pragma mark -

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
    
    [self.contentScrollView setHidden:YES];
    
    /*
	UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=12, 317, 1)]autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[self.contentScrollView addSubview:lineView];
	
	UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight+= 4, 301, 34+10+10)]autorelease];
	[lblTitle setNumberOfLines:0];
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[lblTitle setTextColor:RGB(44, 44, 44)];
	[lblTitle setFont:[UIFont systemFontOfSize:15]];
	[lblTitle setText:@"개인(신용)정보 수집,이용,제공 동의서(상품서비스 안내 등)및 관련 고객권리 안내문"];
	[self.contentScrollView addSubview:lblTitle];
	fCurrHeight += 34+10;
	
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[ivInfoBox setUserInteractionEnabled:YES];
	[self.contentScrollView addSubview:ivInfoBox];
	
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
	[self.contentScrollView addSubview:lblQuestion];
	fCurrHeight += 10+15+10;
	
	self.marrMarketingRadioBtns = [NSMutableArray array];
	for (int nIdx=0; nIdx<2; nIdx++) {
		UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
		[btnRadio addTarget:self action:@selector(marketingRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentScrollView addSubview:btnRadio];
		[self.marrMarketingRadioBtns addObject:btnRadio];
		
		UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
		[lblRadio setBackgroundColor:[UIColor clearColor]];
		[lblRadio setTextColor:RGB(74, 74, 74)];
		[lblRadio setFont:[UIFont systemFontOfSize:15]];
		[self.contentScrollView addSubview:lblRadio];
		
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

- (void)setEssentialView
{
    /*
	UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=12, 317, 1)]autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[self.contentScrollView addSubview:lineView];
	
	UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight+= 4, 301, 34+10+10)]autorelease];
	[lblTitle setNumberOfLines:0];
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[lblTitle setTextColor:RGB(44, 44, 44)];
	[lblTitle setFont:[UIFont systemFontOfSize:15]];
	[lblTitle setText:@"개인(신용)정보 수집,이용,동의서(비여신 금융거래)및 고객권리 안내문"];
	[self.contentScrollView addSubview:lblTitle];
	fCurrHeight += 34+10;
	
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[ivInfoBox setUserInteractionEnabled:YES];
	[self.contentScrollView addSubview:ivInfoBox];
	
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
	[self.contentScrollView addSubview:lbl1];
	fCurrHeight += 10+size.height+10;
	
	{	// 필수적 정보
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 10+15+10+21+10)];
		[self.contentScrollView addSubview:ivBox2];
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
		[self.contentScrollView addSubview:ivBox2];
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
	[self.contentScrollView addSubview:lbl2];
	fCurrHeight += 10+size.height+10;
	
	{	// 고유식별 정보
		NSString *strDistinct = @"고유식별 정보 : 주민등록번호, 여권번호, 운전면허번호, 외국인등록번호";
		size = [strDistinct sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(260, 999) lineBreakMode:NSLineBreakByWordWrapping];
		
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 10+size.height+10+21+10)];
		[self.contentScrollView addSubview:ivBox2];
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

// 약관 보기 버튼액션
- (void)marketingStipulationBtnAction
{
    _readStipulation2 = YES;
    
	NSString *strUrl;
    if (!AppInfo.realServer) {
        strUrl = [NSString stringWithFormat:@"%@yak_agree.html", URL_YAK_TEST];
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"%@yak_agree.html", URL_YAK];
    }
	SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc]initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil]autorelease];
	viewController.strUrl = strUrl;
    viewController.strName = @"예금/적금 가입";
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

- (void)essentialStipulationBtnAction
{
    _readStipulation3 = YES;
    
    NSString *strUrl;
	if (!AppInfo.realServer)
    {
        strUrl = [NSString stringWithFormat:@"%@pci_lending_02.html", URL_YAK_TEST];
	}
    else{
        strUrl = [NSString stringWithFormat:@"%@pci_lending_02.html", URL_YAK];
    }
	SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc]initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil]autorelease];
	viewController.strUrl = strUrl;
    viewController.strName = @"예금/적금 가입";
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

- (void)marketingRadioBtnAction:(UIButton *)sender
{
	for (UIButton *btn in self.marrMarketingRadioBtns)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)essential1_1RadioBtnAction:(UIButton *)sender
{
	for (UIButton *btn in self.marrEssentialRadioBtns1_1)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)essential1_2RadioBtnAction:(UIButton *)sender
{
	for (UIButton *btn in self.marrEssentialRadioBtns1_2)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)essential2RadioBtnAction:(UIButton *)sender
{
	for (UIButton *btn in self.marrEssentialRadioBtns2)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

#pragma mark - Button

- (void)navigationButtonPressed:(id)sender
{
    if ([sender tag] == NAVI_BACK_BTN_TAG) {
        
        if (_isBackMarketingAgree && [_marketingWV isHidden]) {
            
            _isBackMarketingAgree = NO;
            _isTermsSee = NO;
            _isTermsSee_1 = NO;
            _isELDSee = NO;
            
            [_termsCheck setSelected:NO];
            [_ELDCheck setSelected:NO];
            
            [self navigationBackButtonHidden];
            
            [_marketingWV setHidden:NO];
            [self.contentScrollView setHidden:YES];
            
            return;
        }
    }
    
    [super navigationButtonPressed:sender];
}

- (IBAction)termSeePressed:(UIButton *)sender
{
    _isTermsSee = YES;
    
    NSString *URL = @"";
    
    if (AppInfo.realServer) {
        URL = [NSString stringWithFormat:@"%@/nexrib2/ko/data/dm/eld/SAFE_%@.pdf", URL_IMAGE, _viewDataSource[@"상품코드"]];
    }
    else {
        URL = [NSString stringWithFormat:@"%@/nexrib2/ko/data/dm/eld/SAFE_%@.pdf", URL_IMAGE_TEST, _viewDataSource[@"상품코드"]];
    }
    
    SHBELD_WebViewController *viewController = [[SHBELD_WebViewController alloc] initWithNibName:@"SHBELD_WebViewController" bundle:nil];
    viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:@{
                                     @"SUBTITLE" : @"약관동의 및 상품설명서",
                                     @"URL" : URL,
                                     @"BOTTOM_TYPE" : @"1" }]; // 하단 버튼 타입 - 1:확인 버튼
    
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}


- (IBAction)term_1SeePressed:(UIButton *)sender  //설명확인의무서
{
    _isTermsSee_1 = YES;
    
    NSString *URL = @"";
    
    if (AppInfo.realServer) {
        URL = [NSString stringWithFormat:@"http://img.shinhan.com/sbank/yak/borrowed_name_prohibition.html"];
    }
    else {
        URL = [NSString stringWithFormat:@"http://imgdev.shinhan.com/sbank/yak/borrowed_name_prohibition.html"];
    }
    
    SHBELD_WebViewController *viewController = [[SHBELD_WebViewController alloc] initWithNibName:@"SHBELD_WebViewController" bundle:nil];
    viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    @"SUBTITLE" : @"설명확인서",
                                                                                    @"URL" : URL,
                                                                                    @"BOTTOM_TYPE" : @"1" }]; // 하단 버튼 타입 - 1:확인 버튼
    
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}


- (IBAction)termsCheckPressed:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
}

- (IBAction)ELDSeePressed:(UIButton *)sender
{
    _isELDSee = YES;
    
    NSString *URL = @"";
    
    if (AppInfo.realServer) {
        URL = [NSString stringWithFormat:@"%@/pages/financialPrdt/deposit/sb_eld_mobile_02.jsp?EQUP_CD=SI", URL_M];
    }
    else {
        URL = [NSString stringWithFormat:@"%@/pages/financialPrdt/deposit/sb_eld_mobile_02.jsp?EQUP_CD=SI", URL_M_TEST];
    }
    
    SHBELD_WebViewController *viewController = [[SHBELD_WebViewController alloc] initWithNibName:@"SHBELD_WebViewController" bundle:nil];
    viewController.viewDataSource = [NSMutableDictionary dictionaryWithDictionary:@{
                                     @"SUBTITLE" : @"지수연동예금 주요 질의,응답",
                                     @"URL" : URL,
                                     @"BOTTOM_TYPE" : @"2" }]; // 하단 버튼 타입 - 2: 확인, 문의안내
    
    [self.navigationController pushFadeViewController:viewController];
    [viewController release];
}

- (IBAction)ELDCheckPressed:(UIButton *)sender
{
    [sender setSelected:![sender isSelected]];
}

- (IBAction)okPressed:(UIButton *)sender
{
    if (!_isTermsSee) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"약관동의 및 상품설명서를 읽고 확인을 선택하시기 바랍니다."];
        
        return;
    }

    if (!_isTermsSee_1) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"설명확인서 보기를 읽고 확인을 선택하시기 바랍니다."];
        
        return;
    }

    
    
    if (![_termsCheck isSelected]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"상품설명서 및 약관에 동의하셔야 합니다."];
        
        return;
    }
    
    if (!_isELDSee) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"지수연동예금 주요 질의,응답을 읽고 확인을 선택하시기 바랍니다."];
        
        return;
    }
    
    if (![_ELDCheck isSelected]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"지수연동예금 주요 질의,응답을 확인 후 확인여부에 체크하여 주시기 바랍니다."];
        
        return;
    }
    
    /*
	if (_isMarketingAgree == NO && ![self isReadStipulation2]) {     //마케팅동의
		[UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"개인(신용)정보 수집•이용•제공 동의서(상품서비스 안내 등) 및 관련 고객권리 안내문을 선택하여 확인하시기 바랍니다."];
        
        return;
	}
    
    UIButton *market_btn1 = (UIButton *)[self.marrMarketingRadioBtns objectAtIndex:0];
    UIButton *market_btn2 = (UIButton *)[self.marrMarketingRadioBtns objectAtIndex:1];
    
    if ([self isReadStipulation2] && ![market_btn1 isSelected]  && ![market_btn2 isSelected]) {     //마케팅동의여부체크
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:nil
                       message:@"개인(신용)정보 수집•이용•제공 이용동의 여부를 선택하시기 바랍니다."];
        
        return;
    }
	
    if (!_isEssentialAgree) {    // 필수적동의
		if (![self isReadStipulation3]) {
			[UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:nil
                           message:@"개인(신용)정보 조회 동의서 / 개인(신용) 정보수집•이용•제공 동의서(비여신 금융거래) 및 고객권리 안내문을 선택하여 확인하시기 바랍니다."];
            
            return;
		}
		else
		{
			UIButton *essentialBtn1 = (UIButton *)[self.marrEssentialRadioBtns1_1 objectAtIndex:0];
            UIButton *essentialBtn2 = (UIButton *)[self.marrEssentialRadioBtns2 objectAtIndex:0];
            
			if (![essentialBtn1 isSelected]) {
				[UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:nil
                               message:@"1번 필수적정보는 반드시 동의하셔야 합니다."];
                
                return;
			}
			
			
            
			if (![essentialBtn2 isSelected]) {
				[UIAlertView showAlert:nil
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:nil
                               message:@"2번 고유식별정보는 반드시 동의하셔야 합니다."];
                
                return;
			}
		}
	}
     */
    
    NSMutableDictionary *userItem = [NSMutableDictionary dictionary];
    
	if (!_isMarketingAgree && _isEssentialAgree) {
        
        // 마케팅 동의만 그릴 때
        
		[userItem setObject:_marketingAgreeDic[@"마케팅활용동의여부"] forKey:@"정보동의"];
		[userItem setObject:_marketingAgreeDic[@"자택TM통지요청구분"] forKey:@"_자택TM통지요청구분"];
        [userItem setObject:_marketingAgreeDic[@"직장TM통지요청구분"] forKey:@"_직장TM통지요청구분"];
        [userItem setObject:_marketingAgreeDic[@"휴대폰통지요청구분"] forKey:@"_휴대폰통지요청구분"];
        [userItem setObject:_marketingAgreeDic[@"SMS통지요청구분"] forKey:@"_SMS통지요청구분"];
        [userItem setObject:_marketingAgreeDic[@"EMAIL통지요청구분"] forKey:@"_EMAIL통지요청구분"];
        [userItem setObject:_marketingAgreeDic[@"DM희망지주소구분"] forKey:@"_DM희망지주소구분"];
        
		if ([_marketingAgreeDic[@"마케팅활용동의여부"] isEqualToString:@"1"]) {
            
			[userItem setObject:@"마케팅동의구분" forKey:@"동의구분"];
		}
		else {
            
			[userItem setObject:@"마케팅동의안함" forKey:@"동의구분"];
		}
        
        // C2315 내려온 값 그대로 셋팅
		[userItem setObject:self.data[@"필수정보동의여부"] forKey:@"필수정보동의여부"];
		[userItem setObject:self.data[@"선택정보동의여부"] forKey:@"선택정보동의여부"];
	}
	else if (_isMarketingAgree && !_isEssentialAgree) {
        
        // 필수적 동의만 그릴 때
        
		[userItem setObject:_marketingAgreeDic[@"필수정보동의여부"] forKey:@"필수적정보동의"];
		[userItem setObject:_marketingAgreeDic[@"선택정보동의여부"] forKey:@"선택정보동의여부"];
		[userItem setObject:@"필수적정보동의구분" forKey:@"동의구분"];
        
        // C2315 내려온 값 그대로 셋팅
		[userItem setObject:self.data[@"마케팅활용동의여부"] forKey:@"마케팅활용동의여부"];
        [userItem setObject:self.data[@"자택TM통지요청구분"] forKey:@"_자택TM통지요청구분"];
        [userItem setObject:self.data[@"직장TM통지요청구분"] forKey:@"_직장TM통지요청구분"];
        [userItem setObject:self.data[@"휴대폰통지요청구분"] forKey:@"_휴대폰통지요청구분"];
        [userItem setObject:self.data[@"SMS통지요청구분"] forKey:@"_SMS통지요청구분"];
        [userItem setObject:self.data[@"EMAIL통지요청구분"] forKey:@"_EMAIL통지요청구분"];
        [userItem setObject:self.data[@"DM희망지주소구분"] forKey:@"_DM희망지주소구분"];
	}
	else if (!_isMarketingAgree && !_isEssentialAgree) {
        
        // 둘다 그릴 때
        
		[userItem setObject:_marketingAgreeDic[@"마케팅활용동의여부"] forKey:@"정보동의"];
		
		if ([_marketingAgreeDic[@"마케팅활용동의여부"] isEqualToString:@"2"]) {
            
			[userItem setObject:@"필수적정보동의구분" forKey:@"동의구분"];
		}
		else {
            
			[userItem setObject:@"마케팅과필수적정보동의구분" forKey:@"동의구분"];
		}
		
		[userItem setObject:_marketingAgreeDic[@"필수정보동의여부"] forKey:@"필수적정보동의"];
		[userItem setObject:_marketingAgreeDic[@"선택정보동의여부"] forKey:@"선택정보동의여부"];
        [userItem setObject:_marketingAgreeDic[@"자택TM통지요청구분"] forKey:@"_자택TM통지요청구분"];
        [userItem setObject:_marketingAgreeDic[@"직장TM통지요청구분"] forKey:@"_직장TM통지요청구분"];
        [userItem setObject:_marketingAgreeDic[@"휴대폰통지요청구분"] forKey:@"_휴대폰통지요청구분"];
        [userItem setObject:_marketingAgreeDic[@"SMS통지요청구분"] forKey:@"_SMS통지요청구분"];
        [userItem setObject:_marketingAgreeDic[@"EMAIL통지요청구분"] forKey:@"_EMAIL통지요청구분"];
        [userItem setObject:_marketingAgreeDic[@"DM희망지주소구분"] forKey:@"_DM희망지주소구분"];
	}
    
    SHBELD_BA17_12_inputViewcontroller *viewController = [[[SHBELD_BA17_12_inputViewcontroller alloc] initWithNibName:@"SHBELD_BA17_12_inputViewcontroller" bundle:nil] autorelease];
    viewController.dicSelectedData = _viewDataSource;
    viewController.userItem = userItem;
    
    if (_viewDataSource[@"mdicPushInfo"]) {
        viewController.mdicPushInfo = _viewDataSource[@"mdicPushInfo"];
    }
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
}

- (IBAction)cancelPressed:(UIButton *)sender
{
    if (_isBackMarketingAgree && [_marketingWV isHidden]) {
        
        _isBackMarketingAgree = NO;
        _isTermsSee = NO;
        _isELDSee = NO;
        
        [_termsCheck setSelected:NO];
        [_ELDCheck setSelected:NO];
        
        [self setMarketingView];
        
        return;
    }
    
    [self.navigationController fadePopViewController];
}

#pragma mark - Response

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    return YES;
}

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if (self.service.serviceId == kC2800Id) {
        NSString *strMsg = nil;
		
		NSInteger nResult = [aDataSet[@"인터넷구분수행결과"] integerValue];
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
			[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:8214 title:nil message:strMsg];
            
            return NO;
		}
        
        self.service = nil;
        self.service = [[[SHBProductService alloc]initWithServiceId:kC2315Id viewController:self] autorelease];
        [self.service start];
    }
    else if (self.service.serviceId == kC2315Id) {
        
        self.data = aDataSet;
        
        if ([aDataSet[@"마케팅활용동의여부"] isEqualToString:@"1"] ||
            [aDataSet[@"마케팅활용동의여부"] isEqualToString:@"2"]) {
            
			_isMarketingAgree = YES;
		}
		else {
            
			_isMarketingAgree = NO;
		}
		
		if ([aDataSet[@"필수정보동의여부"] isEqualToString:@"1"]) {
            
			_isEssentialAgree = YES;
		}
		else {
            
			_isEssentialAgree = NO;
		}
        
        if (!_isMarketingAgree || !_isEssentialAgree) {
            
            [self setMarketingView];
        }
        else {
            
            [self.contentScrollView setHidden:NO];
            [_marketingWV setHidden:YES];
        }
        
        CGRect frame = _mainView.frame;
        frame.size.height = fCurrHeight + 39;
        _mainView.frame = frame;
        
        [self.contentScrollView setContentSize:_mainView.frame.size];
    }
    
    
    return YES;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView.tag == 8214) {
        self.service = nil;
        self.service = [[[SHBProductService alloc]initWithServiceId:kC2315Id viewController:self] autorelease];
        [self.service start];
    }
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
            
            [self.contentScrollView setHidden:NO];
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
