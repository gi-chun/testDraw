//
//  SHBTransferResultCell.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 9.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBTransferResultCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lblTranDateTime;
@property (retain, nonatomic) IBOutlet UILabel *lblState;
@property (retain, nonatomic) IBOutlet UILabel *lblRecvName;
@property (retain, nonatomic) IBOutlet UILabel *lblTranAmount;

@end
