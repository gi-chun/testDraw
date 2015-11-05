//
//  SHBCertIdentyConfirmViewController.h
//  ShinhanBank
//
//  Created by RedDragon on 12. 11. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBCertIDConfirmViewController : SHBBaseViewController <SHBSecureDelegate>

@property (nonatomic, retain) IBOutlet UILabel *subjectLabel;
@property (nonatomic, retain) IBOutlet UILabel *issuerAliasLabel;
@property (nonatomic, retain) IBOutlet UILabel *notAfterLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;

@property (nonatomic, retain) IBOutlet UILabel *notAfterTitle;
@property (nonatomic, retain) IBOutlet UIButton *confirmBtn;
//@property (nonatomic, retain) IBOutlet UIButton *cancelBtn;

@property (nonatomic, retain) IBOutlet SHBSecureTextField *ssnTextField;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *certPwdTextField;
@property (nonatomic, retain) IBOutlet UIImageView *certImageView;

@property (nonatomic, retain) NSData *certData;
@property (nonatomic, retain) NSData *ssnData;

- (IBAction) confirmClick:(id)sender;
//- (IBAction) cancelClick:(id)sender;

@end
