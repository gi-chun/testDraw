//
//  SHBBranchesListViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBBranchesListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
