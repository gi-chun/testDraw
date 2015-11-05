//
//  SHBBancasurancePaymentListCell.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBBancasurancePaymentListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *receiptCountMon;
@property (retain, nonatomic) IBOutlet UILabel *receiptDate;
@property (retain, nonatomic) IBOutlet UILabel *realReceiptAmount;
@property (retain, nonatomic) IBOutlet UILabel *discountType;
@property (retain, nonatomic) IBOutlet UILabel *amount;

@end
