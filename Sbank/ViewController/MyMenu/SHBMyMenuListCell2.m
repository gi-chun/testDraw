//
//  SHBMyMenuListCell2.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBMyMenuListCell2.h"

@implementation SHBMyMenuListCell2

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
    
    [_label1 setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self.contentView setBackgroundColor:[UIColor clearColor]];
}

- (void)dealloc
{
    [_label1 release];
    [super dealloc];
}

@end
