//
//  SHBAccidentSelfCheckInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBTextField.h"
#import "SHBDateField.h"

/**
 고객센터 - 사고신고
 자기앞수표 사고신고 화면
 */

@interface SHBAccidentSelfCheckInputViewController : SHBBaseViewController
<SHBTextFieldDelegate, SHBDateFieldDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet SHBTextField *checkNumber; // 수표번호
@property (retain, nonatomic) IBOutlet SHBTextField *branchCode; // 발행점지로코드
@property (retain, nonatomic) IBOutlet SHBDateField *dateField; // 발행일
@property (retain, nonatomic) IBOutlet SHBButton *checkType; // 수표종류
@property (retain, nonatomic) IBOutlet SHBTextField *checkMoney; // 수표금액(원)
@property (retain, nonatomic) IBOutlet UILabel *checkMoneyKor; // 수표금액(원) 한글표기
@property (retain, nonatomic) IBOutlet SHBTextField *checkName; // 신청인성명
@property (retain, nonatomic) IBOutlet SHBTextField *phoneNumber; // 신청인 전화번호
@property (retain, nonatomic) IBOutlet UIView *helpView; // 도움말 popup

@end
