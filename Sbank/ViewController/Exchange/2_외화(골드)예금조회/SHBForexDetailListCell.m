//
//  SHBForexDetailListCell.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexDetailListCell.h"

@implementation SHBForexDetailListCell

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

    [_inName release];
    [_inOutValueLabel release];
    [_inOutValue release];
    [_interestRateLabel release];
    [_interestRate release];
    [_cancelMoneyView release];
    [super dealloc];
}
@end
