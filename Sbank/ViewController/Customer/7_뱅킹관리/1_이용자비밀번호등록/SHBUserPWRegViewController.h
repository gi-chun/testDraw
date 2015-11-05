//
//  SHBUserPWRegViewController.h
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 환경설정 > 이용자 비밀번호 등록
 */

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBSecureTextField.h"

@interface SHBUserPWRegViewController : SHBBaseViewController <SHBTextFieldDelegate, SHBSecureDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *ivInfoBox;

/**
 주민등록번호 텍스트필드
 */
@property (retain, nonatomic) IBOutlet SHBSecureTextField *ssnTextField;

/**
 이용자아이디 텍스트필드
 */
@property (retain, nonatomic) IBOutlet SHBTextField *idTextField;

/**
 확인버튼 눌렀을 때의 액션
 */
- (IBAction)confirmButtonAction:(SHBButton *)sender;

/**
 취소버튼 액션
 */
- (IBAction)cancelButtonAction:(SHBButton *)sender;

@end
