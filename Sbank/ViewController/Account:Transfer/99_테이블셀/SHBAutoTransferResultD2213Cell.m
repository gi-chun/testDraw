//
//  SHBAutoTransferResultD2213Cell.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 09.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBAutoTransferResultD2213Cell.h"

@implementation SHBAutoTransferResultD2213Cell

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
    
    if(selected)
    {
        [self.contentView setBackgroundColor:RGB(244, 244, 244)];
    }
    else
    {
        [self.contentView setBackgroundColor:RGB(244, 239, 234)];
    }
}

- (void)dealloc
{
    [_lblData release];
    [super dealloc];
}

@end
