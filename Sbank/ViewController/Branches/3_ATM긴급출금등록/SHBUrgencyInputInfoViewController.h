//
//  SHBUrgencyInputInfoViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 영업점/ATM > ATM긴급출금등록 > ATM긴급출금등록 정보입력
 */
#import "SHBBaseViewController.h"
#import "SHBSelectBox.h"
#import "SHBTextField.h"
#import "SHBListPopupView.h"

@interface SHBUrgencyInputInfoViewController : SHBBaseViewController <SHBSelectBoxDelegate, SHBSecureDelegate, SHBTextFieldDelegate, SHBListPopupViewDelegate, UITextFieldDelegate>

/**
 ATM 긴급출금 유의사항
 */
@property (retain, nonatomic) IBOutlet SHBButton *atmInfoBtn;

/**
 출금계좌번호
 */
@property (retain, nonatomic) IBOutlet SHBSelectBox *sbAccountNum;

/**
 출금가능잔액
 */
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;

/**
 계좌비밀번호
 */
@property (retain, nonatomic) IBOutlet SHBSecureTextField *tfAccountPW;

/**
 출금금액
 */
@property (retain, nonatomic) IBOutlet SHBTextField *tfWithdrawAmount;

/**
 출금금액 한글표시
 */
@property (retain, nonatomic) IBOutlet UILabel *lblAmountKor;

/**
 1회용비밀번호
 */
@property (retain, nonatomic) IBOutlet SHBSecureTextField *tfInstantPW;

/**
 1회용비밀번호 확인
 */
@property (retain, nonatomic) IBOutlet SHBSecureTextField *tfInstantPWConfirm;

/**
 SMS수신 휴대폰번호
 */
@property (retain, nonatomic) IBOutlet SHBTextField *tfPhoneNum1;
@property (retain, nonatomic) IBOutlet SHBTextField *tfPhoneNum2;
@property (retain, nonatomic) IBOutlet SHBTextField *tfPhoneNum3;

/**
 잔액조회 버튼액션
 */
- (IBAction)inquiryBalanceBtnAction:(UIButton *)sender;

- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

- (IBAction)closeNormalPad:(UIButton *)sender;
- (IBAction)closeNormalPad_1:(UIButton *)sender;
- (IBAction)closeNormalPad_2:(UIButton *)sender;


- (void)initializeData;		// 데이터 초기화

@end
