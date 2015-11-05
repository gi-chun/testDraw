//
//  SHBBancasuranceBaseInfoViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
//#import "SHBScrollingTicker.h"
#import "SHBScrollLabel.h"

@interface SHBBancasuranceBaseInfoViewController : SHBBaseViewController

@property (retain, nonatomic) OFDataSet *detailData;
@property (nonatomic, retain) NSDictionary *accountInfo;
@property (nonatomic, retain) NSMutableDictionary *dicDataDictionary;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *bancaTickerName; // 계좌명
@property (retain, nonatomic) IBOutlet SHBScrollLabel *bancaDetailTickerName; //담보명

@property (retain, nonatomic) IBOutlet UILabel *lblBasis0;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis1;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis2;  // 보험기간
@property (retain, nonatomic) IBOutlet UILabel *lblBasis3;  // 납입방법/기간
@property (retain, nonatomic) IBOutlet UILabel *lblBasis4;  // 최종납입월
@property (retain, nonatomic) IBOutlet UILabel *lblBasis5;  // 최종납입회차
@property (retain, nonatomic) IBOutlet UILabel *lblBasis6;  // 계약일자
@property (retain, nonatomic) IBOutlet UILabel *lblBasis7;  // 보험료
@property (retain, nonatomic) IBOutlet UILabel *lblBasis8;  // 이체희망일
@property (retain, nonatomic) IBOutlet UILabel *lblBasis9;  // 주민번호
@property (retain, nonatomic) IBOutlet UILabel *lblBasis10;  // 주피보험자주민번호
@property (retain, nonatomic) IBOutlet UILabel *lblBasis11;  // 종피보험자주민번호
@property (retain, nonatomic) IBOutlet UILabel *lblBasis12;  // 만기시수익자주민번호
@property (retain, nonatomic) IBOutlet UILabel *lblBasis13;  // 상해시수익자주민번호
@property (retain, nonatomic) IBOutlet UILabel *lblBasis14;  // 사망시수익자1주민번호
@property (retain, nonatomic) IBOutlet UILabel *lblBasis15;  // 사망시수익자2주민번호
@property (retain, nonatomic) IBOutlet UILabel *lblBasis16;  // 사망시수익자3주민번호
@property (retain, nonatomic) IBOutlet UILabel *lblBasis17;  // 연금개시연령
@property (retain, nonatomic) IBOutlet UILabel *lblBasis18;  // 사망시수익자지급율1
@property (retain, nonatomic) IBOutlet UILabel *lblBasis19;  // 사망시수익자지급율2
@property (retain, nonatomic) IBOutlet UILabel *lblBasis20;  // 사망시수익자지급율3
@property (retain, nonatomic) IBOutlet UILabel *lblBasis21;  // 지급기간
@property (retain, nonatomic) IBOutlet UILabel *lblBasis22;  // 총납입보험료

@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;    // 기본정보뷰의 스크롤뷰
@property (retain, nonatomic) IBOutlet UIView       *infoView;          // 기본정보뷰

@property (retain, nonatomic) IBOutlet UIButton     *btnDetailAccount;  // 입금내역

@end
