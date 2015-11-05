//
//  SHBTextField.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBTextField.h"


@implementation SHBTextField

@synthesize accDelegate;
@synthesize strLableFormat;
@synthesize strNoDataLable;
@synthesize strHint;

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 5, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (void)drawRect:(CGRect)rect{
	// Background Image
	[self setBackground:[[UIImage imageNamed:@"textfeld_nor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]];
	[self setDisabledBackground:[[UIImage imageNamed:@"textfeld_dim.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]];
	
	// Input Accessory View
	UIView	*inputAccView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	[inputAccView setBackgroundColor:[UIColor colorWithRed:53.0f/255.0f green:53.0f/255.0f blue:62.0f/255.0f alpha:0.8]];
	
	UIButton *prevButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 5, 50, 29)];
	prevButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	[prevButton setTitle:@"이전" forState:UIControlStateNormal];
	[prevButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[prevButton setTag:10];
	UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(67, 5, 50, 29)];
	nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	[nextButton setTitle:@"다음" forState:UIControlStateNormal];
	[nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[nextButton setTag:20];
	UIButton *completeButton = [[UIButton alloc] initWithFrame:CGRectMake(258, 5, 50, 29)];
	completeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
	[completeButton setTitle:@"완료" forState:UIControlStateNormal];
	[completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[completeButton setTag:30];
	
	
	// Image with without cap insets
	[prevButton setBackgroundImage:[[UIImage imageNamed:@"btn_btype1.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
	[nextButton setBackgroundImage:[[UIImage imageNamed:@"btn_btype1.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
	[completeButton setBackgroundImage:[[UIImage imageNamed:@"btn_ctype3.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3] forState:UIControlStateNormal];
	
	[prevButton addTarget:self action:@selector(buttonPressed:) forControlEvents: UIControlEventTouchUpInside];
	[nextButton addTarget:self action:@selector(buttonPressed:) forControlEvents: UIControlEventTouchUpInside];
	[completeButton addTarget:self action:@selector(buttonPressed:) forControlEvents: UIControlEventTouchUpInside];
	
    if (!UIAccessibilityIsVoiceOverRunning())
    {
        [inputAccView addSubview:prevButton];
        [inputAccView addSubview:nextButton];
    }

    
	[inputAccView addSubview:completeButton];
	
	[prevButton release];
	[nextButton release];
	[completeButton release];
	
	// AccessoryView
	[self setInputAccessoryView:inputAccView];
	[inputAccView release];
	
	// Prev, Next Button Enabled in AccessoryView
    isDraw = YES;
	[self enableAccButtons:NO Next:NO];
}
- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
}

#pragma mark - Mothos
- (void)focusSetWithLoss:(BOOL)focus{
	if (focus){
		[self setBackground:[[UIImage imageNamed:@"textfeld_focus.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]];
	}else{
		[self setBackground:[[UIImage imageNamed:@"textfeld_nor.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]];
        
	}
}

- (void)enableAccButtons:(BOOL)prev Next:(BOOL)next{
	UIButton *prevButton = (UIButton*)[self.inputAccessoryView viewWithTag:10];
	UIButton *nextButton = (UIButton*)[self.inputAccessoryView viewWithTag:20];
	[prevButton setEnabled:prev];
	[nextButton setEnabled:next];
    
    if (UIAccessibilityIsVoiceOverRunning() && isDraw == NO)
    {
        if (self.keyboardType == UIKeyboardTypeNumberPad)
        {
            [self.inputAccessoryView viewWithTag:30].accessibilityHint = @"일반숫자입력화면입니다";
        }else
        {
            [self.inputAccessoryView viewWithTag:30].accessibilityHint = @"일반문자입력화면입니다";
        }
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, [self.inputAccessoryView viewWithTag:30]);
    }

    isDraw = NO;
}

- (void)buttonPressed:(UIButton*)sender{
	switch (sender.tag) {
		case 10:
			// 이전버튼
			//NSLog(@"이전버튼 실행");
			
			if (accDelegate != nil && [accDelegate respondsToSelector:@selector(didPrevButtonTouch)]) {
				[accDelegate didPrevButtonTouch];
			}
			break;
		case 20:
			// 다음버튼
			//NSLog(@"다음버튼 실행");
			
			if (accDelegate != nil && [accDelegate respondsToSelector:@selector(didNextButtonTouch)]) {
				[accDelegate didNextButtonTouch];
			}
			break;
		case 30:
			// 완료버튼
			//NSLog(@"완료버튼 실행");
			
			if (accDelegate != nil && [accDelegate respondsToSelector:@selector(didCompleteButtonTouch)]) {
				[accDelegate didCompleteButtonTouch];
			}
			break;
			
		default:
			break;
	}
}


- (BOOL)isAccessibilityElement{
    return [super isAccessibilityElement];
}

- (NSString *)accessibilityHint
{
    NSString *strReturn = [super accessibilityHint];
    
    if(strHint != nil) strReturn = strHint;
    
    return strReturn;
}

- (NSString *)accessibilityLabel
{
    NSString *strReturn = [super accessibilityLabel];
    
    if(strLableFormat != nil){
        if([self.text length] > 0){
            strReturn = [NSString stringWithFormat:strLableFormat, self.text];
        }else{
            if(strLableFormat != nil) strReturn = strNoDataLable;
        }
    }
    return strReturn;
}

- (NSString *)accessibilityValue
{
    NSString *strReturn = [super accessibilityValue];
    
    if(strLableFormat != nil){
        if([self.text length] == 0){
            if(strNoDataLable != nil){
                strReturn = @"";
            }else{
                if([self.placeholder length] > 0) strReturn = self.placeholder;
            }
        }else{
            strReturn = @"";
        }
    }
    
    return strReturn;
}


- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}


@end
