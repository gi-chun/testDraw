//
//  SHBBancasurancePaymentListViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBDateField.h"
#import "SHBScrollLabel.h"

@interface SHBBancasurancePaymentListViewController : SHBBaseViewController <SHBDateFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSDictionary *detailData;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *bancaTickerName; // 계좌명

@property (retain, nonatomic) IBOutlet UILabel *lblBacTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblData1;
@property (retain, nonatomic) IBOutlet UILabel *lblData2;
@property (retain, nonatomic) IBOutlet UILabel *lblData3;
@property (retain, nonatomic) IBOutlet UILabel *lblData4;
@property (retain, nonatomic) IBOutlet UILabel *lblData5;
@property (retain, nonatomic) IBOutlet UILabel *lblData6;
@property (retain, nonatomic) IBOutlet UILabel *lblData7;
@property (retain, nonatomic) IBOutlet UILabel *lblData8;
@property (retain, nonatomic) IBOutlet UILabel *lblData9;
@property (retain, nonatomic) IBOutlet UILabel *lblData10;
@property (retain, nonatomic) IBOutlet UILabel *lblData11;
@property (retain, nonatomic) IBOutlet UILabel *lblData12;
@property (retain, nonatomic) IBOutlet UILabel *lblData13;
@property (retain, nonatomic) IBOutlet UILabel *lblData14;
@property (retain, nonatomic) IBOutlet UILabel *lblData15;
@property (retain, nonatomic) IBOutlet UILabel *lblData16;

@property (retain, nonatomic) IBOutlet SHBDateField *dateField; // 조회기준일

@property (retain, nonatomic) IBOutlet UIButton *btnDetailInfo;
@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UIView *tableTopSubView;
@property (retain, nonatomic) IBOutlet UIView *bacInfoView;
//@property (retain, nonatomic) IBOutlet UIView *lineView;
@property (retain, nonatomic) IBOutlet UIView *termSelectView;
@property (nonatomic, retain) IBOutlet UILabel *recordCountLabel;

@property (nonatomic, retain) IBOutlet UITableView *bacAccountListTable;
@property (retain, nonatomic) IBOutlet UIButton *btnSort;

@end
