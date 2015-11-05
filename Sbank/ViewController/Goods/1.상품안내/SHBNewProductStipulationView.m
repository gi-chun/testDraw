//
//  SHBNewProductStipulationView.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 24..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNewProductStipulationView.h"
#import "SHBButton.h"

@implementation SHBNewProductStipulationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self setBackgroundColor:[UIColor clearColor]];
		
		SHBButton *btnSee = [SHBButton buttonWithType:UIButtonTypeCustom];
		[btnSee setFrame:CGRectMake(0, 0, 79, 29)];
		[btnSee setBackgroundImage:[UIImage imageNamed:@"btn_ctype3.png"] forState:UIControlStateNormal];
		[btnSee setBackgroundImage:[UIImage imageNamed:@"btn_ctype3_focus.png"] forState:UIControlStateHighlighted];
		[btnSee.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[btnSee.titleLabel setTextColor:[UIColor whiteColor]];
		[btnSee setTitle:@"보기" forState:UIControlStateNormal];
		[btnSee setCenter:self.center];
		[btnSee setFrame:CGRectMake(218, btnSee.frame.origin.y, btnSee.frame.size.width, btnSee.frame.size.height)];
		[btnSee addTarget:self.parentViewController action:@selector(seeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        btnSee.accessibilityLabel = @"약관동의 및 상품설명서 보기";
        //btnSee.accessibilityLabel = @"개인신용정보수집이용제공동의서 보기";
		[self addSubview:btnSee];
    }
	
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextBeginPath(context);
	CGContextSetRGBStrokeColor(context, 209/255.0, 209/255.0, 209/255.0, 1);
	CGContextSetLineWidth(context, 1);
	
	// 오른쪽 세로라인
	CGContextMoveToPoint(context, 216, 1);
	CGContextAddLineToPoint(context, 216, self.frame.size.height-1);
	CGContextStrokePath(context);
	
	// Label 및 탭제스쳐 세팅
	for (int nIdx = 0; nIdx < [self.parentViewController.marrStipulations count]; nIdx++) {
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(10, nIdx*kRowHeight, 216-10, kRowHeight)]autorelease];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setFont:[UIFont systemFontOfSize:15]];
		[lbl setText:[self.parentViewController.marrStipulations objectAtIndex:nIdx]];
		[lbl setUserInteractionEnabled:YES];
		[lbl setAdjustsFontSizeToFitWidth:YES];
		[lbl setTag:nIdx];
		[self addSubview:lbl];

		UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc]initWithTarget:self.parentViewController action:@selector(stipulationItemPressed:)]autorelease];
		[tap setNumberOfTapsRequired:1];
		[lbl addGestureRecognizer:tap];
	}
	
	// 가로라인
	for (int nIdx = 1; nIdx < [self.parentViewController.marrStipulations count]; nIdx++) {
		CGContextMoveToPoint(context, 1, nIdx * kRowHeight);
		CGContextAddLineToPoint(context, 216, nIdx * kRowHeight);
		CGContextStrokePath(context);
	}
}



@end
