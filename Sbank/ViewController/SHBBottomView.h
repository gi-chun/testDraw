//
//  SHBBottomView.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBottomViewDelegate.h"

@interface SHBBottomView : UIView {
	
	id <SHBBottomViewDelegate> delegate;
}

@property (nonatomic, assign) id/*<SHBBottomViewDelegate>*/ delegate;

- (void)changeLogInOut:(BOOL)logIn;	// 로그인아웃 이미치 교체
- (void)changeNotiImage:(int)notiState;
- (void)blockAccessbility:(BOOL)isBolck;
@end
