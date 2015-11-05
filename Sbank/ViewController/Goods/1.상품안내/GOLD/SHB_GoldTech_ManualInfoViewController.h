//
//  SHB_GoldTech_ManualInfoViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 12..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

/**
 상품신규 - 골드리슈골드테크
 안내
 */

@interface SHB_GoldTech_ManualInfoViewController : SHBBaseViewController

/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
 쿠폰에서 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicReceiveData;

/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;

@property (retain, nonatomic) IBOutlet UIView *contentView;

@end
