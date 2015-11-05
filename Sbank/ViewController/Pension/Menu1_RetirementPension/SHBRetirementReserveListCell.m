//
//  SHBRetirementReserveListCell.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBRetirementReserveListCell.h"


@implementation SHBRetirementReserveListCell

#pragma mark -
#pragma mark Synthesize

@synthesize button1;
@synthesize cellButtonActionDelegate;

@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize label5;


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
    
    if (highlighted)
    {
        [self.contentView setBackgroundColor:RGB(108, 157, 203)];
    }
    else
    {
        if ( self.selected )
        {
            [self.contentView setBackgroundColor:[UIColor whiteColor]];
        }
        else
        {
            [self.contentView setBackgroundColor:[UIColor clearColor]];
        }
    
    }
    
    for (UIView *subViews in self.contentView.subviews)
    {
        if ([subViews isKindOfClass:[UILabel class]])
        {
            [(UILabel*)subViews setHighlighted:highlighted];
        }
    }
}

- (IBAction)buttonDidPush:(id)sender
{
    switch ([sender tag]) {
            
        case 11:        // 펼치기
        {
            [cellButtonActionDelegate cellButtonActionisOpen:self.row];
        }
            break;
            
        case 21:        // 상세보기, 입금 버튼
        case 22:
        {
            [cellButtonActionDelegate cellButtonAction:[sender tag]];
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    self.button1 = nil;
    
    self.label1 = nil;
    self.label2 = nil;
    self.label3 = nil;
    self.label4 = nil;
    self.label5 = nil;
    
    [super dealloc];
}

@end
