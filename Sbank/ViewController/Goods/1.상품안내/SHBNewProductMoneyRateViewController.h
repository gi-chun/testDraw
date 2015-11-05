//
//  SHBNewProductMoneyRateViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 상품 가입/해지 > 상품안내 > 금리조회
 */

#import "SHBBaseViewController.h"

@interface SHBNewProductMoneyRateViewController : SHBBaseViewController

/**
 현재 선택된 상품 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
 금리조회 URL 스트링
 */
@property (nonatomic, retain) NSString *strURL;

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
