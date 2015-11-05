//
//  SHBNoticeSmartNewViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 24..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBNoticeSmartNewViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@property (retain, nonatomic) IBOutlet UIView *noDataView;
@end
