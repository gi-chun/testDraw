//
//  UIAlertView+Error.m
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "UIAlertView+Error.h"

@implementation UIAlertView (Error)

- (UIAlertView *)showWithError:(NSError *)error
{
    UIAlertView *alert = [[[UIAlertView alloc]
                          initWithTitle:[error localizedDescription]
                          message:[error localizedRecoverySuggestion]
                          delegate:nil
                          cancelButtonTitle:@"확인"
                          otherButtonTitles:nil]
                          autorelease];
    
    [alert show];
    return alert;
}

@end
