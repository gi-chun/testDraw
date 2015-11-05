//
//  SHBNoticeSmartLetterListCell.m
//  ShinhanBank
//
//  Created by Joon on 12. 12. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNoticeSmartLetterListCell.h"

@implementation SHBNoticeSmartLetterListCell

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
        if ([self tag] == 100) {
            [self.contentView setBackgroundColor:[UIColor clearColor]];
        }
        else {
            [self.contentView setBackgroundColor:[UIColor clearColor]];
        }
    }
    
    [_arrow setHighlighted:highlighted];
    [_branch setHighlighted:highlighted];
    [_subject setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)dealloc {
    [_subject release];
    [_readImage release];
    [_arrow release];
    [_branch release];
    [_edit release];
    [_dataView release];
    [super dealloc];
}
@end
