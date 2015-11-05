//
//  SHBNotiListViewCell.m
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNotiListViewCell.h"

@implementation SHBNotiListViewCell
@synthesize label1;
@synthesize noti_seq;
@synthesize lineView;

- (void)dealloc
{
    [lineView release];
    [noti_seq release];
    [label1 release];
    [super dealloc];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    
    [self.label1 setHighlighted:highlighted];
    
}
@end
