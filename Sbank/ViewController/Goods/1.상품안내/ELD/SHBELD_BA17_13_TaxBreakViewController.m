//
//  SHBELD_BA17_13_TaxBreakViewController.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 6. 3..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBELD_BA17_13_TaxBreakViewController.h"
#import "SHBProductService.h"
#import "SHBNewProductRegTopView.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductListViewController.h"
#import	"SHBNewProductReInputNotiPopupView.h"
#import "SHBELD_BA17_14_SignUpViewController.h"
#import "SHBELD_BA17_11ViewController.h"
#import "SHBUtility.h"
#import "SHBNewProductStipulationViewController.h"
#import "SHBListPopupView.h" // list popup
#import "SHBPopupView.h" // popup

@interface SHBELD_BA17_13_TaxBreakViewController ()
<SHBListPopupViewDelegate>
{
	CGFloat fCurrHeight;
	
	// 예외처리용
	BOOL tax;				// 세금우대
	int taxval;				// 0:일반과세, 1:세금우대, 2:비과세(생계형)
    int type;               // 1:이자지급식, 3:만기일시지급식
    int mailnoti;           // 9:미통보, 3:e-mail
    
	BOOL isSendTaxFree;		// D4222 전문을 보냈는지?
	BOOL tax_On;			// taxval이 0이나 1일때 YES
    
    
    BOOL mon_check;				// 이자지급주기 여부
	
	NSInteger nTextFieldTag;
    SHBButton *b_mon;
    
    UILabel *lblEmail;
    UILabel *lblEmailText;
    NSString *email;
}

@property (nonatomic, retain) NSMutableArray *marrTaxRadioBtns;				// 세금우대관련 라디오버튼
@property (nonatomic, retain) NSMutableArray *marrTypeRadioBtns;				// 이자지급방법 라디오버튼
@property (nonatomic, retain) NSMutableArray *marrMonRadioBtns;				// 이자지급주기 라디오버튼
@property (nonatomic, retain) NSMutableArray *marrEmailRadioBtns;				// 이자 수익률통보 라디오버튼
@property (nonatomic, retain) SHBNewProductReInputNotiPopupView *popupView;	// 자동재예치 결과통지 팝업뷰
@property (retain, nonatomic) NSMutableArray *monList; // 지급주기
@property (retain, nonatomic) NSMutableDictionary *selectMonDic; // 선택된 지급주기


@end

@implementation SHBELD_BA17_13_TaxBreakViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		tax = NO;

		tax_On = NO;

		taxval = -1;
        type = -1;
        mailnoti = -1;
        
        mon_check = NO;

		
		nTextFieldTag = 222000;
    }
    return self;
}



- (void)dealloc {

	[_lblTopRow1Value release];
	[_lblTopRow2Value release];
	[_D4222 release];
	[_userItem release];
	[_marrTaxRadioBtns release];

	[_tfTaxBreakAmount release];
	[_D3602 release];
	[_D4220 release];
    [_D6115 release];
	[_dicSelectedData release];
	[_mdicPushInfo release];
	[_bottomBackView release];
	[super dealloc];
}

- (void)viewDidUnload {

	self.lblTopRow1Value = nil;
	self.lblTopRow2Value = nil;

    //	self.tfAutoTransEndDate = nil;
    //	self.tfAutoTransStartDate = nil;
	self.tfTaxBreakAmount = nil;
	[self setBottomBackView:nil];
	[super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예금/적금 가입"];
    
        
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	
	
	[self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 가입", [self.dicSelectedData objectForKey:@"상품한글명"]] maxStep:5 focusStepNumber:3]autorelease]];
	
	SHBNewProductRegTopView *topView = [[[SHBNewProductRegTopView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 320, 34*2) parentViewController:self]autorelease];
	[self.contentScrollView addSubview:topView];
	fCurrHeight += 34*2;
	   
    
    
    self.monList = [NSMutableArray arrayWithArray:
                     @[
                     @{ @"1" : @"1개월", @"code" : @"1", },
                     @{ @"1" : @"2개월", @"code" : @"2", },
                     @{ @"1" : @"3개월", @"code" : @"3", },
                     @{ @"1" : @"6개월", @"code" : @"6", },
                     ]];
    
    self.selectMonDic = _monList[0];
    

	if ([[self.dicSelectedData objectForKey:@"세금우대가능여부"]isEqualToString:@"1"])
   {
		
       // 처음 전문을 보낼때 Error가 발생하면 이전 화면으로 이동 한다.
       AppInfo.isNeedBackWhenError = YES;
       
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   //@"주민번호" : AppInfo.ssn,
                               //@"주민번호" : [AppInfo getPersonalPK],
                              @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                              @"세금우대_D4222저축종류" : @"41",  // @"세금우대_D4222저축종류"]값 없으므로 41 값 고정하기로함
                              
							  // @"세금우대_D4222저축종류" : [self.dicSelectedData objectForKey:@"세금우대_D4222저축종류"],
							   }];
		self.service = [[[SHBProductService alloc]initWithServiceId:kD4220Id viewController:self]autorelease];
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
- (void)setTaxView
{
	fCurrHeight += 10;
	UILabel *lblTitle1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 317-8, 21)]autorelease];
	[lblTitle1 setBackgroundColor:[UIColor clearColor]];
	[lblTitle1 setTextColor:RGB(74, 74, 74)];
	[lblTitle1 setFont:[UIFont systemFontOfSize:15]];
	[lblTitle1 setText:@"세금우대관련"];
	[self.contentScrollView addSubview:lblTitle1];
	fCurrHeight += 30;
	
	taxval = 0;
	NSMutableArray *marrRadios = [NSMutableArray array];
    
	[marrRadios addObject:@"일반과세"];
    [marrRadios addObject:@"세금우대"];
    [marrRadios addObject:@"비과세(생계형)"];
    
	self.marrTaxRadioBtns = [NSMutableArray array];
	for (int nIdx = 0; nIdx < [marrRadios count]; nIdx++) {
		UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
		[btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
		[btnRadio addTarget:self action:@selector(taxRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentScrollView addSubview:btnRadio];
		[btnRadio setDataKey:[marrRadios objectAtIndex:nIdx]];
		[self.marrTaxRadioBtns addObject:btnRadio];
		
		UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
		[lblRadio setBackgroundColor:[UIColor clearColor]];
		[lblRadio setTextColor:RGB(74, 74, 74)];
		[lblRadio setFont:[UIFont systemFontOfSize:14]];
		[lblRadio setText:[marrRadios objectAtIndex:nIdx]];
		[self.contentScrollView addSubview:lblRadio];
		
		if (nIdx == 0) {
			[btnRadio setFrame:CGRectMake(8, fCurrHeight, 21, 21)];
			[btnRadio setSelected:YES];
		}
		else if (nIdx == 1) {
			[btnRadio setFrame:CGRectMake(320-3-8-200, fCurrHeight, 21, 21)];
		}
		else if (nIdx == 2) {
			[btnRadio setFrame:CGRectMake(204, fCurrHeight, 21, 21)];
		}
		
		[lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, fCurrHeight, 84, 21)];
	}
    
	fCurrHeight += 30;
    
    
	
}

- (void)setTaxGuideView
{
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[self.contentScrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 5;
	
	NSMutableArray *marrGuides = [NSMutableArray array];
	for (int nIdx = 1; nIdx <= 10; nIdx ++) {
		NSString *strKey = [NSString stringWithFormat:@"메시지%d", nIdx];
		NSString *strValue  = [self.D3602 objectForKey:strKey];
		NSString *strValue1 = [strValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
		
		if ([strValue1 length] > 0) {
			[marrGuides addObject:strValue1];
		}
	}
    
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
}


- (void)setTypeView
{
	fCurrHeight += 10;
	UILabel *lblTitle2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 317-8, 21)]autorelease];
	[lblTitle2 setBackgroundColor:[UIColor clearColor]];
	[lblTitle2 setTextColor:RGB(74, 74, 74)];
	[lblTitle2 setFont:[UIFont systemFontOfSize:15]];
	[lblTitle2 setText:@"이자지급방법"];
	[self.contentScrollView addSubview:lblTitle2];


    
    
    if ([[self.dicSelectedData objectForKey:@"이자지급방법"]isEqualToString:@"3"])
    {
        UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
		[lblRadio setBackgroundColor:[UIColor clearColor]];
		[lblRadio setTextColor:RGB(74, 74, 74)];
		[lblRadio setFont:[UIFont systemFontOfSize:14]];
		[lblRadio setText:@"만기일시지급식"];
		[lblRadio setFrame:CGRectMake(126, fCurrHeight, 150, 21)];
        [self.contentScrollView addSubview:lblRadio];
        fCurrHeight += 30;
        
        type =3;
       
    }
    
    else
    {
       type =3;
    
        NSMutableArray *marrRadios = [NSMutableArray array];
       
        [marrRadios addObject:@"만기일시지급식"];
        [marrRadios addObject:@"이자지급식"];
    
        self.marrTypeRadioBtns = [NSMutableArray array];
        for (int nIdx = 0; nIdx < [marrRadios count]; nIdx++)
        {
            UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
            [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
            [btnRadio addTarget:self action:@selector(typeRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentScrollView addSubview:btnRadio];
            [btnRadio setDataKey:[marrRadios objectAtIndex:nIdx]];
            [self.marrTypeRadioBtns addObject:btnRadio];
		
            UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
            [lblRadio setBackgroundColor:[UIColor clearColor]];
            [lblRadio setTextColor:RGB(74, 74, 74)];
            [lblRadio setFont:[UIFont systemFontOfSize:14]];
            [lblRadio setText:[marrRadios objectAtIndex:nIdx]];
            [self.contentScrollView addSubview:lblRadio];
		
            if (nIdx == 0) {
                [btnRadio setFrame:CGRectMake(100, fCurrHeight, 21, 21)];
                [lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, fCurrHeight, 100, 21)];
                [btnRadio setSelected:YES];

            }
            else if (nIdx == 1) {
                [btnRadio setFrame:CGRectMake(100, fCurrHeight+30, 21, 21)];
                [lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, fCurrHeight+30, 80, 21)];
               
            }
            
        }
        
        if ([self.mdicPushInfo[@"_스마트신규이자지급방법"] isEqualToString:@"1"]) {
            
            // 이자지급식
            
            [self.marrTypeRadioBtns[0] setSelected:NO];
            [self.marrTypeRadioBtns[1] setSelected:YES];
            
            mon_check =YES;
            type = 1;
        }
        
        fCurrHeight += 60;
        [self setMonView];  // 이자지급식일때만 이자지급주기 ui 나옴
    }
       
}



- (void)setMonView
{
    fCurrHeight += 10;

	UILabel *lblTitle3 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 100, 21)]autorelease];
	[lblTitle3 setBackgroundColor:[UIColor clearColor]];
	[lblTitle3 setTextColor:RGB(74, 74, 74)];
	[lblTitle3 setFont:[UIFont systemFontOfSize:15]];
	[lblTitle3 setText:@"이자지급주기"];
	[self.contentScrollView addSubview:lblTitle3];

	
	b_mon = [SHBButton buttonWithType:UIButtonTypeCustom];
	[b_mon setFrame:CGRectMake(100, fCurrHeight, 150, 29)];
	[b_mon setBackgroundImage:[UIImage imageNamed:@"selectbox2_nor.png"] forState:UIControlStateNormal];
	[b_mon setBackgroundImage:[UIImage imageNamed:@"selectbox2_focus.png"] forState:UIControlStateHighlighted];
    [b_mon setBackgroundImage:[UIImage imageNamed:@"selectbox2_dim.png"] forState:UIControlStateDisabled];
	[b_mon.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [b_mon setTitleColor:RGB(44, 44, 44) forState:UIControlStateNormal];
    [b_mon setTitleColor:RGB(198, 198, 198) forState:UIControlStateDisabled];
	[b_mon setTitle:@"선택하세요" forState:UIControlStateNormal];
    [b_mon setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [b_mon setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    [b_mon setEnabled:NO];
	[b_mon addTarget:self action:@selector(monRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.contentScrollView addSubview:b_mon];
	
    fCurrHeight += 30;
    
    if ([self.mdicPushInfo[@"_스마트신규이자지급방법"] isEqualToString:@"1"]) {
        
        // 이자지급식 !@#$
        
        for (NSMutableDictionary *dic in self.monList) {
            
            if ([dic[@"code"] isEqualToString:self.mdicPushInfo[@"_스마트신규지급주기"]]) {
                
                self.selectMonDic = dic;
                
                [b_mon setEnabled:YES];
                [b_mon setTitle:self.selectMonDic[@"1"] forState:UIControlStateNormal];
                
                break;
            }
        }
    }
}



- (void)setEmailView
{
    
    fCurrHeight += 10;
	UILabel *lblTitle4 = [[[UILabel alloc]initWithFrame:CGRectMake(8, fCurrHeight, 100, 36)]autorelease];
	[lblTitle4 setBackgroundColor:[UIColor clearColor]];
	[lblTitle4 setTextColor:RGB(74, 74, 74)];
	[lblTitle4 setFont:[UIFont systemFontOfSize:15]];
	[lblTitle4 setText:@"지수수익률표\n통보"];
    lblTitle4.numberOfLines=2;
	[self.contentScrollView addSubview:lblTitle4];
    //fCurrHeight += 30;
	
	 mailnoti = 9;

    
    NSMutableArray *marrRadios = [NSMutableArray array];
    
    [marrRadios addObject:@"미통보"];
    [marrRadios addObject:@"E-mail"];
    
    self.marrEmailRadioBtns = [NSMutableArray array];
    for (int nIdx = 0; nIdx < [marrRadios count]; nIdx++)
    {
        UIButton *btnRadio = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_off"] forState:UIControlStateNormal];
        [btnRadio setBackgroundImage:[UIImage imageNamed:@"radio_on"] forState:UIControlStateSelected];
        [btnRadio addTarget:self action:@selector(mailRadioBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScrollView addSubview:btnRadio];
        [btnRadio setDataKey:[marrRadios objectAtIndex:nIdx]];
        [self.marrEmailRadioBtns addObject:btnRadio];
		
        UILabel *lblRadio = [[[UILabel alloc]init]autorelease];
        [lblRadio setBackgroundColor:[UIColor clearColor]];
        [lblRadio setTextColor:RGB(74, 74, 74)];
        [lblRadio setFont:[UIFont systemFontOfSize:14]];
        [lblRadio setText:[marrRadios objectAtIndex:nIdx]];
        [self.contentScrollView addSubview:lblRadio];
		
        
        
        if (nIdx == 0) {
            [btnRadio setFrame:CGRectMake(100, fCurrHeight, 21, 21)];
            [btnRadio setSelected:YES];
            [lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, fCurrHeight, 80, 21)];
        }
        else if (nIdx == 1)
        {
            [btnRadio setFrame:CGRectMake(100, fCurrHeight, 21, 21)];
            [lblRadio setFrame:CGRectMake(left(btnRadio)+21+5, fCurrHeight, 80, 21)];
            
            lblEmail= [[UILabel alloc]init];
            [lblEmail setBackgroundColor:[UIColor clearColor]];
            [lblEmail setTextColor:RGB(74, 74, 74)];
            [lblEmail setFont:[UIFont systemFontOfSize:14]];
            
             email = [self.D6115 objectForKey:@"이메일"];
            if ([email  isEqualToString:@""]) {
                
                [lblEmail setText:@""];
                [lblEmailText setText:@""];
                
            }
            else{
                 [lblEmail setText:[NSString stringWithFormat:@"***%@",[email substringFromIndex:3]]];
            }
            
          
           
           // [lblEmail setText:[NSString stringWithFormat:@"%@", [self.D6115 objectForKey:@"이메일"]]];
            [lblEmail setFrame:CGRectMake(left(btnRadio)+30, fCurrHeight+20, 150, 21)];
           // [self.contentScrollView addSubview:lblEmail];
            
            
            NSString *mailtext = @"통보받으실 이메일 주소를 확인하여 주시기 바라며, 다를경우는 영업점이나 인터넷뱅킹에서 변경 바랍니다.";
            lblEmailText= [[UILabel alloc]init];
            [lblEmailText setBackgroundColor:[UIColor clearColor]];
            [lblEmailText setTextColor:RGB(74, 74, 74)];
            [lblEmailText setFont:[UIFont systemFontOfSize:12]];
            [lblEmailText setText:mailtext];
            [lblEmailText setFrame:CGRectMake(8, fCurrHeight+35, 300, 50)];
            lblEmailText.numberOfLines=3;
           // [self.contentScrollView addSubview:lblEmailText];
            
        }
                
        fCurrHeight += 30;
    }
    
   fCurrHeight += 40;

}

- (void)setBottomView
{
	// 확인/취소 버튼 및 스크롤뷰 컨텐트사이즈
	[self.bottomBackView setHidden:NO];
	FrameReposition(self.bottomBackView, 0, fCurrHeight += 12);
	fCurrHeight += 30;
	
    
	[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fCurrHeight+=12)];
	[self.contentScrollView flashScrollIndicators];
	
	contentViewHeight = contentViewHeight > fCurrHeight ? contentViewHeight : fCurrHeight;
    
    startTextFieldTag = 222000;
    endTextFieldTag = nTextFieldTag;
}


// 비과세(생계형) 라디오버튼 선택시에는 전문을 통해 새로 데이터를 가져오네
- (void)taxFreeOn
{
	for (UIButton *btn in self.marrTaxRadioBtns)
	{
		[btn setSelected:NO];
		
		if ([btn.dataKey isEqualToString:@"비과세(생계형)"]) {
			[btn setSelected:YES];
		}
	}
	
	taxval = 2;
	
	[self.lblTopRow1Title setText:@"비과세(생계형)가입총액"];
	[self.lblTopRow2Title setText:@"비과세(생계형)한도잔여"];
	
	[self.lblTopRow1Value setText:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[self.D4222 objectForKey:@"저축종류별가입금액"]]]];
	[self.lblTopRow2Value setText:[NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[self.D4222 objectForKey:@"저축종류별미사용금액"]]]];
	
	tax_On = NO;
	isSendTaxFree = YES;
	[self.tfTaxBreakAmount setEnabled:YES];
	[self.tfTaxBreakAmount setText:nil];
}


#pragma mark - SHBListPopupView

- (void)listPopupView:(SHBListPopupView *)listPopView didSelectedIndex:(NSInteger)anIndex
{
    self.selectMonDic = _monList[anIndex];
    
   //  [_b_mon setTitle:_selectMonDic[@"1"]];
    [b_mon setTitle:_selectMonDic[@"1"] forState:UIControlStateNormal];
}


#pragma mark - Action
- (void)taxRadioBtnAction:(UIButton *)sender
{
	NSString *dataKey = sender.dataKey;
	Debug(@"dataKey : %@", dataKey);
    
    for (UIButton *btn in self.marrTaxRadioBtns)
	{
		[btn setSelected:NO];
	}
	
	[sender setSelected:YES];
    
    
    
	if ([dataKey isEqualToString:@"일반과세"]) {
		[self.lblTopRow1Title setText:@"세금우대가입총액"];
		[self.lblTopRow2Title setText:@"세금우대한도잔여"];
		
		[self.lblTopRow1Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대가입총액"]]];
		[self.lblTopRow2Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대한도잔액"]]];
		
		taxval = 0;
		
		[self.tfTaxBreakAmount setEnabled:NO];
		[self.tfTaxBreakAmount setText:nil];
	}
	else if ([dataKey isEqualToString:@"세금우대"]) {
		
		
        if ([[[self.userItem objectForKey:@"신규금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] >
				[[[self.D4220 objectForKey:@"세금우대한도잔액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] ) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																message:@"신규금액은 세금우대한도잔여액을 초과할 수 없습니다."
															   delegate:nil
													  cancelButtonTitle:@"확인"
													  otherButtonTitles:nil];
				[alert show];
				[alert release];
                [sender setSelected:NO];
                [[self.marrTaxRadioBtns objectAtIndex:0]setSelected:YES];
				return;
			}
		
		
	
		[self.lblTopRow1Title setText:@"세금우대가입총액"];
		[self.lblTopRow2Title setText:@"세금우대한도잔여"];
		
		[self.lblTopRow1Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대가입총액"]]];
		[self.lblTopRow2Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대한도잔액"]]];
		
		taxval = 1;
		
		[self.tfTaxBreakAmount setEnabled:YES];
		[self.tfTaxBreakAmount setText:nil];
		
	}
	else if ([dataKey isEqualToString:@"비과세(생계형)"]) {
        
        
     	        
        
        if (isSendTaxFree == NO) {	// D4222 전문을 보내지 않았으면
            //D4222 전문을 보냄
			self.service = [[[SHBProductService alloc]initWithServiceId:kD4222Id viewController:self]autorelease];
			self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{
										//@"주민번호" : AppInfo.ssn,
                                        //@"주민번호" : [AppInfo getPersonalPK],
                                        @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
										@"저축종류" : @"41",
										}];
			[self.service start];
            
            return;
        }
        else{
            [self taxFreeOn];
			return;
        }
        
	}
	
  
}
- (void)typeRadioBtnAction:(UIButton *)sender
{
	for (UIButton *btn in self.marrTypeRadioBtns)
	{
		
        [btn setSelected:NO];
        
        if([sender.dataKey isEqualToString:@"이자지급식"])
        {
            [b_mon setEnabled:YES];
            mon_check =YES;
            type = 1;
        }
        else
        {
            [b_mon setEnabled:NO];
            mon_check =NO;
            [b_mon setTitle:@"선택하세요" forState:UIControlStateNormal];
             type = 3;
        }
	}
	
	[sender setSelected:YES];
}

- (void)monRadioBtnAction:(UIButton *)sender
{
  
    
    SHBListPopupView *popupView = [[[SHBListPopupView alloc] initWithTitle:@"이자지급주기"
                                                                   options:_monList
                                                                   CellNib:@"SHBExchangePopupCell"
                                                                     CellH:32
                                                               CellDispCnt:4
                                                                CellOptCnt:1] autorelease];
    [popupView setDelegate:self];
    [popupView showInView:self.navigationController.view animated:YES];
    
}





- (void)mailRadioBtnAction:(UIButton *)sender
{
	for (UIButton *btn in self.marrEmailRadioBtns)
	{
		 
        
        if([sender.dataKey isEqualToString:@"E-mail"])
        {
            
            if ([email  isEqualToString:@""] || [[self.D6115 objectForKey:@"이메일금지여부"] isEqualToString:@"1"])
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                         message:@"고객원장에 이메일주소가 등록되어 있지 않습니다. 인터넷뱅킹 또는 영업점 방문을 통하여 이메일주소를 등록하여 주시기 바랍니다."
                                                         delegate: nil
                                                        cancelButtonTitle:@"확인"
                                                        otherButtonTitles:nil];
                [alert show];
                [alert release];
                
                [btn setSelected:YES];
                [sender setSelected:NO];
                 mailnoti=9;
                
                return;

            }
        }
        
          [btn setSelected:NO];

	}
    
     [sender setSelected:YES];
    
     if([sender.dataKey isEqualToString:@"E-mail"])
    {
       
        [self.contentScrollView addSubview:lblEmail];
        [self.contentScrollView addSubview:lblEmailText];
        
        mailnoti=3;
        
    }
        
    
    else if ([sender.dataKey isEqualToString:@"미통보"])
    {

        [lblEmail removeFromSuperview];
         [lblEmailText removeFromSuperview];
        
         mailnoti=9;
        
    }
   
}


- (IBAction)confirmBtnAction:(SHBButton *)sender
{
	// TODO: 입력값 예외처리
    

	if (tax)
    {
		[self.userItem setObject:[NSString stringWithFormat:@"%d",taxval] forKey:@"세금우대"];

		 ///////////세금우대 입력이 없는 경우
			if (taxval == 1) {
				if ([[[self.userItem objectForKey:@"신규금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] >
					[[[self.D4220 objectForKey:@"세금우대한도잔액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue]) {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																	message:@"신규금액이 한도잔여액을 초과하였습니다."
																   delegate: nil
														  cancelButtonTitle:@"확인"
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
					return;
				}
			}
			else if (taxval == 2)
            {
				if ([[[self.userItem objectForKey:@"신규금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] >
					[[[self.D4222 objectForKey:@"저축종류별미사용금액"] stringByReplacingOccurrencesOfString:@"," withString:@""] longLongValue] )
                {
					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
																	message:@"신규금액은 비과세(생계형)한도 잔여액을 초과할 수 없습니다."
																   delegate:nil
														  cancelButtonTitle:@"확인"
														  otherButtonTitles:nil];
					[alert show];
					[alert release];
                   
					return;
				}
				
				
			}
			
			
		}
		
    
    if (mon_check ==YES)
    {
        if( [b_mon.titleLabel.text isEqualToString:@"선택하세요"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"이자지급주기를 선택하여 주십시오."
                                                           delegate:nil
                                                  cancelButtonTitle:@"확인"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;

        }
    }
    
  
        
     if( [b_mon.titleLabel.text isEqualToString:@"1개월"])
     {
         [self.userItem setObject:[NSString stringWithFormat:@"1"] forKey:@"지급주기"];
     }
     else if( [b_mon.titleLabel.text isEqualToString:@"2개월"])
     {
         [self.userItem setObject:[NSString stringWithFormat:@"2"] forKey:@"지급주기"];
     }
     else if( [b_mon.titleLabel.text isEqualToString:@"3개월"])
     {
         [self.userItem setObject:[NSString stringWithFormat:@"3"] forKey:@"지급주기"];
     }
     else if( [b_mon.titleLabel.text isEqualToString:@"6개월"])
     {
         [self.userItem setObject:[NSString stringWithFormat:@"6"] forKey:@"지급주기"];
      }
     else{
         [self.userItem setObject:[NSString stringWithFormat:@"0"] forKey:@"지급주기"];
     }
    
    
   	[self.userItem setObject:[NSString stringWithFormat:@"%d",type] forKey:@"이자지급방법"];
    [self.userItem setObject:[NSString stringWithFormat:@"%d",mailnoti] forKey:@"발송"];
    [self.userItem setObject:@"eld가입" forKey:@"eld가입"];
    
	
    SHBELD_BA17_14_SignUpViewController *viewController = [[SHBELD_BA17_14_SignUpViewController alloc]initWithNibName:@"SHBELD_BA17_14_SignUpViewController" bundle:nil];
	viewController.dicSelectedData = self.dicSelectedData;
	viewController.userItem = self.userItem;
	viewController.needsLogin = YES;
    viewController.stepNumber = @"예금적금 가입 3단계";
   
    [self checkLoginBeforePushViewController:viewController animated:YES];
	[viewController release];
}





- (IBAction)cancelBtnAction:(SHBButton *)sender {
       
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
	
	if (textField == self.tfTaxBreakAmount) {	// 세금우대신청금액
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
		
	return YES;
}



- (void)dateField:(SHBDateField*)dateField changeDate:(NSDate*)date
{
}

- (void)currentDateField:(SHBDateField*)dateField
{
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
	
	if (self.service.serviceId == kD4220Id) {
		self.D4220 = aDataSet;
		
		[self.lblTopRow1Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대가입총액"]]];
		[self.lblTopRow2Value setText:[NSString stringWithFormat:@"%@원", [self.D4220 objectForKey:@"세금우대한도잔액"]]];
		
		[self setTaxView];
		
		tax = YES;
		
        //세금우대 안내문구 받기
		self.service = [[[SHBProductService alloc]initWithServiceId:XDA_S00001_1 viewController:self]autorelease];	// D3602
		[self.service start];
	}
	else if (self.service.serviceId == XDA_S00001_1) {
		self.D3602 = aDataSet;
        
        self.service = [[[SHBProductService alloc]initWithServiceId:kD6115Id viewController:self]autorelease];	//Email
		[self.service start];


               
    }
    else if (self.service.serviceId == kD6115Id) {
        self.D6115 = aDataSet;
                
        [self setTaxGuideView];
        [self setTypeView];
        [self setEmailView];
        
        [self setBottomView];
        
	}
    
    
	else if (self.service.serviceId == kD4222Id) {
		self.D4222 = aDataSet;
		[self taxFreeOn];
	}
	
	    return NO;
}

@end

