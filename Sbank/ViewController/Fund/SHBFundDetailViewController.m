//
//  SHBFundDetailViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFundDetailViewController.h"

@interface SHBFundDetailViewController ()

@end

@implementation SHBFundDetailViewController

@synthesize basicInfo;
@synthesize fundInfo;
@synthesize fundNameLabel;

@synthesize scrollView;

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
@synthesize basicLabel18;
@synthesize basicLabel19;

// 기본데이터
- (void)displayBasicData
{
    basicLabel01.text = [basicInfo objectForKey:@"계좌명"];
    // 신구 계좌에 따른 차이로 값 셋팅하여 들어온다
    basicLabel02.text = [basicInfo objectForKey:@"계좌번호표시"];
    basicLabel03.text = [basicInfo objectForKey:@"고객명"];
    basicLabel04.text = [basicInfo objectForKey:@"저축종류"];
    basicLabel05.text = [basicInfo objectForKey:@"신규일자"];
    if ([[basicInfo objectForKey:@"통화종류"] isEqualToString:@"KRW"]) {
        basicLabel06.text = [NSString stringWithFormat:@"원(%@)", [basicInfo objectForKey:@"통화종류"]];
    } else {
        basicLabel06.text = [basicInfo objectForKey:@"통화종류"];
    }
    basicLabel07.text = [basicInfo objectForKey:@"연결계좌번호"];
    basicLabel08.text = [fundInfo objectForKey:@"거래종류"];
    basicLabel09.text = [fundInfo objectForKey:@"거래일자"];
    basicLabel10.text = [fundInfo objectForKey:@"거래번호"];
    if ([[fundInfo objectForKey:@"연동상대계좌번호"] isEqualToString:@""]) {
        basicLabel19.text = @"미등록";
    } else {
        basicLabel19.text = [fundInfo objectForKey:@"연동상대계좌번호"];
    }
    basicLabel11.text = [fundInfo objectForKey:@"취소여부"];
    if ([[basicInfo objectForKey:@"통화종류"] isEqualToString:@"KRW"]) {
        basicLabel12.text = [[fundInfo objectForKey:@"거래금액"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"거래금액"] rangeOfString:@"."].location)];
//        basicLabel13.text = [[fundInfo objectForKey:@"선취수수료"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"선취수수료"] rangeOfString:@"."].location)];
//        basicLabel15.text = [[fundInfo objectForKey:@"거래기준가"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"거래기준가"] rangeOfString:@"."].location)];
//        basicLabel16.text = [[fundInfo objectForKey:@"과표기준가"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"과표기준가"] rangeOfString:@"."].location)];
        basicLabel18.text = [[fundInfo objectForKey:@"거래후평가금액"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"거래후평가금액"] rangeOfString:@"."].location)];
    } else {
        basicLabel12.text = [fundInfo objectForKey:@"거래금액"];
        basicLabel18.text = [fundInfo objectForKey:@"거래후평가금액"];
    }
    
    [basicLabel13 setText:[NSString stringWithFormat:@"%@",[SHBUtility normalStringTocommaString:[fundInfo objectForKey:@"선취수수료"]]]];
	
    [basicLabel15 setText:[NSString stringWithFormat:@"%@",[SHBUtility normalStringTocommaString:[fundInfo objectForKey:@"거래기준가"]]]];
    
    [basicLabel16 setText:[NSString stringWithFormat:@"%@",[SHBUtility normalStringTocommaString:[fundInfo objectForKey:@"과표기준가"]]]];
    

    basicLabel14.text = [[fundInfo objectForKey:@"거래좌수"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"거래좌수"] rangeOfString:@"."].location)];
    basicLabel17.text = [[fundInfo objectForKey:@"잔고좌수"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"잔고좌수"] rangeOfString:@"."].location)];
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [self.navigationController fadePopViewController];
}

- (void)dealloc
{
    [scrollView release];
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
    [basicLabel11 release], basicLabel11 = nil;
    [basicLabel12 release], basicLabel12 = nil;
    [basicLabel13 release], basicLabel13 = nil;
    [basicLabel14 release], basicLabel14 = nil;
    [basicLabel15 release], basicLabel15 = nil;
    [basicLabel16 release], basicLabel16 = nil;
    [basicLabel17 release], basicLabel17 = nil;
    [basicLabel18 release], basicLabel18 = nil;
    [basicLabel19 release], basicLabel19 = nil;
    
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
    
    self.title = @"펀드조회";
    [self displayBasicData];

    // scroll Labe
    [_fundTickerName initFrame:_fundTickerName.frame colorType:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1] fontSize:15 textAlign:2];
    [_fundTickerName setCaptionText:[basicInfo objectForKey:@"계좌명"]];

    [self.scrollView setContentSize:_infoView.frame.size];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self displayBasicData];
}

@end
