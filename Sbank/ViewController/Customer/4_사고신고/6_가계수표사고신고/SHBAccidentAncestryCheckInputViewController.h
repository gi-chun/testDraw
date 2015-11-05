//
//  SHBAccidentAncestryCheckInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBTextField.h"

/**
 고객센터 - 사고신고
 가계수표 사고신고 화면
 */

@interface SHBAccidentAncestryCheckInputViewController : SHBBaseViewController
<SHBTextFieldDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet SHBTextField *accountNumber; // 계좌번호
@property (retain, nonatomic) IBOutlet SHBButton *bank; // 발행은행
@property (retain, nonatomic) IBOutlet SHBTextField *checkNumber; // 수표번호
@property (retain, nonatomic) IBOutlet SHBTextField *checkMoney; // 수표금액(원)
@property (retain, nonatomic) IBOutlet UILabel *checkMoneyKor; // 수표금액(원) 한글표기
@end
