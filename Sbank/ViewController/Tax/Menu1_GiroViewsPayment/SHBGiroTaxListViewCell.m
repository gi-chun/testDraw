//
//  SHBGiroTaxListViewCell.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 10..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBGiroTaxListViewCell.h"

@implementation SHBGiroTaxListViewCell


- (void)dealloc
{
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
}

@end
