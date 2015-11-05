//
//  SHBUrgencyPaymentCompleteViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
  영업점/ATM > ATM긴급출금등록 > ATM긴급출금등록 정보입력 > ATM긴급출금등록 정보확인 > 전자서명 > ATM긴급출금등록 완료
 */

#import "SHBBaseViewController.h"

@interface SHBUrgencyPaymentCompleteViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIImageView *ivBox;

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
 등록 신청일자
 */
@property (retain, nonatomic) IBOutlet UILabel *lblRequestDate;
@property (nonatomic, retain) NSString *strRequestDate;

- (IBAction)confirmBtnAction:(SHBButton *)sender;

@end
