//
//  SHBNewProductWABSListViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 2. 27..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBNewProductWABSListViewController : SHBBaseViewController <UITableViewDelegate>

@property (retain, nonatomic) NSMutableDictionary *dicSelectedData;
@property (retain, nonatomic) IBOutlet UITableView *dataTable;

@end
