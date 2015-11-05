//
//  SHBAccountExpiryDateListCell.m
//  ShinhanBank
//
//  Created by Joon on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBAccountExpiryDateListCell.h"

@implementation SHBAccountExpiryDateListCell

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
    [_accountName release];
    [_accountNo release];
    [_expiryDate release];
    [super dealloc];
}

@end
