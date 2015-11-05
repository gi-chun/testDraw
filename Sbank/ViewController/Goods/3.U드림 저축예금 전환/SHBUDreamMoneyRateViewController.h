//
//  SHBUDreamMoneyRateViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBUDreamMoneyRateViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIWebView *webView;

/**
 금리보기 URL 스트링
 */
@property (nonatomic, retain) NSString *strURL;

@end
