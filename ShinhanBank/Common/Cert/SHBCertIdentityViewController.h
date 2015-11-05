//
//  SHBCertIdentityViewController.h
//  ShinhanBank
//
//  Created by RedDragon on 12. 11. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBCertIdentityViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UILabel *subjectLabel;
@property (nonatomic, retain) IBOutlet UILabel *issuerAliasLabel;
@property (nonatomic, retain) IBOutlet UILabel *notAfterLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *notAfterTitle;

@property (nonatomic, retain) IBOutlet UIButton *confirmBtn;
@property (nonatomic, retain) IBOutlet UIImageView *certImageView;
@end
