//
//  SHBSurchargeListViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBPopupView.h"                    // popupView


@interface SHBSurchargeListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, SHBPopupViewDelegate>
{
    IBOutlet UITableView        *tableView1;
    IBOutlet UIView             *viewPopup;         // popup View
    
    IBOutlet UIButton           *buttonCheck;       // 체크박스 버튼
    
    NSMutableArray              *arrayDataArray;    // 실제 표시될 array
    
    int     intSelectedRow;
}

@end
