//
//  SHB_GoldTech_InputViewcontroller.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 11. 6..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

typedef enum
{
	ListPopupViewTagAccounts = 400,
	ListPopupViewTagCoupons,
}ListPopupViewTag;
#import "SHB_GoldTech_InputViewcontroller.h"
#import "SHB_GoldTech_ProductInfoViewcontroller.h"
#import "SHBELD_BA17_13_TaxBreakViewController.h"
#import "SHBELD_BA17_14_SignUpViewController.h"
#import "SHBELD_BA17_11ViewController.h"
#import "SHBUtility.h"
#import "SHBAskStaffViewController.h"
#import "SHBProductService.h"
#import "SHBNewProductRegTopView.h"
#import "SHBAccountService.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBExchangeService.h"
#import "SHBCustomerService.h" // 서비스
#import "SHBUtility.h"
#import "SHB_GoldTech_ManualInfoViewController.h"
#define kLeftTitleFontSize		15

#define kTagLabelBalance		11


@interface SHB_GoldTech_InputViewcontroller ()
{
	CGFloat fCurrHeight;
	SHBTextField *currentTextField;
	
	NSInteger nTextFieldTag;
    BOOL b_tfEmployee;
    
    BOOL b_MoneyType;  // 신규금액 타입
    
    BOOL b_zero;  // 0선택
    BOOL b_notice;   //수익률통지 타입
    
    BOOL b_mail;   //수익률통지 타입

    
    int type;
    
    NSString *strRate;
    
    UIButton *zeroChkbtn;
    
    UILabel *titleType;   //신규적립타입
    UIButton *btnTitleRadio;
    UILabel *lblTitleRadio;
    SHBTextField *tf_money;
    SHBTextField *tf_gram;
    
    
    UIButton *btnNoticeRadio1;  // 수익률기준 통지
    SHBTextField *tf_goal1;    //목표수익률
    SHBTextField *tf_ganger1;  //위험수익률
    
    UIButton *btnNoticeRadio2;  // 가격기준 통지
    SHBTextField *tf_goal2;
    SHBTextField *tf_ganger2;
    
    UIButton *btnNo_mail;  // 미통보
    UIButton *btn_mail;  // 이메일
    UILabel *lblmail;
    
     SHBTextField *tf_mailday; // 정기잔고통보일
    
    
    NSString *strEmail;
    
    NSString *sMoney;   //적립량
    
}

@property (nonatomic, retain) NSString *tmpA;	// 예외처리용
@property (nonatomic, retain) NSString *tmpB;	// 예외처리용

@property (nonatomic, retain) NSMutableArray *marrAccounts;		// 출금계좌 배열
@property (nonatomic, retain) NSMutableDictionary *selectedAccount;	// 선택된 출금계좌

@property (nonatomic, retain) NSString *strEncryptedNewPW;			// Encrypt된 패스워드
@property (nonatomic, retain) NSString *strEncryptedNewPWConfirm;	// Encrypt된 패스워드 확인
@property (nonatomic, retain) NSString *strEncryptedOldPW;	// Encrypt된 출금계좌비밀번호
@property (nonatomic, retain) NSMutableArray *marrCoupons;	// 쿠폰
@property (nonatomic, retain) NSMutableArray *marrRecStaffs;	// 전문으로 받아온 권유직원
@property (nonatomic, retain) NSMutableArray *marrStaffRadioBtns;	// 권유직원 라디오버튼
@property (retain, nonatomic) NSString *strRate;
@property (retain, nonatomic) NSString *strEmail;

@property (nonatomic, retain) NSMutableArray *marrMoneyTypeRadioBtns;		// 신규적립 라디오버튼선택
@property (nonatomic, retain) NSMutableArray *marrNoticTypeRadioBtns;		// 통지타입 라디오버튼선택
@property (nonatomic, retain) NSMutableArray *marrEmailTypeRadioBtns;		// email 라디오버튼선택


@end



@implementation SHB_GoldTech_InputViewcontroller

@synthesize btn_zeroCheck;
@synthesize inAccInfoDic;
@synthesize outAccInfoDic;
@synthesize strRate;
@synthesize strEmail;
@synthesize userItem;


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
    [_tmpA release];
    [_tmpB release];
    
	[_btnEmployee release];
	[_marrStaffRadioBtns release];
	[_marrRecStaffs release];

    
	[_marrCoupons release];
    
	[_strEncryptedNewPW release];
	[_strEncryptedNewPWConfirm release];
	[_strEncryptedOldPW release];

    
	[_selectedAccount release];
	[_marrAccounts release];
    
	[_sbOldAccountNum release];
	[_tfOldAccountPW release];

	[_tfAmount release];
	[_tfEmployee release];
	[_tfNewPW release];
	[_tfNewPWConfirm release];
	[_dicSelectedData release];
	[_bottomView release];
    
    [_tfgoal1 release];
    [_tfgoal2 release];
    [_tfganger1 release];
    [_tfganger2 release];
    [_dayGoal release];
    [_dayGoalNotic release];
    [_tfAmount_gram release];
    
  	[super dealloc];
}

- (void)reset
{
    self.tfNewPW.text = @"";
    self.tfNewPWConfirm.text = @"";
    self.tfOldAccountPW.text = @"";
    
    self.strEncryptedNewPW = @"";
    self.strEncryptedNewPWConfirm = @"";
    self.strEncryptedOldPW = @"";
}


- (void)viewDidUnload {
    
    
	self.sbOldAccountNum = nil;
	self.tfOldAccountPW = nil;

	self.tfAmount = nil;
	self.tfEmployee = nil;
	self.tfNewPW = nil;
	self.tfNewPWConfirm = nil;
	[self setBottomView:nil];
    
    self.tfgoal1  = nil;
    self.tfgoal2  = nil;
    self.tfganger1  = nil;
    self.tfganger2  = nil;
    self.dayGoal = nil;
    self.dayGoalNotic = nil;
    self.tfAmount_gram = nil;
    
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

    b_MoneyType = NO;
    b_zero = nil;
    b_notice = NO;  // 수익률통지 타입
    b_mail = NO;
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	FrameResize(self.contentScrollView, 317, height(self.contentScrollView));
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[self.dicSelectedData objectForKey:@"상품명"] maxStep:5 focusStepNumber:3]autorelease]];
    
    
    
    //통화코드 조회 전문
    NSString *strCurDate = [SHBUtility getCurrentDate];
    
    self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"F1405" viewController:self] autorelease];
    self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"조회구분" : @"1", @"고시일자09" : strCurDate}] autorelease];
    [self.service start];

    
    
    
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
    NSMutableArray *tableDataArray;
    
    tableDataArray = self.inAccInfoDic[@"외환출금계좌리스트"];
    
    
	fCurrHeight = 0;
	
    // 적립방식, 계약기간
	CGFloat height = 30*3;
	
    
	SHBNewProductRegTopView *topView = [[[SHBNewProductRegTopView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 320, height) parentViewController:self]autorelease];
	[self.contentScrollView addSubview:topView];
	fCurrHeight += 10 + height;
	
    
	
	// 신규금액, 신규계좌비밀번호, 비밀번호확인, 예금별명, 권유직원번호
    
	for (int nIdx = 0; nIdx < 6; nIdx++)
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
			[lblTitle setText:@"통화코드"];
			
			UILabel *lb_value = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 30)]autorelease];
			[lb_value setBackgroundColor:[UIColor clearColor]];
			[lb_value setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
			[lb_value setTextColor:RGB(74, 74, 74)];
			[lb_value setNumberOfLines:0];

			[rowView addSubview:lb_value];
			self.lb_code = lb_value;
			
            [lb_value setText:[NSString stringWithFormat:@"XAU(우대환율:%@)", strRate]];
            
		}
        
        
        else if (nIdx == 1)
        {
			[lblTitle setText:@"신규적립(g,원)"];  // 라디오버튼
			
            
            self.marrMoneyTypeRadioBtns = [NSMutableArray array];
            
            
            for (int sIdx = 0; sIdx < 2; sIdx++) {
                btnTitleRadio = [UIButton buttonWithType:UIButtonTypeCustom];
                [btnTitleRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
                [btnTitleRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
                [btnTitleRadio addTarget:self action:@selector(typeRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentScrollView addSubview:btnTitleRadio];
                [self.marrMoneyTypeRadioBtns addObject:btnTitleRadio];
                
                lblTitleRadio = [[[UILabel alloc]init]autorelease];
                [lblTitleRadio setBackgroundColor:[UIColor clearColor]];
                [lblTitleRadio setTextColor:RGB(74, 74, 74)];
                [lblTitleRadio setFont:[UIFont systemFontOfSize:14]];
                [self.contentScrollView addSubview:lblTitleRadio];
                
                if (sIdx == 0) {
                    [btnTitleRadio setFrame:CGRectMake(320-3-8-200, 145, 21, 21)];
                    [btnTitleRadio setSelected:YES];
                    
                    [btnTitleRadio setDataKey:@"골드(그램)"];
                    
                    [lblTitleRadio setText:@"골드(그램)"];
                    
                }
                else if (sIdx == 1) {
                    [btnTitleRadio setFrame:CGRectMake(204, 145, 21, 21)];
                    [btnTitleRadio setDataKey:@"원화금액"];
                    
                    [lblTitleRadio setText:@"원화금액"];
                }
                
                [lblTitleRadio setFrame:CGRectMake(left(btnTitleRadio)+21+5, 145, 80, 21)];
            }

        }
        

        
		else if (nIdx == 2) {  // 신규금액
			[lblTitle setText:@""];
			
            tf_money = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+88+3, 0, 140, 30)]autorelease];
			[tf_money setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
			[tf_money setTextAlignment:NSTextAlignmentRight];
			[tf_money setDelegate:self];
			[tf_money setAccDelegate:self];
			[tf_money setKeyboardType:UIKeyboardTypeNumberPad];
			[tf_money setFont:[UIFont systemFontOfSize:15]];
			[tf_money setTag:++nTextFieldTag];
            [tf_money setText:@"0"];
            
			[rowView addSubview:tf_money];
			self.tfAmount = tf_money;
			
			NSString *strPlaceHolder = nil;
            strPlaceHolder = [NSString stringWithFormat:@"%@", [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"거치최소금액"]]]];
            valAmount = 1;
			
			[tf_money setPlaceholder:strPlaceHolder];
            
            
            UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(242, 0, 5, 30)]autorelease];
            [lblTitle setBackgroundColor:[UIColor clearColor]];
            [lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
            [lblTitle setTextColor:RGB(74, 74, 74)];
            [lblTitle setNumberOfLines:0];
            [lblTitle setText:@"."];
            [rowView addSubview:lblTitle];

            
            tf_gram = [[[SHBTextField alloc]initWithFrame:CGRectMake(250, 0, 30, 30)]autorelease];
			[tf_gram setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
			[tf_gram setTextAlignment:NSTextAlignmentRight];
			[tf_gram setDelegate:self];
			[tf_gram setAccDelegate:self];
			[tf_gram setKeyboardType:UIKeyboardTypeNumberPad];
			[tf_gram setFont:[UIFont systemFontOfSize:15]];
			[tf_gram setTag:++nTextFieldTag];
            [tf_gram setText:@"0"];
            
			[rowView addSubview:tf_gram];
			self.tfAmount_gram = tf_gram;
			valAmount = 2;
						

            
             titleType = [[[UILabel alloc]initWithFrame:CGRectMake(282, 0, 30, 30)]autorelease];
            [titleType setBackgroundColor:[UIColor clearColor]];
            [titleType setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
            [titleType setTextColor:RGB(74, 74, 74)];
            [titleType setNumberOfLines:0];
            [titleType setText:@"그램"];
            [rowView addSubview:titleType];

            
		}
        
        else if (nIdx == 3)
		{
			[lblTitle setText:@""];
			
            UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3, 0, 210, 30)]autorelease];
            [lblTitle setBackgroundColor:[UIColor clearColor]];
            [lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
            lblTitle.textAlignment = UITextAlignmentRight;
            [lblTitle setTextColor:RGB(74, 74, 74)];
            [lblTitle setNumberOfLines:0];
            [lblTitle setText:@"0원 신규"];
            [rowView addSubview:lblTitle];
            
            zeroChkbtn = [[UIButton alloc] initWithFrame:CGRectMake(230, 5, 20, 20)];
            [zeroChkbtn setBackgroundImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
            [zeroChkbtn setBackgroundImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateSelected];
            [zeroChkbtn addTarget:self action:@selector(zeroCheck:) forControlEvents:UIControlEventTouchUpInside];
          //  chkbtn.tag = 1267;
            [zeroChkbtn setDataKey:@"0원 신규"];
            [rowView addSubview:zeroChkbtn];
            
        }
        
        
        else if (nIdx == 4)
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
		
		else if (nIdx == 5)
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
		
        
		fCurrHeight += 40;
	}
    
      self.marrNoticTypeRadioBtns = [NSMutableArray array];
    
	{	// 목표 / 위험 수익률 통지(선택)
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 200, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"목표/위험 수익률통지(선택)"];
		[self.contentScrollView addSubview:lblTitle];
		
		UIButton *chkbtn = [[UIButton alloc] initWithFrame:CGRectMake(230, fCurrHeight+5, 20, 20)];
        [chkbtn setBackgroundImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
        [chkbtn setBackgroundImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateSelected];
        [chkbtn addTarget:self action:@selector(noticCheck:) forControlEvents:UIControlEventTouchUpInside];
        //chkbtn.tag = 1267;
        [chkbtn setDataKey:@"미선택"];
        [self.contentScrollView addSubview:chkbtn];
        
        
        UILabel *lblselect = [[[UILabel alloc]initWithFrame:CGRectMake(8+88+3, fCurrHeight, 210, 30)]autorelease];
        [lblselect setBackgroundColor:[UIColor clearColor]];
        [lblselect setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
        lblselect.textAlignment = UITextAlignmentRight;
        [lblselect setTextColor:RGB(74, 74, 74)];
        [lblselect setNumberOfLines:0];
        [lblselect setText:@"미선택"];
        
        [self.contentScrollView addSubview:lblselect];

        
		fCurrHeight += 40;
	}

    {	//수익률 기준 통지
		
        btnNoticeRadio1 =[[UIButton alloc] initWithFrame:CGRectMake(30, fCurrHeight+5, 20, 20)];
        [btnNoticeRadio1 setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
        [btnNoticeRadio1 setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
        [btnNoticeRadio1 addTarget:self action:@selector(noticeRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnNoticeRadio1 setSelected:YES];
        type = 3;
        [btnNoticeRadio1 setDataKey:@"수익률 기준 통지"];
        [self.marrNoticTypeRadioBtns addObject:btnNoticeRadio1];
        [self.contentScrollView addSubview:btnNoticeRadio1];

        
        UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(60, fCurrHeight, 180, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"수익률 기준 통지"];
		[self.contentScrollView addSubview:lblTitle];

        
		fCurrHeight += 40;
	}
    
    {	//수익률 기준 통지
		
    
        
        UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(60, fCurrHeight, 80, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"목표수익률"];
		[self.contentScrollView addSubview:lblTitle];
        
        
        UILabel *lblselect = [[[UILabel alloc]initWithFrame:CGRectMake(160, fCurrHeight, 10, 30)]autorelease];
        [lblselect setBackgroundColor:[UIColor clearColor]];
        [lblselect setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
        lblselect.textAlignment = UITextAlignmentLeft;
        [lblselect setTextColor:RGB(74, 74, 74)];
        [lblselect setNumberOfLines:0];
        [lblselect setText:@"+"];
        [self.contentScrollView addSubview:lblselect];

        
        tf_goal1 = [[[SHBTextField alloc]initWithFrame:CGRectMake(180, fCurrHeight, 80, 30)]autorelease];
        [tf_goal1 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tf_goal1 setTextAlignment:NSTextAlignmentRight];
        [tf_goal1 setKeyboardType:UIKeyboardTypeNumberPad];
        [tf_goal1 setDelegate:self];
        [tf_goal1 setAccDelegate:self];
        [tf_goal1 setFont:[UIFont systemFontOfSize:15]];
        [tf_goal1 setTag:++nTextFieldTag];
        
        self.tfgoal1 = tf_goal1;
        [self.contentScrollView addSubview:tf_goal1];
        
        UILabel *lblper = [[[UILabel alloc]initWithFrame:CGRectMake(270, fCurrHeight, 30, 30)]autorelease];
        [lblper setBackgroundColor:[UIColor clearColor]];
        [lblper setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
        lblper.textAlignment = UITextAlignmentLeft;
        [lblper setTextColor:RGB(74, 74, 74)];
        [lblper setNumberOfLines:0];
        [lblper setText:@"%"];
        [self.contentScrollView addSubview:lblper];
		fCurrHeight += 40;
	}
    
    {	//수익률 기준 통지
		
        
        UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(60, fCurrHeight, 80, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"위험수익률"];
		[self.contentScrollView addSubview:lblTitle];
        
        
        UILabel *lblselect = [[[UILabel alloc]initWithFrame:CGRectMake(160, fCurrHeight, 10, 30)]autorelease];
        [lblselect setBackgroundColor:[UIColor clearColor]];
        [lblselect setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
        lblselect.textAlignment = UITextAlignmentLeft;
        [lblselect setTextColor:RGB(74, 74, 74)];
        [lblselect setNumberOfLines:0];
        [lblselect setText:@"-"];
        [self.contentScrollView addSubview:lblselect];
        
        
        tf_ganger1 = [[[SHBTextField alloc]initWithFrame:CGRectMake(180, fCurrHeight, 80, 30)]autorelease];
        [tf_ganger1 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tf_ganger1 setTextAlignment:NSTextAlignmentRight];
        [tf_ganger1 setKeyboardType:UIKeyboardTypeNumberPad];
        [tf_ganger1 setDelegate:self];
        [tf_ganger1 setAccDelegate:self];
        [tf_ganger1 setFont:[UIFont systemFontOfSize:15]];
        [tf_ganger1 setTag:++nTextFieldTag];
        self.tfganger1 = tf_ganger1;
        [self.contentScrollView addSubview:tf_ganger1];
        
        UILabel *lblper = [[[UILabel alloc]initWithFrame:CGRectMake(270, fCurrHeight, 30, 30)]autorelease];
        [lblper setBackgroundColor:[UIColor clearColor]];
        [lblper setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
        lblper.textAlignment = UITextAlignmentLeft;
        [lblper setTextColor:RGB(74, 74, 74)];
        [lblper setNumberOfLines:0];
        [lblper setText:@"%"];
        [self.contentScrollView addSubview:lblper];
		fCurrHeight += 30;
	}
    

    {	//가격기준통지
		
        btnNoticeRadio2 =[[UIButton alloc] initWithFrame:CGRectMake(30, fCurrHeight+5, 20, 20)];
        [btnNoticeRadio2 setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
        [btnNoticeRadio2 setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
        [btnNoticeRadio2 addTarget:self action:@selector(noticeRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.marrNoticTypeRadioBtns addObject:btnNoticeRadio2];
        [btnNoticeRadio2 setDataKey:@"가격 기준 통지"];
        [self.contentScrollView addSubview:btnNoticeRadio2];
        
        
        UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(60, fCurrHeight, 180, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"가격 기준 통지"];
		[self.contentScrollView addSubview:lblTitle];
        
        
		fCurrHeight += 30;
	}
    
    {	//수익률 기준 통지
		

        UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(60, fCurrHeight, 80, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"목표가격"];
		[self.contentScrollView addSubview:lblTitle];
        
        tf_goal2 = [[[SHBTextField alloc]initWithFrame:CGRectMake(160, fCurrHeight, 100, 30)]autorelease];
        [tf_goal2 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tf_goal2 setTextAlignment:NSTextAlignmentRight];
        [tf_goal2 setKeyboardType:UIKeyboardTypeNumberPad];
        [tf_goal2 setDelegate:self];
        [tf_goal2 setAccDelegate:self];
        [tf_goal2 setFont:[UIFont systemFontOfSize:15]];
        [tf_goal2 setTag:++nTextFieldTag];
        [tf_goal2 setEnabled:NO];
        self.tfgoal2 = tf_goal2;
        [self.contentScrollView addSubview:tf_goal2];
        
        UILabel *lblper = [[[UILabel alloc]initWithFrame:CGRectMake(270, fCurrHeight, 30, 30)]autorelease];
        [lblper setBackgroundColor:[UIColor clearColor]];
        [lblper setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
        lblper.textAlignment = UITextAlignmentLeft;
        [lblper setTextColor:RGB(74, 74, 74)];
        [lblper setNumberOfLines:0];
        [lblper setText:@"원"];
        [self.contentScrollView addSubview:lblper];
		fCurrHeight += 40;
	}
    
    {	//수익률 기준 통지
		
       
        
        UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(60, fCurrHeight, 80, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"위험가격"];
		[self.contentScrollView addSubview:lblTitle];
        
        
        
        tf_ganger2 = [[[SHBTextField alloc]initWithFrame:CGRectMake(160, fCurrHeight, 100, 30)]autorelease];
        [tf_ganger2 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tf_ganger2 setTextAlignment:NSTextAlignmentRight];
        [tf_ganger2 setKeyboardType:UIKeyboardTypeNumberPad];
        [tf_ganger2 setDelegate:self];
        [tf_ganger2 setAccDelegate:self];
        [tf_ganger2 setFont:[UIFont systemFontOfSize:15]];
        [tf_ganger2 setTag:++nTextFieldTag];
        [tf_ganger2 setEnabled:NO];
        self.tfganger2 = tf_ganger2;
        [self.contentScrollView addSubview:tf_ganger2];
        
        UILabel *lblper = [[[UILabel alloc]initWithFrame:CGRectMake(270, fCurrHeight, 30, 30)]autorelease];
        [lblper setBackgroundColor:[UIColor clearColor]];
        [lblper setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
        lblper.textAlignment = UITextAlignmentLeft;
        [lblper setTextColor:RGB(74, 74, 74)];
        [lblper setNumberOfLines:0];
        [lblper setText:@"원"];
        [self.contentScrollView addSubview:lblper];
		fCurrHeight += 40;
	}
    
    {	//정기수익률
		
        
        UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 80, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"정기수익률"];
		[self.contentScrollView addSubview:lblTitle];
        
        UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(120, fCurrHeight, 30, 30)]autorelease];
        [lblTitle1 setBackgroundColor:[UIColor clearColor]];
        [lblTitle1 setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
        lblTitle1.textAlignment = UITextAlignmentLeft;
        [lblTitle1 setTextColor:RGB(74, 74, 74)];
        [lblTitle1 setNumberOfLines:0];
        [lblTitle1 setText:@"매월"];
        [self.contentScrollView addSubview:lblTitle1];
        
        SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(160, fCurrHeight, 60, 30)]autorelease];
        [tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tf setTextAlignment:NSTextAlignmentCenter];
        [tf setKeyboardType:UIKeyboardTypeNumberPad];
        [tf setDelegate:self];
        [tf setAccDelegate:self];
        [tf setFont:[UIFont systemFontOfSize:15]];
        [tf setTag:++nTextFieldTag];
        self.dayGoal = tf;
        [self.contentScrollView addSubview:tf];
        
        UILabel *lblTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(220, fCurrHeight, 90, 30)]autorelease];
        [lblTitle2 setBackgroundColor:[UIColor clearColor]];
        [lblTitle2 setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
        lblTitle2.textAlignment = UITextAlignmentLeft;
        [lblTitle2 setTextColor:RGB(74, 74, 74)];
        [lblTitle2 setNumberOfLines:0];
        [lblTitle2 setText:@"일(선택사항)"];
        [self.contentScrollView addSubview:lblTitle2];

		fCurrHeight += 40;
	}
    
    
    
      self.marrEmailTypeRadioBtns = [NSMutableArray array];
    
    
    {	//미통보
		
        
        UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 100, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"정기잔고통보"];
		[self.contentScrollView addSubview:lblTitle];
        
        
        btnNo_mail =[[UIButton alloc] initWithFrame:CGRectMake(320-3-8-200, fCurrHeight+5, 21, 21)];
        [btnNo_mail setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
        [btnNo_mail setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
        [btnNo_mail addTarget:self action:@selector(emailRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnNo_mail setSelected:YES];
        [btnNo_mail setDataKey:@"미통보"];

        [self.marrEmailTypeRadioBtns addObject:btnNo_mail];
        [self.contentScrollView addSubview:btnNo_mail];
        
        
        UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(320-3-8-200+30, fCurrHeight, 60, 30)]autorelease];
		[lblTitle1 setBackgroundColor:[UIColor clearColor]];
		[lblTitle1 setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle1 setTextColor:RGB(74, 74, 74)];
		[lblTitle1 setNumberOfLines:0];
		[lblTitle1 setText:@"미통보"];
		[self.contentScrollView addSubview:lblTitle1];
        
        btn_mail =[[UIButton alloc] initWithFrame:CGRectMake(320-3-8-200+30+60, fCurrHeight+5, 21, 21)];
        [btn_mail setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
        [btn_mail setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
        [btn_mail addTarget:self action:@selector(emailRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn_mail setDataKey:@"E-mail"];
        [self.marrEmailTypeRadioBtns addObject:btn_mail];
        [self.contentScrollView addSubview:btn_mail];
        
        
        UILabel *lblTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(320-3-8-200+30+60+30, fCurrHeight, 50, 30)]autorelease];
		[lblTitle2 setBackgroundColor:[UIColor clearColor]];
		[lblTitle2 setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle2 setTextColor:RGB(74, 74, 74)];
		[lblTitle2 setNumberOfLines:0];
		[lblTitle2 setText:@"E-mail"];
		[self.contentScrollView addSubview:lblTitle2];

		fCurrHeight += 20;
	}
    
    
    {	//Email

        
        lblmail = [[[UILabel alloc]initWithFrame:CGRectMake(320-3-8-200+10, fCurrHeight, 200, 30)]autorelease];
		[lblmail setBackgroundColor:[UIColor clearColor]];
		[lblmail setFont:[UIFont systemFontOfSize:11]];
		[lblmail setTextColor:RGB(74, 74, 74)];
		[lblmail setNumberOfLines:0];
		//[lblmail setText:@"수익률 기준 통지"];
		[self.contentScrollView addSubview:lblmail];
        
        
		fCurrHeight += 40;
	}
    
    
    {	//정기수익률
		
        
        UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 120, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"정기잔고통보일"];
		[self.contentScrollView addSubview:lblTitle];
        
        UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(120, fCurrHeight, 30, 30)]autorelease];
        [lblTitle1 setBackgroundColor:[UIColor clearColor]];
        [lblTitle1 setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
        lblTitle1.textAlignment = UITextAlignmentLeft;
        [lblTitle1 setTextColor:RGB(74, 74, 74)];
        [lblTitle1 setNumberOfLines:0];
        [lblTitle1 setText:@"매월"];
        [self.contentScrollView addSubview:lblTitle1];
        
        tf_mailday = [[[SHBTextField alloc]initWithFrame:CGRectMake(160, fCurrHeight, 60, 30)]autorelease];
        [tf_mailday setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tf_mailday setTextAlignment:NSTextAlignmentCenter];
        [tf_mailday setKeyboardType:UIKeyboardTypeNumberPad];
        [tf_mailday setDelegate:self];
        [tf_mailday setAccDelegate:self];
        [tf_mailday setFont:[UIFont systemFontOfSize:15]];
        [tf_mailday setTag:++nTextFieldTag];
        [tf_mailday setEnabled:NO];
        self.dayGoalNotic = tf_mailday;
        [self.contentScrollView addSubview:tf_mailday];
        
        UILabel *lblTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(220, fCurrHeight, 90, 30)]autorelease];
        [lblTitle2 setBackgroundColor:[UIColor clearColor]];
        [lblTitle2 setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
        lblTitle2.textAlignment = UITextAlignmentLeft;
        [lblTitle2 setTextColor:RGB(74, 74, 74)];
        [lblTitle2 setNumberOfLines:0];
        [lblTitle2 setText:@"일"];
        [self.contentScrollView addSubview:lblTitle2];
        
        
		fCurrHeight += 40;
	}
    
    
	{	// 출금계좌번호
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 90, 40)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:kLeftTitleFontSize]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:2];
		[lblTitle setText:@"원화출금\n계좌번호"];
		[self.contentScrollView addSubview:lblTitle];
		
		
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
		[lblTitle setText:@"출금계좌\n비밀번호"];
        [lblTitle setNumberOfLines:2];
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
			if ([dic[@"구분"]hasPrefix:@"[스마트레터"])
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
			else if ([dic[@"구분"]hasPrefix:@"[SBANK"])
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
        
		for (int nIdx = 0; nIdx < 2; nIdx++) {
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
                b_tfEmployee= NO;
                
			}
			else if (nIdx == 1) {
				[btnRadio setDataKey:@"선택안함"];
				
				UILabel *lblRadio1 = [[[UILabel alloc]init]autorelease];
				[lblRadio1 setFrame:CGRectMake(left(btnRadio)+21+5, 0, 275, 40)];
				[lblRadio1 setBackgroundColor:[UIColor clearColor]];
				[lblRadio1 setTextColor:RGB(74, 74, 74)];
				[lblRadio1 setFont:[UIFont systemFontOfSize:15]];
				[lblRadio1 setText:@"선택안함"];
				[rowView addSubview:lblRadio1];
				
                if ([self.marrStaffRadioBtns count] <= 2) {
                    [btnRadio setSelected:YES];
                }
			}
			
			fCurrHeight += 40;
		}
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
	[self.tfAmount resignFirstResponder];
	[self.tfEmployee resignFirstResponder];
	[self.tfNewPWConfirm resignFirstResponder];
    
}


#pragma mark - Ask Staff and Search Zipcode
- (void)viewControllerDidSelectDataWithDic:(NSMutableDictionary *)mDic{
	[super viewControllerDidSelectDataWithDic:mDic];
	
	if (mDic){
		if ([[mDic objectForKey:@"행번"]length]) {
			[self.tfEmployee setText:[mDic objectForKey:@"행번"]];
		}
        
	}
}

#pragma mark - Action
// 신규적립 타입
- (void)typeRadioBtnAction:(UIButton *)sender
{
	for (UIButton *btn in self.marrMoneyTypeRadioBtns)
	{
		
        [btn setSelected:NO];
        
        if([sender.dataKey isEqualToString:@"골드(그램)"])
        {
            [titleType setText:@"그램"];
            [tf_gram setEnabled:YES];
            [tf_money setEnabled:YES];
            [tf_money setPlaceholder:@"0"];
            [zeroChkbtn setSelected:NO];
            b_MoneyType = NO;
        }
        
        else if([sender.dataKey isEqualToString:@"원화금액"])
        {
            [titleType setText:@"원"];
            [tf_gram setEnabled:NO];
            [tf_gram setText:@"0"];
            b_MoneyType = YES;
        }
	}
	[sender setSelected:YES];
	
}

- (void)zeroCheck:(id)sender
{
    NSLog(@"클릭");

    [sender setSelected:![sender isSelected]];

    if ([sender isSelected])
    {
        b_zero = YES;
        [titleType setText:@"원"];
        [tf_gram setEnabled:NO];
        [tf_money setText:@"0"];
        [tf_gram setText:@"0"];
        [tf_money setEnabled:NO];
        [self typeRadioBtnAction:self.marrMoneyTypeRadioBtns[1]];
       
    }
    
    else{
         b_zero = NO;
        [self typeRadioBtnAction:self.marrMoneyTypeRadioBtns[0]];
        [titleType setText:@"그램"];
        [tf_gram setEnabled:YES];
        [tf_money setEnabled:YES];
        [tf_money setPlaceholder:@""];
        
        
    }
   
   
}

- (void)noticCheck:(id)sender     // 수익률 미선택
{
    NSLog(@"클릭");

    [sender setSelected:![sender isSelected]];
    
    if ([sender isSelected]) {
        b_notice = YES;
        
        [btnNoticeRadio1 setEnabled:NO];
        [tf_goal1 setEnabled:NO];
        [tf_ganger1 setEnabled:NO];
        
        [btnNoticeRadio2 setEnabled:NO];
        [tf_goal2 setEnabled:NO];
        [tf_ganger2 setEnabled:NO];
        
        [self.tfgoal1 setText:@""];
        [self.tfganger1 setText:@""];
        [self.tfgoal2 setText:@""];
        [self.tfganger2 setText:@""];
    }
    else{
      
        b_notice = NO;
        
        [self noticeRadioBtnAction:self.marrNoticTypeRadioBtns[0]];
        [btnNoticeRadio1 setEnabled:YES];   // 가격
        [tf_goal1 setEnabled:YES];
        [tf_ganger1 setEnabled:YES];
        
        [btnNoticeRadio2 setEnabled:YES];
        [tf_goal2 setEnabled:NO];
        [tf_ganger2 setEnabled:NO];
        
        [self.tfgoal1 setText:@""];
        [self.tfganger1 setText:@""];
        [self.tfgoal2 setText:@""];
        [self.tfganger2 setText:@""];

    }
    
    
}


//수익률통지 타입
- (void)noticeRadioBtnAction:(UIButton *)sender
{
	for (UIButton *btn in self.marrNoticTypeRadioBtns)
	{
		
        [btn setSelected:NO];
 
        if ([sender.dataKey isEqualToString:@"수익률 기준 통지"])
        {
           
            [tf_goal1 setEnabled:YES];
            [tf_ganger1 setEnabled:YES];
            
            [tf_goal2 setEnabled:NO];
            [tf_ganger2 setEnabled:NO];
            
            
            [self.tfgoal2 setText:@""];
            [self.tfganger2 setText:@""];
            
            
            type = 3;
        }
        
        else if ([sender.dataKey isEqualToString:@"가격 기준 통지"])
        {
         
            
            [tf_goal1 setEnabled:NO];
            [tf_ganger1 setEnabled:NO];
            
            
            [tf_goal2 setEnabled:YES];
            [tf_ganger2 setEnabled:YES];
            
            
            [self.tfgoal1 setText:@""];
            [self.tfganger1 setText:@""];
            
            type = 4;
        }
	}
	
	[sender setSelected:YES];
}


//email 타입
- (void)emailRadioBtnAction:(UIButton *)sender
{
	for (UIButton *btn in self.marrEmailTypeRadioBtns)
	{
		
        [btn setSelected:NO];
        
        
        if ([sender.dataKey isEqualToString:@"미통보"])
        {
            b_mail = NO;
            [lblmail setText:@""];
            [self.dayGoalNotic setText:@""];
            [tf_mailday setEnabled:NO];
           
        }
        
        else if ([sender.dataKey isEqualToString:@"E-mail"])
        {
            
            [tf_mailday setEnabled:YES];
            
            if (strEmail == nil || [strEmail isEqualToString:@""])
            {
                b_mail = NO;
                [lblmail setText:@"고객정보변경에서 메일 주소를 등록해주세요"];
                [tf_mailday setEnabled:NO];
            }
                 
            else
            {
                b_mail = YES;
                [lblmail setText:[NSString stringWithFormat:@"E-mail: %@",strEmail]];
            }
            
            
        }
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



- (void)couponBtnAction:(SHBButton *)sender
{
	self.service = [[[SHBProductService alloc]initWithServiceId:kE4903Id viewController:self]autorelease];
	[self.service start];
}





- (IBAction)confirmBtnAction:(UIButton *)sender {
    
   //self.userItem = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];

    
    if (b_MoneyType == NO) { // 골드
         if(self.tfAmount.text == nil && self.tfAmount_gram.text == nil)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"‘입금량’의 입력값이 유효하지 않습니다."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        
        if([self.tfAmount.text length] == 0)self.tfAmount.text = @"0";
        if([self.tfAmount_gram.text length] == 0) self.tfAmount_gram.text = @"0";
        if([self.tfAmount.text isEqualToString:@"0"] && [self.tfAmount_gram.text isEqualToString:@"0"])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"골드적립은 최소 0.01g부터 가능합니다."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
            
        }
        
        
        if([self.tfAmount.text isEqualToString:@"0"] && [self.tfAmount_gram.text isEqualToString:@"00"])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"골드적립은 최소 0.01g부터 가능합니다."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
            
        }
    }
    
    else {   // 원화
        
        if ([self.tfAmount.text length] == 0)
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"‘신규적립량’의 입력값이 유효하지 않습니다."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
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
        _tmpA = @"";
        _tmpB = @"";
		return;
	}
	
    
	if (([self.tfNewPW.text length] && [self.tfNewPWConfirm.text length] && ![_tmpA isEqualToString:_tmpB]) ) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"신규계좌 비밀번호와 비밀번호확인이 일치하지 않습니다."
													   delegate:nil
											  cancelButtonTitle:@"확인"
											  otherButtonTitles:nil];
		[alert show];
        self.tfNewPW.text = nil;
        self.tfNewPWConfirm.text = nil;
        _tmpA = @"";
        _tmpB = @"";
		[alert release];
		return;
		
	}
    
    if (b_notice == NO)   // 수익률 선택일때
    {
        if (type == 3) {
            if (self.tfgoal1.text == nil || [self.tfgoal1.text isEqualToString:@""])
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"목표수익률을 입력해 주시기 바립니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
            if (self.tfganger1.text == nil || [self.tfganger1.text isEqualToString:@""])
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"위험수익률을 입력해 주시기 바립니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
                
            }
        }
        
        if (type == 4)
        {
            if (self.tfgoal2.text == nil || [self.tfgoal2.text isEqualToString:@""])
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"목표가격을 입력해 주시기 바립니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
                
            }
            if (self.tfganger2.text == nil || [self.tfganger2.text isEqualToString:@""])
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"위험가격을 입력해 주시기 바립니다."
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
                
            }
            
        }
    }
	
   
    
    
    if (self.dayGoal.text != nil || ![self.dayGoal.text isEqualToString:@""])
    {
       if ([self.dayGoal.text isEqualToString:@"0"]  ||  [self.dayGoal.text integerValue] > 30 )
       {   // 30일 체크 알럿
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                           message:@"정기수익률일자는 1일~30일까지 입력가능합니다."
                                                          delegate:nil
                                                 cancelButtonTitle:@"확인"
                                                 otherButtonTitles:nil];
           [alert show];
           [alert release];
           return;
       }

    
    }
	if (b_mail == YES ) {
        
        if (self.dayGoalNotic.text == nil || [self.dayGoalNotic.text isEqualToString:@""]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"정기잔고 통보일을 입력해 주시기 바랍니다."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
 
       if ([self.dayGoalNotic.text isEqualToString:@"0"]  ||  [self.dayGoalNotic.text integerValue] > 30 )
       {   // 30일 체크 알럿
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                           message:@"정기잔고 통보일은 1일~30일까지 입력가능합니다."
                                                          delegate:nil
                                                 cancelButtonTitle:@"확인"
                                                 otherButtonTitles:nil];
           [alert show];
           [alert release];
           return;
       }
	}

    
    if (![self.sbOldAccountNum.text length]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:@"원화출금계좌번호를 입력해 주십시오."
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
    
	
    
    if ([self.dayGoal.text isEqualToString:@""] || self.dayGoal.text == nil)
    {
        [self.userItem setObject:@"0" forKey:@"정기수익률"];
    }
    else
    {
        [self.userItem setObject:[NSString stringWithFormat:@"%@",self.dayGoal.text] forKey:@"정기수익률"];
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
	
	
    
	Debug(@"신계좌 : %@", [self.selectedAccount objectForKey:@"출금계좌번호"]);
	Debug(@"계좌 : %@", [self.selectedAccount objectForKey:@"2"]);
    
    
    [self.userItem setObject:[self.dicSelectedData objectForKey:@"상품명"] forKey:@"상품명"];
	[self.userItem setObject:self.strEncryptedNewPW forKey:@"신규계좌비밀번호"];
    
    
    
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
    
    self.service = [[[SHBProductService alloc]initWithServiceId:kD3603Id viewController:self]autorelease];
	self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
                                                                      @"비밀번호최대자리수" : @"4",
                                                                      @"고객번호" : AppInfo.customerNo,
                                                                      @"비밀번호" : self.strEncryptedNewPW,
                                                                      }];
	[self.service start];
    
}

- (IBAction)cancelBtnAction:(UIButton *)sender {

    for (SHB_GoldTech_ManualInfoViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHB_GoldTech_ManualInfoViewController class]]) {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
			[self.navigationController fadePopToViewController:viewController];
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
		if (dataLength + dataLength2 > 11)
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
	
	if (textField == self.tfAmount_gram) {	// 그램
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 2)
        {
			return NO;
		}
//		else
//        {
//			if ([string isEqualToString:[NSString stringWithFormat:@"%d", [string intValue]]])
//            {
//                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""], string]];
//				return NO;
//			}
//            else
//            {
//				int nLen = [textField.text length];
//				NSString *strStr = [textField.text substringToIndex:nLen - 1];
//				textField.text = strStr;
//                
//                textField.text = [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%@", [textField.text stringByReplacingOccurrencesOfString:@"," withString:@""]]];
//				return NO;
//			}
//		}
		
	}
    
    
    if (textField == self.tfgoal1 || textField == self.tfganger1) {	//목표수익률
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0 )
        {
			return NO;
		}
		if (dataLength + dataLength2 > 3)
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
    
    
    if (textField == self.tfgoal2 || textField == self.tfganger2) {	// 목표가격
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0)
        {
			return NO;
		}
		if (dataLength + dataLength2 > 10)
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
    
    
    
    if (textField == self.dayGoal || textField == self.dayGoalNotic) {	// 정기수익률 일자
		// 숫자이외에는 입력안되게 체크
		NSString *NUMBER_SET = @"0123456789";
		
		NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_SET] invertedSet];
		NSString *filtered = [[string componentsSeparatedByCharactersInSet: cs] componentsJoinedByString:@""];
		BOOL basicTest = [string isEqualToString:filtered];
		
		if (!basicTest && [string length] > 0)
        {
			return NO;
		}
		if (dataLength + dataLength2 > 2)
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
    
    
    else if (textField == self.tfEmployee)  //권유직원번호
    {
        textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if ([textField.text length] >= 8 && range.length == 0) {
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
	if ([AppInfo.serviceCode isEqualToString:@"D0011"])
    {
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
        

        
        self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7301" viewController:self] autorelease];
        SHBDataSet *dataSet = [[[SHBDataSet alloc] initWithDictionary:@{
                                                                             @"고객번호" : AppInfo.customerNo,
                                                                             @"거래구분" : @"4", //고정
                                                                             @"외화거주구분" : @"4",   //고정
                                                                             @"투자목적" : @"0",   //고정
                                                                             @"통화코드" : @"XAU",   //고정
                                                                             @"상품코드" : [self.dicSelectedData objectForKey:@"상품코드"],
                                                                             @"환율적용구분" : @"1",   //고정
                                                                             @"우대" : @"0",
                                                                             @"약정월수" : @"",
                                                                             @"신규계좌비밀번호" : self.strEncryptedNewPW,
                                                                             @"원화출금계좌번호" : [self.selectedAccount objectForKey:@"출금계좌번호"],
                                                                             @"원화출금계좌비밀번호" : self.strEncryptedOldPW,
                                                                             @"원화출금계좌은행구분" : @"1",
                                                                             @"자동이체시작일" : @"",
                                                                             @"자동이체종료일" : @"",
                                                                             @"자동이체적립구분" : @"",
                                                                             @"자동이체적립주기" : @"",
                                                                             @"자동이체적립요일" : @"",
                                                                             @"자동이체최고환율" : @"",
                                                                             @"자동이체최저환율" : @"",
                                                                             @"자동이체적립배수" : @"",
                                                                             @"거래점용은행구분" : @"1",
                                                                             @"거래점용계좌번호" : [self.selectedAccount objectForKey:@"출금계좌번호"],
                                                                             @"초과등급여부" : [self.dicSelectedData objectForKey:@"_초과등급여부"],
                                                                             }] autorelease];
        
        
        
        // 신규금액 적립량에 따라 분기
        
        
        
        if (b_MoneyType ==  NO) {  //골드
            [dataSet insertObject:[NSString stringWithFormat:@"%@.%@" ,self.tfAmount.text ,self.tfAmount_gram.text] forKey:@"적립량" atIndex:0];  //
            [dataSet insertObject:@"" forKey:@"원화합계금액" atIndex:0];  //
            [self.userItem setObject:[NSString stringWithFormat:@"%@.%@" ,self.tfAmount.text ,self.tfAmount_gram.text] forKey:@"신규금액" ];

        }
        else
        {
            [dataSet insertObject:self.tfAmount.text forKey:@"적립량" atIndex:0];  //
            [dataSet insertObject:self.tfAmount.text forKey:@"원화합계금액" atIndex:0];  //
            [self.userItem setObject:self.tfAmount.text forKey:@"신규금액" ];

        }
        
        // 수익률 미선택시
        
        if (b_notice == YES)  // 가격통지
        {
            
            [self.userItem setObject:@"미신청" forKey:@"목표수익률통지"];
            [self.userItem setObject:@"미신청" forKey:@"위험수익률통지"];

        }
        else
        {
            
            if (type == 3) {  //수익률
                [dataSet insertObject:self.tfgoal1.text forKey:@"목표수익률" atIndex:0];  //
                [dataSet insertObject:self.tfganger1.text forKey:@"위험수익률" atIndex:0];  //
                [dataSet insertObject:@"" forKey:@"목표가격" atIndex:0];  //
                [dataSet insertObject:@"" forKey:@"위험가격" atIndex:0];  //
                
                [self.userItem setObject:self.tfgoal1.text forKey:@"목표수익률" ];
                [self.userItem setObject:self.tfganger1.text forKey:@"위험수익률" ];
                [self.userItem setObject:@"" forKey:@"목표가격" ];
                [self.userItem setObject:@"" forKey:@"위험가격" ];
            }
            else if(type == 4)
            {
                [dataSet insertObject:@"" forKey:@"목표수익률" atIndex:0];  //
                [dataSet insertObject:@"" forKey:@"위험수익률" atIndex:0];  //
                [dataSet insertObject:self.tfgoal2.text forKey:@"목표가격" atIndex:0];  //
                [dataSet insertObject:self.tfganger2.text forKey:@"위험가격" atIndex:0];  //
                
                [self.userItem setObject:@"" forKey:@"목표수익률" ];
                [self.userItem setObject:@"" forKey:@"위험수익률" ];
                [self.userItem setObject:self.tfgoal2.text forKey:@"목표가격" ];
                [self.userItem setObject:self.tfganger2.text forKey:@"위험가격" ];
            }

        }

        
        if (b_mail == YES) {  //email 선택
			[dataSet insertObject:@"3" forKey:@"정기잔고통보" atIndex:0];  //
            [dataSet insertObject:self.dayGoalNotic.text forKey:@"정기잔고통보일" atIndex:0];  //
            [self.userItem setObject:@"e-mail" forKey:@"정기잔고통보"];
            [self.userItem setObject:self.dayGoalNotic.text forKey:@"정기잔고통보일"];
		}
        else  //미통보
        {
            [dataSet insertObject:@"0" forKey:@"정기잔고통보" atIndex:0];  //
            [dataSet insertObject:@"00" forKey:@"정기잔고통보일" atIndex:0];  //
            [self.userItem setObject:@"" forKey:@"정기잔고통보"];
            [self.userItem setObject:@"" forKey:@"정기잔고통보일"];
        }
        

        self.service.requestData = dataSet;
        [self.service start];

        
        
        
    }
    
	else if ([AppInfo.serviceCode isEqualToString:@"D2004"])
	{
		NSString *strBalance = [aDataSet objectForKey:@"지불가능잔액"];
		UILabel *lblBalance = (UILabel *)[self.contentScrollView viewWithTag:kTagLabelBalance];
		[lblBalance setText:[NSString stringWithFormat:@"출금가능잔액 %@원", strBalance]];
		
	}
#endif
    
    
  	else if ([AppInfo.serviceCode isEqualToString:@"D7301"])
	{
		[self.tfNewPW setText:nil];
		[self.tfNewPWConfirm setText:nil];
		[self.tfOldAccountPW setText:nil];
        
        
        NSLog(@"신규적립량 %@",[aDataSet objectForKey:@"신규적립량"]);
        
        
        [self.userItem setObject:[NSString stringWithFormat:@"골드테크가입"] forKey:@"골드테크가입"];
        [self.userItem setObject:[aDataSet objectForKey:@"통화코드"] forKey:@"통화코드"];
        [self.userItem setObject:[aDataSet objectForKey:@"신규적립량"] forKey:@"신규적립량"];
        [self.userItem setObject:[aDataSet objectForKey:@"포지션"] forKey:@"포지션"];
        [self.userItem setObject:[aDataSet objectForKey:@"원화합계"] forKey:@"원화합계"];
        [self.userItem setObject:[aDataSet objectForKey:@"약정월수"] forKey:@"약정월수"];
        [self.userItem setObject:[aDataSet objectForKey:@"적용환율"] forKey:@"적용환율"];
        [self.userItem setObject:[aDataSet objectForKey:@"원화출금계좌번호"] forKey:@"원화출금계좌번호"];
        
        
        SHBELD_BA17_14_SignUpViewController *viewController = [[SHBELD_BA17_14_SignUpViewController alloc]initWithNibName:@"SHBELD_BA17_14_SignUpViewController" bundle:nil];
        viewController.dicSelectedData = self.dicSelectedData;
        viewController.userItem = self.userItem;
        viewController.needsLogin = YES;
        viewController.stepNumber = @"예금적금 가입 3단계";
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
        
        

        
        
	}
   	
	else if ([AppInfo.serviceCode isEqualToString:@"F1405"])
	{
        for(NSDictionary *dic in [aDataSet arrayWithForKey:@"조회내역"])
        {
            if([dic[@"통화CODE"] isEqualToString:@"XAU"])
            {
                strRate = dic[@"전신환매도우대환율"];
            }
        }
        
        
        self.service = nil;
        self.service = [[[SHBCustomerService alloc] initWithServiceCode:CUSTOMER_C2310
                                                         viewController:self] autorelease];
        [self.service start];

	}
    
    else if ([self.service.strServiceCode isEqualToString:CUSTOMER_C2310]) {
        
        strEmail = [aDataSet objectForKey:@"이메일"];
        
        [self setUI];
    }

    
	
	return NO;
}

@end


