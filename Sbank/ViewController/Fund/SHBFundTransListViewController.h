//
//  SHBFundTransListViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccount.h"
#import "SHBScrollingTicker.h"
#import "SHBScrollLabel.h"

@interface SHBFundTransListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *accountInfo;
}
/**
 상세리스트 테이블뷰
 */
@property (nonatomic, retain) NSMutableDictionary *dicDataDictionary;
@property (nonatomic, retain) NSDictionary *accountInfo;
//@property (nonatomic, retain) SHBAccount *account;
//@property (nonatomic, retain) IBOutlet NSString *fundCode;

//@property (retain, nonatomic) IBOutlet SHBScrollingTicker *fundTickerName; // 계좌명
@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 계좌명

@property (nonatomic, retain) IBOutlet UITableView *fundTransListTable;
@property (nonatomic, retain) IBOutlet UILabel *accountNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *accountNoLabel;
@property (nonatomic, retain) IBOutlet UILabel *issueDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *balanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *availableBalanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *recordCountLabel;
@property (nonatomic, retain) SHBDataSet *previousData;

@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UIView *tableTopSubView;
@property (retain, nonatomic) IBOutlet UIView *fundInfoView;
@property (retain, nonatomic) IBOutlet UIView *lineView;
@property (retain, nonatomic) IBOutlet UIView *termSelectView;

@property (retain, nonatomic) IBOutlet UIButton *btnSort;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
