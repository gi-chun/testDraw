//
//  SHBSecureKeyPadSettingViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 8. 14..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSecureKeyPadSettingViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIButton *btnSet;
@property (retain, nonatomic) IBOutlet UIButton *btnNoSet;

- (IBAction)radioBtnAction:(UIButton *)sender;
- (IBAction)confirmBtnAction:(UIButton *)sender;
- (IBAction)cancelBtnAction:(UIButton *)sender;

@end
