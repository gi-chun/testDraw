//
//  SHBSimpleLoanInput3ViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 16..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBDateField.h"

/**
 대출 - 약정업체 간편대출
 정보입력(3) 화면
 */

@interface SHBSimpleLoanInput3ViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate, SHBDateFieldDelegate>

@property (retain, nonatomic) NSMutableDictionary *inputData;

@property (retain, nonatomic) IBOutlet UIView *mainView;

@property (retain, nonatomic) IBOutlet SHBTextField *textField1; // 연근로소득
@property (retain, nonatomic) IBOutlet SHBTextField *textField2; // 신한은행 총 대출금액
@property (retain, nonatomic) IBOutlet SHBTextField *textField3; // 신한은행 신용대출금
@property (retain, nonatomic) IBOutlet SHBTextField *textField4; // 대출 신청금액
@property (retain, nonatomic) IBOutlet SHBButton *useBtn; // 자금용도
@property (retain, nonatomic) IBOutlet SHBTextField *useTF; // 자금용도
@property (retain, nonatomic) IBOutlet SHBButton *planBtn; // 상환계획
@property (retain, nonatomic) IBOutlet SHBTextField *planTF; // 상환계획
@property (retain, nonatomic) IBOutlet SHBDateField *dateField; // 대출희망일
@end
