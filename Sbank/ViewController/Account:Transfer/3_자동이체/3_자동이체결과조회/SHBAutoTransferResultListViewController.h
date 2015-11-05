//
//  SHBAutoTransferResultListViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"

@interface SHBAutoTransferResultListViewController : SHBBaseViewController
{
    SHBAccountService *service;
}
@property (nonatomic, retain) SHBAccountService *service;
@property (retain, nonatomic) IBOutlet UILabel *lblAccountNo;
@property (retain, nonatomic) IBOutlet UILabel *lblInqueryTerm;
@property (retain, nonatomic) IBOutlet UIButton *btnSort;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
