//
//  SHBClosedProductStep_2Cell.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 12. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBClosedProductStep_2Cell : UITableViewCell



/**
 악세서리뷰
 */
@property (nonatomic, retain) UIImageView *ivAccessory;

/**
거래번호
 */
@property (nonatomic, retain) UILabel *lblName;

/**
 계좌번호
 */
@property (nonatomic, retain) UILabel *lblAccountNo;


/**
 해지일
 */
@property (nonatomic, retain) UILabel *endDate;


/**
 해지금액
 */
@property (nonatomic, retain) UILabel *lblMoney;

@end

