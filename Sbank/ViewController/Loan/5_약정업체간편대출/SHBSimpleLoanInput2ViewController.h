//
//  SHBSimpleLoanInput2ViewController.h
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
 정보입력(2) 화면
 */

@interface SHBSimpleLoanInput2ViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate, SHBDateFieldDelegate>

@property (retain, nonatomic) NSMutableDictionary *inputData;

@property (retain, nonatomic) IBOutlet UIView *mainView;

@property (retain, nonatomic) IBOutlet SHBTextField *organSearch; // 기관검색
@property (retain, nonatomic) IBOutlet SHBButton *organSelectBtn; // 기관선택
@property (retain, nonatomic) IBOutlet SHBTextField *branch; // 대출희망지점
@property (retain, nonatomic) IBOutlet SHBButton *jobFamilyBtn; // 직종
@property (retain, nonatomic) IBOutlet SHBButton *job1Btn; // 직업1
@property (retain, nonatomic) IBOutlet SHBButton *job2Btn; // 직업2
@property (retain, nonatomic) IBOutlet SHBButton *job3Btn; // 직업3
@property (retain, nonatomic) IBOutlet SHBButton *job4Btn; // 직업4
@property (retain, nonatomic) IBOutlet SHBButton *positionBtn; // 직위
@property (retain, nonatomic) IBOutlet SHBTextField *department; // 근무부서
@property (retain, nonatomic) IBOutlet SHBTextField *zipCode1; // 우편번호1
@property (retain, nonatomic) IBOutlet SHBTextField *zipCode2; // 우편번호2
@property (retain, nonatomic) IBOutlet SHBTextField *address1; // 주소1
@property (retain, nonatomic) IBOutlet SHBTextField *address2; // 주소2
@property (retain, nonatomic) IBOutlet SHBTextField *number1; // 직장 전화번호1
@property (retain, nonatomic) IBOutlet SHBTextField *number2; // 직장 전화번호2
@property (retain, nonatomic) IBOutlet SHBTextField *number3; // 직장 전화번호3
@property (retain, nonatomic) IBOutlet SHBDateField *dateField; // 입사일자

@end
