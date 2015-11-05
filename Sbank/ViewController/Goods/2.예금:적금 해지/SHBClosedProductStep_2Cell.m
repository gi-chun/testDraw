//
//  SHBClosedProductStep_2Cell.m
//  ShinhanBank
//
//  Created by gu_mac on 13. 12. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBClosedProductStep_2Cell.h"

@interface SHBClosedProductStep_2Cell ()

@end

@implementation SHBClosedProductStep_2Cell

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
		
        
        
        
        //거래번호
		UILabel *lblNo = [[[UILabel alloc]initWithFrame:CGRectMake(8, 3, 280, 7+14+7)]autorelease];
		[lblNo setNumberOfLines:0];
		[lblNo setBackgroundColor:[UIColor clearColor]];
		[lblNo setTextColor:RGB(44, 44, 44)];
		[lblNo setHighlightedTextColor:[UIColor whiteColor]];
		[lblNo setFont:[UIFont systemFontOfSize:15]];
        [lblNo setText:@"거래번호"];
		[self.contentView addSubview:lblNo];
        [lblNo setTextAlignment:UITextAlignmentLeft];
		//self.lblNo = lblAccountNo;
        
        
        //거래번호
		UILabel *lblAccountNo = [[[UILabel alloc]initWithFrame:CGRectMake(8, 3, 280, 7+14+7)]autorelease];
		[lblAccountNo setNumberOfLines:0];
		[lblAccountNo setBackgroundColor:[UIColor clearColor]];
		[lblAccountNo setTextColor:RGB(44, 44, 44)];
		[lblAccountNo setHighlightedTextColor:[UIColor whiteColor]];
		[lblAccountNo setFont:[UIFont systemFontOfSize:15]];
		[self.contentView addSubview:lblAccountNo];
        [lblAccountNo setTextAlignment:UITextAlignmentRight];
		self.lblAccountNo = lblAccountNo;

        
        //해지일
		UILabel *endname = [[[UILabel alloc]initWithFrame:CGRectMake(8, 10+14, 280, 7+14+7)]autorelease];
		[endname setNumberOfLines:0];
		[endname setBackgroundColor:[UIColor clearColor]];
		[endname setTextColor:RGB(44, 44, 44)];
		[endname setHighlightedTextColor:[UIColor whiteColor]];
		[endname setFont:[UIFont systemFontOfSize:15]];
        [endname setAdjustsFontSizeToFitWidth:YES];
        [endname setText:@"해지일"];
        [endname setTextAlignment:UITextAlignmentLeft];
		[self.contentView addSubview:endname];
		//self.lblName = lblName;
        
		//해지일
		UILabel *endDate = [[[UILabel alloc]initWithFrame:CGRectMake(8, 10+14, 280, 7+14+7)]autorelease];
		[endDate setNumberOfLines:0];
		[endDate setBackgroundColor:[UIColor clearColor]];
		[endDate setTextColor:RGB(44, 44, 44)];
		[endDate setHighlightedTextColor:[UIColor whiteColor]];
		[endDate setFont:[UIFont systemFontOfSize:15]];
        [endDate setAdjustsFontSizeToFitWidth:YES];
        [endDate setTextAlignment:UITextAlignmentRight];
		[self.contentView addSubview:endDate];
		self.endDate = endDate;
        
      
        
        
        //해지금액
        UILabel *lblMoneyname = [[[UILabel alloc]initWithFrame:CGRectMake(8, 31+14, 294, 7+14+7)]autorelease];
		[lblMoneyname setNumberOfLines:0];
		[lblMoneyname setBackgroundColor:[UIColor clearColor]];
		[lblMoneyname setTextColor:RGB(44, 44, 44)];
		[lblMoneyname setHighlightedTextColor:[UIColor whiteColor]];
		[lblMoneyname setFont:[UIFont systemFontOfSize:15]];
        [lblMoneyname setTextAlignment:UITextAlignmentLeft];
        [lblMoneyname setText:@"해지금액"];
		[self.contentView addSubview:lblMoneyname];
		//self.endDate = lblMoneyname;
        
        
        UILabel *lblMoney = [[[UILabel alloc]initWithFrame:CGRectMake(8, 31+14, 280, 7+14+7)]autorelease];
		[lblMoney setNumberOfLines:0];
		[lblMoney setBackgroundColor:[UIColor clearColor]];
		[lblMoney setTextColor:RGB(0, 137, 220)];
		[lblMoney setHighlightedTextColor:[UIColor whiteColor]];
		[lblMoney setFont:[UIFont systemFontOfSize:15]];
        [lblMoney setTextAlignment:UITextAlignmentRight];
		[self.contentView addSubview:lblMoney];
		self.lblMoney = lblMoney;
        
                
        
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
