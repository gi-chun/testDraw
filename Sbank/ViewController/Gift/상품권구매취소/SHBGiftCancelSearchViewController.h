//
//  SHBGiftCancelSearchViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBDateField.h"
#import "SHBTextField.h"

/**
 상품권 - 모바일상품권 구매취소
 건별 조회 화면
 */

@interface SHBGiftCancelSearchViewController : SHBBaseViewController <SHBDateFieldDelegate, SHBTextFieldDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIButton *emartBtn; // 신세계상품권교환권
@property (retain, nonatomic) IBOutlet UIButton *cultuBtn; // 문화상품권
@property (retain, nonatomic) IBOutlet SHBDateField *dateField; // 구매일자
@property (retain, nonatomic) IBOutlet SHBTextField *approvalNumber; // 승인번호
@property (retain, nonatomic) IBOutlet SHBButton *accountNumber; // 계좌번호
@property (retain, nonatomic) IBOutlet UIView *mainView;
@end
