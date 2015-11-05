//
//  SHBForexFavoritListCell.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 외환/골드 - 자주쓰는 해외송금/조회
 자주쓰는 해외송금 목록 화면 cell
 */

@interface SHBForexFavoritListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *arrow;
@property (retain, nonatomic) IBOutlet UIView *line;
@property (retain, nonatomic) IBOutlet UILabel *remittanceDateLabel;
@property (retain, nonatomic) IBOutlet UILabel *remittanceDate; // 송금일
@property (retain, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *bankName; // 수취은행명
@property (retain, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *accountNumber; // 수취인계좌번호
@property (retain, nonatomic) IBOutlet UILabel *consigneeLabel;
@property (retain, nonatomic) IBOutlet UILabel *consignee; // 수취인

@end
