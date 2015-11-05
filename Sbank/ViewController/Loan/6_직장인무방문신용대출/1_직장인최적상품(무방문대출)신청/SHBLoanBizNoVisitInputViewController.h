//
//  SHBLoanBizNoVisitInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"
#import "SHBTextField.h"
#import "SHBDateField.h"

/**
 대출 - 직장인 무방문 신용대출
 직장인 최적상품(무방문대출) 신청 인적사항 확인
 */

@interface SHBLoanBizNoVisitInputViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate, SHBDateFieldDelegate>

@property (assign, nonatomic) Boolean isSelectInfoAgree; // 선택정보동의여부
@property (retain, nonatomic) NSDictionary *C2800Dic;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *subTitleView;
@property (retain, nonatomic) IBOutlet UIView *mainView;

@property (retain, nonatomic) IBOutlet SHBTextField *email; // Email
@property (retain, nonatomic) IBOutlet SHBButton *dwellingBtn; // 주거소유
@property (retain, nonatomic) IBOutlet UIButton *smsChkBtn; // SMS수신여부
@property (retain, nonatomic) IBOutlet SHBButton *postDeliveryBtn; // 우편 송달
@property (retain, nonatomic) IBOutlet UIButton *spouseChkBtn; // 배우자
@property (retain, nonatomic) IBOutlet UIButton *fatherChkBtn; // 부
@property (retain, nonatomic) IBOutlet UIButton *motherChkBtn; // 모
@property (retain, nonatomic) IBOutlet UIButton *childChkBtn; // 자녀
@property (retain, nonatomic) IBOutlet SHBTextField *child; // 자녀수
@property (retain, nonatomic) IBOutlet UIButton *brotherChkBtn; // 형제자매
@property (retain, nonatomic) IBOutlet UIButton *otherChkBtn; // 기타
@property (retain, nonatomic) IBOutlet UIButton *noneChkBtn; // 없음
@property (retain, nonatomic) IBOutlet SHBTextField *bizLicense; // 본사 사업자 등록번호
@property (retain, nonatomic) IBOutlet UIButton *publicOfficialChkBtn; // 공무원
@property (retain, nonatomic) IBOutlet SHBButton *jobFamilyBtn; // 직종구분
@property (retain, nonatomic) IBOutlet SHBButton *job1Btn; // 직업1
@property (retain, nonatomic) IBOutlet SHBButton *job2Btn; // 직업2
@property (retain, nonatomic) IBOutlet SHBButton *job3Btn; // 직업3
@property (retain, nonatomic) IBOutlet SHBButton *job4Btn; // 직업4
@property (retain, nonatomic) IBOutlet SHBButton *positionBtn; // 직위
@property (retain, nonatomic) IBOutlet SHBButton *dutyBtn; // 직무
@property (retain, nonatomic) IBOutlet SHBDateField *dateField; // 입사일자
@property (retain, nonatomic) IBOutlet SHBButton *jobClassBtn; // 직업구분
@property (retain, nonatomic) IBOutlet SHBTextField *companyName; // 직장명/상호
@property (retain, nonatomic) IBOutlet SHBTextField *department; // 근무부서
@property (retain, nonatomic) IBOutlet SHBTextField *employee; // 직원/직함

- (void)clearViewData;

@end
