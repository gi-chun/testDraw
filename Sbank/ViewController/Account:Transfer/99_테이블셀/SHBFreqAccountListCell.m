//
//  SHBFreqAccountListCell.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBFreqAccountListCell.h"

@implementation SHBFreqAccountListCell
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
    if(sender == _btnOpen)
    {
        [self.target performSelector:self.openBtnSelector withObject:(id)row];
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
    
//    if (selected) {
//        [self.contentView setBackgroundColor:[UIColor whiteColor]];
//    }
//    else {
//        [self.contentView setBackgroundColor:[UIColor clearColor]];
//    }
}

- (void)dealloc
{
    [_btnOpen release];
    [super dealloc];
}

@end
