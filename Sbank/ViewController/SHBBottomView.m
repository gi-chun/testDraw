//
//  SHBBottomView.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBottomView.h"

@implementation SHBBottomView
{
    int curTag;
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		// 알림, 마이메뉴, 앱더보기, 환경설정, 로그아웃 버튼
		UIButton *buttons1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 49)];
		UIButton *buttons2 = [[UIButton alloc] initWithFrame:CGRectMake(64*1, 0, 64, 49)];
		UIButton *buttons3 = [[UIButton alloc] initWithFrame:CGRectMake(64*2, 0, 64, 49)];
		UIButton *buttons4 = [[UIButton alloc] initWithFrame:CGRectMake(64*3, 0, 64, 49)];
		UIButton *buttons5 = [[UIButton alloc] initWithFrame:CGRectMake(64*4, 0, 64, 49)];
		[buttons1 setAccessibilityLabel:@"알림"];
		[buttons1 setImage:[UIImage imageNamed:@"footermenu_1.png"] forState:UIControlStateNormal];
		[buttons1 setImage:[UIImage imageNamed:@"footermenu_1_focus.png"] forState:UIControlStateHighlighted];
		[buttons1 setImage:[UIImage imageNamed:@"footermenu_1_focus.png"] forState:UIControlStateDisabled];
		[buttons2 setAccessibilityLabel:@"마이메뉴"];
		[buttons2 setImage:[UIImage imageNamed:@"footermenu_2.png"] forState:UIControlStateNormal];
		[buttons2 setImage:[UIImage imageNamed:@"footermenu_2_focus.png"] forState:UIControlStateHighlighted];
		[buttons2 setImage:[UIImage imageNamed:@"footermenu_2_focus.png"] forState:UIControlStateDisabled];
		[buttons3 setAccessibilityLabel:@"앱더보기"];
		[buttons3 setImage:[UIImage imageNamed:@"footermenu_3.png"] forState:UIControlStateNormal];
		[buttons3 setImage:[UIImage imageNamed:@"footermenu_3_focus.png"] forState:UIControlStateHighlighted];
		[buttons3 setImage:[UIImage imageNamed:@"footermenu_3_focus.png"] forState:UIControlStateDisabled];
		[buttons4 setAccessibilityLabel:@"환경설정"];
		[buttons4 setImage:[UIImage imageNamed:@"footermenu_4.png"] forState:UIControlStateNormal];
		[buttons4 setImage:[UIImage imageNamed:@"footermenu_4_focus.png"] forState:UIControlStateHighlighted];
		[buttons4 setImage:[UIImage imageNamed:@"footermenu_4_focus.png"] forState:UIControlStateDisabled];
		if (AppInfo.isLogin == LoginTypeNo){
			[buttons5 setAccessibilityLabel:@"로그인"];
			[buttons5 setImage:[UIImage imageNamed:@"footermenu_6.png"] forState:UIControlStateNormal];
			[buttons5 setImage:[UIImage imageNamed:@"footermenu_6_focus.png"] forState:UIControlStateHighlighted];
			
		}else{
			[buttons5 setAccessibilityLabel:@"로그아웃"];
			[buttons5 setImage:[UIImage imageNamed:@"footermenu_5_focus.png"] forState:UIControlStateNormal];
			[buttons5 setImage:[UIImage imageNamed:@"footermenu_5.png"] forState:UIControlStateHighlighted];
			
		}
		
		[buttons5 setImage:[UIImage imageNamed:@"footermenu_6.png"] forState:UIControlStateNormal];
		[buttons5 setImage:[UIImage imageNamed:@"footermenu_6_focus.png"] forState:UIControlStateHighlighted];
		
		[buttons1 setTag:1];
		[buttons2 setTag:2];
		[buttons3 setTag:3];
		[buttons4 setTag:4];
		[buttons5 setTag:5];
		
		[buttons1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[buttons2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[buttons3 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[buttons4 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[buttons5 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:buttons1];
		[self addSubview:buttons2];
		[self addSubview:buttons3];
		[self addSubview:buttons4];
		[self addSubview:buttons5];
		
		[buttons1 release];
		[buttons2 release];
		[buttons3 release];
		[buttons4 release];
		[buttons5 release];
    }
    return self;
}

- (void)buttonPressed:(UIButton*)sender{
    
//    if (sender.tag == 5)
//    {
//        curTag = 0;
//    } else
//    {
//        curTag = sender.tag;
//    }
//    
//    if ((AppInfo.indexQuickMenu == curTag) && (sender.tag != 5))
//    {
//        return;
//    }
    
	//AppInfo.indexQuickMenu = sender.tag;
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(pushViewControlByBottomMenu:)]) {
        [self.delegate pushViewControlByBottomMenu:sender.tag];
    }
	
}

- (void)blockAccessbility:(BOOL)isBolck
{
    for (int i = 1; i < 6; i++)
    {
        if (isBolck)
        {
           [[self viewWithTag:i] setIsAccessibilityElement:NO];
        } else
        {
           [[self viewWithTag:i] setIsAccessibilityElement:YES];
        }
    
        
    }
}
- (void)changeLogInOut:(BOOL)logIn
{
    
	UIButton *logButton = (UIButton *)[self viewWithTag:5];
    
	if (logIn) {
		[logButton setAccessibilityLabel:@"로그아웃"];
		[logButton setImage:[UIImage imageNamed:@"footermenu_5_focus.png"] forState:UIControlStateNormal];
		[logButton setImage:[UIImage imageNamed:@"footermenu_5.png"] forState:UIControlStateHighlighted];
        
	}
    else {
		[logButton setAccessibilityLabel:@"로그인"];
		[logButton setImage:[UIImage imageNamed:@"footermenu_6.png"] forState:UIControlStateNormal];
		[logButton setImage:[UIImage imageNamed:@"footermenu_6_focus.png"] forState:UIControlStateHighlighted];
	}
    
    
}

- (void)changeNotiImage:(int)notiState
{
    UIButton *logButton1 = (UIButton*)[self viewWithTag:1];
    
    if (notiState == 0) {
        [logButton1 setAccessibilityLabel:@"알림"];
		[logButton1 setImage:[UIImage imageNamed:@"footermenu_1.png"] forState:UIControlStateNormal];
		[logButton1 setImage:[UIImage imageNamed:@"footermenu_1_focus.png"] forState:UIControlStateHighlighted];
		[logButton1 setImage:[UIImage imageNamed:@"footermenu_1_focus.png"] forState:UIControlStateDisabled];
    }
    else if (notiState == 1) {
        UIButton *button4 = (UIButton *)[self viewWithTag:4];
        
        [button4 setAccessibilityLabel:@"업데이트"];
        [button4 setImage:[UIImage imageNamed:@"footermenu_4_1.png"] forState:UIControlStateNormal];
		[button4 setImage:[UIImage imageNamed:@"footermenu_4_1_focus.png"] forState:UIControlStateHighlighted];
		[button4 setImage:[UIImage imageNamed:@"footermenu_4_1_focus.png"] forState:UIControlStateDisabled];
    } else if (notiState == 2) {
        [logButton1 setAccessibilityLabel:@"새알림"];
        [logButton1 setImage:[UIImage imageNamed:@"footermenu_1_1.png"] forState:UIControlStateNormal];
		[logButton1 setImage:[UIImage imageNamed:@"footermenu_1_1_focus.png"] forState:UIControlStateHighlighted];
		[logButton1 setImage:[UIImage imageNamed:@"footermenu_1_1_focus.png"] forState:UIControlStateDisabled];
    }
}

@end
