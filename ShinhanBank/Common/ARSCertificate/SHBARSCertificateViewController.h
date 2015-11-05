//
//  SHBARSCertificateViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 7. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBARSCertificateDelegate <NSObject>

- (void)ARSCertificateCancel;

@end

typedef enum
{
    ARS_INFOVIEW_1 = 0
    
}ARS_INFOVIEW_COUNT;

@interface SHBARSCertificateViewController : SHBBaseViewController <UIScrollViewDelegate>
{
	IBOutlet	UIView			*_stepView;
    
    IBOutlet    UIView          *infoView1;
    IBOutlet    UIView          *infoView2;
    IBOutlet    UIView          *infoView3;
    IBOutlet    UILabel         *subTitleLabel;
    
    IBOutlet    UIView          *bottomView;
    IBOutlet    UIView          *bottomView1;
    
    IBOutlet    UIButton        *numberBtn;
    IBOutlet    UIButton        *agreeButton;
    
    IBOutlet    UIButton        *numberBtn1;
    IBOutlet    UIButton        *agreeButton1;
	NSString *_nextViewControlName;
	NSString *titleName;
    
    
	NSMutableDictionary *infoDic;
    
	int nextStep;
	int totalStep;
    int infoCount;
}

@property (assign, nonatomic) id<SHBARSCertificateDelegate> delegate;
@property (nonatomic, assign) SERVICE_TYPE_SEQUENCE serviceSeq;
@property (nonatomic, retain) NSString *homeNumber;
@property (nonatomic, retain) NSString *jobNumber;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *mobileNumber;
@property (nonatomic, assign) BOOL *isAllidentity;
@property (nonatomic, retain) UILabel *subTitleLabel;

- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName;

- (void)subTitle:(NSString *)subTitle infoViewCount:(ARS_INFOVIEW_COUNT)infoViewCount;

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
           infoViewCount:(ARS_INFOVIEW_COUNT)infoViewCount
      nextViewController:(NSString *)nextViewController;
@end
