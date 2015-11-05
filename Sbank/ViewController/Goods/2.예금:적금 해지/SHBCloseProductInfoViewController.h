//
//  SHBCloseProductInfoViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 10..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

/**
 해지상품 리스트
 */

#import "SHBBaseViewController.h"

@interface SHBCloseProductInfoViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *button1;           // 해지현황조회 버튼


- (IBAction)buttonDidPush:(id)sender;



@end
