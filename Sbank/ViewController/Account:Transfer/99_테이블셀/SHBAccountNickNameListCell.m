//
//  SHBAccountNickNameListCell.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccountNickNameListCell.h"

@implementation SHBAccountNickNameListCell
@synthesize target;
@synthesize openBtnSelector;
@synthesize inquiryBtnSelector;
@synthesize deleteBtnSelector;

@synthesize row;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    if(sender == _btnOpen)
    {
        [self.target performSelector:self.openBtnSelector withObject:(id)row];
    }
    else if(sender == _btnLeft)
    {
        [self.target performSelector:self.inquiryBtnSelector withObject:(id)row];
    }
    else if(sender == _btnRight)
    {
        [self.target performSelector:self.deleteBtnSelector withObject:(id)row];
    }
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if(selected)
    {
        [self.contentView setBackgroundColor:RGB(244, 244, 244)];
    }
    else
    {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)dealloc
{
    [_bgView release];
    [_accountNameLabel release];
    [_accountNoLabel release];
    [_nickNameLabel release];
    [_btnLeft release];
    [_btnOpen release];
    [_btnRight release];
    [super dealloc];
}

@end
