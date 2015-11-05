//
//  SHBSimpleLoanInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 16..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

/**
 대출 - 약정업체 간편대출
 정보입력(1) 화면
 */

@interface SHBSimpleLoanInputViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet SHBTextField *zipCode1; // 우편번호1
@property (retain, nonatomic) IBOutlet SHBTextField *zipCode2; // 우편번호2
@property (retain, nonatomic) IBOutlet SHBTextField *address1; // 주소1
@property (retain, nonatomic) IBOutlet SHBTextField *address2; // 주소2
@property (retain, nonatomic) IBOutlet UIButton *homeBtn; // 자택
@property (retain, nonatomic) IBOutlet UIButton *officeBtn; // 직장
@property (retain, nonatomic) IBOutlet UIButton *noSendBtn; // 발송안함
@property (retain, nonatomic) IBOutlet SHBTextField *number1; // 전화번호1
@property (retain, nonatomic) IBOutlet SHBTextField *number2; // 전화번호2
@property (retain, nonatomic) IBOutlet SHBTextField *number3; // 전화번호3
@property (retain, nonatomic) IBOutlet SHBTextField *phone1; // 휴대전화1
@property (retain, nonatomic) IBOutlet SHBTextField *phone2; // 휴대전화2
@property (retain, nonatomic) IBOutlet SHBTextField *phone3; // 휴대전화3
@property (retain, nonatomic) IBOutlet SHBTextField *email; // 이메일


@end
