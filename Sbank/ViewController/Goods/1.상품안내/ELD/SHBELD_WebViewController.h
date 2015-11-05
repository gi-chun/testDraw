//
//  SHBELD_WebViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 23..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
//  상품가입 > 예금/적금가입 > 지수연동예금상품 > 공통 웹 뷰컨트롤러

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBWebView.h"

@interface SHBELD_WebViewController : SHBBaseViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet SHBWebView *webView1;        // 웹뷰
@property (nonatomic, retain) NSMutableDictionary *viewDataSource;  // 뷰 - 데이타 소스
@property (nonatomic, retain) IBOutlet UIView *view1;               // 하단 확인 버튼 뷰
@property (nonatomic, retain) IBOutlet UIView *view2;               // 하단 확인, 문의하기 뷰

- (IBAction)buttonDidPush:(id)sender;                               // 확인 버튼 - 액션

@end
