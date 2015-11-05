//
//  SHBCardMonthDateInputCell.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 신한카드 - 이용대금 명세서 조회 - 월별 청구금액 조회
 월별 청구금액 조회 화면 cell
 */

@interface SHBCardMonthDateInputCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *arrow;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *date; // 청구날짜
@property (retain, nonatomic) IBOutlet UILabel *cardName; // 카드명
@end
