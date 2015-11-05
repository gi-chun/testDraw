//
//  SHBBancasuranceBaseInfoViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBancasuranceBaseInfoViewController.h"
#import "SHBBancasurancePaymentListViewController.h"
//#import "SHBScrollingTicker.h"

@interface SHBBancasuranceBaseInfoViewController ()
{
//    SHBScrollingTicker *scrollingTicker;

}

@end

@implementation SHBBancasuranceBaseInfoViewController
@synthesize accountInfo;
@synthesize dicDataDictionary;

- (void)displayBanData
{
    // Scroll Label
    [_bancaTickerName initFrame:_bancaTickerName.frame colorType:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1] fontSize:15 textAlign:0];
    [_bancaTickerName setCaptionText:[_detailData objectForKey:@"상품명"]];

    // 변액사항,상품정보 데이타
	NSMutableArray *recvText = [[NSMutableArray alloc] init];
	NSMutableArray *deductText = [[NSMutableArray alloc] init];

    if ([[_detailData objectForKey:@"계약자주민번호"] length] > 0) {
        _lblBasis9.text = [NSString stringWithFormat:@"%@-●●●●●●●",
                          [[_detailData objectForKey:@"계약자주민번호"] substringWithRange:NSMakeRange(0, 6)]];
    } else {
        _lblBasis9.text = @"";
    }
    if ([[_detailData objectForKey:@"계약일자"] length] > 0) {
        _lblBasis2.text = [NSString stringWithFormat:@"%@ ~ %@", [SHBUtility getDateWithDash:[_detailData objectForKey:@"계약일자"]], [SHBUtility getDateWithDash:[_detailData objectForKey:@"만기일자"]]];
    } else {
        _lblBasis2.text = @"";
    }
    _lblBasis3.text =  [NSString stringWithFormat:@"%@ / %@", [_detailData objectForKey:@"납입방법"], [_detailData objectForKey:@"납입기간"]];
    if ([[_detailData objectForKey:@"최종납입월"] length] > 0) {
        _lblBasis4.text = [NSString stringWithFormat:@"%@.%@", [[_detailData objectForKey:@"최종납입월"] substringWithRange:NSMakeRange(0, 4)], [[_detailData objectForKey:@"최종납입월"] substringWithRange:NSMakeRange(4, 2)]];
    } else {
        _lblBasis4.text = @"";
    }
    _lblBasis5.text = [NSString stringWithFormat:@"%@회", [_detailData objectForKey:@"최종납입회차"]];
    _lblBasis6.text = [_detailData objectForKey:@"계약일자"];
    _lblBasis7.text = [NSString stringWithFormat:@"%@(%@)", [SHBUtility normalStringTocommaString:[_detailData objectForKey:@"합계보험료"]], [_detailData objectForKey:@"상품통화코드"]];
    _lblBasis8.text = [NSString stringWithFormat:@"%@일", [_detailData objectForKey:@"이체희망일"]];
    _lblBasis22.text = [NSString stringWithFormat:@"%@(%@)", [SHBUtility normalStringTocommaString:[_detailData objectForKey:@"총납입보험료"]], [_detailData objectForKey:@"상품통화코드"]];

    if ([[_detailData objectForKey:@"주피보험자주민번호"] length] > 0) {
        _lblBasis10.text = [NSString stringWithFormat:@"%@-●●●●●●●",
                        [[_detailData objectForKey:@"주피보험자주민번호"] substringWithRange:NSMakeRange(0, 6)]];
    } else {
        _lblBasis10.text = @"";
    }
    if ([[_detailData objectForKey:@"종피보험자주민번호"] length] > 0) {
        _lblBasis11.text = [NSString stringWithFormat:@"%@-●●●●●●●",
                        [[_detailData objectForKey:@"종피보험자주민번호"] substringWithRange:NSMakeRange(0, 6)]];
    } else {
        _lblBasis11.text = @"";
    }
    if ([[_detailData objectForKey:@"만기시수익자주민번호"] length] > 0) {
        _lblBasis12.text = [NSString stringWithFormat:@"%@-●●●●●●●",
                        [[_detailData objectForKey:@"만기시수익자주민번호"] substringWithRange:NSMakeRange(0, 6)]];
    } else {
       _lblBasis12.text = @"";
    }
    if ([[_detailData objectForKey:@"상해시수익자주민번호"] length] > 0) {
        _lblBasis13.text = [NSString stringWithFormat:@"%@-●●●●●●●",
                        [[_detailData objectForKey:@"상해시수익자주민번호"] substringWithRange:NSMakeRange(0, 6)]];
    } else {
        _lblBasis13.text = @"";
    }
    if ([[_detailData objectForKey:@"사망시수익자주민번호1"] length] > 0) {
        _lblBasis14.text = [NSString stringWithFormat:@"%@-●●●●●●●",
                        [[_detailData objectForKey:@"사망시수익자주민번호1"] substringWithRange:NSMakeRange(0, 6)]];
    } else {
        _lblBasis14.text = @"";
    }
    if ([[_detailData objectForKey:@"사망시수익자주민번호2"] length] > 0) {
        _lblBasis15.text = [NSString stringWithFormat:@"%@-●●●●●●●",
                        [[_detailData objectForKey:@"사망시수익자주민번호2"] substringWithRange:NSMakeRange(0, 6)]];
    } else {
        _lblBasis15.text = @"";
    }
    if ([[_detailData objectForKey:@"사망시수익자주민번호3"] length] > 0) {
        _lblBasis16.text = [NSString stringWithFormat:@"%@-●●●●●●●",
                        [[_detailData objectForKey:@"사망시수익자주민번호3"] substringWithRange:NSMakeRange(0, 6)]];
    } else {
        _lblBasis16.text = @"";
    }
    
    // 사망시수익자지급율1,2,3
    if ([[_detailData objectForKey:@"사망시수익자지급율1"] length] > 0) {
        if ([[_detailData objectForKey:@"사망시수익자지급율1"] rangeOfString:@"."].location != NSNotFound) {
            _lblBasis18.text = [[_detailData objectForKey:@"사망시수익자지급율1"] substringWithRange:NSMakeRange(0, [[_detailData objectForKey:@"사망시수익자지급율1"] rangeOfString:@"."].location)];
        } else {
            _lblBasis18.text = [_detailData objectForKey:@"사망시수익자지급율1"];
        }
    } else {
        _lblBasis18.text = @"";
    }

    if ([[_detailData objectForKey:@"사망시수익자지급율2"] length] > 0) {
        if ([[_detailData objectForKey:@"사망시수익자지급율2"] rangeOfString:@"."].location != NSNotFound) {
            _lblBasis19.text = [[_detailData objectForKey:@"사망시수익자지급율2"] substringWithRange:NSMakeRange(0, [[_detailData objectForKey:@"사망시수익자지급율2"] rangeOfString:@"."].location)];
        } else {
            _lblBasis19.text = [_detailData objectForKey:@"사망시수익자지급율2"];
        }
    } else {
        _lblBasis19.text = @"";
    }

    if ([[_detailData objectForKey:@"사망시수익자지급율3"] length] > 0) {
        if ([[_detailData objectForKey:@"사망시수익자지급율3"] rangeOfString:@"."].location != NSNotFound) {
            _lblBasis20.text = [[_detailData objectForKey:@"사망시수익자지급율3"] substringWithRange:NSMakeRange(0, [[_detailData objectForKey:@"사망시수익자지급율3"] rangeOfString:@"."].location)];
        } else {
            _lblBasis20.text = [_detailData objectForKey:@"사망시수익자지급율3"];
        }
    } else {
        _lblBasis20.text = @"";
    }

    // 지급기간
    if ([[_detailData objectForKey:@"연금지급기간명"] isEqualToString:@"0 년"]) {
        _lblBasis21.text = @"";
    } else {
        _lblBasis21.text = [_detailData objectForKey:@"연금지급기간명"];
    }
    
    // 연금개시연령
    if ([[_detailData objectForKey:@"연금개시연령"] isEqualToString:@"0"]) {
        _lblBasis17.text = @"";
    } else {
        _lblBasis17.text = [NSString stringWithFormat:@"%@세",[_detailData objectForKey:@"연금개시연령"]];
    }
    
    for (NSMutableDictionary *dic in [_detailData arrayWithForKey:@"변액사항"]) {
//		[recvText addObject:[dic objectForKey:[NSString stringWithFormat:@"출력속성"]]];
		[recvText addObject:[dic objectForKey:[NSString stringWithFormat:@"변액FUND구분"]]];
		[recvText addObject:[dic objectForKey:[NSString stringWithFormat:@"FUND분담율"]]];
//		[recvText addObject:[dic objectForKey:[NSString stringWithFormat:@"FUND유형"]]];
		[recvText addObject:[dic objectForKey:[NSString stringWithFormat:@"FUND유형명"]]];
    }

    for (NSMutableDictionary *dic in [_detailData arrayWithForKey:@"상품정보"]) {
//		[deductText addObject:[dic objectForKey:[NSString stringWithFormat:@"출력속성"]]];
//		[deductText addObject:[dic objectForKey:[NSString stringWithFormat:@"보험코드"]]];
//		[deductText addObject:[dic objectForKey:[NSString stringWithFormat:@"주계약구분여부"]]];
		[deductText addObject:[dic objectForKey:[NSString stringWithFormat:@"보험명"]]];
		[deductText addObject:[dic objectForKey:[NSString stringWithFormat:@"특약가입금액"]]];
		[deductText addObject:[dic objectForKey:[NSString stringWithFormat:@"특약보험료"]]];
		[deductText addObject:[dic objectForKey:[NSString stringWithFormat:@"보험기간"]]];
		[deductText addObject:[dic objectForKey:[NSString stringWithFormat:@"납입기간"]]];
//		[deductText addObject:[dic objectForKey:[NSString stringWithFormat:@"특약납입상태"]]];
    }
    
    // 3) 특약정보 라벨
    [_lblBasis0 setFrame:CGRectMake(8, 1070, 100, 15)];
    
    int tempDeduct = 5;
    if ([deductText count] > 0) tempDeduct = [deductText count];
    
    // 특약사항 라벨
    for(int t = 0; t < tempDeduct/5; t++) {
        UILabel *T_TText = [[UILabel alloc] init];
        [T_TText setFrame:CGRectMake(8, (_lblBasis0.frame.origin.y + (25*(t+1)))+(t*73), 100, 15)];
        [T_TText setText:@"보험명"];
        [T_TText setTextColor:RGB(74, 74, 74)]; //[UIColor blackColor];
        T_TText.backgroundColor = [UIColor clearColor];
        T_TText.font = [UIFont systemFontOfSize:15.0f];
        T_TText.tag = t;
        [_infoView addSubview:T_TText];
        [T_TText release];
        
        UILabel *T_TText2 = [[UILabel alloc] init];
        [T_TText2 setFrame:CGRectMake(8, (_lblBasis0.frame.origin.y + (25*(t+2)))+(t*73), 100, 15)];
        [T_TText2 setText:@"특약가입금액"];
        [T_TText2 setTextColor:RGB(74, 74, 74)];
        T_TText2.backgroundColor = [UIColor clearColor];
        T_TText2.font = [UIFont systemFontOfSize:15.0f];
        T_TText2.tag = t;
        [_infoView addSubview:T_TText2];
        [T_TText2 release];
        
        UILabel *T_TText3 = [[UILabel alloc] init];
        [T_TText3 setFrame:CGRectMake(8, (_lblBasis0.frame.origin.y + (25*(t+3)))+(t*73), 100, 15)];
        [T_TText3 setText:@"특약보험료"];
        [T_TText3 setTextColor:RGB(74, 74, 74)];
        T_TText3.backgroundColor = [UIColor clearColor];
        T_TText3.font = [UIFont systemFontOfSize:15.0f];
        T_TText3.tag = t;
        [_infoView addSubview:T_TText3];
        [T_TText3 release];
        
        UILabel *T_TText4 = [[UILabel alloc] init];
        [T_TText4 setFrame:CGRectMake(8, (_lblBasis0.frame.origin.y + (25*(t+4)))+(t*73), 100, 15)];
        [T_TText4 setText:@"보험기간"];
        [T_TText4 setTextColor:RGB(74, 74, 74)];
        T_TText4.backgroundColor = [UIColor clearColor];
        T_TText4.font = [UIFont systemFontOfSize:15.0f];
        T_TText4.tag = t;
        [_infoView addSubview:T_TText4];
        [T_TText4 release];
        
        UILabel *T_TText5 = [[UILabel alloc] init];
        [T_TText5 setFrame:CGRectMake(8, (_lblBasis0.frame.origin.y + (25*(t+5)))+(t*73), 100, 15)];
        [T_TText5 setText:@"납입기간"];
        [T_TText5 setTextColor:RGB(74, 74, 74)];
        T_TText5.backgroundColor = [UIColor clearColor];
        T_TText5.font = [UIFont systemFontOfSize:15.0f];
        T_TText5.tag = t;
        [_infoView addSubview:T_TText5];
        [T_TText5 release];
    }

    // 특약사항 라벨
    for(int t = 0; t < [deductText count]/5; t++) {
//        UILabel *D_DText = [[UILabel alloc] init];
//        [D_DText setTextAlignment:UITextAlignmentRight];
//        [D_DText setFrame:CGRectMake(129, (_lblBasis0.frame.origin.y + (25*(t+1)))+(t*73), 180, 15)];
//        [D_DText setText:[deductText objectAtIndex:(5*t)]];
//        D_DText.textColor = RGB(44, 44, 44);// [UIColor blackColor];
//        D_DText.backgroundColor = [UIColor clearColor];
//        D_DText.font = [UIFont systemFontOfSize:15.0f];
//        D_DText.tag = t;
//        [_infoView addSubview:D_DText];
        
        // Scroll Label
        _bancaDetailTickerName = [[SHBScrollLabel alloc] initWithFrame:CGRectMake(129, ((_lblBasis0.frame.origin.y + (25*(t+1)))+(t*73))-2, 180, 19)];
        [_bancaDetailTickerName initFrame:_bancaDetailTickerName.frame colorType:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1] fontSize:15 textAlign:2];
        [_bancaDetailTickerName setCaptionText:[deductText objectAtIndex:(5*t)]];
        [_infoView addSubview:_bancaDetailTickerName];

        UILabel *D_DText2 = [[UILabel alloc] init];
        [D_DText2 setTextAlignment:UITextAlignmentRight];
        [D_DText2 setFrame:CGRectMake(129, (_lblBasis0.frame.origin.y + (25*(t+2)))+(t*73), 180, 15)];
        [D_DText2 setText:[NSString stringWithFormat:@"%@", [SHBUtility normalStringTocommaString:[deductText objectAtIndex:(5*t)+1]]]];
        D_DText2.textColor = RGB(44, 44, 44); //[UIColor blackColor];
        D_DText2.backgroundColor = [UIColor clearColor];
        D_DText2.font = [UIFont systemFontOfSize:15.0f];
        D_DText2.tag = t;
        [_infoView addSubview:D_DText2];
        [D_DText2 release];

        UILabel *D_DText3 = [[UILabel alloc] init];
        [D_DText3 setTextAlignment:UITextAlignmentRight];
        [D_DText3 setFrame:CGRectMake(129, (_lblBasis0.frame.origin.y + (25*(t+3)))+(t*73), 180, 15)];
        [D_DText3 setText:[NSString stringWithFormat:@"%@", [SHBUtility normalStringTocommaString:[deductText objectAtIndex:(t*5)+2]]]];
        D_DText3.textColor = RGB(44, 44, 44); //[UIColor blackColor];
        D_DText3.backgroundColor = [UIColor clearColor];
        D_DText3.font = [UIFont systemFontOfSize:15.0f];
        D_DText3.tag = t;
        [_infoView addSubview:D_DText3];
        [D_DText3 release];
        
        UILabel *D_DText4 = [[UILabel alloc] init];
        [D_DText4 setTextAlignment:UITextAlignmentRight];
        [D_DText4 setFrame:CGRectMake(129, (_lblBasis0.frame.origin.y + (25*(t+4)))+(t*73), 180, 15)];
        [D_DText4 setText:[deductText objectAtIndex:(t*5)+3]];
        D_DText4.textColor = RGB(44, 44, 44); //[UIColor blackColor];
        D_DText4.backgroundColor = [UIColor clearColor];
        D_DText4.font = [UIFont systemFontOfSize:15.0f];
        D_DText4.tag = t;
        [_infoView addSubview:D_DText4];
        [D_DText4 release];
        
        UILabel *D_DText5 = [[UILabel alloc] init];
        [D_DText5 setTextAlignment:UITextAlignmentRight];
        [D_DText5 setFrame:CGRectMake(129, (_lblBasis0.frame.origin.y + (25*(t+5)))+(t*73), 180, 15)];
        [D_DText5 setText:[deductText objectAtIndex:(t*5)+4]];
        D_DText5.textColor = RGB(44, 44, 44); //[UIColor blackColor];
        D_DText5.backgroundColor = [UIColor clearColor];
        D_DText5.font = [UIFont systemFontOfSize:15.0f];
        D_DText5.tag = t;
        [_infoView addSubview:D_DText5];
        [D_DText5 release];
    }
    [deductText release];
    
    // 4) 변액정보 라벨
    [_lblBasis1 setFrame:CGRectMake(8, _lblBasis0.frame.origin.y + ((tempDeduct+1) * 25), 100, 15)];
    
    // 변액사항 라벨
    int tempCount = 3;
    if ([recvText count] > 0) tempCount = [recvText count];
    
    for( int t = 0; t < tempCount/3; t++) {
        UILabel *T_TText = [[UILabel alloc] init];
        [T_TText setFrame:CGRectMake(8, (_lblBasis1.frame.origin.y + (25*(t+1)))+(t*48), 100, 15)];
        [T_TText setText:@"변액FUND구분"];
        [T_TText setTextColor:RGB(74, 74, 74)];
        T_TText.backgroundColor = [UIColor clearColor];
        T_TText.font = [UIFont systemFontOfSize:15.0f];
        T_TText.tag = t;
        [_infoView addSubview:T_TText];
        [T_TText release];
        
        UILabel *T_TText2 = [[UILabel alloc] init];
        [T_TText2 setFrame:CGRectMake(8, (_lblBasis1.frame.origin.y + (25*(t+2)))+(t*48), 100, 15)];
        [T_TText2 setText:@"FUND분담율"];
        [T_TText2 setTextColor:RGB(74, 74, 74)];
        T_TText2.backgroundColor = [UIColor clearColor];
        T_TText2.font = [UIFont systemFontOfSize:15.0f];
        T_TText2.tag = t;
        [_infoView addSubview:T_TText2];
        [T_TText2 release];
        
        UILabel *T_TText3 = [[UILabel alloc] init];
        [T_TText3 setFrame:CGRectMake(8, (_lblBasis1.frame.origin.y + (25*(t+3)))+(t*48), 100, 15)];
        [T_TText3 setText:@"FUND유형"];
        [T_TText3 setTextColor:RGB(74, 74, 74)];
        T_TText3.backgroundColor = [UIColor clearColor];
        T_TText3.font = [UIFont systemFontOfSize:15.0f];
        T_TText3.tag = t;
        [_infoView addSubview:T_TText3];
        [T_TText3 release];
    }

    // 변액사항 데이터
    for( int t = 0; t < [recvText count]/3; t++) {
        UILabel *D_DText = [[UILabel alloc] init];
        [D_DText setTextAlignment:UITextAlignmentRight];
        [D_DText setFrame:CGRectMake(129, (_lblBasis1.frame.origin.y + (25*(t+1)))+(t*48), 180, 15)];
        [D_DText setText:[recvText objectAtIndex:(t*3)]];
        D_DText.textColor = RGB(44, 44, 44); //[UIColor blackColor];
        D_DText.backgroundColor = [UIColor clearColor];
        D_DText.font = [UIFont systemFontOfSize:15.0f];
        D_DText.tag = t;
        [_infoView addSubview:D_DText];
        [D_DText release];
        
        UILabel *D_DText2 = [[UILabel alloc] init];
        [D_DText2 setTextAlignment:UITextAlignmentRight];
        [D_DText2 setFrame:CGRectMake(129, (_lblBasis1.frame.origin.y + (25*(t+2)))+(t*48), 180, 15)];
        [D_DText2 setText:[recvText objectAtIndex:(t*3)+1]];
        D_DText2.textColor = RGB(44, 44, 44); //[UIColor blackColor];
        D_DText2.backgroundColor = [UIColor clearColor];
        D_DText2.font = [UIFont systemFontOfSize:15.0f];
        D_DText2.tag = t;
        [_infoView addSubview:D_DText2];
        [D_DText2 release];
        
        UILabel *D_DText3 = [[UILabel alloc] init];
        [D_DText3 setTextAlignment:UITextAlignmentRight];
        [D_DText3 setFrame:CGRectMake(129, (_lblBasis1.frame.origin.y + (25*(t+3)))+(t*48), 180, 15)];
        [D_DText3 setText:[recvText objectAtIndex:(t*3)+2]];
        D_DText3.textColor = RGB(44, 44, 44); //[UIColor blackColor];
        D_DText3.backgroundColor = [UIColor clearColor];
        D_DText3.font = [UIFont systemFontOfSize:15.0f];
        D_DText3.tag = t;
        [_infoView addSubview:D_DText3];
        [D_DText3 release];
    }
    [recvText release];

    [_infoView setFrame:CGRectMake(0, 0, 317.0f, _lblBasis1.frame.origin.y + ((tempCount+1) * 25))];

}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    SHBBancasurancePaymentListViewController *detailViewController = [[SHBBancasurancePaymentListViewController alloc] initWithNibName:@"SHBBancasurancePaymentListViewController" bundle:nil];
    detailViewController.detailData = _detailData;
    
//    [self.navigationController pushViewController:detailViewController animated:YES];
    [self.navigationController pushFadeViewController:detailViewController];
    [detailViewController release];
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
    
    self.title = @"방카슈랑스조회";
    self.strBackButtonTitle = @"방카슈랑스조회 상세";

    [self.binder bind:self dataSet:_detailData];
    // 가변데이터 표시
//    [self displayBaseInfo];
    [self displayBanData];
    [_mainScrollView setContentSize:_infoView.frame.size];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [accountInfo release];
    [dicDataDictionary release];
    [_mainScrollView release];
    [_infoView release];
    [_btnDetailAccount release];
    [_bancaTickerName release];

    [_lblBasis0 release];
    [_lblBasis1 release];
    [_lblBasis3 release];
    [_lblBasis4 release];
    [_lblBasis5 release];
    [_lblBasis6 release];
    [_lblBasis7 release];
    [_lblBasis8 release];
    [_lblBasis9 release];
    [_lblBasis10 release];
    [_lblBasis11 release];
    [_lblBasis12 release];
    [_lblBasis13 release];
    [_lblBasis14 release];
    [_lblBasis15 release];
    [_lblBasis16 release];
    [_lblBasis17 release];
    [_lblBasis18 release];
    [_lblBasis19 release];
    [_lblBasis20 release];
    [_lblBasis21 release];
    [_lblBasis22 release];

    [super dealloc];
}

@end
