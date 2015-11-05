//
//  SHBNewProductInfoViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

typedef enum
{
	BottomButtonTagStart	= 100,
	BottomButtonTagMovie	= BottomButtonTagStart,
	BottomButtonTagInterest,
	BottomButtonTagJoin,
	BottomButtonTagEnd = BottomButtonTagJoin+1,
}BottomButtonTag;


#import "SHBNewProductInfoViewController.h"
#import "SHBProductService.h"
#import "SHBNewProductStipulationViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductMoneyRateViewController.h"
#import "SHBNewProductListViewController.h"
#import "SHBPushInfo.h"
#import "SHBNewProductWABSListViewController.h"
#import "SHBTelephoneConsultationRequestViewController.h"

@interface SHBNewProductInfoViewController ()

@end

@implementation SHBNewProductInfoViewController
@synthesize smallRate;
@synthesize bigRate;

#pragma mark -
#pragma mark UIButton Action Methods

- (IBAction)buttonDidPush:(id)sender
{
    // 전화상담요청 페이지로 이동
    SHBTelephoneConsultationRequestViewController *viewController = [[SHBTelephoneConsultationRequestViewController alloc] initWithNibName:@"SHBTelephoneConsultationRequestViewController" bundle:nil];
    
    if ([viewController isTelephoneConsultationRequest]) {
        
        // 상품코드 정보 수집
        NSString *stringTemp = nil;
        
        if (self.mdicPushInfo) { // 푸쉬로 오거나 스마트신규에서 넘어온 경우
            
            stringTemp = [self.mdicPushInfo objectForKey:@"productCode"];
        }
        else { // 그외
            
            if ([self.dicSelectedData objectForKey:@"상품코드"]) {
                
                stringTemp = [self.dicSelectedData objectForKey:@"상품코드"];
            }
            else if ([self.dicSelectedData objectForKey:@"prodCode"]) {
                
                stringTemp = [self.dicSelectedData objectForKey:@"prodCode"];
            }
            else {
                
                stringTemp = @"";
            }
        }
        
        AppInfo.commonDic = @{@"콜백서비스" : @"97",     // 예금
                              @"페이지정보" : @"P41000", // S뱅크 > 상품가입 > 예적금가입 > 전화상담요청
                              @"상품코드" : stringTemp};
        
        viewController.needsLogin = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
    }
    
    [viewController release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [smallRate release];
    [bigRate release];
	[_lblDuration release];
	[_lblInterest1 release];
	[_lblInterest2 release];
	[_popupView release];
	[_mdicPushInfo release];
	[_dicSelectedData release];
    [_dicReceiveData release];
    [_dicSmartNewData release];
    [_button1 release];
	[_wvProductInfo release];
	[_bottomBackView release];
	[_baseView release];
	[_popupContentView release];
    self.button1 = nil;
    
	[super dealloc];
}
- (void)viewDidUnload {
    self.button1 = nil;
	self.lblDuration = nil;
	self.lblInterest1 = nil;
	self.lblInterest2 = nil;
	self.popupView = nil;
	[self setWvProductInfo:nil];
	[self setBottomBackView:nil];
	[self setBaseView:nil];
	[self setPopupContentView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예금/적금 가입"];
     self.strBackButtonTitle = @"예금적금 상품설명";
    
    
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.wvProductInfo setBackgroundColor:RGB(244, 239, 233)];
	NSLog(@"self.mdicPushInfo:%@",self.mdicPushInfo);
	if (self.mdicPushInfo && self.mdicPushInfo[@"productCode"]) {  // 푸쉬로 오거나 스마트신규에서 넘어온 경우
		[self.baseView setHidden:YES];
		
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
        
		NSString *strProductCode = [self.mdicPushInfo objectForKey:@"productCode"];
		
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
													TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
												  TASK_ACTION_KEY : @"getPrdNewList",
							   @"상품코드" : [SHBUtility nilToString:strProductCode],
							   @"attributeNamed" : @"mode",
							   @"attributeValue" : @"ECHO",
							   }];

        self.service = nil;
		self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00004_1 viewController:self]autorelease];
		self.service.requestData = dataSet;
		[self.service start];
	}
	else
	{
        if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000501"] ||   //  신탁상품
            [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000601"])
        {
            [self setUI];
            [self.baseView setHidden:NO];
            return;
        }
        
        // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
        AppInfo.isNeedBackWhenError = YES;
		[self requestD5020Service];  //쿠폰상품일때 여기로 ~
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)requestD5020Service
{
//	NSArray *dates = [SHBUtility getCurrentDateAgoYear:0 AgoMonth:0 AgoDay:0];
//	NSString *currentDate = [dates objectAtIndex:0];
	 //NSLog(@"상품코드 ===!! %@",[self.dicSelectedData objectForKey:@"상품코드"]);
    
	Debug(@"AppInfo.customerNo : %@", AppInfo.customerNo);
    NSString *prod_Code;
    
    if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200009207"] ||
        [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200009209"])
    {
           prod_Code = @"200009206";
    }
    else if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200013410"] ||
             [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200013410"])
    {
        prod_Code = @"200013403";
    }
    else
    {
        prod_Code = [self.dicSelectedData objectForKey:@"상품코드"];
    }
    
    
    
    
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
//						   @"조회구분" : @"1",
//						   @"기준일자" : currentDate,
//						   @"수신금리유형" : @"1",
//						   @"이자지급방법" : @"99",
//						   @"반복횟수" : @"1",
                         @"상품코드" : [SHBUtility nilToString:prod_Code],
						   }];
#if 1	// 민트정기예금 - 쿠폰
	if (AppInfo.isLogin && AppInfo.customerNo) {	// 로그인 상태이면 고객번호도 같이 던져준다
		[dataSet insertObject:AppInfo.customerNo forKey:@"고객번호" atIndex:0];
	}
#endif
	self.service = [[[SHBProductService alloc]initWithServiceId:kD5020Id viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
}

#pragma mark - UI
- (void)setUI
{
	NSString *strProductUrl = nil;

    if([[self.dicReceiveData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"])
    {
        strProductUrl = [self.dicReceiveData objectForKey:@"상품요약설명URL"];
    }
    
    else
    {
        strProductUrl = [self.dicSelectedData objectForKey:@"상품요약설명URL"];
    
    }

    //상품신규 웹뷰 페이지 캐시 초기화 파라미터
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:strProductUrl]]];
    [self.wvProductInfo loadRequest:request];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[self.dicSelectedData objectForKey:@"상품명"] maxStep:5 focusStepNumber:1]autorelease]];

    
    
    [self.view bringSubviewToFront:self.button1];
    
    if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"232000101"] ||
        [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"232000201"] ) { // 재형저축 101변동금리 201고정금리
        UIButton *btn1 = (UIButton *)[self.bottomBackView viewWithTag:BottomButtonTagMovie];
        [btn1 setTitle:@"금리보기" forState:UIControlStateNormal];
        [btn1 removeTarget:self action:@selector(videoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 addTarget:self action:@selector(interestDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btn2 = (UIButton *)[self.bottomBackView viewWithTag:BottomButtonTagInterest];
        [btn2 setTitle:@"가입신청" forState:UIControlStateNormal];
        [btn2 removeTarget:self action:@selector(interestDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(joinBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setBackgroundImage:[[UIImage imageNamed:@"btn_btype1.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                        forState:UIControlStateNormal];
        [btn2 setBackgroundImage:[[UIImage imageNamed:@"btn_btype1_focus.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                        forState:UIControlStateHighlighted];
        
        UIButton *btn3 = (UIButton *)[self.bottomBackView viewWithTag:BottomButtonTagJoin];
        [btn3 setTitle:@"조회/취소" forState:UIControlStateNormal];
        [btn3 removeTarget:self action:@selector(joinBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 addTarget:self action:@selector(videoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 setBackgroundImage:[[UIImage imageNamed:@"btn_btype2.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                        forState:UIControlStateNormal];
        [btn3 setBackgroundImage:[[UIImage imageNamed:@"btn_btype2_focus.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0]
                        forState:UIControlStateHighlighted];
        
        if(AppInfo.isiPhoneFive == YES)
        {
            [self.wvProductInfo setFrame:CGRectMake(0, 84, 317, 257+41+38)];
            FrameReposition(self.bottomBackView, 0, 84+height(self.wvProductInfo)+2);
        }
        else
        {
            [self.wvProductInfo setFrame:CGRectMake(0, 84, 317, 257-10)];
            FrameReposition(self.bottomBackView, 0, 84+height(self.wvProductInfo)+2);
        }
    }
    
   
    
    else {
        
        if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000501"] ||   //  신탁상품
            [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000601"]) {
            
            [self.TopView setHidden:YES];
            
            for (int nIdx = BottomButtonTagStart; nIdx < BottomButtonTagEnd; nIdx++) {
                
                UIButton *btn = (UIButton *)[self.bottomBackView viewWithTag:nIdx];
                
                if (nIdx == BottomButtonTagMovie) {
                    
                    [btn removeFromSuperview];
                }
                else if (nIdx == BottomButtonTagInterest) {
                    
                    FrameReposition(btn, 163, top(btn));
                    
                    [btn setTitle:@"취소" forState:UIControlStateNormal];
                    [btn removeTarget:self
                               action:@selector(interestDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [btn addTarget:self.navigationController
                            action:@selector(fadePopViewController) forControlEvents:UIControlEventTouchUpInside];
                }
                else if (nIdx == BottomButtonTagJoin) {
                    
                    FrameReposition(btn, 60, top(btn));
                }
            }
            
            if (AppInfo.isiPhoneFive == YES) {
                
                [self.wvProductInfo setFrame:CGRectMake(0, 0, 317, 257+84+41+38)];
                FrameReposition(self.bottomBackView, 0, height(self.wvProductInfo)+2);
            }
            else {
                
                [self.wvProductInfo setFrame:CGRectMake(0, 0, 317, 257+84-10)];
                FrameReposition(self.bottomBackView, 0, height(self.wvProductInfo)+2);
            }
        }
        else {
            
            NSString *strUrl = [self.dicSelectedData objectForKey:@"동영상URL"];
            
            if (![strUrl length]) {
                
                for (int nIdx = BottomButtonTagStart; nIdx < BottomButtonTagEnd; nIdx++) {
                    UIButton *btn = (UIButton *)[self.bottomBackView viewWithTag:nIdx];
                    
                    if (nIdx == BottomButtonTagMovie) {
                        [btn removeFromSuperview];
                    }
                    else if (nIdx == BottomButtonTagInterest) {
                        FrameReposition(btn, 60, top(btn));
                    }
                    else if (nIdx == BottomButtonTagJoin) {
                        FrameReposition(btn, 163, top(btn));
                    }
                }
            }
            
            if ([self.dicSelectedData[@"상품구분"]intValue] == 5 ) {
                
                UIButton *btn = (UIButton *)[self.bottomBackView viewWithTag:BottomButtonTagJoin];
                [btn setTitle:@"전용APP" forState:UIControlStateNormal];
                
                [self.TopView setHidden:YES];
                
                if (AppInfo.isiPhoneFive == YES) {
                    
                    [self.wvProductInfo setFrame:CGRectMake(0, 0, 317, 257+84+41+38)];
                    FrameReposition(self.bottomBackView, 0, height(self.wvProductInfo)+2);
                }
                else {
                    
                    [self.wvProductInfo setFrame:CGRectMake(0, 0, 317, 257+84-10)];
                    FrameReposition(self.bottomBackView, 0, height(self.wvProductInfo)+2);
                }
            }
            
            else
            {
                if (AppInfo.isiPhoneFive == YES) {
                    
                    [self.wvProductInfo setFrame:CGRectMake(0, 84, 317, 257+41+38)];
                    FrameReposition(self.bottomBackView, 0, 84+height(self.wvProductInfo)+2);
                }
                else {
                    
                    [self.wvProductInfo setFrame:CGRectMake(0, 84, 317, 257-10)];
                    FrameReposition(self.bottomBackView, 0, 84+height(self.wvProductInfo)+2);
                }
            }
        }
    }
    
    // 아이패드에서 상품가입시 푸시로 넘어온 경우 가입버튼이 바로 누른 상태가 되어야 함 (2014.04.17)
    if (self.mdicPushInfo[@"withiPad"] && [self.dicSelectedData[@"상품구분"]intValue] != 5) {
        
        if ([self.mdicPushInfo[@"withiPad"] isEqualToString:@"Y"]) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"가입" forState:UIControlStateNormal];
            [self joinBtnAction:btn];
        }
    }
}


- (void)navigationButtonPressed:(id)sender
{
    if ([_delegate respondsToSelector:@selector(productCouponCancel)]) {
        [_delegate productCouponCancel];
    }
    else {
        [super navigationButtonPressed:sender];
    }
}



#pragma mark - Popup Button Action
- (IBAction)confirmBtnActionInPopupView:(SHBButton *)sender {
	if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"S10000001"]
		|| [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"230011921"])
	{
		SHBPushInfo *pushInfo = [SHBPushInfo instance];
		[pushInfo requestOpenURL:@"missionplus://" Parm:nil];
	}
	else if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"S10000002"]
			 || [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"110004601"])
	{
		SHBPushInfo *pushInfo = [SHBPushInfo instance];
		[pushInfo requestOpenURL:@"asset://" Parm:nil];
	}

	[self.popupView closePopupViewWithButton:nil];
}

- (IBAction)cancelBtnActionInPopupView:(SHBButton *)sender {
	[self.popupView closePopupViewWithButton:nil];
}

//#pragma mark - Action
//
//// 백키 눌렀을 때 푸쉬로 타고 들어왔는지 체크하기 위하여 오버라이드
//- (void)navigationButtonPressed:(id)sender
//{
//    [super navigationButtonPressed:sender];
//	UIButton *btnSender = (UIButton*)sender;
//	if (btnSender.tag == NAVI_BACK_BTN_TAG)
//	{
//		if (self.mdicPushInfo) {		// 푸쉬로 타고 들어왔었으면 리스트화면에서 전체리스트를 뿌려주기 위한 처리
//			for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
//			{
//				if ([viewController isKindOfClass:[SHBNewProductListViewController class]]) {
//					[(SHBNewProductListViewController *)viewController setNeedsAllList:YES];
//					
//					[self.navigationController fadePopViewController];
//				}
//			}
//		}
//		else	// 일반적일땐 그냥 일반적인 동작
//		{
//			[self.navigationController fadePopViewController];
//		}
//		
//	}
//}

- (IBAction)videoBtnAction:(UIButton *)sender {
    if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"232000101"] ||
        [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"232000201"]) { // 재형저축
        
        SHBNewProductWABSListViewController *viewController = [[[SHBNewProductWABSListViewController alloc] initWithNibName:@"SHBNewProductWABSListViewController" bundle:nil] autorelease];
		viewController.needsCert = YES;
        viewController.dicSelectedData = _dicSelectedData;
        
		[self checkLoginBeforePushViewController:viewController animated:YES];
        
        return;
    }
    
    NSString *strUrl = [self.dicSelectedData objectForKey:@"동영상URL"];
    if (strUrl) {
        [UIAlertView showAlert:self type:ONFAlertTypeTwoButton tag:337337 title:@"" message:@"3G/4G 모바일 네트워크를 사용할 경우 요금제에 따라 데이터 요금이 부과 될 수 있습니다. 동영상 서비스를 이용하시겠습니까?"];
    }
}

- (IBAction)interestDetailBtnAction:(UIButton *)sender {
    
    NSString *strUrl;
    
    if (!AppInfo.realServer) {
        strUrl = [NSString stringWithFormat:@"%@PROD_ID=%@&EQUP_CD=SI", URL_INTEREST_TEST, self.dicSelectedData[@"상품코드"]];	// &EQUP_CD=SI
    }
    else{
        strUrl = [NSString stringWithFormat:@"%@PROD_ID=%@&EQUP_CD=SI", URL_INTEREST, self.dicSelectedData[@"상품코드"]];	// &EQUP_CD=SI
        
    }
    
    NSLog(@"!!%@",strUrl);
    
	SHBNewProductMoneyRateViewController *viewController = [[SHBNewProductMoneyRateViewController alloc]initWithNibName:@"SHBNewProductMoneyRateViewController" bundle:nil];
	viewController.dicSelectedData = self.dicSelectedData;
	viewController.strURL = strUrl;
	[self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
}



- (IBAction)joinBtnAction:(UIButton *)sender {
    
   // NSMutableDictionary *dicData = [[self.marrSectionDatas objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
	Debug(@"버전 : %@",[self.dicSelectedData objectForKey:@"버전"] );
	float serverVersion = [[self.dicSelectedData objectForKey:@"버전"]floatValue];
	float localVersion = [SIB_NEWDEPOSITVERSION floatValue];
	
	if (serverVersion > localVersion) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"[업데이트 안내]"
                                                         message:@"해당상품은 신한S뱅크 최신버전에서 가입 가능합니다.\n업데이트 후 이용하시기 바랍니다."
                                                        delegate:self
                                                   cancelButtonTitle:@"확인"
                                               otherButtonTitles:@"업데이트", nil] autorelease];
        
        [alert setTag:4321];
		[alert show];
		
		return;
	}

    
	if ([sender.titleLabel.text isEqualToString:@"가입"] ||
        [sender.titleLabel.text isEqualToString:@"가입신청"] ||
        [sender.titleLabel.text isEqualToString:@"취소"])
    {
//        if ([sender.titleLabel.text isEqualToString:@"취소"])
//        {
//            [self.navigationController fadePopViewController]; // 신탁의 취소 
//        }
        
        
        NSString *date = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSInteger *time = [[AppInfo.tran_Time stringByReplacingOccurrencesOfString:@":" withString:@""] integerValue];
        
        
        if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000501"] ||   //  신탁상품 2014. 5.9 추가
            [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000601"])
        {
            if (![SHBUtility isOPDate:date]) {
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:[NSString stringWithFormat:@"%@은 토요일 및 공휴일에 가입이 불가한 상품입니다.",
                                        [self.dicSelectedData objectForKey:@"상품명"]]];
                
                return;
            }

        }
        
        if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"232000101"] || // 재형저축
            [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"232000201"] )
        {
           
            
            if (![SHBUtility isOPDate:date]) {
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:[NSString stringWithFormat:@"%@은 토요일 및 공휴일에 가입이 불가한 상품입니다.",
                                        [self.dicSelectedData objectForKey:@"상품명"]]];
                
                return;
            }
            
            if ([SHBUtility isOPDate:date] && time > 155500 && time < 160000) {
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeOneButton
                                   tag:0
                                 title:@""
                               message:@"당일 신규 신청시간이 종료되었습니다. 16시 이후에 신청하십시오. 단, 16시 이후에는 익일로 신규처리 됩니다."];
                
                return;
            }
        }
        
		SHBNewProductStipulationViewController *viewController = [[SHBNewProductStipulationViewController alloc]initWithNibName:@"SHBNewProductStipulationViewController" bundle:nil];
        
        viewController.dicReceiveData = self.dicReceiveData; //쿠폰상품정보리스트
        viewController.dicSelectedData = self.dicSelectedData;
		viewController.mdicPushInfo = self.mdicPushInfo;
        viewController.dicSmartNewData = self.dicSmartNewData; // 스마트신규 데이터
        
		
		//	viewController.needsLogin = YES;
		viewController.needsCert = YES;
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];

	}
	else	// 전용APP
	{
//		NSMutableArray *marr = AppInfo.otherAppArray;
//		Debug(@"marr : %@", marr);
//		
//		SHBPushInfo *pushInfo = [SHBPushInfo instance];
		/*
		 {
		 메인액티비티클래스 = ;
		 앱구분 = 009_01;
		 패키지_스키마 = com.shinhan.smartfundcenter;
		 다운로드URL = ;
		 OS구분 = A;
		 순서 = 2;
		 상세페이지URL = http://m2013.shinhan.com/test/test~;
		 패키지구분 = 2;
		 SSO연동여부 = ;
		 TSTORE연동ID = 32132132;
		 아이콘URL = http://imgdev.shinhan.com/test/test~~;
		 앱구분명 = 은행;
		 TSTORE연동구분 = 1;
		 앱이름 = 스마트펀드센터;
		 }
		 ,
		 {
		 메인액티비티클래스 = ;
		 앱구분 = 009_01;
		 패키지_스키마 = ;
		 다운로드URL = ;
		 OS구분 = A;
		 순서 = 4;
		 상세페이지URL = ;
		 패키지구분 = 1;
		 SSO연동여부 = ;
		 TSTORE연동ID = ;
		 아이콘URL = ;
		 앱구분명 = 은행;
		 TSTORE연동구분 = 0;
		 앱이름 = 앱좀더보기;
		 }
		 */
		
		NSString *strMsg = nil;
		CGSize size = CGSizeZero;
		CGFloat fHeight = 28;
		NSString *strTitle = nil;
		
		UILabel *lblBody = (UILabel *)[self.popupContentView viewWithTag:130];
		UIView *oneButtonView = (UIView *)[self.popupContentView viewWithTag:140];
		UIView *twoButtonView = (UIView *)[self.popupContentView viewWithTag:150];
		
		Debug(@"%@", [self.dicSelectedData objectForKey:@"상품코드"]);
		// 신한 미션플러스 적금
		if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"S10000001"]
			|| [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"230011921"]) {	// 상품코드가 바뀌었나?
			strTitle = @"미션플러스APP 안내";
			
			if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"missionplus://"]]) {
				strMsg = @"신한 미션플러스 적금은 목표로 한 자금을 마련하기 위해 미션 또는 일상 생활 속의 작은 미션과 함께 저축에 대한 개별적인 니즈를 충족시킬 수 있는 특화 적립식 상품으로 미션의 효율적 달성을 위하여 제휴사를 통한 이자수익 수준의 추가 할인 혜택까지 제공하는 신개념 금융 상품입니다.\n\n본 상품은 전용App인 미션플러스 어플리케이션을 통해 이용해 주시기 바랍니다.";
				size = [strMsg sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(255, 999) lineBreakMode:NSLineBreakByWordWrapping];
				
				[lblBody setText:strMsg];
				[lblBody setFrame:CGRectMake(left(lblBody), fHeight, width(lblBody), size.height)];
				fHeight += size.height;
				
				FrameReposition(oneButtonView, 0, fHeight+=28);
				[oneButtonView setHidden:NO];				
				[twoButtonView setHidden:YES];
				
				FrameResize(self.popupContentView, width(self.popupContentView), fHeight+29+30);
			}
			else
			{
				strMsg = @"신한 미션플러스 적금은 목표로 한 자금을 마련하기 위해 미션 또는 일상 생활 속의 작은 미션과 함께 저축에 대한 개별적인 니즈를 충족시킬 수 있는 특화 적립식 상품으로 미션의 효율적 달성을 위하여 제휴사를 통한 이자수익 수준의 추가 할인 혜택까지 제공하는 신개념 금융 상품입니다.\n\n본 상품은 전용App인 미션플러스 어플리케이션을 통해 이용해 주시기 바랍니다. 미션플러스 어플리케이션을 설치하시겠습니까?";
				size = [strMsg sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(255, 999) lineBreakMode:NSLineBreakByWordWrapping];
				
				[lblBody setText:strMsg];
				[lblBody setFrame:CGRectMake(left(lblBody), fHeight, width(lblBody), size.height)];
				fHeight += size.height;
				
				[oneButtonView setHidden:YES];
				
				FrameReposition(twoButtonView, 0, fHeight+=28);
				[twoButtonView setHidden:NO];
				
				FrameResize(self.popupContentView, width(self.popupContentView), fHeight+29+30);
			}
		}
		// 사랑愛 저금통
		else if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"S10000002"]
				 || [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"110004601"]) {
			strTitle = @"한달愛저금통(머니멘토) 안내";
			
			if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"asset://"]]) {
				strMsg = @"한달愛저금통은 매일 절약한 금액/자투리 금액을 계좌에 모아 그 적립금을 매월 돌려받을 수 있는 Money Mentor(인터넷/스마트폰-비 대면채널) 전용 소액 입출금 상품입니다.\n\n본 상품은 전용APP인 머니멘토 어플리케이션을 통해 이용해 주시기 바랍니다.";
				size = [strMsg sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(255, 999) lineBreakMode:NSLineBreakByWordWrapping];
				
				[lblBody setText:strMsg];
				[lblBody setFrame:CGRectMake(left(lblBody), fHeight, width(lblBody), size.height)];
				fHeight += size.height;
				
				FrameReposition(oneButtonView, 0, fHeight+=28);
				[oneButtonView setHidden:NO];
				
				[twoButtonView setHidden:YES];
				
				FrameResize(self.popupContentView, width(self.popupContentView), fHeight+29+30);
			}
			else
			{
				strMsg = @"한달愛저금통은 매일 절약한 금액/자투리 금액을 계좌에 모아 그 적립금을 매월 돌려받을 수 있는 Money Mentor(인터넷/스마트폰-비 대면채널) 전용 소액 입출금 상품입니다.\n\n본 상품은 전용APP인 머니멘토 어플리케이션을 통해 이용해 주시기 바랍니다. 한달愛저금통(머니멘토) 전용 APP을 설치하시겠습니까?";
				size = [strMsg sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(255, 999) lineBreakMode:NSLineBreakByWordWrapping];
				
				[lblBody setText:strMsg];
				[lblBody setFrame:CGRectMake(left(lblBody), fHeight, width(lblBody), size.height)];
				fHeight += size.height;
				
				[oneButtonView setHidden:YES];
				
				FrameReposition(twoButtonView, 0, fHeight+=28);
				[twoButtonView setHidden:NO];
				
				FrameResize(self.popupContentView, width(self.popupContentView), fHeight+29+30);
			}
		}
		
		SHBPopupView *pv = [[[SHBPopupView alloc]initWithTitle:strTitle subView:self.popupContentView]autorelease];
		[pv showInView:self.navigationController.view animated:YES];
		self.popupView = pv;
	}
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[super alertView:alertView clickedButtonAtIndex:buttonIndex];
	
	if (alertView.tag == 337337) {
		if (buttonIndex == 0) {
			NSString *strUrl = [self.dicSelectedData objectForKey:@"동영상URL"];
			[[UIApplication sharedApplication]openURL:[NSURL URLWithString:strUrl]];			
		}
	}
    
    // 업데이트
    if (alertView.tag == 4321 && buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/kr/app/id357484932?mt=8"]];
    }
}

//#pragma mark - UIWebView Delegate
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//#if 0
//	CGFloat contentHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight"]floatValue];
//	Debug(@"%.f", contentHeight);
//	
//	[webView stringByEvaluatingJavaScriptFromString:@"window.resizeTo(301, 500)"];
//#elif 1
//	Debug(@"%.f", webView.scrollView.contentSize.height);
//	CGSize contentSize = webView.scrollView.contentSize;
//	
//	float rw = 301 / contentSize.width;
//
//	webView.scrollView.minimumZoomScale = rw;
//	webView.scrollView.maximumZoomScale = rw;
//	webView.scrollView.zoomScale = rw;
//	
//	Debug(@"%.f", webView.scrollView.contentSize.height);
//	[webView.scrollView setShowsHorizontalScrollIndicator:NO];
//#else
//	CGRect frame = webView.frame;
//	frame.size.height = 1;
//
//	CGSize fittingSize = [self.wvProductInfo sizeThatFits:CGSizeZero];
//	fittingSize.width = 301;
//	frame.size = fittingSize;
//	webView.frame = frame;
//#endif
//}

#pragma mark - Http Delegate
- (BOOL) onBind: (OFDataSet*) aDataSet
{
    Debug(@"aDataSet : %@", aDataSet);
	if (self.service.serviceId == XDA_S00004_1)
	{
		self.dataList = [aDataSet arrayWithForKeyPath:@"data"];
		self.dicSelectedData = [self.dataList objectAtIndex:0];
		
        // 상품버전체크는 상품리스트에서만 했기 때문에 푸시로 넘어온 경우 체크가 되지 않아 추가
        float serverVersion = [[self.dicSelectedData objectForKey:@"버전"]floatValue];
        float localVersion = [SIB_NEWDEPOSITVERSION floatValue];
        
        if (serverVersion > localVersion) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"[업데이트 안내]"
                                                             message:@"해당상품은 신한S뱅크 최신버전에서 가입 가능합니다.\n업데이트 후 이용하시기 바랍니다."
                                                            delegate:self
                                                   cancelButtonTitle:@"확인"
                                                   otherButtonTitles:@"업데이트", nil] autorelease];
            
            [alert setTag:4321];
            [alert show];
            
            return NO;
        }
        
        if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000501"] ||  //  신탁상품
            [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000601"]) {
            
            [self setUI];
            [self.baseView setHidden:NO];
        }
        else {
            
            [self requestD5020Service];
        }
		
		return NO;
	}
	else if (self.service.serviceId == kD5020Id) {
		
//		NSMutableArray *marr = [aDataSet arrayWithForKeyPath:@"data"];
		NSMutableArray *marr = [aDataSet arrayWithForKey:@"조회내역"];
		Debug(@"%@", marr);
		
		NSDictionary *dicData = [marr objectAtIndex:0];
		
        if ([[dicData objectForKey:@"기간수"] isEqualToString:@"0"]) {
            [self.lblDuration setText:[NSString stringWithFormat:@""]]; //기간구간  빈값처리 2014. 9.25
        }
        else{
            [self.lblDuration setText:[NSString stringWithFormat:@"기간 : %@ 개월", [dicData objectForKey:@"기간수"]]]; //기간구간
        }
        
       

        
		double val1 = [[dicData objectForKey:@"수신이율"]doubleValue];
		double val2 = [[dicData objectForKey:@"인터넷가산이율"]doubleValue];
		double val3 = [[dicData objectForKey:@"최고금리"]doubleValue];
		
		[self.lblInterest1 setText:[NSString stringWithFormat:@"%.2f", val1+val2]];
		[self.lblInterest2 setText:[NSString stringWithFormat:@"%.2f", val1+val2+val3]];
        self.smallRate.accessibilityLabel = [NSString stringWithFormat:@"최저금리 연 %@%@",self.lblInterest1.text,@"%"];
		self.bigRate.accessibilityLabel = [NSString stringWithFormat:@"최고금리 연 %@%@",self.lblInterest2.text,@"%"];
        
#if 1	
		if (//AppInfo.isLogin && [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200009206"] ||  // 민트정기예금 20146.13일 판매종료
            AppInfo.isLogin && [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013606"] ) {	// S드림정기예금
			
			if (![[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:[dicData objectForKey:@"상품코드"]]) {	// 상품코드가 다르면 갈아침
				[self.dicSelectedData setObject:[dicData objectForKey:@"상품코드"] forKey:@"상품코드"];
			}
			
			if ([aDataSet objectForKey:@"prodCode"]) {	// 560 or 561 or @""
				[self.dicSelectedData setObject:[aDataSet objectForKey:@"prodCode"] forKey:@"prodCode"];
			}
			
			if ([aDataSet objectForKey:@"under12"]) {
				[self.dicSelectedData setObject:[aDataSet objectForKey:@"under12"] forKey:@"under12"];
			}
			
			if ([aDataSet objectForKey:@"over12"]) {
				[self.dicSelectedData setObject:[aDataSet objectForKey:@"over12"] forKey:@"over12"];
			}
            if ([aDataSet objectForKey:@"prodUrl"]) {
				[self.dicSelectedData setObject:[aDataSet objectForKey:@"prodUrl"] forKey:@"prodUrl"];
			}
		}
#endif
		
		[self setUI];
		[self.baseView setHidden:NO];
	}
	
    return NO;
}


@end
