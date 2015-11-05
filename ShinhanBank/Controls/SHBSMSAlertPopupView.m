//
//  SHBAlertPopupView.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 13. 2. 26..
//  Copyright (c) 2013년 (주)두베 All rights reserved.
//

#import "SHBSMSAlertPopupView.h"
#import "SHBSmithingGuideViewController.h"
@implementation SHBSMSAlertPopupView

#define POP_VIEW_TAG 9099


#pragma mark -
#pragma mark - Synthesize

@synthesize delegate;
@synthesize mainView;


#pragma mark -
#pragma mark - initialization

- (id)initWithString:(NSString *)aString ButtonCount:(int)count SubViewHeight:(float)height
{
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
		self.backgroundColor = [UIColor clearColor];
		
		// Popup Image
		float top = (self.frame.size.height - (height+52))/2;
		
        // 팝업 자체
		//UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(22, top, 276, 12+height+10)];
        UIView *popupView = [[UIView alloc] initWithFrame:CGRectMake(22, top, 256, height)];
		popupView.backgroundColor = [UIColor clearColor];
        //popupView.backgroundColor = [UIColor yellowColor];
		popupView.tag = POP_VIEW_TAG;
        
        UIScrollView *scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(12, 0, 260, popupView.frame.size.height - 29 - 40)];
        
        [scrollView1 setContentSize:CGSizeMake(0, 0)];
        [scrollView1 setScrollEnabled:NO];
        
        //[scrollView1 setBackgroundColor:[UIColor redColor]];
        
        UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
        
		[stringLabel setBackgroundColor:[UIColor clearColor]];
		[stringLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[stringLabel setTextColor:[UIColor blackColor]];
		[stringLabel setText:aString];
        [stringLabel setTextAlignment:NSTextAlignmentCenter];
        [stringLabel setNumberOfLines:0];
        
        // 자동으로 높이 계산
        CGSize withinSize = CGSizeMake(stringLabel.frame.size.width, FLT_MAX);
        CGSize size = [aString sizeWithFont:stringLabel.font constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
        
        // 12는 여백크기
        float fltSize = 12;
        
        [stringLabel setFrame:CGRectMake(0, 0, 240, size.height + fltSize)];
        
        if (height < size.height)       // scroll이 있는 경우
        {
            [scrollView1 setContentSize:CGSizeMake(0, size.height + fltSize)];
            [scrollView1 setScrollEnabled:YES];
        }
        else            // scroll이 없는 경우
        {
            //[stringLabel setFrame:CGRectMake(0, 20, 240, size.height + fltSize)];
            [stringLabel setFrame:CGRectMake(0, 0, 240, size.height + fltSize)];
        }
        
        
        UIButton *button1;
        UIButton *button2 = nil;
        
        // 버튼이 하나의 경우
        if (count == 1)
        {
            button1 = [[UIButton alloc] initWithFrame:CGRectMake(popupView.center.x - (150/2) - 22,
                                                                 popupView.frame.size.height - 29 - 20,
                                                                 150,
                                                                 29)];
            
            button1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
            [button1 setTitle:@"확인" forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button1 setBackgroundImage:[[UIImage imageNamed:@"btn_btype1.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]
                               forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
        }
        else        // 버튼이 2개인 경우
        {
            // button1,2 일반적인 확인 취소 버튼 위치 값에 맞췄다
            button1 = [[UIButton alloc] initWithFrame:CGRectMake(48,
                                                                 popupView.frame.size.height - 29 - 20,
                                                                 94,
                                                                 29)];
            
            button1.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
            [button1 setTitle:@"예" forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button1 setBackgroundImage:[[UIImage imageNamed:@"btn_btype1.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]
                               forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(confirmPopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
            
            button2 = [[UIButton alloc] initWithFrame:CGRectMake(151,
                                                                 popupView.frame.size.height - 29 - 20,
                                                                 94,
                                                                 29)];
            
            button2.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
            [button2 setTitle:@"아니오" forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button2 setBackgroundImage:[[UIImage imageNamed:@"btn_btype2.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]
                               forState:UIControlStateNormal];
            [button2 addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
        }
		
		UIView	*subView = [[UIView alloc] initWithFrame:CGRectMake(10, 8, 266, height+8-20)];
		subView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:239.0f/255.0f blue:233.0f/255.0f alpha:1];
        //subView.backgroundColor = [UIColor clearColor];
		
        UIButton *chkbtn = [[UIButton alloc] initWithFrame:CGRectMake(80, popupView.frame.size.height - 29 - 20 - 40, 20, 20)];
        [chkbtn setBackgroundImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
        [chkbtn setBackgroundImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateSelected];
        [chkbtn addTarget:self action:@selector(touchDate:) forControlEvents:UIControlEventTouchUpInside];
        chkbtn.tag = 1267;
        chkbtn.accessibilityLabel = @"일주일 동안 안보기 선택";
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, popupView.frame.size.height - 29 - 20 - 40, 150, 20)];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
		[dateLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
		[dateLabel setTextColor:[UIColor blackColor]];
		[dateLabel setText:@"일주일 동안 안보기"];
        [dateLabel setTextAlignment:NSTextAlignmentLeft];
        [dateLabel setNumberOfLines:1];
        [dateLabel setIsAccessibilityElement:NO];
		
//        UIImageView	*topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,  0, 276, 12)];
//		UIImageView *midImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 276, height)];
//		UIImageView	*btmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12+height, 276, 10)];
        
        UIImageView	*topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,  0, 266, 12)];
		UIImageView *midImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 266, height - 20)];
		UIImageView	*btmImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12+height - 20, 266, 10)];
        
		[topImageView setImage:[UIImage imageNamed:@"popup_top.png"]];
		[midImageView setImage:[UIImage imageNamed:@"popup_mid.png"]];
		[btmImageView setImage:[UIImage imageNamed:@"popup_bottom.png"]];
		
		//mainView = [[UIView alloc] initWithFrame:CGRectMake(8, 12, 260, height)];
        //mainView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1];
        
		mainView = [[UIView alloc] initWithFrame:CGRectMake(18, 12, 250, height - 20)];
        mainView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1];
        //mainView.backgroundColor = [UIColor redColor];
        
		[popupView addSubview:subView];
		[popupView addSubview:topImageView];
		[popupView addSubview:midImageView];
		[popupView addSubview:btmImageView];
        [mainView addSubview:scrollView1];
		[popupView addSubview:mainView];
        [scrollView1 addSubview:stringLabel];
        [popupView addSubview:button1];
        [popupView addSubview:button2];
		[popupView addSubview:chkbtn];
        [popupView addSubview:dateLabel];
		//Background Dimm Button
		UIButton	*dimmButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height)];
		[dimmButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
        //[dimmButton setBackgroundColor:[UIColor clearColor]];
        dimmButton.accessibilityTraits = UIAccessibilityTraitNone;
        dimmButton.accessibilityLabel = @"알림";
        //[dimmButton setIsAccessibilityElement:NO];
		//[dimmButton addTarget:self action:@selector(closePopupViewWithButton:) forControlEvents: UIControlEventTouchUpInside];
		
        [dimmButton setIsAccessibilityElement:NO];
        
            //dimmButton.accessibilityTraits = UIAccessibilityTraitNone;
            //dimmButton.accessibilityLabel = @"알림";
        
        [topImageView setIsAccessibilityElement:YES];
        topImageView.accessibilityLabel = @"알림";
        topImageView.accessibilityTraits = UIAccessibilityTraitNone;
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, topImageView);
        
        
		[self addSubview:dimmButton];
		[self addSubview:popupView];
		
        [subView release];
		[dimmButton release];
        [stringLabel release];
		[button1 release];
        [button2 release];
		[topImageView release];
		[midImageView release];
		[btmImageView release];
        [scrollView1 release];
		[popupView release];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutClose) name:@"logoutClose" object:nil];
    return self;
}

- (IBAction)touchDate:(id)sender
{
    NSLog(@"클릭");
    [sender setSelected:![sender isSelected]];
}
#pragma mark -
#pragma mark - Private Methods

- (void)showAlertView
{
	UIView *popupView = [self viewWithTag:POP_VIEW_TAG];
    popupView.transform = CGAffineTransformMakeScale(.2, .2);
    popupView.alpha = 0;
    
    [UIView animateWithDuration:0.35 animations:^{
        popupView.alpha = 1;
        popupView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)closeAlertView
{
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

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    
    if (animated) {
        [self showAlertView];
    }
}

// 왼쪽 버튼 시
- (void)confirmPopupViewWithButton:(UIButton*)sender
{
    // tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidConfirm)])
    {
        [self.delegate popupViewDidConfirm];
    }
    
    
    if ([(UIButton *)[self viewWithTag:1267] isSelected])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"SMSNotiType"];
        NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
        [defaults setObject:currentDate forKey:@"SMSNotiDate"];
        [defaults synchronize];
    }
    
    // 만기예정 상품 안내 팝업이 떠있는 경우 제거
    for (UIViewController *viewController in AppDelegate.navigationController.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(@"SHBAccountMenuListViewController")]) {
            [viewController performSelector:@selector(expiryPopupClose)];
            
            break;
        }
    }
    
    // dismiss self
    [self closeAlertView];
    [AppDelegate.navigationController fadePopToRootViewController];
    SHBSmithingGuideViewController *viewcontroller = [[SHBSmithingGuideViewController alloc] initWithNibName:@"SHBSmithingGuideViewController" bundle:nil];
    [AppDelegate.navigationController pushFadeViewController:viewcontroller];
    [viewcontroller release];
}

// 확인 및 오른쪽 버튼 시
- (void)closePopupViewWithButton:(UIButton*)sender
{
	// tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidCancel)])
    {
        [self.delegate popupViewDidCancel];
    }
    
    if ([(UIButton *)[self viewWithTag:1267] isSelected])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:@"SMSNotiType"];
        NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
        [defaults setObject:currentDate forKey:@"SMSNotiDate"];
        [defaults synchronize];
    }
    
    // dismiss self
    [self closeAlertView];
}

- (void)logoutClose
{
    [self closeAlertView];
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc
{
    self.mainView = nil;
    [super dealloc];
}

@end
