//
//  SHBOver14yearsStep2ViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 20..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBSecureTextField.h"

@interface SHBOver14yearsStep2ViewController : SHBBaseViewController <UIScrollViewDelegate, UITextFieldDelegate, SHBTextFieldDelegate, SHBSecureDelegate>{
	IBOutlet UIView				*mainView;
	IBOutlet SHBTextField		*idx1TextField;
	//IBOutlet SHBTextField		*idx2TextField;
    IBOutlet SHBSecureTextField	*idx2TextField;
	IBOutlet SHBTextField		*idx3TextField;
	IBOutlet SHBSecureTextField	*idx4SecureField;
	IBOutlet SHBTextField		*idx5TextField;
	IBOutlet SHBSecureTextField	*idx6SecureField;
	IBOutlet SHBSecureTextField	*idx7SecureField;
	IBOutlet SHBTextField		*idx8TextField;
	IBOutlet SHBTextField		*idx9TextField;
	IBOutlet SHBTextField		*idx10TextField;
	
	int		indexCurrentField;
	
	BOOL	isCheckAccount;
	BOOL	isCheckDupliID;
	BOOL	isRequestNameCert;
	
	NSString	*accountPassword;
	NSString	*idPassword1;
	NSString	*idPassword2;
	
	NSMutableDictionary	*svcH1009Dic;
}

@property (nonatomic, retain) NSString *accountPassword;
@property (nonatomic, retain) NSString *idPassword1;
@property (nonatomic, retain) NSString *idPassword2;
@property (nonatomic, retain) NSString *encJumin;
@property (nonatomic, retain) NSString *userName;

- (IBAction)buttonPressed:(UIButton*)sender;

- (void)clearData;

@end
