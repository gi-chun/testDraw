//
//  SHBLoanSecurityStipulationView.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBLoanSecurityStipulationView.h"

@implementation SHBLoanSecurityStipulationView

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
		[btnSee.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[btnSee.titleLabel setTextColor:[UIColor whiteColor]];
		[btnSee setTitle:@"보기" forState:UIControlStateNormal];
		[btnSee setCenter:self.center];
		[btnSee setFrame:CGRectMake(218, btnSee.frame.origin.y, btnSee.frame.size.width, btnSee.frame.size.height)];
		[btnSee addTarget:self.parentViewController action:@selector(seeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
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
	for (int nIdx = 0; nIdx < 2; nIdx++) {
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(10, nIdx*kRowHeight, 216-10, kRowHeight)]autorelease];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setFont:[UIFont systemFontOfSize:14]];
		[lbl setUserInteractionEnabled:YES];
		[lbl setTag:nIdx];
		[self addSubview:lbl];
		
		if (nIdx == 0) {
			[lbl setText:@"지연배상금 조항 자세히 보기"];
		}
		else if (nIdx == 1) {
			[lbl setText:@"개인신용정보의 제공 및 조회 동의서"];
		}
		
		UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc]initWithTarget:self.parentViewController action:@selector(stipulationItemPressed:)]autorelease];
		[tap setNumberOfTapsRequired:1];
		[lbl addGestureRecognizer:tap];
	}
	
	// 가로라인
	for (int nIdx = 1; nIdx < 2; nIdx++) {
		CGContextMoveToPoint(context, 1, nIdx * kRowHeight);
		CGContextAddLineToPoint(context, 216, nIdx * kRowHeight);
		CGContextStrokePath(context);
	}
}

@end
