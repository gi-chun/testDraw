//
//  SHBCloseProductEndViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCloseProductEndViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"
#import "SHBNewProductNoLineRowView.h"

@interface SHBCloseProductEndViewController ()
{
	CGFloat fCurrHeight;
	BOOL isCloseTypeLoan;	// 예적금담보대출 해지인 경우
}

/**
 지급항목 : 존재하는 데이터만 가공한 데이터
 */
@property (nonatomic, retain) NSMutableArray *marrPayment;

/**
 공제항목 : 존재하는 데이터만 가공한 데이터
 */
@property (nonatomic, retain) NSMutableArray *marrDeduction;


@end

@implementation SHBCloseProductEndViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		fCurrHeight = 0;
    }
    return self;
}

- (void)dealloc {
	[_marrDeduction release];
	[_marrPayment release];
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
	[self setTitle:@"예금/적금 해지"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self navigationBackButtonHidden];	// 완료화면에서는 이전버튼이 없단다.
	
	NSInteger nMax = 0;
	NSInteger nFocus = 0;


    if (!self.dicSelectedData) {
        
        if (AppInfo.transferDic[@"dicSelectedData"]) {
            
            self.dicSelectedData = AppInfo.transferDic[@"dicSelectedData"];
        }
        
        
    }
    
    

    
    if (_confirmVC.nServiceCode == kD3281Id || _confirmVC.nServiceCode == kD3342Id) {	// 전체해지, 신탁해지
        
        if([AppInfo.Close_type isEqualToString:@"only_allClose"])
        {
           nMax = nFocus = 5;
        }
        else
        {
            nMax = nFocus = 6;
        }
   	}
    
    
      
    else if (_confirmVC.nServiceCode == kD3285Id) {	// 일부해지로 왔으면
		nMax = nFocus = 6;
	}
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"해지완료" maxStep:nMax focusStepNumber:nFocus]autorelease]];
	
	[self dataSetting];
	[self setUI];
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
- (void)setUI
{
    
;
    
    if (_confirmVC.nServiceCode == kD3342Id) {	// 신탁해지
        
        NSString *strTemp = nil;

        
        strTemp = [self.dicSelectedData objectForKey:@"해지계좌번호"];
        SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=10 title:@"해지계좌" value:strTemp]autorelease];
        [self.scrollView addSubview:row];
        
        strTemp = [self.dicSelectedData objectForKey:@"입금계좌번호"];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"입금계좌" value:strTemp] autorelease];
        [self.scrollView addSubview:row2];
        
        strTemp = AppInfo.tran_Date;
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"해지신청일" value:strTemp] autorelease];
        [self.scrollView addSubview:row3];
        
        strTemp = [self.data objectForKey:@"해지예정일"];
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"해지예정일" value:strTemp] autorelease];
        [self.scrollView addSubview:row4];
        
        fCurrHeight += 15+5;
		
		UIView *lineView2 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=10, 317, 1)]autorelease];
		[lineView2 setBackgroundColor:RGB(209, 209, 209)];
		[self.scrollView addSubview:lineView2];
		
        
        // ios7상단 스크롤
        FrameResize(self.scrollView, 317, height(self.scrollView));
        FrameReposition(self.scrollView, 0, 77);
        
        SHBButton *btnConfirm = [SHBButton buttonWithType:UIButtonTypeCustom];
        [btnConfirm setFrame:CGRectMake(83, fCurrHeight+=12, 150, 29)];
        [btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_btype1.png"] forState:UIControlStateNormal];
        [btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_btype1_focus.png"] forState:UIControlStateHighlighted];
        [btnConfirm.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [btnConfirm.titleLabel setTextColor:[UIColor whiteColor]];
        [btnConfirm setTitle:@"확인" forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btnConfirm];
        
        [self.scrollView setContentSize:CGSizeMake(width(self.scrollView), fCurrHeight+=29+12)];
        
        return;

    
    }
    else{
        SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=9 title:@"계좌번호" value:[self.data objectForKey:@"계좌번호"]]autorelease];
        [self.scrollView addSubview:row];

    }
    
	
    CGFloat fcousViewH = 0;
	UIView *focusView = [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
	[focusView setBackgroundColor:RGB(235, 217, 195)];
	[self.scrollView addSubview:focusView];
	/**
	 원금 및 이자내역 ~ 공제내역
	 */
	for (int nIdx = 0; nIdx < 4; nIdx++) {
		
		if (nIdx == 0) {
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"원금 및 이자내역" value:nil]autorelease];
			[row.lblTitle setTextColor:RGB(40, 91, 142)];
			[self.scrollView addSubview:row];
		}
		else if (nIdx == 1) {
			long long total = 0;
			for (NSDictionary *dic in self.marrPayment)
			{
				NSString *strTitle = [dic objectForKey:@"title"];
				NSString *strValue = [dic objectForKey:@"value"];
				SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:strTitle value:[NSString stringWithFormat:@"%@원", strValue]]autorelease];
				[self.scrollView addSubview:row];
				
				total += [[SHBUtility commaStringToNormalString:strValue]longLongValue];
			}
			
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"원금 및 이자 합계" value:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%qi", total]]]]autorelease];
			[self.scrollView addSubview:row];
		}
		else if (nIdx == 2) {
			UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=25, 317, 1)]autorelease];
			[lineView setBackgroundColor:RGB(209, 209, 209)];
			[self.scrollView addSubview:lineView];
			
			fcousViewH = fCurrHeight;
			FrameReposition(focusView, 0, fCurrHeight);

			
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=6 title:@"[공제내역]" value:nil]autorelease];
			[row setBackgroundColor:RGB(235, 217, 195)];
			[row.lblTitle setTextColor:RGB(40, 91, 142)];
			[self.scrollView addSubview:row];
		}
		else if (nIdx == 3) {
			for (NSDictionary *dic in self.marrDeduction)
			{
				NSString *strTitle = [dic objectForKey:@"title"];
				NSString *strValue = [dic objectForKey:@"value"];
				SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:strTitle value:[NSString stringWithFormat:@"%@원", strValue]]autorelease];
				[row setBackgroundColor:RGB(235, 217, 195)];
				[self.scrollView addSubview:row];
			}
			
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"공제합계" value:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"총공제액"]]]autorelease];
			[row setBackgroundColor:RGB(235, 217, 195)];
			[self.scrollView addSubview:row];
		}
	}
	
	if (isCloseTypeLoan) {	// 예적금 담보대출 해지일 경우
		/**
		 상환액
		 */
		for (int nIdx = 0; nIdx < 4; nIdx++) {
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight += 25]autorelease];
			[row setBackgroundColor:RGB(235, 217, 195)];
			[self.scrollView addSubview:row];
			
			if (nIdx == 0) {
				[row.lblTitle setTextColor:RGB(40, 91, 142)];
				[row.lblTitle setText:@"[상환액]"];
			}
			else if (nIdx == 1) {
				[row.lblTitle setText:@"총 지급액"];
				[row.lblValue setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"뒷면총지급액1"]]];
			}
			else if (nIdx == 2) {
				[row.lblTitle setText:@"총 공제 및 상환액"];
				[row.lblValue setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"뒷면총공제액1"]]];
			}
			else if (nIdx == 3) {
				[row.lblTitle setTextColor:RGB(0, 137, 220)];
				[row.lblValue setTextColor:RGB(0, 137, 220)];
				
				[row.lblTitle setText:@"상환 후 실 수령액"];
				[row.lblValue setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"뒷면실수령액1"]]];
			}
		}
		fCurrHeight += 15+5;
		
		UIView *lineView2 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=10, 317, 1)]autorelease];
		[lineView2 setBackgroundColor:RGB(209, 209, 209)];
		[self.scrollView addSubview:lineView2];
		
		//FrameResize(focusView, 317, fCurrHeight);
        
        // ios7상단 스크롤
        FrameResize(self.scrollView, 317, height(self.scrollView));
        FrameReposition(self.scrollView, 0, 77);
        

	}
	else	// 일반해지
	{
		for (int nIdx = 0; nIdx < 3; nIdx++) {
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight += 25]autorelease];
			[self.scrollView addSubview:row];
			
			if (nIdx == 0) {
				fCurrHeight -= 10;
				
				[row.lblTitle setText:@"받으시는 금액"];
				[row.lblTitle setTextColor:RGB(0, 137, 220)];
				FrameResize(row.lblTitle, 301, height(row.lblTitle));
			}
			else if (nIdx == 1) {
				
				[row.lblTitle setFont:[UIFont systemFontOfSize:13]];
				FrameResize(row.lblTitle, 301, height(row.lblTitle));
				[row.lblTitle setTextColor:RGB(0, 137, 220)];
				[row.lblTitle setText:@"(원금 및 이자 합계금액-공제합계금액)"];
			}
			else if (nIdx == 2) {
				[row.lblValue setTextColor:RGB(0, 137, 220)];
				[row.lblValue setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"실수령액"]]];
			}
		}
		fCurrHeight += 15+5;
		
		UIView *lineView2 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=10, 317, 1)]autorelease];
		[lineView2 setBackgroundColor:RGB(209, 209, 209)];
		[self.scrollView addSubview:lineView2];
		
        
        // ios7상단 스크롤
        FrameResize(self.scrollView, 317, height(self.scrollView));
        FrameReposition(self.scrollView, 0, 77);
        
        
		
	}
	
	SHBButton *btnConfirm = [SHBButton buttonWithType:UIButtonTypeCustom];
	[btnConfirm setFrame:CGRectMake(83, fCurrHeight+=12, 150, 29)];
	[btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_btype1.png"] forState:UIControlStateNormal];
	[btnConfirm setBackgroundImage:[UIImage imageNamed:@"btn_btype1_focus.png"] forState:UIControlStateHighlighted];
	[btnConfirm.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
	[btnConfirm.titleLabel setTextColor:[UIColor whiteColor]];
	[btnConfirm setTitle:@"확인" forState:UIControlStateNormal];
	[btnConfirm addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.scrollView addSubview:btnConfirm];
	
	[self.scrollView setContentSize:CGSizeMake(width(self.scrollView), fCurrHeight+=29+12)];
}

#pragma mark - Etc.
- (void)dataSetting
{
	// 지급항목 데이터 세팅
	self.marrPayment = [NSMutableArray array];
	for (int nIdx = 0; nIdx < 9; nIdx++) {
		NSString *strTitle = [self.data objectForKey:[NSString stringWithFormat:@"지급항목%d", nIdx+1]];
		NSString *strValue = [self.data objectForKey:[NSString stringWithFormat:@"지급내용%d", nIdx+1]];
		
		if ([strTitle length] && [strValue length]) {
			NSDictionary *dic = @{ @"title" : strTitle, @"value" : strValue };
			[self.marrPayment addObject:dic];
		}
	}
	
	// 공제항목 데이터 세팅
	self.marrDeduction = [NSMutableArray array];
	for (int nIdx = 0; nIdx < 9; nIdx++) {
		NSString *strTitle = [self.data objectForKey:[NSString stringWithFormat:@"공제항목%d", nIdx+1]];
		NSString *strValue = [self.data objectForKey:[NSString stringWithFormat:@"공제내용%d", nIdx+1]];
		
		if ([strTitle length] && [strValue length]) {
			NSDictionary *dic = @{ @"title" : strTitle, @"value" : strValue };
			[self.marrDeduction addObject:dic];
		}
	}
	
	if (![[self.data objectForKey:@"뒷면실수령액1"]length]
		|| [[self.data objectForKey:@"뒷면실수령액1"]isEqualToString:@"0"]) {
		isCloseTypeLoan = NO;
	}
	else
	{
		isCloseTypeLoan = YES;
	}
}

#pragma mark - Action
- (void)confirmBtnAction:(SHBButton *)sender
{
	[self.navigationController fadePopToRootViewController];
}

@end
