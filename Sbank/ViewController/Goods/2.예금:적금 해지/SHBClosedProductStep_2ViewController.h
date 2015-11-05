//
//  SHBClosedProductStep_2ViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 12. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//


/**
 해지계산서조회
 */


#import "SHBBaseViewController.h"

@interface SHBClosedProductStep_2ViewController : SHBBaseViewController<UITableViewDataSource, UITableViewDelegate>


{
    NSDictionary *dicData;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSDictionary *accountList;
@end
