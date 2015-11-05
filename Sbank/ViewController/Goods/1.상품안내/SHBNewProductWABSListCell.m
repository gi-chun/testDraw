//
//  SHBNewProductWABSListCell.m
//  ShinhanBank
//
//  Created by Joon on 13. 2. 27..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBNewProductWABSListCell.h"

@implementation SHBNewProductWABSListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
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
    
    [_productClassLabel setHighlighted:highlighted];
    [_productClass setHighlighted:highlighted];
    [_numberLabel setHighlighted:highlighted];
    [_number setHighlighted:highlighted];
    [_accountStateLabel setHighlighted:highlighted];
    [_accountState setHighlighted:highlighted];
    [_arrow setHighlighted:highlighted];
    [_productLabel setHighlighted:highlighted];
    [_product setHighlighted:highlighted];
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

- (void)dealloc {
    [_productClassLabel release];
    [_productClass release];
    [_numberLabel release];
    [_number release];
    [_accountStateLabel release];
    [_accountState release];
    [_arrow release];
    [_productLabel release];
    [_product release];
    [super dealloc];
}
@end
