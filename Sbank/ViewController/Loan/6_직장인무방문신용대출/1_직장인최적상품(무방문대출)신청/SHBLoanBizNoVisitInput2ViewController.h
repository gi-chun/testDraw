//
//  SHBLoanBizNoVisitInput2ViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"
#import "SHBTextField.h"
#import "SHBDateField.h"

/**
 대출 - 직장인 무방문 신용대출
 직장인 최적상품(무방문대출) 신청 대출관련사항
 */

@interface SHBLoanBizNoVisitInput2ViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate, SHBDateFieldDelegate>

@property (retain, nonatomic) NSMutableDictionary *inputData;
@property (retain, nonatomic) NSDictionary *C2800Dic;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *subTitleView;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet SHBTextField *annualIncome; // 연근로소득
@property (retain, nonatomic) IBOutlet SHBTextField *generalIncomeTax; // 종합소득세
@property (retain, nonatomic) IBOutlet SHBTextField *shbTotalLoan; // 신한은행 총 대출금액
@property (retain, nonatomic) IBOutlet SHBTextField *shbBizLoan; // 신한은행 총 담보대출금액
@property (retain, nonatomic) IBOutlet SHBTextField *otherLoanCount; // 타 금융기관 대출받은 기관 수
@property (retain, nonatomic) IBOutlet SHBTextField *otherTotalLoan; // 타 금융기관 총 대출금액
@property (retain, nonatomic) IBOutlet SHBTextField *otherBizLoan; // 타 금융기관 신용대출금액
@property (retain, nonatomic) IBOutlet SHBButton *loanTypeBtn; // 대출방식
@property (retain, nonatomic) IBOutlet SHBDateField *wishDate; // 대출희망일자
@property (retain, nonatomic) IBOutlet SHBButton *useBtn; // 자금용도
@property (retain, nonatomic) IBOutlet SHBTextField *use; // 자금용도
@property (retain, nonatomic) IBOutlet SHBTextField *wishBranch; // 대출희망지점
@property (retain, nonatomic) IBOutlet SHBButton *planBtn; // 상환계획
@property (retain, nonatomic) IBOutlet SHBTextField *plan; // 상환계획
@property (retain, nonatomic) IBOutlet SHBButton *transferAccount; // 입금계좌번호
@property (retain, nonatomic) IBOutlet SHBDateField *transferDate; // 이자이체일자
@property (retain, nonatomic) IBOutlet SHBTextField *canvasserNo; // 권유자행번
@property (retain, nonatomic) IBOutlet UIView *infoView1; // 조회시 확인사항
@property (retain, nonatomic) IBOutlet UIView *infoView2; // 건별대출시 확인사항
@property (retain, nonatomic) IBOutlet UIView *infoView3; // 한도대출시 확인사항


@end
