//
//  SHBAccountFundListCell.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccountFundListCell.h"

@implementation SHBAccountFundListCell
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [_bgView release];
    [_accountName release];
    [_accountNo release];
    [_rate release];
    [_amount release];
    [_btnLeft release];
    [_btnCenter release];
    [_btnRight release];
    [_btnOpen release];
    [super dealloc];
}

@end
