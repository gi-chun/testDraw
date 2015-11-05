//
//  UINavigationController+Rotate.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Rotate)

- (BOOL)shouldAutorotate;
- (NSUInteger) supportedInterfaceOrientations;

@end
