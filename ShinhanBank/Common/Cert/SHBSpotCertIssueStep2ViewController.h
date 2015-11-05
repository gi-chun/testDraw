//
//  SHBSpotCertIssueStep2ViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 14. 6. 12..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSpotCertIssueStep2ViewController : SHBBaseViewController<SHBSecureDelegate>

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
