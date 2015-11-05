//
//  SHBLoanRegViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSelectBox.h"
#import "SHBListPopupView.h"
#import "SHBTextField.h"

@interface SHBLoanRegViewController : SHBBaseViewController <SHBSelectBoxDelegate, SHBListPopupViewDelegate, UITextFieldDelegate, SHBTextFieldDelegate, SHBSecureDelegate>

@property (retain, nonatomic) IBOutlet UIView *bodyView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UILabel *typelable;
@property (nonatomic, retain) NSString *Loantype;

/**
 사용자입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;

/**
 담보예금 계좌번호
 */
@property (retain, nonatomic) IBOutlet SHBSelectBox *sbAccountNo;

/**
 담보예금 비밀번호
 */
@property (retain, nonatomic) IBOutlet SHBSecureTextField *tfAccountPW;

/**
 대출가능 한도조회
 */
@property (retain, nonatomic) IBOutlet SHBTextField *tfLimitQuery;

/**
 대출 받으실 금액
 */
@property (retain, nonatomic) IBOutlet SHBTextField *tfLoanAmount;

/**
 입금계좌번호
 */
@property (retain, nonatomic) IBOutlet SHBSelectBox *sbDepositAccountNo;

/**
 권유직원번호
 */
@property (retain, nonatomic) IBOutlet SHBTextField *tfEmployeeNo;

/**
 대출용도
 */
@property (retain, nonatomic) IBOutlet SHBSelectBox *sbLoanPurpose;

/**
 대출용도(기타 선택시 직접입력)
 */
@property (retain, nonatomic) IBOutlet SHBTextField *tfInputLoanPurpose;

/**
 대출가능한도 조회 버튼 액션
 */
- (IBAction)limitQueryBtnAction:(SHBButton *)sender;

/**
 권유직원조회 버튼 액션
 */
- (IBAction)employeeBtnAction:(SHBButton *)sender;

- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
