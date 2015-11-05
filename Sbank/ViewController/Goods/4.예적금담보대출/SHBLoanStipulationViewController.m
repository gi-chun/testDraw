//
//  SHBLoanStipulationViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBLoanStipulationViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"
#import "SHBLoanStipulationView.h"
#import "SHBLoanRegViewController.h"
#import "SHBIdentity1ViewController.h"
#import "SHBIdentity3ViewController.h"
#import "SHBNewProductSeeStipulationViewController.h"

@interface SHBLoanStipulationViewController () <SHBIdentity3Delegate>
{
	CGFloat fCurrHeight;
	
	BOOL isReadStipulation1;
	BOOL isReadStipulation2;
	BOOL isLastAgreeCheck;
}

@property (nonatomic, retain) NSMutableArray *marrRadioBtnsNo1_1;
@property (nonatomic, retain) NSMutableArray *marrRadioBtnsNo1_2;
@property (nonatomic, retain) NSMutableArray *marrRadioBtnsNo2;
@property (nonatomic, retain) NSMutableArray *marrRadioBtnsNo3;
@property (nonatomic, retain) NSMutableArray *marrRadioBtnsNo4;
@property (nonatomic, retain) NSMutableArray *marrRadioBtnsNo5;
@property (nonatomic, retain) NSMutableArray *marrRadioBtnsNo6;
@property (nonatomic, retain) NSMutableArray *marrRadioBtnsNo7;
@property (nonatomic, retain) NSMutableArray *marrRadioBtnsNo8;
@property (nonatomic, retain) NSMutableArray *marrRadioBtnsNo9;


@end

@implementation SHBLoanStipulationViewController

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
	[_marrRadioBtnsNo1_1 release];
	[_marrRadioBtnsNo1_2 release];
	[_marrRadioBtnsNo2 release];
	[_marrRadioBtnsNo3 release];
	[_marrRadioBtnsNo4 release];
	[_marrRadioBtnsNo5 release];
	[_marrRadioBtnsNo6 release];
	[_marrRadioBtnsNo7 release];
	[_marrRadioBtnsNo8 release];
    [_marrRadioBtnsNo9 release];
    [_marketingWV release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMarketingWV:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예적금담보대출"];
    self.strBackButtonTitle = @"예적금담보대출 신청 1단계";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예적금담보대출 신청" maxStep:6 focusStepNumber:1]autorelease]];
	
	self.service = [[[SHBProductService alloc]initWithServiceId:kC2800Id viewController:self]autorelease];
	[self.service start];
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userReadStipulation:) name:@"UserPressedConfirmButton" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LoanSecurityConfirmCancel)
                                                 name:@"LoanSecurityConfirmCancel"
                                               object:nil];
    
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
    isLastAgreeCheck = NO;
    
//    [self.btn_lastAgreeCheck setSelected:NO];
    
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBLoanStipulationViewController class]]) {
			[self.navigationController fadePopToViewController:viewController];
            
            self.service = [[[SHBProductService alloc]initWithServiceId:kC2800Id viewController:self]autorelease];
            [self.service start];
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
//	[self.scrollView flashScrollIndicators];
}

#pragma mark - Notification
- (void)userReadStipulation:(NSNotification *)noti
{
	NSString *strUrl = [[noti userInfo]objectForKey:@"url"];
	
	if ([strUrl hasSuffix:@"yak_loanbasic.html"] ||
        [strUrl hasSuffix:@"loan_limitloan_yak.html"]) {
		isReadStipulation1 = YES;
	}
	else if ([strUrl hasSuffix:@"pci_lending_01.html"]) {
		isReadStipulation2 = YES;
	}
}

- (void)LoanSecurityConfirmCancel
{
    if ([[AppInfo.userInfo objectForKey:@"보안매체정보"]intValue] == 5)
    {
        [self.navigationController fadePopViewController];
        [self.navigationController fadePopViewController];
        [self.navigationController fadePopViewController];
   
	}
	else
	{
        [self.navigationController fadePopViewController];
        [self.navigationController fadePopViewController];
        [self.navigationController fadePopViewController];
        [self.navigationController fadePopViewController];
    }
    
    self.service = [[[SHBProductService alloc]initWithServiceId:kC2800Id viewController:self]autorelease];
	[self.service start];
}


#pragma mark - UI

- (void)setMarketingView
{
    NSMutableString *URL = [NSMutableString stringWithFormat:@"https://%@.shinhan.com/sbank/marketing/marketing_yeinfo.jsp?", AppInfo.realServer ? @"m" : @"dev-m"];
    
    NSDictionary *dic = @{ @"대출타입" : self.Loantype,
                           @"마케팅활용동의여부" : self.data[@"마케팅활용동의여부"],
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
}

/*
- (void)setStipulationView
{
	CGFloat fHeight = 25;
	
	NSString *strGuide = @"아래의 약관 및 약정서를 선택하여 본 후 동의 해야 대출 신청을 할 수 있습니다.";
	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByWordWrapping];
	
	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(8, fHeight, 301, size.height)]autorelease];
	[lblGuide setNumberOfLines:0];
	[lblGuide setBackgroundColor:[UIColor clearColor]];
	[lblGuide setTextColor:RGB(44, 44, 44)];
	[lblGuide setFont:[UIFont systemFontOfSize:15]];
	[lblGuide setText:strGuide];
	[self.scrollView addSubview:lblGuide];
	fHeight += size.height + 8;
	
	UIImage *image = [UIImage imageNamed:@"box_consent.png"];
	UIImageView *ivStipulationBG = [[[UIImageView alloc]initWithImage:[image stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[ivStipulationBG setBackgroundColor:[UIColor clearColor]];
	[ivStipulationBG setFrame:CGRectMake(10, fHeight, 300, 3 * kRowHeight)];
	[ivStipulationBG setUserInteractionEnabled:YES];
	[self.scrollView addSubview:ivStipulationBG];
	
	SHBLoanStipulationView *stipulationView = [[[SHBLoanStipulationView alloc]initWithFrame:CGRectMake(0, 0, 300, 3 * kRowHeight)]autorelease];
    
    if ([self.Loantype isEqualToString:@"A"])
    {
        stipulationView.strLoan = [NSString stringWithFormat:@"담보대출 건별거래 약정서"];
    }
    else{
        stipulationView.strLoan = [NSString stringWithFormat:@"담보대출 한도거래 약정서"];
    }
    
    
	[stipulationView setParentViewController:self];
	[ivStipulationBG addSubview:stipulationView];
	fHeight += (3 * kRowHeight);
	
	fCurrHeight = fHeight + 9;
	FrameReposition(self.questionView, left(self.questionView), fCurrHeight);
	fCurrHeight += 68;
	
	[self repositionBottomView];
}

- (void)setAgreeInfoView	// 정보동의
{
	UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=12, 317, 1)]autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[self.scrollView addSubview:lineView];
	
	UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight+= 3, 301, 50+9+9)]autorelease];
	[lblTitle setNumberOfLines:0];
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[lblTitle setTextColor:RGB(44, 44, 44)];
	[lblTitle setFont:[UIFont systemFontOfSize:15]];
	[lblTitle setText:@"개인(신용)정보 조회 동의서 / 개인(신용) 정보수집, 이용, 제공 동의서 (여신 금융거래) 및 고객권리 안내문"];
	[self.scrollView addSubview:lblTitle];
	fCurrHeight += 50+9;
	
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[ivInfoBox setUserInteractionEnabled:YES];
	[self.scrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 5;
	NSString *strGuide = @"'개인(신용) 정보 수집, 이용 및 제공(여신금융거래)' 중 고유 식별정보(주민번호 등), 필수 정보(이름, 전화번호, 이메일 등) 및 선택적 정보(주거, 가족사항, 결혼여부 등)의 수집 및 이용등 처리에 동의해야 대출 신청을 할 수 있습니다.";
	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(226-3, 999) lineBreakMode:NSLineBreakByCharWrapping];
	
	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5, fHeight, 226-3, size.height)]autorelease];
	[lblGuide setNumberOfLines:0];
	[lblGuide setBackgroundColor:[UIColor clearColor]];
	[lblGuide setTextColor:RGB(114, 114, 114)];
	[lblGuide setFont:[UIFont systemFontOfSize:13]];
	[lblGuide setText:strGuide];
	[ivInfoBox addSubview:lblGuide];
	
	UIImage *imgBox1 = [UIImage imageNamed:@"box_1"];
	UIImageView *ivRightBG = [[[UIImageView alloc]initWithImage:[imgBox1 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[ivRightBG setUserInteractionEnabled:YES];
	[ivRightBG setImage:nil];
	[ivInfoBox addSubview:ivRightBG];
	
	SHBButton *btnSee = [SHBButton buttonWithType:UIButtonTypeCustom];
	[btnSee setFrame:CGRectMake(0, 0, 60, 29)];
	[btnSee setBackgroundImage:[UIImage imageNamed:@"btn_ctype3"] forState:UIControlStateNormal];
	[btnSee setBackgroundImage:[UIImage imageNamed:@"btn_ctype3_focus"] forState:UIControlStateHighlighted];
	[btnSee.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
	[btnSee.titleLabel setTextColor:[UIColor whiteColor]];
	[btnSee setTitle:@"보기" forState:UIControlStateNormal];
	[btnSee addTarget:self action:@selector(stipulationBtnAction) forControlEvents:UIControlEventTouchUpInside];
	[ivRightBG addSubview:btnSee];
	
	fHeight += size.height + 5;
	
	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight+=9, 311, fHeight)];
	[ivRightBG setFrame:CGRectMake(236-3, 3, 75, height(ivInfoBox)-6)];
	[btnSee setCenter:ivRightBG.center];
	FrameReposition(btnSee, 8, top(btnSee)-3);
	fCurrHeight += fHeight;
	
	// no.1
	NSString *str1 = @"1. 신한은행이 개인정보 수집, 이용, 제공 동의서(여신 금융거래)와 같이 본인의 개인정보를 수집, 이용하는 것에 동의합니다.";
	size = [str1 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
	UILabel *lbl1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9)]autorelease];
	[lbl1 setNumberOfLines:0];
	[lbl1 setBackgroundColor:[UIColor clearColor]];
	[lbl1 setTextColor:RGB(44, 44, 44)];
	[lbl1 setFont:[UIFont systemFontOfSize:15]];
	[lbl1 setText:str1];
	[self.scrollView addSubview:lbl1];
	fCurrHeight += 9+size.height+9;
	
	{	// 필수적 정보
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 9+14+9+21+9)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 9+14+9+21+9;
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(12, 9+4, 7, 7)];
		[ivBox2 addSubview:ivBullet];
		
		UILabel *lblRequired = [[[UILabel alloc]initWithFrame:CGRectMake(left(ivBullet)+7+3, 0, 301, 9+14+9)]autorelease];
		[lblRequired setNumberOfLines:0];
		[lblRequired setBackgroundColor:[UIColor clearColor]];
		[lblRequired setTextColor:RGB(44, 44, 44)];
		[lblRequired setFont:[UIFont systemFontOfSize:15]];
		[lblRequired setText:@"필수적 정보"];
		[ivBox2 addSubview:lblRequired];
		
		self.marrRadioBtnsNo1_1 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(radioBtnAction1_1:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrRadioBtnsNo1_1 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 9+14+9, 21, 21)];
				[btnRadio setSelected:YES];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 9+14+9, 21, 21)];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 9+14+9, 100, 21)];
		}
	}
	
	fCurrHeight += 5;
	{	// 선택적 정보
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 9+14+9+21+9)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 9+14+9+21+9;
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(12, 9+4, 7, 7)];
		[ivBox2 addSubview:ivBullet];
		
		UILabel *lblOptional = [[[UILabel alloc]initWithFrame:CGRectMake(left(ivBullet)+7+3, 0, 301, 9+14+9)]autorelease];
		[lblOptional setNumberOfLines:0];
		[lblOptional setBackgroundColor:[UIColor clearColor]];
		[lblOptional setTextColor:RGB(44, 44, 44)];
		[lblOptional setFont:[UIFont systemFontOfSize:15]];
		[lblOptional setText:@"선택적 정보"];
		[ivBox2 addSubview:lblOptional];
		
		self.marrRadioBtnsNo1_2 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(radioBtnAction1_2:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrRadioBtnsNo1_2 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 9+14+9, 21, 21)];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 9+14+9, 21, 21)];
				[btnRadio setSelected:YES];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 9+14+9, 100, 21)];
		}
	}
	
	// no2.
	NSString *str2 = @"2. 신한은행이 개인정보 수집, 이용, 제공 동의서(여신금융거래)와 같이 본인의 고유 식별 정보를 수집, 이용하는 것에 동의 합니다.";
	size = [str2 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
	UILabel *lbl2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9)]autorelease];
	[lbl2 setNumberOfLines:0];
	[lbl2 setBackgroundColor:[UIColor clearColor]];
	[lbl2 setTextColor:RGB(44, 44, 44)];
	[lbl2 setFont:[UIFont systemFontOfSize:15]];
	[lbl2 setText:str2];
	[self.scrollView addSubview:lbl2];
	fCurrHeight += 9+size.height+9;
	
	{
		NSString *strDistinct = @"고유식별 정보 : 주민등록번호, 여권번호, 운전면허번호, 외국인등록번호";
		size = [strDistinct sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(260, 999) lineBreakMode:NSLineBreakByWordWrapping];
		
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9+21+9)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 9+size.height+9+21+9;
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(12, 9+4, 7, 7)];
		[ivBox2 addSubview:ivBullet];
		
		
		UILabel *lblDistinct = [[[UILabel alloc]initWithFrame:CGRectMake(left(ivBullet)+7+3, 0, 260, 9+size.height+9)]autorelease];
		[lblDistinct setNumberOfLines:0];
		[lblDistinct setBackgroundColor:[UIColor clearColor]];
		[lblDistinct setTextColor:RGB(44, 44, 44)];
		[lblDistinct setFont:[UIFont systemFontOfSize:15]];
		[lblDistinct setText:strDistinct];
		[ivBox2 addSubview:lblDistinct];
		
		self.marrRadioBtnsNo2 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(radioBtnAction2:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrRadioBtnsNo2 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
	 		if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 9+size.height+9, 21, 21)];
                [btnRadio setSelected:YES];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 9+size.height+9, 21, 21)];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 9+size.height+9, 100, 21)];
		}
	}
	
	{	// no.3
		NSString *str3 = @"3. 신한은행이 개인정보 수집, 이용, 제공 동의서(여신금융거래)와 같이 본인의 개인정보를 제공하는 것에 동의합니다.";
		size = [str3 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
		UILabel *lbl3 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9)]autorelease];
		[lbl3 setNumberOfLines:0];
		[lbl3 setBackgroundColor:[UIColor clearColor]];
		[lbl3 setTextColor:RGB(44, 44, 44)];
		[lbl3 setFont:[UIFont systemFontOfSize:15]];
		[lbl3 setText:str3];
		[self.scrollView addSubview:lbl3];
		fCurrHeight += 9+size.height+9;
	
	
		NSString *strDistinct = @"개인정보 제공";
		size = [strDistinct sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(260, 999) lineBreakMode:NSLineBreakByWordWrapping];
		
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9+21+9)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 9+size.height+9+21+9;
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(12, 9+4, 7, 7)];
		[ivBox2 addSubview:ivBullet];
		
		
		UILabel *lblDistinct = [[[UILabel alloc]initWithFrame:CGRectMake(left(ivBullet)+7+3, 0, 260, 9+size.height+9)]autorelease];
		[lblDistinct setNumberOfLines:0];
		[lblDistinct setBackgroundColor:[UIColor clearColor]];
		[lblDistinct setTextColor:RGB(44, 44, 44)];
		[lblDistinct setFont:[UIFont systemFontOfSize:15]];
		[lblDistinct setText:strDistinct];
		[ivBox2 addSubview:lblDistinct];
		
		self.marrRadioBtnsNo3 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(radioBtnAction3:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrRadioBtnsNo3 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 9+size.height+9, 21, 21)];
                [btnRadio setSelected:YES];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 9+size.height+9, 21, 21)];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 9+size.height+9, 100, 21)];
		}
	}
	
	{	// no.4
		NSString *str4 = @"4. 신한은행이 개인정보 수집, 이용, 제공 동의서(여신금융거래)와 같이 본인의 고유식별정보를 제공하는 것에 동의합니다.";
		size = [str4 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
		UILabel *lbl4 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9)]autorelease];
		[lbl4 setNumberOfLines:0];
		[lbl4 setBackgroundColor:[UIColor clearColor]];
		[lbl4 setTextColor:RGB(44, 44, 44)];
		[lbl4 setFont:[UIFont systemFontOfSize:15]];
		[lbl4 setText:str4];
		[self.scrollView addSubview:lbl4];
		fCurrHeight += 9+size.height+9;
	
		NSString *strDistinct = @"고유식별정보 : 주민등록번호, 여권번호, 운전면허번호, 외국인등록번호";
		size = [strDistinct sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(260, 999) lineBreakMode:NSLineBreakByWordWrapping];
		
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9+21+9)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 9+size.height+9+21+9;
		
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(12, 9+4, 7, 7)];
		[ivBox2 addSubview:ivBullet];
		
		
		UILabel *lblDistinct = [[[UILabel alloc]initWithFrame:CGRectMake(left(ivBullet)+7+3, 0, 260, 9+size.height+9)]autorelease];
		[lblDistinct setNumberOfLines:0];
		[lblDistinct setBackgroundColor:[UIColor clearColor]];
		[lblDistinct setTextColor:RGB(44, 44, 44)];
		[lblDistinct setFont:[UIFont systemFontOfSize:15]];
		[lblDistinct setText:strDistinct];
		[ivBox2 addSubview:lblDistinct];
		
		self.marrRadioBtnsNo4 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(radioBtnAction4:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrRadioBtnsNo4 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 9+size.height+9, 21, 21)];
                [btnRadio setSelected:YES];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 9+size.height+9, 21, 21)];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 9+size.height+9, 100, 21)];
		}
	}
	
	{	// no.5
		NSString *str5 = @"5. 신한은행이 본인의 개인신용정보를 수집,이용하는 것에 동의합니다.";
		size = [str5 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
		UILabel *lbl5 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9)]autorelease];
		[lbl5 setNumberOfLines:0];
		[lbl5 setBackgroundColor:[UIColor clearColor]];
		[lbl5 setTextColor:RGB(44, 44, 44)];
		[lbl5 setFont:[UIFont systemFontOfSize:15]];
		[lbl5 setText:str5];
		[self.scrollView addSubview:lbl5];
		fCurrHeight += 9+size.height+9;
		
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 9+21+9)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 9+21+9;
		
		self.marrRadioBtnsNo5 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(radioBtnAction5:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrRadioBtnsNo5 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 9, 21, 21)];
                [btnRadio setSelected:YES];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 9, 21, 21)];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 9, 100, 21)];
		}
	}
	
	{	// no.6
		NSString *str5 = @"6. 신한은행이 본인의 개인신용정보를 제공,조회하는 것에 동의합니다.";
		size = [str5 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
		UILabel *lbl5 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9)]autorelease];
		[lbl5 setNumberOfLines:0];
		[lbl5 setBackgroundColor:[UIColor clearColor]];
		[lbl5 setTextColor:RGB(44, 44, 44)];
		[lbl5 setFont:[UIFont systemFontOfSize:15]];
		[lbl5 setText:str5];
		[self.scrollView addSubview:lbl5];
		fCurrHeight += 9+size.height+9;
		
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 9+21+9)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 9+21+9;
		
		self.marrRadioBtnsNo6 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(radioBtnAction6:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrRadioBtnsNo6 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 9, 21, 21)];
                [btnRadio setSelected:YES];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 9, 21, 21)];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 9, 100, 21)];
		}
	}
	
	{	// no.7
		NSString *str5 = @"7. 신한은행이 본인의 고유 식별정보를 제공,조회하는 것에 동의합니다.";
		size = [str5 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
		UILabel *lbl5 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9)]autorelease];
		[lbl5 setNumberOfLines:0];
		[lbl5 setBackgroundColor:[UIColor clearColor]];
		[lbl5 setTextColor:RGB(44, 44, 44)];
		[lbl5 setFont:[UIFont systemFontOfSize:15]];
		[lbl5 setText:str5];
		[self.scrollView addSubview:lbl5];
		fCurrHeight += 9+size.height+9;
		
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 9+21+9)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 9+21+9;
		
		self.marrRadioBtnsNo7 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(radioBtnAction7:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrRadioBtnsNo7 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 9, 21, 21)];
                [btnRadio setSelected:YES];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 9, 21, 21)];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 9, 100, 21)];
		}
	}
	
	{	// no.8
		NSString *str5 = @"8. 신한은행이 본인의 고유 식별정보를 수집,이용하는 것에 동의합니다.";
		size = [str5 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
		UILabel *lbl5 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9)]autorelease];
		[lbl5 setNumberOfLines:0];
		[lbl5 setBackgroundColor:[UIColor clearColor]];
		[lbl5 setTextColor:RGB(44, 44, 44)];
		[lbl5 setFont:[UIFont systemFontOfSize:15]];
		[lbl5 setText:str5];
		[self.scrollView addSubview:lbl5];
		fCurrHeight += 9+size.height+9;
		
		UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 9+21+9)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 9+21+9;
		
		self.marrRadioBtnsNo8 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(radioBtnAction8:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrRadioBtnsNo8 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 9, 21, 21)];
                [btnRadio setSelected:YES];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 9, 21, 21)];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 9, 100, 21)];
		}
	}
	
    
    {	// no.9

        NSString *str6 = @"9. 신한은행이 아래와 같이 본인의 정보를 제공/조회하는 것에 동의합니다.";
        size = [str6 sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByCharWrapping];
        
        
		UILabel *lbl6 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 9+size.height+9)]autorelease];
		[lbl6 setNumberOfLines:0];
		[lbl6 setBackgroundColor:[UIColor clearColor]];
		[lbl6 setTextColor:RGB(44, 44, 44)];
		[lbl6 setFont:[UIFont systemFontOfSize:15]];
		[lbl6 setText:str6];
        [self.scrollView addSubview:lbl6];
		fCurrHeight += 9+size.height+9;
         
		
        UIImage *imgBox2 = [UIImage imageNamed:@"box_2"];
		UIImageView *ivBox2 = [[[UIImageView alloc]initWithImage:[imgBox2 stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivBox2 setUserInteractionEnabled:YES];
		[ivBox2 setImage:nil];
		[ivBox2 setFrame:CGRectMake(8, fCurrHeight, 301, 9+170+9)];
		[self.scrollView addSubview:ivBox2];
		fCurrHeight += 9+170+9;
        
                
        for (int nIdx=0; nIdx<4; nIdx++)
        {
			 UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
            [ivBox2 addSubview:ivBullet];

			UILabel *lblname = [[[UILabel alloc]init]autorelease];
			[lblname setBackgroundColor:[UIColor clearColor]];
			[lblname setTextColor:RGB(44, 44, 44)];
			[lblname setFont:[UIFont systemFontOfSize:14]];
			[ivBox2 addSubview:lblname];
			
			if (nIdx == 0) {
				[ivBullet setFrame:CGRectMake(12, 9+4, 7, 7)];
                [lblname setFrame:CGRectMake(left(ivBullet)+7+3, 9, 280, 15)];
				[lblname setText:@"식별정보 : 주민등록번호, 사업자번호"];
			}
			else if (nIdx == 1) {
				[ivBullet setFrame:CGRectMake(12, 30+4, 7, 7)];
                [lblname setFrame:CGRectMake(left(ivBullet)+7+3, 30, 280, 35)];
                lblname.numberOfLines=2;
				[lblname setText:@"제공할정보 : 카드사용정보,연체정보,거래정지,가맹점정보,특수채권정보,신용등급"];
			}
            
            else if (nIdx == 2) {
				[ivBullet setFrame:CGRectMake(12, 71+4, 7, 7)];
                [lblname setFrame:CGRectMake(left(ivBullet)+7+3, 71, 280, 35)];
                lblname.numberOfLines=2;
				[lblname setText:@"제공(이용)목적 : 대출 등 금융거래 설정 및 유지관리"];
			}
            
            else if (nIdx == 3) {
				[ivBullet setFrame:CGRectMake(12, 112+4, 7, 7)];
                [lblname setFrame:CGRectMake(left(ivBullet)+7+3, 112, 280, 35)];
                lblname.numberOfLines=2;
				[lblname setText:@"제공동의 효력기간 : 본인과 귀사의 금융거래의 종료시 까지"];
			}
			
        }
        
        
        self.marrRadioBtnsNo9 = [NSMutableArray array];
		for (int nIdx=0; nIdx<2; nIdx++) {
			UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
			[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
			[btnRadio addTarget:self action:@selector(radioBtnAction9:) forControlEvents:UIControlEventTouchUpInside];
			[ivBox2 addSubview:btnRadio];
			[self.marrRadioBtnsNo9 addObject:btnRadio];
			
			UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
			[lblRadio setBackgroundColor:[UIColor clearColor]];
			[lblRadio setTextColor:RGB(74, 74, 74)];
			[lblRadio setFont:[UIFont systemFontOfSize:15]];
			[ivBox2 addSubview:lblRadio];
			
			if (nIdx == 0) {
				[btnRadio setFrame:CGRectMake(23, 155, 21, 21)];
                [btnRadio setSelected:YES];
				[lblRadio setText:@"동의함"];
			}
			else if (nIdx == 1) {
				[btnRadio setFrame:CGRectMake(155, 155, 21, 21)];
				[lblRadio setText:@"동의하지 않음"];
			}
			
			[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, 155, 100, 21)];
		}

	}

    
	NSString *strQ = @"위 약관과 약정서, 상품설명서 및 동의서를 서면으로 교부하는 것에 갈음하여 위와 같이 전자문서를 열람하고 이를 전자적 방법으로 처리하는 것에 동의하며 대출을 신청하시겠습니까?";
	size = [strQ sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByWordWrapping];
	
	UILabel *lblQ = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight+=20, 301, size.height)]autorelease];
	[lblQ setNumberOfLines:0];
	[lblQ setBackgroundColor:[UIColor clearColor]];
	[lblQ setTextColor:RGB(44, 44, 44)];
	[lblQ setFont:[UIFont systemFontOfSize:15]];
	[lblQ setText:strQ];
	[self.scrollView addSubview:lblQ];
	fCurrHeight += size.height;
}

- (void)repositionBottomView
{
	CGFloat fBottomHeight = fCurrHeight;
	FrameReposition(self.bottomView, left(self.bottomView), fBottomHeight += 22);
	[self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, fBottomHeight += 29+30)];
	[self.scrollView flashScrollIndicators];
}
*/

#pragma mark - Action
- (void)stipulationItemPressed:(UITapGestureRecognizer *)sender
{
	Debug(@"sender : %@", sender);
	Debug(@"sender.view.tag : %d", sender.view.tag);
	// 각 약관 눌렀을때의 처리 구현 : 안하기로 함
}

- (void)seeBtnAction:(UIButton *)sender {

    NSString *strUrl;
    
     if (!AppInfo.realServer)
     {
         if ([self.Loantype isEqualToString:@"A"])
         {
             strUrl = [NSString stringWithFormat:@"%@yak_loanbasic.html", URL_YAK_TEST];
         }
         else
         {
              strUrl = [NSString stringWithFormat:@"%@loan_limitloan_yak.html", URL_YAK_TEST];
         }
        
     }
     else
     {
         if ([self.Loantype isEqualToString:@"A"])
         {
             strUrl = [NSString stringWithFormat:@"%@yak_loanbasic.html", URL_YAK];
         }
         else{
             strUrl = [NSString stringWithFormat:@"%@loan_limitloan_yak.html", URL_YAK];
         }
         
         
     }
	SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc]initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil]autorelease];
	viewController.strUrl = strUrl;
    viewController.strName = @"예적금담보대출";
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

- (IBAction)agreeCheckBtnAction:(UIButton *)sender {
	[sender setSelected:!sender.selected];
	
	isLastAgreeCheck = [sender isSelected];
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
	
    /*
    NSString *strMsg = nil;
	
	if (isReadStipulation1 == NO) {
        if ([self.Loantype isEqualToString:@"A"])
        {
            strMsg = @"은행 여신거래 기본약관, 담보대출 건별거래 약정서, 가계대출 상품 설명서 보기를 선택하여 확인하시기 바랍니다.";
        }
        else
        {
            strMsg = @"은행 여신거래 기본약관, 담보대출 한도거래 약정서, 가계대출 상품 설명서 보기를 선택하여 확인하시기 바랍니다.";
        }
		
	}
	else if (!isLastAgreeCheck) {
        if ([self.Loantype isEqualToString:@"A"])
        {
            strMsg = @"은행 여신거래 기본약관, 담보대출 건별거래 약정서, 가계대출 상품 설명서를 읽고 동의를 선택하시기 바랍니다.";
        }
        else
        {
            strMsg = @"은행 여신거래 기본약관, 담보대출 한도거래 약정서, 가계대출 상품 설명서를 읽고 동의를 선택하시기 바랍니다.";
        }
		
	}
	else if (isReadStipulation2 == NO) {
		strMsg = @"개인(신용)정보 조회 동의서/개인(신용) 정보수집,이용,제공 동의서(여신 금융거래) 및 고객권리 안내문 동의문 보기를 선택하여 확인하시기 바랍니다.";
	}
	else if ([[self.marrRadioBtnsNo1_1 objectAtIndex:0] isSelected] == NO) {
		strMsg = @"1번 필수적정보는 반드시 동의하셔야 합니다.";
	}
	else if ([[self.marrRadioBtnsNo2 objectAtIndex:0]isSelected] == NO) {
		strMsg = @"2번 고유식별정보는 반드시 동의하셔야 합니다.";
	}
	else if ([[self.marrRadioBtnsNo3 objectAtIndex:0]isSelected] == NO) {
		strMsg = @"3번 개인정보제공은 반드시 동의하셔야 합니다.";
	}
	else if ([[self.marrRadioBtnsNo4 objectAtIndex:0]isSelected] == NO) {
		strMsg = @"4번 고유식별정보 제공 동의를 하셔야합니다.";
	}
	else if ([[self.marrRadioBtnsNo5 objectAtIndex:0]isSelected] == NO) {
		strMsg = @"5번 개인신용정보 수집 동의하셔야 합니다.";
	}
	else if ([[self.marrRadioBtnsNo6 objectAtIndex:0]isSelected] == NO) {
		strMsg = @"6번 개인신용정보 제공 동의하셔야 합니다.";
	}
	else if ([[self.marrRadioBtnsNo7 objectAtIndex:0]isSelected] == NO) {
		strMsg = @"7번 고유식별정보 제공 동의를 하셔야합니다.";
	}
	else if ([[self.marrRadioBtnsNo8 objectAtIndex:0]isSelected] == NO) {
		strMsg = @"8번 고유식별정보 제공 동의를 하셔야합니다.";
	}
	else if ([[self.marrRadioBtnsNo9 objectAtIndex:0]isSelected] == NO) {
		strMsg = @"9번 신한카드 사용정보 제공동의하셔야 합니다.";
	}
    
	if (strMsg) {
		[[[[UIAlertView alloc]initWithTitle:@"" message:strMsg delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil]autorelease]show];
		
		return;
	}
    */
//	if ([[AppInfo.userInfo objectForKey:@"보안매체정보"]intValue] == 5) {
//		SHBLoanRegViewController *viewController = [[SHBLoanRegViewController alloc]initWithNibName:@"SHBLoanRegViewController" bundle:nil];
//		viewController.needsLogin = YES;
//        
//        if ([self.Loantype isEqualToString:@"A"])
//        {
//            AppInfo.commonLoanDic = @{
//            @"_대출타입" : @"A",
//
//            };
//        }
//        else
//        {
//            AppInfo.commonLoanDic = @{
//            @"_대출타입" : @"B",
//           };
//        }
//      
//		[self checkLoginBeforePushViewController:viewController animated:YES];
//		[viewController release];
//	}
	
        /*
        //임시  - 휴대폰 인증 안하고 테스트할때 사용함
        SHBLoanRegViewController *viewController = [[SHBLoanRegViewController alloc]initWithNibName:@"SHBLoanRegViewController" bundle:nil];
		viewController.needsLogin = YES;
        
        if ([self.Loantype isEqualToString:@"A"])
        {
            AppInfo.commonDic = @{
                                  @"_대출타입" : @"A",
                                  
                                  };
        }
        else
        {
            AppInfo.commonDic = @{
                                  @"_대출타입" : @"B",
                                  };
        }
        
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
        
        */
		
    
    
    // otp도 추가 인증 포함 2014.7. 26
    
        NSString *type;
    
        if ([self.Loantype isEqualToString:@"A"])
        {
            type = @"예담대-건별";
            AppInfo.commonLoanDic = @{
                                  @"_대출타입" : @"A",
                                  
                                  };
        }
        else
        {
            type = @"예담대-한도";
            AppInfo.commonLoanDic = @{
                                  @"_대출타입" : @"B",
                                  };
        }
        AppInfo.transferDic = @{ @"계좌번호_상품코드" : type,
                                 @"거래금액" : @"",
                                 @"서비스코드" : @"L1310" };
    
        SHBLoanRegViewController *viewController = [[SHBLoanRegViewController alloc]initWithNibName:@"SHBLoanRegViewController" bundle:nil];
        viewController.needsLogin = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
    
    /*
        SHBIdentity3ViewController *viewController = [[SHBIdentity3ViewController alloc]initWithNibName:@"SHBIdentity3ViewController" bundle:nil];
        
        [viewController setServiceSeq:SERVICE_LOAN];
        viewController.needsLogin = YES;
        viewController.delegate = self;
        
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
        [viewController executeWithTitle:@"예적금담보대출" Step:2 StepCnt:6 NextControllerName:@"SHBLoanRegViewController"];
        [viewController subTitle:@"추가인증 방법 선택"];
        [viewController release];
        
        
        */
	

}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopViewController];
}

- (void)radioBtnAction1_1:(UIButton *)sender
{
	for (UIButton *btn in self.marrRadioBtnsNo1_1)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)radioBtnAction1_2:(UIButton *)sender
{
	for (UIButton *btn in self.marrRadioBtnsNo1_2)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)radioBtnAction2:(UIButton *)sender
{
	for (UIButton *btn in self.marrRadioBtnsNo2)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)radioBtnAction3:(UIButton *)sender
{
	for (UIButton *btn in self.marrRadioBtnsNo3)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)radioBtnAction4:(UIButton *)sender
{
	for (UIButton *btn in self.marrRadioBtnsNo4)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)radioBtnAction5:(UIButton *)sender
{
	for (UIButton *btn in self.marrRadioBtnsNo5)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)radioBtnAction6:(UIButton *)sender
{
	for (UIButton *btn in self.marrRadioBtnsNo6)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)radioBtnAction7:(UIButton *)sender
{
	for (UIButton *btn in self.marrRadioBtnsNo7)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}

- (void)radioBtnAction8:(UIButton *)sender
{
	for (UIButton *btn in self.marrRadioBtnsNo8)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}


- (void)radioBtnAction9:(UIButton *)sender
{
	for (UIButton *btn in self.marrRadioBtnsNo9)
	{
		[btn setSelected:NO];
	}
	[sender setSelected:YES];
}
// 두번째 약관 보기
- (void)stipulationBtnAction
{
    NSString *strUrl;
	 if (!AppInfo.realServer) {
         strUrl = [NSString stringWithFormat:@"%@pci_lending_01.html", URL_YAK_TEST];
     }
     else{
         strUrl = [NSString stringWithFormat:@"%@pci_lending_01.html", URL_YAK];
     }
	SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc]initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil]autorelease];
	viewController.strUrl = strUrl;
    viewController.strName = @"예적금담보대출";
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
	if (alertView.tag == 8214) {
        
        self.service = [[[SHBProductService alloc] initWithServiceId:kC2315Id viewController:self] autorelease];
		[self.service start];
        
//		[self setStipulationView];
//		[self setAgreeInfoView];
//		[self.questionView setHidden:NO];
//		[self.bottomView setHidden:NO];
//		[self repositionBottomView];
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
            
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" message:strMsg delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil] autorelease];
			[alert setTag:8214];
			[alert show];
		}
		else {
            
            self.service = [[[SHBProductService alloc] initWithServiceId:kC2315Id viewController:self] autorelease];
            [self.service start];
            
//			[self setStipulationView];
//			[self setAgreeInfoView];
//			[self.questionView setHidden:NO];
//			[self.bottomView setHidden:NO];
//			[self repositionBottomView];
		}
	}
	else if (self.service.serviceId == kC2315Id) {
        
        self.data = aDataSet;
        
        [self setMarketingView];
    }
    else if (self.service.serviceId == kC2316Id) {
        
        [self confirmBtnAction:nil];
    }

	return NO;
}

#pragma mark - identity1 delegate

- (void)identity3ViewControllerCancel
{
    // 취소시 입력값 초기화 필요한 경우
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
            
            NSLog(@"urlStr : %@", urlStr);
            NSLog(@"marketingAgreeDic : %@", dic);
            
            Boolean isMarketingAgree = NO;
            Boolean isEssentialAgree = NO;
            
            if ([self.data[@"마케팅활용동의여부"] isEqualToString:@"1"] ||
                [self.data[@"마케팅활용동의여부"] isEqualToString:@"2"]) {
                
                isMarketingAgree = YES;
            }
            else {
                
                isMarketingAgree = NO;
            }
            
            if ([self.data[@"필수정보동의여부"] isEqualToString:@"1"]) {
                
                isEssentialAgree = YES;
            }
            else {
                
                isEssentialAgree = NO;
            }
            
            if (!isMarketingAgree || !isEssentialAgree) {
                
                // 마케팅활용에 동의하지 않은 경우
                
                SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                             @"은행구분" : @"1",
                                                                             @"검색구분" : @"1",
                                                                             @"고객번호" : AppInfo.customerNo,
                                                                             @"고객번호1" : AppInfo.customerNo,
                                                                             @"마케팅활용동의여부" : dic[@"마케팅활용동의여부"],
                                                                             @"장표출력SKIP여부" : @"1",
                                                                             @"인터넷수행여부" : @"2",
                                                                             @"필수정보동의여부" : @"1",
                                                                             @"선택정보동의여부" : dic[@"선택정보동의여부"],
                                                                             @"자택TM통지요청구분" : dic[@"자택TM통지요청구분"],
                                                                             @"직장TM통지요청구분" : dic[@"직장TM통지요청구분"],
                                                                             @"휴대폰통지요청구분" : dic[@"휴대폰통지요청구분"],
                                                                             @"SMS통지요청구분" : dic[@"SMS통지요청구분"],
                                                                             @"EMAIL통지요청구분" : dic[@"EMAIL통지요청구분"],
                                                                             @"DM희망지주소구분" : dic[@"DM희망지주소구분"],
                                                                             @"DATA존재유무" : @"",
                                                                             @"마케팅활용매체별동의" : @"1",
                                                                             }];
                
                NSLog(@"%@", dataSet);
                
                self.service = nil;
                self.service = [[[SHBProductService alloc] initWithServiceId:kC2316Id viewController:self] autorelease];
                self.service.requestData = dataSet;
                [self.service start];
            }
            else {
                
                [self confirmBtnAction:nil];
            }
            
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
