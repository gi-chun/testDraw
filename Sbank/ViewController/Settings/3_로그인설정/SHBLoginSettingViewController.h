//
//  SHBLoginSettingViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSelectBox.h"
#import "SHBListPopupView.h"

@interface SHBLoginSettingViewController : SHBBaseViewController <SHBSelectBoxDelegate, SHBListPopupViewDelegate>

/**
 기본 로그인
 */
@property (retain, nonatomic) IBOutlet UIButton *btnRadio1;

/**
 공인인증서 로그인
 */
@property (retain, nonatomic) IBOutlet UIButton *btnRadio2;

/**
 공인인증서 지정 로그인
 */
@property (retain, nonatomic) IBOutlet UIButton *btnRadio3;

/**
 인증서 선택
 */
@property (retain, nonatomic) IBOutlet SHBSelectBox *sbCertificate;

@property (retain, nonatomic) IBOutlet UIImageView *ivBox;

- (IBAction)radioBtnAction:(UIButton *)sender;

- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
