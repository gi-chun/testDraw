//
//  UINavigationController+Fade.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationController (Fade)

- (void)pushFadeViewController:(UIViewController *)viewController;
- (void)fadePopViewController;
- (void)fadePopToRootViewController;
- (void)fadePopToViewController:(UIViewController *)viewController;
- (void)popToRootWithFadePushViewController:(UIViewController *)viewController;

@end