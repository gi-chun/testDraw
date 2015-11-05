//
//  SHBNewProductRegViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 19..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

typedef enum
{
	ListPopupViewTagAccounts = 400,
	ListPopupViewTagCoupons,
}ListPopupViewTag;

#import "SHBNewProductRegViewController.h"
#import "SHBProductService.h"
#import "SHBNewProductListViewController.h"
#import "SHBNewProductRegTopView.h"
#import "SHBAccountService.h"
#import "SHBNewProductSolicitorSearchCell.h"
#import "SHBNewProductTaxBreakViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"
#import "SHBAskStaffViewController.h"
#import "SHBSearchZipViewController.h"
#import "SHBNewProductStipulationViewController.h"

#define kLeftTitleFontSize		15

#define kTagLabelBalance		11

@interface SHBNewProductRegViewController ()
{
	CGFloat fCurrHeight;
	SHBTextField *currentTextField;
	
	NSInteger nTextFieldTag;
    BOOL b_tfEmployee;
}

@property (nonatomic, retain) NSString *tmpA;	// 예외처리용
@property (nonatomic, retain) NSString *tmpB;	// 예외처리용

@property (nonatomic, retain) NSMutableArray *marrAccounts;		// 출금계좌 배열
@property (nonatomic, retain) NSMutableDictionary *selectedAccount;	// 선택된 출금계좌
//@property (nonatomic, retain) NSMutableArray *marrEmployees;	// 검색된 권유직원들
//@property (nonatomic, retain) SHBPopupView *employeePopupView;	// 권유직원조회 팝업뷰
@property (nonatomic, retain) NSString *strEncryptedNewPW;			// Encrypt된 패스워드
@property (nonatomic, retain) NSString *strEncryptedNewPWConfirm;	// Encrypt된 패스워드 확인
@property (nonatomic, retain) NSString *strEncryptedOldPW;	// Encrypt된 출금계좌비밀번호
@property (nonatomic, retain) NSMutableArray *marrCoupons;	// 쿠폰
@property (nonatomic, retain) NSMutableArray *marrRecStaffs;	// 전문으로 받아온 권유직원
@property (nonatomic, retain) NSMutableArray *marrStaffRadioBtns;	// 권유직원 라디오버튼

@end

@implementation SHBNewProductRegViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		nTextFieldTag = 222000-1;
    }
    return self;
}

- (void)dealloc
{
    self.dicSmartNewData = nil;
    [_tmpA release];
    [_tmpB release];
	[_btnEmployee release];
	[_marrStaffRadioBtns release];
	[_marrRecStaffs release];
	[_mdicPushInfo release];
	[_strProductCode1 release];
	[_strProductCode2 release];
	[_marrAccumulateRadioBtns release];
	[_marrCoupons release];
	[_tfAddress release];
	[_tfZipCode1 release];
	[_tfZipCode2 release];
	[_strEncryptedNewPW release];
	[_strEncryptedNewPWConfirm release];
	[_strEncryptedOldPW release];
	[_userItem release];
//	[_employeePopupView release];
//	[_marrEmployees release];
	[_selectedAccount release];
	[_marrAccounts release];
	[_tfPeriod release];
	[_marrPeriodRadioBtns release];
    [_marrTurnRadioBtns  release];
	[_tfCoupon release];
//	[_tfOldAccountNum release];
	[_sbOldAccountNum release];
	[_tfOldAccountPW release];
	[_tfAccountName release];
	[_tfAmount release];
	[_tfEmployee release];
	[_tfNewPW release];
	[_tfNewPWConfirm release];
	[_dicSelectedData release];
	[_bottomView release];
//    [_employeeView release];
//	[_btnRadioEmployee release];
//	[_btnRadioBranch release];
//	[_tfEmployeeSearchWord release];
//	[_tblEmployees release];
	[super dealloc];
}

- (void)viewDidUnload {
	self.tfZipCode1 = nil;
	self.tfZipCode2 = nil;
	self.tfAddress = nil;
	self.tfCoupon = nil;
//	self.tfOldAccountNum = nil;
	self.sbOldAccountNum = nil;
	self.tfOldAccountPW = nil;
	self.tfAccountName = nil;
	self.tfAmount = nil;
	self.tfEmployee = nil;
	self.tfNewPW = nil;
	self.tfNewPWConfirm = nil;
	[self setBottomView:nil];
//    [self setEmployeeView:nil];
//	[self setBtnRadioEmployee:nil];
//	[self setBtnRadioBranch:nil];
//	[self setTfEmployeeSearchWord:nil];
//	[self setTblEmployees:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예금/적금 가입"];
    
    if(self.stepNumber ==nil)
    {
      self.strBackButtonTitle = @"예금적금 가입 2단계";
    }
    else
    {
        self.strBackButtonTitle =self.stepNumber; //3단계 (주택청약일때)
    }
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	FrameResize(self.contentScrollView, 317, height(self.contentScrollView));
	
	self.isSubscription = [[self.dicSelectedData objectForKey:@"청약여부"]isEqualToString:@"1"];

	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[self.dicSelectedData objectForKey:@"상품명"] maxStep:self.isSubscription ? 5+1 : 5 focusStepNumber:self.isSubscription ? 2+1 :2]autorelease]];
	
//	if (self.mdicPushInfo) {
//		NSString *strStaffNo = [self.mdicPushInfo objectForKey:@"recStaffNo"];
//		
//		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
//							   TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
//							   TASK_ACTION_KEY : @"selectEmpInfo",
//							   @"고객번호" : AppInfo.customerNo,
//							   @"행원번호" : strStaffNo,
//							   }];
//		self.service = [[[SHBProductService alloc]initWithServiceId:XDA_SelectEmpInfo viewController:self]autorelease];
//		self.service.requestData = dataSet;
//		[self.service start];
//	}
//	else
//	{
//		[self setUI];
//	}
    
	// 스마트신규에서 넘어온 경우에는 전문타지 않음 (그 외에는 권유직원번호가 없어도 무조건 전문 날림)
    if (_dicSmartNewData) {
        self.marrRecStaffs = [NSMutableArray arrayWithArray:@[
                              @{ @"그룹사코드" : @"",
                              @"구분" : @"",
                              @"점번호" : [SHBUtility nilToString:_dicSmartNewData[@"등록지점"]],
                              @"한글점명" : [SHBUtility nilToString:_dicSmartNewData[@"등록지점명"]],
                              @"직원명" : [SHBUtility nilToString:_dicSmartNewData[@"등록직원명"]],
                              @"행원번호" : [SHBUtility nilToString:_dicSmartNewData[@"등록직원"]], } ]];
        
        [self responseSelectEmpInfo];
    }
    else {
        NSString *strStaffNo = [self.mdicPushInfo objectForKey:@"recStaffNo"];
        if (!strStaffNo) {
            strStaffNo = @"";
        }
        
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                    TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                                  TASK_ACTION_KEY : @"selectEmpInfo",
                               @"고객번호" : AppInfo.customerNo,
                               @"행원번호" : strStaffNo,
                               }];
        self.service = [[[SHBProductService alloc]initWithServiceId:XDA_SelectEmpInfo viewController:self]autorelease];
        self.service.requestData = dataSet;
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
	
	[self.contentScrollView flashScrollIndicators];
}

#pragma mark - UI

- (void)responseSelectEmpInfo
{
    if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200009206"] || //민트일반
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200009207"] || //민트560
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200009208"] || //민트561
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013606"] || //S드림 일반
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013607"] || //S드림 560
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013608"] || //S드림 561
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013403"] ||  // u드림회전
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013410"] ||  // u드림회전 쿠폰상품 560
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013411"] ||  // u드림회전 쿠폰상품 561
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"230011932"] || //북21 - 230011932
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"230011821"] ||  //올레tv모바일
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"230011831"] ) //저축습관만들기
    {
        
        if ([self.dicSelectedData objectForKey:@"prodCode"]) {	// 상품상세화면에서 이미 D5020을 받아왔으면
            [self setUI];
        }
        else	// 아니면 새로 D5020 전문을 날려준다.
        {
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                   @"상품코드" : [self.dicSelectedData objectForKey:@"상품코드"],
                                   @"고객번호" : AppInfo.customerNo,
                                   }];
            
            self.service = [[[SHBProductService alloc]initWithServiceId:kD5020Id viewController:self]autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        }
    }
    
    else
    {
        [self setUI];
    }
}

- (void)setUI
{
	fCurrHeight = 0;
	
	// 쿠폰
#if 1
        
	if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013606"] || //s드림 정기예금(고객산출,비대면일반)
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013607"] ||   //s드림(비대면 560)
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013608"] || //s드림(비대면 561)
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200009206"] ||  //민트 온라인
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200009207"] || //민트(온라인 560)
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200009208"] || //민트(온라인 561)
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013403"] ||  // u드림회전
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013410"] ||  // u드림회전 쿠폰상품 560
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"200013411"] ||  // u드림회전 쿠폰상품 561
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"230011932"] ||	// 민트정기예금일때  북21 - 230011932
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"230011821"] ||  //올레tv모바일
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"230011831"] )  //저축습관만들기
	{
		
          //민트 쿠폰  Url 변경시 적용 예정 정과장님 요청시 주석 풀고 밑에 라멜 이미지는 삭제 해야함 2013.02
            
       if (![[self.dicSelectedData objectForKey:@"prodUrl"]isEqualToString:@""] &&
            [self.dicSelectedData objectForKey:@"prodUrl"] != nil)
        {
            UIWebView *CouponView = [[[UIWebView alloc] init] autorelease];
            [CouponView setFrame:CGRectMake(0, fCurrHeight, 320, 125)];
            NSLog(@"aaaaaaaurl = %@",[self.dicSelectedData objectForKey:@"prodUrl"]);
            [CouponView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[SHBUtility addTimeStamp:[self.dicSelectedData objectForKey:@"prodUrl"]]]]]; //@"prodUrl"  @"http://img.shinhan.com/nexrib2/ko/images/depcenter/bg_coupon_4.gif"
            [CouponView setScalesPageToFit:YES];
            [self.contentScrollView addSubview:CouponView];
            
            fCurrHeight += 125+4;
        }
    
	}
	
#endif
	// 적립방식, 계약기간
	CGFloat height = 34*2;
    
    if([[self.dicSelectedData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"])
    {
        if([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200009201"] ||  //민트
           [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200009301"] ||  //신한그린애
           [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200009206"] ||
           [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200009207"] ||
           [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200009208"] ||  //민트(온라인)
           [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200013601"] ||  //s드림
           [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200013606"] ||   //s드림 정기예금(고객산출,비대면일반)
           [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200013607"] ||  //s드림(비대면 560)
           [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200013608"] )  //s드림(비대면 561)
        {
            
            height = 34*6-8;
        }
        else if([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200003401"] ||  //top회전정기
                [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200013403"] ||
                [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200013410"] ||
                [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200013411"] )   //u드림 회전정기)
        {
            
            height = 34*7-8;
        }
   
    }
    else
    {
    
        if (self.isSubscription)
        {
            height = 34;
        }
        else if ([[self.dicSelectedData objectForKey:@"계약기간_자유여부"] isEqualToString:@"1"])	// 텍스트필드가 들어가면 하이트 좀 크게..
        {
            height = 34*2+8;
        }
        else if([[self.dicSelectedData objectForKey:@"회전주기_선택비트"] isEqualToString:@"136"])  //상품리스트 u드림 회전정기예금
        {
            height = 34*3+8;
        }
    
        if ([[self.dicSelectedData objectForKey:@"계약기간_선택여부"] isEqualToString:@"1"])	// 2줄로 처리하는 경우 (선택기간이 4개 이상인 경우)
        {
            int num = 0;
            
            if ([self.dicSelectedData[@"계약기간_선택3"] isEqualToString:@"0"] ||
                [self.dicSelectedData[@"계약기간_선택3"] isEqualToString:@""] ||
                self.dicSelectedData[@"계약기간_선택3"] == nil) {
                
                num = 2;
            }
            else if ([self.dicSelectedData[@"계약기간_선택4"] isEqualToString:@"0"] ||
                     [self.dicSelectedData[@"계약기간_선택4"] isEqualToString:@""] ||
                     self.dicSelectedData[@"계약기간_선택4"] == nil) {
                
                num = 3;
            }
            else if ([self.dicSelectedData[@"계약기간_선택5"] isEqualToString:@"0"] ||
                     [self.dicSelectedData[@"계약기간_선택5"] isEqualToString:@""] ||
                     self.dicSelectedData[@"계약기간_선택5"] == nil) {
                
                num = 4;
            }
            else {
                
                num = 5;
            }
            
            if (num > 3) {
                
                height += 34;
            }
        }
   	}
    
    NSLog(@"  !!! 상품코드   %@",[self.dicSelectedData objectForKey:@"상품코드"]);
    
    if( ![[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000501"] &&   //  신탁상품
        ![[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000601"])
    {
        
        SHBNewProductRegTopView *topView = [[[SHBNewProductRegTopView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 320, height) parentViewController:self]autorelease];
        [self.contentScrollView addSubview:topView];
        fCurrHeight += 10 + height;
    }
    
    fCurrHeight += 10 ;
    
    
	if (self.tfPeriod) {
		[self.tfPeriod setTag:++nTextFieldTag];
	}
	
	// 신규금액, 신규계좌비밀번호, 비밀번호확인, 예금별명, 권유직원번호

    if([[self.dicSelectedData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"])
    {
        for (int nIdx = 0; nIdx < 3; nIdx++)
        {
            
            
            UIView *rowView = [[[UIView alloc]init]autorelease];
            [rowView setFrame:CGRectMake(0, fCurrHeight, 320, 40)];
            [rowView setUserInteractionEnabled:YES];
            [self.contentScrollView addSubview:rowView];
            
            UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, -2, 88, 36)]autorelease];
            [lblTitle setBackgroundColor:[UIColor clearColor]];
            [lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
            [lblTitle setTextColor:RGB(74, 74, 74)];
            [lblTitle setNumberOfLines:0];
            [rowView addSubview:lblTitle];
            
           if (nIdx == 0)
            {
                [lblTitle setText:@"신규계좌\n비밀번호"];
                
                SHBSecureTextField *tf = [[[SHBSecureTextField alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 30)]autorelease];
                [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                [tf setPlaceholder:@"숫자 4자리"];
                [tf setFont:[UIFont systemFontOfSize:15]];
                [tf setTag:++nTextFieldTag];
                [rowView addSubview:tf];
                [tf showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
                
                self.tfNewPW = tf;
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:tf.frame];
                [btn addTarget:self action:@selector(selectSecureTextField1) forControlEvents:UIControlEventTouchDown];
                [rowView addSubview:btn];
            }
            else if (nIdx == 1)
            {
                [lblTitle setText:@"비밀번호 확인"];
                
                SHBSecureTextField *tf = [[[SHBSecureTextField alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 30)]autorelease];
                [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                [tf setFont:[UIFont systemFontOfSize:15]];
                [tf setTag:++nTextFieldTag];
                [rowView addSubview:tf];
                [tf showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
                
                self.tfNewPWConfirm = tf;
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setFrame:tf.frame];
                [btn addTarget:self action:@selector(selectSecureTextField2) forControlEvents:UIControlEventTouchDown];
                [rowView addSubview:btn];
            }
            else if (nIdx == 2)
            {
                [lblTitle setText:@"예금별명\n(선택)"];
                
                SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 30)]autorelease];
                [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                [tf setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [tf setAutocorrectionType:UITextAutocorrectionTypeNo];
                [tf setDelegate:self];
                [tf setAccDelegate:self];
                [tf setFont:[UIFont systemFontOfSize:15]];
                [tf setPlaceholder:@"10자 이내"];
                [tf setTag:++nTextFieldTag];
                [rowView addSubview:tf];
                
                self.tfAccountName = tf;
            }
            
            
    		
            fCurrHeight += 40;
        }

    }
    
    
    else{
    // 기존상품신규
        for (int nIdx = 0; nIdx < 4; nIdx++)
        {
        
        
		UIView *rowView = [[[UIView alloc]init]autorelease];
		[rowView setFrame:CGRectMake(0, fCurrHeight, 320, 40)];
		[rowView setUserInteractionEnabled:YES];
		[self.contentScrollView addSubview:rowView];
		
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, -2, 88, 36)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[rowView addSubview:lblTitle];
		
		if (nIdx == 0) {
			[lblTitle setText:@"신규금액(원)"];
			
			SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 30)]autorelease];
			[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
			[tf setTextAlignment:NSTextAlignmentRight];
			[tf setDelegate:self];
			[tf setAccDelegate:self];
			[tf setKeyboardType:UIKeyboardTypeNumberPad];
			[tf setFont:[UIFont systemFontOfSize:14]];
			[tf setTag:++nTextFieldTag];
			[rowView addSubview:tf];
			self.tfAmount = tf;
            
            if (_dicSmartNewData) { // 스마트신규인 경우 계약기간을 세팅
                [self.tfAmount setText:[SHBUtility normalStringTocommaString:_dicSmartNewData[@"신규금액"]]];
            }
			
			NSString *strPlaceHolder = nil;
			if ([[self.dicSelectedData objectForKey:@"금액_최대금액"]isEqualToString:@"0"]) {
				strPlaceHolder = [NSString stringWithFormat:@"%@원 이상", [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_최소금액"]]]];
				
				valAmount = 1;
			}
			else if ([[self.dicSelectedData objectForKey:@"금액_입금단위금액"]isEqualToString:@"1"]) {
                
                if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
                    [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000201"])
                {
                    strPlaceHolder = [NSString stringWithFormat:@"%@원이상 분기당 %@원이내", [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_최소금액"]]], [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_최대금액"]]]];
                    
                }
                else{

				strPlaceHolder = [NSString stringWithFormat:@"%@원~%@원", [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_최소금액"]]], [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_최대금액"]]]];
                }
				
				valAmount = 2;
			}
			else
			{
               	strPlaceHolder = [NSString stringWithFormat:@"%@원~%@원(%@원단위)", [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_최소금액"]]], [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_최대금액"]]], [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_입금단위금액"]]]];
                
				
				valAmount = 3;
			}
			
			//			if (self.isSubscription) {
			//				FrameResize(rowView, width(rowView), height(rowView)+22);
			//				fCurrHeight += 25-6;
			//
			//				UILabel *lblPlaceHolder = [[[UILabel alloc]initWithFrame:CGRectMake(8, 30, 300, 21)]autorelease];
			//				[lblPlaceHolder setBackgroundColor:[UIColor clearColor]];
			//				[lblPlaceHolder setFont:[UIFont systemFontOfSize:13]];
			//				[lblPlaceHolder setTextColor:RGB(133, 87, 35)];
			//				[lblPlaceHolder setTextAlignment:NSTextAlignmentRight];
			//				[lblPlaceHolder setText:strPlaceHolder];
			//
			//				[rowView addSubview:lblPlaceHolder];
			//			}
			//			else
			//			{
			//				[tf setPlaceholder:strPlaceHolder];
			//			}
			[tf setPlaceholder:strPlaceHolder];
            
		}
		else if (nIdx == 1)
		{
			[lblTitle setText:@"신규계좌\n비밀번호"];
			[lblTitle setNumberOfLines:2];
			SHBSecureTextField *tf = [[[SHBSecureTextField alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 30)]autorelease];
			[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
			[tf setPlaceholder:@"숫자 4자리"];
			[tf setFont:[UIFont systemFontOfSize:15]];
			[tf setTag:++nTextFieldTag];
			[rowView addSubview:tf];
			[tf showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
			
			self.tfNewPW = tf;
			
			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
			[btn setFrame:tf.frame];
			[btn addTarget:self action:@selector(selectSecureTextField1) forControlEvents:UIControlEventTouchDown];
			[rowView addSubview:btn];
		}
		else if (nIdx == 2)
		{
			[lblTitle setText:@"비밀번호 확인"];
			
			SHBSecureTextField *tf = [[[SHBSecureTextField alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 30)]autorelease];
			[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
			[tf setFont:[UIFont systemFontOfSize:15]];
			[tf setTag:++nTextFieldTag];
			[rowView addSubview:tf];
			[tf showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
			
			self.tfNewPWConfirm = tf;
			
			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
			[btn setFrame:tf.frame];
			[btn addTarget:self action:@selector(selectSecureTextField2) forControlEvents:UIControlEventTouchDown];
			[rowView addSubview:btn];
		}
		else if (nIdx == 3) 
		{
            if( [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000501"] ||   //  신탁상품
                [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000601"])
            {
                fCurrHeight -= 40;
            }
            else
            {
                [lblTitle setText:@"예금별명\n(선택)"];
                [lblTitle setNumberOfLines:2];
                
                SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 30)]autorelease];
                [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                [tf setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                [tf setAutocorrectionType:UITextAutocorrectionTypeNo];
                [tf setDelegate:self];
                [tf setAccDelegate:self];
                [tf setFont:[UIFont systemFontOfSize:15]];
                [tf setPlaceholder:@"10자 이내"];
                [tf setTag:++nTextFieldTag];
                [rowView addSubview:tf];
                
                self.tfAccountName = tf;

            }
           
        }

    		
		fCurrHeight += 40;
        }
    }
    
    

    {
        if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
            [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000201"])
        {
            // 소득금액증명원
            UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 150, 34)]autorelease];
            [lblTitle setBackgroundColor:[UIColor clearColor]];
            [lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
            [lblTitle setTextColor:RGB(74, 74, 74)];
            [lblTitle setNumberOfLines:0];
            [lblTitle setText:@"소득확인증명서(재형저축가입용) 발급번호"];
            [self.contentScrollView addSubview:lblTitle];
            
            CGSize lblTitle_Size = [lblTitle.text sizeWithFont:lblTitle.font
                                             constrainedToSize:CGSizeMake(999, 30)
                                                 lineBreakMode:lblTitle.lineBreakMode];
            
            [lblTitle setFrame:CGRectMake(8, fCurrHeight, lblTitle_Size.width, 30)];
            
            UILabel *lblTitlenoti = [[[UILabel alloc]initWithFrame:CGRectMake(8 + lblTitle_Size.width + 5, fCurrHeight, 155, 30)]autorelease];
            [lblTitlenoti setBackgroundColor:[UIColor clearColor]];
            [lblTitlenoti setTextColor:RGB(74, 74, 74)];
            [lblTitlenoti setFont:[UIFont systemFontOfSize:9.5]];
            [lblTitlenoti setText:@"* 14자리"];
            [self.contentScrollView addSubview:lblTitlenoti];
            
            
            fCurrHeight += 40;
            
            
            SHBTextField *tf1 = [[[SHBTextField alloc]initWithFrame:CGRectMake(8, fCurrHeight, 72, 30)]autorelease];
            [tf1 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [tf1 setDelegate:self];
            [tf1 setAccDelegate:self];
            [tf1 setFont:[UIFont systemFontOfSize:15]];
            [tf1 setTag:++nTextFieldTag];
            [tf1 setAutocorrectionType:UITextAutocorrectionTypeNo];
            [tf1 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [tf1 setReturnKeyType:UIReturnKeyDone];
            [tf1 setKeyboardType:UIKeyboardTypeNumberPad];
            [self.contentScrollView addSubview:tf1];
            self.tfNum1 = tf1;
            
            SHBTextField *tf2 = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+72+4, fCurrHeight, 72, 30)]autorelease];
            [tf2 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [tf2 setDelegate:self];
            [tf2 setAccDelegate:self];
            [tf2 setFont:[UIFont systemFontOfSize:15]];
            [tf2 setTag:++nTextFieldTag];
            [tf2 setAutocorrectionType:UITextAutocorrectionTypeNo];
            [tf2 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [tf2 setReturnKeyType:UIReturnKeyDone];
            [tf2 setKeyboardType:UIKeyboardTypeNumberPad];
            [self.contentScrollView addSubview:tf2];
            self.tfNum2 = tf2;
            
            SHBTextField *tf3 = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+72+4+72+4, fCurrHeight, 72, 30)]autorelease];
            [tf3 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [tf3 setDelegate:self];
            [tf3 setAccDelegate:self];
            [tf3 setFont:[UIFont systemFontOfSize:15]];
            [tf3 setTag:++nTextFieldTag];
            [tf3 setAutocorrectionType:UITextAutocorrectionTypeNo];
            [tf3 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [tf3 setReturnKeyType:UIReturnKeyDone];
            [tf3 setKeyboardType:UIKeyboardTypeNumberPad];
            [self.contentScrollView addSubview:tf3];
            self.tfNum3 = tf3;
            
            SHBTextField *tf4 = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+72+4+72+4+72+4, fCurrHeight, 72, 30)]autorelease];
            [tf4 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [tf4 setDelegate:self];
            [tf4 setAccDelegate:self];
            [tf4 setFont:[UIFont systemFontOfSize:15]];
            [tf4 setTag:++nTextFieldTag];
            [tf4 setAutocorrectionType:UITextAutocorrectionTypeNo];
            [tf4 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [tf4 setReturnKeyType:UIReturnKeyDone];
            [tf4 setKeyboardType:UIKeyboardTypeNumberPad];
            [self.contentScrollView addSubview:tf4];
            self.tfNum4 = tf4;
            
            
            fCurrHeight += 40;
            
            
            UILabel *lblnoti1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 10, 12)]autorelease];
			[lblnoti1 setBackgroundColor:[UIColor clearColor]];
			[lblnoti1 setTextColor:RGB(74, 74, 74)];
			[lblnoti1 setFont:[UIFont systemFontOfSize:11]];
			[lblnoti1 setText:@"*"];
			[self.contentScrollView addSubview:lblnoti1];
            
            UILabel *lblnoti1_2 = [[[UILabel alloc]init]autorelease];
			[lblnoti1_2 setBackgroundColor:[UIColor clearColor]];
			[lblnoti1_2 setTextColor:RGB(74, 74, 74)];
			[lblnoti1_2 setFont:[UIFont systemFontOfSize:11]];
			[lblnoti1_2 setText:@"국세청 홈텍스에서 발급한 소득확인증명서(재형저축가입용)의 발급번호를 입력해 주십시오."];
            [lblnoti1_2 setNumberOfLines:0];
            
            CGSize lblnoti1_2_Size = [lblnoti1_2.text sizeWithFont:lblnoti1_2.font
                                                 constrainedToSize:CGSizeMake(283, 999)
                                                     lineBreakMode:lblnoti1_2.lineBreakMode];
            
            [lblnoti1_2 setFrame:CGRectMake(15, fCurrHeight, 283, lblnoti1_2_Size.height)];
            
			[self.contentScrollView addSubview:lblnoti1_2];
            
            
            fCurrHeight += lblnoti1_2_Size.height + 10;
            
            
            UILabel *lblnoti2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 10, 12)]autorelease];
			[lblnoti2 setBackgroundColor:[UIColor clearColor]];
			[lblnoti2 setTextColor:RGB(74, 74, 74)];
			[lblnoti2 setFont:[UIFont systemFontOfSize:11]];
			[lblnoti2 setText:@"*"];
			[self.contentScrollView addSubview:lblnoti2];
            
            UILabel *lblnoti2_2 = [[[UILabel alloc]init]autorelease];
			[lblnoti2_2 setBackgroundColor:[UIColor clearColor]];
			[lblnoti2_2 setTextColor:RGB(74, 74, 74)];
			[lblnoti2_2 setFont:[UIFont systemFontOfSize:11]];
			[lblnoti2_2 setText:@"최초 발급일로부터 90일 이내 사용 가능합니다."];
            [lblnoti2_2 setNumberOfLines:0];
            
            CGSize lblnoti2_2_Size = [lblnoti2_2.text sizeWithFont:lblnoti2_2.font
                                                 constrainedToSize:CGSizeMake(283, 999)
                                                     lineBreakMode:lblnoti2_2.lineBreakMode];
            
            [lblnoti2_2 setFrame:CGRectMake(15, fCurrHeight, 283, lblnoti2_2_Size.height)];
            
			[self.contentScrollView addSubview:lblnoti2_2];
            
            
            fCurrHeight += lblnoti2_2_Size.height + 10;
            
            
            UILabel *lblnoti3 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 10, 12)]autorelease];
			[lblnoti3 setBackgroundColor:[UIColor clearColor]];
			[lblnoti3 setTextColor:RGB(74, 74, 74)];
			[lblnoti3 setFont:[UIFont systemFontOfSize:11]];
			[lblnoti3 setText:@"*"];
			[self.contentScrollView addSubview:lblnoti3];
            
            UILabel *lblnoti3_2 = [[[UILabel alloc]init]autorelease];
			[lblnoti3_2 setBackgroundColor:[UIColor clearColor]];
			[lblnoti3_2 setTextColor:RGB(74, 74, 74)];
			[lblnoti3_2 setFont:[UIFont systemFontOfSize:11]];
			[lblnoti3_2 setText:@"국세청 홈텍스에서 신청시, 수령방법은 '인터넷발급(프린터출력)'선택, 발급희망수량은 '신규할 계좌수*2'만큼 선택하십시오. (ex. 2계좌 가입 시 발급희망수량은 4매 신청, 프린터출력은 2매 이하로 출력하셔야 합니다.)"];
            [lblnoti3_2 setNumberOfLines:0];
            
            CGSize lblnoti3_2_Size = [lblnoti3_2.text sizeWithFont:lblnoti3_2.font
                                                 constrainedToSize:CGSizeMake(283, 999)
                                                     lineBreakMode:lblnoti3_2.lineBreakMode];
            
            [lblnoti3_2 setFrame:CGRectMake(15, fCurrHeight, 283, lblnoti3_2_Size.height)];
            
			[self.contentScrollView addSubview:lblnoti3_2];
            
            
            fCurrHeight += lblnoti3_2_Size.height + 10;
            
            
            UILabel *lblnoti4 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 10, 12)]autorelease];
			[lblnoti4 setBackgroundColor:[UIColor clearColor]];
			[lblnoti4 setTextColor:RGB(74, 74, 74)];
			[lblnoti4 setFont:[UIFont systemFontOfSize:11]];
			[lblnoti4 setText:@"*"];
			[self.contentScrollView addSubview:lblnoti4];
            
            UILabel *lblnoti4_2 = [[[UILabel alloc]init]autorelease];
			[lblnoti4_2 setBackgroundColor:[UIColor clearColor]];
			[lblnoti4_2 setTextColor:RGB(74, 74, 74)];
			[lblnoti4_2 setFont:[UIFont systemFontOfSize:11]];
			[lblnoti4_2 setText:@"소득확인증명서(재형저축가입용) 발급번호 오류 시 가입신청이 거절될 수 있습니다."];
            [lblnoti4_2 setNumberOfLines:0];
            
            CGSize lblnoti4_2_Size = [lblnoti4_2.text sizeWithFont:lblnoti4_2.font
                                                 constrainedToSize:CGSizeMake(283, 999)
                                                     lineBreakMode:lblnoti4_2.lineBreakMode];
            
            [lblnoti4_2 setFrame:CGRectMake(15, fCurrHeight, 283, lblnoti4_2_Size.height)];
            
			[self.contentScrollView addSubview:lblnoti4_2];
            
            fCurrHeight += lblnoti4_2_Size.height + 10;
            
        }
	}
    
	
    {
        if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
            [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000201"])
        {
            NSString *phoneNumber = [AppInfo.userInfo[@"휴대폰번호"] stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSString *phone1 = @"";
            NSString *phone2 = @"";
            NSString *phone3 = @"";
            
            if ([phoneNumber length] == 11) {
                
                phone1 = [phoneNumber substringWithRange:NSMakeRange(0, 3)];
                phone2 = [phoneNumber substringWithRange:NSMakeRange(3, 4)];
                phone3 = [phoneNumber substringWithRange:NSMakeRange(7, 4)];
            }
            else if ([phoneNumber length] == 10) {
                
                phone1 = [phoneNumber substringWithRange:NSMakeRange(0, 3)];
                phone2 = [phoneNumber substringWithRange:NSMakeRange(3, 3)];
                phone3 = [phoneNumber substringWithRange:NSMakeRange(6, 4)];
            }
            
            // 소득금액증명원
            UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 210, 30)]autorelease];
            [lblTitle setBackgroundColor:[UIColor clearColor]];
            [lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
            [lblTitle setTextColor:RGB(74, 74, 74)];
            [lblTitle setNumberOfLines:0];
            [lblTitle setText:@"휴대폰번호"];
            [self.contentScrollView addSubview:lblTitle];
            
            SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3, fCurrHeight, 67, 30)]autorelease];
            [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [tf setDelegate:self];
            [tf setAccDelegate:self];
            [tf setFont:[UIFont systemFontOfSize:15]];
            [tf setTag:++nTextFieldTag];
            [tf setAutocorrectionType:UITextAutocorrectionTypeNo];
            [tf setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [tf setReturnKeyType:UIReturnKeyDone];
            [tf setKeyboardType:UIKeyboardTypeNumberPad];
            [tf setText:phone1];
            [self.contentScrollView addSubview:tf];
            self.tfphone1 = tf;
            
            SHBTextField *tf_2 = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3+67+5, fCurrHeight, 67, 30)]autorelease];
            [tf_2 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [tf_2 setDelegate:self];
            [tf_2 setAccDelegate:self];
            [tf_2 setFont:[UIFont systemFontOfSize:15]];
            [tf_2 setTag:++nTextFieldTag];
            [tf_2 setAutocorrectionType:UITextAutocorrectionTypeNo];
            [tf_2 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [tf_2 setReturnKeyType:UIReturnKeyDone];
            [tf_2 setKeyboardType:UIKeyboardTypeNumberPad];
            [tf_2 setText:phone2];
            [self.contentScrollView addSubview:tf_2];
            self.tfphone2 = tf_2;

            
            SHBTextField *tf_3 = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3+67+5+67+5, fCurrHeight, 67, 30)]autorelease];
            [tf_3 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [tf_3 setDelegate:self];
            [tf_3 setAccDelegate:self];
            [tf_3 setFont:[UIFont systemFontOfSize:15]];
            [tf_3 setTag:++nTextFieldTag];
            [tf_3 setAutocorrectionType:UITextAutocorrectionTypeNo];
            [tf_3 setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [tf_3 setReturnKeyType:UIReturnKeyDone];
            [tf_3 setKeyboardType:UIKeyboardTypeNumberPad];
            //tf_3.secureTextEntry=YES;
            [tf_3 setText:phone3];
            [self.contentScrollView addSubview:tf_3];
            self.tfphone3 = tf_3;

            
            fCurrHeight += 40;
            
            UILabel *lblnoti = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 10, 12)]autorelease];
			[lblnoti setBackgroundColor:[UIColor clearColor]];
			[lblnoti setTextColor:RGB(74, 74, 74)];
			[lblnoti setFont:[UIFont systemFontOfSize:11]];
			[lblnoti setText:@"*"];
			[self.contentScrollView addSubview:lblnoti];
            
            UILabel *lblnoti_2 = [[[UILabel alloc]init]autorelease];
			[lblnoti_2 setBackgroundColor:[UIColor clearColor]];
			[lblnoti_2 setTextColor:RGB(74, 74, 74)];
			[lblnoti_2 setFont:[UIFont systemFontOfSize:11]];
			[lblnoti_2 setText:@"홈텍스 확인 후 신규처리 가능하며 진행 경과 및 결과 통지 SMS용 휴대폰 번호를 입력하여 주십시오."];
            [lblnoti_2 setNumberOfLines:0];
            
            CGSize lblnoti_2_Size = [lblnoti_2.text sizeWithFont:lblnoti_2.font
                                               constrainedToSize:CGSizeMake(283, 999)
                                                   lineBreakMode:lblnoti_2.lineBreakMode];
            
            [lblnoti_2 setFrame:CGRectMake(15, fCurrHeight, 283, lblnoti_2_Size.height)];
            
			[self.contentScrollView addSubview:lblnoti_2];
            
             fCurrHeight += lblnoti_2_Size.height + 10;
        }
	}
    
	{	// 출금계좌번호
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 88, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"출금계좌번호"];
		[self.contentScrollView addSubview:lblTitle];
		
		//		SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+96+3, fCurrHeight, 202, 30)]autorelease];
		//		[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		//		[tf setDelegate:self];
		//		[tf setAccDelegate:self];
		//		[tf setPlaceholder:@"계좌를 선택해주세요."];
		//		[tf setFont:[UIFont systemFontOfSize:14]];
		//		[self.scrollView addSubview:tf];
		//		self.tfOldAccountNum = tf;
		
		SHBSelectBox *sb = [[[SHBSelectBox alloc]initWithFrame:CGRectMake(8+88+3, fCurrHeight, 210, 30)]autorelease];
		[sb setDelegate:self];
		[self.contentScrollView addSubview:sb];
		self.sbOldAccountNum = sb;
		
		self.marrAccounts = [self outAccountList];	// 출금계좌 배열 가져오기
		
		if ([self.marrAccounts count] > 0) {
			self.selectedAccount = [self.marrAccounts objectAtIndex:0];
			[self.sbOldAccountNum setText:[self.selectedAccount objectForKey:@"2"]];	// 첫번째에 있는 계좌번호를 미리 박아둠
            
          
		}
		else
		{
			[self.sbOldAccountNum setText:@"출금계좌정보가 없습니다."];
		}
		
		
		fCurrHeight += 40;
	}
	
	{	// 잔액조회
		UILabel *lblBalance = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 320-90-8, 25)]autorelease];
		[lblBalance setBackgroundColor:[UIColor clearColor]];
		[lblBalance setFont:[UIFont systemFontOfSize:13]];
		[lblBalance setTextColor:RGB(74, 74, 74)];
		[lblBalance setTextAlignment:NSTextAlignmentRight];
		[lblBalance setTag:kTagLabelBalance];
		//		[lblBalance setText:@"출금가능잔액 1,000,000,000원"];
		[self.contentScrollView addSubview:lblBalance];
		
		SHBButton *btn = [SHBButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:CGRectMake(8+76+3+138+12, fCurrHeight, 73, 25)];
		[btn setBackgroundImage:[UIImage imageNamed:@"btn_balancewithdraw.png"] forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageNamed:@"btn_balancewithdraw_focus.png"] forState:UIControlStateHighlighted];
		[btn addTarget:self action:@selector(inquiryBalanceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentScrollView addSubview:btn];
		
		fCurrHeight += 35;
	}
	
	{	// 출금계좌비밀번호
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight-2, 88, 36)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"출금계좌\n비밀번호"];
		[self.contentScrollView addSubview:lblTitle];
		
		SHBSecureTextField *tf = [[[SHBSecureTextField alloc]initWithFrame:CGRectMake(8+88+3, fCurrHeight, 210, 30)]autorelease];
		[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[tf setPlaceholder:@"숫자 4자리"];
		[tf setFont:[UIFont systemFontOfSize:15]];
		[tf setTag:++nTextFieldTag];
		[self.contentScrollView addSubview:tf];
		[tf showKeyPadWitType:SHBSecureTextFieldTypeNumber delegate:self target:self maximum:4];
		
		self.tfOldAccountPW = tf;
		
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:tf.frame];
		[btn addTarget:self action:@selector(selectSecureTextField3) forControlEvents:UIControlEventTouchDown];
		[self.contentScrollView addSubview:btn];
		
		fCurrHeight += 40;
	}
	
    
    if([[self.dicSelectedData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"])
    {
        
        //return; //권유직원 없음
    }

    else{
        // 권유직원
        {
            UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 34)]autorelease];
            [lblTitle setBackgroundColor:[UIColor clearColor]];
            [lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
            [lblTitle setTextColor:RGB(74, 74, 74)];
            [lblTitle setText:@"권유직원(선택)"];
            [self.contentScrollView addSubview:lblTitle];
            fCurrHeight +=34;
            
            self.marrStaffRadioBtns = [NSMutableArray array];
            for (NSDictionary *dic in self.marrRecStaffs)
            {
                if ([dic[@"구분"]hasPrefix:@"[스마트레터"] &&
                    (![[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
                     ![[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000201"]) )
                {
                    
                    
                    UIView *rowView = [[[UIView alloc]init]autorelease];
                    [rowView setFrame:CGRectMake(0, fCurrHeight, 320, 40)];
                    [rowView setUserInteractionEnabled:YES];
                    [self.contentScrollView addSubview:rowView];
                    
                    UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btnRadio setFrame:CGRectMake(8, 9, 21, 21)];
                    [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                    [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
                    [btnRadio addTarget:self action:@selector(selectedRecStaffsRadioBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [rowView addSubview:btnRadio];
                    
                    [btnRadio setDataKey:dic[@"행원번호"]];
                    [self.marrStaffRadioBtns addObject:btnRadio];
                    
                    UILabel *lblRadio1 = [[[UILabel alloc]init]autorelease];
                    [lblRadio1 setFrame:CGRectMake(left(btnRadio)+21+5, 0, 275, 20)];
                    [lblRadio1 setBackgroundColor:[UIColor clearColor]];
                    [lblRadio1 setTextColor:RGB(74, 74, 74)];
                    [lblRadio1 setFont:[UIFont systemFontOfSize:15]];
                    [lblRadio1 setText:[NSString stringWithFormat:@"%@ %@ (%@)", dic[@"행원번호"], dic[@"직원명"], dic[@"한글점명"]]];
                    [rowView addSubview:lblRadio1];
                    
                    UILabel *lblRadio2 = [[[UILabel alloc]init]autorelease];
                    [lblRadio2 setFrame:CGRectMake(left(btnRadio)+21+5, 20, 275, 20)];
                    [lblRadio2 setBackgroundColor:[UIColor clearColor]];
                    [lblRadio2 setTextColor:RGB(74, 74, 74)];
                    [lblRadio2 setFont:[UIFont systemFontOfSize:15]];
                    [lblRadio2 setText:dic[@"구분"]];
                    [rowView addSubview:lblRadio2];
                    
                    fCurrHeight += 40;
                }
                else if ([dic[@"구분"]hasPrefix:@"[SBANK"] &&
                         (![[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
                          ![[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000201"]))
                {
                    UIView *rowView = [[[UIView alloc]init]autorelease];
                    [rowView setFrame:CGRectMake(0, fCurrHeight, 320, 40)];
                    [rowView setUserInteractionEnabled:YES];
                    [self.contentScrollView addSubview:rowView];
                    
                    UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btnRadio setFrame:CGRectMake(8, 9, 21, 21)];
                    [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                    [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
                    [btnRadio addTarget:self action:@selector(selectedRecStaffsRadioBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [rowView addSubview:btnRadio];
                    
                    [btnRadio setDataKey:dic[@"행원번호"]];
                    [self.marrStaffRadioBtns addObject:btnRadio];
                    
                    UILabel *lblRadio1 = [[[UILabel alloc]init]autorelease];
                    [lblRadio1 setFrame:CGRectMake(left(btnRadio)+21+5, 0, 275, 20)];
                    [lblRadio1 setBackgroundColor:[UIColor clearColor]];
                    [lblRadio1 setTextColor:RGB(74, 74, 74)];
                    [lblRadio1 setFont:[UIFont systemFontOfSize:15]];
                    [lblRadio1 setText:[NSString stringWithFormat:@"%@ %@ (%@)", dic[@"행원번호"], dic[@"직원명"], dic[@"한글점명"]]];
                    [rowView addSubview:lblRadio1];
                    
                    UILabel *lblRadio2 = [[[UILabel alloc]init]autorelease];
                    [lblRadio2 setFrame:CGRectMake(left(btnRadio)+21+5, 20, 275, 20)];
                    [lblRadio2 setBackgroundColor:[UIColor clearColor]];
                    [lblRadio2 setTextColor:RGB(74, 74, 74)];
                    [lblRadio2 setFont:[UIFont systemFontOfSize:15]];
                    [lblRadio2 setText:dic[@"구분"]];
                    [rowView addSubview:lblRadio2];
                    
                    fCurrHeight += 40;
                }
            }
            
            
            if ([self.marrStaffRadioBtns count] > 0) {
                [(UIButton *)[self.marrStaffRadioBtns objectAtIndex:0] setSelected:YES];
            }
            
            
            
            int num;
            
            if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
                [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000201"])
            {
                num = 1;
            }
            else{
                num = 2;
            }
            
            for (int nIdx = 0; nIdx < num; nIdx++) {
                UIView *rowView = [[[UIView alloc]init]autorelease];
                [rowView setFrame:CGRectMake(0, fCurrHeight, 320, 40)];
                [rowView setUserInteractionEnabled:YES];
                [self.contentScrollView addSubview:rowView];
                
                UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnRadio setFrame:CGRectMake(8, 9, 21, 21)];
                [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
                [btnRadio addTarget:self action:@selector(selectedRecStaffsRadioBtn:) forControlEvents:UIControlEventTouchUpInside];
                [rowView addSubview:btnRadio];
                [self.marrStaffRadioBtns addObject:btnRadio];
                
                if (nIdx == 0) {
                    
                    [btnRadio setDataKey:@"권유직원조회"];
                    
                    SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+21+5, 5, 183, 30)]autorelease];
                    [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                    [tf setKeyboardType:UIKeyboardTypeNumberPad];
                    [tf setDelegate:self];
                    [tf setAccDelegate:self];
                    [tf setFont:[UIFont systemFontOfSize:15]];
                    [tf setTag:++nTextFieldTag];
                    [rowView addSubview:tf];
                    self.tfEmployee = tf;
                    [tf setEnabled:NO];
                    
                    SHBButton *btn = [SHBButton buttonWithType:UIButtonTypeCustom];
                    [btn setFrame:CGRectMake(8+88+3+118+12, 5, 80, 29)];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_ctype3.png"] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_ctype3_focus.png"] forState:UIControlStateHighlighted];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btn_ctype3.png"] forState:UIControlStateDisabled];
                    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
                    [btn setTitle:@"권유직원조회" forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(searchEmployeeAction:) forControlEvents:UIControlEventTouchUpInside];
                    [rowView addSubview:btn];
                    self.btnEmployee = btn;
                    
                    [btn setEnabled:NO];
                    
                    if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
                        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000201"])
                    {
                        [tf setFrame:CGRectMake(8, 5, 183+23, 30)];
                        [btnRadio setHidden:YES];
                        [tf setEnabled:YES];
                        [btn setEnabled:YES];
                    }
                    
                    if (_dicSmartNewData) // 스마트신규인 경우 권유직원을 직접 세팅
                    {
                        [btnRadio setSelected:YES];
                        [tf setEnabled:YES];
                        [btn setEnabled:YES];
                        [tf setText:_dicSmartNewData[@"등록직원"]];
                        b_tfEmployee = YES;
                    }
                    else
                    {
                        b_tfEmployee= NO;
                    }
                    
                }
                else if (nIdx == 1 &&
                         (![[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
                          ![[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000201"]) )
                {
                    [btnRadio setDataKey:@"선택안함"];
                    
                    UILabel *lblRadio1 = [[[UILabel alloc]init]autorelease];
                    [lblRadio1 setFrame:CGRectMake(left(btnRadio)+21+5, 0, 275, 40)];
                    [lblRadio1 setBackgroundColor:[UIColor clearColor]];
                    [lblRadio1 setTextColor:RGB(74, 74, 74)];
                    [lblRadio1 setFont:[UIFont systemFontOfSize:15]];
                    [lblRadio1 setText:@"선택안함"];
                    [rowView addSubview:lblRadio1];
                    
                    if ([self.marrStaffRadioBtns count] <= 2 && !_dicSmartNewData) {
                        [btnRadio setSelected:YES];
                    }
                }
                
                fCurrHeight += 40;
            }
        }

    }
		
	// 쿠폰   3.8.5 버전에 적용될 예정
	if ([[self.dicSelectedData objectForKey:@"쿠폰입력여부"]isEqualToString:@"1"]
		|| [[self.dicSelectedData objectForKey:@"쿠폰조회여부"]isEqualToString:@"1"]
		|| [[self.dicSelectedData objectForKey:@"쿠폰조회여부"]isEqualToString:@"2"])
	{
		
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight-2, 88, 36)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		//		[lblTitle setText:@"쿠폰번호\n(선택)"];
		[lblTitle setText:@"쿠폰번호(선택)"];
		[self.contentScrollView addSubview:lblTitle];
		
		SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3, fCurrHeight, 118, 30)]autorelease];
		[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tf setKeyboardType:UIKeyboardTypeNumberPad];
		[tf setDelegate:self];
		[tf setAccDelegate:self];
		[tf setFont:[UIFont systemFontOfSize:15]];
		[tf setTag:++nTextFieldTag];
		[self.contentScrollView addSubview:tf];
		self.tfCoupon = tf;
        
        if ([[self.dicSelectedData objectForKey:@"쿠폰입력여부"]isEqualToString:@"0"]
            && [[self.dicSelectedData objectForKey:@"쿠폰조회여부"]isEqualToString:@"1"])
        {
            [tf setEnabled:NO];
        }
        else{
            [tf setEnabled:YES];
        }

		
        if ([[self.dicSelectedData objectForKey:@"쿠폰조회여부"]isEqualToString:@"1"]
            || [[self.dicSelectedData objectForKey:@"쿠폰조회여부"]isEqualToString:@"2"])
        {
		SHBButton *btn = [SHBButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:CGRectMake(8+88+3+118+12, fCurrHeight, 80, 29)];
		[btn setBackgroundImage:[UIImage imageNamed:@"btn_ctype3.png"] forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageNamed:@"btn_ctype3_focus.png"] forState:UIControlStateHighlighted];
		[btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
		[btn setTitle:@"조회" forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(couponBtnAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentScrollView addSubview:btn];
		}
        
		fCurrHeight += 40;
	}
	
	
	
	if ([[self.dicSelectedData objectForKey:@"청약여부"]isEqualToString:@"1"])
	{
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight-2, 88, 34)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"우편번호"];
		[self.contentScrollView addSubview:lblTitle];
		
		SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3, fCurrHeight, 54, 30)]autorelease];
		[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[tf setDelegate:self];
		[tf setAccDelegate:self];
		[tf setFont:[UIFont systemFontOfSize:15]];
		[tf setTag:++nTextFieldTag];
		[self.contentScrollView addSubview:tf];
		self.tfZipCode1 = tf;
		
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3+54, fCurrHeight, 12, 30)]autorelease];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setFont:[UIFont systemFontOfSize:20]];
		[lbl setTextAlignment:NSTextAlignmentCenter];
		[lbl setText:@"-"];
		[self.contentScrollView addSubview:lbl];
		
		SHBTextField *tf1 = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3+54+12, fCurrHeight, 54, 30)]autorelease];
		[tf1 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[tf1 setDelegate:self];
		[tf1 setAccDelegate:self];
		[tf1 setFont:[UIFont systemFontOfSize:15]];
		[tf1 setTag:++nTextFieldTag];
		[self.contentScrollView addSubview:tf1];
		self.tfZipCode2 = tf1;
		
		SHBButton *btn = [SHBButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:CGRectMake(8+88+3+118+12, fCurrHeight, 80, 29)];
		[btn setBackgroundImage:[UIImage imageNamed:@"btn_ctype3.png"] forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageNamed:@"btn_ctype3_focus.png"] forState:UIControlStateHighlighted];
		[btn.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
		[btn setTitle:@"우편번호검색" forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(searchZipCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentScrollView addSubview:btn];
		
		fCurrHeight += 40;
		
		SHBTextField *tf2 = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3, fCurrHeight, 210, 30)]autorelease];
		[tf2 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[tf2 setDelegate:self];
		[tf2 setAccDelegate:self];
		[tf2 setFont:[UIFont systemFontOfSize:15]];
		[tf2 setTag:++nTextFieldTag];
		[self.contentScrollView addSubview:tf2];
		self.tfAddress = tf2;
		fCurrHeight += 30;
		
		NSString *strGuide = @"우편번호 및 청약지역을 반드시 주민등록상의 주소지를 기준으로 선택 하십시오.";
		CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByWordWrapping];
		
		UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight+=10, 301, size.height)]autorelease];
		[lblGuide setBackgroundColor:[UIColor clearColor]];
		[lblGuide setFont:[UIFont systemFontOfSize:13]];
		[lblGuide setTextColor:RGB(74, 74, 74)];
		[lblGuide setNumberOfLines:0];
		[lblGuide setText:strGuide];
		[self.contentScrollView addSubview:lblGuide];
		fCurrHeight += size.height;
		
		NSMutableArray *marrGuides = [NSMutableArray array];
		[marrGuides addObject:@"신규가입 가능시간 : 평일 09:00 ~22:00 (토요일/휴일 불가)"];
		[marrGuides addObject:@"중도해지 및 만기해지가 인터넷에서도 가능합니다."];
		[marrGuides addObject:@"타 은행에 주택청약 관련상품이 있으시면 신청할 수 없습니다."];
		
		UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
		UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[self.contentScrollView addSubview:ivInfoBox];
		
		CGFloat fHeight = 5;
		
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
		
		//		strGuide = @"신규가입 가능시간 : 평일 09:00 ~22:00 (토요일/휴일 불가)\n중도해지 및 만기해지가 인터넷에서도 가능합니다.\n타 은행에 주택청약 관련상품이 있으시면 신청할 수 없습니다.";
		//		size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByWordWrapping];
		//
		//		UILabel *lblGuide1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight+=10, 301, size.height)]autorelease];
		//		[lblGuide1 setBackgroundColor:[UIColor clearColor]];
		//		[lblGuide1 setFont:[UIFont systemFontOfSize:13]];
		//		[lblGuide1 setTextColor:RGB(147, 147, 147)];
		//		[lblGuide1 setNumberOfLines:0];
		//		[lblGuide1 setText:strGuide];
		//		[self.contentScrollView addSubview:lblGuide1];
		//		fCurrHeight += size.height;
	}
	
	FrameReposition(self.bottomView, 0, fCurrHeight-6+22);
	fCurrHeight += 29+28;
	
	[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fCurrHeight)];
	
	contentViewHeight = contentViewHeight > fCurrHeight ? contentViewHeight : fCurrHeight;
    
    startTextFieldTag = 222000;
    endTextFieldTag = nTextFieldTag;
	
//	[self.tfEmployeeSearchWord setAccDelegate:self];
}

#pragma mark - Etc.
- (void)closeKeyboard
{
	[self.tfAccountName resignFirstResponder];
	[self.tfAmount resignFirstResponder];
	[self.tfEmployee resignFirstResponder];
	[self.tfNewPWConfirm resignFirstResponder];
	[self.tfNewPW resignFirstResponder];
	[self.tfPeriod resignFirstResponder];
	[self.tfCoupon resignFirstResponder];
	//		[self.tfOldAccountNum resignFirstResponder];
	[self.tfOldAccountPW resignFirstResponder];
	[self.tfZipCode1 resignFirstResponder];
	[self.tfZipCode2 resignFirstResponder];
	[self.tfAddress resignFirstResponder];
}

- (void)moveToNextViewController
{
    [self.tfNewPW setText:nil];
    [self.tfNewPWConfirm setText:nil];
    [self.tfOldAccountPW setText:nil];
    
    SHBBaseViewController *viewController;
    NSString *strClassName = @"SHBNewProductTaxBreakViewController";
    
    if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000201"] )  //재형저축일때
    {
        strClassName = @"SHBNewProductTaxBreakViewController2";
    }
    
    if( [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000501"] ||   //  신탁상품
       [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000601"])
    {
         strClassName = @"SHBNewProductTaxBreakViewController3";
    }
    
    viewController = [[NSClassFromString(strClassName) alloc] initWithNibName:strClassName bundle:nil];
    
    if ([strClassName isEqualToString:@"SHBNewProductTaxBreakViewController"])  //재형저축아닌경우
    {
        ((SHBNewProductTaxBreakViewController*)viewController).dicSmartNewData = self.dicSmartNewData;
    }
    
    // warning 피하기 위해 casting
    ((SHBNewProductTaxBreakViewController*)viewController).dicSelectedData = self.dicSelectedData;
    ((SHBNewProductTaxBreakViewController*)viewController).userItem = self.userItem;
    viewController.needsLogin = YES;
    
    NSLog(@"예금적금 단계 %@",self.stepNumber);
    if([self.stepNumber isEqualToString:@"예금적금 가입 3단계" ])
    {
        ((SHBNewProductTaxBreakViewController*)viewController).stepNumber = @"예금적금 가입 4단계"; //3단계 (주택청약일때)
    }
    else
    {
        ((SHBNewProductTaxBreakViewController*)viewController).stepNumber = @"예금적금 가입 3단계";
    }
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark - Ask Staff and Search Zipcode
- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic{
	[super viewControllerDidSelectDataWithDic:mDic];
	
	if (mDic){
		if ([[mDic objectForKey:@"행번"]length]) {
			[self.tfEmployee setText:[mDic objectForKey:@"행번"]];
		}
		else if ([mDic[@"POST1"]length])
		{
			[self.tfZipCode1 setText:mDic[@"POST1"]];
			[self.tfZipCode2 setText:mDic[@"POST2"]];
			[self.tfAddress setText:[NSString stringWithFormat:@"%@ %@", mDic[@"ADDR1"], mDic[@"ADDR2"]]];
		}
		
	}
}

#pragma mark - Action
// 적립방식 선택 : 정기적립식, 자유적립식
- (void)selectedAccumulateRadioBtn:(UIButton *)sender
{
	for (UIButton *btn in self.marrAccumulateRadioBtns)
	{
		[btn setSelected:NO];
	}	
	[sender setSelected:YES];

	if ([sender.dataKey isEqualToString:@"정기적립식"]) {
		[self.dicSelectedData setObject:self.strProductCode1 forKey:@"상품코드"];
	}
	else if ([sender.dataKey isEqualToString:@"자유적립식"]) {
		[self.dicSelectedData setObject:self.strProductCode2 forKey:@"상품코드"];
	}
	
	Debug(@"%@", self.dicSelectedData);
}

- (void)selectedPeriodRadioBtn:(UIButton *)sender	// 계약기간 선택
{
	for (UIButton *btn in self.marrPeriodRadioBtns)
	{
		[btn setSelected:NO];
	}
	
	[sender setSelected:YES];
}

- (void)selectedTurnRadioBtn:(UIButton *)sender	// 회전주기기간 선택
{
	for (UIButton *btn in self.marrTurnRadioBtns)
	{
		[btn setSelected:NO];
	}
	
	[sender setSelected:YES];
}

// 권유직원 라디오버튼
- (void)selectedRecStaffsRadioBtn:(UIButton *)sender
{
	for (UIButton *btn in self.marrStaffRadioBtns)
	{
		[btn setSelected:NO];
	}
	
	[sender setSelected:YES];
	
	if ([sender.dataKey isEqualToString:@"권유직원조회"]) {
		[self.tfEmployee setEnabled:YES]; 
		[self.btnEmployee setEnabled:YES];
        b_tfEmployee = YES;
	}
	else
	{
		[self.tfEmployee setEnabled:NO];
		[self.tfEmployee setText:nil];
		[self.btnEmployee setEnabled:NO];
        b_tfEmployee = NO;
	}
}

- (void)inquiryBalanceBtnAction:(SHBButton *)sender		// 잔액조회
{
//	if ([self.tfOldAccountNum.text length]) {
	if ([self.sbOldAccountNum.text length]) {
#if 0
		self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D0011" viewController:self]autorelease];
		self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"A" : @"A",}] autorelease];
		[self.service start];
#else
		if (self.selectedAccount) {
			self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2004" viewController:self]autorelease];
			self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : [self.selectedAccount objectForKey:@"2"]}] autorelease];
			[self.service start];
		}
#endif
	}
}

- (void)searchEmployeeAction:(SHBButton *)sender
{
#if 1	
	SHBAskStaffViewController *staffViewController = [[SHBAskStaffViewController alloc] initWithNibName:@"SHBAskStaffViewController" bundle:nil];
	[staffViewController executeWithTitle:@"권유직원 조회" ReturnViewController:self];
	[self.navigationController pushFadeViewController:staffViewController];
	[staffViewController release];
#elif 0
	[self.tfEmployeeSearchWord setFrame:self.tfEmployeeSearchWord.frame];
	
	SHBPopupView *popupView = [[[SHBPopupView alloc]initWithTitle:@"권유직원 조회" subView:self.employeeView]autorelease];
	[popupView setDelegate:self];
	[popupView showInView:self.navigationController.view animated:YES];

	self.employeePopupView = popupView;
#else
	SHBNewProductSolicitorSearchViewController *viewController = [[SHBNewProductSolicitorSearchViewController alloc]initWithNibName:@"SHBNewProductSolicitorSearchViewController" bundle:nil];
	UIWindow *window = [[UIApplication sharedApplication]keyWindow];
	if (!window) {
		window = [[[UIApplication sharedApplication]windows]objectAtIndex:0];
	}
	[window addSubview:viewController.view];
	[viewController release];
#endif
}

//- (IBAction)employeeRadioBtn:(UIButton *)sender {
//	if (![sender isSelected]) {
//		if (sender == self.btnRadioEmployee) {
//			[self.btnRadioEmployee setSelected:YES];
//			[self.btnRadioBranch setSelected:NO];
//		}
//		else if (sender == self.btnRadioBranch) {
//			[self.btnRadioEmployee setSelected:NO];
//			[self.btnRadioBranch setSelected:YES];
//		}
//	}
//}
//
//- (IBAction)searchEmployeeBtn:(SHBButton *)sender {		// 권유직원 팝업뷰의 조회버튼
//	[self didCompleteButtonTouch];
//
//	if ([self.tfEmployeeSearchWord.text length]) {
//		NSString *strValue = nil;
//		if ([self.btnRadioEmployee isSelected]) {
//			strValue = @"1";
//		}
//		else if ([self.btnRadioBranch isSelected]) {
//			strValue = @"2";
//		}
//		
//		self.service = [[[SHBProductService alloc]initWithServiceId:kE1826Id viewController:self]autorelease];
//		self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
//									@"검색어" : self.tfEmployeeSearchWord.text,
//								   @"조회구분" : strValue,
//							   }];
//		[self.service start];
//	}
//}

- (void)couponBtnAction:(SHBButton *)sender
{
	self.service = [[[SHBProductService alloc]initWithServiceId:kE4903Id viewController:self]autorelease];
	[self.service start];
}

- (void)searchZipCodeBtnAction:(SHBButton *)sender
{
	SHBSearchZipViewController *viewController = [[[SHBSearchZipViewController alloc]initWithNibName:@"SHBSearchZipViewController" bundle:nil]autorelease];
	[viewController executeWithTitle:@"예금/적금 가입" ReturnViewController:self];
	[self.navigationController pushFadeViewController:viewController];
}

- (IBAction)confirmBtnAction:(UIButton *)sender {
#if 0	// Temp
	SHBNewProductTaxBreakViewController *viewController = [[SHBNewProductTaxBreakViewController alloc]initWithNibName:@"SHBNewProductTaxBreakViewController" bundle:nil];
	viewController.dicSelectedData = self.dicSelectedData;
    viewController.dicSmartNewData = _dicSmartNewData;
    
    if([self.stepNumber isEqualToString:@"예금적금 가입 3단계" ])
    {
        viewController.stepNumber = @"예금적금 가입 4단계"; //3단계 (주택청약일때)
    }
    else
    {
         viewController.stepNumber = @"예금적금 가입 3단계";
    }
    
    [self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
#else
    
    if( ![[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000501"] &&   //  신탁상품
        ![[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"290000601"])
    {
        
        if ([self.marrAccumulateRadioBtns count]) {  // 라디오버튼으로 정기 or 자유 선택 상품일때
            for (UIButton *btn in self.marrAccumulateRadioBtns)
            {
                if ([btn isSelected]) {
                    [self.userItem setObject:btn.dataKey forKey:@"적립방식선택"];
                    break;
                }
            }
        }
        else{    // 적립방식_정기적립식여부 , 적립방식_자유적립식여부 값에 따라서
            
            if ([[self.dicSelectedData objectForKey:@"적립방식_정기적립식여부"] isEqualToString:@"1"])
            {
                [self.userItem setObject:@"정기적립식" forKey:@"적립방식선택"];
            }
            else if ([[self.dicSelectedData objectForKey:@"적립방식_자유적립식여부"] isEqualToString:@"1"])
            {
                [self.userItem setObject:@"자유적립식" forKey:@"적립방식선택"];
            }
            
            
        }
        
        if ([[self.dicSelectedData objectForKey:@"계약기간_고정여부"]isEqualToString:@"1"]) {
            [self.userItem setObject:[self.dicSelectedData objectForKey:@"계약기간_고정_기간"] forKey:@"계약기간"];
        }
        else if([[self.dicSelectedData objectForKey:@"계약기간_자유여부"]isEqualToString:@"1"]){
            if (self.exceptionVal == NO && ([[self.dicSelectedData objectForKey:@"계약기간_자유_최소기간"] intValue]>[self.tfPeriod.text intValue] ||
                                            [[self.dicSelectedData objectForKey:@"계약기간_자유_최대기간"] intValue]<[self.tfPeriod.text intValue]) ) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"계약기간은 최소 %@개월 이상 %@개월 이내 월 단위로 입력하셔야 합니다.",[self.dicSelectedData objectForKey:@"계약기간_자유_최소기간"],
                                                                         [self.dicSelectedData objectForKey:@"계약기간_자유_최대기간"] ]
                                                               delegate:nil cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil ];
                [alert show];
                [alert release];
                return;
            }
            if (self.exceptionVal == YES && (self.mini>[self.tfPeriod.text intValue] ||
                                             self.max<[self.tfPeriod.text intValue]) ) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:[NSString stringWithFormat:@"계약기간은 최소 %d개월 이상 %d개월 이내 월 단위로 입력하셔야 합니다.",self.mini,self.max ]
                                                               delegate:nil cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil ];
                [alert show];
                [alert release];
                return;
                
            }
            [self.userItem setObject:self.tfPeriod.text forKey:@"계약기간" ];
        }
        else if([[self.dicSelectedData objectForKey:@"계약기간_선택여부"]isEqualToString:@"1"]){
            NSString *strKey = nil;
            
            for (UIButton *btn in self.marrPeriodRadioBtns)
            {
                if ([btn isSelected]) {
                    Debug(@"selected : %d", btn.tag);
                    strKey = [NSString stringWithFormat:@"계약기간_선택%d", btn.tag+1];
                }
            }
            
            NSString *strVal = [self.dicSelectedData objectForKey:strKey];
            [self.userItem setObject:strVal forKey:@"계약기간"];
        }
        else {   //계약기간이 없는 경우
            [self.userItem setObject:@"0" forKey:@"계약기간" ];
        }
        
    
    }
    
	

	if(valAmount == 1){
		if ([[self.dicSelectedData objectForKey:@"금액_최소금액"] longLongValue] > [[self.tfAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:[NSString stringWithFormat:@"신규금액은 %@원 이상입니다.",
																	 [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_최소금액"]]] ]
														   delegate:nil
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		
		if ([[self.tfAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] % [[self.dicSelectedData objectForKey:@"금액_입금단위금액"] longLongValue] != 0 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:[NSString stringWithFormat:@"신규금액은 %@원 단위로 입력해 주십시오.",
																	 [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_입금단위금액"] ]] ]
														   delegate:nil
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			return;
		}
	}
	else if(valAmount == 2 || valAmount == 3){
		if ([[self.dicSelectedData objectForKey:@"금액_최소금액"] longLongValue] > [[self.tfAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] ||
			[[self.dicSelectedData objectForKey:@"금액_최대금액"] longLongValue] < [[self.tfAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:[NSString stringWithFormat:@"신규금액은 %@원 ~ %@원 입니다.",
																	 [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_최소금액"] ]],
																	 [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_최대금액"]]] ]
														   delegate:nil
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			return;
		}
		
		if ([[self.tfAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] % [[self.dicSelectedData objectForKey:@"금액_입금단위금액"] longLongValue] != 0 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:[NSString stringWithFormat:@"신규금액은 %@원 단위로 입력해 주십시오.",
																	 [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"금액_입금단위금액"] ]] ]
														   delegate:nil
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			return;
		}
		
	}
	
    //U드림 회전정기예금 추가 13.10.29
    
    if([[self.dicSelectedData objectForKey:@"회전주기_선택비트"] isEqualToString:@"136"])
    {
		NSString *strKey = nil;
        NSString *strVal = nil;
		
        for (UIButton *btn in self.marrTurnRadioBtns)
        {
            if ([btn isSelected])
            {
                Debug(@"selected : %d", btn.tag);
                    
				strKey = [NSString stringWithFormat:@"%d", btn.tag];
            }
        }
		
        if ([strKey isEqualToString:@"0"])
        {
            strVal= [NSString stringWithFormat:@"1"];
        }
        
        else if ([strKey isEqualToString:@"1"])
        {
            strVal= [NSString stringWithFormat:@"3"];
        }
        else if ([strKey isEqualToString:@"2"])
        {
            strVal= [NSString stringWithFormat:@"6"];
        }

        
		[self.userItem setObject:strVal forKey:@"회전주기"];
	}
	else   //계약기간이 없는 경우
    {   
		[self.userItem setObject:@"0" forKey:@"회전주기"];
	}
	
    
    	
	if ([self.tfNewPW.text length] != 4) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"신규계좌 비밀번호는 4자리를 입력해 주십시오."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	if ([self.tfNewPWConfirm.text length] != 4) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"신규계좌 비밀번호 확인은 4자리를 입력해 주십시오."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
    
    if ([_tmpA isEqualToString:@"0000"] || [_tmpA isEqualToString:@"1111"] || [_tmpA isEqualToString:@"2222"] ||
        [_tmpA isEqualToString:@"3333"] || [_tmpA isEqualToString:@"4444"] || [_tmpA isEqualToString:@"5555"] ||
        [_tmpA isEqualToString:@"6666"] || [_tmpA isEqualToString:@"7777"] || [_tmpA isEqualToString:@"8888"] ||
        [_tmpA isEqualToString:@"9999"] )
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"입력하신 신규계좌 비밀번호는 동일한 숫자를 연속 사용이 불가 합니다."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
        
		self.tfNewPW.text = nil;
		self.tfNewPWConfirm.text = nil;
		self.tmpA = @"";
        self.tmpB = @"";
        
		return;
	}
	
    
	if (([self.tfNewPW.text length] && [self.tfNewPWConfirm.text length] && ![_tmpA isEqualToString:_tmpB]) ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"신규계좌 비밀번호와 비밀번호확인이 일치하지 않습니다."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
        
		self.tfNewPW.text = nil;
		self.tfNewPWConfirm.text = nil;
		self.tmpA = @"";
        self.tmpB = @"";
		return;
		
	}
	
    
   
//    
//	if ([self.tfEmployee.text length]) {
//		if ([self.tfEmployee.text length] != 8) {
//			[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"권유직원번호는 8자리를 입력하시기 바랍니다."];
//			
//			return;
//		}
//	}
//	
	if(self.tfAccountName.text != nil && [SHBUtility countMultiByteStringFromUTF8String:self.tfAccountName.text] > 20 )
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:[NSString stringWithFormat:@"내용이 입력한도를 초과했습니다.(한글 10자, 영숫자 20자)"]
													   delegate:self
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		
		[alert show];
		[alert release];
		
		[self.tfAccountName setText:[SHBUtility substring:self.tfAccountName.text ToMultiByteLength:20]];
	}
    
    if(self.tfAccountName.text != nil && [self.tfAccountName.text length] > 0)
    {
        int checkCount = 0;
        for (int i = 0; i < [self.tfAccountName.text length]; i++) {
            NSInteger ch = [self.tfAccountName.text characterAtIndex:i];
            /**
             A~Z : 65 ~ 90
             a~z : 97 ~ 122
             0~9 : 48 ~ 57
             ㄱ ~ ㅣ : 12593 ~ 12643
             가~ 힣(Hangul Syllabales): 44032 ~ 55203
             **/
            if (!((32 == ch) || (48 <= ch && ch <= 57) || (65 <= ch && ch <=92) || (97 <= ch && ch <= 122) || (44032 <= ch && ch <= 55203) || (12593 <= ch && ch <= 12643))) {
                checkCount++;
                break;
            }
        }
        
        if (checkCount > 0 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"예금별명은 한글과 영숫자만 입력이 가능합니다."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    }

	if (self.tfAccountName.text != nil && [self.tfAccountName.text length] != 0) {
		[self.userItem setObject:self.tfAccountName.text forKey:@"예금별명"];
	}
	else {
		[self.userItem setObject:@"" forKey:@"예금별명"];
	}
    
    if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000201"] )  //재형저축일때
    {
        NSString *tfNumStr = [NSString stringWithFormat:@"%@%@%@%@", _tfNum1.text, _tfNum2.text, _tfNum3.text, _tfNum4.text];
	
        if ([tfNumStr length] != 14) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"소득확인증명서 발급번호 14자리를 입력해 주십시오."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    
              
        NSString *phone_1 = [self.tfphone1.text substringWithRange:NSMakeRange(0, 1)];

        
        NSLog(@"phone_1 %@",phone_1);
        if (![phone_1 isEqualToString:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"휴대폰 번호를 입력하여 주십시오."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        if (![self.tfphone1.text length] && ![self.tfphone1.text length] && ![self.tfphone1.text length]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"휴대폰 번호를 입력하여 주십시오."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
    
        if ([self.tfphone1.text length] < 3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"휴대폰번호 첫번째 입력칸은 3자리 이상 입력하여 주십시오."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
       
           
        if ([self.tfphone2.text length] < 3)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"휴대폰번호 두번째 입력칸은 3자리 이상 입력하여 주십시오."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    
        if ([self.tfphone3.text length] < 4)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"휴대폰번호 세번째 입력칸은 4자리를 입력하여 주십시오."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
        }
    }
	
//	if (![self.tfOldAccountNum.text length]) {
	if (![self.sbOldAccountNum.text length]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"출금계좌번호를 입력해 주십시오."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	if ([self.tfOldAccountPW.text length] != 4) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"출금계좌비밀번호는 4자리를 입력해 주십시오."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
    
    
    if (b_tfEmployee == YES &&  [self.tfEmployee.text length] != 8) {
  
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"권유직원번호는 8자리로 입력하시기 바랍니다."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
    
    
	
	if ([[self.dicSelectedData objectForKey:@"청약여부"] isEqualToString:@"1"] &&
		([self.tfZipCode1.text length] == 0) )  {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"우편번호를 검색하여 입력하여 주십시오."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
    
    if (self.tfAccountName.text != nil && [self.tfAccountName.text length] != 0) {
		[self.userItem setObject:self.tfAccountName.text forKey:@"예금별명"];
	}
	else {
		[self.userItem setObject:@"" forKey:@"예금별명"];
    }
    
    
    
    NSString *strPhoneNum = [NSString stringWithFormat:@"%@-%@-%@", self.tfphone1.text, self.tfphone2.text, self.tfphone3.text];
    
	[self.userItem setObject:[self.dicSelectedData objectForKey:@"상품명"] forKey:@"상품명"];
	
	[self.userItem setObject:self.strEncryptedNewPW forKey:@"신규계좌비밀번호"];
    
    
    
    if([[self.dicSelectedData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"] )  
    
    {

       newMoney = [[self.dicSelectedData objectForKey:@"신청금액"] stringByReplacingOccurrencesOfString:@"," withString:@""];

    }
    else
    {
        newMoney = self.tfAmount.text;
    }
    
    
    [self.userItem setObject:newMoney forKey:@"신규금액"];
    
    
    if ([[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000101"] ||
        [[self.dicSelectedData objectForKey:@"상품코드"]isEqualToString:@"232000201"])  //재형저축일때
    {
        NSString *tfNumStr = [NSString stringWithFormat:@"%@%@%@%@", _tfNum1.text, _tfNum2.text, _tfNum3.text, _tfNum4.text];
        
        [self.userItem setObject:tfNumStr forKey:@"소득금액증명발급번호"];
        [self.userItem setObject:strPhoneNum forKey:@"휴대폰번호"];
        
        if ([self.tfEmployee.text length]) {
            [self.userItem setObject:self.tfEmployee.text forKey:@"직원번호"];
        }
        
    }
    
    
    
	for (UIButton *btnRadio in self.marrStaffRadioBtns)
	{
		if ([btnRadio isSelected]) {
			if ([btnRadio.dataKey isEqualToString:@"선택안함"] == NO) {
				if ([self.tfEmployee.text length]) {
					[self.userItem setObject:self.tfEmployee.text forKey:@"직원번호"];
				}
				else
				{
					[self.userItem setObject:btnRadio.dataKey forKey:@"직원번호"];
				}
			}
		}
	}
	
    if ([[self.dicSelectedData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"]) //u드림 회전정기)
    {
        [self.userItem setObject:self.dicSelectedData[@"승인신청행원번호"] forKey:@"직원번호"];
    }
    
	if ([self.tfCoupon.text length]) {
		[self.userItem setObject:self.tfCoupon.text forKey:@"쿠폰번호"];
	}
	
	if ([[self.dicSelectedData objectForKey:@"청약여부"] isEqualToString:@"1"]) {
		[self.userItem setObject:[NSString stringWithFormat:@"%@%@",self.tfZipCode1.text,self.tfZipCode2.text] forKey:@"우편번호"];
	}

	Debug(@"신계좌 : %@", [self.selectedAccount objectForKey:@"출금계좌번호"]);
	Debug(@"계좌 : %@", [self.selectedAccount objectForKey:@"2"]);

	//D4306 전문은 신계좌번호로만 전송 // 출금은행 구분은 "1"
	[self.userItem setObject:[self.selectedAccount objectForKey:@"출금계좌번호"] forKey:@"출금계좌번호"];		// 2 = 계좌번호
//	[self.userItem setObject:self.tfOldAccountNum.text forKey:@"출금계좌번호출력용"];
	[self.userItem setObject:self.sbOldAccountNum.text forKey:@"출금계좌번호출력용"];
	[self.userItem setObject:[self.selectedAccount objectForKey:@"은행코드"] forKey:@"출금계좌번호출력용은행코드"];
	
	
	[self.userItem setObject:self.strEncryptedOldPW forKey:@"출금계좌비밀번호"];
	[self.userItem setObject:@"1" forKey:@"출금계좌은행구분"];
    
    // D3603 에러시 처리
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(D3603Error:)
                                                 name:@"notiServerError"
                                               object:nil];
    
    self.service = [[[SHBProductService alloc] initWithServiceId:kD3603Id viewController:self] autorelease];
    self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
                                @"비밀번호최대자리수" : @"4",
                                @"고객번호" : AppInfo.customerNo,
                                @"비밀번호" : self.strEncryptedNewPW,
                                }];
    [self.service start];
    
    
    
#endif
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
//	Debug(@"self.navigationController.viewControllers : %@", self.navigationController.viewControllers);
//	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
//	{
//		if ([viewController isKindOfClass:[SHBNewProductStipulationViewController class]]) {
//			[self.navigationController popToViewController:viewController animated:YES];
//		}
//	}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewProductCancel" object:nil];
}

//#pragma mark - Table view data source
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//	return [self.marrEmployees count]+1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    SHBNewProductSolicitorSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[SHBNewProductSolicitorSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//    }
//    
//    // Configure the cell...
//	if (indexPath.row == 0) {
//		[cell setBackgroundView:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"memberlist_title.png"]]autorelease]];
//		[cell setSelectedBackgroundView:nil];
//		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//		[cell.lblLeft setFrame:CGRectMake(57, 0, 171-57, 22)];
//		[cell.lblRight setFrame:CGRectMake(179, 0, 40, 22)];
//		[cell.lblLeft setText:@"지점명"];
//		[cell.lblRight setText:@"이름"];
//	}
//	else
//	{
//		[cell setBackgroundView:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"memberlist_list_off.png"]]autorelease]];
//		[cell setSelectedBackgroundView:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"memberlist_list_on.png"]]autorelease]];
//		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
//		[cell.lblLeft setFrame:CGRectMake(8, 0, 158-8-18, 27)];
//		[cell.lblRight setFrame:CGRectMake(158, 0, 76, 27)];
//		
//		NSDictionary *dicData = [self.marrEmployees objectAtIndex:indexPath.row-1];
//		
//		[cell.lblLeft setText:[dicData objectForKey:@"지점명"]];
//		[cell.lblRight setText:[dicData objectForKey:@"성명"]];
//	}
//    
//    return cell;
//}
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	NSInteger row = indexPath.row;
//	if (row != 0) {
//		[self.tfEmployee setText:[[self.marrEmployees objectAtIndex:row-1]objectForKey:@"행번"]];
//		
//		[self.employeePopupView closePopupViewWithButton:nil];
//	}
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	CGFloat retVal = 0;
//	if (indexPath.row == 0) {
//		retVal = 22;
//	}
//	else
//	{
//		retVal = 27;
//	}
//	
//	return retVal;
//}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag == 23200) { // 재형저축 소득확인증명서 발급번호 젤 앞자리가 2013으로 시작한 경우
        if (buttonIndex == alertView.cancelButtonIndex) { // 확인
            [super didNextButtonTouch];
        }
        else {
            [_tfNum1 setText:@""];
        }
    }
    if (alertView.tag == 3939) {
        if (buttonIndex == alertView.firstOtherButtonIndex) {
            [self moveToNextViewController];
        }
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![super textField:textField shouldChangeCharactersInRange:range replacementString:string])
    {
        return NO;
    }
    
	int dataLength = [textField.text lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	int dataLength2 = [string lengthOfBytesUsingEncoding:0x80000000 + kCFStringEncodingDOSKorean];
	NSString *textString;
    
	if (textField == self.tfAmount) {	// 신규금액
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 14)
        {
			return NO;
		}
		else
        {
			if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
            {
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
				return NO;
			}
            else
            {
				int nLen = [textField.text length];
				NSString *strStr = [textField.text substringToIndex:nLen - 1];
				textField.text = strStr;
                
                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
				return NO;
			}
		}
		
	}
	else if (textField == self.tfAccountName)	// 예금별명
	{		
		//특수문자 : ₩ $ £ ¥ • 은 입력 안됨
		NSString *SPECIAL_CHAR = @"$₩€£¥•";
		
		NSCharacterSet *cs;
		cs = [[NSCharacterSet characterSetWithCharactersInString:SPECIAL_CHAR] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 20)
        {
			return NO;
		}
	}

	else if (textField == self.tfCoupon) {	// 쿠폰번호입력
		textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([textField.text length] >= 12 && range.length == 0) {
            return NO;
        }

	}
    
    else if (textField == self.tfEmployee)  //권유직원번호
    {
        textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([textField.text length] >= 8 && range.length == 0) {
            return NO;
        }
    }

    
    else if (textField == self.tfphone1)  // 휴대폰 번호
    {
        textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([textField.text length] >= 2 && range.length == 0) {
            if ([textString length] <= 3) {
                [self.tfphone1 setText:textString];
            }
            
            [super didNextButtonTouch];
            
            return NO;
        }
    }
    else if (textField == self.tfphone2)
    {
      textString = [textField.text stringByReplacingCharactersInRange:range withString:string];   
        if ([textField.text length] >= 3 && range.length == 0) {
            if ([textString length] <= 4) {
                [self.tfphone2 setText:textString];
            }
            
            [super didNextButtonTouch];
            
            return NO;
        }
    }
    else if (textField == self.tfphone3)
    {
         textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([textField.text length] >= 4 && range.length == 0) {
            return NO;
        }
    }
    
    // 소득확인증명서
    else if (textField == self.tfNum1)
    {
        textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([textField.text length] >= 3 && range.length == 0) {
            if ([textString length] <= 4) {
                [self.tfNum1 setText:textString];
            }
            
            if ([_tfNum1.text isEqualToString:@"2013"]) {
                [UIAlertView showAlert:self
                                  type:ONFAlertTypeTwoButton
                                   tag:23200
                                 title:@""
                               message:@"지금 입력하신 소득확인증명서 발급번호는 발급번호가 아닌 접수번호 일 수 있습니다. '발급번호'가 맞는지 다시 한번 확인해 주시기 바랍니다."];
            }
            else {
                [super didNextButtonTouch];
            }
            
            return NO;
        }
    }
    else if (textField == self.tfNum2)
    {
        textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([textField.text length] >= 2 && range.length == 0) {
            if ([textString length] <= 3) {
                [self.tfNum2 setText:textString];
            }
            
            [super didNextButtonTouch];
            
            return NO;
        }
    }
    else if (textField == self.tfNum3)
    {
        textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([textField.text length] >= 3 && range.length == 0) {
            if ([textString length] <= 4) {
                [self.tfNum3 setText:textString];
            }
            
            [super didNextButtonTouch];
            
            return NO;
        }
    }
    else if (textField == self.tfNum4)
    {
        textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([textField.text length] >= 3 && range.length == 0) {
            return NO;
        }
    }


	
	return YES;
}

#pragma mark - 보안키패드 처리
- (void)selectSecureTextField1
{
	[super closeNormalPad:nil];
	[self.tfNewPW becomeFirstResponder];
}

- (void)selectSecureTextField2
{
	[super closeNormalPad:nil];
	[self.tfNewPWConfirm becomeFirstResponder];
}

- (void)selectSecureTextField3
{
	[super closeNormalPad:nil];
	[self.tfOldAccountPW becomeFirstResponder];
}

#pragma mark - SHBSecureTextField Delegate
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
	[super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    Debug(@"EncriptedVaule: %@", value);
	
	if (textField == self.tfNewPW) {
		self.tmpA = textField.text;
		
		self.strEncryptedNewPW = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
	}
	else if (textField == self.tfNewPWConfirm) {
		self.tmpB = textField.text;
		
		self.strEncryptedNewPWConfirm = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
	}
	else if (textField == self.tfOldAccountPW) {
		self.strEncryptedOldPW = [NSString stringWithFormat:@"<E2K_NUM=%@>", value];
	}
}

#pragma mark - SHBSelectBox Delegate
- (void)didSelectSelectBox:(SHBSelectBox *)selectBox
{
	[self closeKeyboard];
	[selectBox setState:SHBSelectBoxStateSelected];
	
	if (selectBox == self.sbOldAccountNum) {
		
		Debug(@"self.marrAccounts : %@", self.marrAccounts);
		
//		if ([self.marrAccounts count] == 0) {
//			[UIAlertView showAlert:self
//							  type:ONFAlertTypeOneButton
//							   tag:0
//							 title:@""
//						   message:@"출금가능한 계좌가 없습니다."];
//		}
//		else {
//			SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"출금계좌"
//																		   options:self.marrAccounts
//																		   CellNib:@"SHBAccountListPopupCell"
//																			 CellH:50
//																	   CellDispCnt:5
//																		CellOptCnt:4] autorelease];
//			[popupView setDelegate:self];
//			[popupView setTag:ListPopupViewTagAccounts];
//			[popupView showInView:self.navigationController.view animated:YES];
//			
//		}
		SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"출금계좌"
																	   options:self.marrAccounts
																	   CellNib:@"SHBAccountListPopupCell"
																		 CellH:50
																   CellDispCnt:5
																	CellOptCnt:4] autorelease];
		[popupView setDelegate:self];
		[popupView setTag:ListPopupViewTagAccounts];
		[popupView showInView:self.navigationController.view animated:YES];
        self.tfOldAccountPW.text=@"";
	}
	
}

#pragma mark - SHBListPopupView Delegate
- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
	if (listPopView.tag == ListPopupViewTagAccounts) {
		UILabel *lblBalance = (UILabel *)[self.contentScrollView viewWithTag:kTagLabelBalance];
		[lblBalance setText:nil];
		
		self.selectedAccount = [self.marrAccounts objectAtIndex:anIndex];
		
		[self.sbOldAccountNum setText:[self.selectedAccount objectForKey:@"2"]];
		[self.sbOldAccountNum setState:SHBSelectBoxStateNormal];
	}
	else if (listPopView.tag == ListPopupViewTagCoupons) {
		NSString *str = [[self.marrCoupons objectAtIndex:anIndex]objectForKey:@"2"];
		[self.tfCoupon setText:str];
	}
}

- (void)listPopupViewDidCancel
{
	[self.sbOldAccountNum setState:SHBSelectBoxStateNormal];
}

#pragma mark - SHBPopupView Delegate
- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary*)mDic
{
}

- (void)popupViewDidCancel
{
}

#pragma mark - server Error Notification

- (void)D3603Error:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiServerError" object:nil];
    
    self.tfNewPW.text = @"";
    self.tfNewPWConfirm.text = @"";
    self.strEncryptedNewPW = @"";
    self.strEncryptedNewPWConfirm = @"";
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
#if 0
	if ([AppInfo.serviceCode isEqualToString:@"D0011"]) {
		NSMutableArray *array = [aDataSet arrayWithForKey:@"예금계좌"];
		
		NSString *strAccountNum1 = [self.selectedAccount objectForKey:@"2"];
		NSString *strAccountNum2 = nil;
		
		for (NSDictionary *dic in array)
		{
			strAccountNum2 = [[dic objectForKey:@"신계좌변환여부"] isEqualToString:@"1"] ? [dic objectForKey:@"계좌번호"] : [dic objectForKey:@"구계좌번호"];
			
			if ([strAccountNum1 isEqualToString:strAccountNum2]) {	// 전문통신을 통해 가져온 계좌 중 계좌번호가 같은 것의 잔액을 보여주고 빠지자.
				// 잔액표시
				NSString *strBalance = [dic objectForKey:@"잔액"];
				
				UILabel *lblBalance = (UILabel *)[self.scrollView viewWithTag:kTagLabelBalance];
				[lblBalance setText:[NSString stringWithFormat:@"출금가능잔액 %@원", strBalance]];
				
				break;
			}
		}

	}
#else
    if (self.service.serviceId == kD3603Id) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiServerError" object:nil];
        
        if (![aDataSet[@"비밀번호유효여부"] isEqualToString:@"1"]) {
            
            // error
            [self D3603Error:nil];
            
            return NO;
        }
        
        
        self.service = [[[SHBProductService alloc]initWithServiceId:kC2090Id viewController:self]autorelease];
        self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
                                    @"은행구분" : [self.selectedAccount objectForKey:@"은행코드"],	// 3 = 은행코드
                                    @"출금계좌번호" : [self.selectedAccount objectForKey:@"출금계좌번호"]/*self.sbOldAccountNum.text*/,
                                    @"출금계좌비밀번호" : self.strEncryptedOldPW/*self.tfOldAccountPW.text*/,
                                    @"납부금액" : newMoney,

                                    }];
        [self.service start];
         self.tfOldAccountPW.text =@"";
        return NO;
    }
    else if ([AppInfo.serviceCode isEqualToString:@"D2004"])
	{
		NSString *strBalance = [aDataSet objectForKey:@"지불가능잔액"];
		UILabel *lblBalance = (UILabel *)[self.contentScrollView viewWithTag:kTagLabelBalance];
		[lblBalance setText:[NSString stringWithFormat:@"출금가능잔액 %@원", strBalance]];
		
	}
#endif
//	else if (self.service.serviceId == kE1826Id)	// 권유직원 조회
//	{
//		self.marrEmployees = [aDataSet arrayWithForKey:@"조회내역"];
//		if (![self.marrEmployees count]) {
//			[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"검색결과가 존재하지 않습니다."];
//		}
//		else
//		{
//			Debug(@"self.marrEmployees : %@", self.marrEmployees);
//			[self.tblEmployees reloadData];
//		}
//	}
	else if (self.service.serviceId == kC2090Id)
	{
        if (_dicSmartNewData) { // 스마트신규인 경우 알럿 추가
            NSString *msg = [NSString stringWithFormat:@"고객님께서 신청하신 내용은 아래와 같습니다.\n계약기간 : %@개월\n신규금액 : %@원\n\n위와 같이 신청하시겠습니까?",
                             self.userItem[@"계약기간"],
                             self.userItem[@"신규금액"]];
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@""
                                                                 message:msg
                                                                delegate:self
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"예", @"아니오", nil] autorelease];
            [alertView setTag:3939];
            [alertView show];
            
            return NO;
        }
       
		[self moveToNextViewController];
        
	}
	else if (self.service.serviceId == kE4903Id)
	{
		Debug(@"%@",aDataSet);

		self.marrCoupons = [aDataSet arrayWithForKey:@"LIST.vector.data"];
		Debug(@"%@", self.marrCoupons);
		
		if ([self.marrCoupons count] == 0) {
			[UIAlertView showAlert:nil type:ONFAlertTypeOneButton tag:0 title:@"" message:@"쿠폰이 존재하지 않습니다."];
		}
		else
		{
			NSInteger nCnt = 0;
			for (NSMutableDictionary *dic in self.marrCoupons)
			{
				[dic setObject:[dic objectForKey:@"쿠폰명"] forKey:@"1"];
				[dic setObject:[dic objectForKey:@"쿠폰번호"] forKey:@"2"];
				nCnt++;
			}
			
			SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"쿠폰번호"
																		   options:self.marrCoupons
																		   CellNib:@"SHBAccountListPopupCell"
																			 CellH:50
																	   CellDispCnt:5
																		CellOptCnt:4] autorelease];
			[popupView setDelegate:self];
			[popupView setTag:ListPopupViewTagCoupons];
			[popupView showInView:self.navigationController.view animated:YES];
		}
	}
	else if (self.service.serviceId == XDA_SelectEmpInfo)
	{
		Debug(@"aDataSet : %@", aDataSet);
		
		self.marrRecStaffs = [aDataSet arrayWithForKeyPath:@"data"];
		
        [self responseSelectEmpInfo];
	}
	else if (self.service.serviceId == kD5020Id) {
		NSMutableArray *marr = [aDataSet arrayWithForKey:@"조회내역"];
		Debug(@"%@", marr);
		
		NSDictionary *dicData = [marr objectAtIndex:0];

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
        
		
		[self setUI];
	}
	
	return NO;
}

@end
