//
//  SHBLoanMyLimitInput2ViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 5. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

/**
 대출 - 예상 대출 한도 조회
 대출관련사항 화면
 */

@protocol SHBLoanMyLimitInput2Delegate <NSObject>

@optional
- (void)loanMyLimitInput2Cancel;

@end

@interface SHBLoanMyLimitInput2ViewController : SHBBaseViewController

@property (retain, nonatomic) id<SHBLoanMyLimitInput2Delegate> delegate;

@property (retain, nonatomic) IBOutlet SHBTextField *textField1; // 연근로소득
@property (retain, nonatomic) IBOutlet SHBTextField *textField2; // 신한은행 총 대출금액
@property (retain, nonatomic) IBOutlet SHBTextField *textField3; // 신한은행 총 담보대출 금액
@property (retain, nonatomic) IBOutlet SHBTextField *textField4; // 타기관 대출신고건수
@property (retain, nonatomic) IBOutlet SHBTextField *textField5; // 타기관 대출신고금액
@property (retain, nonatomic) IBOutlet SHBTextField *textField6; // 타기관 담보대출금액
@property (retain, nonatomic) IBOutlet SHBTextField *textField7; // 타기관 신용대출 상환금액
@property (retain, nonatomic) IBOutlet SHBTextField *textField8; // 타기관 담보대출 상환금액

@property (retain, nonatomic) IBOutlet UIView *mainView;
@end
