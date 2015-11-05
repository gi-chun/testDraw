//
//  SHBAutoTransferListViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 11. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBAutoTransferListViewController : SHBBaseViewController
{
    int nType; // 0: 정상 9:해지
}
@property (nonatomic        ) int nType;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;
@end
