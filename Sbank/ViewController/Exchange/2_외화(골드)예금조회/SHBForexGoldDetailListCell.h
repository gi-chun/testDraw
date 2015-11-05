//
//  SHBForexGoldDetailListCell.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 외환/골드 - 외화골드예금조회
 골드리슈예금조회 화면 cell
 */

@interface SHBForexGoldDetailListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *tradeMoneyLabel; // 거래종류 label
@property (retain, nonatomic) IBOutlet UILabel *tradeMoney; // 거래종류
@end
