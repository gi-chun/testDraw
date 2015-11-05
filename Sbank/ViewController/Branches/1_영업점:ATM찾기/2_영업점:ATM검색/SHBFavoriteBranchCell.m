//
//  SHBFavoriteBranchCell.m
//  ShinhanBank
//
//  Created by 6r19ht on 13. 12. 3..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBFavoriteBranchCell.h"

@implementation SHBFavoriteBranchCell

#pragma mark -
#pragma mark init & dealloc

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.imageView1 = nil;
    
    [super dealloc];
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
        
        [self setBackgroundColor:RGB(108, 157, 203)];
    }
    else {
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    self.label1.highlighted = highlighted;
    self.label2.highlighted = highlighted;
    self.label3.highlighted = highlighted;
    self.imageView1.highlighted = highlighted;
}

@end
