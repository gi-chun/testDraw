//
//  SHBNewProductRegEndViewController.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNewProductRegEndViewController.h"
#import "SHBGoodsSubTitleView.h"
#import "SHBNewProductListViewController.h"
#import "SHBNewProductNoLineRowView.h"
#import "SHBProductService.h"
#import "SHBNewProductEventInfoViewController.h"
#import "SHBSmartTransferAddInputViewController.h"

@interface SHBNewProductRegEndViewController ()
{
	CGFloat fCurrHeight;
    
}

@property (nonatomic, retain) NSMutableArray *interString;	// 이자지급방법

@end

@implementation SHBNewProductRegEndViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
	[_interString release];
	[_dicSelectedData release];
	[_userItem release];
	[_completeData release];
    [_scrollView release];
    [_bottomBackView release];
    [_smartTransferView release];
    [_smartTransferInfo release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setBottomBackView:nil];
    [self setSmartTransferView:nil];
    [self setSmartTransferInfo:nil];
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"예금/적금 가입"];
	[self.view setBackgroundColor:RGB(244, 239, 233)];
	[self returnArr];
	
	[self navigationBackButtonHidden];	// 완료화면에서는 이전버튼이 없단다.
    
	
    
    
    
    if ([self.dicSelectedData objectForKey:@"재형저축신청취소"]) { // 재형저축 신청취소
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"신한 재형저축 신청취소 완료"] maxStep:0 focusStepNumber:0]autorelease]];
    }
    else if([self.userItem objectForKey:@"재형저축가입신청"])
    {
        NSString *title = [self.dicSelectedData objectForKey:@"상품명"];
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 가입신청완료",title] maxStep:5 focusStepNumber:5]autorelease]];

    }
	else {
        NSString *title = [self.dicSelectedData objectForKey:@"상품명"];
        BOOL isSubscription = [[self.dicSelectedData objectForKey:@"청약여부"]isEqualToString:@"1"];
        [self.view addSubview:[[[SHBGoodsSubTitleView alloc]initWithTitle:[NSString stringWithFormat:@"%@ 가입완료",title] maxStep:isSubscription ? 5+1 : 5 focusStepNumber:isSubscription ? 5+1 : 5]autorelease]];
    }
	
	fCurrHeight = 0;
	
	UIView *topView = [[[UIView alloc]init]autorelease];
	[topView setBackgroundColor:[UIColor whiteColor]];
	[self.scrollView addSubview:topView];
	
	CGFloat fHeight = 6;
	NSString *strGuide = @"";
    
    if ([self.dicSelectedData objectForKey:@"재형저축신청취소"]) { // 재형저축 신청취소
        strGuide = @"고객님께서 신청하신 재형저축 신청이 취소 되었습니다.";
    }
    else if([self.userItem objectForKey:@"재형저축가입신청"])
    {
       strGuide = @"감사합니다. 재형저축 상품 예약이 아래와 같이 완료되었습니다.";
        
    }
    else {
        strGuide = [NSString stringWithFormat:@"감사합니다!\n\"%@\" 신규가 정상적으로 처리되었습니다.", [self.userItem objectForKey:@"상품명"]];
    }          
    
	CGSize size = [strGuide sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(301, 999) lineBreakMode:NSLineBreakByWordWrapping];
	
	UILabel *lblGuide = [[[UILabel alloc]initWithFrame:CGRectMake(8, fHeight, 301, size.height)]autorelease];
	[lblGuide setNumberOfLines:0];
	[lblGuide setBackgroundColor:[UIColor clearColor]];
	[lblGuide setTextColor:RGB(40, 91, 142)];
	[lblGuide setFont:[UIFont systemFontOfSize:13]];
	[lblGuide setText:strGuide];
	[topView addSubview:lblGuide];
	fHeight += size.height + 6;
	
	[topView setFrame:CGRectMake(0, 0, 317, fHeight)];
	fCurrHeight = fHeight;
	
	UIView *lineView = [[[UIView alloc]initWithFrame:CGRectMake(0, fCurrHeight, 317, 1)]autorelease];
	[lineView setBackgroundColor:RGB(209, 209, 209)];
	[topView addSubview:lineView];
	
    if (AppInfo.ollehCoupon ==nil &&
        [[self.completeData objectForKey:@"상품코드"]isEqualToString:@"230011821"]) // 상품리스트에서 진입이고, 올레 상품일때
    {
        
       SHBDataSet *forwardData = [[[SHBDataSet alloc] initWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                      TASK_ACTION_KEY : @"selectTeckerBar",
                                      @"PRODUCT_CODE" : @"KT",
                                      }] autorelease];
        
        // release 추가
        self.service = nil;
        self.service = [[[SHBProductService alloc] initWithServiceId:XDA_TICKER viewController:self] autorelease];
        self.service.requestData = forwardData;
        [self.service start];
        return;
        
        
        
        
    }
	
    else{
        
        [self setNoLineRowView]; // 일반 상품
    }
    
    if (![[self.completeData objectForKey:@"상품코드"] isEqualToString:@"230011831"]) {
        
        // 신한 저축습관만들기의 경우 미리 setNoLineRowView에서 이미 하고 오기 때문에 안해도 됨
        
        // ios7상단 스크롤
        FrameResize(self.scrollView, 317, height(self.scrollView));
        FrameReposition(self.scrollView, 0, 77);
        FrameReposition(self.bottomBackView, left(self.bottomBackView), fCurrHeight+=12);
        
        [self.scrollView setContentSize:CGSizeMake(width(self.scrollView), fCurrHeight += 83)];
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
	[self.scrollView flashScrollIndicators];
}

#pragma mark - UI
- (void)setNoLineRowView
{
    [self startTicker];
    
    NSString *strTemp = nil;
    
    
    ///////////////////////////////재형저축가입신청 시작 //////////////////////////////////
    if ([self.userItem objectForKey:@"재형저축가입신청"])
    { // 재형저축 가입 신청
        
        strTemp = [self.dicSelectedData objectForKey:@"상품명"];
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=10 title:@"예금명" value:strTemp] autorelease];
        [self.scrollView addSubview:row1];
        
              
        strTemp = [[self.completeData  objectForKey:@"계좌번호"] substringWithRange:NSMakeRange([[self.completeData  objectForKey:@"계좌번호"] length] - 6, 6)];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신청번호" value:strTemp] autorelease];
        [self.scrollView addSubview:row2];
        
        
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적립방식" value:@"자유적립식"] autorelease];
        [self.scrollView addSubview:row3];
        
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"계약기간" value:@"84개월"] autorelease];
        [self.scrollView addSubview:row4];
        
        strTemp = [NSString stringWithFormat:@"%@원", [self.userItem objectForKey:@"신규금액"]];
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"최초불입금" value:strTemp] autorelease];
        [self.scrollView addSubview:row5];
        
        
        
        strTemp = [self.completeData objectForKey:@"신규일"];
        SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규예약일" value:strTemp] autorelease];
        [self.scrollView addSubview:row6];
        
        strTemp = [self.completeData objectForKey:@"만기일"];
        SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"만기일" value:strTemp] autorelease];
        [self.scrollView addSubview:row7];
        
              
        SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적용과세" value:@"이자(배당)소득 비과세(농특세 1.4% 징수)"] autorelease];
        [self.scrollView addSubview:row8];
        
       
        strTemp = [NSString stringWithFormat:@"%@원",[self.userItem objectForKey:@"분기당납입한도"]];
        SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"분기당납입한도" value:strTemp] autorelease];
        [self.scrollView addSubview:row9];

        if ([[self.userItem objectForKey:@"자동이체신청"]isEqualToString:@"자동이체신청"])
        {
            strTemp = [self.completeData objectForKey:@"자동이체시작일"];
            SHBNewProductNoLineRowView *row10 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"자동이체시작일" value:strTemp] autorelease];
            [self.scrollView addSubview:row10];
        
            strTemp = [self.completeData objectForKey:@"자동이체종료일"];
            SHBNewProductNoLineRowView *row11 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"자동이체종료일" value:strTemp] autorelease];
            [self.scrollView addSubview:row11];
        

            strTemp = [NSString stringWithFormat:@"%@원",[self.userItem objectForKey:@"자동이체금액"]];
            SHBNewProductNoLineRowView *row12 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"자동이체금액" value:strTemp] autorelease];
            [self.scrollView addSubview:row12];
            
            strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
            SHBNewProductNoLineRowView *row13 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp] autorelease];
            [self.scrollView addSubview:row13];
            
            
            SHBNewProductNoLineRowView *row14 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"상품설명서 받기 여부" value:@"받음"] autorelease];
            [self.scrollView addSubview:row14];
            
            SHBNewProductNoLineRowView *row15 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"약관받기 여부" value:@"받음"] autorelease];
            [self.scrollView addSubview:row15];
            
            strTemp = [self.userItem objectForKey:@"소득금액증명발급번호"];
            SHBNewProductNoLineRowView *row16 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"소득금액증명서 발급번호" value:strTemp] autorelease];
            [self.scrollView addSubview:row16];
            
            
            NSString *phoneNumber = [self.userItem objectForKey:@"휴대폰번호"];
            NSString *number = [phoneNumber substringWithRange:NSMakeRange(0, [phoneNumber length] - 4)];
            
            strTemp = [NSString stringWithFormat:@"%@****", number];
            SHBNewProductNoLineRowView *row17 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"휴대폰번호" value:strTemp] autorelease];
            [self.scrollView addSubview:row17];
        }
        
       else
       {
            strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
            SHBNewProductNoLineRowView *row10 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp] autorelease];
            [self.scrollView addSubview:row10];
            
            
            SHBNewProductNoLineRowView *row11 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"상품설명서 받기 여부" value:@"받음"] autorelease];
            [self.scrollView addSubview:row11];
            
            SHBNewProductNoLineRowView *row12 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"약관받기 여부" value:@"받음"] autorelease];
            [self.scrollView addSubview:row12];
            
            strTemp = [self.userItem objectForKey:@"소득금액증명발급번호"];
            SHBNewProductNoLineRowView *row13 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"소득금액증명서 발급번호" value:strTemp] autorelease];
            [self.scrollView addSubview:row13];
            
           NSString *phoneNumber = [self.userItem objectForKey:@"휴대폰번호"];
           NSString *number = [phoneNumber substringWithRange:NSMakeRange(0, [phoneNumber length] - 4)];
           
           strTemp = [NSString stringWithFormat:@"%@****", number];
            SHBNewProductNoLineRowView *row14 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"휴대폰번호" value:strTemp] autorelease];
            [self.scrollView addSubview:row14];

        
        }
        
        
        
        fCurrHeight += 15+5;
        
        //재형저축 안내 뷰
        [self.scrollView addSubview:self.viewTaxBreak];
        [self.viewTaxBreak setFrame:CGRectMake(0, fCurrHeight+8, self.viewTaxBreak.frame.size.width, self.viewTaxBreak.frame.size.height)];
            
        fCurrHeight += self.viewTaxBreak.frame.size.height + 10;
        

        return;
        
    }
///////////////////////////////재형저축가입신청 끝 //////////////////////////////////
   
    
    
 ///////////////////////////////재형저축신청취소 시작 //////////////////////////////////   
   if ([self.dicSelectedData objectForKey:@"재형저축신청취소"])
   { // 재형저축 신청취소
        strTemp = [self.dicSelectedData objectForKey:@"상품명"];
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=10 title:@"예금명" value:strTemp] autorelease];
        [self.scrollView addSubview:row1];
        
        strTemp = [self.dicSelectedData objectForKey:@"_신청번호"];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신청번호" value:strTemp] autorelease];
        [self.scrollView addSubview:row2];
        
        strTemp = [self.dicSelectedData objectForKey:@"_신규예정일"];
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규 예정일" value:strTemp] autorelease];
        [self.scrollView addSubview:row3];
        
        strTemp = [self.dicSelectedData objectForKey:@"_만기일"];
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"만기일" value:strTemp] autorelease];
        [self.scrollView addSubview:row4];
        
        strTemp = [self.dicSelectedData objectForKey:@"_신규금액"];
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규예정금액" value:strTemp] autorelease];
        [self.scrollView addSubview:row5];
        
        fCurrHeight += 15+5;
        
        return;
    }
    
        ///////////////////////////////재형저축취소신청 끝  //////////////////////////////////
    
    
    
    
     //////////////////////////////신탁상품 시작  //////////////////////////////////
    
    if ([self.dicSelectedData objectForKey:@"신탁상품가입"])
    {
        strTemp = [self.dicSelectedData objectForKey:@"상품명"];
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=10 title:@"예금명" value:strTemp] autorelease];
        [self.scrollView addSubview:row1];
        
         strTemp = [self.completeData objectForKey:@"계좌번호"];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"계좌번호" value:strTemp] autorelease];
        [self.scrollView addSubview:row2];
        
        strTemp = [self.completeData objectForKey:@"고객성명"];
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"고객명" value:strTemp] autorelease];
        [self.scrollView addSubview:row3];
        
         strTemp = [self.completeData objectForKey:@"펀드번호"];
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"펀드번호" value:strTemp] autorelease];
        [self.scrollView addSubview:row4];


         strTemp = [NSString stringWithFormat:@"%@원",[self.completeData objectForKey:@"거래금액"]];
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규금액" value:strTemp] autorelease];
        [self.scrollView addSubview:row5];
        
        strTemp = [self.completeData objectForKey:@"거래좌수"];
        SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"거래좌수" value:strTemp] autorelease];
        [self.scrollView addSubview:row6];
        
        strTemp = [self.completeData objectForKey:@"계약기간월수"];
        SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"계약기간월수" value:strTemp] autorelease];
        [self.scrollView addSubview:row7];

        strTemp = [self.userItem objectForKey:@"통보방법"];
        SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"운영내역통보방법" value:strTemp] autorelease];
        [self.scrollView addSubview:row8];
        
        strTemp = [self.completeData objectForKey:@"신규일"];
        SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규일" value:strTemp] autorelease];
        [self.scrollView addSubview:row9];
        
        strTemp = [self.completeData objectForKey:@"만기일"];
        SHBNewProductNoLineRowView *row10 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적립만기일" value:strTemp] autorelease];
        [self.scrollView addSubview:row10];
        
        strTemp = [self.completeData objectForKey:@"연금지급만기일"];
        SHBNewProductNoLineRowView *row11 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"연금지급만기일" value:strTemp] autorelease];
        [self.scrollView addSubview:row11];
        
        strTemp = [NSString stringWithFormat:@"%@ 년",[self.completeData objectForKey:@"연금지급기간"]];
        SHBNewProductNoLineRowView *row12 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"연금지급기간" value:strTemp] autorelease];
        [self.scrollView addSubview:row12];
        
        strTemp = [NSString stringWithFormat:@"%@원",[self.completeData objectForKey:@"세금우대한도금액"]];
        SHBNewProductNoLineRowView *row13 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"연간적립한도금액" value:strTemp] autorelease];
        [self.scrollView addSubview:row13];
        
        
        fCurrHeight += 15+5;
        
        return;
    }
    
    ///////////////////////////////신탁상품 끝  //////////////////////////////////
    
    

    //////////////////////////////////// 쿠폰상품 시작 //////////////////////////////////  
    //영업점 승인 가입
    if ([[self.dicSelectedData objectForKey:@"쿠폰상품여부"] isEqualToString:@"1"] )  // 영업점 승인 민트정기예금
    {
        
        strTemp = [self.dicSelectedData objectForKey:@"상품명"];
        SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=10 title:@"예금명" value:strTemp] autorelease];
        [self.scrollView addSubview:row1];
        
        strTemp = [self.completeData objectForKey:@"계좌번호"];
        SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규계좌번호" value:strTemp] autorelease];
        [self.scrollView addSubview:row2];
        
        
        strTemp = [self.dicSelectedData objectForKey:@"이자지급방법문구"];
        SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"이자지급방법" value:strTemp] autorelease];
        [self.scrollView addSubview:row3];
        
        strTemp = [NSString stringWithFormat:@"정기예금"];
        SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적립방식" value:strTemp] autorelease];
        [self.scrollView addSubview:row4];
        
        strTemp =  [self.dicSelectedData objectForKey:@"가입기간문구"];
        SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"계약기간" value:strTemp] autorelease];
        [self.scrollView addSubview:row5];
        
        if (![[self.completeData objectForKey:@"회전주기"] isEqualToString:@"0"])
        {
            strTemp = [NSString stringWithFormat:@"%@개월",[self.dicSelectedData objectForKey:@"회전주기"]];
            SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"회전기간" value:strTemp] autorelease];
            [self.scrollView addSubview:row6];
        }
        
        strTemp = [NSString stringWithFormat:@"%@원",[self.completeData objectForKey:@"거래금액"]];
        SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"최초가입액" value:strTemp] autorelease];
        [self.scrollView addSubview:row7];
        
        strTemp = [NSString stringWithFormat:@"%@%%",[self.dicSelectedData objectForKey:@"적용금리"]];
        SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적용이율" value:strTemp] autorelease];
        [self.scrollView addSubview:row8];
        
        strTemp = [self.completeData objectForKey:@"신규일"];
        SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"신규일" value:strTemp] autorelease];
        [self.scrollView addSubview:row9];
        
        strTemp = [self.completeData objectForKey:@"만기일"];
        SHBNewProductNoLineRowView *row10 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"만기일" value:strTemp] autorelease];
        [self.scrollView addSubview:row10];
        
        
        if ([[self.completeData objectForKey:@"세금우대종류"]isEqualToString:@"0"]) {
            strTemp = @"일반과세";
        }
        else if ([[self.completeData objectForKey:@"세금우대종류"]isEqualToString:@"1"]) {
            strTemp = @"세금우대";
        }
        else if ([[self.completeData objectForKey:@"세금우대종류"]isEqualToString:@"2"]) {
            strTemp = @"비과세(생계형)";
        }
        
        SHBNewProductNoLineRowView *row11 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"적용과세" value:strTemp] autorelease];
        [self.scrollView addSubview:row11];
        
        if ([[self.dicSelectedData objectForKey:@"세금우대_금액입력여부"] isEqualToString:@"1"] &&
            ![[self.userItem objectForKey:@"세금우대"] isEqualToString:@"0" ] ) {
            
            if ([self.userItem objectForKey:@"세금우대_신청금액"] ==nil || [[self.userItem objectForKey:@"세금우대_신청금액"] isEqualToString:@"" ]) {
                strTemp = @"0원";
            }
            else {
                strTemp = [NSString stringWithFormat:@"%@원",[self.userItem objectForKey:@"세금우대_신청금액"]];
            }
            SHBNewProductNoLineRowView *row12 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"세금우대신청금액" value:strTemp] autorelease];
            [self.scrollView addSubview:row12];
        }
        
        strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
        SHBNewProductNoLineRowView *row13 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp] autorelease];
        [self.scrollView addSubview:row13];

                
        strTemp = [self.dicSelectedData objectForKey:@"승인신청행원번호"];
        SHBNewProductNoLineRowView *row14 = [[[SHBNewProductNoLineRowView alloc] initWithYOffset:fCurrHeight+=25 title:@"권유직원번호" value:strTemp] autorelease];
        [self.scrollView addSubview:row14];
        

        SHBNewProductNoLineRowView *row15 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"상품설명서 받기 여부" value:@"받음"]autorelease];
        [self.scrollView addSubview:row15];
        
        SHBNewProductNoLineRowView *row16 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"약관 받기 여부" value:@"받음"]autorelease];
        [self.scrollView addSubview:row16];

        fCurrHeight += 15+5;
        
        return;
    }
	
    //////////////////////////////////// 쿠폰상품끝 //////////////////////////////////   
    
    
    
    
    //////////////////////////////////// 기본상품신규 시작 ////////////////////////////////// 
	strTemp = [[self.completeData objectForKey:@"부기명"]length] ? [NSString stringWithFormat:@"%@(%@)", [self.dicSelectedData objectForKey:@"상품명"], [self.completeData objectForKey:@"부기명"]] : [self.dicSelectedData objectForKey:@"상품명"];
	SHBNewProductNoLineRowView *row1 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=10 title:@"예금명" value:strTemp isTicker:YES]autorelease];
	[self.scrollView addSubview:row1];
	
	strTemp = [self.completeData objectForKey:@"계좌번호"];
	SHBNewProductNoLineRowView *row2 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"신규계좌번호" value:strTemp]autorelease];
	[self.scrollView addSubview:row2];
	
	strTemp = [_interString objectAtIndex:[[self.completeData objectForKey:@"이자지급방법"]intValue]];
	SHBNewProductNoLineRowView *row3 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"적립방식" value:strTemp]autorelease];
	[self.scrollView addSubview:row3];
	
    
	if ([[self.completeData objectForKey:@"계약기간월수"]isEqualToString:@"0"]
		&& ![[self.dicSelectedData objectForKey:@"청약여부"]isEqualToString:@"1"]) {
		
		strTemp = [NSString stringWithFormat:@"%@개월", [self.completeData objectForKey:@"계약기간월수"]];
		SHBNewProductNoLineRowView *row4 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"계약기간" value:strTemp]autorelease];
		[self.scrollView addSubview:row4];
	}
    
    
    if([[self.dicSelectedData objectForKey:@"회전주기_선택비트"] isEqualToString:@"136"])
    {
    strTemp = [NSString stringWithFormat:@"%@개월", [self.completeData objectForKey:@"회전주기"]];
	SHBNewProductNoLineRowView *row5 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"회전기간" value:strTemp]autorelease];
	[self.scrollView addSubview:row5];
    }
	
	strTemp = [NSString stringWithFormat:@"%@원", [self.completeData objectForKey:@"거래금액"]];
    
    if ([self.dicSelectedData[@"상품코드"] isEqualToString:@"200013410"]) { // u드림 회전정기예금의 경우 최초가입액으로 보여짐
        SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"최초가입액" value:strTemp]autorelease];
        [self.scrollView addSubview:row6];
    }
    else {
        SHBNewProductNoLineRowView *row6 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"신규금액" value:strTemp]autorelease];
        [self.scrollView addSubview:row6];
    }
	
	
	if (![[self.dicSelectedData objectForKey:@"청약여부"]isEqualToString:@"1"]) {
		strTemp = [NSString stringWithFormat:@"%.2f %%", [[self.completeData objectForKey:@"기본이율"]floatValue]];
		SHBNewProductNoLineRowView *row7 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"적용이율" value:strTemp]autorelease];
		[self.scrollView addSubview:row7];
	}
	
	strTemp = [self.completeData objectForKey:@"신규일"];
	SHBNewProductNoLineRowView *row8 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"신규일자" value:strTemp]autorelease];
	[self.scrollView addSubview:row8];
	
	if (![[self.dicSelectedData objectForKey:@"청약여부"]isEqualToString:@"1"]) {
		strTemp = [self.completeData objectForKey:@"만기일"];
		SHBNewProductNoLineRowView *row9 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"만기일자" value:strTemp]autorelease];
		[self.scrollView addSubview:row9];
	}
	
	if ([[self.completeData objectForKey:@"세금우대종류"]isEqualToString:@"0"]) {
		strTemp = @"일반과세";
	}
	else if ([[self.completeData objectForKey:@"세금우대종류"]isEqualToString:@"1"]) {
		strTemp = @"세금우대";
	}
	else if ([[self.completeData objectForKey:@"세금우대종류"]isEqualToString:@"2"]) {
		strTemp = @"비과세(생계형)";
	}
	SHBNewProductNoLineRowView *row10 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"적용과세" value:strTemp]autorelease];
	[self.scrollView addSubview:row10];
	
	if (![[self.completeData objectForKey:@"세금우대한도금액"]isEqualToString:@"0"]) {
        strTemp = [NSString stringWithFormat:@"%@원", [SHBUtility normalStringTocommaString:[self.completeData objectForKey:@"세금우대한도금액"]]];
		SHBNewProductNoLineRowView *row11 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"세금우대신청금액" value:strTemp]autorelease];
		[self.scrollView addSubview:row11];
	}
	
	if ([[self.completeData objectForKey:@"자동이체시작일"]length]) {
		strTemp = [self.completeData objectForKey:@"자동이체시작일"];
		SHBNewProductNoLineRowView *row12 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"자동이체시작일" value:strTemp]autorelease];
		[self.scrollView addSubview:row12];
	}
	
	if ([[self.completeData objectForKey:@"자동이체종료일"]length]) {
		strTemp = [self.completeData objectForKey:@"자동이체종료일"];
		SHBNewProductNoLineRowView *row13 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"자동이체종료일" value:strTemp]autorelease];
		[self.scrollView addSubview:row13];
	}
	
	if ([self.completeData objectForKey:@"자동이체금액"]
		&& [[self.completeData objectForKey:@"자동이체금액"]length]) {
		strTemp = [NSString stringWithFormat:@"%@원", [self.completeData objectForKey:@"자동이체금액"]];
		SHBNewProductNoLineRowView *row14 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"자동이체금액" value:strTemp]autorelease];
		[self.scrollView addSubview:row14];
	}
	
	if ([self.userItem objectForKey:@"자동재예치"]) {
		if ([[self.userItem objectForKey:@"자동재예치"]isEqualToString:@"0"]) {
			strTemp = @"신청안함(만기자동해지)";
		}
		else if ([[self.userItem objectForKey:@"자동재예치"]isEqualToString:@"1"]) {
			strTemp = @"원금만 자동재예치";
		}
		else if ([[self.userItem objectForKey:@"자동재예치"]isEqualToString:@"2"]) {
			strTemp = @"원리금 자동재예치";
		}
		
		SHBNewProductNoLineRowView *row15 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"자동재예치" value:strTemp]autorelease];
		[self.scrollView addSubview:row15];
    }
	
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
            else{
                strTemp = @"원하지 않음";
            }
            
            SHBNewProductNoLineRowView *row = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"자동재예치결과통지" value:strTemp]autorelease];
            [self.scrollView addSubview:row];

        
		}
	}
	
	strTemp = [self.userItem objectForKey:@"출금계좌번호출력용"];
	SHBNewProductNoLineRowView *row16 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"출금계좌번호" value:strTemp]autorelease];
	[self.scrollView addSubview:row16];
	
	SHBNewProductNoLineRowView *row17 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"상품설명서 받기 여부" value:@"받음"]autorelease];
	[self.scrollView addSubview:row17];
	
	SHBNewProductNoLineRowView *row18 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"약관 받기 여부" value:@"받음"]autorelease];
	[self.scrollView addSubview:row18];
	
    
    if (AppInfo.ollehCoupon == nil )  // 기존상품쿠폰 경우~~~
    {
        if ([self.completeData objectForKey:@"쿠폰번호"] && [[self.completeData objectForKey:@"쿠폰번호"]length]) {
            strTemp = [self.completeData objectForKey:@"쿠폰번호"];
            SHBNewProductNoLineRowView *row19 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"쿠폰번호" value:strTemp]autorelease];
            [self.scrollView addSubview:row19];
        }
    }
    else
    {
          strTemp = AppInfo.ollehCoupon;   // 올레상품 쿠폰~~
          SHBNewProductNoLineRowView *row19 = [[[SHBNewProductNoLineRowView alloc]initWithYOffset:fCurrHeight+=25 title:@"올레쿠폰번호" value:strTemp]autorelease];
          [self.scrollView addSubview:row19];
        
    }

	fCurrHeight += 15+5;
    
    if ([[self.completeData objectForKey:@"상품코드"]isEqualToString:@"230011821"] &&
         AppInfo.ollehCoupon == nil)
    {   // 올레tv적금 상품신규 진입시
        
        
        //올레티커 뷰
        [self.scrollView addSubview:_tickerView];
        [_tickerView setFrame:CGRectMake(18, fCurrHeight+8, _tickerView.frame.size.width, _tickerView.frame.size.height)];
        
        fCurrHeight += _tickerView.frame.size.height ;
        FrameReposition(self.bottomBackView, left(self.bottomBackView), fCurrHeight+=12);
         [self.scrollView setContentSize:CGSizeMake(width(self.scrollView), fCurrHeight += 70 )];
        
     
    }
    
    if ([[self.completeData objectForKey:@"상품코드"] isEqualToString:@"230011831"]) {
        
        // 신한 저축습관만들기
        
        [_smartTransferInfo initFrame:_smartTransferInfo.frame];
        [_smartTransferInfo setText:@"<midGray_13>알림(Push)서비스를 받으시려면 </midGray_13><midRed_13>스마트이체</midRed_13><midGray_13> 설정을 등록하셔야 합니다!</midGray_13>"];
        
        FrameReposition(_smartTransferView, 0, fCurrHeight + height(self.bottomBackView) + 20);
        [self.scrollView addSubview:_smartTransferView];
        
        FrameResize(self.scrollView, 317, height(self.scrollView));
        FrameReposition(self.scrollView, 0, 77);
        [self.scrollView setContentSize:CGSizeMake(width(self.scrollView), fCurrHeight + 20 + height(_smartTransferView) + height(self.bottomBackView) + 15)];
        FrameReposition(self.bottomBackView, left(self.bottomBackView), fCurrHeight += 8);
    }
    
    return;
    
    
    //////////////////////////////////// 기본상품신규 끝//////////////////////////////////
}

#pragma mark - Etc.

// 이자지급방법
-(void)returnArr{
	self.interString = [NSMutableArray array];
	[_interString addObject:@"미사용"];//0
	[_interString addObject:@"이자지급식"];
	[_interString addObject:@"만기일시지급-복리식"];
	[_interString addObject:@"만기일시지급-단리식"];
	[_interString addObject:@"결산원가식"];
	[_interString addObject:@"지급거래시지급식"];//5
	[_interString addObject:@"입금거래시지급시"];
	[_interString addObject:@"지급거래시원가식"];
	[_interString addObject:@"입금거래시원가식"];
	[_interString addObject:@"결산원가식+지급거래시원가식"];
	[_interString addObject:@"결산원가식+입금거래시원가식"];//10
	[_interString addObject:@"결산원가식+지급거래시지급식"];
	[_interString addObject:@""];
	[_interString addObject:@""];
	[_interString addObject:@"만기일시지급-회전주기복리식"];
	[_interString addObject:@""];//15
	[_interString addObject:@""];
	[_interString addObject:@"결산원가-복리식"];//17
	[_interString addObject:@"고객지정일지급식"];
	[_interString addObject:@"결산원가-복리식+지급거래시지급식"];
	[_interString addObject:@""];//20
	[_interString addObject:@"이자지급-회전주기복리식"];
	[_interString addObject:@"이자지급-(복리식+지급이자복리식)"];
	[_interString addObject:@"만기일시지급-단리식+지급거래시지급식"];
	[_interString addObject:@"만기일시지급-복리식+지급거래시지급식"];
	[_interString addObject:@"할인식"];//25
	[_interString addObject:@"복리식"];
	[_interString addObject:@"이표식"];
	[_interString addObject:@"액면식"];
	[_interString addObject:@"결산원가식+연금지급시지급식"];
	[_interString addObject:@"연금지급시지급식"];//30
	[_interString addObject:@"만기일시원가-복리식"];
	[_interString addObject:@"결산원가-만기후-복리식"];
	[_interString addObject:@"만기일시지급-단리식+중도이자지급식"];
	[_interString addObject:@"연금지급+원리금균등"];
	[_interString addObject:@"원금균등연금연복리만기일시"];//35	
}

#pragma mark - Action

- (IBAction)confirmBtnAction:(SHBButton *)sender
{
    if ([self.dicSelectedData objectForKey:@"재형저축신청취소"]) { // 재형저축 신청취소
        for (SHBBaseViewController *viewController in self.navigationController.viewControllers)
        {
            if ([viewController isKindOfClass:[SHBNewProductListViewController class]]) {
                [self.navigationController fadePopToViewController:viewController];
            }
        }
        
        return;
    }
    
    for (UIViewController *viewController in [self.navigationController viewControllers]) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:viewController];
    }
    
    if ([[self.completeData objectForKey:@"상품코드"] isEqualToString:@"230011831"]) {
        
        // 신한 저축습관만들기
        
        [UIAlertView showAlert:self
                          type:ONFAlertTypeOneButton
                           tag:121314
                         title:@""
                       message:@"신한 저축습관만들기 적금을 가입해 주셔서 감사합니다.\n\n확인을 누르시면 스마트이체 설정등록이 진행됩니다!"];
        return;
    }
    
	[self.navigationController fadePopToRootViewController];
}



- (IBAction)tickerButton:(id)sender
{
    
    SHBNewProductEventInfoViewController *viewController = [[[SHBNewProductEventInfoViewController alloc]initWithNibName:@"SHBNewProductEventInfoViewController" bundle:nil]autorelease];
    [self checkLoginBeforePushViewController:viewController animated:YES];
}



- (void)startTicker{
   
    if ([tickArray count] > 0)
    {
        for (int i = 0; i < [tickArray count]; i++)
        {
            NSDictionary *nDic = [tickArray objectAtIndex:i];
            NSURL *imgURL = [NSURL URLWithString:[nDic objectForKey:@"아이콘Url"]];
            NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
            
            switch (i)
            {
                case 0:
                    
                    _bannerMainBtn1.accessibilityLabel = [nDic objectForKey:@"티커제목"];
                    [_bannerMainBtn1 setBackgroundImage:[UIImage imageWithData:imgData] forState:UIControlStateNormal];

                    
                    break;
                
                default:
                    break;
            }
        }


    }
    
    
   
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    
    if (alertView.tag == 121314) {
        
        self.service = nil;
        self.service = [[[SHBProductService alloc] initWithServiceCode:@"D0011" viewController:self] autorelease];
        self.service.requestData = [SHBDataSet dictionaryWithDictionary:@{ }];
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

- (BOOL)onBind:(OFDataSet *)aDataSet
{
    if ([self.service.strServiceCode isEqualToString:@"D0011"] && [[self.completeData objectForKey:@"상품코드"] isEqualToString:@"230011831"]) {
        
        SHBSmartTransferAddInputViewController *viewController = [[[SHBSmartTransferAddInputViewController alloc] initWithNibName:@"SHBSmartTransferAddInputViewController" bundle:nil] autorelease];
        
        [self checkLoginBeforePushViewController:viewController animated:YES];
        
        return NO;
    }
    
    Debug(@"aDataSet : %@", aDataSet);
    
    tickArray = [aDataSet arrayWithForKeyPath:@"data.Ticker"];
    [self setNoLineRowView];
    
    return NO;
}

@end
