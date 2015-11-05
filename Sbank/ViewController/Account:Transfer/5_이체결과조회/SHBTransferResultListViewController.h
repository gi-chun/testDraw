//
//  SHBTransferResultListViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTransferResultListPopupView.h"

@interface SHBTransferResultListViewController : SHBBaseViewController <SHBListPopupViewDelegate>
{
    NSString *strAccountNo;
}

@property (retain, nonatomic) NSString *strAccountNo;
@property (retain, nonatomic) IBOutlet SHBButton *btnOutAccNo;
@property (retain, nonatomic) IBOutlet UILabel *lblInqueryTrem;
@property (retain, nonatomic) IBOutlet UITableView *tableView1;
@property (retain, nonatomic) IBOutlet UIView *tableFooterView;
@property (retain, nonatomic) IBOutlet UIButton *btnSort;
- (IBAction)buttonTouchupInside:(UIButton *)sender;
@end
