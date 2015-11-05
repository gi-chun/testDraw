//
//  SHBNoCertForCertLogInViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBNoCertForCertLogInViewController : SHBBaseViewController

@property(nonatomic, retain) IBOutlet UILabel *certCopyPCBtnLabel;
@property(nonatomic, retain) IBOutlet UILabel *certCopyQRBtnLabel;
@property(nonatomic, retain) IBOutlet UILabel *certIssueBtnLabel;
@property(nonatomic, retain) IBOutlet UIButton *idBtn;
- (IBAction) certCopyPCClick:(id)sender;
- (IBAction) certCopyQRClick:(id)sender;
- (IBAction) certIssueClick:(id)sender;
- (IBAction) idpwdClick:(id)sender;

@end
