//
//  SHBBancasurancePaymentListCell.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBancasurancePaymentListCell.h"

@implementation SHBBancasurancePaymentListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        [self.contentView setBackgroundColor:RGB(244, 244, 244)];
    }
    else
    {
        [self.contentView setBackgroundColor:RGB(244, 239, 234)];
    }
}

- (void)dealloc {
    [_receiptCountMon release];
    [_receiptDate release];
    [_receiptCountMon release];
    [_discountType release];
    [_amount release];
    
    [super dealloc];
}

@end
