//
//  SHBLoanBizNoVisitApplyCompleteViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 14..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

/**
 대출 - 직장인 무방문 신용대출
 신청 조회 및 실행 6단계 (실행 완료)
 */

@interface SHBLoanBizNoVisitApplyCompleteViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet SHBScrollLabel *productName;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *loanRate;

@property (retain, nonatomic) IBOutlet UIView *startDateView;
@property (retain, nonatomic) IBOutlet UIView *endDateView;

@end
