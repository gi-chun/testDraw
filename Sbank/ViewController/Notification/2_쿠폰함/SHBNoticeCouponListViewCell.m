//
//  SHBNoticeCouponListViewCell.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 28..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBNoticeCouponListViewCell.h"


@implementation SHBNoticeCouponListViewCell

#pragma mark -
#pragma mark Synthesize

@synthesize label1;         // 제목
@synthesize label2;         // 환전우대율
@synthesize label3;         // 유효기간
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
}

- (void)dealloc
{
    self.label1 = nil;      // 제목
    self.label2 = nil;      // 환전우대율
    self.label3 = nil;      // 유효기간
    self.imageView1 = nil;  // new icon
    
    [super dealloc];
}


@end
