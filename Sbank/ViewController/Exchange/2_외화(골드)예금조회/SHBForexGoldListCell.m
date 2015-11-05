//
//  SHBForexGoldListCell.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBForexGoldListCell.h"

@implementation SHBForexGoldListCell

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
        if ([_moreBtn isSelected]) {
            [self.contentView setBackgroundColor:[UIColor whiteColor]];
        }
        else {
            [self.contentView setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    [_accountName setHighlighted:highlighted];
    [_accountNumber setHighlighted:highlighted];
    [_money setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)buttonTouchUpInside:(UIButton *)sender
{
    NSDictionary *dic = @{ @"Index" : [NSString stringWithFormat:@"%d", _row], @"Button" : sender };
    
    [self.pTarget performSelector:self.pSelector withObject:dic];
}

- (void)dealloc
{
    [_moreBtn release];
    [_btn1 release];
    [_btn2 release];
    [_btn3 release];
    [_btn4 release];
    [_line release];
    [_accountName release];
    [_accountNumber release];
    [_money release];
    [super dealloc];
}

@end
