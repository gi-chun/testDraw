//
//  SHBGoodsSubTitleView.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBGoodsSubTitleView.h"
#import "SHBScrollLabel.h"
#import "SHBScrollingTicker.h"
@implementation SHBGoodsSubTitleView

- (void)dealloc
{
	[_marrSteps release];
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

- (id)initWithTitle:(NSString *)title maxStep:(NSUInteger)maxStep
{
	self = [super initWithFrame:CGRectMake(0, 44, 317, 37)];
    if (self) {
        // Initialization code
		[self setBackgroundColor:RGB(53, 53, 62)];
		
		self.marrSteps = [NSMutableArray array];
		
//		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 180, height(self))]autorelease];
//		[lbl setBackgroundColor:[UIColor clearColor]];
//		[lbl setTextColor:[UIColor whiteColor]];
//		[lbl setFont:[UIFont systemFontOfSize:15]];
//		[lbl setText:title];
//		[self addSubview:lbl];
		
		CGRect rect = CGRectZero;
		CGFloat width = 0;
		
		NSMutableArray *marrTemp = [NSMutableArray array];
		NSInteger nStep = maxStep;
		for (int nIdx = 0; nIdx < maxStep; nIdx++) {
			UIImageView *ivStep = [[[UIImageView alloc]initWithFrame:CGRectMake(320-((3+8-2)+((18+2)*(nIdx+1))), 10, 18, 16)]autorelease];
			[ivStep setImage:[UIImage imageNamed:@"step_off.png"]];
			[ivStep setHighlightedImage:[UIImage imageNamed:@"step_on.png"]];
            [ivStep setIsAccessibilityElement:NO];
			[self addSubview:ivStep];
			
			UILabel *lblNum = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 18, 16)]autorelease];
			[lblNum setBackgroundColor:[UIColor clearColor]];
			[lblNum setTextColor:[UIColor whiteColor]];
			[lblNum setFont:[UIFont systemFontOfSize:13]];
			[lblNum setTextAlignment:NSTextAlignmentCenter];
			[lblNum setText:[NSString stringWithFormat:@"%d", nStep]];
            [lblNum setIsAccessibilityElement:NO];
			[ivStep addSubview:lblNum];
			
			nStep--;
			[marrTemp addObject:ivStep];
			
			if (nIdx == maxStep-1) {
				width = left(ivStep);
			}
		}
		
		for (int nIdx = [marrTemp count]-1; nIdx >= 0; nIdx--) {
			[self.marrSteps addObject:[marrTemp objectAtIndex:nIdx]];
		}
		
		if (maxStep == 0) {
			rect = CGRectMake(8, 0, 301, height(self));
		}
		else
		{
			rect = CGRectMake(8, 0, width-10, height(self));
		}
		
		SHBScrollLabel *lbl = [[[SHBScrollLabel alloc]initWithFrame:rect]autorelease];
		[self addSubview:lbl];
		
        [lbl initFrame:lbl.frame];
        [lbl setCaptionText:title];
//		LPScrollingTickerLabelItem *tickerItem = [[[LPScrollingTickerLabelItem alloc]initWithLabelStyle:title FontSize:15 TextColor:[UIColor whiteColor]]autorelease];
//		[lbl executeSlideAnimation:tickerItem Direction:LPScrollingDirection_FromRight];
        
        
    }
	
    return self;
}

- (id)initWithTitle:(NSString *)title maxStep:(NSUInteger)maxStep focusStepNumber:(NSUInteger)focusStep
{
	self = [super initWithFrame:CGRectMake(0, 44, 317, 37)];
    if (self) {
        // Initialization code
		[self setBackgroundColor:RGB(53, 53, 62)];
		
		self.marrSteps = [NSMutableArray array];
		
//		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 180, height(self))]autorelease];
//		[lbl setBackgroundColor:[UIColor clearColor]];
//		[lbl setTextColor:[UIColor whiteColor]];
//		[lbl setFont:[UIFont systemFontOfSize:15]];
//		[lbl setText:title];
//		[self addSubview:lbl];
		
		CGRect rect = CGRectZero;
		CGFloat width = 0;
		
		NSMutableArray *marrTemp = [NSMutableArray array];
		NSInteger nStep = maxStep;
		for (int nIdx = 0; nIdx < maxStep; nIdx++) {
			UIImageView *ivStep = [[[UIImageView alloc]initWithFrame:CGRectMake(320-((3+8-2)+((18+2)*(nIdx+1))), 10, 18, 16)]autorelease];
			[ivStep setImage:[UIImage imageNamed:@"step_off.png"]];
			[ivStep setHighlightedImage:[UIImage imageNamed:@"step_on.png"]];
            [ivStep setIsAccessibilityElement:NO];
			[self addSubview:ivStep];
			
			UILabel *lblNum = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 18, 16)]autorelease];
			[lblNum setBackgroundColor:[UIColor clearColor]];
			[lblNum setTextColor:[UIColor whiteColor]];
			[lblNum setFont:[UIFont systemFontOfSize:13]];
			[lblNum setTextAlignment:NSTextAlignmentCenter];
			[lblNum setText:[NSString stringWithFormat:@"%d", nStep]];
            
            NSString *accStr;
            if (nStep == focusStep)
            {
                accStr = [NSString stringWithFormat:@"총 %i 단계중 현재 %i단계입니다",maxStep,focusStep];
            }else if (nStep < focusStep)
            {
                accStr = @"";
            }else
            {
                accStr = @"";
            }
            
            lblNum.accessibilityLabel = accStr;
            //[lblNum setIsAccessibilityElement:NO];
			[ivStep addSubview:lblNum];
			
			nStep--;
			[marrTemp addObject:ivStep];
			
			if (nIdx == maxStep-1) {
				width = left(ivStep);
			}
		}
		
		for (int nIdx = [marrTemp count]-1; nIdx >= 0; nIdx--) {
			[self.marrSteps addObject:[marrTemp objectAtIndex:nIdx]];
		}
		
		if ([self.marrSteps count]) {
			for (int nIdx = 0; nIdx < focusStep; nIdx++) {
				UIImageView *ivStep = [self.marrSteps objectAtIndex:nIdx];
				[ivStep setHighlighted:YES];
			}
		}
		
		if (maxStep == 0) {
			rect = CGRectMake(8, 0, 301, height(self));
		}
		else
		{
			rect = CGRectMake(8, 0, width-10, height(self));
		}
		
		SHBScrollLabel *lbl = [[[SHBScrollLabel alloc]initWithFrame:rect]autorelease];  // 단계표시줄의 글자 흐름속도 부분
		[self addSubview:lbl];
//		
//		LPScrollingTickerLabelItem *tickerItem = [[[LPScrollingTickerLabelItem alloc]initWithLabelStyle:title FontSize:15 TextColor:[UIColor whiteColor]]autorelease];
//		[lbl executeSlideAnimation:tickerItem Direction:LPScrollingDirection_FromRight];
//        [lbl initFrame:lbl.frame];
        
        [lbl initFrame:lbl.frame];
        [lbl setCaptionText:title];

        
    }
	
    return self;
}

- (void)setFocusStepNumber:(NSUInteger)num
{
	if ([self.marrSteps count]) {
		for (int nIdx = 0; nIdx < num; nIdx++) {
			UIImageView *ivStep = [self.marrSteps objectAtIndex:nIdx];
	[ivStep setHighlighted:YES];
}
	}
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
