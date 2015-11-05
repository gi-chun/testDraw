//
//  UINavigationController+Rotate.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "UINavigationController+Rotate.h"

@implementation UINavigationController (Rotate)

- (BOOL)shouldAutorotate
{
    // 없는 경우가 있네...
    if([self.viewControllers count] == 0) return NO;
    return [self.viewControllers[0] shouldAutorotate];
    
}
- (NSUInteger) supportedInterfaceOrientations
{
    return [self.viewControllers[0] supportedInterfaceOrientations];
}

@end
