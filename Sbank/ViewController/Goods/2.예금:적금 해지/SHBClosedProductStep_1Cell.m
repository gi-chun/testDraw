//
//  SHBClosedProductCell.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBClosedProductStep_1Cell.h"

@implementation SHBClosedProductStep_1Cell

- (void)dealloc
{
	[_ivAccessory release];
	[_lblAccountNo release];
	[_lblName release];
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		UIImageView *ivAccessory = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 14)]autorelease];
		[ivAccessory setImage:[UIImage imageNamed:@"arrow_list_view"]];
		[ivAccessory setHighlightedImage:[UIImage imageNamed:@"arrow_list_view_focus"]];
		[self setAccessoryView:ivAccessory];
		self.ivAccessory = ivAccessory;
		
		UIView *selectedView = [[[UIView alloc]initWithFrame:self.contentView.frame]autorelease];
		[selectedView setBackgroundColor:RGB(108, 157, 203)];
		[self setSelectedBackgroundView:selectedView];
		
        
        SHBScrollLabel *lblName = [[[SHBScrollLabel alloc]initWithFrame:CGRectMake(8, 3, 294, 7+14+7)]autorelease];
        [lblName initFrame:lblName.frame colorType:RGB(44, 44, 44) fontSize:15 textAlign:0];
        [lblName.caption1 setHighlightedTextColor:[UIColor whiteColor]];
		[self.contentView addSubview:lblName];
		self.lblName = lblName;
		
		UILabel *lblAccountNo = [[[UILabel alloc]initWithFrame:CGRectMake(8, 10+14, 294, 7+14+7)]autorelease];
		[lblAccountNo setNumberOfLines:0];
		[lblAccountNo setBackgroundColor:[UIColor clearColor]];
		[lblAccountNo setTextColor:RGB(44, 44, 44)];
		[lblAccountNo setHighlightedTextColor:[UIColor whiteColor]];
		[lblAccountNo setFont:[UIFont systemFontOfSize:15]];
		[self.contentView addSubview:lblAccountNo];
		self.lblAccountNo = lblAccountNo;
        
        
        UILabel *endname = [[[UILabel alloc]initWithFrame:CGRectMake(8, 31+14, 294, 7+14+7)]autorelease];
		[endname setNumberOfLines:0];
		[endname setBackgroundColor:[UIColor clearColor]];
		[endname setTextColor:RGB(44, 44, 44)];
		[endname setHighlightedTextColor:[UIColor whiteColor]];
		[endname setFont:[UIFont systemFontOfSize:15]];
        [endname setTextAlignment:UITextAlignmentLeft];
        [endname setText:@"해지일"];
		[self.contentView addSubview:endname];
		//self.endDate = endDate;
        
        
        UILabel *endDate = [[[UILabel alloc]initWithFrame:CGRectMake(8, 31+14, 280, 7+14+7)]autorelease];
		[endDate setNumberOfLines:0];
		[endDate setBackgroundColor:[UIColor clearColor]];
		[endDate setTextColor:RGB(44, 44, 44)];
		[endDate setHighlightedTextColor:[UIColor whiteColor]];
		[endDate setFont:[UIFont systemFontOfSize:15]];
        [endDate setTextAlignment:UITextAlignmentRight];
		[self.contentView addSubview:endDate];
		self.endDate = endDate;
        
       
        
        UILabel *startname = [[[UILabel alloc]initWithFrame:CGRectMake(8, 53+14, 294, 7+14+7)]autorelease];
		[startname setNumberOfLines:0];
		[startname setBackgroundColor:[UIColor clearColor]];
		[startname setTextColor:RGB(44, 44, 44)];
		[startname setHighlightedTextColor:[UIColor whiteColor]];
		[startname setFont:[UIFont systemFontOfSize:15]];
        [startname setTextAlignment:UITextAlignmentLeft];
        [startname setText:@"신규일"];
		[self.contentView addSubview:startname];
		//self.startDate = startDate;
        
        
        UILabel *startDate = [[[UILabel alloc]initWithFrame:CGRectMake(8, 53+14, 280, 7+14+7)]autorelease];
		[startDate setNumberOfLines:0];
		[startDate setBackgroundColor:[UIColor clearColor]];
		[startDate setTextColor:RGB(44, 44, 44)];
		[startDate setHighlightedTextColor:[UIColor whiteColor]];
		[startDate setFont:[UIFont systemFontOfSize:15]];
        [startDate setTextAlignment:UITextAlignmentRight];
		[self.contentView addSubview:startDate];
		self.startDate = startDate;
        
        

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
	
    [self.lblName.caption1 setHighlighted:highlighted];
	[self.lblAccountNo setHighlighted:highlighted];
	[self.ivAccessory setHighlighted:highlighted];
}


@end
