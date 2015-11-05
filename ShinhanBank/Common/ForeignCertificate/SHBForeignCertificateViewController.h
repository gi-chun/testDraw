//
//  SHBForeignCertificateViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 13. 9. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    FOREIGN_INFOVIEW_1 = 0
    
}FOREIGN_INFOVIEW_COUNT;

@interface SHBForeignCertificateViewController : SHBBaseViewController
{
    IBOutlet	UIView			*_stepView;
    
    IBOutlet    UIView          *infoView1;
    
    IBOutlet    UILabel         *subTitleLabel;
    
    IBOutlet    UIView          *bottomView;
    
    IBOutlet    UIButton        *numberBtn;
    IBOutlet    UIButton        *agreeButton;
    
	NSString *_nextViewControlName;
	NSString *titleName;
    
    
	NSMutableDictionary *infoDic;
    
	int nextStep;
	int totalStep;
    int infoCount;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, assign) SERVICE_TYPE_SEQUENCE serviceSeq;
@property (retain, nonatomic) IBOutlet UIButton *checkBtn; // 예, 동의합니다.

- (void)executeWithTitle:(NSString *)aTitle Step:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString *)nextCtrlName;

- (void)subTitle:(NSString *)subTitle infoViewCount:(FOREIGN_INFOVIEW_COUNT)infoViewCount;

- (void)executeWithTitle:(NSString *)aTitle
                subTitle:(NSString *)subTitle
                    step:(int)step
               stepCount:(int)stepCount
           infoViewCount:(FOREIGN_INFOVIEW_COUNT)infoViewCount
      nextViewController:(NSString *)nextViewController;

- (IBAction)okButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)checkButton:(id)sender;
@end
