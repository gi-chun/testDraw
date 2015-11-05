//
//  SHBSearchPopupSettingViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 25..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBSearchPopupSettingViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutlet UIButton *btnSet;
@property (retain, nonatomic) IBOutlet UIButton *btnNoSet;

- (IBAction)radioBtnAction:(UIButton *)sender;
- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
