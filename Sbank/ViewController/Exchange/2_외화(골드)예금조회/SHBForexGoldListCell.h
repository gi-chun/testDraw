//
//  SHBForexGoldListCell.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBButton.h"

/**
 외환/골드 - 외화골드예금조회
 외화골드 계좌목록 화면 cell
 */

@interface SHBForexGoldListCell : UITableViewCell

@property (assign, nonatomic) id pTarget;
@property (assign, nonatomic) SEL pSelector;
@property (nonatomic) int row;

@property (retain, nonatomic) IBOutlet SHBButton *moreBtn; // 더보기
@property (retain, nonatomic) IBOutlet SHBButton *btn1; // 조회
@property (retain, nonatomic) IBOutlet SHBButton *btn2; // 이체, 적립, 입금
@property (retain, nonatomic) IBOutlet SHBButton *btn3; // 매도, 출금
@property (retain, nonatomic) IBOutlet SHBButton *btn4; // 입금
@property (retain, nonatomic) IBOutlet UIView *line;
@property (retain, nonatomic) IBOutlet UILabel *accountName; // 계좌이름
@property (retain, nonatomic) IBOutlet UILabel *accountNumber; // 계좌번호
@property (retain, nonatomic) IBOutlet UILabel *money; // 잔액

- (void)buttonTouchUpInside:(UIButton *)sender;

@end
