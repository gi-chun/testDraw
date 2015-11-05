//
//  SHBQryServiceViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBSecureTextField.h"

@interface SHBQryServiceViewController : SHBBaseViewController<UIScrollViewDelegate, UITextFieldDelegate, SHBTextFieldDelegate, SHBSecureDelegate>{
	IBOutlet UIScrollView	*scrollView;
	IBOutlet UIView			*mainView;
	IBOutlet UIImageView	*boxTopImageView;
	IBOutlet UIImageView	*boxBtmImageView;
	IBOutlet UIImageView	*boxMidImageView;
	IBOutlet UILabel		*_userIdLabel;
	IBOutlet UILabel		*_userNmLabel;
	
	IBOutlet SHBTextField		*empTextField;
	IBOutlet SHBTextField		*accTextField;
	IBOutlet SHBSecureTextField	*pssSecureField;
	
	BOOL	isViewContract;
	BOOL	isCheckAgreement;
	
	int		indexCurrentField;
	
	NSString	*accountPassword;
	
	SHBDataSet	*svcH1009Dic;
}

@property (nonatomic, retain) NSString *accountPassword;


- (void)executeWithUser:(NSString*)aUserId UserName:(NSString*)aUserNm;

- (IBAction)buttonPressed:(UIButton*)sender;


@end
