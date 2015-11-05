//
//  SHBIdentity2ViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 13. 8. 2..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBIdentity2Delegate <NSObject>

- (void)identity2ViewControllerCancel;

@end

@interface SHBIdentity2ViewController : SHBBaseViewController<UIScrollViewDelegate>

@property(nonatomic, retain) IBOutlet UIButton *smsButton;
@property(nonatomic, retain) IBOutlet UIButton *arsButton;
@property(nonatomic, retain) IBOutlet UILabel *subTitleLabel;

@property(nonatomic, retain) IBOutlet UIButton *foreignButton;
@property(nonatomic, retain) IBOutlet UIButton *confirmButton;
@property(nonatomic, retain) IBOutlet UIButton *cancelButton;

@property (nonatomic, assign) SERVICE_TYPE_SEQUENCE serviceSeq;
@property (nonatomic, assign) id<SHBIdentity2Delegate> delegate;


- (IBAction)buttonTouched:(id)sender;

- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName;

- (void)subTitle:(NSString *)subTitle;

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
      nextViewController:(NSString *)nextViewController;
@end
