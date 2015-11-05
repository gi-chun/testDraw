//
//  SHBDeviceRegistServiceListViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 1. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 보안센터 - 이용기기 등록 서비스 - 이용기기 조회/삭제
 등록폰 조회/삭제 화면
 */

@interface SHBDeviceRegistServiceListViewController : SHBBaseViewController
<UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *dataTable;

@end
