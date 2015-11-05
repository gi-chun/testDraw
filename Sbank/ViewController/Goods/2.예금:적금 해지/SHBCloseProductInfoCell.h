//
//  SHBCloseProductInfoCell.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBCloseProductInfoCell : UITableViewCell

/**
 악세서리뷰
 */
@property (nonatomic, retain) UIImageView *ivAccessory;

/**
 상품명
 */
@property (nonatomic, retain) UILabel *lblName;

/**
 계좌번호
 */
@property (nonatomic, retain) UILabel *lblAccountNo;

//잔액
@property (nonatomic, retain) UILabel *lblMoney;
@property (nonatomic, retain) UILabel *Money;

//만기일
@property (nonatomic, retain) UILabel *lbldate;
@property (nonatomic, retain) UILabel *date;
@end
