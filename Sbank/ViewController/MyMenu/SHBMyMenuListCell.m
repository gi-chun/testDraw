//
//  SHBMyMenuListCell.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBMyMenuListCell.h"

@implementation SHBMyMenuListCell
@synthesize target;
@synthesize openBtnSelector;
@synthesize section;
@synthesize row;
@synthesize itemId;

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
        [self.delegate addItemToCart:itemId itemSection:section];
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
    
    [_label2 setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self.contentView setBackgroundColor:[UIColor clearColor]];
}

- (void)dealloc
{
    [_btnOpen release];
    [_label2 release];
    [super dealloc];
}

@end
