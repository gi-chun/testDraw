//
//  SHBUdreamSecurityViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//
#define kTagLabelBalance		11

#import "SHBUdreamSecurityViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"
#import "SHBAccountService.h"
#import "SHBUDreamEndViewController.h"
#import "SHBUDreamInfoViewController.h"

@interface SHBUdreamSecurityViewController ()
{
	CGFloat fCurrHeight;
	SHBTextField *currentTextField;
}

@property (nonatomic, retain) NSMutableArray *marrAccounts;		// U드림 전환대상 계좌 리스트
@property (nonatomic, retain) NSMutableDictionary *selectedAccount;	// 선택된 출금계좌

@end

@implementation SHBUdreamSecurityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_selectedAccount release];
//	[_tfOutAccount release];
	[_marrAccounts release];
	[_userItem release];
	[_bottomView release];
	[super dealloc];
}
- (void)viewDidUnload {
//	self.tfOutAccount = nil;
	[self setBottomView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"U드림 저축예금 전환"];
    self.strBackButtonTitle = @"U드림 저축예금 전환 2단계";
    
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"전환 신청" maxStep:3 focusStepNumber:2]autorelease]];
	
#if 0	// 셀렉트 박스 선택할때마다 전문 가져오는 거로 바뀜
	
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"고객번호" : AppInfo.customerNo,
						   //@"실명번호" : AppInfo.ssn,
                           //@"실명번호" : [AppInfo getPersonalPK],
                           @"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
						   @"거래구분" : @"9",
						   @"해지거래구분" : @"0",
						   @"보안계좌조회구분" : @"2",
						   @"인터넷조회제한여부" : @"1",
						   }];
	
	self.service = [[[SHBProductService alloc]initWithServiceId:kE2650Id viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
#endif
	fCurrHeight = 0;
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[self.contentScrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 5;
	NSMutableArray *marrGuides = [NSMutableArray array];
	[marrGuides addObject:@"U드림 예금거래 서비스로 전환하신 후에는 기존 통장으로는 거래할 수 없습니다.\n영업점 창구를 이용시에는 소정의 청구거래 수수료를 납부하셔야 합니다."];
	[marrGuides addObject:@"U드림 예금거래서비스로 전환 후 일반통장으로 재전환은 영업점에서만 가능합니다.\nU드림 예금거래 서비스로 전환하실 계좌를 선택한 후 '전환 신청' 버튼을 선택하세요."];
	
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
	
//	NSString *strGuide = @"U드림 예금거래 서비스로 전환하신 후에는 기존 통장으로는 거래할 수 없습니다.\n영업점 창구를 이용시에는 소정의 청구거래 수수료를 납부하셔야 합니다.\n\nU드림 예금거래서비스로 전환 후 일반통장으로 재전환은 영업점에서만 가능합니다.\nU드림 예금거래 서비스로 전환하실 계좌를 선택한 후 '전환 신청' 버튼을 클릭하세요.";
//	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(294, 999) lineBreakMode:NSLineBreakByWordWrapping];
//	
//	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5, fHeight, 294, size.height)]autorelease];
//	[lblGuide setNumberOfLines:0];
//	[lblGuide setBackgroundColor:[UIColor clearColor]];
//	[lblGuide setTextColor:RGB(114, 114, 114)];
//	[lblGuide setFont:[UIFont systemFontOfSize:12]];
//	[lblGuide setText:strGuide];
//	[ivInfoBox addSubview:lblGuide];
//	
//	fHeight += size.height + 10;
//	
//	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight, 311, fHeight)];
//	fCurrHeight += fHeight;
	
//	fCurrHeight += 10;
	{	// 출금계좌번호
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 30)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:15]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setNumberOfLines:0];
		[lblTitle setText:@"U드림 저축예금 전환 계좌번호"];
		[self.contentScrollView addSubview:lblTitle];
		
		SHBSelectBox *sb = [[[SHBSelectBox alloc]initWithFrame:CGRectMake(8/*+88+3*/, fCurrHeight+=30, 301, 30)]autorelease];
		[sb setDelegate:self];
		[sb setText:@"선택해주세요"];
		[self.contentScrollView addSubview:sb];
		self.sbOutAccount = sb;
		
		
		fCurrHeight += 30;
		
//		SHBTextField *tf = [[[SHBTextField alloc]initWithFrame:CGRectMake(8+96+3, fCurrHeight, 202, 30)]autorelease];
//		[tf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
//		[tf setDelegate:self];
//		[tf setAccDelegate:self];
//		[tf setPlaceholder:@"계좌를 선택해주세요."];
//		[tf setFont:[UIFont systemFontOfSize:14]];
//		[self.contentScrollView addSubview:tf];
//		self.tfOutAccount = tf;
//		
//		fCurrHeight += 36;
	}
	
//	{	// 잔액조회
//		UILabel *lblBalance = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 320-90-8, 25)]autorelease];
//		[lblBalance setBackgroundColor:[UIColor clearColor]];
//		[lblBalance setFont:[UIFont systemFontOfSize:13]];
//		[lblBalance setTextColor:RGB(74, 74, 74)];
//		[lblBalance setTextAlignment:NSTextAlignmentRight];
//		[lblBalance setTag:kTagLabelBalance];
//		//		[lblBalance setText:@"출금가능잔액 1,000,000,000원"];
//		[self.contentScrollView addSubview:lblBalance];
//		
//		SHBButton *btn = [SHBButton buttonWithType:UIButtonTypeCustom];
//		[btn setFrame:CGRectMake(8+76+3+138+12, fCurrHeight, 73, 25)];
//		[btn setBackgroundImage:[UIImage imageNamed:@"btn_balancewithdraw.png"] forState:UIControlStateNormal];
//		[btn setBackgroundImage:[UIImage imageNamed:@"btn_balancewithdraw_focus.png"] forState:UIControlStateHighlighted];
//		[btn addTarget:self action:@selector(inquiryBalanceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//		[self.contentScrollView addSubview:btn];
//		
//		fCurrHeight += 35;
//	}
	
	[self setSecretMediaView];
	
//	FrameReposition(self.bottomView, left(self.bottomView), fCurrHeight);
	[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fCurrHeight += 29+12)];
	
	// 전자서명 Noti
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
	
    
//    //서버에러일때
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"UdreamCancel" object:nil];
    
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
		fCurrHeight += 185/*vc.view.bounds.size.height*/;
        
        /* previousData는 이전 전문 파싱값을 넘겨줄 필요가 있을때 넘겨준다
         연속적으로 이체할때 보안 카드 확인값이 변경되므로 값을 알아야됨 - 아직 미구현
         */
        [vc setMediaCode:secutryType previousData:nil];
        vc.delegate = self;
        vc.nextSVC = @"D5520";
		self.cardViewController = vc;
		[vc.bottomView removeFromSuperview];
		
		[vc.view addSubview:self.bottomView];
		FrameReposition(self.bottomView, 0, 185);
    }
    else if (secutryType == 5)
    {           //OTP
        
        SHBSecretOTPViewController *vc = [[[SHBSecretOTPViewController alloc] init] autorelease];
        vc.targetViewController = self;
        
        [secretMediaView addSubview:vc.view];
        [vc.view setFrame:CGRectMake(0, 0, 317/*self.view.frame.size.width*/, vc.view.bounds.size.height)];
		
		[secretMediaView setFrame:CGRectMake(0, fCurrHeight+=4, 317, vc.view.bounds.size.height)];
		
		vc.selfPosY = fCurrHeight+37;
		fCurrHeight += 86/*vc.view.bounds.size.height*/;
        
        vc.delegate = self;
        vc.nextSVC = @"D5520";
		
		self.otpViewController = vc;
		[vc.bottomView removeFromSuperview];
		
		[vc.view addSubview:self.bottomView];
		FrameReposition(self.bottomView, 0, 86);
    }
}

#pragma mark - Action
- (void)inquiryBalanceBtnAction:(SHBButton *)sender
{
	if ([self.sbOutAccount.text length] && ![self.sbOutAccount.text isEqualToString:@"선택해주세요"]) {
		if (self.selectedAccount) {
			self.service = [[[SHBAccountService alloc] initWithServiceCode:@"D2004" viewController:self]autorelease];
			self.service.requestData = [[[SHBDataSet alloc] initWithDictionary:@{@"출금계좌번호" : [self.selectedAccount objectForKey:@"2"]}] autorelease];
			[self.service start];
		}
	}
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
#if 0
	SHBUDreamEndViewController *viewController = [[SHBUDreamEndViewController alloc]initWithNibName:@"SHBUDreamEndViewController" bundle:nil];
	viewController.needsLogin = YES;
	[self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
#else
	if (![self.sbOutAccount.text length] || [self.sbOutAccount.text isEqualToString:@"선택해주세요"]) {
		[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:@"U드림 저축 예금 계좌를 선택한 후 \"전환신청\" 버튼을 눌러주세요."];
		return;
	}
	
	NSInteger secutryType = [[AppInfo.userInfo objectForKey:@"보안매체정보"]intValue];
    
    if (secutryType == 1 || secutryType == 2 || secutryType == 3 || secutryType == 4)
    {
		[self.cardViewController confirmSecretCardNumber];
    }
    else if (secutryType == 5)
    {
		[self.otpViewController confirmSecretOTPNumber];
    }
#endif
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBUDreamInfoViewController class]]) {
			[self.navigationController popToViewController:viewController animated:YES];
		}
	}
}

#pragma mark - Notification
- (void)getElectronicSignResult:(NSNotification *)noti
{
	Debug(@"[noti userInfo] : %@", [noti userInfo]);
	if (!AppInfo.errorType)
    {
//		self.data = [noti userInfo];
		
//		if ([[self.userItem objectForKey:@"정보동의"]length]) {
//			Debug(@"%@", [self.userItem objectForKey:@"정보동의"]);
//			SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
//								   @"은행구분" : @"1",
//								   @"검색구분" : @"1",
//								   @"고객번호" : AppInfo.customerNo,
//								   @"고객번호1" : AppInfo.customerNo,
//								   @"마케팅활용동의여부" : [self.userItem objectForKey:@"정보동의"],
//								   @"장표출력SKIP여부" : @"1",
//								   }];
//			
//			self.service = [[[SHBProductService alloc]initWithServiceId:kC2316Id viewController:self]autorelease];
//			self.service.requestData = dataSet;
//			[self.service start];
//		}
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        if ([self.userItem objectForKey:@"동의구분"]) {
			SHBDataSet *dataSet = nil;
			if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의구분"] ||
                [[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의안함"]) {
				Debug(@"%@", [self.userItem objectForKey:@"정보동의"]);
				dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"은행구분" : @"1",
						   @"검색구분" : @"1",
						   @"고객번호" : AppInfo.customerNo,
						   @"고객번호1" : AppInfo.customerNo,
						   @"마케팅활용동의여부" : self.userItem[@"정보동의"], // 동의함 1 , 동의안함 2 중 선택된 값
						   @"장표출력SKIP여부" : @"1",
						   @"인터넷수행여부" : @"2",
						   @"필수정보동의여부" : self.userItem[@"필수정보동의여부"],
						   @"선택정보동의여부" : self.userItem[@"선택정보동의여부"],
                           @"자택TM통지요청구분" : self.userItem[@"_자택TM통지요청구분"],
                           @"직장TM통지요청구분" : self.userItem[@"_직장TM통지요청구분"],
                           @"휴대폰통지요청구분" : self.userItem[@"_휴대폰통지요청구분"],
                           @"SMS통지요청구분" : self.userItem[@"_SMS통지요청구분"],
                           @"EMAIL통지요청구분" : self.userItem[@"_EMAIL통지요청구분"],
                           @"DM희망지주소구분" : self.userItem[@"_DM희망지주소구분"],
                           @"DATA존재유무" : @"",
                           @"마케팅활용매체별동의" : @"1",
						   }];
				
				
			}
			else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"필수적정보동의구분"]) {
				dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"은행구분" : @"1",
						   @"검색구분" : @"1",
						   @"고객번호" : AppInfo.customerNo,
						   @"고객번호1" : AppInfo.customerNo,
						   @"마케팅활용동의여부" : self.userItem[@"마케팅활용동의여부"], // c2315에 내려온 값 그대로 셋팅
						   @"장표출력SKIP여부" : @"1",
						   @"인터넷수행여부" : @"2",
						   @"필수정보동의여부" : @"1",
						   @"선택정보동의여부" : self.userItem[@"선택정보동의여부"], // 동의함 1 , 동의안함 2 중 선택된 값
                           @"자택TM통지요청구분" : self.userItem[@"_자택TM통지요청구분"],
                           @"직장TM통지요청구분" : self.userItem[@"_직장TM통지요청구분"],
                           @"휴대폰통지요청구분" : self.userItem[@"_휴대폰통지요청구분"],
                           @"SMS통지요청구분" : self.userItem[@"_SMS통지요청구분"],
                           @"EMAIL통지요청구분" : self.userItem[@"_EMAIL통지요청구분"],
                           @"DM희망지주소구분" : self.userItem[@"_DM희망지주소구분"],
                           @"DATA존재유무" : @"",
                           @"마케팅활용매체별동의" : @"1",
						   }];
			}
			else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅과필수적정보동의구분"]) {
				dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"은행구분" : @"1",
						   @"검색구분" : @"1",
						   @"고객번호" : AppInfo.customerNo,
						   @"고객번호1" : AppInfo.customerNo,
						   @"마케팅활용동의여부" : self.userItem[@"정보동의"],
						   @"장표출력SKIP여부" : @"1",
						   @"인터넷수행여부" : @"2",
						   @"필수정보동의여부" : @"1",
						   @"선택정보동의여부" : self.userItem[@"선택정보동의여부"], // 동의함 1 , 동의안함 2 중 선택된 값
                           @"자택TM통지요청구분" : self.userItem[@"_자택TM통지요청구분"],
                           @"직장TM통지요청구분" : self.userItem[@"_직장TM통지요청구분"],
                           @"휴대폰통지요청구분" : self.userItem[@"_휴대폰통지요청구분"],
                           @"SMS통지요청구분" : self.userItem[@"_SMS통지요청구분"],
                           @"EMAIL통지요청구분" : self.userItem[@"_EMAIL통지요청구분"],
                           @"DM희망지주소구분" : self.userItem[@"_DM희망지주소구분"],
                           @"DATA존재유무" : @"",
                           @"마케팅활용매체별동의" : @"1",
						   }];
			}
			
			self.service = [[[SHBProductService alloc]initWithServiceId:kC2316Id viewController:self]autorelease];
			self.service.requestData = dataSet;
			[self.service start];
        }
        else
        {
			SHBUDreamEndViewController *viewController = [[SHBUDreamEndViewController alloc]initWithNibName:@"SHBUDreamEndViewController" bundle:nil];
			viewController.needsLogin = YES;
			[self checkLoginBeforePushViewController:viewController animated:YES];
			[viewController release];
        }
	}
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 111) {
		[self cancelBtnAction:nil];
	}
}

#pragma mark - UITextField Delegate
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//	if (textField == self.tfOutAccount) {	// 출금계좌번호
//		
//		if ([self.marrAccounts count] == 0) {
//			[UIAlertView showAlert:self
//							  type:ONFAlertTypeOneButton
//							   tag:111
//							 title:@""
//						   message:@"U드림 전환 대상 계좌가 없습니다."];
//		}
//		else {
//			SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"출금계좌리스트"
//																		   options:self.marrAccounts
//																		   CellNib:@"SHBAccountListPopupCell"
//																			 CellH:50
//																	   CellDispCnt:5
//																		CellOptCnt:4] autorelease];
//			[popupView setDelegate:self];
//			[popupView showInView:self.navigationController.view animated:YES];
//			
//		}
//		
//		return NO;
//	}
//	
//	return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{	
	currentTextField = (SHBTextField *)textField;
	[currentTextField focusSetWithLoss:YES];
}

//#pragma mark - SHBTextField Delegate
//- (void)didPrevButtonTouch
//{
//}
//
//- (void)didNextButtonTouch
//{
//}
//
//- (void)didCompleteButtonTouch
//{	
//	[currentTextField focusSetWithLoss:NO];
//}

#pragma mark - SHBSelectBox Delegate
- (void)didSelectSelectBox:(SHBSelectBox *)selectBox
{
#if 1
	SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"고객번호" : AppInfo.customerNo,
						   //@"실명번호" : AppInfo.ssn,
                           //@"실명번호" : [AppInfo getPersonalPK],
                           @"실명번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
						   @"거래구분" : @"9",
						   @"해지거래구분" : @"0",
						   @"보안계좌조회구분" : @"2",
						   @"인터넷조회제한여부" : @"1",
						   }];
	
	self.service = [[[SHBProductService alloc]initWithServiceId:kE2650Id viewController:self]autorelease];
	self.service.requestData = dataSet;
	[self.service start];
#else
	if (selectBox == self.sbOutAccount) {
		if ([self.marrAccounts count] == 0) {
			[UIAlertView showAlert:self
							  type:ONFAlertTypeOneButton
							   tag:111
							 title:@""
						   message:@"U드림 전환 대상 계좌가 없습니다."];
		}
		else {
			[selectBox setState:SHBSelectBoxStateSelected];
			
			SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"출금계좌리스트"
																		   options:self.marrAccounts
																		   CellNib:@"SHBAccountListPopupCell"
																			 CellH:50
																	   CellDispCnt:5
																		CellOptCnt:4] autorelease];
			[popupView setDelegate:self];
			[popupView showInView:self.navigationController.view animated:YES];
			
		}
	}
#endif
}

#pragma mark - SHBListPopupView Delegate

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
	UILabel *lblBalance = (UILabel *)[self.contentScrollView viewWithTag:kTagLabelBalance];
	[lblBalance setText:nil];
	
	self.selectedAccount = [self.marrAccounts objectAtIndex:anIndex];
	
	[self.sbOutAccount setText:[self.selectedAccount objectForKey:@"2"]];
	[self.sbOutAccount setState:SHBSelectBoxStateNormal];
}

- (void)listPopupViewDidCancel
{
	[self.sbOutAccount setState:SHBSelectBoxStateNormal];
}

#pragma mark - SHBSecretCard Delegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
	Debug(@"confirmSecretData:%@", confirmData);
    Debug(@"confirmSecretResult:%i", confirm);
    Debug(@"confirmSecretMedia:%i", mediaType);
	
	if (confirm == 1) {		
//		NSMutableArray *arr = [self outAccountList];
//		NSDictionary *dic = nil;	// 은행코드 때문에 추가..
//		NSString *str = nil;
//		for(int i = 0; i < [arr count]; i ++)
//		{
//			if([[[arr objectAtIndex:i] objectForKey:@"2"] isEqualToString:self.sbOutAccount.text])
//			{
//				dic = [arr objectAtIndex:i];
//				str = self.sbOutAccount.text;
//			}
//		}
		
		[self.userItem setObject:self.sbOutAccount.text forKey:@"계좌번호"];
		
		AppInfo.electronicSignString = @"";
		AppInfo.eSignNVBarTitle = @"U드림저축예금 전환";
		
		NSString *str1 = AppInfo.tran_Date;
		NSString *str2 = AppInfo.tran_Time;
		NSString *str3 = [self.data objectForKey:@"고객성명"];
		NSString *str4 = [self.selectedAccount objectForKey:@"2"];
		
		AppInfo.electronicSignCode = @"D5520";
		AppInfo.electronicSignTitle = @"U드림저축예금 전환";
		
		//[AppInfo addElectronicSign:@"U드림 저축예금 전환 및 개인(신용)정보 수집,이용 동의서(비여신 금융거래)에 동의합니다."];
        
        if ([self.userItem objectForKey:@"동의구분"]) {
			if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의구분"]) {
				AppInfo.electronicSignTitle = @"U드림 저축예금 전환 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등)에 동의합니다.";
             
			}
			else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"필수적정보동의구분"]) {
				AppInfo.electronicSignTitle = @"U드림 저축예금 전환 및 개인(신용)정보 수집, 이용동의서(비여신 금융거래)에 동의합니다.";
               
			}
			else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅과필수적정보동의구분"]) {
				AppInfo.electronicSignTitle = @"U드림 저축예금 전환 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등)와 수집, 이용동의서(비여신 금융거래)에 동의합니다.";
               
			}
			else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의안함"]) {
				AppInfo.electronicSignTitle = @"U드림 저축예금 전환";
               
			}
		}
		else
		{
			AppInfo.electronicSignTitle = @"U드림 저축예금 전환";
            
		}

        
        
        
        
//		[AppInfo addElectronicSign:@"아래의 내용을 서명합니다. 동의하시면 인증서 암호를 입력하시고 확인버튼을 눌러주세요."];
//		[AppInfo addElectronicSign:@"U드림 저축예금 전환"];
		[AppInfo addElectronicSign:@"1. U드림 저축 예금 거래 서비스 특약 내용을 충분히 이해하고 동의함"];
		[AppInfo addElectronicSign:@"2. U드림 저축예금 전환 신청 내용"];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", str1]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", str2]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)고객명: %@", str3]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)계좌번호: %@", str4]];
		[AppInfo addElectronicSign:@"(5)신청내용: U드림 저축예금 전환신청"];
		[AppInfo addElectronicSign:@"3. 상품설명서 및 약관"];
		[AppInfo addElectronicSign:@"(1)상품설명서 받기 여부: 받음"];
		[AppInfo addElectronicSign:@"(2)약관 받기 여부: 받음"];
		
		NSString *str5 = [[self.selectedAccount objectForKey:@"계좌번호"]stringByReplacingOccurrencesOfString:@"-" withString:@""];
//		NSString *str6 = [[self.selectedAccount objectForKey:@"신계좌변환여부"]isEqualToString:@"1"] ? @"1" : [dic objectForKey:@"은행코드"];
//		NSString *str6 = [self.selectedAccount objectForKey:@"은행코드"];
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   @"계좌번호" : str5,
							   @"은행구분" : @"1",
							   @"등록해제구분" : @"1",
							   @"등록해제코드" : @"22165",
							   @"등록자명" : @"",
							   @"거래구분" : @"",
							   }];
		
		self.service = [[[SHBProductService alloc]initWithServiceId:kD5520Id viewController:self]autorelease];
		self.service.requestData = dataSet;
		[self.service start];
	}
}

#pragma mark - Http
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
	if (self.service.serviceId == kE2650Id) {
		self.data = aDataSet;
		self.dataList = [aDataSet arrayWithForKey:@"예금내역"];
		
		self.marrAccounts = [NSMutableArray array];
		for (NSMutableDictionary *dicData in self.dataList)
		{
			if ([[dicData objectForKey:@"예금종류"]isEqualToString:@"1"]
				&& [[dicData objectForKey:@"상품코드"]isEqualToString:@"110000101"]
				&& [[dicData objectForKey:@"U드림통장여부"]isEqualToString:@"0"]) {
				
				[dicData setObject:[[dicData objectForKey:@"상품부기명"]length] ? [dicData objectForKey:@"상품부기명"] : [dicData objectForKey:@"과목명"] forKey:@"1"];
				[dicData setObject:[[dicData objectForKey:@"신계좌변환여부"]isEqualToString:@"1"] ? [dicData objectForKey:@"계좌번호"] : [dicData objectForKey:@"구계좌번호"] forKey:@"2"];
			//	[dicData setObject:[[dicData objectForKey:@"신계좌변환여부"]isEqualToString:@"1"] ? @"1" : [dicData objectForKey:@"은행코드"] forKey:@"은행코드"];
				[self.marrAccounts addObject:dicData];
			}
		}
		
		Debug(@"self.marrAccounts : %@", self.marrAccounts);
		
		if ([self.marrAccounts count] == 0) {
			[UIAlertView showAlert:self
							  type:ONFAlertTypeOneButton
							   tag:111
							 title:@""
						   message:@"U드림 전환 대상 계좌가 없습니다."];
		}
		else {
			[self.sbOutAccount setState:SHBSelectBoxStateSelected];
			
			SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"U드림 저축예금 전환 계좌번호"
																		   options:self.marrAccounts
																		   CellNib:@"SHBAccountListPopupCell"
																			 CellH:50
																	   CellDispCnt:5
																		CellOptCnt:4] autorelease];
			[popupView setDelegate:self];
			[popupView showInView:self.navigationController.view animated:YES];
			
		}
		
	}   // self.service.serviceId == ACCOUNT_D2004
	else if ([AppInfo.serviceCode isEqualToString:@"D2004"])
	{
		NSString *strBalance = [aDataSet objectForKey:@"지불가능잔액"];
		UILabel *lblBalance = (UILabel *)[self.contentScrollView viewWithTag:kTagLabelBalance];
		[lblBalance setText:[NSString stringWithFormat:@"출금가능잔액 %@원", strBalance]];		
	}
	else if (self.service.serviceId == kC2316Id)
	{
		SHBUDreamEndViewController *viewController = [[SHBUDreamEndViewController alloc]initWithNibName:@"SHBUDreamEndViewController" bundle:nil];
		viewController.needsLogin = YES;
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
	}

	return NO;
}

@end
