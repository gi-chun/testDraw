//
//  SHBDrawingDetailViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBDrawingDetailViewController.h"
#import "SHBUtility.h"

@interface SHBDrawingDetailViewController ()

@end

@implementation SHBDrawingDetailViewController

@synthesize scrollView;
@synthesize fundInfo;
@synthesize basicInfo;

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
@synthesize basicLabel20;
@synthesize basicLabel21;
@synthesize basicLabel22;
@synthesize basicLabel23;
@synthesize basicLabel24;
@synthesize basicLabel25;
@synthesize basicLabel26;
@synthesize basicLabel27;
@synthesize basicLabel28;
@synthesize basicLabel29;
@synthesize basicLabel30;

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
    basicLabel11.text = [fundInfo objectForKey:@"취소여부"];
    basicLabel12.text = [fundInfo objectForKey:@"연동상대계좌번호"];
    if ([[basicInfo objectForKey:@"통화종류"] isEqualToString:@"KRW"]) {
        basicLabel13.text = [[fundInfo objectForKey:@"평가금액"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"평가금액"] rangeOfString:@"."].location)];
        basicLabel14.text = [[fundInfo objectForKey:@"지금기준구분"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"지금기준구분"] rangeOfString:@"."].location)];
        basicLabel15.text = [[fundInfo objectForKey:@"거래좌수"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"거래좌수"] rangeOfString:@"."].location)];
        basicLabel16.text = [[fundInfo objectForKey:@"거래금액"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"거래금액"] rangeOfString:@"."].location)];
        basicLabel17.text = [[fundInfo objectForKey:@"환매수수료"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"환매수수료"] rangeOfString:@"."].location)];
        basicLabel18.text = [[fundInfo objectForKey:@"과세표준금액"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"과세표준금액"] rangeOfString:@"."].location)];
        basicLabel19.text = [[fundInfo objectForKey:@"징수세금합계"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"징수세금합계"] rangeOfString:@"."].location)];
        
        NSString *tmp_1= [fundInfo objectForKey:@"소득세"];
        NSString *tmp_2 = [fundInfo objectForKey:@"법인세"];
        
        tmp_1 = [tmp_1 stringByReplacingOccurrencesOfString:@"," withString:@""];
        tmp_2 = [tmp_2 stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        int Corporate = [tmp_1 intValue];
        int Residence = [tmp_2 intValue];
        int sum = Corporate + Residence;
        
        NSString *str = [NSString stringWithFormat:@"%@", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d",sum]]];

        NSLog(@"%d", [str rangeOfString:@"."].location);
        basicLabel20.text = [str substringWithRange:NSMakeRange(0, [str rangeOfString:@"."].location ==  NSNotFound ?  [str length] : [str rangeOfString:@"."].location)];
        basicLabel21.text = [[fundInfo objectForKey:@"주민세"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"주민세"] rangeOfString:@"."].location)];
        basicLabel22.text = [[fundInfo objectForKey:@"농특세"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"농특세"] rangeOfString:@"."].location)];
        basicLabel23.text = [[fundInfo objectForKey:@"환출세금합계"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"환출세금합계"] rangeOfString:@"."].location)];

        tmp_1= [fundInfo objectForKey:@"환출소득세"];
        tmp_2 = [fundInfo objectForKey:@"환출법인세"];
        
        tmp_1 = [tmp_1 stringByReplacingOccurrencesOfString:@"," withString:@""];
        tmp_2 = [tmp_2 stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        Corporate = [tmp_1 intValue];
        Residence = [tmp_2 intValue];
        int sum2 = Corporate + Residence;
        
        NSString *str2 = [NSString stringWithFormat:@"%@", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d",sum2]]];

        NSLog(@"%d", [str2 rangeOfString:@"."].location);
        basicLabel24.text = [str2 substringWithRange:NSMakeRange(0, [str2 rangeOfString:@"."].location ==  NSNotFound ?  [str2 length] : [str2 rangeOfString:@"."].location)];
        basicLabel25.text = [[fundInfo objectForKey:@"환출주민세"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"환출주민세"] rangeOfString:@"."].location)];
        basicLabel26.text = [[fundInfo objectForKey:@"환출농특세"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"환출농특세"] rangeOfString:@"."].location)];
        basicLabel27.text = [[fundInfo objectForKey:@"거래기준가"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"평가거래기준가금액"] rangeOfString:@"."].location)];
        basicLabel28.text = [[fundInfo objectForKey:@"과표기준가"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"과표기준가"] rangeOfString:@"."].location)];
        basicLabel29.text = [[fundInfo objectForKey:@"거래금액"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"거래금액"] rangeOfString:@"."].location)];
        basicLabel30.text = [[fundInfo objectForKey:@"출금평가수익"] substringWithRange:NSMakeRange(0, [[fundInfo objectForKey:@"출금평가수익"] rangeOfString:@"."].location)];
    } else {
        basicLabel13.text = [fundInfo objectForKey:@"평가금액"];
        basicLabel14.text = [fundInfo objectForKey:@"지금기준구분"];
        basicLabel15.text = [fundInfo objectForKey:@"거래좌수"];
        basicLabel16.text = [fundInfo objectForKey:@"거래금액"];
        basicLabel17.text = [fundInfo objectForKey:@"환매수수료"];
        basicLabel18.text = [fundInfo objectForKey:@"과세표준금액"];
        basicLabel19.text = [fundInfo objectForKey:@"징수세금합계"];

        NSString *tmp_1= [fundInfo objectForKey:@"소득세"];
        NSString *tmp_2 = [fundInfo objectForKey:@"법인세"];
        
        tmp_1 = [tmp_1 stringByReplacingOccurrencesOfString:@"," withString:@""];
        tmp_2 = [tmp_2 stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        int Corporate = [tmp_1 intValue];
        int Residence = [tmp_2 intValue];
        int sum = Corporate + Residence;
        
        NSString *str = [NSString stringWithFormat:@"%@", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d",sum]]];
        
        basicLabel20.text = str; //[fundInfo objectForKey:@"법인세"];
        basicLabel21.text = [fundInfo objectForKey:@"주민세"];
        basicLabel22.text = [fundInfo objectForKey:@"농특세"];
        basicLabel23.text = [fundInfo objectForKey:@"환출세금합계"];

        tmp_1= [fundInfo objectForKey:@"환출소득세"];
        tmp_2 = [fundInfo objectForKey:@"환출법인세"];
        
        tmp_1 = [tmp_1 stringByReplacingOccurrencesOfString:@"," withString:@""];
        tmp_2 = [tmp_2 stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        Corporate = [tmp_1 intValue];
        Residence = [tmp_2 intValue];
        int sum2 = Corporate + Residence;
        
        NSString *str2 = [NSString stringWithFormat:@"%@", [SHBUtility normalStringTocommaString:[NSString stringWithFormat:@"%d",sum2]]];

        basicLabel24.text = str2; //[fundInfo objectForKey:@"환출소득세"];
        basicLabel25.text = [fundInfo objectForKey:@"환출주민세"];
        basicLabel26.text = [fundInfo objectForKey:@"환출농특세"];
        basicLabel27.text = [fundInfo objectForKey:@"거래기준가"];
        basicLabel28.text = [fundInfo objectForKey:@"과표기준가"];
        basicLabel29.text = [fundInfo objectForKey:@"거래금액"];
        basicLabel30.text = [fundInfo objectForKey:@"출금평가수익"];
    }
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
    [basicLabel20 release], basicLabel20 = nil;
    [basicLabel21 release], basicLabel21 = nil;
    [basicLabel22 release], basicLabel22 = nil;
    [basicLabel23 release], basicLabel23 = nil;
    [basicLabel24 release], basicLabel24 = nil;
    [basicLabel25 release], basicLabel25 = nil;
    [basicLabel26 release], basicLabel26 = nil;
    [basicLabel27 release], basicLabel27 = nil;
    [basicLabel28 release], basicLabel28 = nil;
    [basicLabel29 release], basicLabel29 = nil;
    [basicLabel30 release], basicLabel30 = nil;
    
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
}

@end
