//
//  SHBLoanBizNoVisitResultRateView.h
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 대출 - 직장인 무방문 신용대출
 직장인 최적상품(무방문대출) 신청 - 감면금리 항목명 및 금리
 */

@protocol SHBLoanBizNoVisitResultRateViewDelegate <NSObject>

- (void)loanBizNoVisitResultRateOK;

@end

@interface SHBLoanBizNoVisitResultRateView : UIView

@property (assign, nonatomic) id<SHBLoanBizNoVisitResultRateViewDelegate> delegate;
@property (retain, nonatomic) NSMutableArray *dataList;

@property (retain, nonatomic) IBOutlet UIView *popupView;
@property (retain, nonatomic) IBOutlet UITableView *dataTable;

@property (retain, nonatomic) IBOutlet UIView *popupView2;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)fadeIn;
- (void)fadeOut;

@end
