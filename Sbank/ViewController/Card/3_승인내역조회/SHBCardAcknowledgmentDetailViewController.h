//
//  SHBCardAcknowledgmentDetailViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 신한카드 - 승인내역조회
 승인내역조회 완료 화면
 */

@interface SHBCardAcknowledgmentDetailViewController : SHBBaseViewController
<UITableViewDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *dataTable;

@end
