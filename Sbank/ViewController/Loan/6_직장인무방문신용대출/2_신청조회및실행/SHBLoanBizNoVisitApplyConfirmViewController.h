//
//  SHBLoanBizNoVisitApplyConfirmViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 14..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBSecureTextField.h"
#import "SHBScrollLabel.h"

/**
 대출 - 직장인 무방문 신용대출
 신청 조회 및 실행 5단계 (입력정보 확인)
 */

@interface SHBLoanBizNoVisitApplyConfirmViewController : SHBBaseViewController <SHBSecureDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet SHBSecureTextField *passwordTF;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIView *secureView;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *productName;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *loanRate;

@end
