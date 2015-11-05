//
//  SHBNoticeStoreListViewCell.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 10. 15..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBNoticeStoreListViewCell.h"

@implementation SHBNoticeStoreListViewCell

@synthesize target;
@synthesize openBtnSelector;
@synthesize row;
@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize label5;
@synthesize label6;
@synthesize label7;
@synthesize label8;
@synthesize label9;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
    
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
    [self.label9 setHighlighted:highlighted];
    
}





- (IBAction)buttonTouchUpInside:(UIButton *)sender
{
   
     NSDictionary *dic = @{ @"Index" : [NSString stringWithFormat:@"%d", row], @"Button" : sender };
    [self.target performSelector:self.openBtnSelector withObject:dic];
    
}



- (void)dealloc {
    [self.label1 release];
    [self.label2 release];
    [self.label3 release];
    [self.label4 release];
    [self.label5 release];
    [self.label6 release];
    [self.label7 release];
    [self.label8 release];
    [self.label9 release];
    [_btn1 release];
    [super dealloc];
}


@end
