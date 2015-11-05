//
//  SHBFreqTransferListCell.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 11.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBCellActionProtocol.h"

@interface SHBFreqTransferListCell : UITableViewCell
@property (nonatomic, assign) id <SHBCellActionProtocol> cellButtonActionDelegate;         // buttonPushDelegate

@property (nonatomic        ) int row;

@property (retain, nonatomic) IBOutlet UILabel *accountNickName;
@property (retain, nonatomic) IBOutlet UILabel *amount;
@property (retain, nonatomic) IBOutlet UILabel *outAccountNo;
@property (retain, nonatomic) IBOutlet UILabel *bankName;
@property (retain, nonatomic) IBOutlet UILabel *inAccountNo;
@property (retain, nonatomic) IBOutlet UIButton *widgetBtn;

@end
