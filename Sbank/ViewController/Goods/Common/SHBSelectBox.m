//
//  SHBSelectBox.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSelectBox.h"

@interface SHBSelectBox ()

@property (nonatomic, retain) SHBButton *button;
@property (nonatomic, retain) UILabel *label;

@end

@implementation SHBSelectBox

- (void)dealloc
{
	[_text release];
	[_button release];
	[_label release];
	[super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		SHBButton *btn = [SHBButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
		[btn setBackgroundImage:[UIImage imageNamed:@"selectbox2_nor.png"] forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageNamed:@"selectbox2_focus.png"] forState:UIControlStateSelected];
		[btn setBackgroundImage:[UIImage imageNamed:@"selectbox2_dim.png"] forState:UIControlStateDisabled];
		[btn setAdjustsImageWhenHighlighted:NO];
		[btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btn];
		self.button = btn;
		
        
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, self.frame.size.width-24-8, 30)]autorelease];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setTextColor:RGB(44, 44, 44)];
		[lbl setFont:[UIFont systemFontOfSize:15]];
		[self addSubview:lbl];
		self.label = lbl;
        [self.label setIsAccessibilityElement:NO];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		SHBButton *btn = [SHBButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:CGRectMake(0, 0, frame.size.width, 30)];
		[btn setBackgroundImage:[UIImage imageNamed:@"selectbox2_nor.png"] forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageNamed:@"selectbox2_focus.png"] forState:UIControlStateSelected];
		[btn setBackgroundImage:[UIImage imageNamed:@"selectbox2_dim.png"] forState:UIControlStateDisabled];
		[btn setAdjustsImageWhenHighlighted:NO];
		[btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btn];
		self.button = btn;
		
		UILabel *lbl = [[[UILabel alloc]initWithFrame:CGRectMake(8, 0, frame.size.width-24-8, 30)]autorelease];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setTextColor:RGB(44, 44, 44)];
		[lbl setFont:[UIFont systemFontOfSize:15]];
		[self addSubview:lbl];
		self.label = lbl;
    }
	
    return self;
}

- (void)buttonPressed:(SHBButton *)sender
{
	if (_delegate && [_delegate respondsToSelector:@selector(didSelectSelectBox:)]) {
		[_delegate didSelectSelectBox:self];
	}
}

- (void)setText:(NSString *)text
{
	[_text release];
	_text = [text retain];
	[_label setText:_text];
}

- (void)setState:(SHBSelectBoxState)state
{
	switch (state) {
		case SHBSelectBoxStateNormal:
			[_button setEnabled:YES];
			[_button setSelected:NO];
			[_label setTextColor:RGB(44, 44, 44)];
			break;
		case SHBSelectBoxStateSelected:
			[_button setEnabled:YES];
			[_button setSelected:YES];
			[_label setTextColor:RGB(44, 44, 44)];
			break;
		case SHBSelectBoxStateDisabled:
			[_button setEnabled:NO];
			[_label setTextColor:RGB(198, 198, 198)];
			break;
			
		default:
			break;
	}
}

@end
