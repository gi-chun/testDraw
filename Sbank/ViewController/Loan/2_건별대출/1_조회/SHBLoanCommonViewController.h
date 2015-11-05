//
//  SHBLoanCommonViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 16..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBLoanCommonViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, assign) NSDictionary *accountInfo;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIView *detailView;
@property (retain, nonatomic) IBOutlet UILabel *interestDetailInfo; // 이자상세조회
@property (retain, nonatomic) IBOutlet UIView *loanEndDateView; // 대출만기일
@property (retain, nonatomic) IBOutlet UIView *orderView; // 조회기간
@property (retain, nonatomic) IBOutlet UILabel *orderInfo; // 최근거래내역 x건이 조회되었습니다.
@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@property (retain, nonatomic) IBOutlet SHBButton *arrow; // 거래내역 정렬

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
