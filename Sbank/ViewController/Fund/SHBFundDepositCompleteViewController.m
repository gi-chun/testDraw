//
//  SHBFundDepositCompleteViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBFundDepositCompleteViewController.h"
#import "SHBScrollingTicker.H"

@interface SHBFundDepositCompleteViewController ()
{
    SHBScrollingTicker *scrollingTicker;
}
@end

@implementation SHBFundDepositCompleteViewController

@synthesize accountNo;
@synthesize depositAccountNo;
@synthesize transMoney;
@synthesize dicDataDictionary;
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

- (void)displayCompleteData
{
    basicLabel02.text = [dicDataDictionary objectForKey:@"계좌번호"];
    basicLabel03.text = [dicDataDictionary objectForKey:@"출금계좌번호"];
    basicLabel04.text = [dicDataDictionary objectForKey:@"신청일자"];
	if([[dicDataDictionary objectForKey:@"입금방식"] isEqualToString:@"1"])
	{
		basicLabel05.text = @"익일이후입금"; 
	}
	else if ([[dicDataDictionary objectForKey:@"입금방식"] isEqualToString:@"2"])
	{
		basicLabel05.text = @"당일입금";
	}
    basicLabel06.text = [dicDataDictionary objectForKey:@"처리예정일자"];
    basicLabel07.text = [dicDataDictionary objectForKey:@"매입기준가일"];
    basicLabel08.text = [dicDataDictionary objectForKey:@"예약금액"];
    basicLabel09.text = [dicDataDictionary objectForKey:@"거래좌수"];
    basicLabel10.text = [dicDataDictionary objectForKey:@"거래기준가"];
    basicLabel11.text = [dicDataDictionary objectForKey:@"잔고좌수"];
    basicLabel12.text = [dicDataDictionary objectForKey:@"평가금액"];
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
//    [self.navigationController fadePopToRootViewController];
//    NSLog(@"index 0 : %@", NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:0] class]));
//    NSLog(@"index 1 : %@", NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]));
//    NSLog(@"index 2 : %@", NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:2] class]));
    NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]);
    if([strController isEqualToString:@"SHBAccountMenuListViewController"]
       ||[strController isEqualToString:@"SHBFundAccountListViewController"])
    {
        [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(refresh)];
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
    }
    else
    {
        [self.navigationController fadePopToRootViewController];
    }
}

- (void)dealloc
{
    [accountNo release], accountNo = nil;
    [depositAccountNo release], depositAccountNo = nil;
    [transMoney release], transMoney = nil;
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

    [_infoView release];
    self.dicDataDictionary = nil;
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
    [self navigationBackButtonHidden];

    // scroll Labe
    [_fundTickerName initFrame:_fundTickerName.frame colorType:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1] fontSize:15 textAlign:2];
    [_fundTickerName setCaptionText:[dicDataDictionary objectForKey:@"펀드명"]];

    // 완료 데이터 화면 표시
    [self displayCompleteData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
