//
//  SHBCloseProductInfoCell.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCloseProductInfoCell.h"

@implementation SHBCloseProductInfoCell

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
		
		UILabel *lblName = [[[UILabel alloc]initWithFrame:CGRectMake(8, 3, 294, 7+14+7)]autorelease];
		[lblName setNumberOfLines:0];
		[lblName setBackgroundColor:[UIColor clearColor]];
		[lblName setTextColor:RGB(44, 44, 44)];
		[lblName setHighlightedTextColor:[UIColor whiteColor]];
		[lblName setFont:[UIFont systemFontOfSize:15]];
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
        
        UILabel *lblMoney = [[[UILabel alloc]initWithFrame:CGRectMake(8, 10+14+20, 294, 7+14+7)]autorelease];
		[lblMoney setNumberOfLines:0];
		[lblMoney setBackgroundColor:[UIColor clearColor]];
		[lblMoney setTextColor:RGB(44, 44, 44)];
        [lblMoney setText:@"잔액"];
		[lblMoney setHighlightedTextColor:[UIColor whiteColor]];
		[lblMoney setFont:[UIFont systemFontOfSize:15]];
		[self.contentView addSubview:lblMoney];
		self.lblMoney = lblMoney;
        
        UILabel *Money = [[[UILabel alloc]initWithFrame:CGRectMake(8, 10+14+20, 280, 7+14+7)]autorelease];
		[Money setNumberOfLines:0];
		[Money setBackgroundColor:[UIColor clearColor]];
		[Money setTextColor:RGB(209, 75, 75)];
		[Money setHighlightedTextColor:[UIColor whiteColor]];
		[Money setFont:[UIFont systemFontOfSize:15]];
        [Money setTextAlignment:NSTextAlignmentRight];
		[self.contentView addSubview:Money];
		self.Money = Money;
        
        UILabel *lbldate = [[[UILabel alloc]initWithFrame:CGRectMake(8, 10+14+20+20, 294, 7+14+7)]autorelease];
		[lbldate setNumberOfLines:0];
		[lbldate setBackgroundColor:[UIColor clearColor]];
		[lbldate setTextColor:RGB(44, 44, 44)];
        [lbldate setText:@"만기일"];
		[lbldate setHighlightedTextColor:[UIColor whiteColor]];
		[lbldate setFont:[UIFont systemFontOfSize:15]];
		[self.contentView addSubview:lbldate];
		self.lbldate = lbldate;
        
        UILabel *date = [[[UILabel alloc]initWithFrame:CGRectMake(8, 10+14+20+20, 280, 7+14+7)]autorelease];
		[date setNumberOfLines:0];
		[date setBackgroundColor:[UIColor clearColor]];
		[date setTextColor:RGB(44, 44, 44)];
		[date setHighlightedTextColor:[UIColor whiteColor]];
		[date setFont:[UIFont systemFontOfSize:15]];
        [date setTextAlignment:NSTextAlignmentRight];
		[self.contentView addSubview:date];
		self.date = date;
        
        
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
	
	[self.lblName setHighlighted:highlighted];
	[self.lblAccountNo setHighlighted:highlighted];
	[self.ivAccessory setHighlighted:highlighted];
}

@end
