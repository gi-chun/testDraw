//
//  SHBAccountListViewController.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"

@interface SHBAccountListViewController : SHBBaseViewController
{
    SHBAccountService *service;
}
@property (retain, nonatomic) SHBAccountService *service;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;

@end
