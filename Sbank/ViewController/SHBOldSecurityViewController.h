//
//  SHBOldSecurityViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 8. 2..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
#import "SHBBaseViewController.h"


@interface SHBOldSecurityViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIButton *checkBtn; // 예, 동의합니다.
@property (retain, nonatomic) NSArray *dataCheckList;

- (IBAction)cancelButton:(id)sender;
- (IBAction)okButton:(id)sender;
- (IBAction)checkButton:(id)sender;
@end;


