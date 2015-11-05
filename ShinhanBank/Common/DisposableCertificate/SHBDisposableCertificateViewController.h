//
//  SHBDisposableCertificateViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 7. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBTextField.h"

@protocol SHBDisposableCertificateDelegate <NSObject>

- (void)disposableCertificateCancel;

@end

@interface SHBDisposableCertificateViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate>
{
    IBOutlet	UIView			*_stepView;
	IBOutlet	SHBTextField	*_textField;
    IBOutlet    UILabel         *subTitleLabel;
    
	NSString *_nextViewControlName;
    
	int nextStep;
	int totalStep;
    int infoCount;
}

@property (assign, nonatomic) id<SHBDisposableCertificateDelegate> delegate;

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
      nextViewController:(NSString *)nextViewController;

@end
