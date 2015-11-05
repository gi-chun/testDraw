//
//  SHBForexFavoritListCell.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexFavoritListCell.h"

@implementation SHBForexFavoritListCell

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
        [self.contentView setBackgroundColor:RGB(108, 157, 203)];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    [_arrow setHighlighted:highlighted];
    [_remittanceDateLabel setHighlighted:highlighted];
    [_remittanceDate setHighlighted:highlighted];
    [_bankNameLabel setHighlighted:highlighted];
    [_bankName setHighlighted:highlighted];
    [_accountNumberLabel setHighlighted:highlighted];
    [_accountNumber setHighlighted:highlighted];
    [_consigneeLabel setHighlighted:highlighted];
    [_consignee setHighlighted:highlighted];
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
    [_arrow release];
    [_line release];
    [_remittanceDateLabel release];
    [_remittanceDate release];
    [_bankNameLabel release];
    [_bankName release];
    [_accountNumberLabel release];
    [_accountNumber release];
    [_consigneeLabel release];
    [_consignee release];
    [super dealloc];
}
@end
