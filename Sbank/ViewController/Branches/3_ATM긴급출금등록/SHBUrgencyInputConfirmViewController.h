//
//  SHBUrgencyInputConfirmViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 영업점/ATM > ATM긴급출금등록 > ATM긴급출금등록 정보입력 > ATM긴급출금등록 정보확인
 */
#import "SHBBaseViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

@interface SHBUrgencyInputConfirmViewController : SHBBaseViewController <SHBSecretCardDelegate, SHBSecretOTPDelegate>

/**
 출금계좌번호
 */
@property (retain, nonatomic) IBOutlet UILabel *lblAccountNum;

/**
 출금금액
 */
@property (retain, nonatomic) IBOutlet UILabel *lblAmount;

/**
 SMS수신휴대폰번호
 */
@property (retain, nonatomic) IBOutlet UILabel *lblPhoneNum;

/**
 보안카드
 */
@property (nonatomic, retain) SHBSecretCardViewController *cardViewController;

/**
 OTP
 */
@property (nonatomic, retain) SHBSecretOTPViewController *otpViewController;

@end
