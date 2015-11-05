//
//  SHBSelfDistricTaxListCell.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 17..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBSelfDistricTaxListCell.h"

@implementation SHBSelfDistricTaxListCell

#pragma mark -
#pragma mark Synthesize

@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize label5;


#pragma mark -
#pragma mark Xcode Generate

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
    
    for (UIView *subViews in self.contentView.subviews)
    {
        if ([subViews isKindOfClass:[UILabel class]])
        {
            [(UILabel*)subViews setHighlighted:highlighted];
        }
    }
}

- (void)dealloc
{
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    self.label5 = nil;
    
    [super dealloc];
}

@end
