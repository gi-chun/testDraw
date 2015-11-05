//
//  SHBCardTrafficListViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 신한카드 - 교통카드 내역조회
 교통카드 내역조회 완료 화면
 */

@interface SHBCardTrafficListViewController : SHBBaseViewController
<UITableViewDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *dataTable;

@end
