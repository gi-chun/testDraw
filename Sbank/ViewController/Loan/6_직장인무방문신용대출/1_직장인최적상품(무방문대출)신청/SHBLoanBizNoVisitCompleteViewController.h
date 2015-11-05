//
//  SHBLoanBizNoVisitCompleteViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBAttentionLabel.h"
#import "SHBScrollLabel.h"

/**
 대출 - 직장인 무방문 신용대출
 직장인 최적상품(무방문대출) 신청 완료
 */

@interface SHBLoanBizNoVisitCompleteViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet SHBAttentionLabel *info1;

@property (retain, nonatomic) IBOutlet UIScrollView *contentSV;
@property (retain, nonatomic) IBOutlet UIView *contentView; // 신청완료
@property (retain, nonatomic) IBOutlet UIView *eliteLoanView; // 엘리트론 선택시 안내문구
@property (retain, nonatomic) IBOutlet SHBScrollLabel *subTitleView;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *productName;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *rateName;
@end
