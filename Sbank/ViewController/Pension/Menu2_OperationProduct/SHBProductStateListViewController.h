//
//  SHBProductStateListViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBProductStateListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView        *tableView1;
    
    NSMutableArray              *arrayDataArray;    // 실제 표시될 array
    
    int         intRow;           // 선택된 row
}

@end
