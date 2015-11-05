//
//  SHBClosedProductCell.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBScrollLabel.h"

@interface SHBClosedProductStep_1Cell : UITableViewCell


/**
 악세서리뷰
 */
@property (nonatomic, retain) UIImageView *ivAccessory;

/**
 상품명
 */
@property (nonatomic, retain) SHBScrollLabel *lblName;

/**
 계좌번호
 */
@property (nonatomic, retain) UILabel *lblAccountNo;


/**
해지일
 */
@property (nonatomic, retain) UILabel *endDate;


/**
신규일
 */
@property (nonatomic, retain) UILabel *startDate;

@end
