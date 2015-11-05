//
//  SHBReservRegListViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"
@interface SHBReservRegListViewController : SHBBaseViewController
{
    SHBAccountService *service;
}
@property (retain, nonatomic) SHBAccountService *service;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;

@end
