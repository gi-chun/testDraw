//
//  SHB_GoldTech_ProductInfoViewcontroller.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 11. 6..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
@interface SHB_GoldTech_ProductInfoViewcontroller : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIView *baseView;	// 웹뷰와 Bottom의 상위뷰

/**
 상품정보 웹뷰
 */
@property (retain, nonatomic) IBOutlet UIWebView *wvProductInfo;


@property (retain, nonatomic) IBOutlet UIButton *btn_lastAgreeCheck;
/**
 마지막 약관 동의 체크 여부
 */
@property (getter = isLastAgreeCheck) BOOL lastAgreeCheck;


/**
 동의여부 체크 버튼 액션
 */
- (IBAction)agreeCheckBtnAction:(UIButton *)sender;



/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;


/**
 가입 버튼 액션
 */
- (IBAction)joinBtnAction:(UIButton *)sender;



@end
