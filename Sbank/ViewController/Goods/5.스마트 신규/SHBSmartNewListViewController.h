//
//  SHBSmartNewListViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 11. 1..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBSmartNewListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) BOOL isCoupon;

@property (retain, nonatomic) IBOutlet UIView *subTitleView;
@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *noDataView;
@end
