


//
//  SHBNewProductRegEndViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBELD_BA17_15_EndViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductListViewController.h"
#import "SHBNewProductNoLineRowView.h"

@interface SHBELD_BA17_15_EndViewController ()
{
	CGFloat fCurrHeight;
}

@property (nonatomic, retain) NSMutableArray *interString;	// 이자지급방법

@end

@implementation SHBELD_BA17_15_EndViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_interString release];
	[_dicSelectedData release];
	[_userItem release];
	[_completeData release];
    [_scrollView release];
    [_bottomBackView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setBottomBackView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예금/적금 가입"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];

	
	[self navigationBackButtonHidden];	// 완료화면에서는 이전버튼이 없단다.
	
   // NSString *title = [self.dicSelectedData objectForKey:@"상품한글명"];
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"가입완료"] maxStep:5 focusStepNumber:5]autorelease]];
   
	fCurrHeight = 0;
	
	UIView *topView = [[[UIView alloc]init]autorelease];
	[topView setBackgroundColor:[UIColor whiteColor]];
	[self.scrollView addSubview:topView];
	
	CGFloat fHeight = 27;
	NSString *strGuide = @"";
    
    
    if ([self.userItem objectForKey:@"eld가입"]) { // eld
        strGuide = [NSString stringWithFormat:@"감사합니다!\n\"%@\" 신규가 정상적으로 처리되었습니다.", [self.userItem objectForKey:@"상품한글명"]];
    }
    else if ([self.userItem objectForKey:@"골드테크가입"]) { //골드테크가입
        strGuide = [NSString stringWithFormat:@"감사합니다!\n\"%@\" 신규가 정상적으로 처리되었습니다.", [self.userItem objectForKey:@"상품명"]];
    }

    
	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByWordWrapping];
	
	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(8, fHeight, 301, size.height)]autorelease];
	[lblGuide setNumberOfLines:0];
	[lblGuide setBackgroundColor:[UIColor clearColor]];
	[lblGuide setTextColor:RGB(40, 91, 142)];
	[lblGuide setFont:[UIFont systemFontOfSize:13]];
	[lblGuide setText:strGuide];
	[topView addSubview:lblGuide];
	fHeight += size.height + 6;
	
	[topView setFrame:CGRectMake(0, 0, 317, fHeight)];
	fCurrHeight = fHeight;  
	
	UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 317, 1)]autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[topView addSubview:lineView];
	
	
	[self setNoLineRowView];
	
	FrameReposition(self.bottomBackView, left(self.bottomBackView), fCurrHeight+=12);
	[self.scrollView setContentSize:CGSizeMake(width(self.scrollView), fCurrHeight += 53)];
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

#pragma mark - UI
- (void)setNoLineRowView
{
    
    NSString *strTemp = nil;
            
   	if ([self.userItem objectForKey:@"eld가입"]) { // eld
     
        strTemp = [[self.completeData objectForKey:@"부기명"]length] ? [NSString stringWithFormat:@"%@(%@)", [self.dicSelectedData objectForKey:@"상품한글명"], [self.completeData objectForKey:@"부기명"]] : [self.dicSelectedData objectForKey:@"상품한글명"];
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=10 title:@"예금명" value:strTemp isTicker:YES]autorelease];
        [self.scrollView addSubview:row1];
        
        strTemp = [self.completeData objectForKey:@"계좌번호"];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"신규계좌번호" value:strTemp]autorelease];
        [self.scrollView addSubview:row2];
		
        strTemp = [NSString stringWithFormat:@"지수연동예금"];
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"적립방식" value:strTemp]autorelease];
        [self.scrollView addSubview:row3];
        
        strTemp = [NSString stringWithFormat:@"%@ 원",[self.completeData objectForKey:@"거래금액"]];
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"최초가입액" value:strTemp] autorelease];
        [self.scrollView addSubview:row4];
        
        
        strTemp = [NSString stringWithFormat:@"%@",[self.completeData objectForKey:@"신규일"]];
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규일" value:strTemp] autorelease];
        [self.scrollView addSubview:row5];
        
        
        strTemp = [NSString stringWithFormat:@"%@",[self.completeData objectForKey:@"만기일"]];
        SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"만기일" value:strTemp] autorelease];
        [self.scrollView addSubview:row6];
        
        
        if ([[self.userItem objectForKey:@"세금우대"]isEqualToString:@"0"]) {
            strTemp = [NSString stringWithFormat:@"일반과세"];
        }
        else if ([[self.userItem objectForKey:@"세금우대"]isEqualToString:@"1"]) {
            strTemp = [NSString stringWithFormat:@"세금우대"];
        }
        else if ([[self.userItem objectForKey:@"세금우대"]isEqualToString:@"2"]) {
            strTemp = [NSString stringWithFormat:@"비과세(생계형)"];
        }
        SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"적용과세" value:strTemp]autorelease];
        [self.scrollView addSubview:row7];
        
        
        strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
        SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp]autorelease];
        [self.scrollView addSubview:row8];
        
        
        
        if ([[self.userItem objectForKey:@"이자지급방법"] isEqualToString:@"1"]) {
            strTemp = [NSString stringWithFormat:@"이자지급식"];
        }
        else {
            strTemp = [NSString stringWithFormat:@"만기일시지급식"];
        }
        SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"이자지급방법" value:strTemp]autorelease];
        [self.scrollView addSubview:row9];
        
        SHBNewProductNoLineRowView *row10 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"상품설명서 받기 여부" value:@"받음"]autorelease];
        [self.scrollView addSubview:row10];
        
        SHBNewProductNoLineRowView *row11 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"약관 받기 여부" value:@"받음"]autorelease];
        [self.scrollView addSubview:row11];
        
        fCurrHeight += 15+5;
	}
	
	
    
    else if ([self.userItem objectForKey:@"골드테크가입"]) { //골드테크가입
        
        
        strTemp =  AppInfo.tran_Date;
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=10 title:@"거래일자" value:strTemp] autorelease];
        [self.scrollView addSubview:row1];
        
        strTemp = [self.completeData objectForKey:@"고객성명"];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"고객명" value:strTemp] autorelease];
        [self.scrollView addSubview:row2];

        
        strTemp = [self.completeData objectForKey:@"신규계좌번호"];
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규계좌번호" value:strTemp] autorelease];
        [self.scrollView addSubview:row3];
        
        strTemp = [NSString stringWithFormat:@"%@g",[self.completeData objectForKey:@"외화합계"]];
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규량" value:strTemp] autorelease];
        [self.scrollView addSubview:row4];
        
        strTemp = [NSString stringWithFormat:@"%@g",[self.completeData objectForKey:@"외화합계"]];
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"POSITION" value:strTemp] autorelease];
        [self.scrollView addSubview:row5];
        
        strTemp = [self.userItem objectForKey:@"통화코드"];
        SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"통화코드" value:strTemp] autorelease];
        [self.scrollView addSubview:row6];
        
        strTemp = [self.userItem objectForKey:@"적용환율"];
        SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"환율" value:strTemp] autorelease];
        [self.scrollView addSubview:row7];
        
        strTemp = [NSString stringWithFormat:@"%@원",[self.completeData objectForKey:@"원화합계"]];
        SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"금액" value:strTemp] autorelease];
        [self.scrollView addSubview:row8];
        
        
        strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
        
        SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp] autorelease];
        [self.scrollView addSubview:row9];

        fCurrHeight += 15+5;

    }


}

#pragma mark - Etc.

#pragma mark - Action
- (IBAction)confirmBtnAction:(SHBButton *)sender {
  
    
	[self.navigationController fadePopToRootViewController];
}

@end
