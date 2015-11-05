//
//  SHBLoanBizNoVisitApplyListCell.m
//  ShinhanBank
//
//  Created by Joon on 2014. 10. 31..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitApplyListCell.h"

@implementation SHBLoanBizNoVisitApplyListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_productName release];
    [_rate release];
    [_status release];
    [super dealloc];
}
@end
