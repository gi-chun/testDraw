//
//  SHBForexRequestListViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 외환/골드 - 환전신청내역조회
 환전신청 목록 화면
 */

@interface SHBForexRequestListViewController : SHBBaseViewController
<UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@property (retain, nonatomic) IBOutlet UIView *orderView; // 조회기간설정
@property (retain, nonatomic) IBOutlet UILabel *orderInfo; // xxxx.xx.xx~xxxx.xx.xx[x건]
@property (retain, nonatomic) IBOutlet UILabel *noData; // 조회된 거래내역이 없습니다.
@end
