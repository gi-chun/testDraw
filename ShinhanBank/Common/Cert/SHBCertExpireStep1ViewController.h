//
//  SHBCertExpireStep1ViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBCertExpireStep1ViewController : SHBBaseViewController <SHBSecureDelegate,UITextFieldDelegate, SHBTextFieldDelegate>

@property (nonatomic, retain) NSString *encryptPwd;
@property (nonatomic, retain) NSString *encryptSsn;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *ssnPwdTextField;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *accountPwdTextField;

@property (nonatomic, retain) IBOutlet SHBTextField *accountTextField;

- (IBAction) confirmClick:(id)sender; //확인
- (IBAction) cancelClick:(id)sender; //취소

- (IBAction) ssnBtnClick:(id)sender; //주민번호
- (IBAction) accountPwdBtnClick:(id)sender; //계죄비밀번호
@end
