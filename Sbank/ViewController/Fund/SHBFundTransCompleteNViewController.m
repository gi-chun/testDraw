//
//  SHBFundTransCompleteNViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFundTransCompleteNViewController.h"

@interface SHBFundTransCompleteNViewController ()

@end

@implementation SHBFundTransCompleteNViewController

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
@synthesize basicLabel13;
@synthesize basicLabel14;
@synthesize basicLabel15;
@synthesize basicLabel16;
@synthesize commentLabel1;
@synthesize commentLabel2;
@synthesize commentLabel3;

- (void)displayCompleteData
{
    basicLabel02.text = [dicDataDictionary objectForKey:@"계좌번호"];    
    basicLabel03.text = [dicDataDictionary objectForKey:@"연결계좌번호"];
    basicLabel04.text = [dicDataDictionary objectForKey:@"신청구분"];
    basicLabel05.text = [dicDataDictionary objectForKey:@"예상평가금액"];
    basicLabel06.text = [dicDataDictionary objectForKey:@"전환신청좌수"];
    basicLabel07.text = [dicDataDictionary objectForKey:@"예상수수료"];
    basicLabel08.text = [dicDataDictionary objectForKey:@"예상세금금액"];
    
    commentLabel1.text = [NSString stringWithFormat:@"%@ %@ %@", [dicDataDictionary objectForKey:@"T_설명1"], [dicDataDictionary objectForKey:@"T_설명2"], [dicDataDictionary objectForKey:@"T_설명3"]];
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]);
    if([strController isEqualToString:@"SHBFundAccountListViewController"])
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
//    [accountNo release], accountNo = nil;
    self.dicDataDictionary = nil;
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
    [commentLabel1 release], commentLabel1 = nil;
    [commentLabel2 release], commentLabel2 = nil;
    [commentLabel3 release], commentLabel3 = nil;
    
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
    [self navigationBackButtonHidden];

    // scroll Labe
    [_fundTickerName initFrame:_fundTickerName.frame colorType:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1] fontSize:15 textAlign:2];
    [_fundTickerName setCaptionText:[dicDataDictionary objectForKey:@"펀드명"]];

    // 완료데이터를 표시
    [self displayCompleteData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
