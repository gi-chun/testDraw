//
//  SHBSmartCardTelStipulationViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 16..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 알림 - 스마트명함
 전화상담 신청
 */

@protocol SHBSmartCardTelStipulationDelegate <NSObject>

- (void)smartCardTelStipulationBack;

@end
@interface SHBSmartCardTelStipulationViewController : SHBBaseViewController <UIWebViewDelegate>


@property (assign, nonatomic) id<SHBSmartCardTelStipulationDelegate> delegate;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIScrollView *mainSV;
@property (retain, nonatomic) IBOutlet UIView *stipulationView;
//@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet SHBWebView *webView;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *useEssentialCollection; // 1. 필수적 정보
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *useSelectCollection; // 1. 선택적 정보
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *useInherentCollection; // 2. 고유식별정보
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;
@end
