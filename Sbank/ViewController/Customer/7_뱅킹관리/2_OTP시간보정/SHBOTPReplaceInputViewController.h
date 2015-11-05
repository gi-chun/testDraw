//
//  SHBOTPReplaceInputViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 9. 27..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 부가서비스 > OTP 시간보정
 */

#import "SHBOTPReplaceInputViewController.h"
//#import "SHBTextField.h"

@interface SHBOTPReplaceInputViewController : SHBBaseViewController <SHBSecureDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

/**
 OTP카드 비밀번호 텍스트필드
 */
@property (retain, nonatomic) IBOutlet SHBSecureTextField *otpPWTextField;

/**
 확인 버튼 액션
 */
- (IBAction)confirmBtnAction:(UIButton *)sender;

/**
 취소 버튼 액션
 */
- (IBAction)cancelBtnAction:(UIButton *)sender;

@end
