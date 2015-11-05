//
//  SHBFreqTransferListViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBCellActionProtocol.h"           // cell에서 발생하는 event를 받기 위한 protocol

@interface SHBFreqTransferListViewController : SHBBaseViewController <SHBCellActionProtocol>
@property (retain, nonatomic) IBOutlet UITableView *tableView1;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
