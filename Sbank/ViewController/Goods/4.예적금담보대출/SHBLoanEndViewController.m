//
//  SHBLoanEndViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBLoanEndViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"
#import "SHBNewProductNoLineRowView.h"

@interface SHBLoanEndViewController ()
{
	CGFloat fCurrHeight;
}

@end

@implementation SHBLoanEndViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		fCurrHeight = 20;
    }
    return self;
}

- (void)dealloc {
	[_L1312 release];
	[_userItem release];
	[_scrollView release];
	[_btnConfirm release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setScrollView:nil];
	[self setBtnConfirm:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예적금담보대출"];
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예적금담보대출 신청 완료" maxStep:6 focusStepNumber:6]autorelease]];
	[self navigationBackButtonHidden];	// 완료화면에서는 이전버튼이 없단다.
	
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;

    
    if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
    {
        self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00001_4 viewController:self]autorelease];
        [self.service start];
    }
    else
    {
        self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00001_7 viewController:self]autorelease];
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
	[self.scrollView flashScrollIndicators];
}

#pragma mark - UI
- (void)setUI
{
	{
		UIView *vTitle = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 317, 40)]autorelease];
		[vTitle setBackgroundColor:[UIColor whiteColor]];
		[self.scrollView addSubview:vTitle];
		
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 301, 40)]autorelease];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setTextColor:RGB(40, 91, 142)];
		[lbl setFont:[UIFont systemFontOfSize:13]];
		[lbl setText:[NSString stringWithFormat:@"%@\n거래시간 [%@ %@]", @"예적금 담보 대출을 처리 하였습니다.", AppInfo.tran_Date, AppInfo.tran_Time]];
		[lbl setNumberOfLines:0];
		[vTitle addSubview:lbl];
		
		UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=40, 317, 1)]autorelease];
		[lineView setBackgroundColor:RGB(209, 209, 209)];
		[self.scrollView addSubview:lineView];
		fCurrHeight+=1;
	}
	
	for (int nIdx = 0; nIdx < 13; nIdx++) {
		CGFloat fOffSet = nIdx == 0 ? 9 : 25;
		SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight += fOffSet]autorelease];
		[self.scrollView addSubview:row];
		
		if (nIdx == 0) {
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                [row.lblTitle setText:@"고객명"];
                [row.lblValue setText:[self.L1312 objectForKey:@"고객명"]];
            }
            else{
                [row.lblTitle setText:@"상품명"];
               // [row.lblValue setText:[self.L1312 objectForKey:@"상품명"]];
                
                NSString *str = [self.L1312 objectForKey:@"상품명"];
                CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width(row.lblValue), 999) lineBreakMode:NSLineBreakByCharWrapping];
                
                FrameResize(row.lblValue, width(row.lblValue), size.height);
                [row.lblValue setTextAlignment:NSTextAlignmentLeft];
                [row.lblValue setNumberOfLines:0];
                [row.lblValue setText:str];
                
                fCurrHeight -= 25;
                fCurrHeight += size.height;
            }
            
			
		}
		else if (nIdx == 1) {
			[row.lblTitle setText:@"대출구분"];
			
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                NSString *str = @"<가계>일반자금대출 예금담보대출";
                CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width(row.lblValue), 999) lineBreakMode:NSLineBreakByCharWrapping];
                
                FrameResize(row.lblValue, width(row.lblValue), size.height);
                [row.lblValue setTextAlignment:NSTextAlignmentLeft];
                [row.lblValue setNumberOfLines:0];
                [row.lblValue setText:str];
                
                fCurrHeight -= 25;
                fCurrHeight += size.height;
            }
            else{
                [row.lblValue setText:@"신규"];
            }
			
		}
		else if (nIdx == 2) {
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                [row.lblTitle setText:@"담보예금 계좌번호"];
            }
            else{
                [row.lblTitle setText:@"담보예금 설정계좌"];
            }
			
			[row.lblValue setText:[self.L1312 objectForKey:@"담보계좌번호"]];
		}
		else if (nIdx == 3) {
			[row.lblTitle setText:nil];
			[row.lblValue setText:[self.userItem objectForKey:@"상품명"]];
            
		}
		else if (nIdx == 4) {
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                [row.lblTitle setText:@"대출계좌번호"];
                [row.lblValue setText:[self.L1312 objectForKey:@"대출계좌번호"]];
            }
            else
            {
                [row.lblTitle setText:@"대출상환기일"];
                [row.lblValue setText:[self.L1312 objectForKey:@"약정만기일"]];
            }
            
		}
		else if (nIdx == 5) {
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                [row.lblTitle setText:@"입금계좌번호"];
            }
            else
            {
                [row.lblTitle setText:@"한도설정계좌"];
            }
			
			[row.lblValue setText:[self.userItem objectForKey:@"입금계좌번호출력용"]];
		}
		else if (nIdx == 6) {
			[row.lblTitle setTextColor:RGB(209, 75, 75)];
			[row.lblValue setTextColor:RGB(209, 75, 75)];
			
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                [row.lblTitle setText:@"대출신청 금액"];
                [row.lblValue setText:[NSString stringWithFormat:@"%@원", [self.L1312 objectForKey:@"실행금액"]]];
            }
			else
            {
                [row.lblTitle setText:@"대출받으신 금액"];
                [row.lblValue setText:[NSString stringWithFormat:@"%@원", [self.userItem objectForKey:@"실행금액"]]];
            }
            
            
		}
		
		else if (nIdx ==7) {
			[row.lblTitle setTextColor:RGB(209, 75, 75)];
			[row.lblValue setTextColor:RGB(209, 75, 75)];
			
			[row.lblTitle setText:@"대출이율"];
			
			NSString *str = nil;
			if ([[[self.L1312 objectForKey:@"담보계좌번호"]substringWithRange:NSMakeRange(0, 3)]isEqualToString:@"223"]) {
				str = @"CD금리 +";
			}
			else
			{
				str = @"예금금리 +";
			}
			
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
               [row.lblValue setText:[NSString stringWithFormat:@"%@ %.2f%%", str, [[self.L1312 objectForKey:@"대출이율"]floatValue]]];
            }
            else
            {
               [row.lblValue setText:[NSString stringWithFormat:@"%@ %.2f%%", str, [[self.L1312 objectForKey:@"이율"]floatValue]]];
            }
           
		}
        
        
		else if (nIdx == 8) {
            
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                [row.lblTitle setText:@"이자 납입일"];
                [row.lblValue setText:[self.L1312 objectForKey:@"다음이자 납일일"]];
            }
            else
            {
                [row.lblTitle setText:@"지연배상금율"];
                [row.lblValue setText:[NSString stringWithFormat:@"최고 %@",AppInfo.versionInfo[@"지연배상금율_MSG"]]];
            }
			
		}
		else if (nIdx == 9) {
			[row.lblTitle setText:@"인지세"];
			[row.lblValue setText:[self.userItem objectForKey:@"인지세출력용"]];
		}
		else if (nIdx == 10) {
			[row.lblTitle setText:@"권유자 직원번호"];
			[row.lblValue setText:[self.userItem objectForKey:@"권유자"]];
		}
        
       
		else if (nIdx == 11) {
			[row.lblTitle setText:@"대출용도"];
			NSString *str = nil;
             
             if ([[self.userItem objectForKey:@"대출용도출력용"] isEqualToString:@"기타(세부자금용도 직접입력)"])
            {
                str = [NSString stringWithFormat:@"기타(%@)",[self.userItem objectForKey:@"금감원자금용도기타내용"]];
                
            }
            else
            {
               str = [self.userItem objectForKey:@"대출용도출력용"];
            }
            
			CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width(row.lblValue), 999) lineBreakMode:NSLineBreakByCharWrapping];
			
			FrameResize(row.lblValue, width(row.lblValue), size.height);
			[row.lblValue setTextAlignment:size.height > 19 ? NSTextAlignmentLeft : NSTextAlignmentRight];
			[row.lblValue setNumberOfLines:0];
			[row.lblValue setText:str];
			
			fCurrHeight -= 25;
			fCurrHeight += size.height;
		}
	}
	fCurrHeight += 15+5;
	
	{
		UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=10, 317, 1)]autorelease];
		[lineView setBackgroundColor:RGB(209, 209, 209)];
		[self.scrollView addSubview:lineView];
		fCurrHeight+=1;
	}
	
	{
        NSString *strGuide;
        if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
        {
            strGuide = @"처리결과조회는 계좌별 거래 명세서에서 할 수 있습니다.\n대출금 이자납입은 상기 이자납입일에 대출금이 입금된 계좌로부터 자동 인출됩니다.\n고객님께서 약정하신 대출과 관련된 인지비용을 면제하여 드렸습니다.";
        }
        else
        {
            strGuide = @"대출금 이자납부는 매월 첫째주 토요일에 대출계좌로부터 자동인출됩니다. 은행여신거래기본약관은 홈페이지상에서 열람하실 수 있습니다.";
        }
        
        CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(284, 999) lineBreakMode:NSLineBreakByWordWrapping];

		
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight+=10, 301, size.height)]autorelease];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setTextColor:RGB(120, 69, 11)];
		[lbl setFont:[UIFont systemFontOfSize:14]];
		[lbl setText:strGuide];
		[lbl setNumberOfLines:0];
		[self.scrollView addSubview:lbl];
		
		fCurrHeight += size.height+10;
	}
	
	{
		UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
		UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[self.scrollView addSubview:ivInfoBox];
		
		CGFloat fHeight = 5;
		
		NSMutableArray *marrGuides = [NSMutableArray array];
		for (int nIdx = 1; nIdx < 5; nIdx ++) {
			NSString *strKey = [NSString stringWithFormat:@"메시지%d", nIdx];
			NSString *strValue  = [self.data objectForKey:strKey];
			
			if ([strValue length] > 0) {
				[marrGuides addObject:strValue];
			}
		}
		
		for (NSString *strGuide in marrGuides)
		{
			CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(284, 999) lineBreakMode:NSLineBreakByWordWrapping];
			
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
		
		[ivInfoBox setFrame:CGRectMake(3, fCurrHeight += 6, 311, fHeight)];
		fCurrHeight += fHeight;
	}
	
	FrameReposition(self.btnConfirm, left(self.btnConfirm), fCurrHeight+=12);
	[self.btnConfirm setHidden:NO];
	[self.scrollView setContentSize:CGSizeMake(width(self.scrollView), fCurrHeight+=29+12)];
	[self.scrollView flashScrollIndicators];
}

#pragma mark - Action
- (IBAction)confirmBtnAction:(SHBButton *)sender {
	[self.navigationController fadePopToRootViewController];
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
	if (self.service.serviceId == XDA_S00001_4)
	{
		Debug(@"aDataSet : %@", aDataSet);
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
		
		self.data = aDataSet;
		[self setUI];
	}
    else if(self.service.serviceId == XDA_S00001_7)
    {
        self.data = aDataSet;
		[self setUI];
    }
    
	
	return NO;
}

@end
