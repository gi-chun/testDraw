//
//  SHBIdentity3ViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 13. 9. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBIdentity4Delegate <NSObject>

- (void)identity4ViewControllerCancel;

@end

@interface SHBIdentity4ViewController : SHBBaseViewController


@property(nonatomic, retain) IBOutlet UIButton *smsButton;
@property(nonatomic, retain) IBOutlet UIButton *arsButton;
@property(nonatomic, retain) IBOutlet UIButton *foreignButton;
@property(nonatomic, retain) IBOutlet UIButton *confirmButton;
@property(nonatomic, retain) IBOutlet UIButton *cancelButton;
@property(nonatomic, retain) IBOutlet UILabel *subTitleLabel;

@property (nonatomic, assign) SERVICE_TYPE_SEQUENCE serviceSeq;
@property (nonatomic, assign) id<SHBIdentity4Delegate> delegate;

//안심거래서비스

- (IBAction)buttonTouched:(id)sender;

- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName;

- (void)subTitle:(NSString *)subTitle;

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
      nextViewController:(NSString *)nextViewController;
@end
