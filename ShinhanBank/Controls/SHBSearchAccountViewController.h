//
//  SHBSearchAccountViewController.h
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 27..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#define NOTIFICATION_SEARCH_ACCOUNT @"searchAccount"

#import "SHBBaseViewController.h"

@interface SHBSearchAccountViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *accountTable;

@end
