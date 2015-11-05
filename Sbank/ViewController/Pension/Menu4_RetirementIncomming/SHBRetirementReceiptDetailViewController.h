//
//  SHBRetirementReceiptDetailViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 22..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBPeriodPopupView.h"              // 기간선택 팝업


@interface SHBRetirementReceiptDetailViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate, SHBPopupViewDelegate>
{
    IBOutlet UITableView        *tableView1;
    
    IBOutlet UILabel        *label1;            // 사용자부담금합계
    IBOutlet UILabel        *label2;            // 조회기간
    IBOutlet UILabel        *label3;            // 조회내역 없을 경우
    
    NSString                *strSelectedStartDate;      // 기간선택에서 선택된 조회시작 날짜
    NSString                *strSelectedEndDate;        // 기간선택에서 선택된 조회종료 날짜
    
    int                     intMonth;           // 조회기간 관련 변수
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;

- (IBAction)buttonDidPush:(id)sender;

@end
