//
//  SHBLoanAccountListViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 15..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBLoanService.h"

@interface SHBLoanAccountListViewController : SHBBaseViewController
{
    SHBLoanService *service;
}
@property (retain, nonatomic) SHBLoanService *service;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;
@property (retain, nonatomic) IBOutlet UIView *tableFooterView;
@property (retain, nonatomic) IBOutlet UILabel *lblData01;

@end
