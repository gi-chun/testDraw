//
//  SHBBancasuranceDemageInfoViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 2..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"
#import "SHBScrollingTicker.h"

@interface SHBBancasuranceDemageInfoViewController : SHBBaseViewController

@property (retain, nonatomic) OFDataSet *detailData;
@property (nonatomic, retain) NSDictionary *accountInfo;
@property (nonatomic, retain) NSMutableDictionary *dicDataDictionary;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *bancaTickerName; // 계좌명
@property (retain, nonatomic) IBOutlet SHBScrollLabel *bancaDetailTickerName; //담보명

@property (retain, nonatomic) IBOutlet UIView  *infoTitleView1;          // 기본정보뷰
@property (retain, nonatomic) IBOutlet UIView  *infoTitleView2;          // 기본정보뷰
@property (retain, nonatomic) IBOutlet UIView  *infoTitleView3;          // 기본정보뷰
@property (retain, nonatomic) IBOutlet UIView  *infoTitleView4;          // 기본정보뷰

@property (retain, nonatomic) IBOutlet UILabel *lblData0;   // 주민번호
@property (retain, nonatomic) IBOutlet UILabel *lblData1;   // 보험기간
@property (retain, nonatomic) IBOutlet UILabel *lblData2;   // 납입방법
@property (retain, nonatomic) IBOutlet UILabel *lblData3;   // 최종납입회차
@property (retain, nonatomic) IBOutlet UILabel *lblData4;   // 보험료

@property (retain, nonatomic) IBOutlet UILabel *lblBasis0;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis1;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis2;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis3;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis4;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis5;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis6;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis7;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis8;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis9;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis10;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis11;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis12;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis13;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis14;
@property (retain, nonatomic) IBOutlet UILabel *lblBasis15; // 계약관계자 계약형태
@property (retain, nonatomic) IBOutlet UILabel *lblBasis16; // 계약관계자 총피보험자수 라벨
@property (retain, nonatomic) IBOutlet UILabel *lblBasis17; // 계약관계자 총피보험자수

@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;    // 기본정보뷰의 스크롤뷰
@property (retain, nonatomic) IBOutlet UIView       *infoView;          // 기본정보뷰

@property (retain, nonatomic) IBOutlet UIButton     *btnDetailAccount;  // 입금내역

@end
