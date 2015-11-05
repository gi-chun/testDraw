//
//  SHBSmartNewListCell.m
//  ShinhanBank
//
//  Created by Joon on 13. 11. 1..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBSmartNewListCell.h"

@implementation SHBSmartNewListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
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
    [_view01 release];
    [super dealloc];
}

@end
