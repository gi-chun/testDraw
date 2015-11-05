//
//  SHBNewProductNoLineRowView.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNewProductNoLineRowView.h"
#import "SHBScrollLabel.h"

@implementation SHBNewProductNoLineRowView

- (void)dealloc
{
	[_lblTitle release];
	[_lblValue release];
    [_lblView release];
	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithYOffset:(CGFloat)yOffset title:(NSString *)title value:(NSString *)value
{
	self = [super initWithFrame:CGRectMake(0, yOffset, 317, 21)];
    if (self) {
        // Initialization code
		
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 130-8, 21)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:15]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setTextAlignment:NSTextAlignmentLeft];
		[lblTitle setText:title];
		[lblTitle setAdjustsFontSizeToFitWidth:YES];
		[self addSubview:lblTitle];
		self.lblTitle = lblTitle;
		
		UILabel *lblValue = [[[UILabel alloc]initWithFrame:CGRectMake(8+130-8, 0, 317-130-8, 21)]autorelease];
		[lblValue setBackgroundColor:[UIColor clearColor]];
		[lblValue setFont:[UIFont systemFontOfSize:15]];
		[lblValue setTextColor:RGB(44, 44, 44)];
		[lblValue setTextAlignment:NSTextAlignmentRight];
		[lblValue setText:value];
		[lblValue setAdjustsFontSizeToFitWidth:YES];
		[self addSubview:lblValue];
		self.lblValue = lblValue;
    }
    return self;
}

- (id)initWithYOffset:(CGFloat)yOffset title:(NSString *)title value:(NSString *)value isTicker:(BOOL)isTicker
{
	self = [super initWithFrame:CGRectMake(0, yOffset, 317, 21)];
    if (self) {
        // Initialization code
		
		UILabel *lblTitle = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 130-8, 21)]autorelease];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setFont:[UIFont systemFontOfSize:15]];
		[lblTitle setTextColor:RGB(74, 74, 74)];
		[lblTitle setTextAlignment:NSTextAlignmentLeft];
		[lblTitle setText:title];
		[lblTitle setAdjustsFontSizeToFitWidth:YES];
		[self addSubview:lblTitle];
		self.lblTitle = lblTitle;
		
        
        if (isTicker) {
            SHBScrollLabel *label = [[[SHBScrollLabel alloc] initWithFrame:CGRectMake(8+130-8, 0, 317-130-8, 21)] autorelease];
            [label initFrame:CGRectMake(8+130-8, 0, 317-130-8, 21) colorType:RGB(44, 44, 44) fontSize:15 textAlign:2];
            [label setCaptionText:value];
            [self addSubview:label];
            self.lblView = label;
        }
        else {
            UILabel *lblValue = [[[UILabel alloc]initWithFrame:CGRectMake(8+130-8, 0, 317-130-8, 21)]autorelease];
            [lblValue setBackgroundColor:[UIColor clearColor]];
            [lblValue setFont:[UIFont systemFontOfSize:15]];
            [lblValue setTextColor:RGB(44, 44, 44)];
            [lblValue setTextAlignment:NSTextAlignmentRight];
            [lblValue setText:value];
            [lblValue setAdjustsFontSizeToFitWidth:YES];
            [self addSubview:lblValue];
            self.lblValue = lblValue;
        }
    }
    return self;
}

- (id)initWithYOffset:(CGFloat)yOffset
{
	return [self initWithYOffset:yOffset title:nil value:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
