//
//  SHBAccountListCell.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 9.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBAccountListCell.h"

@implementation SHBAccountListCell
@synthesize target;
@synthesize pSelector;
@synthesize row;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    NSDictionary *dic = @{@"Index" : [NSString stringWithFormat:@"%d", row], @"Button" : sender};
    
    [self.target performSelector:self.pSelector withObject:dic];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected) {
        [self.contentView setBackgroundColor:RGB(244, 244, 244)];
    }
    else
    {
        [self.contentView setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self.contentView setBackgroundColor:RGB(108, 157, 203)];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    else
    {
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

- (void)dealloc {
    [_bgView release];
    [_accountName release];
    [_accountNo release];
    [_rate release];
    [_amount release];
    [_balanceCaption release];
    [_btnLeft release];
    [_btnCenter release];
    [_btnRight release];
    [_btnOpen release];
    [_imgDetail release];
    [_expiryDate release];
    [super dealloc];
}

@end
