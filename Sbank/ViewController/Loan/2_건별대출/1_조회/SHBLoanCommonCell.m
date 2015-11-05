//
//  SHBLoanCommonCell.m
//  ShinhanBank
//
//  Created by Joon on 2014. 10. 28..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBLoanCommonCell.h"

@implementation SHBLoanCommonCell

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
    [_transferDate release];
    [_dataView release];
    [super dealloc];
}
@end
