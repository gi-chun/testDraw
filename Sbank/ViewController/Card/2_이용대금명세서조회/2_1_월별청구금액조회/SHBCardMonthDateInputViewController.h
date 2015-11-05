//
//  SHBCardMonthDateInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBMonthField.h"

/**
 신한카드 - 이용대금 명세서 조회 - 월별 청구금액 조회
 월별 청구금액 조회 화면
 */

@interface SHBCardMonthDateInputViewController : SHBBaseViewController
<UITableViewDelegate, SHBMonthFieldDelegate>

@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@property (retain, nonatomic) IBOutlet SHBMonthField *monthField;

@end
