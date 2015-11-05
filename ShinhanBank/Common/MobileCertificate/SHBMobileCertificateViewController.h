//
//  SHBMobileCertificateViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@protocol SHBMobileCertificateDelegate <NSObject>

- (void)mobileCertificateCancel;

@end

typedef enum
{
    MOBILE_INFOVIEW_1 = 0
    
}MOBILE_INFOVIEW_COUNT;


@interface SHBMobileCertificateViewController : SHBBaseViewController <UIScrollViewDelegate, UITextFieldDelegate, SHBTextFieldDelegate>
{
	IBOutlet	UIView			*_stepView;
	IBOutlet	SHBTextField	*phoneNumberTF;
	IBOutlet	UIButton		*agreeButton;
	IBOutlet	UIButton		*confirmButton;
	IBOutlet	UIButton		*cancelButton;
    IBOutlet    UILabel         *subTitleLabel;
    IBOutlet    UIView          *bottomView;
    IBOutlet    UIView          *infoView1;
    IBOutlet    UIView          *infoView2;
    IBOutlet    UILabel         *bottomLabel;
	
	NSString *_nextViewControlName;
	NSString *titleName;
	
	NSMutableDictionary *mobileInfoDic;
	
	int nextStep;
	int totalStep;
}

@property (assign, nonatomic) id<SHBMobileCertificateDelegate> delegate;

@property (nonatomic, assign) SERVICE_TYPE_SEQUENCE serviceSeq;


- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName;

- (void)subTitle:(NSString *)subTitle infoViewCount:(MOBILE_INFOVIEW_COUNT)infoViewCount;

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
           infoViewCount:(MOBILE_INFOVIEW_COUNT)infoViewCount
      nextViewController:(NSString *)nextViewController;

@end
