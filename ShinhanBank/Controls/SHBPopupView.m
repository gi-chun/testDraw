//
//  SHBPopupView.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBPopupView.h"

#define POP_VIEW_TAG 8888

@interface SHBPopupView (private)
- (void)fadeIn;
- (void)fadeOut;
@end


@implementation SHBPopupView

@synthesize delegate;
@synthesize mainView;

#pragma mark - initialization & cleaning up
- (id)initWithTitle:(NSString *)aTitle SubViewHeight:(float)height
{
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
		self.backgroundColor = [UIColor clearColor];
		
		// Popup Image
		float top = (self.frame.size.height - (height+52))/2;
		
		UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(22, top, 276, 42+height+10)];
		popupView.backgroundColor = [UIColor clearColor];
		popupView.tag = POP_VIEW_TAG;
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 200, 35)];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setText:aTitle];
		
		UIButton	*closeButton = [[UIButton alloc] initWithFrame:CGRectMake(276 - 52, 4, 45, 29)];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            [closeButton setFrame:CGRectMake(closeButton.frame.origin.x + 4, closeButton.frame.origin.y, closeButton.frame.size.width, closeButton.frame.size.height)];
        }
		closeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
		[closeButton setTitle:@"닫기" forState:UIControlStateNormal];
		[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"btn_btype2.png"] forState:UIControlStateNormal];
		[closeButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		
		UIView	*subView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, 276, height+10)];
		subView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:239.0f/255.0f blue:233.0f/255.0f alpha:1];
		
		UIImageView	*topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, 276, 42)];
		UIImageView *midImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, 276, height)];
		UIImageView	*btmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42+height, 276, 10)];
		[topImageView setImage:[UIImage imageNamed:@"popup_title.png"]];
		[midImageView setImage:[UIImage imageNamed:@"popup_mid.png"]];
		[btmImageView setImage:[UIImage imageNamed:@"popup_bottom.png"]];
		
		mainView = [[UIView alloc] initWithFrame:CGRectMake(8, 42, 260, height)];
		mainView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1];
		
		[popupView addSubview:subView];
		[popupView addSubview:topImageView];
		[popupView addSubview:midImageView];
		[popupView addSubview:btmImageView];
		[popupView addSubview:titleLabel];
		[popupView addSubview:closeButton];
		[popupView addSubview:mainView];
		
		//Background Dimm Button
		UIButton	*dimmButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
		[dimmButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
		[dimmButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		[dimmButton setIsAccessibilityElement:NO];
        //dimmButton.accessibilityTraits = UIAccessibilityTraitNone;
        //dimmButton.accessibilityLabel = [NSString stringWithFormat:@"%@ 팝업화면입니다",titleLabel.text];
        titleLabel.accessibilityLabel = [NSString stringWithFormat:@"%@ 팝업화면입니다",titleLabel.text];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, titleLabel);
        }
        
		[self addSubview:dimmButton];
		[self addSubview:popupView];
		
        [subView release];
		[dimmButton release];
		[titleLabel release];
		[closeButton release];
		[topImageView release];
		[midImageView release];
		[btmImageView release];
		[popupView release];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
    return self;
}

- (id)initWithSortTitle:(NSString *)aTitle SubViewHeight:(float)height
{
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
		self.backgroundColor = [UIColor clearColor];
		
		// Popup Image
		float top = (self.frame.size.height - (height+52))/2;
		
		UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(22, top, 276, 42+height+10)];
		popupView.backgroundColor = [UIColor clearColor];
		popupView.tag = POP_VIEW_TAG;
		
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 200, 35)];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setText:aTitle];
		
        
        UIButton	*sortButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 7, 25, 25)];
		sortButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
//		[sortButton setTitle:@"정렬" forState:UIControlStateNormal];
		[sortButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[sortButton setBackgroundImage:[UIImage imageNamed:@"btn_btype2.png"] forState:UIControlStateNormal];
		[sortButton addTarget:self action:@selector(sortBtn:) forControlEvents: UIControlEventTouchUpInside];
		[sortButton setBackgroundImage:[UIImage imageNamed:@"btn_listarrange_down.png"] forState:UIControlStateNormal];
		[sortButton setBackgroundImage:[UIImage imageNamed:@"btn_listarrange.png"] forState:UIControlStateSelected];
        //sortButton.accessibilityLabel = [NSString stringWithFormat:@"정렬선택 현재 내림차순입니다. 오름차순으로 정렬하시려면 이중탭하십시요."];
        sortButton.accessibilityLabel = [NSString stringWithFormat:@"회차정렬 내림차순"];
        
        
		UIButton	*closeButton = [[UIButton alloc] initWithFrame:CGRectMake(276 - 52, 4, 45, 29)];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            [closeButton setFrame:CGRectMake(closeButton.frame.origin.x + 4, closeButton.frame.origin.y, closeButton.frame.size.width, closeButton.frame.size.height)];
        }
		closeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
		[closeButton setTitle:@"닫기" forState:UIControlStateNormal];
		[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"btn_btype2.png"] forState:UIControlStateNormal];

		[closeButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		
		UIView	*subView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, 276, height+10)];
		subView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:239.0f/255.0f blue:233.0f/255.0f alpha:1];
		
		UIImageView	*topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, 276, 42)];
		UIImageView *midImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, 276, height)];
		UIImageView	*btmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42+height, 276, 10)];
		[topImageView setImage:[UIImage imageNamed:@"popup_title.png"]];
		[midImageView setImage:[UIImage imageNamed:@"popup_mid.png"]];
		[btmImageView setImage:[UIImage imageNamed:@"popup_bottom.png"]];
		
		mainView = [[UIView alloc] initWithFrame:CGRectMake(8, 42, 260, height)];
		mainView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1];
		
		[popupView addSubview:subView];
		[popupView addSubview:topImageView];
		[popupView addSubview:midImageView];
		[popupView addSubview:btmImageView];
		[popupView addSubview:titleLabel];
		[popupView addSubview:closeButton];
        
        [popupView addSubview:sortButton];

		[popupView addSubview:mainView];
		
		//Background Dimm Button
		UIButton	*dimmButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
		[dimmButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
		[dimmButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		[dimmButton setIsAccessibilityElement:NO];
        //dimmButton.accessibilityTraits = UIAccessibilityTraitNone;
        //dimmButton.accessibilityLabel = [NSString stringWithFormat:@"%@ 팝업화면입니다",titleLabel.text];
        titleLabel.accessibilityLabel = [NSString stringWithFormat:@"%@ 팝업화면입니다",titleLabel.text];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, titleLabel);
        }
		[self addSubview:dimmButton];
		[self addSubview:popupView];
		
        [sortButton release];
        [subView release];
		[dimmButton release];
		[titleLabel release];
		[closeButton release];
		[topImageView release];
		[midImageView release];
		[btmImageView release];
		[popupView release];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
    return self;
}

- (id)initWithTitle:(NSString *)aTitle subView:(UIView *)aView
{
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
		self.backgroundColor = [UIColor clearColor];
		
		// Popup Image
        float height = aView.frame.size.height - 8;
		float top = (self.frame.size.height - (height+52))/2;
		
		UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(22, top, 276, 42+height+10)];
		popupView.backgroundColor = [UIColor clearColor];
		popupView.tag = POP_VIEW_TAG;
		
        aView.frame = CGRectMake(8, 42, 260, height + 8);
        
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 200, 35)];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setText:aTitle];
		
		UIButton	*closeButton = [[UIButton alloc] initWithFrame:CGRectMake(276 - 52, 4, 45, 29)];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            [closeButton setFrame:CGRectMake(closeButton.frame.origin.x + 4, closeButton.frame.origin.y, closeButton.frame.size.width, closeButton.frame.size.height)];
        }
		closeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
		[closeButton setTitle:@"닫기" forState:UIControlStateNormal];
		[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"btn_btype2.png"] forState:UIControlStateNormal];
		[closeButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		
		UIView	*subView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, 276, height+18)];
//		subView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:239.0f/255.0f blue:233.0f/255.0f alpha:1];
        subView.backgroundColor = aView.backgroundColor;
		
		UIImageView	*topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, 276, 42)];
		UIImageView *midImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, 276, height+8)];
		UIImageView	*btmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42+height+8, 276, 10)];
		[topImageView setImage:[UIImage imageNamed:@"popup_title.png"]];
		[midImageView setImage:[UIImage imageNamed:@"popup_mid.png"]];
		[btmImageView setImage:[UIImage imageNamed:@"popup_bottom.png"]];
		
		[popupView addSubview:subView];
		[popupView addSubview:topImageView];
		[popupView addSubview:midImageView];
		[popupView addSubview:btmImageView];
		[popupView addSubview:titleLabel];
		[popupView addSubview:closeButton];
		[popupView addSubview:aView];
        
		//Background Dimm Button
		UIButton	*dimmButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
		[dimmButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
		[dimmButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		[dimmButton setIsAccessibilityElement:NO];
//        dimmButton.accessibilityTraits = UIAccessibilityTraitNone;
//        dimmButton.accessibilityLabel = [NSString stringWithFormat:@"%@ 팝업화면입니다",titleLabel.text];
        
        titleLabel.accessibilityLabel = [NSString stringWithFormat:@"%@ 팝업화면입니다",titleLabel.text];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            if (![titleLabel.text isEqualToString:@"수취인 확인"])
            {
                UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, titleLabel);
            }
        }
		[self addSubview:dimmButton];
		[self addSubview:popupView];
		
		[dimmButton release];
		[titleLabel release];
		[closeButton release];
		[topImageView release];
		[midImageView release];
		[btmImageView release];
		[popupView release];
        [subView release];
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
    return self;
}

// 지로용으로 하나 추가
- (id)initWithTitle:(NSString *)aTitle subView:(UIView *)aView topHeight:(float)top
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
		self.backgroundColor = [UIColor clearColor];
		
		// Popup Image
        float height = aView.frame.size.height - 8;
		float topHeight = top;
		
		UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(22, topHeight, 276, 42+height+10)];
		popupView.backgroundColor = [UIColor clearColor];
		popupView.tag = POP_VIEW_TAG;
		
        aView.frame = CGRectMake(8, 42, 260, height + 8);
        
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, 200, 35)];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setText:aTitle];
		
		UIButton	*closeButton = [[UIButton alloc] initWithFrame:CGRectMake(276 - 52, 4, 45, 29)];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            [closeButton setFrame:CGRectMake(closeButton.frame.origin.x + 4, closeButton.frame.origin.y, closeButton.frame.size.width, closeButton.frame.size.height)];
        }
		closeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
		[closeButton setTitle:@"닫기" forState:UIControlStateNormal];
		[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"btn_btype2.png"] forState:UIControlStateNormal];
		[closeButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		
		UIView	*subView = [[UIView alloc] initWithFrame:CGRectMake(0, 36, 276, height+18)];
        subView.backgroundColor = aView.backgroundColor;
		
		UIImageView	*topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, 276, 42)];
		UIImageView *midImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42, 276, height+8)];
		UIImageView	*btmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 42+height+8, 276, 10)];
		[topImageView setImage:[UIImage imageNamed:@"popup_title.png"]];
		[midImageView setImage:[UIImage imageNamed:@"popup_mid.png"]];
		[btmImageView setImage:[UIImage imageNamed:@"popup_bottom.png"]];
		
		[popupView addSubview:subView];
		[popupView addSubview:topImageView];
		[popupView addSubview:midImageView];
		[popupView addSubview:btmImageView];
		[popupView addSubview:titleLabel];
		[popupView addSubview:closeButton];
		[popupView addSubview:aView];
        
		//Background Dimm Button
		UIButton	*dimmButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
		[dimmButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
		[dimmButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		[dimmButton setIsAccessibilityElement:NO];
        //dimmButton.accessibilityTraits = UIAccessibilityTraitNone;
        //dimmButton.accessibilityLabel = [NSString stringWithFormat:@"%@ 팝업화면입니다",titleLabel.text];
        titleLabel.accessibilityLabel = [NSString stringWithFormat:@"%@ 팝업화면입니다",titleLabel.text];
        if (UIAccessibilityIsVoiceOverRunning())
        {
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, titleLabel);
        }
		[self addSubview:dimmButton];
		[self addSubview:popupView];
		
		[dimmButton release];
		[titleLabel release];
		[closeButton release];
		[topImageView release];
		[midImageView release];
		[btmImageView release];
		[popupView release];
        [subView release];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
    return self;
}
- (void)logoutClose
{
    [self fadeOut];
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Private Methods
- (void)fadeIn{
	UIView *popupView = [self viewWithTag:POP_VIEW_TAG];
    popupView.transform = CGAffineTransformMakeScale(.2, .2);
    popupView.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        popupView.alpha = 1;
        popupView.transform = CGAffineTransformMakeScale(1, 1);
    }];
	
}
- (void)fadeOut{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	UIView *popupView = [self viewWithTag:POP_VIEW_TAG];
    [UIView animateWithDuration:.35 animations:^{
        popupView.transform = CGAffineTransformMakeScale(.2, .2);
        popupView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    
    //self.tag = 876898;
    if (animated) {
        [self fadeIn];
    }
}

- (void)closePopupViewWithButton:(UIButton*)sender{
	// tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidCancel)]) {
        [self.delegate popupViewDidCancel];
    }
    
    // dismiss self
    [self fadeOut];
}

- (void)sortBtn
{
    
}

@end
