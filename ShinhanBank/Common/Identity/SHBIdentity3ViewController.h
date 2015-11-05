//
//  SHBIdentity3ViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 13. 9. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBIdentity3Delegate <NSObject>

- (void)identity3ViewControllerCancel;

@end

@interface SHBIdentity3ViewController : SHBBaseViewController

@property(nonatomic, retain) IBOutlet UIButton *smsButton;
@property(nonatomic, retain) IBOutlet UIButton *arsButton;
@property(nonatomic, retain) IBOutlet UIButton *foreignButton;
@property(nonatomic, retain) IBOutlet UIButton *confirmButton;
@property(nonatomic, retain) IBOutlet UIButton *cancelButton;
@property(nonatomic, retain) IBOutlet UILabel *subTitleLabel;

@property (nonatomic, assign) SERVICE_TYPE_SEQUENCE serviceSeq;
@property (nonatomic, assign) id<SHBIdentity3Delegate> delegate;
@property (nonatomic, assign) BOOL is100Over;
//예금, 적금 해지시 추가인증변경(영업일 오전 9시~ 오후 6시일경우 SMS + ARS 인증 모두 진행
//@property (nonatomic, assign) BOOL isAllIdenty; //모두 인증을 받아야 되는지 플래그
//@property (nonatomic, assign) BOOL isSMSIdenty; //sms 인증을 받았는지
//@property (nonatomic, assign) BOOL isARSIdenty; //ars 인증을 받았는지
- (IBAction)buttonTouched:(id)sender;

- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName;

- (void)subTitle:(NSString *)subTitle;

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
      nextViewController:(NSString *)nextViewController;
@end
