//
//  SHBCloseProductSecurityViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCloseProductSecurityViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductNoLineRowView.h"
#import "SHBUtility.h"
#import "SHBProductService.h"
#import "SHBCloseProductInfoViewController.h"
#import "SHBCloseProductEndViewController.h"

@interface SHBCloseProductSecurityViewController ()
{
	CGFloat fCurrHeight;

}


@end

@implementation SHBCloseProductSecurityViewController




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
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	[_otpViewController release];
	[_cardViewController release];
	[super dealloc];
}
- (void)viewDidUnload {
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	for (SHBCloseProductConfirmViewController *vc in self.navigationController.viewControllers)
	{
		if ([vc isKindOfClass:[SHBCloseProductConfirmViewController class]]) {
			_confirmVC = vc;
			self.data = vc.data;
			
			break;
		}
	}
	
	[self setTitle:@"예금/적금 해지"];
   	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	NSInteger nMax = 0;
	NSInteger nFocus = 0;
    
    if (!self.dicSelectedData) {
        
        if (AppInfo.transferDic[@"dicSelectedData"]) {
            
            self.dicSelectedData = AppInfo.transferDic[@"dicSelectedData"];
        }
    }
    
    if (_confirmVC.nServiceCode == kD3281Id || _confirmVC.nServiceCode == kD3342Id) {	// 전체해지로 왔으면
        
        if([AppInfo.Close_type isEqualToString:@"only_allClose"])
        {
            nMax = 5;
            nFocus = 4;
        }
        else
        {
   		nMax = 6;
   		nFocus = 5;
        }
   	}
	else if (_confirmVC.nServiceCode == kD3285Id) {	// 일부해지로 왔으면
		nMax = 6;
		nFocus = 5;
	}
    
    
    NSString *title_1 =[NSString stringWithFormat:@"%@",[self.dicSelectedData objectForKey:@"상품종류"]];

    if (_confirmVC.nServiceCode == kD3342Id) {
        
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 확인", title_1] maxStep:nMax focusStepNumber:nFocus]autorelease]];
   
    }
    else{
        NSString *title = [[_confirmVC.D3280 objectForKey:@"상품부기명"]length] ? [_confirmVC.D3280 objectForKey:@"상품부기명"] : [_confirmVC.D3280 objectForKey:@"상품명"];
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 확인", title] maxStep:nMax focusStepNumber:nFocus]autorelease]];

    }
    
	   
     self.strBackButtonTitle = [NSString stringWithFormat:@"예금적금 해지 %d단계",nFocus];
	
	/**
	 원금 및 이자내역 ~ 공제내역
	 */
	CGFloat fcousViewH = 0;
	UIView *focusView = [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
	[focusView setBackgroundColor:RGB(235, 217, 195)];
	[self.contentScrollView addSubview:focusView];
	
	for (int nIdx = 0; nIdx < 4; nIdx++) {
		
		if (nIdx == 0) {
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=9 title:@"[원금 및 이자내역]" value:nil]autorelease];
			[row.lblTitle setTextColor:RGB(40, 91, 142)];
			[self.contentScrollView addSubview:row];
		}
		else if (nIdx == 1) {
			long long total = 0;
			for (NSDictionary *dic in _confirmVC.marrPayment)
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
			
			UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=25, 317, 1)]autorelease];
			[lineView setBackgroundColor:RGB(209, 209, 209)];
			[self.contentScrollView addSubview:lineView];
			
			fcousViewH = fCurrHeight;
			FrameReposition(focusView, 0, fCurrHeight);

			
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=6 title:@"[공제내역]" value:nil]autorelease];
			[row.lblTitle setTextColor:RGB(40, 91, 142)];
			[self.contentScrollView addSubview:row];
			
			
//			UIView *lineView1 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=25, 317, 1)]autorelease];
//			[lineView1 setBackgroundColor:RGB(209, 209, 209)];
//			[self.contentScrollView addSubview:lineView1];
		}
		else if (nIdx == 3) {
//			fCurrHeight -= 25;
			
			for (NSDictionary *dic in _confirmVC.marrDeduction)
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
	
	if (_confirmVC.isCloseTypeLoan) {	// 예적금 담보대출 해지
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
		

        FrameResize(focusView, 317, fCurrHeight-fcousViewH);
       // FrameResize(focusView, 317, fCurrHeight);
	}
	else	// 일반해지
	{
		for (int nIdx = 0; nIdx < 3; nIdx++) {
			SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight += 25]autorelease];
			[self.contentScrollView addSubview:row];
			
			if (nIdx == 0) {
				fCurrHeight -= 10;
				
				[row.lblTitle setText:@"받으시는 금액"];
				FrameResize(row.lblTitle, 301, height(row.lblTitle));
                [row.lblTitle setTextColor:RGB(40, 91, 142)];
			}
			else if (nIdx == 1) {
				
				[row.lblTitle setFont:[UIFont systemFontOfSize:13]];
				FrameResize(row.lblTitle, 301, height(row.lblTitle));
				[row.lblTitle setText:@"(원금 및 이자 합계금액-공제합계금액)"];
                [row.lblTitle setTextColor:RGB(40, 91, 142)];
			}
			else if (nIdx == 2) {
				[row.lblValue setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"실수령액"]]];
			}
		}
		fCurrHeight += 15+5;
		
		UIView *lineView2 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=10, 317, 1)]autorelease];
		[lineView2 setBackgroundColor:RGB(209, 209, 209)];
		[self.contentScrollView addSubview:lineView2];
		
		FrameResize(focusView, 317, fCurrHeight-fcousViewH);

        
        
        
		/**
		 받으시는 금액
		 */
//		UIView *lineView2 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=10, 317, 1)]autorelease];
//		[lineView2 setBackgroundColor:RGB(209, 209, 209)];
//		[self.contentScrollView addSubview:lineView2];
//		
//		UIView *vBG = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=1, 317, 55)]autorelease];
//		[vBG setBackgroundColor:RGB(244, 244, 244)];
//		[self.contentScrollView addSubview:vBG];
//		
//		UILabel *lblAmount = [[[UILabel alloc]initWithFrame:CGRectMake(8, 7, 301, 21)]autorelease];
//		[lblAmount setBackgroundColor:[UIColor clearColor]];
//		[lblAmount setTextColor:RGB(44, 44, 44)];
//		[lblAmount setFont:[UIFont systemFontOfSize:15]];
//		[lblAmount setText:@"받으시는 금액 (원금 및 이자 합계금액-공제합계금액)"];
//		[vBG addSubview:lblAmount];
//		
//		UILabel *lblAmountVal = [[[UILabel alloc]initWithFrame:CGRectMake(8, 28, 301, 21)]autorelease];
//		[lblAmountVal setBackgroundColor:[UIColor clearColor]];
//		[lblAmountVal setTextColor:RGB(44, 44, 44)];
//		[lblAmountVal setFont:[UIFont systemFontOfSize:15]];
//		[lblAmountVal setTextAlignment:NSTextAlignmentRight];
//		[lblAmountVal setText:[NSString stringWithFormat:@"%@원", [self.data objectForKey:@"실수령액"]]];
//		[vBG addSubview:lblAmountVal];
//		
//		UIView *lineView3 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=56, 317, 1)]autorelease];
//		[lineView3 setBackgroundColor:RGB(209, 209, 209)];
//		[self.contentScrollView addSubview:lineView3];
	}
	
	[self setSecretMediaView];
	[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fCurrHeight)];
    
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	
	// 전자서명 Noti
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];
    //전자서명 취소
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignServerError) name:@"notiESignError" object:nil];
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
- (void)setSecretMediaView
{
	UIView *secretMediaView = [[[UIView alloc]initWithFrame:CGRectZero]autorelease];
	[self.contentScrollView addSubview:secretMediaView];
	
	NSInteger secutryType = [[AppInfo.userInfo objectForKey:@"보안매체정보"]intValue];
    
    if (secutryType == 1 || secutryType == 2 || secutryType == 3 || secutryType == 4)
    {           //보안카드
        
        SHBSecretCardViewController *vc = [[[SHBSecretCardViewController alloc] init] autorelease];
        vc.targetViewController = self;
        [secretMediaView addSubview:vc.view];
        [vc.view setFrame:CGRectMake(0, 0, 317/*self.view.frame.size.width*/, vc.view.bounds.size.height)];
		
		[secretMediaView setFrame:CGRectMake(0, fCurrHeight+=4, 317, vc.view.bounds.size.height)];
		
		vc.selfPosY = fCurrHeight+37;
		fCurrHeight += vc.view.bounds.size.height;
        
        /* previousData는 이전 전문 파싱값을 넘겨줄 필요가 있을때 넘겨준다
         연속적으로 이체할때 보안 카드 확인값이 변경되므로 값을 알아야됨 - 아직 미구현
         */
        [vc setMediaCode:secutryType previousData:nil];
        vc.delegate = self;
        
        if (_confirmVC.nServiceCode == kD3281Id) {	// 전체해지로 왔으면
			vc.nextSVC = @"D3282";
		}
		else if (_confirmVC.nServiceCode == kD3285Id) {	// 일부해지로 왔으면
			vc.nextSVC = @"D3286";
		}
        else if (_confirmVC.nServiceCode == kD3342Id) {	// 신탁해지
			vc.nextSVC = @"D3343";
		}

        
		self.cardViewController = vc;
    }
    else if (secutryType == 5)
    {           //OTP
        
        SHBSecretOTPViewController *vc = [[[SHBSecretOTPViewController alloc] init] autorelease];
        vc.targetViewController = self;
        
        [secretMediaView addSubview:vc.view];
        [vc.view setFrame:CGRectMake(0, 0, 317/*self.view.frame.size.width*/, vc.view.bounds.size.height)];
		
		[secretMediaView setFrame:CGRectMake(0, fCurrHeight+=4, 317, vc.view.bounds.size.height)];
		vc.selfPosY = fCurrHeight+37;
		
		fCurrHeight += vc.view.bounds.size.height;
        
        vc.delegate = self;
        
        if (_confirmVC.nServiceCode == kD3281Id) {	// 전체해지로 왔으면
			vc.nextSVC = @"D3282";
		}
		else if (_confirmVC.nServiceCode == kD3285Id) {	// 일부해지로 왔으면
			vc.nextSVC = @"D3286";
		}
        
        else if (_confirmVC.nServiceCode == kD3342Id) {	// 신탁해지
			vc.nextSVC = @"D3343";
		}
        
		
		self.otpViewController = vc;
    }
}

#pragma mark - Notification
- (void)getElectronicSignResult:(NSNotification *)noti
{
	Debug(@"[noti userInfo] : %@", [noti userInfo]);
	if (!AppInfo.errorType) {
        
        [[NSNotificationCenter defaultCenter]removeObserver:self];
		
		SHBCloseProductEndViewController *viewController = [[SHBCloseProductEndViewController alloc]initWithNibName:@"SHBCloseProductEndViewController" bundle:nil];
		viewController.data = [noti userInfo];
		viewController.confirmVC = _confirmVC;
        viewController.dicSelectedData= self.dicSelectedData;
		viewController.needsLogin = YES;
        

        
//        if([self.Close_type isEqualToString:@"only_allClose"]);
//        {
//            viewController.Close_type = @"only_allClose";
//        }
//        else
//        {
//            viewController.Close_type = @"";
//        }

		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
	}
}

- (void)getElectronicSignCancel
{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
    
	Debug(@"getElectronicSignCancel");
    NSLog(@"aaaa:%@",self.navigationController.viewControllers);
//	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
//	{
//		if ([viewController isKindOfClass:[SHBCloseProductInfoViewController class]]) {
//			[self.navigationController popToViewController:viewController animated:YES];
//		}
//	}
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
    [AppDelegate.navigationController fadePopViewController];
}

- (void)getElectronicSignServerError
{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
    
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBCloseProductInfoViewController class]]) {
			[self.navigationController popToViewController:viewController animated:YES];
		}
	}
}

#pragma mark - 전자서명 코드 세팅
- (NSString *)getElectronicSignCode
{
	NSString *strReturn = nil;
	
	if (_confirmVC.nServiceCode == kD3285Id) {	// 일부해지
		strReturn = @"D3286";
	}
    
	else if (_confirmVC.nServiceCode == kD3281Id) {	// 전체해지
		if ([_confirmVC isCloseTypeLoan]) {	// 예적금담보대출 해지이면
			strReturn = @"D3282_B";
		}
		else
		{
			strReturn = @"D3282_A";
		}
	}
    
    if (_confirmVC.nServiceCode == kD3342Id) {	// 신탁해지
		strReturn = @"D3343";
	}
	
	return strReturn;
}

#pragma mark - SHBSecretCard Delegate
- (void)cancelSecretMedia
{
	[[NSNotificationCenter defaultCenter]removeObserver:self];
    
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBCloseProductInfoViewController class]]) {
			[self.navigationController popToViewController:viewController animated:YES];
		}
	}
}

- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
	Debug(@"confirmSecretData:%@", confirmData);
    Debug(@"confirmSecretResult:%i", confirm);
    Debug(@"confirmSecretMedia:%i", mediaType);
	
	if (confirm == YES) {
		
		AppInfo.electronicSignString = @"";
		AppInfo.eSignNVBarTitle = @"예금/적금 해지";
		
		AppInfo.electronicSignCode = [self getElectronicSignCode];
		
		
		if (_confirmVC.nServiceCode == kD3285Id) {	// 일부해지
			AppInfo.electronicSignTitle = @"예금 일부해지 신청";
		}
		else if (_confirmVC.nServiceCode == kD3281Id ||  _confirmVC.nServiceCode == kD3342Id ) {	// 전체해지
			AppInfo.electronicSignTitle = @"예금/적금 해지";
		}
		
//		[AppInfo addElectronicSign:@"1.상품해지"];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)예금종류: %@", [self.data objectForKey:@"상품종류"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)계좌번호: %@", [self.data objectForKey:@"계좌번호"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)신규일자: %@", [self.data objectForKey:@"신규일"]]];
		if (_confirmVC.nServiceCode == kD3285Id) {	// 일부해지로 왔으면
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)만기일자: %@", [self.data objectForKey:@"만기일"]]];
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)일부해지금액: %@원", _confirmVC.strPartCloseAmount]];
		}
		else if (_confirmVC.nServiceCode == kD3281Id || _confirmVC.nServiceCode == kD3342Id) {	// 전체해지로 왔으면
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)적용과세: %@", [self.data objectForKey:@"적용과세"]]];
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)만기일자: %@", [self.data objectForKey:@"만기일"]]];
		}		
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)공제세금: %@원", [self.data objectForKey:@"공제세금"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)세금후차감이자: %@원", [self.data objectForKey:@"세금차감후이자"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)소득시작일: %@", [self.data objectForKey:@"소득시작일"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)소득종료일: %@", [self.data objectForKey:@"소득종료일"]]];
		if ([_confirmVC isCloseTypeLoan]) {	// 예적금담보대출 해지이면
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(12)총지급액: %@", [self.data objectForKey:@"뒷면총지급액1"]]];
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(13)총공제액: %@", [self.data objectForKey:@"뒷면총공제액1"]]];
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(14)상환후실수령액: %@", [self.data objectForKey:@"뒷면실수령액1"]]];
		}
		
		NSInteger nServiceId = 0;
		if (_confirmVC.nServiceCode == kD3281Id) {	// 전체해지로 왔으면
			nServiceId = kD3282Id;
		}
		else if (_confirmVC.nServiceCode == kD3285Id) {	// 일부해지로 왔으면
			nServiceId = kD3286Id;
		}
		
        else if (_confirmVC.nServiceCode == kD3342Id) {	// 일부해지로 왔으면
			nServiceId = kD3343Id;
		}

        
        
		SHBDataSet *dataSet = _confirmVC.dataSet;
		Debug(@"%@", dataSet);
		self.service = [[[SHBProductService alloc]initWithServiceId:nServiceId viewController:self]autorelease];
		self.service.requestData = dataSet;
		[self.service start];
	}
}


@end
