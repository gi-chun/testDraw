//
//  SHBSmartNewListCell4.h
//  ShinhanBank
//
//  Created by Joon on 2014. 8. 12..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBScrollLabel.h"

@interface SHBSmartNewListCell4 : UITableViewCell

@property (retain, nonatomic) IBOutlet SHBButton *joinBtn; // 가입하기
@property (retain, nonatomic) IBOutlet SHBScrollLabel *productName; // 상품명
@property (retain, nonatomic) IBOutlet SHBScrollLabel *staff; // 상담직원
@property (retain, nonatomic) IBOutlet SHBButton *arrowBtn;

@end
