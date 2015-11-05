//
//  SHBLoanBizNoVisitApplyInfoViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 14..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

/**
 대출 - 직장인 무방문 신용대출
 신청 조회 및 실행 4단계 (인지세 부과 안내)
 */

@interface SHBLoanBizNoVisitApplyInfoViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIScrollView *contentSV;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@end
