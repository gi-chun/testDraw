//
//  SHBSurchargeListCell.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBSurchargeListCell.h"

@implementation SHBSurchargeListCell

#pragma mark -
#pragma mark Synthesize

@synthesize label1;         // 연금 이름
@synthesize label2;         // 계좌 번호

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
}

- (void)dealloc
{
    self.label1 = nil;      // 연금 이름
    self.label2 = nil;      // 계좌 번호
    
    [super dealloc];
}

@end
