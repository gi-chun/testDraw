//
//  SHBForexFavoritExecuteInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBSecureTextField.h"
#import "SHBButton.h"

/**
 외환/골드 - 자주쓰는 해외송금/조회
 자주쓰는 해외송금 정보입력 화면
 */

@interface SHBForexFavoritExecuteInputViewController : SHBBaseViewController
<SHBTextFieldDelegate, SHBSecureDelegate, UITextFieldDelegate>

@property (retain, nonatomic) OFDataSet *dataSetF3732;
@property (retain, nonatomic) OFDataSet *preDataSet;

@property (retain, nonatomic) IBOutlet SHBButton *sendClass; // 송금구분
@property (retain, nonatomic) IBOutlet SHBButton *currency; // 통화구분
@property (retain, nonatomic) IBOutlet SHBButton *bankCountry; // 수취은행국가명
@property (retain, nonatomic) IBOutlet UIButton *receiptCharge; // 수취인
@property (retain, nonatomic) IBOutlet UIButton *sendCharge; // 송금인
@property (retain, nonatomic) IBOutlet SHBButton *breakdown; // 재산반출내역
@property (retain, nonatomic) IBOutlet SHBButton *nonSelected; // 선택안함
@property (retain, nonatomic) IBOutlet SHBButton *foreignAccountNumber; // 외화출금계좌번호
@property (retain, nonatomic) IBOutlet SHBButton *wonAccountNumber; // 원화출금계좌번호

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet SHBTextField *remittance1; // 전체송금액(외화) 앞
@property (retain, nonatomic) IBOutlet SHBTextField *remittance2; // 전체송금액(외화) 뒤
@property (retain, nonatomic) IBOutlet SHBSecureTextField *jumin; // 유학생주민등록번호
@property (retain, nonatomic) IBOutlet SHBTextField *foreignWithDrawal1; // 외화계좌인출금액(외화) 앞
@property (retain, nonatomic) IBOutlet SHBTextField *foreignWithDrawal2; // 외화계좌인출금액(외화) 뒤
@property (retain, nonatomic) IBOutlet SHBSecureTextField *foreignPasswd; // 외화출금계좌 비밀번호
@property (retain, nonatomic) IBOutlet SHBTextField *wonWithDrawal; // 원화계좌인출금액(외화)
@property (retain, nonatomic) IBOutlet SHBSecureTextField *wonPasswd; // 원화출금계좌 비밀번호
@property (retain, nonatomic) IBOutlet UILabel *balance; // 출금가능잔액

- (void)serverError;

@end
