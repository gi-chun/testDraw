//
//  SHBDistricTaxPaymentListViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 11..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBPeriodPopupView.h"              // 기간선택 팝업


@interface SHBDistricTaxPaymentListViewController : SHBBaseViewController <UITableViewDelegate, SHBPopupViewDelegate>
{
    IBOutlet UIView         *viewMore;      // 더 보기 view
    
    IBOutlet UILabel        *label1;            // 조회기간
    IBOutlet UILabel        *label2;            // 조회내역 없을 시 label
    
    NSString                *strSelectedStartDate;      // 기간선택에서 선택된 조회시작 날짜
    NSString                *strSelectedEndDate;        // 기간선택에서 선택된 조회종료 날짜
    NSString                *account;        // 계좌번호
    
    int                     intIndex;               // 호출 index
    int                     intOldCount;            // 구 지방세 자료 갯수
    int                     intOldIndex;            // 구 지방세 index
    int                     intMonth;           // 조회기간 관련 변수
    BOOL                    isNew;              // 조회 구분을 위한 BOOL
}

@property (nonatomic, retain) IBOutlet UITableView      *tableView1;

@property (nonatomic, retain) NSMutableArray            *arrayData;             // data Array

- (IBAction)buttonDidPush:(id)sender;

@end
