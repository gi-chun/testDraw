//
//  SHBCertIssueStep7ViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBPopupView.h"

@interface SHBCertIssueStep7ViewController : SHBBaseViewController <SHBSecureDelegate, SHBPopupViewDelegate>

@property (nonatomic, retain) NSString *encryptCertPwd1;
@property (nonatomic, retain) NSString *encryptCertPwd2;
@property (nonatomic, retain) IBOutlet SHBDataSet *transDataSet;

@property (nonatomic, retain) IBOutlet SHBSecureTextField *certPwdTextField;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *certPwdConfirmTextField;
@property (nonatomic, assign) BOOL isFirstLoginSetting;
@property (nonatomic, retain) IBOutlet UIView *secureGuideView;

- (IBAction) confirmClick:(id)sender; //확인
- (IBAction) cancelClick:(id)sender; //취소
- (IBAction) secureGuide:(id)sender; //암호설정가이드
@end
