//
//  UINavigationController+Fade.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "UINavigationController+Fade.h"

@implementation UINavigationController (Fade)

- (void)pushFadeViewController:(UIViewController *)viewController
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];
	
	[self pushViewController:viewController animated:NO];
}

- (void)fadePopViewController
{
	CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[self popViewControllerAnimated:NO];
}

- (void)fadePopToRootViewController
{
	CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];
    
    for (int i = 1; i < ([AppDelegate.navigationController.viewControllers count]); i++)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:AppDelegate.navigationController.viewControllers[i]];
    }
    
	[self popToRootViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popToRootViewControllerNotification"
                                                        object:nil];
}

- (void)fadePopToViewController:(UIViewController *)viewController
{
	CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];
    
	[self popToViewController:viewController animated:NO];
}

- (void)popToRootWithFadePushViewController:(UIViewController *)viewController
{
    [self popToRootViewControllerAnimated:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popToRootViewControllerNotification"
                                                        object:nil];
    
    [self pushFadeViewController:viewController];
}

@end