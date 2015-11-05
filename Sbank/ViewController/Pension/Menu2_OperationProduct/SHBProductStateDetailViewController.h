//
//  SHBProductStateDetailViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 14..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBProductStateDetailViewController : SHBBaseViewController <UITableViewDelegate>
{
    IBOutlet UITableView        *tableView1;
    
    IBOutlet UILabel            *label1;        // 플랜명
    IBOutlet UILabel            *label2;        // 계좌번호
    IBOutlet UILabel            *label3;        // 기준일자
}

// 이전에서 넘어온 dataDictionary
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;


@end
