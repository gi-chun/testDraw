//
//  SHBExchangePopupNoMoreCell.m
//  ShinhanBank
//
//  Created by Joon on 12. 12. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBExchangePopupNoMoreCell.h"

@implementation SHBExchangePopupNoMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)dealloc
{
    [_nameLabel release];
    [super dealloc];
}

@end
