//
//  SHBUrgencyCancelConfirmViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 영업점/ATM > ATM긴급출금 조회/취소 > ATM긴급출금 조회/취소 계좌선택 > 상세화면 > 긴급출금취소 > 보안카드 화면
 */

#import "SHBBaseViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

@interface SHBUrgencyCancelConfirmViewController : SHBBaseViewController <SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) IBOutlet UILabel *lblAccountNum;
@property (retain, nonatomic) IBOutlet UILabel *lblAmount;
@property (retain, nonatomic) IBOutlet UILabel *lblPhoneNum;
@property (retain, nonatomic) IBOutlet UILabel *lblRequestDate;
@property (retain, nonatomic) IBOutlet UILabel *lblRequestCnt;
@property (retain, nonatomic) IBOutlet UILabel *lblPWErrorCnt;

/**
 보안카드
 */
@property (nonatomic, retain) SHBSecretCardViewController *cardViewController;

/**
 OTP
 */
@property (nonatomic, retain) SHBSecretOTPViewController *otpViewController;

@end
