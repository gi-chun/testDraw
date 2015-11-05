//
//  SHBView+Screenshot.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBView+Screenshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Screenshot)

- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
	
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}


@end
