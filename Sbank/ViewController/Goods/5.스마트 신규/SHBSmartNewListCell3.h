//
//  SHBSmartNewListCell3.h
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 24..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBScrollLabel.h"

@interface SHBSmartNewListCell3 : UITableViewCell

@property (retain, nonatomic) IBOutlet SHBButton *joinBtn; // 가입하기
@property (retain, nonatomic) IBOutlet UILabel *productName; // 상품명
@property (retain, nonatomic) IBOutlet SHBScrollLabel *staff; // 상담직원
@property (retain, nonatomic) IBOutlet UILabel *easyCloseProductName; // 만기경과 상품 상품명
@property (retain, nonatomic) IBOutlet SHBButton *arrowBtn;
@property (retain, nonatomic) IBOutlet UIView *view01;
@property (retain, nonatomic) IBOutlet UIView *view02; // 가입기간
@property (retain, nonatomic) IBOutlet UIView *view03; // 가입금액

@end
