//
//  SHBOldSecurityChangeViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 8. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBOldSecurityChangeViewController : SHBBaseViewController //SHBBaseViewController // UIViewController

@property (retain, nonatomic) IBOutlet UIButton *checkBtn; // 예, 동의합니다.
@property (retain, nonatomic) IBOutlet UILabel *infoLabel1;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel2;

@property(nonatomic, retain) IBOutlet UILabel *sumLimitLabel;

- (IBAction)okButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)checkButton:(id)sender;
@end
