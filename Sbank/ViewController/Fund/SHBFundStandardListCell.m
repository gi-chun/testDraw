//
//  SHBFundStandardListCell.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 17..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBFundStandardListCell.h"

@implementation SHBFundStandardListCell

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
    
}

- (void)dealloc {
    [_dateLabel release];
    [_basicMoneyLabel release];
    [_variationsLabel release];
    [super dealloc];
}

@end
