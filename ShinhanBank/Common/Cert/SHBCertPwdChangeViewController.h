//
//  SHBCertPwdChangeViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"


@interface SHBCertPwdChangeViewController : SHBBaseViewController <SHBSecureDelegate>


@property (nonatomic, retain) IBOutlet UILabel *subjectLabel;
@property (nonatomic, retain) IBOutlet UILabel *issuerAliasLabel;
@property (nonatomic, retain) IBOutlet UILabel *notAfterLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *notAfterTitle;

@property (nonatomic, retain) IBOutlet UILabel *issuerAliasTitleLabel;            // 발급자 라벨.
@property (nonatomic, retain) IBOutlet UILabel *certificateOIDAliasTitleLabel;    // 구분 라벨.
@property (nonatomic, retain) IBOutlet UILabel *pwdTitle1;
@property (nonatomic, retain) IBOutlet UILabel *pwdTitle2;
@property (nonatomic, retain) IBOutlet UILabel *pwdTitle3;

@property (nonatomic, retain) IBOutlet SHBSecureTextField *pwOldTextField;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *pwNewTextField;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *pwNewConfirmTextField;

@property (nonatomic, retain) IBOutlet UIButton *confirmBtn;
@property (nonatomic, retain) IBOutlet UIImageView *certImageView;

- (IBAction) changePassword:(id)sender;
@end
