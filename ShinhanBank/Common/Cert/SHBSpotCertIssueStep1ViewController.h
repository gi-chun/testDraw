//
//  SHBSpotCertIssueStep1ViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 14. 6. 11..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBSpotCertIssueStep1ViewController : SHBBaseViewController<SHBSecureDelegate>

@property (nonatomic, retain) NSString *encryptSsn;
@property (nonatomic, retain) NSString *encryptAuthCode;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *ssnPwdTextField;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *authCodeTextField;

@property (nonatomic, retain) IBOutlet SHBTextField *authCode1TextField;
@property (nonatomic, retain) IBOutlet SHBTextField *authCode2TextField;

- (IBAction)confirmClicked:(id)sender;
- (IBAction)cancelClicked:(id)sender;
@end
