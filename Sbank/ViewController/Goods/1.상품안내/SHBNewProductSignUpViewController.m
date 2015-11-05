//
//  SHBNewProductSignUpViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNewProductSignUpViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductNoLineRowView.h"
#import "SHBNewProductListViewController.h"
#import "SHBNewProductRegEndViewController.h"
#import "SHBProductService.h"
#import "SHBNewProductRegViewController.h"
#import "SHBNewProductStipulationViewController.h"

@interface SHBNewProductSignUpViewController ()
{
	CGFloat fCurrHeight;
}

@end

@implementation SHBNewProductSignUpViewController

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
    [_dicSmartNewData release];
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
    

    self.strBackButtonTitle =self.stepNumber; //5단계 (주택청약일때)
    
    
    
    
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	FrameResize(self.contentScrollView, 317, height(self.contentScrollView));
    
    if ([self.dicSelectedData objectForKey:@"재형저축신청취소"])
    { // 재형저축 신청취소
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"신한 재형저축 신청취소"] maxStep:0 focusStepNumber:0]autorelease]];
    }
    else if([self.userItem objectForKey:@"재형저축가입신청"])
    {
            [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 가입신청확인", [self.dicSelectedData objectForKey:@"상품명"]] maxStep:5 focusStepNumber:4]autorelease]];
    }
	else
    {
        BOOL isSubscription = [[self.dicSelectedData objectForKey:@"청약여부"]isEqualToString:@"1"];
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 가입확인", [self.dicSelectedData objectForKey:@"상품명"]] maxStep:isSubscription ? 5+1 : 5 focusStepNumber:isSubscription ? 4+1 : 4]autorelease]];
    }
	
	Debug(@"self.userItem : %@", self.userItem);
	
	fCurrHeight = 8;
	UIImage *imgInfoBox = [UIImage imageNamed:@"box_infor"];
	UIImageView *ivInfoBox = [[[UIImageView alloc]initWithImage:[imgInfoBox stretchableImageWithLeftCapWidth:2 topCapHeight:2]]autorelease];
	[self.contentScrollView addSubview:ivInfoBox];
	
	CGFloat fHeight = 10;
	
	NSString *strGuide = @"";
    
    if ([self.dicSelectedData objectForKey:@"재형저축신청취소"]) { // 재형저축 신청취소
        strGuide = @"고객님께서 신청하신 재형저축 신청이 취소됩니다.";
    }

    else {
        strGuide = @"고객님께서는 예금 신규를 아래와 같이 신청하셨습니다. 이체 비밀번호와 보안매체를 입력하시면 가입신청 완료 됩니다.";
    }
    
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
	
//	FrameReposition(self.bottomBackView, left(self.bottomBackView), fCurrHeight);
//	[self.contentScrollView setContentSize:CGSizeMake(width(self.contentScrollView), fCurrHeight += 29+12)];
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
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];  상품약관동의 화면에서 노티 바꿈
    
	// 전자서명 Noti
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
	
	//서버에러일때
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiESignError" object:nil];
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
    
     ///////////////////////////////재형저축가입 시작  //////////////////////////////////
    
    
    if ([self.userItem objectForKey:@"재형저축가입신청"])
    { // 재형저축 가입 신청
        

        strTemp = [NSString stringWithFormat:@"%@ 신규",[self.userItem objectForKey:@"상품명"]];
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=10 title:@"거래구분" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row1];
        
        if ([self.userItem objectForKey:@"예금별명"] == nil || [[self.userItem objectForKey:@"예금별명"] isEqualToString:@""]) {
            strTemp = [self.dicSelectedData objectForKey:@"상품명"];
        }
        else {
            strTemp = [self.userItem objectForKey:@"예금별명"];
        }

        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"예금명" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row2];
        
      
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적립방식" value:@"자유적립식"] autorelease];
        [self.contentScrollView addSubview:row3];
        
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"계약기간" value:@"84개월"] autorelease];
        [self.contentScrollView addSubview:row4];
        
        strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"신규금액"]];      
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"최초불입금" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row5];
        
        
        if ([[self.userItem objectForKey:@"자동이체신청"]isEqualToString:@"자동이체신청"])
        {
        
            strTemp = [self.userItem objectForKey:@"자동이체시작일"];
            SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"자동이체시작일" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row6];
        
            strTemp = [self.userItem objectForKey:@"자동이체종료일"];
            SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"자동이체종료일" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row7];
        
            strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"자동이체금액"]];
            SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"자동이체금액" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row8];
        
    
            SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적용과세" value:@"이자(배당)소득 비과세(농특세 1.4% 징수)"] autorelease];
            [self.contentScrollView addSubview:row9];
        
            strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"분기당납입한도"]];
            SHBNewProductNoLineRowView *row10 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"분기당납입한도" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row10];
        
            strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
            SHBNewProductNoLineRowView *row11 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row11];
        
            strTemp = [self.userItem objectForKey:@"소득금액증명발급번호"];
            SHBNewProductNoLineRowView *row12 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"소득금액증명서 발급번호" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row12];
        
            strTemp = [self.userItem objectForKey:@"휴대폰번호"];
            SHBNewProductNoLineRowView *row13 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"휴대폰번호" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row13];
        }
        
        else
        {
                      
            SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적용과세" value:@"이자(배당)소득 비과세(농특세 1.4% 징수)"] autorelease];
            [self.contentScrollView addSubview:row6];
            
            strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"분기당납입한도"]];
            SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"분기당납입한도" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row7];
            
            strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
            SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row8];
            
            strTemp = [self.userItem objectForKey:@"소득금액증명발급번호"];
            SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"소득금액증명서 발급번호" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row9];
            
            strTemp = [self.userItem objectForKey:@"휴대폰번호"];
            SHBNewProductNoLineRowView *row10 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"휴대폰번호" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row10];
        }
        
        fCurrHeight += 15+5;
        
        return;
  
    }
    
       ///////////////////////////////재형저축가입 끝  //////////////////////////////////
    
    
         ///////////////////////////////재형저축취소신청 시작  ////////////////////////////////// 
    
    else if ([self.dicSelectedData objectForKey:@"재형저축신청취소"]) { // 재형저축 신청취소
        strTemp = [self.dicSelectedData objectForKey:@"상품명"];
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=10 title:@"예금명" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row1];
        
        strTemp = [self.dicSelectedData objectForKey:@"_신청번호"];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신청번호" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row2];
        
        strTemp = [self.dicSelectedData objectForKey:@"_신규예정일"];
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규 예정일" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row3];
        
        strTemp = [self.dicSelectedData objectForKey:@"_만기일"];
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"만기일" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row4];
        
        
        strTemp = [self.dicSelectedData objectForKey:@"_신규금액"];
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규예정금액" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row5];
        
        fCurrHeight += 15+5;
        
        return;
    }
         ///////////////////////////////재형저축취소신청 끝  //////////////////////////////////
    
    
    
    
    
     ///////////////////////////////  신탁상품가입 시작  //////////////////////////////////
    
    
    else if ([self.dicSelectedData objectForKey:@"신탁상품가입"]) { //신탁상품가입
        
        
        strTemp = [NSString stringWithFormat:@"%@ 신규", [self.dicSelectedData objectForKey:@"상품명"]];
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=10 title:@"거래구분" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row1];
        
        
        strTemp = [self.dicSelectedData objectForKey:@"상품명"];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"예금명" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row2];
        
        strTemp = [NSString stringWithFormat:@"%@ 년",[self.userItem objectForKey:@"지급기간"]];
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"연금지급기간" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row3];
        
        strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"신규금액"]];
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규금액" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row4];
        
        
        if ([[self.userItem objectForKey:@"자동이체신청"]isEqualToString:@"자동이체신청"])
        {
            
            strTemp = [self.userItem objectForKey:@"자동이체시작일"];
            SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"자동이체시작일" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row5];
        
            strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"자동이체금액"]];
            SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"자동이체금액" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row6];
            
            strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
            SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"자동이체계좌" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row7];
            
            
            strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
            SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row8];
            
            
             strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"적립한도"]];
            SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"연간적립목표액" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row9];
 
        }
        else{
            strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
            SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row5];
            
            
            strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"적립한도"]];
            SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"연간적립목표액" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row6];

        }
        

        fCurrHeight += 15+5;
        
        return;

    }
    
      ///////////////////////////////  신탁상품가입 끝  //////////////////////////////////
    
    
    
     ///////////////////////////////쿠폰상품 가입 시작 //////////////////////////////////
    else if([[self.dicSelectedData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"])  //u드림 회전정기)
        
    {
        strTemp = [NSString stringWithFormat:@"%@ 신규", [self.dicSelectedData objectForKey:@"상품명"]];
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"거래구분" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row1];
        
        strTemp = [self.dicSelectedData objectForKey:@"상품명"];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"예금명" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row2];
        
        
        strTemp = [self.dicSelectedData objectForKey:@"이자지급방법문구"];
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"이자지급방법" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row3];
        
        strTemp = [NSString stringWithFormat:@"정기예금"];
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적립방식" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row4];
        
        strTemp = [self.dicSelectedData objectForKey:@"가입기간문구"];
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"계약기간" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row5];
        
        if (![[self.dicSelectedData objectForKey:@"회전주기"] isEqualToString:@"0"])
        {
            
            strTemp =  [NSString stringWithFormat:@"%@개월",[self.dicSelectedData objectForKey:@"회전주기"]];
            SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"회전기간" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row6];
        }
        
        strTemp =[NSString stringWithFormat:@"%@원", [self.dicSelectedData objectForKey:@"신청금액"]];
        SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"최초불입금" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row7];
        
        
        
        if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0" ]) {
            strTemp = @"일반과세";
        }
        else if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"1" ]) {
            strTemp = @"세금우대";
        }
        else if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"2" ]) {
            strTemp = @"비과세(생계형)";
        }
        
        SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적용과세" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row8];
        
        NSLog(@"세금우대 !!!!!  %@",[self.userItem objectForKey:@"세금우대"]);
        if ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] &&
            ![[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0" ] ) {
            
            if ([self.userItem objectForKey:@"세금우대_신청금액"] ==nil || [[self.userItem objectForKey:@"세금우대_신청금액"] isEqualToString:@"" ]) {
                strTemp = @"0원";
            }
            else {
                strTemp = [NSString stringWithFormat:@"%@원",[self.userItem objectForKey:@"세금우대_신청금액"]];
            }
            SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"세금우대신청금액" value:strTemp]autorelease];
            [self.contentScrollView addSubview:row9];
        }
        
        strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
        SHBNewProductNoLineRowView *row10 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row10];
        
        
        strTemp = [NSString stringWithFormat:@"%@%%",[self.dicSelectedData objectForKey:@"적용금리"]];
        SHBNewProductNoLineRowView *row11 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적용이율" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row11];
        
        
        strTemp = [self.dicSelectedData objectForKey:@"승인신청행원번호"];
        SHBNewProductNoLineRowView *row12 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"권유직원번호" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row12];
        
        
        fCurrHeight += 15+5;
        
        return;
    }
    
     ///////////////////////////////쿠폰상품 가입 끝 //////////////////////////////////
    
    
    

	 ///////////////////////////////기존상품 신규 시작  //////////////////////////////////
    
	strTemp = [NSString stringWithFormat:@"%@ 신규", [self.dicSelectedData objectForKey:@"상품명"]];
	SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=10 title:@"거래구분" value:strTemp]autorelease];
	[self.contentScrollView addSubview:row1];
	
	if ([self.userItem objectForKey:@"예금별명"] == nil || [[self.userItem objectForKey:@"예금별명"] isEqualToString:@""]) {
		strTemp = [self.dicSelectedData objectForKey:@"상품명"];
	}
	else {
		strTemp = [self.userItem objectForKey:@"예금별명"];
	}
	SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"예금명" value:strTemp]autorelease];
	[self.contentScrollView addSubview:row2];
	
	if ([[self.userItem objectForKey:@"적립방식선택"]length]) {
		strTemp = [self.userItem objectForKey:@"적립방식선택"];
	}
	else
	{
		if ([[self.dicSelectedData objectForKey:@"적립방식_자유적립식여부"] isEqualToString:@"1" ]) {
			strTemp = @"자유적립식";
		}
		else if ([[self.dicSelectedData objectForKey:@"적립방식_정기적립식여부"] isEqualToString:@"1" ]) {
			strTemp = @"정기적립식";
		}
		else if ([[self.dicSelectedData objectForKey:@"적립방식_정기예금여부"] isEqualToString:@"1" ]) {
			strTemp = @"정기예금";
		}
	}
	
	SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"적립방식" value:strTemp]autorelease];
	[self.contentScrollView addSubview:row3];
	
	if (![[self.userItem objectForKey:@"계약기간"] isEqualToString:@"0"]) {
		strTemp = [NSString stringWithFormat:@"%@ 개월", [self.userItem objectForKey:@"계약기간"]];
		SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"계약기간" value:strTemp]autorelease];
		[self.contentScrollView addSubview:row4];
	}
	
    
    if (![[self.userItem objectForKey:@"회전주기"] isEqualToString:@"0"])
    {
        
        strTemp =  [NSString stringWithFormat:@"%@개월",[self.userItem objectForKey:@"회전주기"]];
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"회전기간" value:strTemp] autorelease];
        [self.contentScrollView addSubview:row5];
    }

    
	strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"신규금액"]];
	SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"최초불입금" value:strTemp]autorelease];
	[self.contentScrollView addSubview:row6];
	
	
	NSLog(@"세금우대 !!!!!  %@",[self.userItem objectForKey:@"세금우대"]);
	if ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] &&
		![[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0" ] ) {
		
		if ([self.userItem objectForKey:@"세금우대_신청금액"] ==nil || [[self.userItem objectForKey:@"세금우대_신청금액"] isEqualToString:@"" ]) {
			strTemp = @"0원";
		}
		else {
			strTemp = [NSString stringWithFormat:@"%@ 원",[self.userItem objectForKey:@"세금우대_신청금액"]];
		}
		SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"세금우대신청금액" value:strTemp]autorelease];
		[self.contentScrollView addSubview:row1];
	}
	
	if ([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"0"]) {
		strTemp = [SHBUtility getDateWithDash:[self.userItem objectForKey:@"자동이체_시작일"]];
		SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"자동이체 시작일" value:strTemp]autorelease];
		[self.contentScrollView addSubview:row1];
		
		strTemp = [SHBUtility getDateWithDash:[self.userItem objectForKey:@"자동이체_종료일"]];
		SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"자동이체 종료일" value:strTemp]autorelease];
		[self.contentScrollView addSubview:row2];
		
		strTemp = [NSString stringWithFormat:@"%@ 원", [self.userItem objectForKey:@"자동이체_금액"]];
		SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"자동이체 금액" value:strTemp]autorelease];
		[self.contentScrollView addSubview:row3];
	}
	else if ([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"1"]){
		strTemp = @"신청안함";
		SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"자동이체" value:strTemp]autorelease];
		[self.contentScrollView addSubview:row1];
	}
	
	if ([self.userItem objectForKey:@"자동재예치"]!=nil && ![[self.userItem objectForKey:@"자동재예치"] isEqualToString:@""]) {
		if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"0"]) {
			strTemp = @"신청안함(만기자동해지)";
		}
		else if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"1"]) {
			strTemp = @"원금만 자동재예치";
		}
		else if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"2"]) {
			strTemp = @"원리금 자동재예치";
		}
		
		SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"자동재예치" value:strTemp]autorelease];
		[self.contentScrollView addSubview:row1];
		
	}
    
    NSLog(@"재예치가능여부== %@",[self.dicSelectedData objectForKey:@"재예치가능여부"]);
	
  

    if([[self.dicSelectedData objectForKey:@"재예치가능여부"]isEqualToString:@"1"] ||
       [[self.dicSelectedData objectForKey:@"재예치가능여부"]isEqualToString:@"4"] ||
       [[self.dicSelectedData objectForKey:@"재예치가능여부"]isEqualToString:@"5"] )
    {
        
        if(![[self.userItem objectForKey:@"자동재예치"]isEqualToString:@"0"]  )
        {
       
          if ([[self.userItem objectForKey:@"자동재예치결과통지타입"]isEqualToString:@"0"]) {
              strTemp = @"미신청";
          }
          else if ([[self.userItem objectForKey:@"자동재예치결과통지타입"]isEqualToString:@"1"]) {
              strTemp = @"SMS";
          }
          else if ([[self.userItem objectForKey:@"자동재예치결과통지타입"]isEqualToString:@"3"]) {
              strTemp = @"E-mail";
          }
          else
          {
              strTemp = @"원하지 않음"; 
          }
            
            SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"자동재예치결과통지" value:strTemp] autorelease];
            [self.contentScrollView addSubview:row1];
        
        }
		
         
	}
    
    
    
    if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0" ]) {
		strTemp = @"일반과세";
	}
	else if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"1" ]) {
		strTemp = @"세금우대";
	}
	else if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"2" ]) {
		strTemp = @"비과세(생계형)";
	}
	SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"적용과세" value:strTemp]autorelease];
	[self.contentScrollView addSubview:row7];
	
	strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
	SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp]autorelease];
	[self.contentScrollView addSubview:row8];
	
	fCurrHeight += 15+5;
    
     ///////////////////////////////기존상품 신규 끝  //////////////////////////////////
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
        
        if ([self.dicSelectedData objectForKey:@"재형저축신청취소"]) { // 재형저축 신청취소
            vc.nextSVC = @"D3321";
            
        }
        
        else if ([self.userItem objectForKey:@"재형저축가입신청"]) { // 재형저축 가입 신청
            vc.nextSVC = @"D3300";
        }
        
        else if ([self.dicSelectedData objectForKey:@"신탁상품가입"]) { // 신탁 가입 신청
            vc.nextSVC = @"D3112";
        }
        
        else if([[self.dicSelectedData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"])  //u드림 회전정기)
            
        {

            vc.nextSVC = @"D3250";
        }
        
        else
        {
            vc.nextSVC = @"D3604";
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
        
        if ([self.dicSelectedData objectForKey:@"재형저축신청취소"]) { // 재형저축 신청취소
            vc.nextSVC = @"D3321";
            
        }
        
        else if ([self.userItem objectForKey:@"재형저축가입신청"]) { // 재형저축 가입 신청
            vc.nextSVC = @"D3300";
        }
        
        else if ([self.dicSelectedData objectForKey:@"신탁상품가입"]) { // 신탁 가입 신청
            vc.nextSVC = @"D3112";
        }
        
        
        else if([[self.dicSelectedData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"])  //u드림 회전정기)
        
        {
            vc.nextSVC = @"D3250";
        }
        else
        {
            vc.nextSVC = @"D3604";
        }
		
		self.otpViewController = vc;
    }
}

#pragma mark - Action
- (IBAction)confirmBtnAction:(SHBButton *)sender {
#if 0	// temp
	SHBNewProductRegEndViewController *viewController = [[SHBNewProductRegEndViewController alloc]initWithNibName:@"SHBNewProductRegEndViewController" bundle:nil];
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

#if 1
- (void)cancelSecretMedia
{
//	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
//	{
//		if ([viewController isKindOfClass:[SHBNewProductStipulationViewController class]]) {
//			[self.navigationController popToViewController:viewController animated:YES];
//		}
//	}
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"NewProductCancel" object:nil];
}
#else
- (IBAction)cancelBtnAction:(SHBButton *)sender {
//	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
//	{
//		if ([viewController isKindOfClass:[SHBNewProductListViewController class]]) {
//			[self.navigationController popToViewController:viewController animated:YES];
//		}
//	}
     [[NSNotificationCenter defaultCenter] removeObserver:self];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"NewProductCancel" object:nil];
    
}
#endif

#pragma mark - Notification
- (void)getElectronicSignResult:(NSNotification *)noti
{
	Debug(@"[noti userInfo] : %@", [noti userInfo]);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
	if (!AppInfo.errorType) {
		self.data = [noti userInfo];	// D3604 데이터
		
        if ([self.dicSelectedData objectForKey:@"재형저축신청취소"]) { // 재형저축 신청취소
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            SHBNewProductRegEndViewController *viewController = [[SHBNewProductRegEndViewController alloc]initWithNibName:@"SHBNewProductRegEndViewController" bundle:nil];
			viewController.dicSelectedData = self.dicSelectedData;
			viewController.userItem = self.userItem;
			viewController.completeData = [NSMutableDictionary dictionaryWithDictionary:self.data];
			viewController.needsLogin = YES;
			[self checkLoginBeforePushViewController:viewController animated:YES];
			[viewController release];
            
            return;
        }
        else if ([self.dicSelectedData objectForKey:@"재형저축가입신청"]) { //
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            SHBNewProductRegEndViewController *viewController = [[SHBNewProductRegEndViewController alloc]initWithNibName:@"SHBNewProductRegEndViewController" bundle:nil];
            viewController.dicSelectedData = self.dicSelectedData;
            viewController.userItem = self.userItem;
            viewController.completeData = [NSMutableDictionary dictionaryWithDictionary:self.data];
            viewController.needsLogin = YES;
            [self checkLoginBeforePushViewController:viewController animated:YES];
            [viewController release];

        }
		
     
		else if (([[self.userItem objectForKey:@"직원번호"] length] ||
                  [[self.dicSelectedData objectForKey:@"쿠폰상품여부"]isEqualToString:@"1"])
                 && ![self.userItem objectForKey:@"재형저축가입신청"])
        {
			SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
								   @"성명" : [self.data objectForKey:@"고객성명"],
//								   @"이메일주소" : [NSString stringWithFormat:@"SH%@@portal.shinhan.com",[self.userItem objectForKey:@"직원번호"]],
								   @"내용" : [NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@|%@|%@",
											//[AppInfo.userInfo objectForKey:@"고객성명"],  //고객명
                                            [self.data objectForKey:@"고객성명"],
											[self.userItem objectForKey:@"직원번호"],                               //권유자번호
											[self.dicSelectedData objectForKey:@"상품명"],                                    //상품명
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
            
            if ( [[self.dicSelectedData objectForKey:@"쿠폰상품여부"]isEqualToString:@"1"]) {
                [dataSet insertObject:[NSString stringWithFormat:@"SH%@@portal.shinhan.com",[self.dicSelectedData objectForKey:@"승인신청행원번호"]] forKey:@"이메일주소" atIndex:0];

            }
            else{
                [dataSet insertObject:[NSString stringWithFormat:@"SH%@@portal.shinhan.com",[self.userItem objectForKey:@"직원번호"]] forKey:@"이메일주소" atIndex:0];
            }
            
			self.service = nil;
			self.service = [[[SHBProductService alloc]initWithServiceId:kD9501Id viewController:self]autorelease];
			self.service.requestData = dataSet;
			[self.service start];
            
		}
		else if ([self.userItem objectForKey:@"동의구분"])
        {
			//NSLog(@"!!!정보동의 %@", [self.userItem objectForKey:@"정보동의"]);
            //NSLog(@"!!!마케팅활용동의여부 %@", [self.userItem objectForKey:@"마케팅활용동의여부"]);
           
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
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            SHBNewProductRegEndViewController *viewController = [[SHBNewProductRegEndViewController alloc]initWithNibName:@"SHBNewProductRegEndViewController" bundle:nil];
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
	for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
	{
		if ([viewController isKindOfClass:[SHBNewProductRegViewController class]]) {
			[self.navigationController popToViewController:viewController animated:YES];
		}
	}
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewProductCancel" object:nil];
}

#pragma mark - 전자서명 코드 세팅
- (NSString *)getElectronicSignCode
{
	NSString *strReturn = nil;
    
    if([[self.dicSelectedData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"])  //u드림 회전정기)
    {
        if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200003401"] ||  //top회전정기
            [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200013410"] ||
            [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200013411"] )  //u드림 회전정기))
        {
            strReturn = @"D3250_A";
        }
        else
        {
            if ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] &&
                ![[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0"])
            {
                if (![[self.dicSelectedData objectForKey:@"회전주기"] isEqualToString:@"0"])
                {
                    // 회전주기 없고 세금우대 금액신청 상품
                    
                    strReturn = @"D3250_C";
                }
                else
                {
                    // 회전주기 없고 세금우대 금액신청 상품
                    
                    strReturn = @"D3250_D";
                }
                
            }
            else
            {
                strReturn = @"D3250_B";
            }
        }
        
        
        return strReturn;
    }
    
    if ([self.dicSelectedData objectForKey:@"신탁상품가입"])  // 신탁 가입 신청
    {
            
            if ([[self.userItem objectForKey:@"자동이체신청"]isEqualToString:@"자동이체신청"])
            {
                strReturn = @"D3112_A";
                
            }
            else
            {
                strReturn = @"D3112_B";
            }
            
            return strReturn;
    }

    
    if ([self.dicSelectedData objectForKey:@"재형저축신청취소"]) { // 재형저축 신청취소
        strReturn = @"D3321";
        
        return strReturn;
    }
    
    if ([self.userItem objectForKey:@"재형저축가입신청"]) { // 재형저축 가입 신청
       
        if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"232000101"])
        {
            if ([[self.userItem objectForKey:@"자동이체신청"]isEqualToString:@"자동이체신청"])
            {
                strReturn = @"D3300_A";  
            
            }
            else
            {
                strReturn = @"D3300_B";
            }

            Debug(@"strReturn : %@", strReturn);
            return strReturn;
        }
        
        else
        {
            if ([[self.userItem objectForKey:@"자동이체신청"]isEqualToString:@"자동이체신청"])
            {
                strReturn = @"D3300_C";
                
            }
            else
            {
                strReturn = @"D3300_D";
            }
            
            Debug(@"strReturn : %@", strReturn);
            return strReturn;
        }
        
    }
	
	if ([[self.dicSelectedData objectForKey:@"청약여부"] isEqualToString:@"1"])	// 청약인 경우
	{
		// 1. 세금우대 신청금액이 있는 경우
		if ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] && ![[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0"] &&
			([self.userItem objectForKey:@"세금우대_신청금액"] != nil || [[self.userItem objectForKey:@"세금우대_신청금액"] length] != 0) )
		{
			if ([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"0"]) {	// 자동이체 신청
				strReturn = @"D3604_P";
			}
			else if([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"1"]){	// 자동이체 신청안함
				strReturn = @"D3604_Q";
			}
		}
		// 2. 세금우대 신청금액이 없는 경우
		else
		{
			if ([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"0"]) {	// 자동이체 신청
				strReturn = @"D3604_M";
			}
			else if([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"1"]){	// 자동이체 신청안함
				strReturn = @"D3604_N";
			}
		}
		

	}
	else	// 청약이 아닌 경우
	{
		// 1. 세금우대 신청금액이 있는 경우
		if ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] &&
            ![[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0"] &&
			([self.userItem objectForKey:@"세금우대_신청금액"] != nil
             || [[self.userItem objectForKey:@"세금우대_신청금액"] length] != 0) )
        {

			if ([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"0"]) {	// 자동이체 신청
				
				if ([[self.userItem objectForKey:@"자동재예치"] length]) {		// 자동재예치가 있는 경우
					
                    if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"0"])
                    {
                        strReturn = @"D3604_V";	// 해당 케이스 없을 수 있음
                    }
                    
                    else if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"1"] ||
                             [[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"2"])
                    {
                        strReturn = @"D3604_G";	// 해당 케이스 없을 수 있음
                    }
                    
                   
				}
				else	// 자동재예치 항목자체가 없는 경우
				{
					strReturn = @"D3604_I";
				}
			}
			else if([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"1"]){	// 자동이체 신청안함
				
				if ([[self.userItem objectForKey:@"자동재예치"] length]) {		// 자동재예치가 있는 경우
					// no case
                    if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"0"])
                    {
                        strReturn = @"D3604_W";	// 해당 케이스 없을 수 있음
                    }
                    
                    else if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"1"] ||
                             [[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"2"])
                    {
                        strReturn = @"D3604_H";	// 해당 케이스 없을 수 있음
                    }
                    
					
				}
				else	// 자동재예치 항목자체가 없는 경우
				{
//					strReturn = @"D3604_D";	// D3604_H, D3604_J 랑 겹치는 케이스네
					strReturn = @"D3604_J";
				}
			}
			else	// 자동이체 항목 자체가 없는 경우
			{
				if ([[self.userItem objectForKey:@"자동재예치"] length]) {		// 자동재예치가 있는 경우
					if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"0"])
                    {
                        strReturn = @"D3604_R";	// 해당 케이스 없을 수 있음
                    }
                    
                    else if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"1"] ||
                             [[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"2"])
                    {
                        strReturn = @"D3604_K";	// 해당 케이스 없을 수 있음
                    }
                    
				}
				else	// 자동재예치 항목자체가 없는 경우
				{
					strReturn = @"D3604_L";	// 해당 케이스 없을 수 있음
				}
			}
		}
		
		// 2. 세금우대 신청금액이 없는 경우
		else
		{
			if ([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"0"]) {	// 자동이체 신청
				
				if ([[self.userItem objectForKey:@"자동재예치"] length]) {		// 자동재예치가 있는 경우
					if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"0"])
                    {
                        strReturn = @"D3604_U";	// 해당 케이스 없을 수 있음
                    }
                    else if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"1"] ||
                             [[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"2"])
                    {
                        strReturn = @"D3604_A";	// 해당 케이스 없을 수 있음
                    }

                    
				}
				else	// 자동재예치 항목자체가 없는 경우
				{
					strReturn = @"D3604_C";
				}
			}
			else if([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"1"]){	// 자동이체 신청안함
				
				if ([[self.userItem objectForKey:@"자동재예치"] length]) {		// 자동재예치가 있는 경우
					// no case
					if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"0"])
                    {
                        strReturn = @"D3604_T";	// 해당 케이스 없을 수 있음
                    }
                    else if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"1"] ||
                             [[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"2"])
                    {
                        strReturn = @"D3604_B";	// 해당 케이스 없을 수 있음
                    }


                   
				}
				else	// 자동재예치 항목자체가 없는 경우
				{
//					strReturn = @"D3604_B";
					strReturn = @"D3604_D";
				}
			}
			else	// 자동이체 항목 자체가 없는 경우
			{
				if ([[self.userItem objectForKey:@"자동재예치"] length]) {		// 자동재예치가 있는 경우
					if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"0"])
                    {
                        strReturn = @"D3604_S";	// 해당 케이스 없을 수 있음
                    }
                    
                    else if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"1"] ||
                             [[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"2"])
                    {
                        strReturn = @"D3604_E";	// 해당 케이스 없을 수 있음
                    }

                    
				}
				else	// 자동재예치 항목자체가 없는 경우
				{
                    
                    if([[self.dicSelectedData objectForKey:@"회전주기_선택비트"] isEqualToString:@"136"])
                    {
                        strReturn = @"D3604_X";
                    }
                    else
                    {
                        strReturn = @"D3604_F";
                    }
					
				}
			}

		}
	}
	
	Debug(@"strReturn : %@", strReturn);
	return strReturn;
}

#pragma mark - SHBSecretCard Delegate
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
	Debug(@"confirmSecretData:%@", confirmData);
    Debug(@"confirmSecretResult:%i", confirm);
    Debug(@"confirmSecretMedia:%i", mediaType);
	
	if (confirm == 1)
    {
        AppInfo.electronicSignString = @"";
		AppInfo.eSignNVBarTitle = @"예금/적금 가입";
		AppInfo.electronicSignCode = [self getElectronicSignCode];
        
        
      if ([self.dicSelectedData objectForKey:@"재형저축신청취소"]) { // 재형저축 신청취소
            AppInfo.electronicSignTitle = [NSString stringWithFormat:@"%@ 신규취소 신청 합니다.", [_dicSelectedData objectForKey:@"상품명"]];
            
            [AppInfo addElectronicSign:@"(1)예금종류: 재형저축"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)신청번호: %@", [_dicSelectedData objectForKey:@"_신청번호"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)신규예정일자: %@", [_dicSelectedData objectForKey:@"_신규예정일"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)만기일자: %@", [_dicSelectedData objectForKey:@"_만기일"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)신규예정금액: %@", [_dicSelectedData objectForKey:@"_신규금액"]]];
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                                   @{
                                   @"계좌번호" : [_dicSelectedData objectForKey:@"계좌번호"],
                                   @"거래점용계좌번호" : [_dicSelectedData objectForKey:@"계좌번호"],
                                   @"거래번호" : [_dicSelectedData objectForKey:@"거래번호"],
                                   @"거래조작일자" : [_dicSelectedData objectForKey:@"거래조작일자"],
                                   @"거래조작시간" : [_dicSelectedData objectForKey:@"거래조작시간"],
                                   @"거래일자" : [_dicSelectedData objectForKey:@"거래일자"],
                                   @"거래금액" : [_dicSelectedData objectForKey:@"거래금액"],
                                   @"업무구분" : [_dicSelectedData objectForKey:@"업무구분"],
                                   @"거래구분" : [_dicSelectedData objectForKey:@"거래구분"],
                                   @"정정취소구분" : [_dicSelectedData objectForKey:@"정정취소구분"],
                                   @"채널유형" : [_dicSelectedData objectForKey:@"채널유형"],
                                   @"통화코드" : [_dicSelectedData objectForKey:@"통화코드"],
                                   @"마감후여부" : [_dicSelectedData objectForKey:@"마감후여부"],
                                   @"거래후잔액" : [_dicSelectedData objectForKey:@"거래후잔액"],
                                   @"기산일여부" : [_dicSelectedData objectForKey:@"기산일여부"],
                                   @"후송여부" : [_dicSelectedData objectForKey:@"후송여부"],
                                   @"연동유무" : [_dicSelectedData objectForKey:@"연동유무"],
                                   @"거래점번" : [_dicSelectedData objectForKey:@"거래점번"],
                                   @"한국은행입지사유" : [_dicSelectedData objectForKey:@"BOK입지사유"],
                                   @"지급이자" : [_dicSelectedData objectForKey:@"지급이자"],
                                   }];
            
            NSString *date = [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *oldDate = [[SHBUtility dateStringToMonth:0 toDay:-1] stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSInteger beforeDate = [[SHBUtility getPreOPDate:oldDate] integerValue]; // 전영업일
            
            if ([[_dicSelectedData objectForKey:@"예약신규일"] integerValue] == [date integerValue]) { // 정정
                [dataSet insertObject:@"1"
                               forKey:@"정정취소거래구분"
                              atIndex:0];
            }
            else if ([[_dicSelectedData objectForKey:@"예약신규일"] integerValue] == beforeDate) { // 후송정정
                [dataSet insertObject:@"1"
                               forKey:@"정정취소거래구분"
                              atIndex:0];
                [dataSet insertObject:[_dicSelectedData objectForKey:@"예약신규일"]
                               forKey:@"후송일자"
                              atIndex:0];
            }
            else { // 취소
                [dataSet insertObject:@"2"
                               forKey:@"정정취소거래구분"
                              atIndex:0];
                [dataSet insertObject:[_dicSelectedData objectForKey:@"예약신규일"]
                               forKey:@"기산일자"
                              atIndex:0];
            }
            
            self.service = nil;
            self.service = [[[SHBProductService alloc] initWithServiceId:kD3321Id viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
            
            return;
        }
        
        if([self.userItem objectForKey:@"재형저축가입신청"])  // 재형저축 가입 신청
        {
            NSLog(@"전자서명 문구 시작");
            if ([self.userItem objectForKey:@"동의구분"]) {
                if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의구분"]) {
                    AppInfo.electronicSignTitle = @"해당 상품의 약관 및 상품설명서 내용을 확인하고 재형저축을 신규신청합니다. 상품신규 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등) 및 고객권리 안내문에 동의합니다.";
                    //				[AppInfo addElectronicSign:@"상품신규 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등)에 동의합니다."];
                }
                else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"필수적정보동의구분"]) {
                    AppInfo.electronicSignTitle = @"해당 상품의 약관 및 상품설명서 내용을 확인하고 재형저축을 신규신청합니다. 상품신규 및 개인(신용)정보 수집, 이용동의서(비여신 금융거래) 및 고객권리 안내문에 동의합니다.";
                    //				[AppInfo addElectronicSign:@"상품신규 및 개인(신용)정보 수집, 이용동의서(비여신 금융거래)에 동의합니다."];
                }
                else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅과필수적정보동의구분"]) {
                    AppInfo.electronicSignTitle = @"해당 상품의 약관 및 상품설명서 내용을 확인하고 재형저축을 신규신청합니다.상품신규 및 개인(신용)정보 수집이용 제공동의서(상품서비스 안내등)와 수집이용동의서(비여신 금융거래)및 고객권리 안내문에 동의합니다.";
                    //				[AppInfo addElectronicSign:@"상품신규 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등)와 수집, 이용동의서(비여신 금융거래)에 동의합니다."];
                }
                else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의안함"]) {
                    AppInfo.electronicSignTitle = @"해당 상품의 약관 및 상품설명서 내용을 확인하고 재형저축을 신규신청합니다.";
                    //				[AppInfo addElectronicSign:@"상품신규"];
                }
            }
            else
            {
                AppInfo.electronicSignTitle = @"해당 상품의 약관 및 상품설명서 내용을 확인하고 재형저축을 신규신청합니다.";
                //			[AppInfo addElectronicSign:@"상품신규"];
            }
            
            [AppInfo addElectronicSign:@"1.신청내용"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일자: %@", AppInfo.tran_Date]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)신청시간: %@", AppInfo.tran_Time]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)예금종류: %@", [self.dicSelectedData objectForKey:@"상품명"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)가입기간: 84개월"]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)적립방식: 자유적립식"]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)세금우대: 이자(배당)소득 비과세(농특세1.4%%징수)"]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)분기당납입한도:  %@원", [self.userItem objectForKey:@"분기당납입한도"]]]; 
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)신규금액: %@원",[self.userItem objectForKey:@"신규금액"]]];
         

            
            NSInteger counter = 9;
            
            if ([[self.userItem objectForKey:@"자동이체신청"]isEqualToString:@"자동이체신청"])
            {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체: 신청",counter]];
                counter++;
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체시작일: %@",counter,[self.userItem objectForKey:@"자동이체시작일"]]];
                counter++;
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체종료일: %@",counter,[self.userItem objectForKey:@"자동이체종료일"]]]; 
                counter++;
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체금액: %@원",counter, [self.userItem objectForKey:@"자동이체금액"]]];
                counter++;
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)출금계좌번호: %@",counter, [self.userItem objectForKey:@"출금계좌번호출력용"]]];
                counter++;
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)소득확인증명서발급번호: %@",counter, [self.userItem objectForKey:@"소득금액증명발급번호"]]];
                counter++;
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)휴대폰번호: %@",counter, [self.userItem objectForKey:@"휴대폰번호"]]];
                


            }
            else
            {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체: 미신청",counter]];
                counter++;
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)출금계좌번호: %@",counter, [self.userItem objectForKey:@"출금계좌번호출력용"]]];
                counter++;
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)소득확인증명서발급번호: %@",counter, [self.userItem objectForKey:@"소득금액증명발급번호"]]];
                counter++;
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)휴대폰번호: %@",counter, [self.userItem objectForKey:@"휴대폰번호"]]];
               

            }
           
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"2.상품설명서 및 약관"] ];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)상품설명서: 받음"] ];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)약관: 받음"] ];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)특약: 받음"] ];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)재형저축고객확인서: 받음"] ];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)만기 연장 후 중도해지시 신규가입일로부터 해지일 까지 전기간 일반 과세 적용"] ];
            
            if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"232000101"])
            {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)신규일로부터 최초 3년간만 우대금리 제공"] ];
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)신규일로부터 3년 경과 후, 매 1년마다 변동된 이율 적용"] ];
            }
            
            else{
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)신규일로부터 최초 7년간 고정금리를 적용하며, 우리금리는 최초 7년간만 제공"] ];
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)7년 만기 이전 중도해지하는 경우 약정이자율보다 낮은 중도해지 이자율이 적용"]];
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(8)연장계약기간은 연장 계약시작일의 고시된 3년제 정기적금 기본이자율을 적용"]];

            }
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"3.기타사항"]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"- 가입일 현재 소득세법상 거주자, 직전연도 총급여액이 5천만원이하 종합소득금액이 3천500만원 이하임을 확인하였으며, 가입대상이 아닐경우 취소될 수 있음"]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"- 홈텍스의 장애, 발급번호의 오류 입력시 취소 될 수 있음."]];


            NSLog(@"전자서명 전문조립");
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                                   @{
                                   @"상품코드" : [self.dicSelectedData objectForKey:@"상품코드"],
                                   @"거래점은행구분" :  @"1",
                                   @"대분류과목" : @"4",
                                   @"신규계좌비밀번호" : [self.userItem objectForKey:@"신규계좌비밀번호"],
                                   @"계약기간_개월" : @"84",
                                   @"이자지급방법" : @"03",
                                  // @"회전주기" : @"",   //@"회전주기" : @"12",
                                   @"출금계좌은행구분" : @"1",
                                   @"출금계좌비밀번호" : [self.userItem objectForKey:@"출금계좌비밀번호"],
                                   @"출금금액" : [self.userItem objectForKey:@"신규금액"],
                                   //@"자동이체은행구분" : @"1",
                                  // @"자동이체주기" : @"1",
                                   @"입금주기구분" : @"8",
                                   @"입금주기" : @"0",
                                   @"세금우대한도금액" : [self.userItem objectForKey:@"분기당납입한도"],
                                   @"국세청소득증빙번호" : [self.userItem objectForKey:@"소득금액증명발급번호"],
                                   }];
            
             [dataSet insertObject: [self.userItem objectForKey:@"예금별명"] forKey:@"부제목" atIndex:0];
            [dataSet insertObject: [[self.userItem objectForKey:@"출금계좌번호"]stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"거래점계좌번호" atIndex:0];
            [dataSet insertObject: [[self.userItem objectForKey:@"출금계좌번호"]stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"출금계좌번호" atIndex:0];
            
             [dataSet insertObject: [[self.userItem objectForKey:@"휴대폰번호"]stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"핸드폰번호" atIndex:0];
            
            
            if ([[self.dicSelectedData objectForKey:@"상품코드" ] isEqualToString:@"232000101"]) // 변동
            {
                [dataSet insertObject:@"12" forKey:@"회전주기" atIndex:0];
            }
            else
            {
                [dataSet insertObject:@"" forKey:@"회전주기" atIndex:0];
            }

            if ([[self.userItem objectForKey:@"자동이체신청"]isEqualToString:@"자동이체신청"])
            {
                
               // [dataSet insertObject: [[self.userItem objectForKey:@"자동이체금액"]stringByReplacingOccurrencesOfString:@"," withString:@""] forKey:@"자동이체금액" atIndex:0];
                [dataSet insertObject: [self.userItem objectForKey:@"자동이체금액"] forKey:@"자동이체금액" atIndex:0];
                [dataSet insertObject: [self.userItem objectForKey:@"자동이체종료일"] forKey:@"자동이체종료일" atIndex:0];
                [dataSet insertObject: [self.userItem objectForKey:@"자동이체시작일"] forKey:@"자동이체시작일" atIndex:0];
                [dataSet insertObject: @"1" forKey:@"자동이체주기" atIndex:0];
                [dataSet insertObject: @"1" forKey:@"자동이체은행구분" atIndex:0];
                [dataSet insertObject: [[self.userItem objectForKey:@"출금계좌번호"]stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"자동이체계좌" atIndex:0];
                
              
                
            }
            
            if ([self.userItem objectForKey:@"직원번호"] != nil) {
                [dataSet insertObject:[self.userItem objectForKey:@"직원번호"] forKey:@"권유직원번호" atIndex:0];
          
            }
            
            
            
            self.service = [[[SHBProductService alloc] initWithServiceId:kD3300Id viewController:self] autorelease];
            self.service.requestData = dataSet;  
            [self.service start];
            
            return;
            
            
        }
        
        /////////////////////////////////////////// 신탁상품  전자서명과 전문 시작 ///////////////////////////////////////////
        
    
        
        if([self.dicSelectedData objectForKey:@"신탁상품가입"])  // 신탁상품가입
        {
            if ([self.userItem objectForKey:@"동의구분"])
            {
                if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의구분"]) {
                    AppInfo.electronicSignTitle = @"상품신규 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등) 고객권리 안내문에 동의합니다.";
                }
                else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"필수적정보동의구분"]) {
                    AppInfo.electronicSignTitle = @"상품신규 및 개인(신용)정보 수집, 이용동의서(비여신 금융거래) 고객권리 안내문에 동의합니다.";
                    
                }
                else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅과필수적정보동의구분"]) {
                    AppInfo.electronicSignTitle = @"상품신규 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등)와 수집, 이용동의서(비여신 금융거래) 고객권리 안내문에 동의합니다.";
                }
                else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의안함"]) {
                    AppInfo.electronicSignTitle = @"예금/적금 가입";
                }
            }
            else
            {
                AppInfo.electronicSignTitle = @"예금/적금 가입";
            }
            

            [AppInfo addElectronicSign:@"1.신청내용"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)예금종류: %@", [self.dicSelectedData objectForKey:@"상품명"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)신규금액: %@", [self.userItem objectForKey:@"신규금액"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)연금지급기간: %@", [self.userItem objectForKey:@"지급기간"]]];
            
            
            if ([[self.userItem objectForKey:@"자동이체신청"]isEqualToString:@"자동이체신청"])
            {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)자동이체금액: %@", [self.userItem objectForKey:@"자동이체금액"]]];
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)자동이체계좌: %@", [self.userItem objectForKey:@"출금계좌번호출력용"]]];
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(6)출금계좌번호: %@", [self.userItem objectForKey:@"출금계좌번호출력용"]]];
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(7)연간적립한도금액: %@", [self.userItem objectForKey:@"적립한도"]]];

            }
            
            else{

                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)출금계좌번호: %@", [self.userItem objectForKey:@"출금계좌번호출력용"]]];
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)연간적립한도금액: %@", [self.userItem objectForKey:@"적립한도"]]];
               
            }
            
            
            
            //2010.11.18  상품설명서 관련 추가
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"2.상품설명서 및 약관"] ];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)상품설명서 받기 여부: 받음"] ];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)약관 받기 여부: 받음"] ];
            

            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                                   @{
                                     @"은행구분" : @"1",
                                     @"고객번호" : AppInfo.customerNo,
                                     @"상품코드" : [self.dicSelectedData objectForKey:@"상품코드"],
                                     @"합계금액" : [self.userItem objectForKey:@"신규금액"],
                                     @"대분류과목" : @"5",
                                     @"비밀번호" : [self.userItem objectForKey:@"신규계좌비밀번호"],
                                     @"비밀번호미입력" : @"N",
                                     @"신규거래구분" : @"0",
                                     @"계약기간월" : @"0",
                                     @"세금우대구분" : @"0",
                                     //@"세금우대한도" : @"0",
                                     @"세금우대한도" : [self.userItem objectForKey:@"적립한도"],
                                     @"지급주기코드" : @"4",
                                     @"지급주기" : @"1",
                                     @"연급지급기간" : [self.userItem objectForKey:@"지급기간"],
                                     @"통보방법" : [self.userItem objectForKey:@"통보방법코드"],
                                    // @"이체계좌번호" : [self.userItem objectForKey:@"출금계좌번호"],
                                    // @"이체계좌은행구분" :  @"1",
                                    //  @"이체금액" : [self.userItem objectForKey:@"신규금액"],
                                    // @"이체주기" : @"1",
                                     @"고객명출력구분" :@"0",
                                     @"연동지급계좌번호" : [self.userItem objectForKey:@"출금계좌번호"],
                                     @"연동지급계좌" : @"1",
                                     @"연동지급비밀번호" : [self.userItem objectForKey:@"신규계좌비밀번호"],
                                     @"연동지급금액" : [self.userItem objectForKey:@"신규금액"],
                                     @"적용코드" : @"135",
                                     
                                     }];
            
            if ([[self.userItem objectForKey:@"자동이체신청"]isEqualToString:@"자동이체신청"])
            {

                [dataSet insertObject: [self.userItem objectForKey:@"자동이체금액"] forKey:@"이체금액" atIndex:0];
                [dataSet insertObject: [self.userItem objectForKey:@"자동이체시작일"] forKey:@"이체시작일자" atIndex:0];
                [dataSet insertObject: @"" forKey:@"이체종료일자" atIndex:0];
                [dataSet insertObject: @"1" forKey:@"이체주기" atIndex:0];
                [dataSet insertObject: @"1" forKey:@"이체계좌은행구분" atIndex:0];
                [dataSet insertObject: [[self.userItem objectForKey:@"출금계좌번호"]stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"이체계좌번호" atIndex:0];

            }
            
            if ([self.userItem objectForKey:@"직원번호"] != nil) {
                [dataSet insertObject:[self.userItem objectForKey:@"직원번호"] forKey:@"권유직원번호" atIndex:0];
                
            }
            
            
            self.service = nil;
            self.service = [[[SHBProductService alloc] initWithServiceId:kD3112Id viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
            
            return;
            

            

        }
        
        /////////////////////////////////////////// 신탁상품  전자서명과 전문 끝 ///////////////////////////////////////////
        
        
        
		
		if([[self.dicSelectedData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"])  //민트  쿠폰상품//u드림 회전정기)
        {
            
            if ([self.userItem objectForKey:@"동의구분"])
            {
                if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의구분"]) {
                    AppInfo.electronicSignTitle = @"상품신규 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등) 고객권리 안내문에 동의합니다.";
                }
                else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"필수적정보동의구분"]) {
                    AppInfo.electronicSignTitle = @"상품신규 및 개인(신용)정보 수집, 이용동의서(비여신 금융거래) 고객권리 안내문에 동의합니다.";
                    
                }
                else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅과필수적정보동의구분"]) {
                    AppInfo.electronicSignTitle = @"상품신규 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등)와 수집, 이용동의서(비여신 금융거래) 고객권리 안내문에 동의합니다.";
                }
                else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의안함"]) {
                    AppInfo.electronicSignTitle = @"예금/적금 가입";
                }
            }
            else
            {
                AppInfo.electronicSignTitle = @"예금/적금 가입";
            }
            
            
            [AppInfo addElectronicSign:@"1.신청내용"];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)예금종류: %@", [self.dicSelectedData objectForKey:@"상품명"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)이자지급방법: %@", [self.dicSelectedData objectForKey:@"이자지급방법문구"]]];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)가입기간: %@", [self.dicSelectedData objectForKey:@"가입기간문구"]]];
            
            NSInteger elecCnt = 6;
            
            if (![[self.dicSelectedData objectForKey:@"회전주기"] isEqualToString:@"0"]) {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)회전기간: %@개월", elecCnt, self.dicSelectedData[@"회전주기"]]];
                elecCnt++;
            }
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)적립방식: 정기예금", elecCnt]];
            elecCnt++;
            
            if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0"]) {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)세금우대: 일반과세", elecCnt]];
            }
            else if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"1"]) {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)세금우대: 세금우대", elecCnt]];
            }
            else if ([[self.userItem objectForKey:@"세금우대"] isEqualToString:@"2"]) {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)세금우대: 비과세(생계형)", elecCnt]];
            }
            elecCnt++;
            
            if ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] &&
                ![[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0"])
            {
                NSString *strTemp1 = @"";
                
                if ([self.userItem objectForKey:@"세금우대_신청금액"] == nil ||
                    [[self.userItem objectForKey:@"세금우대_신청금액"] isEqualToString:@""])
                {
                    strTemp1 = @"0원";
                }
                else
                {
                    strTemp1 = [NSString stringWithFormat:@"%@원",[self.userItem objectForKey:@"세금우대_신청금액"]];
                }
                
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)세금우대신청액: %@", elecCnt, strTemp1]];
                elecCnt++;
            }
            
            if ([[self.dicSelectedData objectForKey:@"영업점상품여부"] isEqualToString:@"1"] )
            {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)신규금액: %@원", elecCnt, self.dicSelectedData[@"신청금액"]]];
            }
            else
            {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)신규금액: %@원", elecCnt, self.dicSelectedData[@"신규금액"]]];
            }
            elecCnt++;
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)출금계좌번호: %@", elecCnt, self.userItem[@"출금계좌번호출력용"]]];
            elecCnt++;
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)금리: %@", elecCnt, self.dicSelectedData[@"적용금리"]]];
            elecCnt++;
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)권유직원번호: %@", elecCnt, self.dicSelectedData[@"승인신청행원번호"]]];
            
            
            
            //2010.11.18  상품설명서 관련 추가
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"2.상품설명서 및 약관"] ];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)상품설명서 받기 여부: 받음"] ];
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)약관 받기 여부: 받음"] ];
            
            NSLog(@"세금우대 %@", [self.userItem objectForKey:@"세금우대"]);
            
            SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                                   @{
                                   @"상품코드" : [self.dicSelectedData objectForKey:@"상품코드"],
                                   @"고객번호" : AppInfo.customerNo,
                                   @"거래점은행구분" : @"1",
                                   @"거래점계좌번호" : [self.userItem objectForKey:@"출금계좌번호"],
                                   @"금액" : [self.userItem objectForKey:@"신규금액"],
                                   @"합계" : [self.userItem objectForKey:@"신규금액"],
                                   @"대분류과목" : @"4",
                                   @"신규계좌비밀번호" : [self.userItem objectForKey:@"신규계좌비밀번호"],
                                   @"계약기간_개월" : [self.dicSelectedData objectForKey:@"가입기간"],
                                   @"세금우대" : [self.userItem objectForKey:@"세금우대"],
                                   @"이자지급방법" : [self.dicSelectedData objectForKey:@"이자지급방법"],
                                   @"지급주기구분" : @"0",
                                   //@"지급주기" : [self.dicSelectedData objectForKey:@"이자지급주기"],
                                   //@"승인번호" : [self.dicSelectedData objectForKey:@"승인번호"],
                                   //@"우대이율" : [self.dicSelectedData objectForKey:@"적용금리"],
                                   @"권유직원번호" : [self.dicSelectedData objectForKey:@"승인신청행원번호"],
                                   @"출금계좌은행구분" :  @"1",
                                   @"출금계좌번호" : [self.userItem objectForKey:@"출금계좌번호"],
                                   @"출금계좌비밀번호" : [self.userItem objectForKey:@"출금계좌비밀번호"],
                                   @"출금금액" : [self.userItem objectForKey:@"신규금액"],
                                   // @"고객산출금리여부" : @"0",
                                   }];
            
            
            if ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] &&
                ![[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0"])
            {
                
                [dataSet insertObject:[self.userItem objectForKey:@"세금우대_신청금액"] forKey:@"세금우대한도금액" atIndex:0];
                
            }
            
            if([[self.dicSelectedData objectForKey:@"영업점상품여부"] isEqualToString:@"1"] )
            {
                [dataSet insertObject:[self.dicSelectedData objectForKey:@"승인번호"]forKey:@"승인번호" atIndex:0];
                [dataSet insertObject:[self.dicSelectedData objectForKey:@"적용금리"]forKey:@"우대이율" atIndex:0];
                
            }
            else
            {
                if([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200009301"] ||
                   [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200009201"] ||
                   [[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"200003401"] )
                {
                    [dataSet insertObject:@"1"forKey:@"고객산출금리여부" atIndex:0];
                    [dataSet insertObject:[self.dicSelectedData objectForKey:@"적용금리"]forKey:@"우대이율" atIndex:0];
                }
                
            }

            
            if (![[self.dicSelectedData objectForKey:@"회전주기"] isEqualToString:@"0"])
             {
                [dataSet insertObject:[self.dicSelectedData objectForKey:@"회전주기"]forKey:@"회전주기" atIndex:0];
            }
            if ([self.dicSelectedData objectForKey:@"이자지급주기"] == nil ||
                [[self.dicSelectedData objectForKey:@"이자지급주기"] isEqualToString:@"0"] )
            {
                 [dataSet insertObject:@"0"forKey:@"지급주기" atIndex:0];
               
            }
            else
            {
                 [dataSet insertObject:[self.dicSelectedData objectForKey:@"이자지급주기"]forKey:@"지급주기" atIndex:0];
            }
            
            if ([self.userItem objectForKey:@"예금별명"] != nil)
            {
                [dataSet insertObject:[self.userItem objectForKey:@"예금별명"] forKey:@"부제목" atIndex:0];
            }
            
            self.service = nil;
            self.service = [[[SHBProductService alloc] initWithServiceId:kD3250Id viewController:self] autorelease];
            self.service.requestData = dataSet;
            [self.service start];
            
            return;

        }
        
/////////////////////////////////////////// 기존상품 ///////////////////////////////////////////
        
		if ([self.userItem objectForKey:@"동의구분"]) {
			if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의구분"]) {
				AppInfo.electronicSignTitle = @"상품신규 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등) 고객권리 안내문에 동의합니다.";
//				[AppInfo addElectronicSign:@"상품신규 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등)에 동의합니다."];
			}
			else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"필수적정보동의구분"]) {
				AppInfo.electronicSignTitle = @"상품신규 및 개인(신용)정보 수집, 이용동의서(비여신 금융거래) 고객권리 안내문에 동의합니다.";
//				[AppInfo addElectronicSign:@"상품신규 및 개인(신용)정보 수집, 이용동의서(비여신 금융거래)에 동의합니다."];
			}
			else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅과필수적정보동의구분"]) {
				AppInfo.electronicSignTitle = @"상품신규 및 개인(신용)정보 수집, 이용, 제공동의서(상품서비스 안내 등)와 수집, 이용동의서(비여신 금융거래) 고객권리 안내문에 동의합니다.";			
			}
			else if ([[self.userItem objectForKey:@"동의구분"]isEqualToString:@"마케팅동의안함"]) {
				AppInfo.electronicSignTitle = @"예금/적금 가입";
//				[AppInfo addElectronicSign:@"상품신규"];
			}
		}
		else
		{
			AppInfo.electronicSignTitle = @"예금/적금 가입";
//			[AppInfo addElectronicSign:@"상품신규"];
		}
		
		[AppInfo addElectronicSign:@"1.신청내용"];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)거래일자: %@", AppInfo.tran_Date]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", AppInfo.tran_Time]];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)예금종류: %@", [self.dicSelectedData objectForKey:@"상품명"]]];
		
		NSInteger counter = 4;
		if (![[self.userItem objectForKey:@"계약기간" ] isEqualToString:@"0"]) {
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)가입기간: %@개월",counter, [self.userItem objectForKey:@"계약기간" ]] ];
			counter++;
		}
        
        
      
		        
		if ([[self.userItem objectForKey:@"적립방식선택"]length]) {
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)적립방식: %@",counter, [self.userItem objectForKey:@"적립방식선택"]]];
            counter++;
		}
		else
		{
			if ([[self.dicSelectedData objectForKey:@"적립방식_자유적립식여부"] isEqualToString:@"1" ]) {
				[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)적립방식: 자유적립식",counter] ];
			}
			else if ([[self.dicSelectedData objectForKey:@"적립방식_정기적립식여부"] isEqualToString:@"1" ]) {
				[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)적립방식: 정기적립식",counter]];
			}
			else if ([[self.dicSelectedData objectForKey:@"적립방식_정기예금여부"] isEqualToString:@"1" ]) {
				[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)적립방식: 정기예금", counter]];
			}
			counter++;
		}

           SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   @"상품코드" : [self.dicSelectedData objectForKey:@"상품코드"],
							   @"고객번호" : AppInfo.customerNo,
							   @"거래점은행구분" : [self.userItem objectForKey:@"출금계좌은행구분"],
							   @"거래점계좌번호" : [self.userItem objectForKey:@"출금계좌번호"],
							   @"금액" : [self.userItem objectForKey:@"신규금액"],
							   @"합계" : [self.userItem objectForKey:@"신규금액"],
							   @"대분류과목" : @"04",
							   @"신규계좌비밀번호" : [self.userItem objectForKey:@"신규계좌비밀번호"],
							   @"거래구분" : @"00",
							   @"계약기간_개월" : [self.userItem objectForKey:@"계약기간"],
							   @"세금우대종류" : [self.userItem objectForKey:@"세금우대"],
							   @"출금계좌은행구분" : [self.userItem objectForKey:@"출금계좌은행구분"],
							   @"출금계좌번호" : [self.userItem objectForKey:@"출금계좌번호"],
							   @"출금계좌비밀번호" : [self.userItem objectForKey:@"출금계좌비밀번호"],
							   @"출금금액" : [self.userItem objectForKey:@"신규금액"],
							   }];

		
                
        
		//자동재예치 , 자동이체는 조건문 안에
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
		
		
		if ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] &&
            ![[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0"] &&
			([self.userItem objectForKey:@"세금우대_신청금액"] != nil ||
             [[self.userItem objectForKey:@"세금우대_신청금액"] length] != 0) ) {
			[dataSet insertObject:[self.userItem objectForKey:@"세금우대_신청금액"] forKey:@"세금우대한도금액" atIndex:0];

			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)세금우대신청액: %@ 원",counter, [self.userItem objectForKey:@"세금우대_신청금액"] ] ];
			counter++;
		}
        
        if ([[self.userItem objectForKey:@"적립방식선택"]isEqualToString:@"자유적립식"]&&
            ![[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0"] &&
			([self.userItem objectForKey:@"세금우대_신청금액"] != nil ||
             [[self.userItem objectForKey:@"세금우대_신청금액"] length] != 0) ) {
                [dataSet insertObject:[self.userItem objectForKey:@"세금우대_신청금액"] forKey:@"세금우대한도금액" atIndex:0];
                
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)세금우대신청액: %@ 원",counter, [self.userItem objectForKey:@"세금우대_신청금액"] ] ];
                counter++;
        }
		
		[dataSet insertObject:[self.dicSelectedData objectForKey:@"이자지급방법"] forKey:@"이자지급방법" atIndex:0];
		
        
         //2013. 10.28 u드림 회전정기예금
        if (![[self.userItem objectForKey:@"회전주기" ] isEqualToString:@"0"]) {  
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)회전기간: %@개월",counter, [self.userItem objectForKey:@"회전주기" ]] ];
            [dataSet insertObject:[self.userItem objectForKey:@"회전주기"] forKey:@"회전주기" atIndex:0];
			counter++;
		}

        
		//2011.09.16  지급주기 값 구분.....
		Debug(@"회전주기_고정 = %@",[self.dicSelectedData objectForKey:@"회전주기_고정"]);
		if ([self.dicSelectedData objectForKey:@"회전주기_고정"] != nil &&
			![[self.dicSelectedData objectForKey:@"회전주기_고정"] isEqualToString:@""] &&
			![[self.dicSelectedData objectForKey:@"회전주기_고정"] isEqualToString:@"0"]) {
			Debug(@"지급주기 = 회전주기_고정");
			[dataSet insertObject:[self.dicSelectedData objectForKey:@"회전주기_고정"] forKey:@"지급주기" atIndex:0];
		}
        else if (![[self.userItem objectForKey:@"회전주기" ] isEqualToString:@"0"]) //2013. 10.28 u드림 회전정기예금
        {
            [dataSet insertObject:[self.userItem objectForKey:@"회전주기"] forKey:@"지급주기" atIndex:0];  //지급주기는 회전주기 선택값
        }
		else
        {
			Debug(@"지급주기 = 지급주기");
			[dataSet insertObject:[self.dicSelectedData objectForKey:@"지급주기"] forKey:@"지급주기" atIndex:0];
		}
		
		
		if ([self.userItem objectForKey:@"직원번호"] != nil) {
			[dataSet insertObject:[self.userItem objectForKey:@"직원번호"] forKey:@"권유직원번호" atIndex:0];
		}
		if ([self.userItem objectForKey:@"예금별명"] != nil) {
			[dataSet insertObject:[self.userItem objectForKey:@"예금별명"] forKey:@"부제목" atIndex:0];
		}
		if ([self.userItem objectForKey:@"쿠폰번호"] != nil) {
			[dataSet insertObject:[self.userItem objectForKey:@"쿠폰번호"] forKey:@"쿠폰번호" atIndex:0];
		}
		
       // NSLog(@"AppInfo.ollehCoupon %@",AppInfo.ollehCoupon );
        if ( AppInfo.ollehCoupon != nil )  // 올레페이지 올때
            
        {
            if ([[self.dicSelectedData objectForKey:@"상품코드"] isEqualToString:@"230011821"])
            {
                [dataSet insertObject:AppInfo.ollehCoupon forKey:@"비고" atIndex:0];
            }
            
            
        }
        
        
		if ([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"0"]) {
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체: 신청",counter] ];
			counter++;
			//[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체 시작일: %@",counter,[SHBUtility getDateWithDash:[self.userItem objectForKey:@"자동이체_시작일"]]   ] ];
			//counter++;
			
            
            if ([[self.userItem objectForKey:@"말일이체여부"] isEqualToString:@"0"])
            {
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체 시작일: %@",counter,[SHBUtility getDateWithDash:[self.userItem objectForKey:@"자동이체_시작일"]]]];
                counter++;

            }
            else{
                [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체 시작일: %@(%@)",counter,[SHBUtility getDateWithDash:[self.userItem objectForKey:@"자동이체_시작일"]],[NSString stringWithFormat:@"말일이체신청"]]];
                counter++;
                
                
                //[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)말일이체: 신청함",counter]];
                // counter++;

            }
            
            
            
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체 종료일: %@",counter,[SHBUtility getDateWithDash:[self.userItem objectForKey:@"자동이체_종료일"]]   ] ];
			counter++;

           
			
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체 금액: %@ 원",counter,[self.userItem objectForKey:@"자동이체_금액"]]    ];
			counter++;
			
			[dataSet insertObject:[self.userItem objectForKey:@"출금계좌은행구분"] forKey:@"자동이체은행구분" atIndex:0];
            
            
			[dataSet insertObject:[self.userItem objectForKey:@"자동이체_시작일"] forKey:@"자동이체시작일" atIndex:0];
			[dataSet insertObject:[self.userItem objectForKey:@"자동이체_종료일"] forKey:@"자동이체종료일" atIndex:0];
			[dataSet insertObject:[self.userItem objectForKey:@"자동이체_금액"] forKey:@"자동이체금액" atIndex:0];
			// [dataSet insertObject:[self.userItem objectForKey:@"출금계좌번호출력용"] forKey:@"자동이체계좌" atIndex:0];
            [dataSet insertObject:[self.userItem objectForKey:@"출금계좌번호"] forKey:@"자동이체계좌" atIndex:0];
			[dataSet insertObject:@"1" forKey:@"자동이체주기" atIndex:0];
            
            if ([self.userItem objectForKey:@"말일이체여부"]) {
                [dataSet insertObject:[self.userItem objectForKey:@"말일이체여부"] forKey:@"말일이체여부" atIndex:0]; // 2014.3.14  자동이체 말일이체여부 추가.
            }
			
		}
		else if([[self.userItem objectForKey:@"자동이체"] isEqualToString:@"1"]){
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동이체: 신청안함",counter   ] ];
			counter++;
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)말일이체: 신청안함",counter]];
            counter++;

		}

		if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"0"])
        {
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동재예치: 신청안함(만기자동해지)",counter   ] ];
			counter++;
			
			[dataSet insertObject:[self.userItem objectForKey:@"자동재예치"] forKey:@"재예치재원구분" atIndex:0];
            [dataSet insertObject:@"0" forKey:@"재예치통보" atIndex:0];
           
            
		}
		else if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"1"]) {
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동재예치: 원금만 자동재예치",counter   ] ];
			counter++;
			
			[dataSet insertObject:[self.userItem objectForKey:@"자동재예치"] forKey:@"재예치재원구분" atIndex:0];
            
            if ([[self.userItem objectForKey:@"자동재예치결과통지타입"]length])
            {
                if ([[self.userItem objectForKey:@"자동재예치결과통지타입"]isEqualToString:@"0"]) {
                    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동재예치 결과통지: 원하지않음", counter]];
                    counter++;
                    
                    [dataSet insertObject:@"0" forKey:@"재예치통보" atIndex:0];
                }
                else if ([[self.userItem objectForKey:@"자동재예치결과통지타입"]isEqualToString:@"1"]) {
                    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동재예치 결과통지: SMS", counter]];
                    counter++;
                    
                    [dataSet insertObject:@"1" forKey:@"재예치통보" atIndex:0];
                }
                else if ([[self.userItem objectForKey:@"자동재예치결과통지타입"]isEqualToString:@"3"]) {
                    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동재예치 결과통지: E-mail", counter]];
                    counter++;
                    
                    [dataSet insertObject:@"3" forKey:@"재예치통보" atIndex:0];
                }
                else
                {
                    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동재예치 결과통지: 원하지않음", counter]];
                    counter++;
                }
            }


            
		}
		else if ([[self.userItem objectForKey:@"자동재예치"] isEqualToString:@"2"]) {
			[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동재예치: 원리금 자동재예치",counter   ] ];
			counter++;
			
			[dataSet insertObject:[self.userItem objectForKey:@"자동재예치"] forKey:@"재예치재원구분" atIndex:0];
            
            if ([[self.userItem objectForKey:@"자동재예치결과통지타입"]length])
            {
                if ([[self.userItem objectForKey:@"자동재예치결과통지타입"]isEqualToString:@"0"]) {
                    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동재예치 결과통지: 미신청", counter]];
                    counter++;
				
                    [dataSet insertObject:@"0" forKey:@"재예치통보" atIndex:0];
                }
                else if ([[self.userItem objectForKey:@"자동재예치결과통지타입"]isEqualToString:@"1"]) {
                    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동재예치 결과통지: SMS", counter]];
                    counter++;
				
                    [dataSet insertObject:@"1" forKey:@"재예치통보" atIndex:0];
                }
                else if ([[self.userItem objectForKey:@"자동재예치결과통지타입"]isEqualToString:@"3"]) {
                    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동재예치 결과통지: E-mail", counter]];
                    counter++;
				
                    [dataSet insertObject:@"3" forKey:@"재예치통보" atIndex:0];
                }
                else
                {
                    [AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)자동재예치 결과통지: 원하지 않음", counter]];
                    counter++;
                }
            }

		}
		
	
		if ([[self.dicSelectedData objectForKey:@"청약여부"] isEqualToString:@"1"])
        {
			[dataSet insertObject:[self.userItem objectForKey:@"우편번호"] forKey:@"우편번호" atIndex:0];
			[dataSet insertObject:[self.userItem objectForKey:@"청약희망주택형"] forKey:@"청약희망주택형" atIndex:0];
			[dataSet insertObject:[self.userItem objectForKey:@"청약희망주택면적"] forKey:@"청약희망주택면적" atIndex:0];
			//[dataSet insertObject:[self.userItem objectForKey:@"청약주거종류"] forKey:@"청약주거종류" atIndex:0];
			//[dataSet insertObject:[self.userItem objectForKey:@"청약주거구분"] forKey:@"청약주거구분" atIndex:0];
			//[dataSet insertObject:[self.userItem objectForKey:@"청약직업구분"] forKey:@"청약직업구분" atIndex:0];
			//[dataSet insertObject:[self.userItem objectForKey:@"청약결혼여부"] forKey:@"청약결혼여부" atIndex:0];
			[dataSet insertObject:[self.userItem objectForKey:@"청약희망입주지역"] forKey:@"청약희망입주지역" atIndex:0];
			[dataSet insertObject:[self.userItem objectForKey:@"청약희망입주시기"] forKey:@"청약희망입주시기" atIndex:0];

		}
        
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)신규금액: %@ 원",counter,[self.userItem objectForKey:@"신규금액"]    ]];
		counter++;
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(%d)출금계좌번호: %@",counter,[self.userItem objectForKey:@"출금계좌번호출력용"]    ]];
		counter++;
		
		//2010.11.18  상품설명서 관련 추가
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"2.상품설명서 및 약관"] ];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)상품설명서 받기 여부: 받음"] ];
		[AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)약관 받기 여부: 받음"] ];
        
        // 스마트신규인 경우 승인번호 추가
        if (_dicSmartNewData && _dicSmartNewData[@"등록순번"])
        {
			[dataSet insertObject:_dicSmartNewData[@"등록순번"]
                           forKey:@"스마트신규등록순번"
                          atIndex:0];
        }
		
        self.service = nil;
		self.service = [[[SHBProductService alloc]initWithServiceId:kD3604Id viewController:self]autorelease];
		self.service.requestData = dataSet;
		[self.service start];
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
            
			self.service = nil;
			self.service = [[[SHBProductService alloc]initWithServiceId:kC2316Id viewController:self]autorelease];
			self.service.requestData = dataSet;
			[self.service start];
		}
        
        
		else
		{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
			SHBNewProductRegEndViewController *viewController = [[SHBNewProductRegEndViewController alloc]initWithNibName:@"SHBNewProductRegEndViewController" bundle:nil];
			viewController.dicSelectedData = self.dicSelectedData;
			viewController.userItem = self.userItem;
			viewController.completeData = [NSMutableDictionary dictionaryWithDictionary:self.data];
			[self checkLoginBeforePushViewController:viewController animated:YES];
			[viewController release];
		}
	}
    
    
	else if (self.service.serviceId == kC2316Id) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
		SHBNewProductRegEndViewController *viewController = [[SHBNewProductRegEndViewController alloc]initWithNibName:@"SHBNewProductRegEndViewController" bundle:nil];
		viewController.dicSelectedData = self.dicSelectedData;
		viewController.userItem = self.userItem;
		viewController.completeData = [NSMutableDictionary dictionaryWithDictionary:self.data];
		[self checkLoginBeforePushViewController:viewController animated:YES];
		[viewController release];
	}
	
    return NO;
}

@end
