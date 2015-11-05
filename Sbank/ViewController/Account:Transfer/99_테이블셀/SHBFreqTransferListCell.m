//
//  SHBFreqTransferListCell.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 11.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBFreqTransferListCell.h"

@implementation SHBFreqTransferListCell
@synthesize row;
@synthesize cellButtonActionDelegate;
@synthesize widgetBtn;

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

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    [cellButtonActionDelegate cellButtonActionisOpen:self.row];
}

- (void)dealloc
{
    [widgetBtn release];
    [_accountNickName release];
    [_bankName release];
    [_inAccountNo release];
    [_outAccountNo release];
    [_amount release];

    [super dealloc];
}

@end
