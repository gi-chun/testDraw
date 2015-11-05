//
//  UINavigationController+SlideUpDown.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationController (SlideUpDown)

- (void)pushSlideUpViewController:(UIViewController *)viewController;
- (void)PopSlideDownViewController;

@end