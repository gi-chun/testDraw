//
//  SHBFundExchangeListCell.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 1..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFundExchangeListCell.h"

@implementation SHBFundExchangeListCell


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

    // Configure the view for the selected state
}

- (void)dealloc {
    [_amountLabel release];
    [super dealloc];
}

@end
