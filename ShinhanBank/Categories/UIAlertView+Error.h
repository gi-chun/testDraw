//
//  UIAlertView+Error.h
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Error)

/**
 에러 내용을 상세하게 보여 준다.
 
 @param error NSError.
 @return UIAlertView.
 */
- (UIAlertView *)showWithError:(NSError *)error;

@end
