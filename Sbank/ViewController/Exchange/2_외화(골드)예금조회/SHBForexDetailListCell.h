//
//  SHBForexDetailListCell.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 외환/골드 - 외화골드예금조회
 외화예금조회 화면 cell
 */

@interface SHBForexDetailListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *inName; // 입금의뢰인 이름
@property (retain, nonatomic) IBOutlet UILabel *inOutValueLabel; // 입출금종류 label
@property (retain, nonatomic) IBOutlet UILabel *inOutValue; // 입출금종류
@property (retain, nonatomic) IBOutlet UILabel *interestRateLabel; // 회차(이율) label
@property (retain, nonatomic) IBOutlet UILabel *interestRate; // 회차(이율)
@property (retain, nonatomic) IBOutlet UIView *cancelMoneyView; // 정정취소구분, 거래원화금액 화면
@end
