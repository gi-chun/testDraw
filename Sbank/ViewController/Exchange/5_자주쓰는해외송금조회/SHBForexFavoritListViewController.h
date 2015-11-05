//
//  SHBForexFavoritListViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 외환/골드 - 자주쓰는 해외송금/조회
 자주쓰는 해외송금 목록 화면
 */

@interface SHBForexFavoritListViewController : SHBBaseViewController
<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *dataTable;

@end
