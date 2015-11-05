//
//  SHBAccountOrderChangeViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 5..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBAccountOrderChangeViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView    *tableView1;
    
    IBOutlet UIView         *view1;             // 계좌가 없을 경우 view
    
    IBOutlet UIButton       *button1;           // 순서 초기화 버튼
    
    NSString                *strMesage;         // alert message
//    IBOutlet UIView         *viewTableHeader;       // 헤더 view
//    
//    IBOutlet UILabel        *labelHeaderTitle;      // 헤더 타이틀 라벨
    
}

@property (nonatomic, retain) NSMutableArray    *arrayTableData;        // tableDataArray

//@property (nonatomic, retain) NSMutableArray    *array1;
//@property (nonatomic, retain) NSMutableArray    *array2;
//@property (nonatomic, retain) NSMutableArray    *array3;
//@property (nonatomic, retain) NSMutableArray    *array4;

- (IBAction)buttonDidPush:(id)sender;

@end
