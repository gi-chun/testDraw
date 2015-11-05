//
//  SHBSignupServiceStep2ViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSignupServiceStep2ViewController : SHBBaseViewController <UIScrollViewDelegate> {
	
	IBOutlet UIScrollView	*_scrollView;
	IBOutlet UIView			*_mainView;
	IBOutlet UIButton		*viewAgreeButton;
	IBOutlet UIButton		*compulsoryButton1;
	IBOutlet UIButton		*compulsoryButton2;
	IBOutlet UIButton		*optionButton1;
	IBOutlet UIButton		*optionButton2;
	IBOutlet UIButton		*idButton1;
	IBOutlet UIButton		*idButton2;
	IBOutlet UIButton		*confirmButton;
	IBOutlet UIButton		*cancelButton;
	IBOutlet UIImageView	*boxInfoImageView;
	IBOutlet UIImageView	*boxImageView;
	
	BOOL	isCheckAgreeviewer;
}

- (IBAction)buttonPressed:(UIButton*)sender;

@end
