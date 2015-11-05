//
//  SHBSmartCareTelStipulationViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 1. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 알림 - 스마트 케어 매니저
 전화상담 신청
 */

@protocol SHBSmartCareTelStipulationDelegate <NSObject>

- (void)smartCareTelStipulationBack;

@end

@interface SHBSmartCareTelStipulationViewController : SHBBaseViewController <UIWebViewDelegate>

@property (assign, nonatomic) id<SHBSmartCareTelStipulationDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIScrollView *mainSV;
@property (retain, nonatomic) IBOutlet UIView *stipulationView;
//@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *useEssentialCollection; // 1. 필수적 정보
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *useSelectCollection; // 1. 선택적 정보
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *useInherentCollection; // 2. 고유식별정보

@end
