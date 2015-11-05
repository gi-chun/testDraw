//
//  SHBUrgencyDetailViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 영업점/ATM > ATM긴급출금 조회/취소 > ATM긴급출금 조회/취소 계좌선택 > 상세화면
 */

#import "SHBBaseViewController.h"

@interface SHBUrgencyDetailViewController : SHBBaseViewController

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

/**
 등록 회차
 */
@property (retain, nonatomic) IBOutlet UILabel *lblRequestCnt;

/**
 비밀번호오류횟수
 */
@property (retain, nonatomic) IBOutlet UILabel *lblPWErrorCnt;

/**
 지급일자
 */
@property (retain, nonatomic) IBOutlet UILabel *lblPaymentDate;

/**
 취소일자
 */
@property (retain, nonatomic) IBOutlet UILabel *lblCancelDate;

/**
 SMS 재전송 버튼
 */
@property (retain, nonatomic) IBOutlet SHBButton *btnSendSMS;

/**
 확인 버튼만 있는 뷰
 */
@property (retain, nonatomic) IBOutlet UIView *vOneBtn;

/**
 확인, 긴급출금취소가 있는 뷰
 */
@property (retain, nonatomic) IBOutlet UIView *vTwoBtn;

/**
 SMS 재전송 버튼액션
 */
- (IBAction)sendSMSBtnAction:(SHBButton *)sender;

/**
 확인 버튼 액션
 */
- (IBAction)confirmBtnAction:(SHBButton *)sender;

/**
 긴급출금취소 버튼액션
 */
- (IBAction)cancelPaymentBtnAction:(SHBButton *)sender;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@end
