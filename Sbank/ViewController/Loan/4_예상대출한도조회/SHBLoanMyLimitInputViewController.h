//
//  SHBLoanMyLimitInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 5. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBDateField.h"

/**
 대출 - 예상 대출 한도 조회
 직업정보 화면
 */

@interface SHBLoanMyLimitInputViewController : SHBBaseViewController <SHBDateFieldDelegate>

@property (retain, nonatomic) IBOutlet SHBTextField *companyTF;
@property (retain, nonatomic) IBOutlet UIButton *publicOfficialBtn; // 본사 사업자 등록번호
@property (retain, nonatomic) IBOutlet SHBButton *jobFamilyBtn; // 직종
@property (retain, nonatomic) IBOutlet SHBButton *job1Btn; // 직업1
@property (retain, nonatomic) IBOutlet SHBButton *job2Btn; // 직업2
@property (retain, nonatomic) IBOutlet SHBButton *job3Btn; // 직업3
@property (retain, nonatomic) IBOutlet SHBButton *job4Btn; // 직업4
@property (retain, nonatomic) IBOutlet SHBButton *positionBtn; // 직위
@property (retain, nonatomic) IBOutlet SHBButton *dutyBtn; // 직무
@property (retain, nonatomic) IBOutlet SHBDateField *dateField; // 입사일자
@property (retain, nonatomic) IBOutlet UIView *mainView;

@end
