//
//  SHBProductMenualListCell.m
//  ShinhanBank
//
//  Created by Joon on 2014. 8. 11..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBProductMenualListCell.h"

@implementation SHBProductMenualListCell

- (void)awakeFromNib
{
    // Initialization code
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
    
    for (UIView *view in [self.contentView subviews]) {
        
        if ([view isKindOfClass:[UILabel class]]) {
            
            [(UILabel *)view setHighlighted:highlighted];
        }
        
        if ([view isKindOfClass:[UIImageView class]]) {
            
            [(UIImageView *)view setHighlighted:highlighted];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
