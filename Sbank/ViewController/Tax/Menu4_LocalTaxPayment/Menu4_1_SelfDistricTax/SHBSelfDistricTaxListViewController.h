//
//  SHBSelfDistricTaxListViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 16..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSelfDistricTaxListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView         *viewMore;      // 더 보기 view
    
    IBOutlet UILabel        *label1;        // 총 고지건수
    IBOutlet UILabel        *label2;        // 총 고지금액

    int                     intIndex;               // 호출 index
    NSString                *strSimpleNumber;       // 간편납부 번호
}

@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;     // 전달받은 data Dictionary
@property (nonatomic, retain) NSMutableArray            *arrayData;             // data Array

@property (nonatomic, retain) IBOutlet UITableView      *tableView1;         // tableView

@end
