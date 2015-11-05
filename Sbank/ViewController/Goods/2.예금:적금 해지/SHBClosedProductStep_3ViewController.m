//
//  SHBClosedProductStep_3ViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 12. 6..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBClosedProductStep_3ViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductNoLineRowView.h"





@implementation SHBClosedProductStep_3ViewController

@synthesize dicData;


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
    [_scrollView release];
	[super dealloc];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"해지현황조회"];
    [self.view setBackgroundColor:RGB(244, 239, 233)];
     [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"해지계산서 조회"] maxStep:0 focusStepNumber:0]autorelease]];
    

    // ios7상단 스크롤
    FrameResize(self.scrollView, 317, height(self.scrollView));
    FrameReposition(self.scrollView, 0, 77);
  
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
    [self.scrollView addSubview:ivInfoBox];
    
    CGFloat fHeight = 5;
    
    UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
    [ivBullet setFrame:CGRectMake(5, fHeight+4, 7, 7)];
    [ivInfoBox addSubview:ivBullet];
    

	
	NSString *strGuide = @"";
    
     strGuide = @"보다 상세한 내역은 영업점 또는 인터넷뱅킹에서 확인 하실 수 있습니다.";
    
    
	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(294, 999) lineBreakMode:NSLineBreakByWordWrapping];
	
	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5+7+3, fHeight, 284, size.height)]autorelease];
	[lblGuide setNumberOfLines:0];
	[lblGuide setBackgroundColor:[UIColor clearColor]];
	[lblGuide setTextColor:RGB(114, 114, 114)];
	[lblGuide setFont:[UIFont systemFontOfSize:13]];
	[lblGuide setText:strGuide];
	[ivInfoBox addSubview:lblGuide];
	
	fHeight += size.height + 5;
	
	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight+5, 311, fHeight)];
	fCurrHeight += fHeight;
    
	[self setNoLineRowView];


}


#pragma mark - UI
- (void)setNoLineRowView
{
    NSString *strTemp = nil;
    
     strTemp = [dicData objectForKey:@"성명"];
     SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=10 title:@"성명" value:[NSString stringWithFormat:@"%@ 귀하",strTemp]] autorelease];
     [self.scrollView addSubview:row1];
    
    
    strTemp = [dicData objectForKey:@"계좌번호"];
    SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"계좌번호" value:strTemp] autorelease];
    [self.scrollView addSubview:row2];
    
    strTemp = [dicData objectForKey:@"상품종류"];
    SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"상품종류" value:strTemp] autorelease];
    [self.scrollView addSubview:row3];
    
    strTemp = [dicData objectForKey:@"거래구분"];
    SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"거래구분" value:strTemp] autorelease];
    [self.scrollView addSubview:row4];
    
    
    strTemp = [dicData objectForKey:@"적용과세"];
    SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적용과세" value:strTemp] autorelease];
    [self.scrollView addSubview:row5];
    
    strTemp = [dicData objectForKey:@"신규일"];
    SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규일" value:strTemp] autorelease];
    [self.scrollView addSubview:row6];
    
    strTemp = [dicData objectForKey:@"만기일"];
    SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"만기일" value:strTemp] autorelease];
    [self.scrollView addSubview:row7];
    
    strTemp = [dicData objectForKey:@"소득시작일"];
    SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"소득시작일" value:strTemp] autorelease];
    [self.scrollView addSubview:row8];
    
    strTemp = [dicData objectForKey:@"소득종료일"];
    SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"소득종료일" value:strTemp] autorelease];
    [self.scrollView addSubview:row9];
    
    strTemp = [dicData objectForKey:@"통장잔액"];
    SHBNewProductNoLineRowView *row10 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"통장잔액" value:[NSString stringWithFormat:@"%@원",strTemp]]autorelease];
    [self.scrollView addSubview:row10];
    
    strTemp = [dicData objectForKey:@"이자합계"];
    SHBNewProductNoLineRowView *row11 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"이자합계" value:[NSString stringWithFormat:@"%@원",strTemp]] autorelease];
    [self.scrollView addSubview:row11];
    
    strTemp = [dicData objectForKey:@"공제세금"];
    SHBNewProductNoLineRowView *row12 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"공제세금" value:[NSString stringWithFormat:@"%@원",strTemp]] autorelease];
    [self.scrollView addSubview:row12];
    
    strTemp = [dicData objectForKey:@"세금차감후이자"];
    SHBNewProductNoLineRowView *row13 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"세후이자" value:[NSString stringWithFormat:@"%@원",strTemp]] autorelease];
    [self.scrollView addSubview:row13];
    
    
    fCurrHeight += 25;
    UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 317, 1)]autorelease];
    [lineView setBackgroundColor:RGB(209, 209, 209)];
    [self.scrollView addSubview:lineView];
    
    
    strTemp = [dicData objectForKey:@"실수령액"];
    SHBNewProductNoLineRowView *row14 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=5 title:@"실제로 받으시는 금액" value:[NSString stringWithFormat:@"%@원",strTemp]] autorelease];
    [row14.lblTitle setTextColor:RGB(0, 137, 220)];
    [row14.lblValue setTextColor:RGB(0, 137, 220)];
    [self.scrollView addSubview:row14];


    SHBNewProductNoLineRowView *row15 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=13 title:@"(받으시는 합계금액 - 공제 합계 금액)" value:@""] autorelease];
    [row15.lblTitle setFont:[UIFont systemFontOfSize:13]];
    [self.scrollView addSubview:row15];
    
    
    SHBButton *btnConfirm = [SHBButton buttonWithType:UIButtonTypeCustom];
	[btnConfirm setFrame:CGRectMake(83, fCurrHeight+=30, 150, 29)];
	[btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_btype1.png"] forState:UIControlStateNormal];
	[btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_btype1_focus.png"] forState:UIControlStateHighlighted];
	[btnConfirm.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
	[btnConfirm.titleLabel setTextColor:[UIColor whiteColor]];
	[btnConfirm setTitle:@"확인" forState:UIControlStateNormal];
	[btnConfirm addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.scrollView addSubview:btnConfirm];
	
	[self.scrollView setContentSize:CGSizeMake(width(self.scrollView), fCurrHeight+=29+22)];



    

}


#pragma mark - Action
- (void)confirmBtnAction:(SHBButton *)sender
{
	[self.navigationController fadePopViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
