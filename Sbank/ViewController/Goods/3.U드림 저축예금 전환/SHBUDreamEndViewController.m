//
//  SHBUDreamEndViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUDreamEndViewController.h"
#import "SHBGoodsSubTitleView.h"

@interface SHBUDreamEndViewController ()
{
	CGFloat fCurrHeight;
}

@end

@implementation SHBUDreamEndViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_btnFinish release];
	[_scrollView release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setBtnFinish:nil];
	[self setScrollView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"U드림 저축예금 전환"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self navigationBackButtonHidden];	// 완료화면에서는 이전버튼이 없단다.
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"전환 완료" maxStep:3 focusStepNumber:3]autorelease]];
	
	fCurrHeight = 0;
	
	UIView *topView = [[[UIView alloc]init]autorelease];
	[topView setBackgroundColor:[UIColor whiteColor]];
	[self.scrollView addSubview:topView];
	
	CGFloat fHeight = 6;
	NSString *strGuide = @"감사합니다!\nU드림 예금 거래 서비스 전환 신청이 정상적으로 처리되었습니다.";
	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByWordWrapping];
	
	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(8, fHeight, 301, size.height)]autorelease];
	[lblGuide setNumberOfLines:0];
	[lblGuide setBackgroundColor:[UIColor clearColor]];
	[lblGuide setTextColor:RGB(40, 91, 142)];
	[lblGuide setFont:[UIFont systemFontOfSize:14]];
	[lblGuide setText:strGuide];
	[topView addSubview:lblGuide];
	fHeight += size.height + 6;
	
	[topView setFrame:CGRectMake(0, 0, 317, fHeight)];
	fCurrHeight = fHeight;
	
	UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 317, 1)]autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[topView addSubview:lineView];
	
	fCurrHeight += 8;
	
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[self.scrollView addSubview:ivInfoBox];
	
	
	fHeight = 0;
	
//	UIImageView *ivTitle1BG = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title1_bg"]]autorelease];
//	[ivTitle1BG setFrame:CGRectMake(5, fHeight, 301, 18)];
//	[ivInfoBox addSubview:ivTitle1BG];
	
	UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 301-12, 24)]autorelease];
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	[lblTitle setTextColor:RGB(133, 87, 35)];
	[lblTitle setFont:[UIFont systemFontOfSize:13]];
	[lblTitle setText:@"주의"];
	[ivInfoBox addSubview:lblTitle];
	fHeight += 24;
	
	NSMutableArray *marrGuides = [NSMutableArray array];
	[marrGuides addObject:@"U드림 예금거래 서비스는 통장을 발급하지 않습니다."];
	[marrGuides addObject:@"기존 저축 예금을 U드림 예금 거래 서비스로 전환하신 후에는 통장을 이용한 거래가 제한됩니다."];
	[marrGuides addObject:@"U드림 예금 거래 서비스의 현금카드가 없는 경우에는 영업점을 방문하여 현금카드를 발급 받을 수 있습니다."];
	[marrGuides addObject:@"U드림 예금 거래 서비스는 인터넷 뱅킹, 폰뱅킹, S뱅크(스마트폰 뱅킹), CD/ATM기 등 전자 금융과 자동화 기기를 이용하여 거래하셔야 하며, 영업점 창구를 이용하여 출금, 계좌이체 거래를 할 때에는 창구거래 수수료 1,000원을 추가로 부담하셔야 합니다.\n(단, 수신관련 수수료 징수기준 및 타 지침에서 정한 경우, 입금 또는 1일 현금 인출 한도 초과 인출, CD/ATM기 장애 등으로 인한 경우 수수료 면제)"];
	[marrGuides addObject:@"U드림 예금 거래 서비스를 일반 저축예금(통장거래 방식)으로 전환하시는 경우에는 통장 재 발행 수수료를 부담하셔야 합니다."];
	
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
	
//	strGuide = @"U드림 예금거래 서비스는 통장을 발급하지 않습니다.\n\n기존 저축 예금을 U드림 예금 거래 서비스로 전환하신 후에는 통장을 이용한 거래가 제한됩니다.\n\nU드림 예금 거래 서비스의 현금카드가 없는 경우에는 영업점을 방문하여 현금카드를 발급 받을 수 있습니다.\n\nU드림 예금 거래 서비스는 인터넷 뱅킹, 폰뱅킹, S뱅크(스마트폰 뱅킹), CD/ATM기 등 전자 금융과 자동화 기기를 이용하여 거래하셔야 하며, 영업점 창구를 이용하여 출금, 계좌이체 거래를 할 때에는 창구거래 수수료 1,000원을 추가로 부담하셔야 합니다.\n\n(단, 수신관련 수수료 징수기준 및 타 지침에서 정한 경우, 입금 또는 1일 현금 인출 한도 초과 인출, CD/ATM기 장애 등으로 인한 경우 수수료 면제)\n\nU드림 예금 거래 서비스를 일반 저축예금(통장거래 방식)으로 전환하시는 경우에는 통장 재 발행 수수료를 부담하셔야 합니다.";
//	size = [strGuide sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByWordWrapping];
//
//	
//	UILabel *lblGuide2 = [[[UILabel alloc]initWithFrame:CGRectMake(5, fHeight, 301, size.height)]autorelease];
//	[lblGuide2 setNumberOfLines:0];
//	[lblGuide2 setBackgroundColor:[UIColor clearColor]];
//	[lblGuide2 setTextColor:RGB(114, 114, 114)];
//	[lblGuide2 setFont:[UIFont systemFontOfSize:12]];
//	[lblGuide2 setText:strGuide];
//	[ivInfoBox addSubview:lblGuide2];
//	
//	fHeight += size.height + 10;
//	
//	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight, 311, fHeight)];
//	fCurrHeight += fHeight;
	
	
	FrameReposition(self.btnFinish, left(self.btnFinish), fCurrHeight+=12);
	[self.scrollView setContentSize:CGSizeMake(width(self.scrollView), fCurrHeight += 29+12)];
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
- (IBAction)confirmBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopToRootViewController];
}

@end
