//
//  SHBLoanSecurityViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBLoanSecurityViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBProductService.h"
#import "SHBLoanInfoViewController.h"
#import "SHBNewProductNoLineRowView.h"
#import "SHBUtility.h"
#import "SHBLoanSecurityStipulationView.h"
#import "SHBLoanEndViewController.h"
#import "SHBNewProductSeeStipulationViewController.h"

@interface SHBLoanSecurityViewController ()
{
	CGFloat fCurrHeight;
	
	BOOL isReadStipulation1;
}

@property (nonatomic, retain) NSString *strTmp1;	// 입금계좌
@property (nonatomic, retain) NSString *strTmp2;	// 대출금액
@property (nonatomic, retain) NSString *strTmp3;	// 대출이율
@property (nonatomic, retain) NSString *strTmp4;	// 인지세

@end

@implementation SHBLoanSecurityViewController

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
	[_L1311 release];
	[_userItem release];
	[_bottomView release];
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
	[self setTitle:@"예적금담보대출"];
    self.strBackButtonTitle = @"예적금담보대출 신청 5단계";
    
    // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
    AppInfo.isNeedBackWhenError = YES;
    
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:@"예적금담보대출 확인" maxStep:6 focusStepNumber:5]autorelease]];
	
	
	
    
    
    if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
    {
        self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00001_3 viewController:self] autorelease];
        [self.service start];
    }
    else
    {
        self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00001_6 viewController:self] autorelease];
        [self.service start];    }
    
    
	// 전자서명 Noti
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
	    
	 
	// 약관
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userReadStipulation:) name:@"UserPressedConfirmButton" object:nil];
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

#pragma mark - Notification
- (void)userReadStipulation:(NSNotification *)noti
{
	NSString *strUrl = [[noti userInfo]objectForKey:@"url"];
	
	if ([strUrl hasSuffix:@"yak_delaycompensation.html"]) {
		isReadStipulation1 = YES;
	}
	
}

#pragma mark - UI
- (void)setUI
{
	{
		NSString *strGuide = @"아래와 같이 예적금 담보 대출을 처리 합니다.\n\n본인은 신한은행(이하 은행 이라고 합니다.)과 아래의 조건에 따라 대출거래를 함에 있어 '은행여신 거래 기본약관(가계용)'이 적용됨을 승인하고, 다음 각 조항을 확인 합니다.";
		CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByWordWrapping];
		
		UIView *vTitle = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 317, 10+size.height+10)]autorelease];
		[vTitle setBackgroundColor:[UIColor whiteColor]];
		[self.contentScrollView addSubview:vTitle];
		
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8, 10, 301, size.height)]autorelease];
		[lbl setNumberOfLines:0];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setTextColor:RGB(40, 91, 142)];
		[lbl setFont:[UIFont systemFontOfSize:13]];
		[lbl setText:strGuide];
		[vTitle addSubview:lbl];
		
		UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=10+size.height+10, 317, 1)]autorelease];
		[lineView setBackgroundColor:RGB(209, 209, 209)];
		[self.contentScrollView addSubview:lineView];
		fCurrHeight+=1;
	}
	
	UILabel *lbl1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 33)]autorelease];
	[lbl1 setBackgroundColor:[UIColor clearColor]];
	[lbl1 setTextColor:RGB(40, 91, 142)];
	[lbl1 setFont:[UIFont systemFontOfSize:15]];
	[lbl1 setText:@"제1조 거래조건"];
	[self.contentScrollView addSubview:lbl1];
	fCurrHeight+=33;
	   
	for (int nIdx = 0; nIdx < 11; nIdx++) {
		CGFloat fOffSet = nIdx == 0 ? 0 : 25;
		SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight += fOffSet]autorelease];
		[self.contentScrollView addSubview:row];
		
		if (nIdx == 0) {
			[row.lblTitle setText:@"고객명"];
			[row.lblValue setText:[self.L1311 objectForKey:@"고객명"]];
		}
		else if (nIdx == 1) {
			 NSString *tmp = nil;
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                [row.lblTitle setText:@"대출구분"];
                tmp = [NSString stringWithFormat:@"<가계>일반자금대출 예금담보대출"];
			}
            
            else
            {
                [row.lblTitle setText:@"대출과목"];
                tmp = [NSString stringWithFormat:@"일반자금대출"];
            }
            
			NSString *str = [NSString stringWithFormat:@"%@",tmp];
			CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(width(row.lblValue), 999) lineBreakMode:NSLineBreakByCharWrapping];
			
			FrameResize(row.lblValue, width(row.lblValue), size.height);
			[row.lblValue setTextAlignment:NSTextAlignmentRight];
			[row.lblValue setNumberOfLines:0];
			[row.lblValue setText:str];
			
			fCurrHeight -= 25;
			fCurrHeight += size.height;
		}
		else if (nIdx == 2) {
			if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                [row.lblTitle setText:@"담보예금 계좌번호"]; // 건별
            }
            else
            {
                [row.lblTitle setText:@"담보설정계좌"];  //한도
            }
            
            
			[row.lblValue setText:[self.L1311 objectForKey:@"담보계좌번호"]];
		}
		else if (nIdx == 3) {
			[row.lblTitle setText:nil];
			[row.lblValue setText:[self.userItem objectForKey:@"상품명"]];
		}
		else if (nIdx == 4) {
			
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                [row.lblTitle setText:@"입금계좌번호"];
			}
            else
            {
                [row.lblTitle setText:@"한도대출 등록계좌"];
			}
			self.strTmp1 = [self.userItem objectForKey:@"입금계좌번호출력용"];
			[row.lblValue setText:self.strTmp1];
		}
		else if (nIdx == 5) {
			[row.lblTitle setTextColor:RGB(209, 75, 75)];
			[row.lblValue setTextColor:RGB(209, 75, 75)];
			
			
            [row.lblTitle setText:@"대출신청 금액"];
			
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                self.strTmp2 = [NSString stringWithFormat:@"%@원", [self.L1311 objectForKey:@"실행금액"]];
            }
            else{
                self.strTmp2 = [NSString stringWithFormat:@"%@원", [self.userItem objectForKey:@"실행금액"]];
            }
            
			
			[row.lblValue setText:self.strTmp2];
		}
		else if (nIdx == 6) {
			[row.lblTitle setTextColor:RGB(209, 75, 75)];
			[row.lblValue setTextColor:RGB(209, 75, 75)];
			
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                [row.lblTitle setText:@"대출금리"];
			}
            else
            {
                [row.lblTitle setText:@"대출이율"];
            }
			NSString *str = nil;
			if ([[[self.L1311 objectForKey:@"담보계좌번호"]substringWithRange:NSMakeRange(0, 3)]isEqualToString:@"223"]) {
				str = @"CD금리 +";
			}
			else
			{
				str = @"예금금리 +";
			}
			
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                self.strTmp3 = [NSString stringWithFormat:@"%@ %.2f%%", str, [[self.L1311 objectForKey:@"대출이율"]floatValue]];
            }
            else{
                self.strTmp3 = [NSString stringWithFormat:@"%@ %.2f%%", str, [[self.L1311 objectForKey:@"이율"]floatValue]];
            }
			[row.lblValue setText:self.strTmp3];
		}
		else if (nIdx == 7) {
            
            if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
            {
                [row.lblTitle setText:@"이자 납입일"];
                [row.lblValue setText:[self.L1311 objectForKey:@"다음이자납입일"]];
            }
            else{
                [row.lblTitle setText:@"지연배상금율"];
                [row.lblValue setText:[NSString stringWithFormat:@"최고 %@",AppInfo.versionInfo[@"지연배상금율_MSG"]]];
            }
		}
		else if (nIdx == 8) {
			[row.lblTitle setText:@"인지세"];
			
            if ([AppInfo.commonDic[@"_대출타입"] isEqualToString:@"A"])  //건별
            {
                if ([[self.L1311 objectForKey:@"실행금액->originalValue"] longLongValue] > 40000000) {
                    self.strTmp4 = [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[self.data objectForKey:@"금액1"]]];
                }
                else
                {
                    self.strTmp4 = @"0원";  ;
                }
                
            }
            else  //한도
            {
                
                if ([[[self.userItem objectForKey:@"실행금액"] stringByReplacingOccurrencesOfString:@"," withString:@""]  longLongValue]> 40000000) {
                    self.strTmp4 = [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[self.data objectForKey:@"금액1"]]];
                }
                else
                {
                    self.strTmp4 = @"0원";
                }

            }
			
			
			[row.lblValue setText:self.strTmp4];
		}
		else if (nIdx == 9) {
			[row.lblTitle setText:@"권유자 직원번호"];
			[row.lblValue setText:[self.userItem objectForKey:@"권유자"]];
		}
		else if (nIdx == 10) {
			[row.lblTitle setText:@"대출용도"];
			
			//NSString *str = [self.userItem objectForKey:@"대출용도출력용"];
           
            NSString *str = nil;
            
            NSLog(@" 기타 입력 내용 %@",[self.userItem objectForKey:@"금감원자금용도기타내용"]);
            NSLog(@" 기타 입력 내용 %@",[self.userItem objectForKey:@"대출용도출력용"]);
            
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
	
    
    
    UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[self.contentScrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 10;
	
	NSMutableArray *marrTitles = [NSMutableArray array];
	NSMutableArray *marrGuides = [NSMutableArray array];
	for (int nIdx = 1; nIdx <= 10; nIdx ++) {
		NSString *strKey = [NSString stringWithFormat:@"메시지%d", nIdx];
		NSString *strValue  = [self.data objectForKey:strKey];
		
        if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
        {
            
            if ([strValue length] > 0) {
                [marrGuides addObject:strValue];
                if (nIdx == 1) {
                    [marrTitles addObject:@"이자율등 변동"];
                }
                else if (nIdx == 2) {
                    [marrTitles addObject:@"이자 및 지연배상금 계산방법"];
                }
                else if (nIdx == 3) {
                    [marrTitles addObject:@"대출 실행방법"];
                }
                else if (nIdx == 4) {
                    [marrTitles addObject:@"상환방법"];
                }
                else if (nIdx == 5) {
                    [marrTitles addObject:@"이자 지급 시기 및 방법"];
                }
                else if (nIdx == 6) {
                    [marrTitles addObject:@"상계특약"];
                }
                else
                {
                    [marrTitles addObject:@"."];
                }
            }
        
		}
        else
        {
            if ([strValue length] > 0) {
                [marrGuides addObject:strValue];
                if (nIdx == 1) {
                    [marrTitles addObject:@"이자율등 변동"];
                }
                else if (nIdx == 2) {
                    [marrTitles addObject:@"여신한도약정 수수료"];
                }
                else if (nIdx == 3) {
                    [marrTitles addObject:@"이자 및 지연배상금 계산방법"];
                }
                else if (nIdx == 4) {
                    [marrTitles addObject:@"대출 실행방법"];
                }
                else if (nIdx == 5) {
                    [marrTitles addObject:@"상환방법"];
                }
                else if (nIdx == 6) {
                    [marrTitles addObject:@"이자 지급방법"];
                }
                else
                {
                    [marrTitles addObject:@"."];
                }
            }
        }
	}
	
	NSInteger nCount = 0;
	for (NSString *strGuide in marrGuides)
	{
		UIImageView *ivBullet = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bullet_2"]]autorelease];
		[ivBullet setFrame:CGRectMake(5, fHeight+4, 7, 7)];
		[ivInfoBox addSubview:ivBullet];
		
		NSString *strTitle = [marrTitles objectAtIndex:nCount];
		CGSize size = [strTitle sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(284, 999) lineBreakMode:NSLineBreakByCharWrapping];
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(5+7+3, fHeight, 284, size.height)]autorelease];
		[lblTitle setNumberOfLines:0];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setFont:[UIFont systemFontOfSize:14]];
		[lblTitle setText:strTitle];
		[ivInfoBox addSubview:lblTitle];
		fHeight += size.height;
		
		size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(284, 999) lineBreakMode:NSLineBreakByCharWrapping];
		UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(5+7+3, fHeight, 284, size.height)]autorelease];
		[lblGuide setNumberOfLines:0];
		[lblGuide setBackgroundColor:[UIColor clearColor]];
		[lblGuide setTextColor:RGB(114, 114, 114)];
		[lblGuide setFont:[UIFont systemFontOfSize:13]];
		[lblGuide setText:strGuide];
		[ivInfoBox addSubview:lblGuide];
		
		fHeight += size.height + (strGuide == [marrGuides lastObject] ? 10 : 18);
		
		nCount++;
	}
	
	[ivInfoBox setFrame:CGRectMake(3, fCurrHeight += 10, 311, fHeight)];
	fCurrHeight += fHeight;

	UILabel *lbl2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 301, 33)]autorelease];
	[lbl2 setBackgroundColor:[UIColor clearColor]];
	[lbl2 setTextColor:RGB(40, 91, 142)];
	[lbl2 setFont:[UIFont systemFontOfSize:15]];
	[lbl2 setText:@"제2조 지연 배상금"];
	[self.contentScrollView addSubview:lbl2];
	fCurrHeight+=33;
	
//	{
//		UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=10, 317, 1)]autorelease];
//		[lineView setBackgroundColor:RGB(209, 209, 209)];
//		[self.contentScrollView addSubview:lineView];
//		fCurrHeight+=1;
//		
//		UIView *vTitle = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 317, 33)]autorelease];
//		[vTitle setBackgroundColor:RGB(244, 244, 244)];
//		[self.contentScrollView addSubview:vTitle];
//		
//		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 301, 33)]autorelease];
//		[lbl setBackgroundColor:[UIColor clearColor]];
//		[lbl setTextColor:RGB(40, 91, 142)];
//		[lbl setFont:[UIFont systemFontOfSize:14]];
//		[lbl setText:@"제2조 지연 배상금"];
//		[vTitle addSubview:lbl];
//		
//		UIView *lineView1 = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight+=33, 317, 1)]autorelease];
//		[lineView1 setBackgroundColor:RGB(209, 209, 209)];
//		[self.contentScrollView addSubview:lineView1];
//		fCurrHeight+=1;
//	}
	
	{
		UIImage *image = [UIImage imageNamed:@"box_consent.png"];
		UIImageView *ivStipulationBG = [[[UIImageView alloc]initWithImage:[image stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
		[ivStipulationBG setBackgroundColor:[UIColor clearColor]];
		[ivStipulationBG setFrame:CGRectMake(8, fCurrHeight, 300, 2 * kRowHeight)];
		[ivStipulationBG setUserInteractionEnabled:YES];
		[self.contentScrollView addSubview:ivStipulationBG];
		
		SHBLoanSecurityStipulationView *stipulationView = [[[SHBLoanSecurityStipulationView alloc]initWithFrame:CGRectMake(0, 0, 300, 2*kRowHeight)]autorelease];
		[stipulationView setParentViewController:self];
		[ivStipulationBG addSubview:stipulationView];
		fCurrHeight += 2*kRowHeight;
	}
	
	[self setSecretMediaView];
	[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fCurrHeight)];
	[self.contentScrollView flashScrollIndicators];
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
        if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
        {
            vc.nextSVC =  @"L1312";
        }
        else
        {
             vc.nextSVC =  @"L1411";
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
        if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
        {
            vc.nextSVC =  @"L1312";
        }
        else
        {
            vc.nextSVC =  @"L1411";
        }
		
		self.otpViewController = vc;
    }
}

#pragma mark - Action
- (void)seeBtnAction:(UIButton *)sender {
    NSString *strUrl;
    if (!AppInfo.realServer) {
        strUrl = [NSString stringWithFormat:@"%@yak_delaycompensation.html", URL_YAK_TEST];
	}
    else{
        strUrl = [NSString stringWithFormat:@"%@yak_delaycompensation.html", URL_YAK];
     }
	SHBNewProductSeeStipulationViewController *viewController = [[[SHBNewProductSeeStipulationViewController alloc]initWithNibName:@"SHBNewProductSeeStipulationViewController" bundle:nil]autorelease];
    viewController.strName = @"예적금담보대출";
	viewController.strUrl = strUrl;
	[self checkLoginBeforePushViewController:viewController animated:YES];
}

- (void)stipulationItemPressed:(UITapGestureRecognizer *)sender
{
	Debug(@"sender : %@", sender);
	Debug(@"sender.view.tag : %d", sender.view.tag);
	// 각 약관 눌렀을때의 처리 구현 : 안할기로 함
}

- (IBAction)confirmBtnAction:(SHBButton *)sender {
}

- (IBAction)cancelBtnAction:(SHBButton *)sender {
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBLoanInfoViewController class]]) {
			[self.navigationController popToViewController:viewController animated:YES];
		}
	}
}

#pragma mark - SHBSecretCard Delegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
	Debug(@"confirmSecretData:%@", confirmData);
    Debug(@"confirmSecretResult:%i", confirm);
    Debug(@"confirmSecretMedia:%i", mediaType);
	
	if (confirm == 1) {
		//NSString *str = [AppInfo.ssn substringToIndex:6];
        //NSString *str = [[AppInfo getPersonalPK] substringToIndex:6];
		//NSString *str1 = [NSString stringWithFormat:@"%@*******", str];
		
		AppInfo.electronicSignString = @"";
		AppInfo.eSignNVBarTitle = @"예적금담보대출";
		
		
		AppInfo.electronicSignTitle = @"예금담보대출 신청";
		

		[AppInfo addElectronicSign:@"[내용]"];
        
        
        
        if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
        {
            AppInfo.electronicSignCode = @"L1312";
            [AppInfo addElectronicSign:@"예금담보대출 건별거래를 신청합니다."];
        }
        else{
            AppInfo.electronicSignCode = @"L1411";
            [AppInfo addElectronicSign:@"예금담보대출 한도거래를 신청합니다."];
        }
		
		[AppInfo addElectronicSign:@"다음 사항을 충분히 이해하고 본인"];
		[AppInfo addElectronicSign:@"신용정보의 제공 및 조회에 동의하며"];
		[AppInfo addElectronicSign:@"약정합니다."];
		[AppInfo addElectronicSign:@"1.은행여신거래기본약관(통장한도거래"];
		[AppInfo addElectronicSign:@"대출 및 가계당좌 대출의 경우 관련 "];
		[AppInfo addElectronicSign:@"수신거래약관 포함)이 적용됨을 승인하고"];
		[AppInfo addElectronicSign:@"본 약관 및 대출거래약정서(가계용)의 "];
		[AppInfo addElectronicSign:@"모든 내용에 대하여 충분히 이해하였음."];
		[AppInfo addElectronicSign:@"2.개인신용정보의 제공,조회 동의"];
        [AppInfo addElectronicSign:@"3.가계대출 상품 설명서를 통한 필수 안내 사항인 비용, 금리 등 충분한 설명 및 교부를 받았습니다."];
		[AppInfo addElectronicSign:@"4.신청내용"];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)성명: %@", [self.L1311 objectForKey:@"고객명"]]];
		//[AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)실명번호: %@", str1]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)실명번호: %@", [self.userItem objectForKey:@"실명번호"]]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)고객ID: %@", AppInfo.customerNo]];
        
        if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
        {
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)신청정보: %@", @"예적금담보대출 건별거래 신규"]];
        }
        else
        {
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)신청정보: %@", @"예적금담보대출 한도거래 신규"]];
        }
		
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)담보계좌: %@", [self.userItem objectForKey:@"담보계좌번호출력용"]]];
        if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
        {
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)입금계좌: %@", self.strTmp1]];
        }
        else
        {
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)대출계좌: %@", self.strTmp1]];
        }
		
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(9)대출금액: %@", self.strTmp2]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(10)대출금리: %@", self.strTmp3]];
        
		if ([self.strTmp4 isEqualToString:@"0원"]) {
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)인지세: 0원"]];
		}
		else
		{
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(11)인지세: %@", self.strTmp4]];
		}

               
		if ([[self.userItem objectForKey:@"대출용도출력용"] isEqualToString:@"기타(세부자금용도 직접입력)"]) {
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(12)대출용도: 기타(%@)", [self.userItem objectForKey:@"금감원자금용도기타내용"]]];
		}
		else
		{
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(12)대출용도: %@", [self.userItem objectForKey:@"대출용도출력용"]]];
		}
		
		[self.userItem setObject:self.strTmp4 forKey:@"인지세출력용"];

        
        
        if ([AppInfo.commonLoanDic[@"_대출타입"] isEqualToString:@"A"])
        {
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                       @"고객번호" : AppInfo.customerNo,
                       @"반복횟수" : @"1",
                       @"담보계좌번호" : [self.userItem objectForKey:@"담보계좌번호"],
                       @"담보계좌비밀번호" : [self.userItem objectForKey:@"담보계좌비밀번호"],
                       @"담보계좌은행구분" : [self.userItem objectForKey:@"담보계좌은행코드"],
                       @"대출신청금액" : [self.userItem objectForKey:@"대출신청금액"],
                       @"업무구분" : @"10",
                       @"입금계좌번호" : [self.userItem objectForKey:@"입금계좌번호"],
                       @"입금계좌번호은행구분" : [self.userItem objectForKey:@"입금계좌은행코드"],
                       @"금감원자금용도코드" : [self.userItem objectForKey:@"금감원자금용도코드"],
                       }];
            
            if ([[self.userItem objectForKey:@"대출용도출력용"] isEqualToString:@"기타(세부자금용도 직접입력)"])
            {
                [dataSet insertObject:[self.userItem objectForKey:@"금감원자금용도기타내용"] forKey:@"금감원자금용도기타내용" atIndex:0];
                
            }
            else
            {
                [dataSet insertObject:@"" forKey:@"금감원자금용도기타내용" atIndex:0];
                
            }
            
            if ([[self.userItem objectForKey:@"권유자"]length]) {
                [dataSet insertObject:[self.userItem objectForKey:@"권유자"] forKey:@"권유직원번호" atIndex:0];
            }
            
            self.service = [[[SHBProductService alloc]initWithServiceId:kL1312Id viewController:self]autorelease];
            self.service.requestData = dataSet;
            [self.service start];
            
        }
        
        else{
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                            @"고객번호" : AppInfo.customerNo,
                            @"업무구분" : @"10",
                            @"반복횟수" : @"1",
                            @"담보계좌번호" : [self.userItem objectForKey:@"담보계좌번호"],
                            @"담보계좌비밀번호" : [self.userItem objectForKey:@"담보계좌비밀번호"],
                            @"은행구분" : @"1",
                            @"한도은행구분" : [self.userItem objectForKey:@"담보계좌은행코드"],
                            @"대출신청금액" : [self.userItem objectForKey:@"대출신청금액"],
                            @"한도대출등록계좌" : [self.userItem objectForKey:@"입금계좌번호"],
                            @"금감원자금용도CODE" : [self.userItem objectForKey:@"금감원자금용도코드"],
                            }];
            if ([[self.userItem objectForKey:@"대출용도출력용"] isEqualToString:@"기타(세부자금용도 직접입력)"])
            {
                 [dataSet insertObject:[self.userItem objectForKey:@"금감원자금용도기타내용"] forKey:@"금감원자금용도기타내용" atIndex:0];
                
            }
            else
            {
                [dataSet insertObject:@"" forKey:@"금감원자금용도기타내용" atIndex:0];

            }
            
            if ([[self.userItem objectForKey:@"권유자"]length]) {
                [dataSet insertObject:[self.userItem objectForKey:@"권유자"] forKey:@"권유직원번호" atIndex:0];
            }
            
            self.service = [[[SHBProductService alloc]initWithServiceId:kL1411Id viewController:self]autorelease];
            self.service.requestData = dataSet;
            [self.service start];
        }
        
        
        
		
	}
}



- (void)cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoanSecurityConfirmCancel"
                                                        object:nil];
}


#pragma mark - Notification
- (void)getElectronicSignResult:(NSNotification *)noti
{
	Debug(@"[noti userInfo] : %@", [noti userInfo]);
	if (!AppInfo.errorType) {
		
		SHBLoanEndViewController *viewController = [[SHBLoanEndViewController alloc]initWithNibName:@"SHBLoanEndViewController" bundle:nil];
		viewController.userItem = self.userItem;
		viewController.L1312 = [noti userInfo];
		viewController.needsLogin = YES;
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
	}
}

- (void)getElectronicSignCancel
{
	Debug(@"getElectronicSignCancel");
    [self.navigationController fadePopToViewController:[self.navigationController.viewControllers objectAtIndex:1]];
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
	if (self.service.serviceId == XDA_S00001_3)
	{
		Debug(@"aDataSet : %@", aDataSet);
		
		self.data = aDataSet;
		[self setUI];
	}
    
    else if (self.service.serviceId == XDA_S00001_6)
	{
		Debug(@"aDataSet : %@", aDataSet);
        self.data = aDataSet;
		[self setUI];
    }
	
	return NO;
}
@end
