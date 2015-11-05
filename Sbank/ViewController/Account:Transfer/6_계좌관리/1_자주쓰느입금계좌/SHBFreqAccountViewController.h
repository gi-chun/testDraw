//
//  SHBFreqAccountViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"

@interface SHBFreqAccountViewController : SHBBaseViewController
{
    SHBAccountService *service;
}
@property (retain, nonatomic) SHBAccountService *service;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;

@end
