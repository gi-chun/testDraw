//
//  SHBRetirementReserveListViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBCellActionProtocol.h"           // cell에서 발생하는 event를 받기 위한 protocol
#import "SHBPopupView.h"                    // popupView


@interface SHBRetirementReserveListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, SHBCellActionProtocol, SHBPopupViewDelegate>
{
    IBOutlet UITableView        *tableView1;
    IBOutlet UIView             *viewPopup;
    
    IBOutlet UIButton           *buttonCheck;       // 체크박스 버튼
    
    int     intSelectedRow;
}

- (void)cellButtonActionisOpen:(int)aRow;
- (void)cellButtonAction:(int)aTag;

@end
