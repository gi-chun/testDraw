//
//  SHBBottomViewDelegate.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SHBBottomViewDelegate <NSObject>

@optional

- (void)pushViewControlByBottomMenu:(int)menuTag;

@end
