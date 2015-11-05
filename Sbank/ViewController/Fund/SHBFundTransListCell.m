//
//  SHBFundTransListCell.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 17..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBFundTransListCell.h"

@interface SHBFundTransListCell ()

@end

@implementation SHBFundTransListCell

@synthesize target;
@synthesize openBtnSelector;

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
//    if(sender == _btnOpen)
//    {
//        [self.target performSelector:self.openBtnSelector withObject:(id)row];
//    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self.contentView setBackgroundColor:RGB(108, 157, 203)];
    }
    else
    {
        if ( self.selected )
        {
            [self.contentView setBackgroundColor:[UIColor whiteColor]];
        }
        else
        {
            [self.contentView setBackgroundColor:[UIColor clearColor]];  //RGB(244, 239, 233)];
        }
    }
    [_transDateLabel setHighlighted:highlighted];
    [_transTitleLabel setHighlighted:highlighted];
    [_transMoneyLabel setHighlighted:highlighted];
    [_accountMoneyLabel setHighlighted:highlighted];
    [_acountCountLabel setHighlighted:highlighted];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if(selected)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];  //RGB(244, 244, 244)];
    }
    else
    {
        [self.contentView setBackgroundColor:RGB(244, 239, 234)];
    }
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [_transDateLabel release];
    [_transTitleLabel release];
    [_transMoneyLabel release];
    [_accountMoneyLabel release];
    [_acountCountLabel release];
    [_btnOpen release];
    [_imgOpen release];
    [super dealloc];
}

@end
