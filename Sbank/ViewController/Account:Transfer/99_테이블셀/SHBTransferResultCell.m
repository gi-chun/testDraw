//
//  SHBTransferResultCell.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 9.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBTransferResultCell.h"

@implementation SHBTransferResultCell

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

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self.contentView setBackgroundColor:RGB(108, 157, 203)];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    for (UIView *subview in self.contentView.subviews)
    {
        if([subview isKindOfClass:[UILabel class]])
        {
            ((UILabel *)subview).highlighted = highlighted;
        }
    }
}

- (void)dealloc
{
    [_lblTranDateTime release];
    [_lblState release];
    [_lblRecvName release];
    [_lblTranAmount release];

    [super dealloc];
}

@end
