//
//  SHBLoanBizNoVisitResultViewCell.m
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanBizNoVisitResultViewCell.h"

@implementation SHBLoanBizNoVisitResultViewCell

- (void)awakeFromNib
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self.contentView setBackgroundColor:RGB(108, 157, 203)];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)dealloc
{
    [_productName release];
    [_infoBtn release];
    [super dealloc];
}

@end
