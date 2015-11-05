//
//  SHBFundTransCompleteYViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFundTransCompleteYViewController.h"

@interface SHBFundTransCompleteYViewController ()

@end

@implementation SHBFundTransCompleteYViewController

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
    basicLabel03.text = [dicDataDictionary objectForKey:@"내용3"];
    
    NSMutableArray *dataTitle = [[NSMutableArray alloc] init];
	NSMutableArray *dataText = [[NSMutableArray alloc] init];
	NSMutableArray *recvTitle = [[NSMutableArray alloc] init];
	NSMutableArray *recvText = [[NSMutableArray alloc] init];
	NSMutableArray *deductTitle = [[NSMutableArray alloc] init];
	NSMutableArray *deductText = [[NSMutableArray alloc] init];
	
	NSString *dtitle = [dicDataDictionary objectForKey:@"항목내용4"];
	NSString *dtext = [dicDataDictionary objectForKey:@"내용4"];
	
	if ([dtitle length] > 0 && [dtext length] > 0)
	{
		[dataTitle addObject:dtitle];
		[dataText addObject:dtext];
	}
	
	dtitle = [dicDataDictionary objectForKey:@"항목내용7"];
	dtext = [dicDataDictionary objectForKey:@"내용7"];
	
	if ([dtitle length] > 0 && [dtext length] > 0)
	{
		[dataTitle addObject:dtitle];
		[dataText addObject:dtext];
	}
	
	dtitle = [dicDataDictionary objectForKey:@"항목내용5"];
	dtext = [dicDataDictionary objectForKey:@"내용5"];
	
	if ([dtitle length] > 0 && [dtext length] > 0)
	{
		[dataTitle addObject:dtitle];
		[dataText addObject:dtext];
	}
	
	dtitle = [dicDataDictionary objectForKey:@"항목내용6"];
	dtext = [dicDataDictionary objectForKey:@"내용6"];
	
	if ([dtitle length] > 0 && [dtext length] > 0)
	{
		[dataTitle addObject:dtitle];
		[dataText addObject:dtext];
	}
	
	dtitle = [dicDataDictionary objectForKey:@"항목내용8"];
	dtext = [dicDataDictionary objectForKey:@"내용8"];
	
	if ([dtitle length] > 0 && [dtext length] > 0)
	{
		[dataTitle addObject:dtitle];
		[dataText addObject:dtext];
	}
	
	dtitle = [dicDataDictionary objectForKey:@"항목내용9"];
	dtext = [dicDataDictionary objectForKey:@"내용9"];
	if ([dtitle length] > 0 && [dtext length] > 0)
	{
		[dataTitle addObject:dtitle];
		[dataText addObject:dtext];
	}
	
	dtitle = [dicDataDictionary objectForKey:@"항목내용11"];
	dtext = [dicDataDictionary objectForKey:@"내용11"];
	if ([dtitle length] > 0 && [dtext length] > 0)
	{
		[dataTitle addObject:dtitle];
		[dataText addObject:dtext];
	}
	
	for (int i = 0; i < 9; i++)
	{
		NSString *title =[dicDataDictionary objectForKey:[NSString stringWithFormat:@"지급항목%d",i+1] ];
		NSString *text  =[dicDataDictionary objectForKey:[NSString stringWithFormat:@"지급내용%d",i+1] ];
		if ([title length] > 0 && [text length] > 0)
		{
			[recvTitle addObject:title];
			[recvText addObject:text];
		}
	}
	
	for (int i = 0; i < 9; i++)
	{
		NSString *title =[dicDataDictionary objectForKey:[NSString stringWithFormat:@"공제항목%d",i+1] ];
		NSString *text  =[dicDataDictionary objectForKey:[NSString stringWithFormat:@"공제내용%d",i+1] ];
		if ([title length] > 0 && [text length] > 0)
		{
			[deductTitle addObject:title];
			[deductText addObject:text];
		}
	}

    // 출금방식, 출금한도, 환매기준가, 거래통화
    for( int t = 1; t <= [dataTitle count]; t++) {
		UILabel *T_TText = [[UILabel alloc] init];
		[T_TText setFrame:CGRectMake(8, basicLabel03.frame.origin.y + 25 + ((t-1)*25), 100, 15)];
        [T_TText setText:[dataTitle objectAtIndex:t - 1]];
        T_TText.textColor = RGB(44, 44, 44);//[UIColor blackColor];
        T_TText.backgroundColor = [UIColor clearColor];
        T_TText.font = [UIFont systemFontOfSize:15.0f];
		T_TText.tag = t;
		[_infoView addSubview:T_TText];
        [T_TText release];
		UILabel *D_DText = [[UILabel alloc] init];
		[D_DText setTextAlignment:UITextAlignmentRight];
		[D_DText setFrame:CGRectMake(129, basicLabel03.frame.origin.y + 25 + ((t-1)*25), 180, 15)];
        [D_DText setText:[dataText objectAtIndex:t - 1]];
        D_DText.textColor = RGB(74, 74, 74);//[UIColor blackColor];
        D_DText.backgroundColor = [UIColor clearColor];
        D_DText.font = [UIFont systemFontOfSize:15.0f];
		D_DText.tag = t;
		[_infoView addSubview:D_DText];
        [D_DText release];
    }

    // 받으시는 내역 타이틀  205 + (([recvTitle count])*21)
//    [basicLabel06 setFrame:CGRectMake(8, basicLabel03.frame.origin.y + 25 + ([dataTitle count]*21), 100, 15)];
    [_lineView1 setFrame:CGRectMake(0, basicLabel03.frame.origin.y + 25 + ([dataTitle count]*25), 100, 25)];

    // 받으시는 내역
    for( int t = 1; t <= [recvTitle count]; t++) {
		UILabel *T_TText = [[UILabel alloc] init];
		[T_TText setFrame:CGRectMake(8, _lineView1.frame.origin.y + 35 + ((t-1)*25), 100, 15)];
        [T_TText setText:[recvTitle objectAtIndex:t - 1]];
        T_TText.textColor = RGB(44, 44, 44);
        T_TText.backgroundColor = [UIColor clearColor];
        T_TText.font = [UIFont systemFontOfSize:15.0f];
		T_TText.tag = t;
		[_infoView addSubview:T_TText];
        [T_TText release];
		UILabel *D_DText = [[UILabel alloc] init];
		[D_DText setTextAlignment:UITextAlignmentRight];
		[D_DText setFrame:CGRectMake(129, _lineView1.frame.origin.y + 35 + ((t-1)*25), 180, 15)];
        [D_DText setText:[recvText objectAtIndex:t - 1]];
        D_DText.textColor = RGB(74, 74, 74);
        D_DText.backgroundColor = [UIColor clearColor];
        D_DText.font = [UIFont systemFontOfSize:15.0f];
		D_DText.tag = t;
		[_infoView addSubview:D_DText];
        [D_DText release];
    }

    // 공제내역 타이틀
//    [basicLabel07 setFrame:CGRectMake(8, basicLabel06.frame.origin.y + 25 + ([recvTitle count]*21), 100, 15)];
    [_lineView2 setFrame:CGRectMake(0, _lineView1.frame.origin.y + 35 + ([recvTitle count]*25), 100, 25)];
    
    // 공제내역
    for( int t = 1; t <= [deductTitle count]; t++) {
		UILabel *T_TText = [[UILabel alloc] init];
		[T_TText setFrame:CGRectMake(8, _lineView2.frame.origin.y + 45 + ((t-1)*25) ,100, 15)];
        [T_TText setText:[deductTitle objectAtIndex:t - 1]];
        T_TText.textColor = RGB(44, 44, 44);
        T_TText.backgroundColor = [UIColor clearColor];
        T_TText.font = [UIFont systemFontOfSize:15.0f];
		T_TText.tag = t;
		[_infoView addSubview:T_TText];
        [T_TText release];
		UILabel *D_DText = [[UILabel alloc] init];
		[D_DText setTextAlignment:UITextAlignmentRight];
		[D_DText setFrame:CGRectMake(129, _lineView2.frame.origin.y + 45 + ((t-1)*25) ,180, 15)];
        [D_DText setText:[deductText objectAtIndex:t - 1]];
        D_DText.textColor = RGB(74, 74, 74);
        D_DText.backgroundColor = [UIColor clearColor];
        D_DText.font = [UIFont systemFontOfSize:15.0f];
		D_DText.tag = t;
		[_infoView addSubview:D_DText];
        [D_DText release];
    }
    
    
    [basicLabel08 setFrame:CGRectMake(8, _lineView2.frame.origin.y + 35 + (([deductTitle count])*25), 150, 15)];
    [basicLabel09 setFrame:CGRectMake(129, _lineView2.frame.origin.y + 35 + (([deductTitle count])*25), 180, 15)];

    basicLabel09.text = [dicDataDictionary objectForKey:@"총공제액"];
    
    [basicLabel10 setFrame:CGRectMake(8, basicLabel08.frame.origin.y + 25, 160, 15)];
    [basicLabel11 setFrame:CGRectMake(129, basicLabel08.frame.origin.y + 25, 180, 15)];
    basicLabel11.text = [dicDataDictionary objectForKey:@"실수령액"];

    [basicLabel12 setFrame:CGRectMake(8, basicLabel10.frame.origin.y + 25, 190, 15)];
    
//    [commentLabel1 setFrame:CGRectMake(8, basicLabel12.frame.origin.y + 21, 301, 64)];
    
    [_completeBtn setFrame:CGRectMake(85, basicLabel12.frame.origin.y + 25, 150, 29)];
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    NSString *strController = NSStringFromClass([[self.navigationController.viewControllers objectAtIndex:1] class]);
    if([strController isEqualToString:@"SHBAccountMenuListViewController"]
       ||[strController isEqualToString:@"SHBFundAccountListViewController"])
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
    self.dicDataDictionary = nil;
    
    [_mainScrollView release];
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
    [_lineView1 release];
    [_lineView2 release];
    
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

    [_infoView setFrame:CGRectMake(0, 0, 317.0f, _completeBtn.frame.origin.y + _completeBtn.frame.size.height + 12)];
    [_mainScrollView setContentSize:_infoView.frame.size];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
