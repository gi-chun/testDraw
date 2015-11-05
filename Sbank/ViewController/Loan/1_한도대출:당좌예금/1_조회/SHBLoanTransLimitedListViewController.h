//
//  SHBLoanTransLimitedListViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 16..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBLoanService.h"
#import "SHBScrollLabel.h"

@interface SHBLoanTransLimitedListViewController : SHBBaseViewController
{
    SHBLoanService *service;
    NSDictionary *accountInfo;
}
@property (nonatomic, retain) SHBLoanService *service;
@property (nonatomic, assign) NSDictionary *accountInfo;
@property (retain, nonatomic) IBOutlet UILabel *lblData02;
@property (retain, nonatomic) IBOutlet UILabel *lblData03;

@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblAccountInfoL1120;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblAccountInfoD1170;

@property (retain, nonatomic) IBOutlet UIButton *btnInterest;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;
@property (retain, nonatomic) IBOutlet UIView *tableHeaderView;
@property (retain, nonatomic) IBOutlet UIView *tableFooterView;
@property (retain, nonatomic) IBOutlet UIView *accountInfoL1120View;
@property (retain, nonatomic) IBOutlet UIView *accountInfoD1170View;
@property (retain, nonatomic) IBOutlet UIView *lineView;
@property (retain, nonatomic) IBOutlet UIView *termSelectView;
@property (retain, nonatomic) IBOutlet UIButton *btnSort;
@property (retain, nonatomic) IBOutlet UIButton *btnDealType;
@property (retain, nonatomic) IBOutlet UILabel *lblNoData;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblTitle;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
