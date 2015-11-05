//
//  SHBReservationTransferResultListViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBReservationTransferResultListViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutlet UILabel *lblInqueryTrem;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;
@property (retain, nonatomic) IBOutlet UIButton *btnSort;
- (IBAction)buttonTouchupInside:(UIButton *)sender;
@end
