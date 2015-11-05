//
//  SHBNotificationSettingViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 환경설정 > 알림설정
 */

#import "SHBBaseViewController.h"

@interface SHBNotificationSettingViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIButton *btnSet;
@property (retain, nonatomic) IBOutlet UIButton *btnNoSet;
@property (retain, nonatomic) IBOutlet UIImageView *ivBox;

- (IBAction)radioBtnAction:(UIButton *)sender;
- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
