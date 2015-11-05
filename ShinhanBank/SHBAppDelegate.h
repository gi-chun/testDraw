//
//  LPAppDelegate.h
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/// 10분 동안 접속 유지 한다.
#define KEEP_ALIVE_TIMEOUT 60*10
#define KEEP_ALIVE_TIMEOUTWARNING 60*9

#import <UIKit/UIKit.h>
#import "UINavigationController+Fade.h"
#import "UINavigationController+Rotate.h"
#import "UINavigationController+SlideUpDown.h"
#import "SmartSafeAgent.h"
#import "antidebugger.h"

@interface SHBAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>
{
    NSTimer *_timer10; // 10분 타이머.
    NSTimer *_timer9; // 9분 타이머.
    NSTimer *_timer10ForNFIlter; // 10분마다 nFIlterPK 값을 다시 가져온다.
    int limtTime;
    double startTime;
}

/**
 스마트 세이프 에이전트.
 */
@property (nonatomic, retain) SmartSafeAgent *ssAgent;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

///moasign용
@property (strong, nonatomic) NSString *moaSignUrl;
@property (strong, nonatomic) NSString *moaSignCurrentFunctionString;
@property (strong, nonatomic) NSTimer *moaSignTimer;

- (NSString *)getSSODeviceID;
- (void) startTimer;
- (void) initTimer;
- (void) initNFlterTimer;
//- (void) hideKeyboard;
- (void) showProgressView;
- (void) closeProgressView;
@end
