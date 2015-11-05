//
//  SHBBancasuranceListCell.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBancasuranceListCell.h"

@implementation SHBBancasuranceListCell
@synthesize target;
@synthesize pSelector;
@synthesize row;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
    NSDictionary *dic = @{@"Index" : [NSString stringWithFormat:@"%d", row], @"Button" : sender};
    
    [self.target performSelector:self.pSelector withObject:dic];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted) {
        [self.contentView setBackgroundColor:RGB(108, 157, 203)];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor clearColor]];  //RGB(244, 239, 233)];
//        if ( self.selected )
//        {
//            [self.contentView setBackgroundColor:[UIColor whiteColor]];
//        }
//        else
//        {
//            [self.contentView setBackgroundColor:[UIColor clearColor]];  //RGB(244, 239, 233)];
//        }
    }
    
    [_bacName setHighlighted:highlighted];
    [_bacNo setHighlighted:highlighted];
    [_insuranceName setHighlighted:highlighted];
    [_contractDate setHighlighted:highlighted];
    [_amount setHighlighted:highlighted];
    
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

- (void)dealloc {
    [_bgView release];
    [_bacName release];
    [_bacNo release];
    [_insuranceName release];
    [_contractDate release];
    [_amount release];
    [_btnLeft release];
    [_btnRight release];
    [_btnOpen release];
    [super dealloc];
}

@end
