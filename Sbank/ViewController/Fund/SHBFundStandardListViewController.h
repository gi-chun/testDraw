//
//  SHBFundStandardListViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccount.h"
#import "SHBScrollLabel.h"

@interface SHBFundStandardListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) SHBAccount *account;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 계좌명

@property (retain, nonatomic) IBOutlet UIView *titleView;
@property (retain, nonatomic) IBOutlet UITableView *fundStandardListTable;
@property (nonatomic, retain) IBOutlet NSString *accountNo;
@property (nonatomic, retain) IBOutlet NSString *accountName;
@property (nonatomic, retain) IBOutlet NSString *fundCode;
@property (nonatomic, retain) IBOutlet UILabel *accountNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *accountNoLabel;

@end
