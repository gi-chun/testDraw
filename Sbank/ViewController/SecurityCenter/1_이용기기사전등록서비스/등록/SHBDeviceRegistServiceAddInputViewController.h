//
//  SHBDeviceRegistServiceAddInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 1. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBTextField.h"

/**
 보안센터 - 이용기기 등록 서비스 - 이용기기 등록
 이용기기 등록 화면
 */

@interface SHBDeviceRegistServiceAddInputViewController : SHBBaseViewController
<SHBTextFieldDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet SHBTextField *nickName; // 스마트폰 별명
@property (retain, nonatomic) IBOutlet UIButton *smsBtn; // 휴대폰 SMS 인증
@property (retain, nonatomic) IBOutlet UIButton *arsBtn; // 유선전화 ARS 인증
@property (retain, nonatomic) IBOutlet UIButton *disposableBtn; // 1회용 인증번호(영업점 발급)
@property (retain, nonatomic) IBOutlet UIView *buttonView; // 확인, 취소

@end
