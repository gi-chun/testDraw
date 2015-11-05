//
//  SHBBancasuranceDemageInfoViewController.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 2..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBancasuranceDemageInfoViewController.h"
#import "SHBBancasurancePaymentListViewController.h"

@interface SHBBancasuranceDemageInfoViewController ()

@end

@implementation SHBBancasuranceDemageInfoViewController
@synthesize accountInfo;
@synthesize dicDataDictionary;

- (void)displayBanData
{
    // Scroll Label
    [_bancaTickerName initFrame:_bancaTickerName.frame colorType:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1] fontSize:15 textAlign:0];
    [_bancaTickerName setCaptionText:[_detailData objectForKey:@"상품명"]];

    // 변액사항,상품정보 데이타
	NSMutableArray *recvText1 = [[NSMutableArray alloc] init];
	NSMutableArray *recvText2 = [[NSMutableArray alloc] init];
	NSMutableArray *recvText3 = [[NSMutableArray alloc] init];
    
    if ([[_detailData objectForKey:@"계약자등록번호"] length] > 0) {
        _lblData0.text = [NSString stringWithFormat:@"%@-●●●●●●●",
                           [[_detailData objectForKey:@"계약자등록번호"] substringWithRange:NSMakeRange(0, 6)]];
    } else {
        _lblData0.text = @"";
    }
    if ([[_detailData objectForKey:@"보험시작일"] length] > 0) {
        _lblData1.text = [NSString stringWithFormat:@"%@ ~ %@", [_detailData objectForKey:@"보험시작일"], [_detailData objectForKey:@"보험종료일"]];
    } else {
        _lblData1.text = @"";
    }
    _lblData2.text =  [NSString stringWithFormat:@"%@ / %@", [_detailData objectForKey:@"납입방법"], [_detailData objectForKey:@"납입기간"]];
    _lblData3.text = [NSString stringWithFormat:@"%@회", [_detailData objectForKey:@"최종납입회차"]];
    _lblData4.text = [NSString stringWithFormat:@"%@(%@)", [_detailData objectForKey:@"합계보험료"], [_detailData objectForKey:@"상품통화코드"]];

    for (NSMutableDictionary *dic in [_detailData arrayWithForKey:@"계약관계자"]) {
		[recvText1 addObject:[SHBUtility nilToString:[dic objectForKey:[NSString stringWithFormat:@"계약자와관계명"]]]];
		[recvText1 addObject:[SHBUtility nilToString:[dic objectForKey:[NSString stringWithFormat:@"피보험자한글명"]]]];
		[recvText1 addObject:[SHBUtility nilToString:[dic objectForKey:[NSString stringWithFormat:@"피보험자주민번호"]]]];
    }
    
    for (NSMutableDictionary *dic in [_detailData arrayWithForKey:@"수익자"]) {
		[recvText2 addObject:[SHBUtility nilToString:[dic objectForKey:[NSString stringWithFormat:@"수익자구분"]]]];
		[recvText2 addObject:[SHBUtility nilToString:[dic objectForKey:[NSString stringWithFormat:@"수익자한글명"]]]];
		[recvText2 addObject:[SHBUtility nilToString:[dic objectForKey:[NSString stringWithFormat:@"수익자주민번호"]]]];
    }

    for (NSMutableDictionary *dic in [_detailData arrayWithForKey:@"특약정보"]) {
		[recvText3 addObject:[SHBUtility nilToString:[dic objectForKey:[NSString stringWithFormat:@"구분명"]]]];
		[recvText3 addObject:[SHBUtility nilToString:[dic objectForKey:[NSString stringWithFormat:@"담보명"]]]];
		[recvText3 addObject:[SHBUtility nilToString:[dic objectForKey:[NSString stringWithFormat:@"담보별가입금액"]]]];
		[recvText3 addObject:[SHBUtility nilToString:[dic objectForKey:[NSString stringWithFormat:@"담보별보험료"]]]];
    }

// 데이터의 정확성 부재로 현업과 협의후 제외
//    for (NSMutableDictionary *dic in [_detailData arrayWithForKey:@"목적물정보"]) {
//		[recvText4 addObject:[dic objectForKey:[NSString stringWithFormat:@"목적물명"]]];
//		[recvText4 addObject:[dic objectForKey:[NSString stringWithFormat:@"가입금액"]]];
//		[recvText4 addObject:[dic objectForKey:[NSString stringWithFormat:@"특약정보"]]];
//    }

    // 2 계약관계자
    [_infoTitleView2 setFrame:CGRectMake(0, 260, 317, 25)];

    // 계약관계자 총피보험수 라벨
    [_lblBasis16 setFrame:CGRectMake(8, 320, 100, 15)];

    // 계약형태
    _lblBasis15.text = [_detailData objectForKey:@"가입유형"];
    
    if ([[_detailData objectForKey:@"총피보험자수"] length] > 0) {
        _lblBasis17.text = [NSString stringWithFormat:@"%@명",[_detailData objectForKey:@"총피보험자수"]];
    } else {
        _lblBasis17.text = @"";
    }
    
    int tempRecv1 = 3;
    if ([recvText1 count] > 0) tempRecv1 = [recvText1 count];
    
    // 계약관계자 라벨
    for(int t = 0; t < tempRecv1/3; t++) {
        UILabel *T_TText = [[UILabel alloc] init];
        [T_TText setFrame:CGRectMake(8, (_lblBasis16.frame.origin.y + (25*(t+1)))+(t*48), 100, 15)];
        [T_TText setText:@"구분"];
        T_TText.textColor = RGB(74, 74, 74);
        T_TText.backgroundColor = [UIColor clearColor];
        T_TText.font = [UIFont systemFontOfSize:15.0f];
        T_TText.tag = t;
        [_infoView addSubview:T_TText];
        [T_TText release];
        
        UILabel *T_TText2 = [[UILabel alloc] init];
        [T_TText2 setFrame:CGRectMake(8, (_lblBasis16.frame.origin.y + (25*(t+2)))+(t*48), 100, 15)];
        [T_TText2 setText:@"피보험자한글명"];
        T_TText2.textColor = RGB(74, 74, 74);//[UIColor blackColor];
        T_TText2.backgroundColor = [UIColor clearColor];
        T_TText2.font = [UIFont systemFontOfSize:15.0f];
        T_TText2.tag = t;
        [_infoView addSubview:T_TText2];
        [T_TText2 release];
        
        UILabel *T_TText3 = [[UILabel alloc] init];
        [T_TText3 setFrame:CGRectMake(8, (_lblBasis16.frame.origin.y + (25*(t+3)))+(t*48), 130, 15)];
        [T_TText3 setText:@"피보험자주민번호"];
        T_TText3.textColor = RGB(74, 74, 74);//[UIColor blackColor];
        T_TText3.backgroundColor = [UIColor clearColor];
        T_TText3.font = [UIFont systemFontOfSize:15.0f];
        T_TText3.tag = t;
        [_infoView addSubview:T_TText3];
        [T_TText3 release];
    }

    // 계약관계자 데이터
    for(int t = 0; t < [recvText1 count]/2; t++) {
        UILabel *D_DText = [[UILabel alloc] init];
        [D_DText setTextAlignment:UITextAlignmentRight];
        [D_DText setFrame:CGRectMake(129, (_lblBasis16.frame.origin.y + (25*(t+1)))+(t*48), 180, 15)];
        [D_DText setText:[recvText1 objectAtIndex:(t*2)]];
        D_DText.textColor = RGB(44, 44, 44);
        D_DText.backgroundColor = [UIColor clearColor];
        D_DText.font = [UIFont systemFontOfSize:15.0f];
        D_DText.tag = t;
        [_infoView addSubview:D_DText];
        [D_DText release];
        
        UILabel *D_DText2 = [[UILabel alloc] init];
        [D_DText2 setTextAlignment:UITextAlignmentRight];
        [D_DText2 setFrame:CGRectMake(129, (_lblBasis16.frame.origin.y + (25*(t+2)))+(t*48), 180, 15)];
        [D_DText2 setText:[recvText1 objectAtIndex:(t*2)+1]];
        D_DText2.textColor = RGB(44, 44, 44);//[UIColor blackColor];
        D_DText2.backgroundColor = [UIColor clearColor];
        D_DText2.font = [UIFont systemFontOfSize:15.0f];
        D_DText2.tag = t;
        [_infoView addSubview:D_DText2];
        [D_DText2 release];
        
        UILabel *D_DText3 = [[UILabel alloc] init];
        [D_DText3 setTextAlignment:UITextAlignmentRight];
        [D_DText3 setFrame:CGRectMake(129, (_lblBasis16.frame.origin.y + (25*(t+3)))+(t*48), 180, 15)];
        
        if ([[recvText1 objectAtIndex:(t*2)+2] length] > 0) {
            [D_DText3 setText:[NSString stringWithFormat:@"%@-●●●●●●●",
                               [[recvText1 objectAtIndex:(t*2)+2] substringWithRange:NSMakeRange(0, 6)]]];
        } else {
            [D_DText3 setText:@""];
        }
        D_DText3.textColor = [UIColor blackColor];
        D_DText3.backgroundColor = [UIColor clearColor];
        D_DText3.font = [UIFont systemFontOfSize:15.0f];
        D_DText3.tag = t;
        [_infoView addSubview:D_DText3];
        [D_DText3 release];
    }
    [recvText1 release];
    
    // 3 수익자
    [_infoTitleView3 setFrame:CGRectMake(0, _lblBasis16.frame.origin.y + ((tempRecv1+1) * 25), 317, 25)];

    float tempPos2 = 0;

    int tempRecv2 = 3;
    if ([recvText2 count] > 0) tempRecv2 = [recvText2 count];
    
    // 수익자 라벨
    for(int t = 0; t < tempRecv2/3; t++) {
//        UILabel *T_TText4 = [[UILabel alloc] init];
//        [T_TText4 setFrame:CGRectMake(8, (_infoTitleView3.frame.origin.y + 10 + (25*(t+1)))+(t*48), 100, 15)];
//        [T_TText4 setText:@"수익자구분"];
//        T_TText4.textColor = RGB(74, 74, 74);//[UIColor blackColor];
//        T_TText4.backgroundColor = [UIColor clearColor];
//        T_TText4.font = [UIFont systemFontOfSize:15.0f];
//        T_TText4.tag = t;
//        [_infoView addSubview:T_TText4];
        
        UILabel *D_DText4 = [[UILabel alloc] init];
        [D_DText4 setFrame:CGRectMake(8, (_infoTitleView3.frame.origin.y + 10 + (25*(t+1)))+(t*26), 100, 15)];
        [D_DText4 setText:[recvText2 objectAtIndex:(t*3)]];
        D_DText4.textColor =  RGB(74, 74, 74);
        D_DText4.backgroundColor = [UIColor clearColor];
        D_DText4.font = [UIFont systemFontOfSize:15.0f];
        D_DText4.tag = t;
        [_infoView addSubview:D_DText4];
        [D_DText4 release];
        
        UILabel *T_TText5 = [[UILabel alloc] init];
        [T_TText5 setFrame:CGRectMake(8, (_infoTitleView3.frame.origin.y + 10 + (25*(t+2)))+(t*26), 100, 15)];
        [T_TText5 setText:@"주민번호"];
        T_TText5.textColor = RGB(74, 74, 74);//[UIColor blackColor];
        T_TText5.backgroundColor = [UIColor clearColor];
        T_TText5.font = [UIFont systemFontOfSize:15.0f];
        T_TText5.tag = t;
        [_infoView addSubview:T_TText5];
        [T_TText5 release];
        
//        UILabel *T_TText6 = [[UILabel alloc] init];
//        [T_TText6 setFrame:CGRectMake(8, (_infoTitleView3.frame.origin.y + 10 + (25*(t+3)))+(t*48), 100, 15)];
//        [T_TText6 setText:@"수익자주민번호"];
//        T_TText6.textColor = RGB(74, 74, 74);//[UIColor blackColor];
//        T_TText6.backgroundColor = [UIColor clearColor];
//        T_TText6.font = [UIFont systemFontOfSize:15.0f];
//        T_TText6.tag = t;
//        [_infoView addSubview:T_TText6];
        
        tempPos2 = (_infoTitleView3.frame.origin.y + 10 + (25*(t+2)))+(t*28);

    }

    // 수익자 데이터
    for(int t = 0; t < [recvText2 count]/3; t++) {
//        UILabel *D_DText4 = [[UILabel alloc] init];
//        [D_DText4 setTextAlignment:UITextAlignmentRight];
//        [D_DText4 setFrame:CGRectMake(129, (_infoTitleView3.frame.origin.y + 10 + (25*(t+1)))+(t*48), 180, 15)];
//        [D_DText4 setText:[recvText2 objectAtIndex:(t*3)]];
//        D_DText4.textColor =  RGB(44, 44, 44);
//        D_DText4.backgroundColor = [UIColor clearColor];
//        D_DText4.font = [UIFont systemFontOfSize:15.0f];
//        D_DText4.tag = t;
//        [_infoView addSubview:D_DText4];
        
        UILabel *D_DText5 = [[UILabel alloc] init];
        [D_DText5 setTextAlignment:UITextAlignmentRight];
        [D_DText5 setFrame:CGRectMake(129, (_infoTitleView3.frame.origin.y + 10 + (25*(t+1)))+(t*26), 180, 15)];
        [D_DText5 setText:[recvText2 objectAtIndex:(t*3)+1]];
        D_DText5.textColor =  RGB(44, 44, 44);
        D_DText5.backgroundColor = [UIColor clearColor];
        D_DText5.font = [UIFont systemFontOfSize:15.0f];
        D_DText5.tag = t;
        [_infoView addSubview:D_DText5];
        [D_DText5 release];
        
        UILabel *D_DText6 = [[UILabel alloc] init];
        [D_DText6 setTextAlignment:UITextAlignmentRight];
        [D_DText6 setFrame:CGRectMake(129, (_infoTitleView3.frame.origin.y + 10 + (25*(t+2)))+(t*26), 180, 15)];
        if ([[recvText2 objectAtIndex:(t*3)+2] length] > 0) {
            [D_DText6 setText:[NSString stringWithFormat:@"%@-●●●●●●●",
                               [[recvText2 objectAtIndex:(t*3)+2] substringWithRange:NSMakeRange(0, 6)]]];
        } else {
            [D_DText6 setText:@""];
        }
        D_DText6.textColor =  RGB(44, 44, 44);//[UIColor blackColor];
        D_DText6.backgroundColor = [UIColor clearColor];
        D_DText6.font = [UIFont systemFontOfSize:15.0f];
        D_DText6.tag = t;
        [_infoView addSubview:D_DText6];
        [D_DText6 release];
    }
    [recvText2 release];
    
    // 4 계약사항
//    [_infoTitleView4 setFrame:CGRectMake(0, _infoTitleView3.frame.origin.y + 10 + ((tempRecv2) * 25), 317, 25)];
    [_infoTitleView4 setFrame:CGRectMake(0, tempPos2 + 25, 317, 25)];

    // 1)여행 사항
    [_lblBasis0 setFrame:CGRectMake(8, _infoTitleView4.frame.origin.y + 35, 100, 15)];
    [_lblBasis1 setFrame:CGRectMake(8, _lblBasis0.frame.origin.y + 25, 100, 15)];
    [_lblBasis2 setFrame:CGRectMake(8, _lblBasis1.frame.origin.y + 25, 100, 15)];
    // 여행목적 데이터
    [_lblBasis13 setFrame:CGRectMake(8, _lblBasis0.frame.origin.y + 25, 100, 15)];
    [_lblBasis14 setFrame:CGRectMake(8, _lblBasis1.frame.origin.y + 25, 100, 15)];

    
    // 2) 담보사항
    [_lblBasis3 setFrame:CGRectMake(8, _lblBasis2.frame.origin.y + 25, 100, 15)];

    float tempPos = 0;
    int tempRecv3 = 4;
    if ([recvText3 count] > 0) tempRecv3 = [recvText3 count];
    
    // 2) 담보사항 라벨
    for( int t = 0; t < tempRecv3/4; t++) {
        UILabel *T_TText7 = [[UILabel alloc] init];
        [T_TText7 setFrame:CGRectMake(8, (_lblBasis3.frame.origin.y + (25*(t+1)))+(t*73), 100, 15)];
        [T_TText7 setText:@"구분"];
        T_TText7.textColor = RGB(74, 74, 74);//[UIColor blackColor];
        T_TText7.backgroundColor = [UIColor clearColor];
        T_TText7.font = [UIFont systemFontOfSize:15.0f];
        T_TText7.tag = t;
        [_infoView addSubview:T_TText7];
        [T_TText7 release];
        
        UILabel *T_TText8 = [[UILabel alloc] init];
        [T_TText8 setFrame:CGRectMake(8, (_lblBasis3.frame.origin.y + (25*(t+2)))+(t*73), 100, 15)];
        [T_TText8 setText:@"담보"];
        T_TText8.textColor = RGB(74, 74, 74);//[UIColor blackColor];
        T_TText8.backgroundColor = [UIColor clearColor];
        T_TText8.font = [UIFont systemFontOfSize:15.0f];
        T_TText8.tag = t;
        [_infoView addSubview:T_TText8];
        [T_TText8 release];
        
        UILabel *T_TText9 = [[UILabel alloc] init];
        [T_TText9 setFrame:CGRectMake(8, (_lblBasis3.frame.origin.y + (25*(t+3)))+(t*73), 100, 15)];
        [T_TText9 setText:@"가입금액"];
        T_TText9.textColor = RGB(74, 74, 74);//[UIColor blackColor];
        T_TText9.backgroundColor = [UIColor clearColor];
        T_TText9.font = [UIFont systemFontOfSize:15.0f];
        T_TText9.tag = t;
        [_infoView addSubview:T_TText9];
        [T_TText9 release];
        
        UILabel *T_TText10 = [[UILabel alloc] init];
        [T_TText10 setFrame:CGRectMake(8, (_lblBasis3.frame.origin.y + (25*(t+4)))+(t*73), 100, 15)];
        [T_TText10 setText:@"보험료"];
        T_TText10.textColor = RGB(74, 74, 74);//[UIColor blackColor];
        T_TText10.backgroundColor = [UIColor clearColor];
        T_TText10.font = [UIFont systemFontOfSize:15.0f];
        T_TText10.tag = t;
        [_infoView addSubview:T_TText10];
        [T_TText10 release];
        
        tempPos = (_lblBasis3.frame.origin.y + (25*(t+4)))+(t*73);
    }

    // 2) 담보사항 데이터
    for( int t = 0; t < [recvText3 count]/4; t++) {
        UILabel *D_DText7 = [[UILabel alloc] init];
        [D_DText7 setTextAlignment:UITextAlignmentRight];
        [D_DText7 setFrame:CGRectMake(129, (_lblBasis3.frame.origin.y + (25*(t+1)))+(t*73), 180, 15)];
        [D_DText7 setText:[recvText3 objectAtIndex:(t*4)]];
        D_DText7.textColor = RGB(44, 44, 44);
        D_DText7.backgroundColor = [UIColor clearColor];
        D_DText7.font = [UIFont systemFontOfSize:15.0f];
        D_DText7.tag = t;
        [_infoView addSubview:D_DText7];
        [D_DText7 release];
        
//        UILabel *D_DText8 = [[UILabel alloc] init];
//        [D_DText8 setTextAlignment:UITextAlignmentRight];
//        [D_DText8 setFrame:CGRectMake(129, (_lblBasis3.frame.origin.y + (25*(t+2)))+(t*73), 180, 15)];
//        [D_DText8 setText:[recvText3 objectAtIndex:(t*4)+1]];
//        D_DText8.textColor = RGB(44, 44, 44);
//        D_DText8.backgroundColor = [UIColor clearColor];
//        D_DText8.font = [UIFont systemFontOfSize:15.0f];
//        D_DText8.tag = t;
//        [_infoView addSubview:D_DText8];
//        [D_DText8 release];
        
        // Scroll Label
        _bancaDetailTickerName = [[SHBScrollLabel alloc] initWithFrame:CGRectMake(129, ((_lblBasis3.frame.origin.y + (25*(t+2)))+(t*73))-2, 180, 19)];
        [_bancaDetailTickerName initFrame:_bancaDetailTickerName.frame colorType:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1] fontSize:15 textAlign:2];
        [_bancaDetailTickerName setCaptionText:[recvText3 objectAtIndex:(t*4)+1]];
        [_infoView addSubview:_bancaDetailTickerName];
        [_bancaDetailTickerName release];
        
        UILabel *D_DText9 = [[UILabel alloc] init];
        [D_DText9 setTextAlignment:UITextAlignmentRight];
        [D_DText9 setFrame:CGRectMake(129, (_lblBasis3.frame.origin.y + (25*(t+3)))+(t*73), 180, 15)];
        [D_DText9 setText:[recvText3 objectAtIndex:(t*4)+2]];
        D_DText9.textColor = RGB(44, 44, 44);
        D_DText9.backgroundColor = [UIColor clearColor];
        D_DText9.font = [UIFont systemFontOfSize:15.0f];
        D_DText9.tag = t;
        [_infoView addSubview:D_DText9];
        [D_DText9 release];
        
        UILabel *D_DText10 = [[UILabel alloc] init];
        [D_DText10 setTextAlignment:UITextAlignmentRight];
        [D_DText10 setFrame:CGRectMake(129, (_lblBasis3.frame.origin.y + (25*(t+4)))+(t*73), 180, 15)];
        [D_DText10 setText:[recvText3 objectAtIndex:(t*4)+3]];
        D_DText10.textColor = RGB(44, 44, 44);
        D_DText10.backgroundColor = [UIColor clearColor];
        D_DText10.font = [UIFont systemFontOfSize:15.0f];
        D_DText10.tag = t;
        [_infoView addSubview:D_DText10];
        [D_DText10 release];
    }
    [recvText3 release];
    
// 데이터의 정확성 부재로 현업과 협의후 제외
//    // 3) 목적물정보
////    [_lblBasis4 setFrame:CGRectMake(8, _lblBasis3.frame.origin.y + 10 + (tempRecv3 * 25), 100, 15)];
//    [_lblBasis4 setFrame:CGRectMake(8, tempPos + 25, 100, 15)];
//
//    int tempRecv4 = 3;
//    if ([recvText4 count] > 0) tempRecv4 = [recvText4 count];
//    
//    // 목적물정보 라벨
//    for(int t = 0; t < tempRecv4/3; t++) {
//        UILabel *T_TText11 = [[UILabel alloc] init];
//        [T_TText11 setFrame:CGRectMake(8, (_lblBasis4.frame.origin.y + (25*(t+1)))+(t*48), 100, 15)];
//        [T_TText11 setText:@"목적물명"];
//        T_TText11.textColor = RGB(74, 74, 74);//[UIColor blackColor];
//        T_TText11.backgroundColor = [UIColor clearColor];
//        T_TText11.font = [UIFont systemFontOfSize:15.0f];
//        T_TText11.tag = t;
//        [_infoView addSubview:T_TText11];
//        
//        UILabel *T_TText12 = [[UILabel alloc] init];
//        [T_TText12 setFrame:CGRectMake(8, (_lblBasis4.frame.origin.y + (25*(t+2)))+(t*48), 100, 15)];
//        [T_TText12 setText:@"가입금액"];
//        T_TText12.textColor = RGB(74, 74, 74);//[UIColor blackColor];
//        T_TText12.backgroundColor = [UIColor clearColor];
//        T_TText12.font = [UIFont systemFontOfSize:15.0f];
//        T_TText12.tag = t;
//        [_infoView addSubview:T_TText12];
//        
//        UILabel *T_TText13 = [[UILabel alloc] init];
//        [T_TText13 setFrame:CGRectMake(8, (_lblBasis4.frame.origin.y + (25*(t+3)))+(t*48), 100, 15)];
//        [T_TText13 setText:@"특약정보"];
//        T_TText13.textColor = RGB(74, 74, 74);//[UIColor blackColor];
//        T_TText13.backgroundColor = [UIColor clearColor];
//        T_TText13.font = [UIFont systemFontOfSize:15.0f];
//        T_TText13.tag = t;
//        [_infoView addSubview:T_TText13];
//    }
//
//    // 목적물정보 데이터
//    for(int t = 0; t < [recvText4 count]/3; t++) {
//        UILabel *D_DText11 = [[UILabel alloc] init];
//        [D_DText11 setTextAlignment:UITextAlignmentRight];
//        [D_DText11 setFrame:CGRectMake(129, (_lblBasis4.frame.origin.y + (25*(t+1)))+(t*48), 180, 15)];
//        [D_DText11 setText:[recvText4 objectAtIndex:(t*3)]];
//        D_DText11.textColor = RGB(44, 44, 44);//[UIColor blackColor];
//        D_DText11.backgroundColor = [UIColor clearColor];
//        D_DText11.font = [UIFont systemFontOfSize:15.0f];
//        D_DText11.tag = t;
//        [_infoView addSubview:D_DText11];
//        
//        UILabel *D_DText12 = [[UILabel alloc] init];
//        [D_DText12 setTextAlignment:UITextAlignmentRight];
//        [D_DText12 setFrame:CGRectMake(129, (_lblBasis4.frame.origin.y + (25*(t+2)))+(t*48), 180, 15)];
//        [D_DText12 setText:[recvText4 objectAtIndex:(t*3)+1]];
//        D_DText12.textColor = RGB(44, 44, 44);//[UIColor blackColor];
//        D_DText12.backgroundColor = [UIColor clearColor];
//        D_DText12.font = [UIFont systemFontOfSize:15.0f];
//        D_DText12.tag = t;
//        [_infoView addSubview:D_DText12];
//        
//        UILabel *D_DText13 = [[UILabel alloc] init];
//        [D_DText13 setTextAlignment:UITextAlignmentRight];
//        [D_DText13 setFrame:CGRectMake(129, (_lblBasis4.frame.origin.y + (25*(t+3)))+(t*48), 180, 15)];
//        [D_DText13 setText:[recvText4 objectAtIndex:(t*3)+3]];
//        D_DText13.textColor = RGB(44, 44, 44);//[UIColor blackColor];
//        D_DText13.backgroundColor = [UIColor clearColor];
//        D_DText13.font = [UIFont systemFontOfSize:15.0f];
//        D_DText13.tag = t;
//        [_infoView addSubview:D_DText13];
//    }

    // 보장보험료 라벨
//    [_lblBasis5 setFrame:CGRectMake(8, _lblBasis4.frame.origin.y + 15 + ((tempRecv4+1) * 25), 100, 15)];
    [_lblBasis5 setFrame:CGRectMake(8, tempPos + 35, 100, 15)];
    [_lblBasis6 setFrame:CGRectMake(8, _lblBasis5.frame.origin.y + 25, 100, 15)];
    [_lblBasis7 setFrame:CGRectMake(8, _lblBasis6.frame.origin.y + 25, 100, 15)];
    [_lblBasis8 setFrame:CGRectMake(8, _lblBasis7.frame.origin.y + 25, 100, 15)];
    // 보장보험료 데이터
//    [_lblBasis9 setFrame:CGRectMake(129, _lblBasis4.frame.origin.y + 15 + ((tempRecv4+1) * 25), 180, 15)];
    [_lblBasis9 setFrame:CGRectMake(129, tempPos + 35, 180, 15)];
    [_lblBasis10 setFrame:CGRectMake(129, _lblBasis9.frame.origin.y + 25, 180, 15)];
    [_lblBasis11 setFrame:CGRectMake(129, _lblBasis10.frame.origin.y + 25, 180, 15)];
    [_lblBasis12 setFrame:CGRectMake(129, _lblBasis11.frame.origin.y + 25, 180, 15)];

    _lblBasis9.text = [NSString stringWithFormat:@"%@원", [_detailData objectForKey:@"보장보험료"]];
    _lblBasis10.text = [NSString stringWithFormat:@"%@원", [_detailData objectForKey:@"적립보험료"]];
    _lblBasis11.text = [NSString stringWithFormat:@"%@원", [_detailData objectForKey:@"납입보험료"]];
    _lblBasis12.text = [NSString stringWithFormat:@"%@원", [_detailData objectForKey:@"합계보험료"]];
    
    [_infoView setFrame:CGRectMake(0, 0, 317.0f, _lblBasis8.frame.origin.y + 25)];
    
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
    
    [_infoTitleView1 release];
    [_infoTitleView2 release];
    [_infoTitleView3 release];
    [_infoTitleView4 release];
    
    [_lblData1 release];
    [_lblData2 release];
    [_lblData3 release];
    [_lblData4 release];
    
    [_lblBasis0 release];
    [_lblBasis1 release];
    [_lblBasis2 release];
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
    
    [super dealloc];
}

@end
