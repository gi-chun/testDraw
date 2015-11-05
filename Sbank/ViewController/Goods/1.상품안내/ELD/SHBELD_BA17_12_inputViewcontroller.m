//
//  SHBELD_BA17_12_inputViewcontroller.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 5. 30..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
typedef enum
{
	ListPopupViewTagAccounts = 400,
	ListPopupViewTagCoupons,
}ListPopupViewTag;
#import "SHBELD_BA17_12_inputViewcontroller.h"
#import "SHBELD_BA17_13_TaxBreakViewController.h"
#import "SHBELD_BA17_11ViewController.h"
#import "SHBUtility.h"
#import "SHBAskStaffViewController.h"
#import "SHBProductService.h"
#import "SHBNewProductRegTopView.h"
#import "SHBAccountService.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBUtility.h"

#define kLeftTitleFontSize		15

#define kTagLabelBalance		11


@interface SHBELD_BA17_12_inputViewcontroller ()
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



@implementation SHBELD_BA17_12_inputViewcontroller

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
	[_mdicPushInfo release];

	[_marrCoupons release];

	[_strEncryptedNewPW release];
	[_strEncryptedNewPWConfirm release];
	[_strEncryptedOldPW release];
	[_userItem release];

	[_selectedAccount release];
	[_marrAccounts release];

	[_sbOldAccountNum release];
	[_tfOldAccountPW release];
	[_tfAccountName release];
	[_tfAmount release];
	[_tfEmployee release];
	[_tfNewPW release];
	[_tfNewPWConfirm release];
	[_dicSelectedData release];
	[_bottomView release];
  	[super dealloc];
}

- (void)viewDidUnload {


	self.sbOldAccountNum = nil;
	self.tfOldAccountPW = nil;
	self.tfAccountName = nil;
	self.tfAmount = nil;
	self.tfEmployee = nil;
	self.tfNewPW = nil;
	self.tfNewPWConfirm = nil;
	[self setBottomView:nil];
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
    
    [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[self.dicSelectedData objectForKey:@"상품한글명"] maxStep:5 focusStepNumber:2]autorelease]];
    
    // 스마트신규에서 넘어온 경우에는 전문타지 않음 (그 외에는 권유직원번호가 없어도 무조건 전문 날림)
    if (self.mdicPushInfo[@"_스마트신규금액"]) {
        
        self.marrRecStaffs = [NSMutableArray arrayWithArray:@[ @{ @"그룹사코드" : @"",
                                                                  @"구분" : @"",
                                                                  @"점번호" : [SHBUtility nilToString:self.mdicPushInfo[@"_등록지점"]],
                                                                  @"한글점명" : [SHBUtility nilToString:self.mdicPushInfo[@"_등록지점명"]],
                                                                  @"직원명" : [SHBUtility nilToString:self.mdicPushInfo[@"_등록직원명"]],
                                                                  @"행원번호" : [SHBUtility nilToString:self.mdicPushInfo[@"_등록직원"]], } ]];
		
        [self setUI];
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
- (void)setUI
{
	fCurrHeight = 0;
	
		// 적립방식, 계약기간
	CGFloat height = 34*3;
	
		
	SHBNewProductRegTopView *topView = [[[SHBNewProductRegTopView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 320, height) parentViewController:self]autorelease];
	[self.contentScrollView addSubview:topView];
	fCurrHeight += 10 + height;
	
	
	// 신규금액, 신규계좌비밀번호, 비밀번호확인, 예금별명, 권유직원번호
    
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
			[tf setFont:[UIFont systemFontOfSize:15]];
			[tf setTag:++nTextFieldTag];
            
            if (self.mdicPushInfo[@"_스마트신규금액"]) {
                
                [tf setText:[SHBUtility normalStringTocommaString:self.mdicPushInfo[@"_스마트신규금액"]]];
            }
            
			[rowView addSubview:tf];
			self.tfAmount = tf;
			
			NSString *strPlaceHolder = nil;
            strPlaceHolder = [NSString stringWithFormat:@"%@원 이상", [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"거치최소금액"]]]];
				valAmount = 1;
			
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
        
        
        
		fCurrHeight += 40;
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
                
                if (self.mdicPushInfo[@"_스마트신규금액"]) {
                    
                    // 스마트신규인 경우 권유직원을 직접 세팅
                    
                    [btnRadio setSelected:YES];
                    [tf setEnabled:YES];
                    [btn setEnabled:YES];
                    [tf setText:self.mdicPushInfo[@"_등록직원"]];
                    b_tfEmployee = YES;
                }
                else
                {
                    b_tfEmployee= NO;
                }
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
				
				if ([self.marrStaffRadioBtns count] <= 2 && !self.mdicPushInfo[@"_스마트신규금액"]) {
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
	[self.tfAccountName resignFirstResponder];
	[self.tfAmount resignFirstResponder];
	[self.tfEmployee resignFirstResponder];
	[self.tfNewPWConfirm resignFirstResponder];

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
// 적립방식 선택 : 정기적립식, 자유적립식

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

	
    
	if(valAmount == 1){
		if ([[[self.dicSelectedData objectForKey:@"거치최소금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] > [[self.tfAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:[NSString stringWithFormat:@"신규금액은 %@원 이상입니다.",
																	 [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"거치최소금액"]]]]
														   delegate:nil
												  cancelButtonTitle:@"확인"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		
		if ([[self.tfAmount.text stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] % [[self.dicSelectedData objectForKey:@"거치단위금액"] longLongValue] != 0 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
															message:[NSString stringWithFormat:@"신규금액은 %@원 단위로 입력해 주십시오.",
																	 [SHBUtility changeNumberStringToKoreaAmountString:[SHBUtility normalStringTocommaString:[self.dicSelectedData objectForKey:@"거치단위금액"] ]] ]
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
    
    
		
    
    if (self.tfAccountName.text != nil && [self.tfAccountName.text length] != 0) {
		[self.userItem setObject:self.tfAccountName.text forKey:@"예금별명"];
	}
	else {
		[self.userItem setObject:@"" forKey:@"예금별명"];
    }
    
        
	[self.userItem setObject:[self.dicSelectedData objectForKey:@"상품한글명"] forKey:@"상품한글명"];
	[self.userItem setObject:self.tfAmount.text forKey:@"신규금액" ];
	[self.userItem setObject:self.strEncryptedNewPW forKey:@"신규계좌비밀번호"];
    
      
    
    
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
   
    for (SHBELD_BA17_11ViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBELD_BA17_11ViewController class]]) {
            if ([viewController respondsToSelector:@selector(reset)]) {
                [viewController reset];
            }
            
			[self.navigationController popToViewController:viewController animated:YES];
		}
	}
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
        
        self.service = [[[SHBProductService alloc]initWithServiceId:kC2090Id viewController:self]autorelease];
        self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
                                    @"은행구분" : [self.selectedAccount objectForKey:@"은행코드"],	// 3 = 은행코드
                                    @"출금계좌번호" : [self.selectedAccount objectForKey:@"출금계좌번호"]/*self.sbOldAccountNum.text*/,
                                    @"출금계좌비밀번호" : self.strEncryptedOldPW/*self.tfOldAccountPW.text*/,
                                    @"납부금액" : self.tfAmount.text,
                                    }];
        [self.service start];
    }
    
	else if ([AppInfo.serviceCode isEqualToString:@"D2004"])
	{
		NSString *strBalance = [aDataSet objectForKey:@"지불가능잔액"];
		UILabel *lblBalance = (UILabel *)[self.contentScrollView viewWithTag:kTagLabelBalance];
		[lblBalance setText:[NSString stringWithFormat:@"출금가능잔액 %@원", strBalance]];
		
	}
#endif
    
    
  	else if (self.service.serviceId == kC2090Id)
	{
		[self.tfNewPW setText:nil];
		[self.tfNewPWConfirm setText:nil];
		[self.tfOldAccountPW setText:nil];
        
        SHBBaseViewController *viewController;
        NSString *strClassName = @"SHBELD_BA17_13_TaxBreakViewController";
        
      	viewController = [[NSClassFromString(strClassName) alloc] initWithNibName:strClassName bundle:nil];	
        // warning 피하기 위해 casting
		((SHBELD_BA17_13_TaxBreakViewController*)viewController).dicSelectedData = self.dicSelectedData;
		((SHBELD_BA17_13_TaxBreakViewController*)viewController).mdicPushInfo = self.mdicPushInfo;
		((SHBELD_BA17_13_TaxBreakViewController*)viewController).userItem = self.userItem;
        
		viewController.needsLogin = YES;
        
        NSLog(@"예금적금 단계 %@",self.stepNumber);
      
        ((SHBELD_BA17_13_TaxBreakViewController*)viewController).stepNumber = @"예금적금 가입 3단계";
        [self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
        
                
	}
	else if (self.service.serviceId == XDA_SelectEmpInfo)
	{
		Debug(@"aDataSet : %@", aDataSet);
		
		self.marrRecStaffs = [aDataSet arrayWithForKeyPath:@"data"];
		
        [self setUI];
        
	}
	
	return NO;
}

@end

