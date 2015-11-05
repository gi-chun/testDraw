//
//  SHBOver14yesrsStep3ViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBOver14yearsStep3ViewController : SHBBaseViewController <UIScrollViewDelegate, UITextFieldDelegate, SHBTextFieldDelegate>{
	IBOutlet UIScrollView	*scrollView;
	IBOutlet UIView			*mainView;
	IBOutlet UIImageView	*boxTopImageView;
	IBOutlet UIImageView	*boxBtmImageView;
	IBOutlet UILabel		*_userIdLabel;
	IBOutlet UILabel		*_userNmLabel;
	
	IBOutlet SHBTextField	*empTextField;
	
	BOOL	isViewContract;
	BOOL	isCheckAgreement;
	
	NSMutableDictionary	*svcH1009Dic;
}

- (void)setH1009Dic:(NSMutableDictionary*)mDic;

- (IBAction)buttonPressed:(UIButton*)sender;

@end
