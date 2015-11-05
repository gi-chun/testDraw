//
//  SHBMobileCertificateStep2ViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@protocol SHBMoblieCertificateStep2Delegate <NSObject>

- (void)mobileCertificateStep2Back;

@end

@interface SHBMobileCertificateStep2ViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate>
{
	IBOutlet	UIView			*_stepView;
    IBOutlet    UIView          *mainView;
	
	NSString *_nextViewControlName;
	
	NSMutableDictionary *mobileDic;
}

@property (assign, nonatomic) id<SHBMoblieCertificateStep2Delegate> delegate;
@property (assign, nonatomic) BOOL isCertView;
@property (nonatomic, assign) SERVICE_TYPE_SEQUENCE serviceSeq;

@property(nonatomic, retain) IBOutlet SHBTextField *certTextField;
@property (nonatomic, retain) IBOutlet UILabel *subTitleLabel;

- (void)executeWithTitle:(NSString*)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString*)nextCtrlName Info:(NSMutableDictionary*)infoDic;


@end
