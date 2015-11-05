//
//  SHBEasyCloseConfirmViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 10..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 상품가입/해지 - 예금/적금 해지 - 신한e-간편해지
 신한e-간편해지 계좌 확인 화면
 */

@interface SHBEasyCloseConfirmViewController : SHBBaseViewController
<SHBSecureDelegate, UITextFieldDelegate>

@property (retain, nonatomic) NSMutableDictionary *smartNewDic;

@property (retain, nonatomic) IBOutlet SHBSecureTextField *secureTF;
@property (retain, nonatomic) IBOutlet SHBButton *accountNumber;
@property (retain, nonatomic) IBOutlet UIView *securityView;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@end
