//
//  SHBFundDepositApplyCompleteViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 2..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFundDepositApplyCompleteViewController.h"
#import "SHBScrollingTicker.h"

@interface SHBFundDepositApplyCompleteViewController ()
{
    SHBScrollingTicker *scrollingTicker;
}

@end

@implementation SHBFundDepositApplyCompleteViewController

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

- (void)displayCompleteData
{
//    basicLabel01.text = [dicDataDictionary objectForKey:@"펀드명"];
    // 신구 계좌에 따른 차이로 값 셋팅하여 들어온다
    basicLabel02.text = [dicDataDictionary objectForKey:@"계좌번호표시"];
    basicLabel03.text = [dicDataDictionary objectForKey:@"거래일자"];
    basicLabel04.text = [dicDataDictionary objectForKey:@"거래번호"];
    basicLabel05.text = [dicDataDictionary objectForKey:@"거래종류"];
    basicLabel06.text = [dicDataDictionary objectForKey:@"입금신청금액"];
    basicLabel07.text = [dicDataDictionary objectForKey:@"입금신청일자"];
    basicLabel08.text = [dicDataDictionary objectForKey:@"입금취소일자"];
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
//    [self.navigationController fadePopToRootViewController];
//    NSLog(@"index 0 : %@", NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:0] class]));
//    NSLog(@"index 1 : %@", NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]));
//    NSLog(@"index 2 : %@", NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:2] class]));
    NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:2] class]);
    if([strController isEqualToString:@"SHBFundTransListViewController"] ||[strController isEqualToString:@"SHBAccountMenuListViewController"] )
    {
        [[self.navigationController.viewControllers objectAtIndex:1] performSelector:@selector(refresh)];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }
    else
    {
        [self.navigationController fadePopToRootViewController];
    }
}

- (void)dealloc
{
    [_infoView release];
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
    
    self.dicDataDictionary = nil;
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

    self.title = @"펀드조회";
    [self navigationBackButtonHidden];

    // Scroll Label
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
