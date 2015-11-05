//
//  SHBUdreamSecurityViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBListPopupView.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBSelectBox.h"

@interface SHBUdreamSecurityViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate, SHBListPopupViewDelegate, SHBSecretCardDelegate, SHBSecretOTPDelegate, SHBSelectBoxDelegate>

@property (retain, nonatomic) IBOutlet UIView *bottomView;

/**
 출금계좌번호
 */
@property (nonatomic, retain) SHBSelectBox *sbOutAccount;
//@property (nonatomic, retain) SHBTextField *tfOutAccount;

/**
 보안카드
 */
@property (nonatomic, retain) SHBSecretCardViewController *cardViewController;

/**
 OTP
 */
@property (nonatomic, retain) SHBSecretOTPViewController *otpViewController;

/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;

- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
