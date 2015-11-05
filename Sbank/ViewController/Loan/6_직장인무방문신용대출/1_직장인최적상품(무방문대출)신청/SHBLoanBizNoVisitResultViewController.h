//
//  SHBLoanBizNoVisitResultViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"
#import "SHBAttentionLabel.h"

/**
 대출 - 직장인 무방문 신용대출
 직장인 최적상품(무방문대출) 신청
 */

@interface SHBLoanBizNoVisitResultViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSMutableDictionary *L3661Dic;
@property (retain, nonatomic) NSDictionary *C2800Dic;

@property (retain, nonatomic) IBOutlet UIScrollView *contentSV;
@property (retain, nonatomic) IBOutlet UIView *noDataView;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *infoView;

@property (retain, nonatomic) IBOutlet UITableView *dataTable; // 상품목록
@property (retain, nonatomic) IBOutlet UITableView *dataTable2; // 금리조회 결과

@property (retain, nonatomic) IBOutlet UIView *rateView; // 금리 조회 결과

@end
