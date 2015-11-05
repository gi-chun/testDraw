//
//  SHBGiroTaxPaymentListViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 9..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBPeriodPopupView.h"          // 기간선택 팝업


@interface SHBGiroTaxPaymentListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, SHBPopupViewDelegate>
{
    IBOutlet UITableView    *tableView1;
    
    IBOutlet UIView         *viewMore;      // 더 보기 view
    
    IBOutlet UILabel        *label1;            // 조회기간
    IBOutlet UILabel        *label2;            // 조회 내역 없음
    
//    NSString                *strSelectedStartDate;      // 기간선택에서 선택된 조회시작 날짜
//    NSString                *strSelectedEndDate;        // 기간선택에서 선택된 조회종료 날짜
    
    int                     intMonth;           // 조회기간 관련 변수
    int                     intIndex;           // 표시 갯수 index
}

@property (nonatomic, retain) NSMutableArray        *arrayData;     // tableView data
// release 되는 문제로 프로퍼티로 사용
@property (nonatomic, retain) NSString *strSelectedStartDate;      // 기간선택에서 선택된 조회시작 날짜
@property (nonatomic, retain) NSString *strSelectedEndDate;      // 기간선택에서 선택된 조회시작 날짜


- (IBAction)buttonDidPush:(id)sender;

@end
