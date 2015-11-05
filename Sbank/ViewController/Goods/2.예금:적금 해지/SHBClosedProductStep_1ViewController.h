//
//  SHBClosedProductStep_1ViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//


/**
 해지된상품 리스트
 */

#import "SHBBaseViewController.h"

@interface SHBClosedProductStep_1ViewController : SHBBaseViewController<UITableViewDataSource, UITableViewDelegate>

{
    NSDictionary *dicData;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
