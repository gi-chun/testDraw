//
//  SHBSignupStep1ViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSignupStep1ViewController : SHBBaseViewController{
	IBOutlet UIImageView	*boxImageView;
	
	
	NSString *_nextViewControlName;
	BOOL	isCheckAgreement;
	BOOL	isViewContract;
}


- (void)executeWithStep:(int)step StepCnt:(int)stepCnt NextControllerName:(NSString*)nextCtrlName;

- (IBAction)buttonPressed:(UIButton*)sender;

@end
