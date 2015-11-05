//
//  SHBFundDepositDetailViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBFundDepositDetailViewController.h"
#import "SHBFundDepositInfoInputViewController.h"
#import "SHBFundService.h"
//#import "SHBScrollingTicker.h"

@interface SHBFundDepositDetailViewController ()
{
    int serviceType;
//    SHBScrollingTicker *scrollingTicker;
}

@end

@implementation SHBFundDepositDetailViewController

@synthesize account;
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
@synthesize data_D6210;
@synthesize data_D6010;

- (void)displayDepositDetailData
{
    NSString *strAccount = [data_D6210 objectForKey:@"계좌번호"];
    // 구계좌의 경우
    if ([[data_D6210 objectForKey:@"신계좌변환여부"] isEqualToString:@"0"] || [[data_D6210 objectForKey:@"구계좌사용여부"] isEqualToString:@"1"] )
    {
        strAccount = [data_D6210 objectForKey:@"구계좌번호"];
    }
    
    basicLabel01.text = [data_D6210 objectForKey:@"펀드명"];
    basicLabel02.text = strAccount;
    basicLabel03.text = [data_D6210 objectForKey:@"저축종류"];
    basicLabel04.text = [data_D6210 objectForKey:@"신규일자"];
    basicLabel05.text = [data_D6210 objectForKey:@"만기일자"];
    if ([[data_D6210 objectForKey:@"통화종류"] isEqualToString:@"KRW"]) {
        basicLabel06.text = [NSString stringWithFormat:@"원(%@)", [data_D6210 objectForKey:@"통화종류"]];
    } else {
        basicLabel06.text = [data_D6210 objectForKey:@"통화종류"];
    }
    basicLabel07.text = [NSString stringWithFormat:@"%@원",[data_D6210 objectForKey:@"납입원금잔액"]];
    basicLabel08.text = [NSString stringWithFormat:@"%@원",[data_D6210 objectForKey:@"평가금액"]];
    basicLabel09.text = [NSString stringWithFormat:@"%@%%",[data_D6210 objectForKey:@"납입원금수익률"]];
    basicLabel10.text = [data_D6210 objectForKey:@"잔고좌수"];
    basicLabel11.text = [data_D6210 objectForKey:@"입금방식"];
    
    if ([[data_D6210 objectForKey:@"엘티거래"] isEqualToString:@"1"])
    {
        _lTView.hidden = NO;
        [buttonUpNext setHidden:YES];
        [buttonBottomNext setHidden:NO];
    }
    else
    {
        _lTView.hidden = YES;
        [buttonUpNext setHidden:NO];
        [buttonBottomNext setHidden:YES];
    }
}

- (void)dealloc
{
    [account release], account = nil;
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
    [data_D6210 release];
    [data_D6010 release];
    [_infoView release];
    [_lTView release];
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
    [super viewDidLoad];
    
    self.title = @"펀드입금";
    self.strBackButtonTitle = @"펀드입금 1단계";
    
    // scroll Labe
    [_fundTickerName initFrame:_fundTickerName.frame colorType:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1] fontSize:15 textAlign:2];
    [_fundTickerName setCaptionText:[data_D6210 objectForKey:@"펀드명"]];

    // 데이터표시
    [self displayDepositDetailData];

    [self.scrollView setContentSize:_infoView.frame.size];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 펀드입금 2단계
- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    // D6100
    serviceType = 0;
    
    SHBDataSet *dicDataDic = [[[SHBDataSet alloc] initWithDictionary:
                              @{
                              @"조회일자"  : [[data_D6210 objectForKey:@"COM_TRAN_DATE"] stringByReplacingOccurrencesOfString:@"." withString:@""],
                              @"상품코드"  : [data_D6210 objectForKey:@"상품코드"]
                              }] autorelease];
    
    self.service = [[[SHBFundService alloc] initWithServiceId: FUND_DEPOSIT_CONFIRM  viewController: self] autorelease];
    self.service.previousData = dicDataDic;
    [self.service start];
}

#pragma mark -
#pragma mark onParse & onBind

- (BOOL)onParse:(OFDataSet *)aDataSet string:(NSData *)aContent
{
    switch (serviceType) {
        case 0:
        {
            // 정보 setting
            SHBFundDepositInfoInputViewController *detailViewController = [[SHBFundDepositInfoInputViewController alloc] initWithNibName:@"SHBFundDepositInfoInputViewController" bundle:nil];
            
//            detailViewController.data_D6010 = data_D6010;
            detailViewController.data_D6210 = data_D6210;
            detailViewController.data_D6100 = self.service.responseData;
            
            [self.navigationController pushFadeViewController:detailViewController];
            [detailViewController release];

        }
            break;
            
        case 1:
        {
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}

@end
