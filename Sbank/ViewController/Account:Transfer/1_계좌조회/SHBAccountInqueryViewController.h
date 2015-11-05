//
//  SHBAccountInqueryViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 16.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"
#import "SHBScrollLabel.h"

@interface SHBAccountInqueryViewController : SHBBaseViewController
{
    SHBAccountService *service;
    NSDictionary *accountInfo;
}
@property (nonatomic, retain) SHBAccountService *service;
@property (nonatomic, assign) NSDictionary *accountInfo;
@property (retain, nonatomic) IBOutlet UILabel *lblData02;
@property (retain, nonatomic) IBOutlet UILabel *lblData03;
@property (retain, nonatomic) IBOutlet UIButton *btnTransfer;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;
@property (retain, nonatomic) IBOutlet UIView *tableHeaderView;
@property (retain, nonatomic) IBOutlet UIView *tableFooterView;
@property (retain, nonatomic) IBOutlet UIView *accoutInfoView;
@property (retain, nonatomic) IBOutlet UIView *termSelectView;
@property (retain, nonatomic) IBOutlet UIButton *btnShowDetail;
@property (retain, nonatomic) IBOutlet UIButton *btnSort;
@property (retain, nonatomic) IBOutlet UIButton *btnDealType;
@property (retain, nonatomic) IBOutlet UIButton *btnBalance;
@property (retain, nonatomic) IBOutlet UIButton *btnWidget;
@property (retain, nonatomic) IBOutlet UILabel *lblNoData;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblTitle;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
