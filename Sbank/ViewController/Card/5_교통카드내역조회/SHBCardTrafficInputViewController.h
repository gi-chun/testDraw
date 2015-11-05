//
//  SHBCardTrafficInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBDateField.h"

/**
 신한카드 - 교통카드 내역조회
 교통카드 내역조회 정보 입력 화면
 */

@interface SHBCardTrafficInputViewController : SHBBaseViewController
<SHBDateFieldDelegate>

@property (retain, nonatomic) IBOutlet SHBButton *cardNumber; // 카드번호
@property (retain, nonatomic) IBOutlet SHBDateField *startDateField; // 기간선택 시작
@property (retain, nonatomic) IBOutlet SHBDateField *endDateField; // 기간선택 종료

@end
