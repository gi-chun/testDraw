//
//  SHBMyMenuSetupListViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBMyMenuListCell.h"

@interface SHBMyMenuSetupListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, SHBMyMenuListCellDelegate>
{
    IBOutlet UITableView    *tableView1;
    NSMutableDictionary     *selectedCellDict;
}

@property (nonatomic, retain) NSMutableArray    *arrayTableData;
@property (nonatomic, retain) NSMutableArray	*totalSubMenuArray;
@property (nonatomic, retain) IBOutlet UILabel  *lblrecordCount;

@end
