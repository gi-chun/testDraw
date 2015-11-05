//
//  SHBELD_BA17_3ViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 23..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
//  상품가입 > 예금/적금가입 > 지수연동예금상품 > BA17-3

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBWebView.h"

@interface SHBELD_BA17_3ViewController : SHBBaseViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet SHBWebView *webView1;        // 웹뷰
@property (nonatomic, retain) NSMutableDictionary *viewDataSource;  // 푸시 데이타
@property (nonatomic, retain) IBOutlet UIButton *button1;           // 전화상담요청 버튼

- (IBAction)buttonDidPush:(id)sender;                               // 수익률범위, 가입 버튼 - 액션

@end