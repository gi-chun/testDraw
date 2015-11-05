//
//  SHBSignupServiceStep1ViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBSignupServiceStep1ViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate>{
	IBOutlet UIView			*mainView;
	IBOutlet UIView			*titleView;
	IBOutlet SHBTextField	*empTextField;
	IBOutlet UIButton		*agreeButton;
	IBOutlet UIImageView	*boxImageView;
	
	BOOL	isCheckAttention;
	BOOL	isCheckAgreement;
}


- (IBAction)buttonPressed:(UIButton*)sender;

@end
