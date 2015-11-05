//
//  SHBCardPointListViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 신한카드 - 포인트 조회
 포인트 조회 화면
 */

@interface SHBCardPointListViewController : SHBBaseViewController
<UITableViewDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *dataTable;

@end