//
//  SHBNoticeSmartNewCell.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 24..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBNoticeSmartNewCell.h"

@implementation SHBNoticeSmartNewCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [_noticeTitle release];
    [_noticeMessage release];
    [_arrowBtn release];
    [super dealloc];
}

@end
