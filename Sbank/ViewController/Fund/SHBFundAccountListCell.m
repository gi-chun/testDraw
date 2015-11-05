//
//  SHBFundAccountLIstCell.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBFundAccountListCell.h"

@implementation SHBFundAccountListCell

@synthesize target;
@synthesize openBtnSelector;
@synthesize leftBtnSelector;
@synthesize centerBtnSelector;
@synthesize rightBtnSelector;

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
        [self.target performSelector:self.leftBtnSelector withObject:(id)row];
    }
    else if(sender == _btnCenter)
    {
        [self.target performSelector:self.centerBtnSelector withObject:(id)row];
    }
    else if(sender == _btnRight)
    {
        [self.target performSelector:self.rightBtnSelector withObject:(id)row];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self.contentView setBackgroundColor:RGB(108, 157, 203)];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }

    [_titleLabel setHighlighted:highlighted];
    [_accountLabel setHighlighted:highlighted];
    [_rateLabel setHighlighted:highlighted];
    [_moneyLabel setHighlighted:highlighted];

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

- (void)dealloc {
    [_bgView release];
    [_titleLabel release];
    [_accountLabel release];
    [_rateLabel release];
    [_moneyLabel release];
    [_btnLeft release];
    [_btnCenter release];
    [_btnRight release];
    [_btnOpen release];
    [super dealloc];
}

@end
