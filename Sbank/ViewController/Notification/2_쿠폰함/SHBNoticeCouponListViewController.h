//
//  SHBNoticeCouponListViewController.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 12. 27..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBNoticeCouponDetailViewController.h"

@interface SHBNoticeCouponListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView        *tableView1;
    
    IBOutlet UIView         *viewMore;      // 더 보기 view
    
    IBOutlet UILabel        *labelNoList;       // 조회된 것 없을 때
    
    NSArray        *arrayData;
    
    int                     intIndex;               // 현재 index
    int                     intSelectRow;           // 선택된 row
}

@property (retain, nonatomic) SHBNoticeCouponDetailViewController *noticeCouponDetailViewController;

@end
