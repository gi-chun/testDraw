//
//  SHBSmartNewListCell4.m
//  ShinhanBank
//
//  Created by Joon on 2014. 8. 12..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSmartNewListCell4.h"

@implementation SHBSmartNewListCell4

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [_joinBtn release];
    [_productName release];
    [_staff release];
    [_arrowBtn release];
    [super dealloc];
}

@end
