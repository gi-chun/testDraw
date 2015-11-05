//
//  SHBNewProductListCell.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 11..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBNewProductListCell.h"

@implementation SHBNewProductListCell

- (void)dealloc {
	[_ivAccessory release];
	[_lblProductName release];
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
		
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 280, 34)]autorelease];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setTextColor:RGB(44, 44, 44)];
		[lbl setHighlightedTextColor:[UIColor whiteColor]];
		[lbl setFont:[UIFont systemFontOfSize:15]];
		[lbl setAdjustsFontSizeToFitWidth:YES];
		[self addSubview:lbl];
		self.lblProductName = lbl;
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
	
	[self.lblProductName setHighlighted:highlighted];
	[self.ivAccessory setHighlighted:highlighted];
}

@end
