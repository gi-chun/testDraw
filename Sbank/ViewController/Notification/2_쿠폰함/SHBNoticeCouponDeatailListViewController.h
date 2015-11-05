//
//  SHBNoticeCouponDeatailListViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 10. 6..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHBNoticeCouponDeatailListViewController : SHBBaseViewController<UIWebViewDelegate>
{
    
    IBOutlet SHBWebView        *webView1;       // 쿠폰리스트웹
    
    
}

@property (retain, nonatomic) NSDictionary *couponWebDic; //
@end
