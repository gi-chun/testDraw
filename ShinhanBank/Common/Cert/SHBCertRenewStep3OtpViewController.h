//
//  SHBCertRenewStep3OtpViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBCertRenewStep3OtpViewController : SHBBaseViewController  <SHBSecureDelegate,UITextFieldDelegate, SHBTextFieldDelegate>

@property (nonatomic, retain) NSString *encryptPwd1;
@property (nonatomic, retain) NSString *encryptPwd2;

@property (nonatomic,retain) IBOutlet SHBSecureTextField *accountTransferPwdTextField;
@property (nonatomic,retain) IBOutlet SHBSecureTextField *accountOtpPwdTextField;

@property (nonatomic, retain) IBOutlet SHBTextField *accountEmailTextField;
@property (nonatomic, retain) IBOutlet SHBTextField *accountPhoneTextField;

@property (nonatomic, retain) IBOutlet SHBDataSet *transDataSet;

@property (nonatomic, assign) BOOL isFirstLoginSetting;

- (IBAction) confirmClick:(id)sender; //확인
- (IBAction) cancelClick:(id)sender; //취소
- (IBAction) accountTransferClick:(id)sender; //확인
- (IBAction) accountOtpPwdClick:(id)sender; //취소

@end
