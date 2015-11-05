//
//  SHBLoanBizNoVisitResult2ViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"
#import "SHBTextField.h"

/**
 대출 - 직장인 무방문 신용대출
 직장인 최적상품(무방문대출) 신청 연소득 확인 안내
 */

@interface SHBLoanBizNoVisitResult2ViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate>

@property (retain, nonatomic) NSDictionary *C2800Dic;

@property (retain, nonatomic) IBOutlet UIView *contentView;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *subTitleView;
@property (retain, nonatomic) IBOutlet SHBTextField *annualIncome; // 연소득확인
@property (retain, nonatomic) IBOutlet SHBScrollLabel *productName; // 대출상품
@property (retain, nonatomic) IBOutlet SHBTextField *money; // 신청금액
@property (retain, nonatomic) IBOutlet UIButton *agreeBtn; // 예, 동의합니다.
@property (retain, nonatomic) IBOutlet UIView *interestView; // 연체이후 이자일부납입 확인
@property (retain, nonatomic) IBOutlet UIView *recommendView; // 추천번호 입력 View
@property (retain, nonatomic) IBOutlet SHBTextField *recommend; // 추천번호 입력

@end
