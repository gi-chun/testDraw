//
//  SHBFundTransDetailViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBFundTransDetailViewController.h"
#import "SHBFundTransInfoInputViewController.h" //펀드출금 2단계 - 출금정보입력
#import "SHBFundService.h"

@interface SHBFundTransDetailViewController ()

@end

@implementation SHBFundTransDetailViewController

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
@synthesize basicLabel12;
@synthesize data_D6310;

- (void)displayDepositDetailData
{
    NSString *strAccount = [data_D6310 objectForKey:@"계좌번호"];
    // 구계좌의 경우
    if ([[data_D6310 objectForKey:@"신계좌변환여부"] isEqualToString:@"0"] || [[data_D6310 objectForKey:@"구계좌사용여부"] isEqualToString:@"1"])
    {
        strAccount = [data_D6310 objectForKey:@"구계좌번호"];
    }
    
    basicLabel01.text = [data_D6310 objectForKey:@"펀드명"];
    basicLabel02.text = strAccount;
    basicLabel03.text = [data_D6310 objectForKey:@"저축종류"];
    basicLabel04.text = [data_D6310 objectForKey:@"신규일자"];
    basicLabel05.text = [data_D6310 objectForKey:@"만기일자"];
    if ([[data_D6310 objectForKey:@"통화종류"] isEqualToString:@"KRW"]) {
        basicLabel06.text = [NSString stringWithFormat:@"원(%@)", [data_D6310 objectForKey:@"통화종류"]];
    } else {
        basicLabel06.text = [data_D6310 objectForKey:@"통화종류"];
    }
    basicLabel07.text = [NSString stringWithFormat:@"%@",[data_D6310 objectForKey:@"납입원금잔액"]];
    basicLabel08.text = [NSString stringWithFormat:@"%@",[data_D6310 objectForKey:@"평가금액"]];
    basicLabel09.text = [NSString stringWithFormat:@"%@%%",[data_D6310 objectForKey:@"납입원금수익률"]];
    basicLabel10.text = [data_D6310 objectForKey:@"잔고좌수"];
    basicLabel11.text = [data_D6310 objectForKey:@"출금방식"];
    
    if ([[data_D6310 objectForKey:@"연결계좌번호"] isEqualToString:@""]) {
        basicLabel12.text = @"미등록";
    } else {
        basicLabel12.text = [data_D6310 objectForKey:@"연결계좌번호"];
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
    [basicLabel12 release], basicLabel12 = nil;
    [data_D6310 release];
    [_infoView release];
    
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
    // Do any additional setup after loading the view from its nib.

    self.title = @"펀드출금";
    self.strBackButtonTitle = @"펀드출금 1단계";

    // scroll Labe
    [_fundTickerName initFrame:_fundTickerName.frame colorType:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1] fontSize:15 textAlign:2];
    [_fundTickerName setCaptionText:[data_D6310 objectForKey:@"펀드명"]];

    // D6310 전문 내용을 표시
    [self displayDepositDetailData];

    [self.contentScrollView setContentSize:_infoView.frame.size];
    contentViewHeight = _infoView.frame.size.height;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 펀드출금 2단계 
- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    SHBFundTransInfoInputViewController *detailViewController = [[SHBFundTransInfoInputViewController alloc] initWithNibName:@"SHBFundTransInfoInputViewController" bundle:nil];
    
    // 데이터 전달
    detailViewController.data_D6310 = data_D6310;
    
    [self.navigationController pushFadeViewController:detailViewController];
    [detailViewController release];
    
}

@end
