//
//  SHBFundTransCompleteYViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBFundTransCompleteYViewController : SHBBaseViewController

@property (nonatomic, retain) NSMutableDictionary *dicDataDictionary;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 편드명

@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;    // 기본정보뷰의 스크롤뷰
@property (retain, nonatomic) IBOutlet UIView       *infoView;          // 기본정보뷰

@property (nonatomic, retain) IBOutlet UILabel *basicLabel01;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel02;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel03;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel04;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel05;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel06;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel07;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel08;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel09;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel10;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel11;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel12;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel13;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel14;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel15;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel16;
@property (nonatomic, retain) IBOutlet UILabel *commentLabel1;
@property (nonatomic, retain) IBOutlet UILabel *commentLabel2;
@property (nonatomic, retain) IBOutlet UILabel *commentLabel3;

@property (retain, nonatomic) IBOutlet UIView  *lineView1;          // 라인1
@property (retain, nonatomic) IBOutlet UIView  *lineView2;          // 라인2

@property (nonatomic, retain) IBOutlet UIButton *completeBtn;

@end
