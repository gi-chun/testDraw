//
//  SHBSmartNewListCell.h
//  ShinhanBank
//
//  Created by Joon on 13. 11. 1..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBScrollLabel.h"

@interface SHBSmartNewListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet SHBButton *joinBtn; // 가입하기
@property (retain, nonatomic) IBOutlet UILabel *productName; // 상품명
@property (retain, nonatomic) IBOutlet SHBScrollLabel *staff; // 상담직원
@property (retain, nonatomic) IBOutlet SHBButton *arrowBtn;
@property (retain, nonatomic) IBOutlet UIView *view01;

@end
