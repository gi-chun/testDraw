//
//  SHBTransferFeeViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 8. 7..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 조회/이체 - 즉시이체 - 이체/예금입금할 계좌선택
 수수료 면제 횟수 조회 화면
 */

@interface SHBTransferFeeViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSString *accountNumber;

@property (retain, nonatomic) IBOutlet UITableView *dataTable;

@end
