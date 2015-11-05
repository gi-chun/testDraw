//
//  SHBLoanBizNoVisitApplyListCell.h
//  ShinhanBank
//
//  Created by Joon on 2014. 10. 31..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBScrollLabel.h"

/**
 대출 - 직장인 무방문 신용대출
 신청 조회 및 실행 cell
 */

@interface SHBLoanBizNoVisitApplyListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet SHBScrollLabel *productName;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *rate;
@property (retain, nonatomic) IBOutlet SHBButton *status;
@end
