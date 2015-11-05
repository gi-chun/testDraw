//
//  SHBProductMenualListViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 8. 11..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBProductMenualListViewController : SHBBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@property (retain, nonatomic) IBOutlet UIView *noDataView;
@end
