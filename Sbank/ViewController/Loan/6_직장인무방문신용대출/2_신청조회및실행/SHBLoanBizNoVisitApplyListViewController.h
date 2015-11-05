//
//  SHBLoanBizNoVisitApplyListViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 10. 31..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAttentionLabel.h"

/**
 대출 - 직장인 무방문 신용대출
 신청 조회 및 실행
 */

@interface SHBLoanBizNoVisitApplyListViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UITableView *dataTable;

@property (retain, nonatomic) IBOutlet SHBAttentionLabel *info1;

- (void)reloadUI;

@end
