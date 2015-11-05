//
//  SHBSmartNewListCell2.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 24..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSmartNewListCell2.h"

@implementation SHBSmartNewListCell2

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
    [_smartNewTitle release];
    [_smartNewView release];
    [_arrowBtn release];
    [_view01 release];
    [_view02 release];
    [super dealloc];
}

@end
