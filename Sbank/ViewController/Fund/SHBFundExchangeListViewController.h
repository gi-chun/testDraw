//
//  SHBFundExchangeListViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 1..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBFundExchangeListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet NSString *accountNo;
@property (nonatomic, retain) IBOutlet NSString *accountName;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 계좌명

@property (retain, nonatomic) IBOutlet UITableView *fundExchangeListTable;

@property (nonatomic, retain) IBOutlet UILabel *accountNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *accountNoLabel;
@property (nonatomic, retain) IBOutlet UILabel *recordCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *currentDateLabel;

@end
