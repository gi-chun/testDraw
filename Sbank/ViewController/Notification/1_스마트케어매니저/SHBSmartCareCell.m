//
//  SHBSmartCareCell.m
//  ShinhanBank
//
//  Created by gu_mac on 2014. 2. 20..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBSmartCareCell.h"
#import "SHBNotificationService.h" // service


@implementation SHBSmartCareCell



- (void)dealloc
{

	[super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       	
		UIView *selectedView = [[[UIView alloc]initWithFrame:self.contentView.frame]autorelease];
		[selectedView setBackgroundColor:RGB(108, 157, 203)];
		[self setSelectedBackgroundView:selectedView];
		
//		UILabel *lbltype = [[[UILabel alloc]initWithFrame:CGRectMake(8, 3, 50, 7+14+7)]autorelease];
//		[lbltype setNumberOfLines:0];
//		[lbltype setBackgroundColor:[UIColor clearColor]];
//		[lbltype setTextColor:RGB(44, 44, 44)];
//		[lbltype setHighlightedTextColor:[UIColor whiteColor]];
//		[lbltype setFont:[UIFont systemFontOfSize:14]];
//		[self.contentView addSubview:lbltype];
//		self.lbltype = lbltype;
//        
        
        UILabel *lblName = [[[UILabel alloc]initWithFrame:CGRectMake(8, 3, 294, 7+14+7)]autorelease];
		[lblName setNumberOfLines:0];
		[lblName setBackgroundColor:[UIColor clearColor]];
		[lblName setTextColor:RGB(44, 44, 44)];
		[lblName setHighlightedTextColor:[UIColor whiteColor]];
		[lblName setFont:[UIFont systemFontOfSize:13.5]];
		[self.contentView addSubview:lblName];
		self.lblName = lblName;
		
		UILabel *lbldate = [[[UILabel alloc]initWithFrame:CGRectMake(8, 10+14, 294, 7+14+7)]autorelease];
		[lbldate setNumberOfLines:0];
		[lbldate setBackgroundColor:[UIColor clearColor]];
		[lbldate setTextColor:RGB(44, 44, 44)];
		[lbldate setHighlightedTextColor:[UIColor whiteColor]];
		[lbldate setFont:[UIFont systemFontOfSize:13.5]];
		[self.contentView addSubview:lbldate];
		self.lbldate = lbldate;
        
        
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
    
    
	[self.lblName setHighlighted:highlighted];
	[self.lbldate setHighlighted:highlighted];

}

@end
