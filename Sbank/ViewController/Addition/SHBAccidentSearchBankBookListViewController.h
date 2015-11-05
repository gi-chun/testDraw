//
//  SHBAccidentSearchBankBookListViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBAccidentSearchBankBookListViewController : SHBBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (retain, nonatomic) NSArray *listData;
//@property (retain, nonatomic) IBOutlet UITableView *bankBookListTable;

@end
