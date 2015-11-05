//
//  SHBFundSecurityCardViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 19..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBFundSecurityCardViewController.h"
#import "SHBFundTransCompleteYViewController.h"
#import "SHBFundTransCompleteNViewController.h"
#import "SHBFundService.h"
#import "SHBScrollingTicker.h"

@interface SHBFundSecurityCardViewController ()
{
    SHBScrollingTicker *scrollingTicker;

}
@end

@implementation SHBFundSecurityCardViewController

@synthesize accountNo;
@synthesize dicDataDictionary;
@synthesize basicLabel00;
@synthesize basicLabel01;
@synthesize basicLabel02;
@synthesize basicLabel03;
@synthesize basicLabel04;
@synthesize basicLabel05;
@synthesize basicLabel06;
@synthesize basicLabel07;
@synthesize basicLabel08;
@synthesize basicLabel09;
@synthesize basicLabel10;
@synthesize basicLabel11;
@synthesize basicLabel12;
@synthesize basicLabel13;
@synthesize basicLabel14;
@synthesize basicLabel15;
@synthesize basicLabel16;
@synthesize basicLabel17;
//@synthesize data_D6010;
@synthesize data_D6310;
@synthesize data_D6320;

- (void)displayDrawingConfirmData
{
    
    
//    basicLabel01.text = [data_D6320 objectForKey:@"계좌번호"];
    // 구계좌번호시 문제로 수정
    if([[data_D6310 objectForKey:@"신계좌변환여부"] isEqualToString:@"0"] || [[data_D6310 objectForKey:@"구계좌사용여부"] isEqualToString:@"1"])
    {
        basicLabel01.text = [data_D6310 objectForKey:@"구계좌번호"];
    }
    else
    {
        // 310 계좌번호와 차이 없다
        basicLabel01.text = [data_D6320 objectForKey:@"계좌번호"];
    }
    
    // 연결계좌번호
    basicLabel02.text = [data_D6320 objectForKey:@"내용3"];
    
    // 기준가적용일
    if ([[data_D6320 objectForKey:@"내용6"] isEqualToString:@"당일출금"])
	{
		basicLabel03.text = [data_D6320 objectForKey:@"COM_TRAN_DATE"];
	}
	else
	{
		basicLabel03.text = [data_D6310 objectForKey:@"환매기준가일"];
	}
    
    // 출금예정일자
    if ([[data_D6320 objectForKey:@"내용6"] isEqualToString:@"당일출금"])
	{
		basicLabel04.text = [data_D6320 objectForKey:@"COM_TRAN_DATE"];
	}
	else
	{
		basicLabel04.text = [data_D6310 objectForKey:@"환매예정일자"];
	}
    
    // 거래구분
    basicLabel05.text = [data_D6320 objectForKey:@"내용4"];
    
    // 거래번호
    basicLabel06.text = [data_D6320 objectForKey:@"항목내용8"];
    basicLabel07.text = [data_D6320 objectForKey:@"내용8"];
    
    // 환매기준가
    basicLabel08.text = [data_D6320 objectForKey:@"항목내용9"];
    basicLabel09.text = [data_D6320 objectForKey:@"내용9"];
    
    // 받는 내역 데이타 계산.
	NSMutableArray *recvTitle = [[NSMutableArray alloc] init];
	NSMutableArray *recvText = [[NSMutableArray alloc] init];
	NSMutableArray *deductTitle = [[NSMutableArray alloc] init];
	NSMutableArray *deductText = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < 9; i++)
	{
		NSString *title =[data_D6320 objectForKey:[NSString stringWithFormat:@"지급항목%d",i+1]];
		NSString *text  =[data_D6320 objectForKey:[NSString stringWithFormat:@"지급내용%d",i+1]];
		if ([title length] > 0 && [text length] > 0)
		{
			[recvTitle addObject:title];
			[recvText addObject:text];
		}
	}
	
	for (int i = 0; i < 9; i++)
	{
		NSString *title =[data_D6320 objectForKey:[NSString stringWithFormat:@"공제항목%d",i+1]];
		NSString *text  =[data_D6320 objectForKey:[NSString stringWithFormat:@"공제내용%d",i+1]];
		if ([title length] > 0 && [text length] > 0)
		{
			[deductTitle addObject:title];
			[deductText addObject:text];
		}
	}
	
    // 받으시는 내역
    for( int t = 1; t <= [recvTitle count]; t++) {
		UILabel *T_TText = [[UILabel alloc] init];
		[T_TText setFrame:CGRectMake(8, 248 + ((t-1)*25), 100, 15)];
        [T_TText setText:[recvTitle objectAtIndex:t - 1]];
        T_TText.textColor = RGB(74, 74, 74);//[UIColor blackColor];
        T_TText.backgroundColor = [UIColor clearColor];
        T_TText.font = [UIFont systemFontOfSize:15.0f];
		T_TText.tag = t;
		[_infoView addSubview:T_TText];
        [T_TText release];
		UILabel *D_DText = [[UILabel alloc] init];
		[D_DText setTextAlignment:UITextAlignmentRight];
		[D_DText setFrame:CGRectMake(129, 248 + ((t-1)*25), 180, 15)];
        [D_DText setText:[recvText objectAtIndex:t - 1]];
        D_DText.textColor = RGB(44, 44, 44);//[UIColor blackColor];
        D_DText.backgroundColor = [UIColor clearColor];
        D_DText.font = [UIFont systemFontOfSize:15.0f];
		D_DText.tag = t;
		[_infoView addSubview:D_DText];
        [D_DText release];
    }
    
    // 예상평가금액
    [basicLabel10 setFrame:CGRectMake(8, 248 + (([recvTitle count])*25), 100, 15)];
    basicLabel10.textColor = RGB(209, 75, 75);
    basicLabel10.backgroundColor = [UIColor clearColor];
    [basicLabel11 setFrame:CGRectMake(129, 248 + (([recvTitle count])*25), 180, 15)];
    basicLabel11.text = [NSString stringWithFormat:@"%@",[data_D6320 objectForKey:@"총수령액"]];
    basicLabel11.textColor = RGB(209, 75, 75);
    basicLabel11.backgroundColor = [UIColor clearColor];

    // 공제내역 타이틀
    [_lineView2 setFrame:CGRectMake(0, basicLabel11.frame.origin.y + 25, 317, 25)];
    
    // 공제내역
    for( int t = 1; t <= [deductTitle count]; t++) {
		UILabel *T_TText = [[UILabel alloc] init];
		[T_TText setFrame:CGRectMake(8, _lineView2.frame.origin.y + 35 + ((t-1)*25) ,100,15)];
        [T_TText setText:[deductTitle objectAtIndex:t - 1]];
        T_TText.textColor = RGB(74, 74, 74);//[UIColor blackColor];
        T_TText.backgroundColor = [UIColor clearColor];
        T_TText.font = [UIFont systemFontOfSize:14.0f];
		T_TText.tag = t;
		[_infoView addSubview:T_TText];
        [T_TText release];
		UILabel *D_DText = [[UILabel alloc] init];
		[D_DText setTextAlignment:UITextAlignmentRight];
		[D_DText setFrame:CGRectMake(129, _lineView2.frame.origin.y + 35 + ((t-1)*25) ,180,15)];
        [D_DText setText:[deductText objectAtIndex:t - 1]];
        D_DText.textColor = RGB(44, 44, 44);//[UIColor blackColor];
        D_DText.backgroundColor = [UIColor clearColor];
        D_DText.font = [UIFont systemFontOfSize:14.0f];
		D_DText.tag = t;
		[_infoView addSubview:D_DText];
        [D_DText release];
    }
    
    // 공제금액합계금액
    [basicLabel13 setFrame:CGRectMake(8, _lineView2.frame.origin.y + 35 + (([deductTitle count])*25), 140, 15)];
    [basicLabel14 setFrame:CGRectMake(129, _lineView2.frame.origin.y + 35 + (([deductTitle count])*25), 180, 15)];
    basicLabel14.text = [NSString stringWithFormat:@"%@",[data_D6320 objectForKey:@"총공제액"]];
    
    // 수령예상금액
    [basicLabel15 setFrame:CGRectMake(8, basicLabel13.frame.origin.y + 25, 100, 15)];
    [basicLabel16 setFrame:CGRectMake(129, basicLabel13.frame.origin.y + 25, 180, 15)];
    basicLabel16.text = [NSString stringWithFormat:@"%@",[data_D6320 objectForKey:@"실수령액"]];
    
    [basicLabel17 setFrame:CGRectMake(8, basicLabel15.frame.origin.y + 25, 200, 15)];
    
    [_lineView3 setFrame:CGRectMake(0, basicLabel17.frame.origin.y + 25, 317, 1)];
    
//    basicLabel15.text = [NSString stringWithFormat:@"%@원",[data_D6320 objectForKey:@"공제금액합계금액"]];
//    basicLabel16.text = [NSString stringWithFormat:@"%@원",[data_D6320 objectForKey:@"수령예상금액"]];
//    basicLabel17.text = [data_D6210 objectForKey:@""];
//    basicLabel15.text = [data_D6210 objectForKey:@""];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [accountNo release], accountNo = nil;
    dicDataDictionary = nil;
    
    secretOTPViewController = nil;
    secretCardViewController = nil;
    
    _encriptedPassword = nil;
    _encriptedNumber1 = nil;
    _encriptedNumber2 = nil;
    
    [_mainScrollView release];
    [_mainView release];
    [_securityView release];
    [_infoView release];
    [_lineView1 release];
    [_lineView2 release];
    [_lineView3 release];
    
    [basicLabel01 release], basicLabel01 = nil;
    [basicLabel02 release], basicLabel02 = nil;
    [basicLabel03 release], basicLabel03 = nil;
    [basicLabel04 release], basicLabel04 = nil;
    [basicLabel05 release], basicLabel05 = nil;
    [basicLabel06 release], basicLabel06 = nil;
    [basicLabel07 release], basicLabel07 = nil;
    [basicLabel08 release], basicLabel08 = nil;
    [basicLabel09 release], basicLabel09 = nil;
    [basicLabel10 release], basicLabel10 = nil;
    [basicLabel11 release], basicLabel11 = nil;
    [basicLabel12 release], basicLabel12 = nil;
    [basicLabel13 release], basicLabel13 = nil;
    [basicLabel14 release], basicLabel14 = nil;
    [basicLabel15 release], basicLabel15 = nil;
    [basicLabel16 release], basicLabel16 = nil;
    [basicLabel17 release], basicLabel17 = nil;
    //    [data_D6010 release];
    [data_D6310 release];
    [data_D6320 release];
    
    [_fundTickerName release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    // 노티 해제
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notiESignError" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignResult:) name:@"eSignFinalData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getElectronicSignCancel) name:@"eSignCancel" object:nil];
    
    // 전자서명 에러
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getElectronicSignCancel)
                                                 name:@"notiESignError"
                                               object:nil];

    [super viewDidLoad];
    
    self.title = @"펀드출금";
    self.strBackButtonTitle = @"펀드출금 3단계";
    
    [self displayDrawingConfirmData];

    [_infoView setFrame:CGRectMake(0, 0, 317.0f, _lineView3.frame.origin.y + 1)];

    NSString *secutryType = [AppInfo.userInfo objectForKey:@"보안매체정보"];
    
    if ([secutryType intValue] == 1 || [secutryType intValue] == 2 ||
        [secutryType intValue] == 3 || [secutryType intValue] == 4) {
        secretCardViewController = [[[SHBSecretCardViewController alloc] init] autorelease];
        secretCardViewController.targetViewController = self;
        
        [secretCardViewController setDelegate:self];
        secretCardViewController.nextSVC = @"D6340";
        
        [_securityView setFrame:CGRectMake(0,
                                           _infoView.frame.size.height,
                                           _securityView.frame.size.width,
                                           secretCardViewController.view.bounds.size.height + 70)];
        
        [_securityView addSubview:secretCardViewController.view];
        
        secretCardViewController.selfPosY = _infoView.frame.size.height + 30;
        [secretCardViewController.view setFrame:CGRectMake(0,
                                                           1,
                                                           secretCardViewController.view.bounds.size.width,
                                                           secretCardViewController.view.bounds.size.height)];
        [secretCardViewController setMediaCode:[secutryType intValue] previousData:nil];
    }
    else if ([secutryType intValue] == 5) { // OTP
        secretOTPViewController = [[[SHBSecretOTPViewController alloc] init] autorelease];
        secretOTPViewController.targetViewController = self;
        [secretOTPViewController setDelegate:self];
        secretOTPViewController.nextSVC = @"D6340";
        
        [_securityView setFrame:CGRectMake(0,
                                           _infoView.frame.size.height,
                                           _securityView.frame.size.width,
                                           secretCardViewController.view.bounds.size.height + 70)];
        
        [_securityView addSubview:secretOTPViewController.view];
        
        secretOTPViewController.selfPosY = _infoView.frame.size.height + 30;
        [secretOTPViewController.view setFrame:CGRectMake(0,
                                                          1,
                                                          secretOTPViewController.view.bounds.size.width,
                                                          secretOTPViewController.view.bounds.size.height)];
    }
    
    [_securityView setFrame:CGRectMake(0, _infoView.frame.size.height+2, 317.0f, 250.0f)];

    [_mainView setFrame:CGRectMake(0,
                                   0,
                                   _mainView.frame.size.width,
                                   _infoView.frame.size.height + _securityView.frame.size.height)];
    
    [_mainScrollView setContentSize:_mainView.frame.size];
    [self.contentScrollView setContentSize:_mainView.frame.size];
    contentViewHeight = _mainView.frame.size.height;

    // scroll Labe
    [_fundTickerName initFrame:_fundTickerName.frame colorType:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1] fontSize:15 textAlign:2];
    [_fundTickerName setCaptionText:[data_D6310 objectForKey:@"펀드명"]];

    // release 처리
    self.dicDataDictionary = [[[NSMutableDictionary alloc] initWithCapacity:8] autorelease];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification Center

- (void)getElectronicSignResult:(NSNotification *)notification
{
    NSLog(@"controlles2:%@",[self.navigationController viewControllers]);

    dicDataDictionary = [NSMutableDictionary dictionaryWithDictionary:notification.userInfo];
    [dicDataDictionary setObject:[data_D6310 objectForKey:@"펀드명"] forKey:@"펀드명"];

//    [dicDataDictionary setObject:[data_D6320 objectForKey:@"계좌번호"] forKey:@"계좌번호"];
    // 구계좌시 문제로 수정
    [dicDataDictionary setObject:basicLabel01.text forKey:@"계좌번호"];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignFinalData" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eSignCancel" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // 예약번호 있는 것
    if ([notification.userInfo[@"예약번호"] isEqualToString:@""]) {
        SHBFundTransCompleteYViewController *viewController = [[[SHBFundTransCompleteYViewController alloc] initWithNibName:@"SHBFundTransCompleteYViewController" bundle:nil] autorelease];
        
        viewController.dicDataDictionary = dicDataDictionary;
        
        [self.navigationController pushFadeViewController:viewController];
        // 예약번호 없는 것
    } else {
        SHBFundTransCompleteNViewController *viewController = [[[SHBFundTransCompleteNViewController alloc] initWithNibName:@"SHBFundTransCompleteNViewController" bundle:nil] autorelease];
        
        viewController.dicDataDictionary = dicDataDictionary;
        
        [self.navigationController pushFadeViewController:viewController];
    }
    
}

- (void)getElectronicSignCancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelButtonReceived" object:nil];
    
    [self.navigationController fadePopViewController];
    [self.navigationController fadePopViewController];
}

#pragma mark - TextField
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value
{
    [super textField:textField didEncriptedData:aData didEncriptedVaule:value];
    
    [self.contentScrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - SHBSecretMedia
- (void) confirmSecretMedia:(OFDataSet*)confirmData result:(BOOL)confirm media:(int)mediaType
{
    
    if (confirm) {
        NSString *tempStr1;
        NSString *tempStr2;
        NSString *tempStr3 = @"";
        NSString *tempStr4 = @"";
        NSString *tempStr5 = @"1";
        
        if([[data_D6310 objectForKey:@"구계좌사용여부"] isEqualToString:@"1"])
        {
            tempStr1 = [[data_D6310 objectForKey:@"구계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            tempStr2 = [data_D6310 objectForKey:@"은행구분"];
        }
        else
        {
            tempStr1 = [[data_D6310 objectForKey:@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            tempStr2 = @"1";
        }
        
        AppInfo.electronicSignString = @"";
        
        // code & 타이틀
        AppInfo.eSignNVBarTitle = @"펀드출금";
        if ([[data_D6320 objectForKey:@"표시구분"] isEqualToString:@"전액출금"] || [[data_D6320 objectForKey:@"표시구분"] isEqualToString:@"금액출금"]) {
            AppInfo.electronicSignCode = @"D6340_A";
        } else {
            AppInfo.electronicSignCode = @"D6340_B";
        }
        AppInfo.electronicSignTitle = @"펀드출금 신청";
        
//        [AppInfo addElectronicSign:@"펀드출금 신청"];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(1)신청일자: %@", [data_D6320 objectForKey:@"COM_TRAN_DATE"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(2)거래시간: %@", [data_D6320 objectForKey:@"COM_TRAN_TIME"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(3)펀드명: %@", [data_D6310 objectForKey:@"펀드명"]]];
        [AppInfo addElectronicSign:[NSString stringWithFormat:@"(4)펀드계좌번호: %@",
                                    basicLabel01.text]];
        
        if ([[data_D6320 objectForKey:@"표시구분"] isEqualToString:@"전액출금"]) {
//            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)신청금액: %@", [data_D6320 objectForKey:@"납부금액"]]];
            [AppInfo addElectronicSign:@"(5)신청금액: 전액출금"];
            tempStr3 = @"";
            tempStr5 = @"2";
        } else if ([[data_D6320 objectForKey:@"표시구분"] isEqualToString:@"금액출금"]) {
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)신청금액: %@원", [data_D6320 objectForKey:@"실수령액"]]];
            tempStr3 = [data_D6320 objectForKey:@"실수령액"];
            tempStr5 = @"1";
        } else {
            [AppInfo addElectronicSign:[NSString stringWithFormat:@"(5)신청좌수: %@좌", [data_D6320 objectForKey:@"지급내용2"]]];
            tempStr4 = [data_D6320 objectForKey:@"지급내용2"];
            tempStr5 = @"1";
        }
        
        // D6340 전자서명 완료후 실행할 전문
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"계좌번호" : tempStr1,
                                @"은행구분" : tempStr2,
                                @"계좌번호" : @"",
                                @"은행구분" : @"",
                                @"고객번호" : AppInfo.customerNo,
                                @"업무구분" : tempStr5,
                                @"조회여부" : @"N",
                                @"지급금액" : tempStr3,
                                @"지급좌수" : tempStr4,
                                @"출금계좌비밀번호" : [data_D6320 objectForKey:@"출금계좌비밀번호"],
                                @"전액대체여부" : @"Y",
                                @"LT거래여부"  : [data_D6310 objectForKey:@"엘티거래"],
                                @"LT승인번호"  : @"0",
                                }] autorelease];
        self.service = [[[SHBFundService alloc] initWithServiceId:FUND_DRAWING_D6340
                                                   viewController:self] autorelease];
        self.service.previousData = aDataSet;
        [self.service start];
        
    } else {
        // 비밀번호가 틀림?
    }
    
}

- (void) cancelSecretMedia
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelButtonReceived" object:nil];
    [self.navigationController fadePopViewController];
}
@end
