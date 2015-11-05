//
//  SHBNoticeSmartCardListViewCell.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 11..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNoticeSmartCardListViewCell.h"

@interface SHBNoticeSmartCardListViewCell ()

@end

@implementation SHBNoticeSmartCardListViewCell


#pragma mark -
#pragma mark Synthesize

@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize label5;
@synthesize imageView1;     // new icon


#pragma mark -
#pragma mark Xcode Generate

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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
    [self.label2 setHighlighted:highlighted];
    [self.label3 setHighlighted:highlighted];
    [self.label4 setHighlighted:highlighted];
    [self.label5 setHighlighted:highlighted];
}

- (void)dealloc
{
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    self.label5 = nil;
    self.imageView1 = nil;  // new icon
    
    [super dealloc];
}


@end
