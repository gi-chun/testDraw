//
//  SHBCloseProductConfirmViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCloseProductConfirmViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"
#import "SHBNewProductNoLineRowView.h"
#import "SHBUtility.h"
#import "SHBCloseProductInfoViewController.h"
#import "SHBCloseProductSecurityViewController.h"
#import "SHBIdentity1ViewController.h"
#import "SHBIdentity3ViewController.h"
#import "SHBLoanInfoViewController.h"
#import "SHBAccidentPopupView.h" // popup

@interface SHBCloseProductConfirmViewController () <SHBIdentity3Delegate>
{
	CGFloat fCurrHeight;
}

@property (nonatomic, retain) NSString *strEncryptedPW;		// 암호화된 패스워드

@end

@implementation SHBCloseProductConfirmViewController

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
	[_dataSet release];
	[_strEncryptedPW release];
	[_tfAccountPW release];
	[_marrDeduction release];
	[_marrPayment release];
	[_strPartCloseAmount release];
	[_D3280 release];
	[_bottomView release];
    [_bottomView_1 release];
    [super dealloc];
}
- (void)viewDidUnload {
	[self setBottomView:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예금/적금 해지"];
    

    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
    if (self.nServiceCode == kD3342Id ) {
        
        NSLog(@"==%@",self.name_D3342);
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle: self.name_D3342 maxStep:self.nMaxStep focusStepNumber:self.nFocusStep]autorelease]];

    }
    else{
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[[self.D3280 objectForKey:@"상품부기명"]length] ? [self.D3280 objectForKey:@"상품부기명"] : [self.D3280 objectForKey:@"상품명"] maxStep:self.nMaxStep focusStepNumber:self.nFocusStep]autorelease]];

    }
	
    self.strBackButtonTitle = [NSString stringWithFormat:@"예금적금 해지 %d단계",self.nFocusStep];
        
    
	
	SHBDataSet *dataSet = nil;
	
	if (self.nServiceCode == kD3281Id) {	// 전체해지 예상조회
		NSArray *dates = [SHBUtility getCurrentDateAgoYear:0 AgoMonth:1 AgoDay:0];
		NSString *currentDate = [dates objectAtIndex:1];
		
		dataSet = [SHBDataSet dictionaryWithDictionary:@{
				   @"계좌번호" : [self.D3280 objectForKey:@"신계좌번호"],
				   @"은행코드" : @"1",
				   @"계산서생략" : @"1",
				   @"해지조회" : @"2",
				   @"해지조회구분" : @"1",
				   @"기준일자" : currentDate,
				   @"전액구분" : @"1",
				   }];
	}
	else if (self.nServiceCode == kD3285Id) {	// 일부해지 예상조회
		dataSet = [SHBDataSet dictionaryWithDictionary:@{
				   @"계좌번호" : [self.D3280 objectForKey:@"신계좌번호"],
				   @"은행구분" : @"1",
				   @"거래점용계좌번호" : [self.D3280 objectForKey:@"신계좌번호"],
				   @"거래점용은행구분" : @"1",
				   @"해지조회" : @"2",
				   @"해지거래구분" : @"1",
				   @"계산서생략" : @"1",
				   @"일부해지구분" : @"1",
				   @"일부해지금액" : self.strPartCloseAmount,
				   @"전액구분" : @"1",
				   @"기준일자" : [self.D3280 objectForKey:@"COM_TRAN_DATE"],
				   @"전액구분" : @"1",
				   }];
	}
    
	else if (self.nServiceCode == kD3342Id) {	// 신탁해지 예상조회
		dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                         @"계좌번호" :self.account_D3342 ,
                                                         @"해지조회" : @"3",
                                                         @"해지조회구분" : @"1",
                                                         @"은행구분" : @"1",
                                                         @"조회일자" : AppInfo.tran_Date,
                                                         @"계산서생략" : @"1",
                                                         }];
	}
    
	self.service = [[[SHBProductService alloc]initWithServiceId:self.nServiceCode viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getServerError) name:@"notiESignError" object:nil];
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
- (void)setUI
{
	/**
	 가이드 텍스트
	 */
	fCurrHeight = 0;
//	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
//	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
//	[self.contentScrollView addSubview:ivInfoBox];
	UIView *vGuide = [[[UIView alloc]init]autorelease];
	[vGuide setBackgroundColor:[UIColor whiteColor]];
	[self.contentScrollView addSubview:vGuide];
	
	CGFloat fHeight = 10;
	NSString *strGuide = @"";
    if (self.nServiceCode == kD3281Id) {	// 전체해지 예상조회
        
        strGuide = @"고객님께서 가입한 상품의 내용은 아래와 같습니다.\n이체비밀번호와 보안매체를 입력하면 예금 해지 처리됩니다.\n\n예/적금 해지시 금감원 보이스피싱 방지대책 일환으로 추가 본인확인 절차가 적용됩니다.";
        
    }
    
    else if (self.nServiceCode == kD3285Id || self.nServiceCode == kD3342Id ) {	// 일부해지 예상조회
        strGuide = @"고객님께서 입력하신 내용은 아래와 같습니다.\n이체비밀번호와 보안매체를 입력하면 예금 해지 처리됩니다.\n\n예/적금 해지시 금감원 보이스피싱 방지대책 일환으로 추가 본인확인 절차가 적용됩니다.";
        
    }
	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(294, 999) lineBreakMode:NSLineBreakByWordWrapping];
	
	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(8, fHeight, 294, size.height)]autorelease];
	[lblGuide setNumberOfLines:0];
	[lblGuide setBackgroundColor:[UIColor clearColor]];
	[lblGuide setTextColor:RGB(40, 91, 142)];
	[lblGuide setFont:[UIFont systemFontOfSize:13]];
	[lblGuide setText:strGuide];
	[vGuide addSubview:lblGuide];
	
	fHeight += size.height + 10;
	
	[vGuide setFrame:CGRectMake(0, fCurrHeight, 317, fHeight)];
//	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight, 311, fHeight)];
	fCurrHeight += fHeight;
	
	UIView *lineView0 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 317, 1)]autorelease];
	[lineView0 setBackgroundColor:RGB(209, 209, 209)];
	[self.contentScrollView addSubview:lineView0];
	
	/**
	 예금종류 ~ 소득종료일
	 */	
	for (int nIdx = 0; nIdx < 9; nIdx++) {
		CGFloat fOffset = nIdx == 0 ? 10 : 25;
		SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight += fOffset]autorelease];
		[self.contentScrollView addSubview:row];
		
		if (nIdx == 0) {
			[row.lblTitle setText:@"예금종류"];
			[row.lblValue setText:[self.data objectForKey:@"상품종류"]];
		}
		else if (nIdx == 1) {
			[row.lblTitle setText:@"계좌번호"];
			[row.lblValue setText:[self.data objectForKey:@"계좌번호"]];
		}
		else if (nIdx == 2) {
			[row.lblTitle setText:@"신규가입일자"];
			[row.lblValue setText:[self.data objectForKey:@"신규일"]];
		}
		else if (nIdx == 3) {
			[row.lblTitle setText:@"만기일자"];
			[row.lblValue setText:[self.data objectForKey:@"만기일"]];
		}
		else if (nIdx == 4) {
			[row.lblTitle setText:@"적용과세"];
			[row.lblValue setText:[self.data objectForKey:@"적용과세"]];
		}
		else if (nIdx == 5) {
			[row.lblTitle setText:@"공제세금"];
			[row.lblValue setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"공제세금"]]];
		}
		else if (nIdx == 6) {
			[row.lblTitle setText:@"세금후 차감이자"];
			[row.lblValue setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"세금차감후이자"]]];
		}
		else if (nIdx == 7) {
			[row.lblTitle setText:@"소득시작일"];
			[row.lblValue setText:[self.data objectForKey:@"소득시작일"]];
		}
		else if (nIdx == 8) {
			[row.lblTitle setText:@"소득종료일"];
			[row.lblValue setText:[self.data objectForKey:@"소득종료일"]];
		}
	}
	fCurrHeight += 15+5;
	
	UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=12, 317, 1)]autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[self.contentScrollView addSubview:lineView];
	
	UIView *vMid = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=1, 317, 60)]autorelease];
	[vMid setBackgroundColor:RGB(244, 244, 244)];
	[self.contentScrollView addSubview:vMid];
	
    
    UILabel *lblMid = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 301, 60)]autorelease];
	[lblMid setBackgroundColor:[UIColor clearColor]];
    //	[lblMid setTextColor:RGB(133, 87, 35)];
	[lblMid setTextColor:RGB(74, 74, 74)];
	
	//[lblMid setText:@"실적배당상품인 경우에는 당일 조회만 가능합니다."];
	
    if ([[self.account_D3342 substringWithRange:NSMakeRange(0, 3)] intValue] == 290)
    {
        lblMid.numberOfLines=6;
        [lblMid setFont:[UIFont systemFontOfSize:11]];
        [lblMid setText:@"본 조회금액은 당일자 기준가격을 적용한 해지예상금액이며, 실제 해지시는 해지신청일 포함 제3영업일의 기준가격을 적용하므로 수령액이 달라짐에 유의 하시기 바랍니다. 적립기간 중에 연금저축신탁을 해지하는 경우에는 해지 당해연도의 납입금액은 세액공제가 불가합니다."];
    }
    else{
        [lblMid setText:@"실적배당상품인 경우에는 당일 조회만 가능합니다."];
         [lblMid setFont:[UIFont systemFontOfSize:14]];
	}
    
    [vMid addSubview:lblMid];
	UIView *lineView1 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=61, 317, 1)]autorelease];
	[lineView1 setBackgroundColor:RGB(209, 209, 209)];
	[self.contentScrollView addSubview:lineView1];
	
	/**
	 원금 및 이자내역 ~ 공제내역
	 */
	for (int nIdx = 0; nIdx < 4; nIdx++) {
		
		if (nIdx == 0) {			
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=10 title:@"[원금 및 이자내역]" value:nil]autorelease];
			[row.lblTitle setTextColor:RGB(40, 91, 142)];
			[self.contentScrollView addSubview:row];
		}
		else if (nIdx == 1) {			
			long long total = 0;
			for (NSDictionary *dic in self.marrPayment)
			{
				NSString *strTitle = [dic objectForKey:@"title"];
				NSString *strValue = [dic objectForKey:@"value"];
				SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:strTitle value:[NSString stringWithFormat:@"%@원", strValue]]autorelease];
				[self.contentScrollView addSubview:row];
				
				total += [[SHBUtility commaStringToNormalString:strValue]longLongValue];
			}
			
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"원금 및 이자 합계" value:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%qi", total]]]]autorelease];
			[self.contentScrollView addSubview:row];
		}
		else if (nIdx == 2) {
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"[공제내역]" value:nil]autorelease];
			[row.lblTitle setTextColor:RGB(40, 91, 142)];
			[self.contentScrollView addSubview:row];
		}
		else if (nIdx == 3) {
			for (NSDictionary *dic in self.marrDeduction)
			{
				NSString *strTitle = [dic objectForKey:@"title"];
				NSString *strValue = [dic objectForKey:@"value"];
				SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:strTitle value:[NSString stringWithFormat:@"%@원", strValue]]autorelease];
				[self.contentScrollView addSubview:row];
			}
       
			
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"공제합계" value:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"총공제액"]]]autorelease];
            [row.lblTitle setTextColor:RGB(0, 137, 220)];
			[row.lblValue setTextColor:RGB(0, 137, 220)];
			[self.contentScrollView addSubview:row];
		}
	}
	
	if (self.isCloseTypeLoan) {	// 예적금 담보대출 해지
		/**
		 상환액
		 */		
		for (int nIdx = 0; nIdx < 4; nIdx++) {
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight += 25]autorelease];
			[self.contentScrollView addSubview:row];
			
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
				[row.lblTitle setText:@"상환 후 실 수령액"];
				[row.lblValue setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"뒷면실수령액1"]]];
			}
		}		
		fCurrHeight += 15+5;
	
		UIView *lineView2 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=10, 317, 1)]autorelease];
		[lineView2 setBackgroundColor:RGB(209, 209, 209)];
		[self.contentScrollView addSubview:lineView2];
	}
	else	// 일반해지
	{
		fCurrHeight += 15+5;
		/**
		 받으시는 금액
		 */
		UIView *lineView2 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=10, 317, 1)]autorelease];
		[lineView2 setBackgroundColor:RGB(209, 209, 209)];
		[self.contentScrollView addSubview:lineView2];
		
		UIView *vBG = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=1, 317, 64)]autorelease];
		[vBG setBackgroundColor:RGB(244, 244, 244)];
		[self.contentScrollView addSubview:vBG];
		
		UILabel *lblAmount = [[[UILabel alloc]initWithFrame:CGRectMake(8, 7, 301, 25)]autorelease];
		[lblAmount setBackgroundColor:[UIColor clearColor]];
		[lblAmount setTextColor:RGB(40, 91, 142)];  
		[lblAmount setFont:[UIFont systemFontOfSize:15]];
		[lblAmount setAdjustsFontSizeToFitWidth:YES];
		[lblAmount setText:@"받으시는 금액 (원금 및 이자 합계금액-공제합계금액)"];
		[vBG addSubview:lblAmount];
		
		UILabel *lblAmountVal = [[[UILabel alloc]initWithFrame:CGRectMake(8, 32, 301, 25)]autorelease];
		[lblAmountVal setBackgroundColor:[UIColor clearColor]];
		[lblAmountVal setTextColor:RGB(44, 44, 44)];
		[lblAmountVal setFont:[UIFont systemFontOfSize:15]];
		[lblAmountVal setTextAlignment:NSTextAlignmentRight];
		[lblAmountVal setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"실수령액"]]];
		[vBG addSubview:lblAmountVal];
		
		UIView *lineView3 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=65, 317, 1)]autorelease];
		[lineView3 setBackgroundColor:RGB(209, 209, 209)];
		[self.contentScrollView addSubview:lineView3];
	}
	
	{	// 계좌비밀번호
		fCurrHeight +=10;
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 96, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:15]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"계좌비밀번호"];
		[self.contentScrollView addSubview:lblTitle];
		
		SHBSecureTextField *tf = [[[SHBSecureTextField alloc]initWithFrame:CGRectMake(8+88+3, fCurrHeight, 210, 30)]autorelease];
		[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[tf setPlaceholder:@"숫자 4자리"];
		[tf setFont:[UIFont systemFontOfSize:15]];
		[self.contentScrollView addSubview:tf];
		[tf showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
		[tf setTag:222000];
		self.tfAccountPW = tf;
		
		UIView *lineView3 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=40, 317, 1)]autorelease];
		[lineView3 setBackgroundColor:RGB(209, 209, 209)];
		[self.contentScrollView addSubview:lineView3];
	}
	
	{	// 입금계좌번호
		fCurrHeight +=1;
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 96, 34)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:15]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"입금계좌번호"];
		[self.contentScrollView addSubview:lblTitle];
		
		UILabel *lblVal = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 34)]autorelease];
		[lblVal setBackgroundColor:[UIColor clearColor]];
		[lblVal setFont:[UIFont systemFontOfSize:15]];
		[lblVal setTextColor:RGB(44, 44, 44)];
		[lblVal setTextAlignment:NSTextAlignmentRight];
		[lblVal setText:[self.data objectForKey:@"계좌번호1"]];
		[self.contentScrollView addSubview:lblVal];
		
		UIView *lineView3 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=35, 317, 1)]autorelease];
		[lineView3 setBackgroundColor:RGB(209, 209, 209)];
		[self.contentScrollView addSubview:lineView3];
	}
    
    {
        fCurrHeight +=3;
       
        
        UILabel *lblect = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 60)]autorelease];
        [lblect setBackgroundColor:[UIColor clearColor]];
        //	[lblMid setTextColor:RGB(133, 87, 35)];
        [lblect setTextColor:RGB(74, 74, 74)];
        
        //[lblMid setText:@"실적배당상품인 경우에는 당일 조회만 가능합니다."];
        
        NSLog(@"==== %f",fCurrHeight);
        
        if ([[self.account_D3342 substringWithRange:NSMakeRange(0, 3)] intValue] == 290)
        {
            
            
            [self.guide setHidden:NO];  // 해지 안내
            
            lblect.numberOfLines=6;
            [lblect setFont:[UIFont systemFontOfSize:11]];
            [lblect setText:@"연금신탁은 중도해지시 일반상품과 다른 세제가 적용되므로, 기타소득세의 징수로 경우에 따라서는 원금에 미달할 수 있음에 유의 하시기 바랍니다. 본 상품이 대출담보로 설정되었다면, 실제 해지시 대출금 상환으로 해지입금금액이 달라질 수 있습니다."];
        }
        else{
            [self.guide setHidden:YES];
            
            
            lblect.numberOfLines=2;
            [lblect setText:@"만기 직전 예금을 중도해지 하시는 경우 예금담보대출을 받으시면 더 유리할 수 있습니다."];
            [lblect setFont:[UIFont systemFontOfSize:13]];
        }
        
        [self.contentScrollView addSubview:lblect];
        
        
        
        
    }
	
	/**
	 확인/취소 및 컨텐트사이즈
	 */

	
    if ([[self.account_D3342 substringWithRange:NSMakeRange(0, 3)] intValue] == 290)
    {
        FrameReposition(self.bottomView_1, 0, fCurrHeight+=20);
        [self.bottomView_1 setHidden:NO];
        [self.bottomView setHidden:YES];
    }
    else{
        FrameReposition(self.bottomView, 0, fCurrHeight+=20);
         [self.bottomView setHidden:NO];
         [self.bottomView_1 setHidden:YES];
    }
    
	[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fCurrHeight+=120+12)];
	[self.contentScrollView flashScrollIndicators];
	
	contentViewHeight = fCurrHeight;
    
    startTextFieldTag = 222000;
    endTextFieldTag = 222000;
}

#pragma mark - noti
- (void)getServerError
{
	[self.navigationController fadePopViewController];
}




#pragma mark - Action
- (IBAction)confirmBtnAction:(SHBButton *)sender {
	NSString *strMsg = nil;
	
	if (![[self.data objectForKey:@"인터넷뱅킹가입여부"]isEqualToString:@"1"]) {
		strMsg = @"영업점에서 신규한 예금은 영업점에서 해지 가능합니다.";
	}
	else if ([self.tfAccountPW.text length] != 4)
	{
		strMsg = @"계좌비밀번호 4자리를 입력하여 주십시오.";
	}
	else if (![self.tfAccountPW.text length])
	{
		strMsg = @"계좌비밀번호를 입력하여 주십시오.";
	}
	
	if (strMsg) {
		[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:strMsg];
		return;
	}
    
    // 미성년자 체크
    SHBDataSet *dataSet = [SHBDataSet dictionary];
    SendData(SHBTRTypeRequst, nil, MAN_AGE_CHECK_URL, self, dataSet);
}



#pragma mark - Button


- (IBAction)infoPressed:(id)sender
{
    
    self.popupView = [[[SHBAccidentPopupView alloc] initWithTitle:@"연금신탁해지 안내문"
                                                    SubViewHeight:_infoView.frame.size.height + 4
                                                   setContentView:_infoView] autorelease];
    
     [_popupView showInView:self.navigationController.view animated:YES];
    
   // [_popupView showInView:AppDelegate.navigationController.view animated:YES];
}


- (IBAction)popupOKPressed:(id)sender
{
    [_popupView fadeOut];
}




- (IBAction)loanBtnAction:(SHBButton *)sender {
	
    SHBLoanInfoViewController *viewController = [[SHBLoanInfoViewController alloc]initWithNibName:@"SHBLoanInfoViewController" bundle:nil];
    viewController.needsCert = YES;
    [self checkLoginBeforePushViewController:viewController animated:YES];
    [viewController release];
   	
}



- (IBAction)cancelBtnAction:(SHBButton *)sender {
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBCloseProductInfoViewController class]]) {
			[self.navigationController popToViewController:viewController animated:YES];
		}
	}
}

#pragma mark - SHBSecureDelegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
	Debug(@"EncriptedVaule: %@", value);
	if (textField == self.tfAccountPW) {
		self.strEncryptedPW = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
	}
    
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
}

#pragma mark - Http Delegate
- (void)client:(OFHTTPClient *)client didReceiveDataSet:(OFDataSet *)dataSet
{
    if (![dataSet[@"result"] isEqualToString:@"true"]) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"미성년자는 법정대리인의 동의에 의해 영업점에서 예금 해지가 가능합니다."];
        
        return;
    }
    
    // 비밀번호 검증
    self.service = [[[SHBProductService alloc]initWithServiceId:kC2092Id viewController:self]autorelease];
	self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
								@"출금계좌번호" :[self.data objectForKey:@"계좌번호"],
                                @"출금계좌비밀번호" : self.strEncryptedPW,
								}];
	[self.service start];
    self.tfAccountPW.text=@"";
}

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
    
  //  NSMutableDictionary *dicSelectedData;
    self.dicSelectedData = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    
    
    if (self.service.serviceId ==kC2092Id)
    {
        
        if (self.nServiceCode == kD3285Id)
        {	// 일부해지일 경우의 데이터셋 셋팅 : D3286 보낼때 사용
            self.dataSet = [SHBDataSet dictionaryWithDictionary:@{
                            @"계좌번호" : [self.data objectForKey:@"계좌번호"],
                            @"은행구분" : @"1",
                            @"거래점용계좌번호" : [self.data objectForKey:@"계좌번호"],
                            @"거래점용은행구분" : @"1",
                            @"비밀번호2" : self.strEncryptedPW,
                            @"해지조회" : @"0",
                            @"해지거래구분" : @"1",
                            @"계산서생략" : @"1",
                            @"일부해지구분" : @"1",
                            @"일부해지금액" : self.strPartCloseAmount,
                            @"전액구분" : @"2",
                            }];
        }
        else if (self.nServiceCode == kD3281Id)
        {	// 전체해지일 경우의 데이터셋 셋팅 : D3282 보낼때 사용
            self.dataSet = [SHBDataSet dictionaryWithDictionary:@{
                            @"계좌번호" : [self.data objectForKey:@"계좌번호"],
                            @"은행코드" : @"1",
                            @"비밀번호2" : self.strEncryptedPW,
                            @"계산서생략" : @"1",
                            @"해지조회" : @"0",
                            @"연동입금금액1" : [self.data objectForKey:@"실수령액"],
                            @"연동입금계좌번호1" : [self.data objectForKey:@"계좌번호1"],
                            @"해지조회구분" : @"1",
                            @"기부구분" : @"0",
                            @"전액구분" : @"2",
                            }];
        }
        
        else if (self.nServiceCode == kD3342Id)
        {	// 전체해지일 경우의 데이터셋 셋팅 : D3343 보낼때 사용
            self.dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                  @"계좌번호" : self.account_D3342,
                                                                  @"은행구분" : @"1",
                                                                  @"비밀번호" : self.strEncryptedPW,
                                                                  @"계산서생략" : @"1",
                                                                  @"해지조회" : @"0",
                                                                  @"해지거래구분" : @"1",
                                                                  @"연동입금금액1" : [self.data objectForKey:@"실수령액"],
                                                                  @"연동입금계좌번호1" : [self.data objectForKey:@"계좌번호1"],
                                                                  @"전액구분" : @"2",
                                                                  @"해지예정등록" : @"1",
                                                                  @"적요코드" : @"135",
                                                                  }];
            
            [self.dicSelectedData setObject:[self.data objectForKey:@"상품종류"] forKey:@"상품종류"];
            [self.dicSelectedData setObject:self.account_D3342 forKey:@"해지계좌번호"];
            [self.dicSelectedData setObject:[self.data objectForKey:@"계좌번호1"] forKey:@"입금계좌번호"];
        }
        
        
       
   //otp일때도 추가인증 적용 2014. 7. 26일
//        
//        if ([[AppInfo.userInfo objectForKey:@"보안매체정보"]intValue] == 5) {	// OTP면 바로 다음 화면으로
//            SHBCloseProductSecurityViewController *viewController = [[SHBCloseProductSecurityViewController alloc]initWithNibName:@"SHBCloseProductSecurityViewController" bundle:nil];
//            viewController.dicSelectedData= self.dicSelectedData;
//            viewController.needsLogin = YES;
//            [self checkLoginBeforePushViewController:viewController animated:YES];
//            [viewController release];
//        }
//        else	// OTP가 아니면 휴대폰 인증 화면으로
//        {
//
        
            if (self.nServiceCode == kD3281Id) {	// 전체해지로 왔으면
                AppInfo.transferDic = @{ @"계좌번호_상품코드" : [self.data[@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                         @"거래금액" : [self.data[@"실수령액"] stringByReplacingOccurrencesOfString:@"," withString:@""],
                                         @"서비스코드" : @"D3282" };
            }
            else if (self.nServiceCode == kD3285Id) {	// 일부해지로 왔으면
                AppInfo.transferDic = @{ @"계좌번호_상품코드" : [self.data[@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                         @"거래금액" : [self.strPartCloseAmount stringByReplacingOccurrencesOfString:@"," withString:@""],
                                         @"서비스코드" : @"D3286" };
            }
            else if (self.nServiceCode == kD3342Id) {	// 신탁
                AppInfo.transferDic = @{ @"계좌번호_상품코드" : [self.account_D3342 stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                         @"거래금액" : [self.data[@"실수령액"] stringByReplacingOccurrencesOfString:@"," withString:@""],
                                         @"서비스코드" : @"D3343",
                                         @"dicSelectedData" : self.dicSelectedData };
            }
            
            SHBIdentity3ViewController *viewController = [[SHBIdentity3ViewController alloc]initWithNibName:@"SHBIdentity3ViewController" bundle:nil];
            [viewController setServiceSeq:SERVICE_CANCEL_GOODS];
            viewController.needsLogin = YES;
        
            //if ([[[self.data objectForKey:@"실수령액"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] > 1000001)  // 101만원 이상이면 ars 방식 체크
            if ([[[self.data objectForKey:@"실수령액"] stringByReplacingOccurrencesOfString:@"," withString:@""] intValue] > 1000000)  // 100만원보다 크면 ars 방식 체크
            {
                viewController.is100Over = YES;
            }
            else
            {
                viewController.is100Over = NO;
            }
        
            viewController.delegate = self;
            [self checkLoginBeforePushViewController:viewController animated:YES];
            
            // Title:네이게이션용 타이틀 Step:휴대폰인증 단계 StepCnt:전체단계 NextCon...:휴대폰인증 완료후 나와야 하는 클래스명
            [viewController executeWithTitle:@"예금/적금 해지" Step:self.nFocusStep+1 StepCnt:self.nMaxStep NextControllerName:@"SHBCloseProductSecurityViewController"];
            [viewController subTitle:@"추가인증 방법 선택"];

            [viewController release];
            
         //  NSLog(@"+++ == %@",[self.dicSelectedData objectForKey:@"상품종류"]);
 
            
            }

        
   // }
	
    
    
	if (self.service.serviceId == kD3281Id || self.service.serviceId == kD3285Id || self.service.serviceId == kD3342Id ) {
		self.data = aDataSet;
		
        
        
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
			self.isCloseTypeLoan = NO;
		}
		else
		{
			self.isCloseTypeLoan = YES;
		}
		
		[self setUI];
	}
	else if (self.service.serviceId == kD3285Id) {
		
        
	}
	
    return NO;
}

#pragma mark - identity1 delegate

- (void)identity1ViewControllerCancel
{
    // 취소시 입력값 초기화 필요한 경우
}

@end
