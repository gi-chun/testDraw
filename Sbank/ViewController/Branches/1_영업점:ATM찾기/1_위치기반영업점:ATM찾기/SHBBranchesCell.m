//
//  SHBBranchesCell.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBranchesCell.h"

@implementation SHBBranchesCell

- (void)dealloc
{
	[_lblAddress release];
	[_lblBranch release];
	[_lblTel release];
	[_ivAcc release];
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8, 16, 282, 18)]autorelease];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setTextColor:RGB(40, 91, 142)];
		[lbl setHighlightedTextColor:[UIColor whiteColor]];
		[lbl setFont:[UIFont systemFontOfSize:15]];
		[self.contentView addSubview:lbl];
		self.lblBranch = lbl;
		
		UILabel *lbl1 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 34, 282, 18)]autorelease];
		[lbl1 setBackgroundColor:[UIColor clearColor]];
		[lbl1 setTextColor:RGB(44, 44, 44)];
		[lbl1 setHighlightedTextColor:[UIColor whiteColor]];
		[lbl1 setFont:[UIFont systemFontOfSize:15]];
		[lbl1 setAdjustsFontSizeToFitWidth:YES];
		[self.contentView addSubview:lbl1];
		self.lblAddress = lbl1;
		
		UILabel *lbl2 = [[[UILabel alloc]initWithFrame:CGRectMake(8, 43, 282, 18)]autorelease];
		[lbl2 setBackgroundColor:[UIColor clearColor]];
		[lbl2 setTextColor:RGB(44, 44, 44)];
		[lbl2 setHighlightedTextColor:[UIColor whiteColor]];
		[lbl2 setFont:[UIFont systemFontOfSize:15]];
		[self.contentView addSubview:lbl2];
		self.lblTel = lbl2;
		
		UIImageView *iv = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_list_view"]]autorelease];
		[iv setHighlightedImage:[UIImage imageNamed:@"arrow_list_view_focus"]];
		[self setAccessoryView:iv];
		self.ivAcc = iv;
		
		UIView *selectedView = [[[UIView alloc]initWithFrame:self.contentView.frame]autorelease];
		[selectedView setBackgroundColor:RGB(108, 157, 203)];
		[self setSelectedBackgroundView:selectedView];
		
    }
	
    return self;
}

- (void)set3Line:(BOOL)yesOrNo
{
	if (yesOrNo) {
		FrameReposition(self.lblBranch, left(self.lblBranch), 7);
		FrameReposition(self.lblAddress, left(self.lblAddress), 25);
		[self.lblTel setHidden:NO];
	}
	else
	{
		FrameReposition(self.lblBranch, left(self.lblBranch), 16);
		FrameReposition(self.lblAddress, left(self.lblAddress), 34);
		[self.lblTel setHidden:YES];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	[self.ivAcc setHighlighted:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	
	[self.lblAddress setHighlighted:highlighted];
	[self.lblBranch setHighlighted:highlighted];
	[self.lblTel setHighlighted:highlighted];
	[self.ivAcc setHighlighted:highlighted];
}

@end
