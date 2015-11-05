//
//  UINavigationController+SlideUpDown.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "UINavigationController+SlideUpDown.h"

@implementation UINavigationController (SlideUpDown)

- (void)pushSlideUpViewController:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
	transition.subtype = kCATransitionFromTop;
	[self.view.layer addAnimation:transition forKey:nil];
	
	[self pushViewController:viewController animated:NO];
}

- (void)PopSlideDownViewController
{
	CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
	transition.subtype = kCATransitionFromBottom;
	[self.view.layer addAnimation:transition forKey:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[self popViewControllerAnimated:NO];
}

@end
