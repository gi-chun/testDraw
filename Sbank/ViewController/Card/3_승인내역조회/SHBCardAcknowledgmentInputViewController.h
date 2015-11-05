//
//  SHBCardAcknowledgmentInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBDateField.h"

/**
 신한카드 - 승인내역조회
 승인내역조회 정보 입력 화면
 */

@interface SHBCardAcknowledgmentInputViewController : SHBBaseViewController
<SHBDateFieldDelegate>

@property (retain, nonatomic) IBOutlet UIButton *domestic; // 국내
@property (retain, nonatomic) IBOutlet UIButton *foreignCountry; // 국외
@property (retain, nonatomic) IBOutlet SHBButton *cardNumber; // 카드번호
@property (retain, nonatomic) IBOutlet SHBDateField *startDateField; // 기간선택 시작
@property (retain, nonatomic) IBOutlet SHBDateField *endDateField; // 기간선택 종료

@end
