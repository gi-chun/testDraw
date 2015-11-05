//
//  SHBARSCertificateStep2ViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 7. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBARSCertificateStep2Delegate <NSObject>

- (void)ARSCertificateStep2Back;

@end

@interface SHBARSCertificateStep2ViewController : SHBBaseViewController
{
	IBOutlet	UIView			*_stepView;
    IBOutlet UIButton *agreeButton;
	
	NSString *_nextViewControlName;
	
	NSMutableDictionary *infoDic;
    
    NSString *realNumber, *certCode;
}

@property (nonatomic, assign) id<SHBARSCertificateStep2Delegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *subTitleLabel;
@property (nonatomic, retain) NSString *realNumber, *certCode, *arsType, *serviceCode;
@property (nonatomic, assign) SERVICE_TYPE_SEQUENCE serviceSeq;
@property (nonatomic, assign) BOOL *isAllidentity;

@property (nonatomic, assign) double arsStartTime;
@property (nonatomic, assign) double arsCancelTime;
@property (nonatomic, assign) double arsDifferTime;
- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName Info:(NSDictionary *)info;

@end
