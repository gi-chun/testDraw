//
//  SHBForeignerStep2ViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBSecureTextField.h"

@interface SHBForeignerStep2ViewController : SHBBaseViewController <UIScrollViewDelegate, UITextFieldDelegate, SHBTextFieldDelegate, SHBSecureDelegate>{
	IBOutlet UIScrollView		*scrollView;
	IBOutlet UIView				*mainView;
	IBOutlet SHBSecureTextField	*idx1TextField;
	IBOutlet SHBTextField		*idx2TextField;
	IBOutlet SHBSecureTextField	*idx3SecureField;
	IBOutlet SHBTextField		*idx4TextField;
	IBOutlet SHBSecureTextField	*idx5SecureField;
	IBOutlet SHBSecureTextField	*idx6SecureField;
	
	
	int		indexCurrentField;
	
	BOOL	isCheckAccount;
	BOOL	isCheckDupliID;
	
	NSString	*accountPassword;
	NSString	*idPassword1;
	NSString	*idPassword2;
	NSString	*userName;
}

@property (nonatomic, retain) NSString *accountPassword;
@property (nonatomic, retain) NSString *idPassword1;
@property (nonatomic, retain) NSString *idPassword2;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *encJumin;

- (IBAction)buttonPressed:(UIButton*)sender;

- (void)clearData;

@end
