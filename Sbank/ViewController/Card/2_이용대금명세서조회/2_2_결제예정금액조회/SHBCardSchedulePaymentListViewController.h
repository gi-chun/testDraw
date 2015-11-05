//
//  SHBCardSchedulePaymentListViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 신한카드 - 이용대금 명세서 조회 - 결제 예정금액 조회
 결제 예정금액 조회 화면
 */

@interface SHBCardSchedulePaymentListViewController : SHBBaseViewController
<UITableViewDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@end
