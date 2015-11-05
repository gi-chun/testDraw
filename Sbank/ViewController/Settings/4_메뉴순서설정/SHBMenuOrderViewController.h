//
//  SHBMenuOrderViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 환경설정 > 메뉴순서 설정
 */

#import "SHBBaseViewController.h"

@interface SHBMenuOrderViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIView *footerView;

- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
