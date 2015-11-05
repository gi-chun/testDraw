//
//  SHBSimpleDistricTaxListViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 6..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSimpleDistricTaxListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView        *tableView1;
    
    IBOutlet UIView         *viewMore;      // 더 보기 view
    
    IBOutlet UILabel            *label1;            // 총 고지건수
    IBOutlet UILabel            *label2;            // 총 고지금액
    
    int                     intIndex;               // 호출 index
}

// 이전 view에서 전달되는 정보 dictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;

@property (nonatomic, retain) NSMutableArray            *arrayData;             // data Array

@end
