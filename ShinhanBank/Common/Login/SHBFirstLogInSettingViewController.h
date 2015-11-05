//
//  SHBFirstLogInSettingViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBFirstLogInSettingViewController : SHBBaseViewController

@property(nonatomic, retain) IBOutlet UILabel *certCopyPCBtnLabel;
@property(nonatomic, retain) IBOutlet UILabel *certCopyQRBtnLabel;
@property(nonatomic, retain) IBOutlet UILabel *certIssueBtnLabel;

- (IBAction) certCopyPCClick:(id)sender;
- (IBAction) certCopyQRClick:(id)sender;
- (IBAction) certIssueClick:(id)sender;
- (IBAction) idpwdClick:(id)sender;
- (IBAction) cancelClick:(id)sender;

@end
