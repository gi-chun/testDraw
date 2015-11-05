//
//  SHBForexGoldDetailListCell.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexGoldDetailListCell.h"

@implementation SHBForexGoldDetailListCell

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

- (void)dealloc
{
    [_tradeMoney release];
    [_tradeMoneyLabel release];
    [super dealloc];
}

@end
