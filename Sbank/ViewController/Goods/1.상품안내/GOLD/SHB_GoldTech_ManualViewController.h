//
//  SHB_GoldTech_ManualViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 11..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

/**
 상품신규 - 골드리슈골드테크
 투자설명서 및 간이투자설명서
 */

@interface SHB_GoldTech_ManualViewController : SHBBaseViewController <UIWebViewDelegate>
{
    
}

/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;


@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet SHBWebView *marketingWV;
@property (retain, nonatomic) IBOutlet UIScrollView *contentSV;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *checkBtnCollection;

- (void)resetUI;

@end
