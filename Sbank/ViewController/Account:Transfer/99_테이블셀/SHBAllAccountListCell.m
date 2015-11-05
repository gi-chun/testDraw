//
//  SHBAllAccountListCell.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 14..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBAllAccountListCell.h"

@implementation SHBAllAccountListCell

@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize label5;
@synthesize label6;
@synthesize label7;
@synthesize label8;


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
    
    [self.label1 setHighlighted:highlighted];
    [self.label2 setHighlighted:highlighted];
    [self.label3 setHighlighted:highlighted];
    [self.label4 setHighlighted:highlighted];
    [self.label5 setHighlighted:highlighted];
    [self.label6 setHighlighted:highlighted];
    [self.label7 setHighlighted:highlighted];
    [self.label8 setHighlighted:highlighted];
}

- (void)dealloc
{
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    self.label5 = nil;
    self.label6 = nil;
    self.label7 = nil;
    self.label8 = nil;
    
    [super dealloc];
}


@end
