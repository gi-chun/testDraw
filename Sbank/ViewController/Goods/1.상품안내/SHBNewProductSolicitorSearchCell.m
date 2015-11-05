//
//  SHBNewProductSolicitorSearchCell.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNewProductSolicitorSearchCell.h"

@implementation SHBNewProductSolicitorSearchCell

- (void)dealloc
{
	[_lblLeft release];
	[_lblRight release];
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.lblLeft = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 158-8-18, 27)]autorelease];
		[self.lblLeft setBackgroundColor:[UIColor clearColor]];
		[self.lblLeft setFont:[UIFont systemFontOfSize:14]];
		[self.lblLeft setTextColor:RGB(44, 44, 44)];
		[self.contentView addSubview:self.lblLeft];
		
		self.lblRight = [[[UILabel alloc]initWithFrame:CGRectMake(158, 0, 76, 27)]autorelease];
		[self.lblRight setBackgroundColor:[UIColor clearColor]];
		[self.lblRight setFont:[UIFont systemFontOfSize:14]];
		[self.lblRight setTextColor:RGB(44, 44, 44)];
		[self.contentView addSubview:self.lblRight];
		
		[self setBackgroundView:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"memberlist_list_off.png"]]autorelease]];
		[self setSelectedBackgroundView:[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"memberlist_list_on.png"]]autorelease]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//	if (selected) {
//		[self.lblLeft setTextColor:RGB(173, 175, 179)];
//		[self.lblRight setTextColor:RGB(173, 175, 179)];
//	}
//	else
//	{
//		[self.lblLeft setTextColor:RGB(44, 44, 44)];
//		[self.lblRight setTextColor:RGB(44, 44, 44)];
//	}
}

@end
