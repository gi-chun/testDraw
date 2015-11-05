

//
//  SHBNewProductSignUpViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBELD_BA17_14_SignUpViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductNoLineRowView.h"
#import "SHBNewProductListViewController.h"
#import "SHBELD_BA17_15_EndViewController.h"
#import "SHBProductService.h"
#import "SHBELD_BA17_12_inputViewcontroller.h"
#import "SHBNewProductStipulationViewController.h"
#import "SHBExchangeService.h"
#import "SHB_GoldTech_InputViewcontroller.h"
@interface SHBELD_BA17_14_SignUpViewController ()
{
	CGFloat fCurrHeight;
}

@end

@implementation SHBELD_BA17_14_SignUpViewController

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
	[_otpViewController release];
	[_cardViewController release];
	[_userItem release];
	[_bottomBackView release];
	[super dealloc];
}
- (void)viewDidUnload {
	[self setBottomBackView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예금/적금 가입"];
    
    
    self.strBackButtonTitle =self.stepNumber; 
    
        
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	FrameResize(self.contentScrollView, 317, height(self.contentScrollView));
    
   if([self.userItem objectForKey:@"eld가입"])
    {
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 가입신청확인", [self.dicSelectedData objectForKey:@"상품한글명"]] maxStep:5 focusStepNumber:4]autorelease]];
    }
    
   else if([self.userItem objectForKey:@"골드테크가입"])
    {
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 가입신청확인", [self.dicSelectedData objectForKey:@"상품명"]] maxStep:5 focusStepNumber:4]autorelease]];
    }
    
		
	Debug(@"self.userItem : %@", self.userItem);
	
	fCurrHeight = 8;
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[self.contentScrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 10;
	
	NSString *strGuide = @"";
    
    
    strGuide = @"고객님께서는 예금 신규를 아래와 같이 신청하셨습니다. 이체 비밀번호와 보안매체를 입력하시면 가입신청 완료 됩니다.";
    
    
	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(294, 999) lineBreakMode:NSLineBreakByWordWrapping];
	
	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5, fHeight, 294, size.height)]autorelease];
	[lblGuide setNumberOfLines:0];
	[lblGuide setBackgroundColor:[UIColor clearColor]];
	[lblGuide setTextColor:RGB(114, 114, 114)];
	[lblGuide setFont:[UIFont systemFontOfSize:13]];
	[lblGuide setText:strGuide];
	[ivInfoBox addSubview:lblGuide];
	
	fHeight += size.height + 10;
	
	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight, 311, fHeight)];
	fCurrHeight += fHeight;
    
	[self setNoLineRowView];
	
	fCurrHeight += 12;
	UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 317, 1)]autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[self.contentScrollView addSubview:lineView];
	
	[self setSecretMediaView];
	

	[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fCurrHeight)];
	
    //보인카드 키패드 위치조정위해 노티 삭제 0,0으로 복귀 - 보안1, 보안2, 보안3 세트
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"secureMediaKeyPadClose" object:nil];
    
    // 보안매체 입력 완료 - 보안2
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(secureMediaKeyPadClose)
                                                 name:@"secureMediaKeyPadClose"
                                               object:nil];
    
    
    
    //같은 작업진행알럿 - 전문 두번 송신 부분 막기위함
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
    
	// 전자서명 Noti
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    
    // 전자서명 취소시
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignServerError) name:@"eSignCancel" object:nil];
    
	//서버에러일때
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignServerError) name:@"notiESignError" object:nil];
}

- (void)secureMediaKeyPadClose // - 보안3
{
    [self.contentScrollView setContentOffset:CGPointMake(0, self.contentScrollView.contentSize.height - self.contentScrollView.frame.size.height)
                                    animated:YES];
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
- (void)setNoLineRowView
{
	NSString *strTemp = nil;
    
    
   if ([self.userItem objectForKey:@"eld가입"]) { // eld
        strTemp = [NSString stringWithFormat:@"세이프 지수연동예금 신규"];
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=10 title:@"거래구분" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row1];
       
       
        strTemp = [self.dicSelectedData objectForKey:@"상품한글명"];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"예금명" value:strTemp isTicker:YES] autorelease];
        [self.contentScrollView addSubview:row2];
        
       if ([[self.userItem objectForKey:@"이자지급방법"] isEqualToString:@"1"]) {
           strTemp = [NSString stringWithFormat:@"이자지급식(지급주기 %@개월)",[self.userItem objectForKey:@"지급주기"]];
       }
       else {
           strTemp = [NSString stringWithFormat:@"만기일시지급식"];
       }
       
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"이자지급방법" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row3];
        
        strTemp = [self.dicSelectedData objectForKey:@"예금시작일자"];
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"예금시작일" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row4];
        
        
        strTemp = [self.dicSelectedData objectForKey:@"예금만기일자"];
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"예금만기일" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row5];
        
        strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"신규금액"]];
        SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"최초불입금" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row6];
       
       
        if ([[self.userItem objectForKey:@"발송"] isEqualToString:@"9"]) {
            strTemp = [NSString stringWithFormat:@"미통보"];
        }
        else {
            strTemp = [NSString stringWithFormat:@"E-mail"];
        }
        
        SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"지수수익률표 통보" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row7];
       
       
        
        if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0" ]) {
             strTemp = [NSString stringWithFormat:@"일반과세"];
        }
        else if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"1" ]) {
             strTemp = [NSString stringWithFormat:@"세금우대"]; 
        }
        else if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"2" ]) {
            strTemp = [NSString stringWithFormat:@"비과세(생계형)"];  
        }
       
       SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"적용과세" value:strTemp]autorelease];
       [self.contentScrollView addSubview:row8];
       
       
        
        strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
        SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row9];
        
        fCurrHeight += 15+5;
        
        return;
    }
    
    else if ([self.userItem objectForKey:@"골드테크가입"]) { //골드테크가입
        
        strTemp = [self.userItem objectForKey:@"통화코드"];
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=10 title:@"신규코드" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row1];
        
        strTemp = [NSString stringWithFormat:@"%@ g",[self.userItem objectForKey:@"포지션"]];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규적립량" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row2];
        
    
        strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
        
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"출금계좌" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row3];
        
        strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"원화합계"]];
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"원화합계" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row4];
        
        
        strTemp = [self.userItem objectForKey:@"적용환율"];
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적용환율" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row5];
        
        if ([[self.userItem objectForKey:@"목표수익률통지"] isEqualToString:@"미신청" ]) {
            strTemp = [NSString stringWithFormat:@"%@",[self.userItem objectForKey:@"목표수익률통지"]];
            SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"목표수익률통지" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row6];
        }
        else
        {
            if ([[self.userItem objectForKey:@"목표가격"] isEqualToString:@"" ]) {
                strTemp = [NSString stringWithFormat:@"(+)%@ %%",[self.userItem objectForKey:@"목표수익률"]];
                SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"목표수익률" value:strTemp] autorelease];
                [self.contentScrollView addSubview:row6];
            }
            else{
                strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"목표가격"]];;
                SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"목표가격" value:strTemp] autorelease];
                [self.contentScrollView addSubview:row6];
            }
            
        }
        
       
        if ([[self.userItem objectForKey:@"위험수익률통지"] isEqualToString:@"미신청" ]) {
            strTemp = [NSString stringWithFormat:@"%@",[self.userItem objectForKey:@"위험수익률통지"]];
            SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"위험수익률통지" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row7];
        }
        else{
            if ([[self.userItem objectForKey:@"위험가격"] isEqualToString:@"" ]) {
                strTemp = [NSString stringWithFormat:@"(-)%@ %%",[self.userItem objectForKey:@"위험수익률"]];
                SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"위험수익률" value:strTemp] autorelease];
                [self.contentScrollView addSubview:row7];
            }
            else{
                strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"위험가격"]];;
                SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"위험가격" value:strTemp] autorelease];
                [self.contentScrollView addSubview:row7];
            }

        }
        
        
        if ([[self.userItem objectForKey:@"정기수익률"] isEqualToString:@"0" ]) {
            strTemp = [NSString stringWithFormat:@"미신청"];
            SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"정기수익률" value:strTemp]autorelease];
            [self.contentScrollView addSubview:row8];
        }
        else{
            strTemp = [NSString stringWithFormat:@"매월%@일",[self.userItem objectForKey:@"정기수익률"]];
            SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"정기수익률" value:strTemp]autorelease];
            [self.contentScrollView addSubview:row8];        }
        
        
        
        
        
        
        if ([[self.userItem objectForKey:@"정기잔고통보"] isEqualToString:@"" ]) {
            strTemp = [NSString stringWithFormat:@"원하지 않음"];
            SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"정기잔고통보" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row9];
        }
        else{
            strTemp = [NSString stringWithFormat:@"%@",[self.userItem objectForKey:@"정기잔고통보"]];;
            SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"정기잔고통보" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row9];
        }
        
        if (![[self.userItem objectForKey:@"정기잔고통보일"] isEqualToString:@"" ]) {
            strTemp = [NSString stringWithFormat:@"매월%@일",[self.userItem objectForKey:@"정기잔고통보일"]];
            SHBNewProductNoLineRowView *row10 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"정기잔고통보일" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row10];
        }
       
        fCurrHeight += 15+5;
        
        return;
    }
	

	
	fCurrHeight += 15+5;
}

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
        
         if ([self.userItem objectForKey:@"eld가입"]) { // eld
              vc.nextSVC = @"D3277";
         }
         else if([self.userItem objectForKey:@"골드테크가입"]) {
             vc.nextSVC = @"D7302";
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
        if ([self.userItem objectForKey:@"eld가입"]) { // eld
            vc.nextSVC = @"D3277";
        }
		else if([self.userItem objectForKey:@"골드테크가입"]) {
            vc.nextSVC = @"D7302";
        }
		self.otpViewController = vc;
    }
}

#pragma mark - Action
- (IBAction)confirmBtnAction:(SHBButton *)sender {
#if 0	// temp
	SHBELD_BA17_15_EndViewController *viewController = [[SHBELD_BA17_15_EndViewController alloc]initWithNibName:@"SHBELD_BA17_15_EndViewController" bundle:nil];
	viewController.dicSelectedData = self.dicSelectedData;
	viewController.userItem = self.userItem;
	[self checkLoginBeforePushViewController:viewController animated:YES];
#else
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



- (void)cancelSecretMedia
{
    if ([self.userItem objectForKey:@"골드테크가입"]) { //골드테크가입
        for (SHB_GoldTech_InputViewcontroller *viewController in self.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[SHB_GoldTech_InputViewcontroller class]]) {
                if ([viewController respondsToSelector:@selector(reset)]) {
                    [viewController reset];
                }
                
                [self.navigationController popToViewController:viewController animated:YES];
            }
        }
        
        
    }
    else{
    
        for (SHBELD_BA17_12_inputViewcontroller *viewController in self.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[SHBELD_BA17_12_inputViewcontroller class]]) {
                if ([viewController respondsToSelector:@selector(reset)]) {
                    [viewController reset];
                }
                
                [self.navigationController popToViewController:viewController animated:YES];
            }
        }
        
    
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
    
    if ([self.userItem objectForKey:@"골드테크가입"]) { //골드테크가입
        for (SHB_GoldTech_InputViewcontroller *viewController in self.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[SHB_GoldTech_InputViewcontroller class]]) {
                if ([viewController respondsToSelector:@selector(reset)]) {
                    [viewController reset];
                }
                
                [self.navigationController popToViewController:viewController animated:YES];
            }
        }
        
        
    }
    else{
        
        for (SHBELD_BA17_12_inputViewcontroller *viewController in self.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[SHBELD_BA17_12_inputViewcontroller class]]) {
                if ([viewController respondsToSelector:@selector(reset)]) {
                    [viewController reset];
                }
                
                [self.navigationController popToViewController:viewController animated:YES];
            }
        }
        
    }
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Notification
- (void)getElectronicSignResult:(NSNotification *)noti
{
	Debug(@"[noti userInfo] : %@", [noti userInfo]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
	if (!AppInfo.errorType) {
		self.data = [noti userInfo];
        
        
        if ([[self.userItem objectForKey:@"직원번호"]length])
        {
            
			SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
								   @"성명" : [AppInfo.userInfo objectForKey:@"고객성명"],
								   @"이메일주소" : [NSString stringWithFormat:@"SH%@@portal.shinhan.com",[self.userItem objectForKey:@"직원번호"]],
								   @"내용" : [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@",
											[AppInfo.userInfo objectForKey:@"고객성명"],  //고객명
											[self.userItem objectForKey:@"직원번호"],        //권유자번호
											[self.dicSelectedData objectForKey:@"상품한글명"],    //상품명
											AppInfo.customerNo,  //고객번호
											[self.data objectForKey:@"계좌번호"],		//계좌번호
											[self.data objectForKey:@"신규일"],		//신규일자
											[self.data objectForKey:@"COM_TRAN_TIME"],		//신규시간
											[self.data objectForKey:@"만기일"],		//만기일자
											[self.data objectForKey:@"거래금액"]		//거래금액
											],
								   @"서비스아이디" : @"SRIB0022",
								   @"사용자아이디" : @"ribagent01",
								   }];
			self.service = nil;
			self.service = [[[SHBProductService alloc]initWithServiceId:kD9501Id viewController:self]autorelease];
			self.service.requestData = dataSet;
			[self.service start];
            
		}
		else if ([self.userItem objectForKey:@"동의구분"])
        {
			//NSLog(@"!!!정보동의 %@", [self.userItem objectForKey:@"정보동의"]);
           // NSLog(@"!!!마케팅활용동의여부 %@", [self.userItem objectForKey:@"마케팅활용동의여부"]);
            
            SHBDataSet *dataSet = nil;
			if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의구분"] ||
                [[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의안함"]) {
				
				dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"은행구분" : @"1",
						   @"검색구분" : @"1",
						   @"고객번호" : AppInfo.customerNo,
						   @"고객번호1" : AppInfo.customerNo,
						   @"마케팅활용동의여부" : self.userItem[@"정보동의"],
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
						   @"마케팅활용동의여부" : self.userItem[@"마케팅활용동의여부"],//c2315 내려온 값 그대로 셋팅
						   @"장표출력SKIP여부" : @"1",
						   @"인터넷수행여부" : @"2",
						   @"필수정보동의여부" : @"1",
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
			
			Debug(@"dataSet : %@", dataSet);
            self.service = nil;
			self.service = [[[SHBProductService alloc]initWithServiceId:kC2316Id viewController:self]autorelease];
			self.service.requestData = dataSet;
			[self.service start];
		}
        
     
        else
        {
        SHBELD_BA17_15_EndViewController *viewController = [[SHBELD_BA17_15_EndViewController alloc]initWithNibName:@"SHBELD_BA17_15_EndViewController" bundle:nil];
        viewController.dicSelectedData = self.dicSelectedData;
        viewController.userItem = self.userItem;
        viewController.completeData = [NSMutableDictionary dictionaryWithDictionary:self.data];
        viewController.needsLogin = YES;
        [self checkLoginBeforePushViewController:viewController animated:YES];
        [viewController release];
        }
        
    }
}

//- (void)getElectronicSignCancel
//{
//	Debug(@"getElectronicSignCancel");
//	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
//	{
//		if ([viewController isKindOfClass:[SHBNewProductStipulationViewController class]]) {
//			[self.navigationController popToViewController:viewController animated:YES];
//		}
//	}
//}

- (void)getElectronicSignServerError
{
    if ([self.userItem objectForKey:@"골드테크가입"]) { //골드테크가입
        for (SHB_GoldTech_InputViewcontroller *viewController in self.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[SHB_GoldTech_InputViewcontroller class]]) {
                if ([viewController respondsToSelector:@selector(reset)]) {
                    [viewController reset];
                }
                
                [self.navigationController popToViewController:viewController animated:YES];
            }
        }
        
        
    }
    else{
        for (SHBELD_BA17_12_inputViewcontroller *viewController in self.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[SHBELD_BA17_12_inputViewcontroller class]]) {
                if ([viewController respondsToSelector:@selector(reset)]) {
                    [viewController reset];
                }
                
                [self.navigationController popToViewController:viewController animated:YES];
            }
        }
        
        
    }
	
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewProductCancel" object:nil];
}

#pragma mark - 전자서명 코드 세팅
- (NSString *)getElectronicSignCode
{
	NSString *strReturn = nil;
    
    if ([self.userItem objectForKey:@"eld가입"])
    {
        
        if ([[self.dicSelectedData objectForKey:@"고객성향유형"] isEqualToString:@"안정형"])
        {
             strReturn = @"D3277_B";
            return strReturn;
        }
        
        strReturn = @"D3277_A";
        
        return strReturn;
    }
    
    else if([self.userItem objectForKey:@"골드테크가입"])
    {
        strReturn = @"D7302";
        
        return strReturn;
    }
   
	
	Debug(@"strReturn : %@", strReturn);
	
    return @"";
}

#pragma mark - SHBSecretCard Delegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
	Debug(@"confirmSecretData:%@", confirmData);
    Debug(@"confirmSecretResult:%i", confirm);
    Debug(@"confirmSecretMedia:%i", mediaType);
    Debug(@"고객성향유형:%@", [self.dicSelectedData objectForKey:@"고객성향유형"]);
    
    
	if (confirm == 1)
    {
        AppInfo.electronicSignString = @"";
		AppInfo.eSignNVBarTitle = @"예금/적금 가입";
		AppInfo.electronicSignCode = [self getElectronicSignCode];
        
     
		if ([self.userItem objectForKey:@"동의구분"]) {
			if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의구분"]) {
				AppInfo.electronicSignTitle = @"해당상품의 약관 및 상품설명서 내용을 확인하고 본 상품에 가입함을 확인합니다. 개인(신용)정보 수집.이용.제공(상품 서비스 안내 등)에 동의합니다.";

			}
			else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"필수적정보동의구분"]) {
				AppInfo.electronicSignTitle = @"해당상품의 약관 및 상품설명서 내용을 확인하고 본 상품에 가입함을 확인합니다. 개인(신용)정보 (고유식별정보 등 포함) 수집.이용에 동의합니다.";

			}
			else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅과필수적정보동의구분"]) {
				AppInfo.electronicSignTitle = @"해당상품의 약관 및 상품설명서 내용을 확인하고 본 상품에 가입함을 확인합니다. 개인(신용)정보 수집.이용.제공(상품 서비스 안내 등)에 동의합니다. 개인(신용)정보 (고유식별정보 등 포함) 수집.이용에 동의합니다.";

			}
			else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의안함"]) {
				AppInfo.electronicSignTitle = @"예금/적금 가입";

			}
		}
		else
		{
            if ([self.userItem objectForKey:@"eld가입"]) {
                AppInfo.electronicSignTitle = @"예금/적금 가입";
            }
			
            else if ([self.userItem objectForKey:@"골드테크가입"]) {
                AppInfo.electronicSignTitle = @"골드리슈 골드테크 신규 신청";
            }
            
		}
		
        
        if ([self.userItem objectForKey:@"골드테크가입"])
        {
            [AppInfo addElectronicSign:@"1. 해당상품의 투자설명서 및 간이 투자설명서를 다운로드 받았음"];
            [AppInfo addElectronicSign:@"2. 상품의 주요 내용 및 투자위험성"];
            [AppInfo addElectronicSign:@"3. 상품가입 신청내용"];
           
            NSInteger counter = 1;
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)통화코드: %@",counter,[self.userItem objectForKey:@"통화코드"]]];
            counter++;

            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)상품명: %@",counter,[self.dicSelectedData objectForKey:@"상품명"]]];
            counter++;
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)위험등급: 2등급(높은 위험)",counter]];
            counter++;
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)고객투자성향: %@",counter,[self.dicSelectedData objectForKey:@"_고객투자성향"]]];
            counter++;
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)파생상품투자경험: %@",counter,[self.dicSelectedData objectForKey:@"_파생상품투자경험"]]];
            counter++;
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)신규적립량(g): %@",counter,[self.userItem objectForKey:@"포지션"]]];
            counter++;
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)원화출금계좌: %@",counter,[self.userItem objectForKey:@"출금계좌번호출력용"]]];
            counter++;
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)원화합계: %@원",counter,[self.userItem objectForKey:@"원화합계"]]];
            counter++;
            
            
            
            SHBDataSet *dataSet =  [[[SHBDataSet alloc] initWithDictionary:@{
                                                                         @"고객번호" : AppInfo.customerNo,
                                                                         @"거래구분" : @"1", //고정
                                                                         @"신규계좌비밀번호" :  [self.userItem objectForKey:@"신규계좌비밀번호"],
                                                                         @"외화거주구분" : @"4",   //고정
                                                                         @"투자목적" : @"0",   //고정
                                                                         @"통화코드" : @"XAU",   //고정
                                                                         @"상품코드" : [self.dicSelectedData objectForKey:@"상품코드"],
                                                                         @"업무분류코드" : @"93",
                                                                         @"환율적용구분" : @"1",   //고정
                                                                         @"신규적립량" :  [self.userItem objectForKey:@"포지션"],
                                                                         @"포지션" :  [self.userItem objectForKey:@"포지션"],
                                                                         @"환율적용구분" :  @"1",
                                                                         @"우대" :  @"1",
                                                                         @"원화출금계좌번호" : [self.userItem objectForKey:@"원화출금계좌번호"],
                                                                         @"원화출금계좌비밀번호" : [self.userItem objectForKey:@"출금계좌비밀번호"],
                                                                         @"원화출금계좌은행구분" : @"1",
                                                                         @"약정월수" :[self.userItem objectForKey:@"약정월수"],
                                                                         @"적용환율" :[self.userItem objectForKey:@"적용환율"],
                                                                         @"입금분류" : @"2",
                                                                         @"입금사유" : @"99",
                                                                         @"원화연동금액" :[self.userItem objectForKey:@"원화합계"],
                                                                         @"자동이체시작일" : @"",
                                                                         @"자동이체종료일" : @"",
                                                                         @"자동이체적립구분" : @"",
                                                                         @"자동이체적립주기" : @"",
                                                                         @"자동이체적립요일" : @"",
                                                                         @"자동이체최고환율" : @"",
                                                                         @"자동이체최저환율" : @"",
                                                                         @"자동이체적립배수" : @"",
                                                                         @"입금은행코드" : @"88",
                                                                         @"입금계좌번호" : @"",
                                                                         @"거래구분1" : @"0",
                                                                         @"업무구분1" : @"0",
                                                                         @"거래점용은행구분" : @"1",
                                                                         @"거래점용계좌번호" : [self.userItem objectForKey:@"원화출금계좌번호"],
                                                                         @"정기잔고통보" : [self.userItem objectForKey:@"정기잔고통보"],
                                                                         @"정기잔고통보일" : [self.userItem objectForKey:@"정기잔고통보일"],
                                                                         @"수익률통보기준일" : [self.userItem objectForKey:@"정기수익률"],
                                                                         @"초과등급여부" : [self.dicSelectedData objectForKey:@"_초과등급여부"],
                                                                         }] autorelease];
            
        
        
        
            if([[self.userItem objectForKey:@"목표수익률통지"] isEqualToString:@"미신청"] ||
               [[self.userItem objectForKey:@"위험수익률통지"] isEqualToString:@"미신청"])
            {
                [dataSet insertObject:@"0" forKey:@"목표수익률" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"목표가격" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"위험수익률" atIndex:0];
                [dataSet insertObject:@"0" forKey:@"위험가격" atIndex:0];
            }
            
            else{
                [dataSet insertObject:[self.userItem objectForKey:@"목표수익률"] forKey:@"목표수익률" atIndex:0];
                [dataSet insertObject:[self.userItem objectForKey:@"목표가격"] forKey:@"목표가격" atIndex:0];
                [dataSet insertObject:[self.userItem objectForKey:@"위험수익률"] forKey:@"위험수익률" atIndex:0];
                [dataSet insertObject:[self.userItem objectForKey:@"위험가격"] forKey:@"위험가격" atIndex:0];
            }
            
            
            
            if ([self.userItem objectForKey:@"직원번호"] != nil) {
                [dataSet insertObject:[self.userItem objectForKey:@"직원번호"] forKey:@"권유직원번호" atIndex:0];  //ㅇ
            }
            if ([self.userItem objectForKey:@"예금별명"] != nil) {
                [dataSet insertObject:[self.userItem objectForKey:@"예금별명"] forKey:@"부제목" atIndex:0];
            }
            
            
            
            
            
            self.service = nil;
            self.service = [[[SHBExchangeService alloc] initWithServiceCode:@"D7302" viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
            
            

        }
        
        else if ([self.userItem objectForKey:@"eld가입"])
        {
            // Eld 가입
            [AppInfo addElectronicSign:@"1.신청내용"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)예금종류: %@", [self.dicSelectedData objectForKey:@"상품한글명"]]];
            
            NSInteger counter = 4;
            
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)예금시작일: %@",counter,[self.dicSelectedData objectForKey:@"예금시작일자"]]];
            counter++;
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)예금만기일: %@",counter,[self.dicSelectedData objectForKey:@"예금만기일자"]]];
            counter++;
            
            
            if ([[self.userItem objectForKey:@"이자지급방법"] isEqualToString:@"1"]) {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)이자지급방법: 이자지급식(지급주기 %@개월)",counter,[self.userItem objectForKey:@"지급주기"]]];
            }
            else
            {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)이자지급방법: 만기일시지급식",counter]];
            }
            counter++;
            
            if ([[self.userItem objectForKey:@"발송"] isEqualToString:@"9"]) {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)지수수익률표 통보: 미통보",counter]];
            }
            else
            {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)지수수익률표 통보: E-mail",counter]];
            }
            counter++;
            
            if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0"]) {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)세금우대: 일반과세",counter] ];
            }
            else if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"1"]) {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)세금우대: 세금우대",counter] ];
            }
            else if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"2"]) {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)세금우대: 비과세(생계형)",counter]];
            }
            
            counter++;
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)신규금액: %@ 원",counter,[self.userItem objectForKey:@"신규금액"]    ]];
            counter++;
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)출금계좌번호: %@",counter,[self.userItem objectForKey:@"출금계좌번호출력용"]    ]];
            counter++;
            
            if ([[self.dicSelectedData objectForKey:@"고객성향유형"] isEqualToString:@"안정형"])
            {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)투자성향등급: 안정형",counter]];
                counter++;
                
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)투자자확인서 작성여부: 작성",counter]];
                counter++;
            }
            
            //2010.11.18  상품설명서 관련 추가
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"2.상품설명서 및 약관"] ];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)상품설명서 받기 여부: 받음"] ];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)약관 받기 여부: 받음"] ];
            
            
            
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                         @"상품코드" : [self.dicSelectedData objectForKey:@"상품코드"],
                                                                         @"고객번호" : AppInfo.customerNo,
                                                                         @"은행구분" :@"1",
                                                                         @"거래점계좌번호" : [self.userItem objectForKey:@"출금계좌번호"],
                                                                         @"금액" : [self.userItem objectForKey:@"신규금액"],
                                                                         @"합계" : [self.userItem objectForKey:@"신규금액"],
                                                                         @"대분류과목" : @"04",
                                                                         @"발송" :[self.userItem objectForKey:@"발송"],
                                                                         @"이자지급방법" :[self.userItem objectForKey:@"이자지급방법"],
                                                                         @"지급주기구분" :@"0",               //ㅇ
                                                                         @"지급주기" :[self.userItem objectForKey:@"지급주기"],
                                                                         @"회전주기" :[self.dicSelectedData objectForKey:@"이율회전주기"],
                                                                         @"신규계좌비밀번호" : [self.userItem objectForKey:@"신규계좌비밀번호"],
                                                                         @"거래구분" : @"0",
                                                                         @"계약기간_개월" : @"0",
                                                                         @"세금우대상품종료" : [self.userItem objectForKey:@"세금우대"],   
                                                                         @"재예치재원구분" : @"",                                               
                                                                         @"연동지급금액" : [self.userItem objectForKey:@"신규금액"],             
                                                                         @"연동지급계좌구분" : @"1",             //ㅇ
                                                                         @"출금계좌은행구분" : [self.userItem objectForKey:@"출금계좌은행구분"],
                                                                         @"출금계좌번호" : [self.userItem objectForKey:@"출금계좌번호"],
                                                                         @"출금계좌비밀번호" : [self.userItem objectForKey:@"출금계좌비밀번호"],
                                                                         @"세이프계좌번호" : [self.userItem objectForKey:@"출금계좌번호"],
                                                                         @"초과등급여부" : [self.dicSelectedData objectForKey:@"고위험세이프예금신규"],
                                                                         
                                                                         }];
            
            
            
            if ([self.userItem objectForKey:@"직원번호"] != nil) {
                [dataSet insertObject:[self.userItem objectForKey:@"직원번호"] forKey:@"권유직원번호" atIndex:0];  //ㅇ
            }
            if ([self.userItem objectForKey:@"예금별명"] != nil) {
                [dataSet insertObject:[self.userItem objectForKey:@"예금별명"] forKey:@"부제목" atIndex:0];
            }
            
            
            
            
            
            self.service = nil;
            self.service = [[[SHBProductService alloc]initWithServiceId:kD3277Id viewController:self]autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        
        }
	}
}

#pragma mark - Http Delegate
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
	
	if (self.service.serviceId == kD9501Id)
    {
		if ([self.userItem objectForKey:@"동의구분"])
        {
			SHBDataSet *dataSet = nil;
			if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의구분"] ||
                [[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의안함"]) {
				Debug(@"%@", [self.userItem objectForKey:@"정보동의"]);
				dataSet = [SHBDataSet dictionaryWithDictionary:@{
						   @"은행구분" : @"1",
						   @"검색구분" : @"1",
						   @"고객번호" : AppInfo.customerNo,
						   @"고객번호1" : AppInfo.customerNo,
						   @"마케팅활용동의여부" : self.userItem[@"정보동의"],
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
						   @"마케팅활용동의여부" : self.userItem[@"마케팅활용동의여부"],
						   @"장표출력SKIP여부" : @"1",
						   @"인터넷수행여부" : @"2",
						   @"필수정보동의여부" : @"1",
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
            
			self.service = nil;
			self.service = [[[SHBProductService alloc]initWithServiceId:kC2316Id viewController:self]autorelease];
			self.service.requestData = dataSet;
			[self.service start];
		}
        
        
		else
		{
			SHBELD_BA17_15_EndViewController *viewController = [[SHBELD_BA17_15_EndViewController alloc]initWithNibName:@"SHBELD_BA17_15_EndViewController" bundle:nil];
			viewController.dicSelectedData = self.dicSelectedData;
			viewController.userItem = self.userItem;
			viewController.completeData = [NSMutableDictionary dictionaryWithDictionary:self.data];
			[self checkLoginBeforePushViewController:viewController animated:YES];
			[viewController release];
		}
	}
    
    
	else if (self.service.serviceId == kC2316Id) {
		SHBELD_BA17_15_EndViewController *viewController = [[SHBELD_BA17_15_EndViewController alloc]initWithNibName:@"SHBELD_BA17_15_EndViewController" bundle:nil];
		viewController.dicSelectedData = self.dicSelectedData;
		viewController.userItem = self.userItem;
		viewController.completeData = [NSMutableDictionary dictionaryWithDictionary:self.data];
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
	}
    
    
    
       return NO;
}

@end

