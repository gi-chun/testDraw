//
//  SHBForexDetailListViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

/**
 외환/골드 - 외화골드예금조회
 외화예금조회 화면
 */

@interface SHBForexDetailListViewController : SHBBaseViewController
<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSMutableDictionary *accountInfo; // 계좌정보
@property (assign, nonatomic) BOOL isAllAccountList; // 전체계좌 조회에서 들어올 경우

@property (retain, nonatomic) IBOutlet UIView *infoView; // 상단정보 view
@property (retain, nonatomic) IBOutlet UITableView *dataTable; // 거래내역
@property (retain, nonatomic) IBOutlet UIView *orderView; // 거래내역정렬 view
@property (retain, nonatomic) IBOutlet UIView *tableHeaderView; // 상단정보 + 거래내역정렬 view
@property (retain, nonatomic) IBOutlet UIView *autoLabelView; // 자동재예치, 만기자동해지 view
@property (retain, nonatomic) IBOutlet UILabel *orderInfo; // 최근거래내역 x건이 조회되었습니다.
@property (retain, nonatomic) IBOutlet SHBButton *orderStandard; // 조회기준
@property (retain, nonatomic) IBOutlet SHBButton *headerBtn1;
@property (retain, nonatomic) IBOutlet SHBButton *headerBtn2;
@property (retain, nonatomic) IBOutlet SHBButton *headerBtn3;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *accountName; // 계좌명
@property (retain, nonatomic) IBOutlet SHBButton *arrow;
@property (retain, nonatomic) IBOutlet UILabel *orderStandardLabel; // 조회기간
@property (retain, nonatomic) IBOutlet UIView *moreView; // 더보기

@end
