//
//  SHBLoanBizNoVisitViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

/**
 대출 - 직장인 무방문 신용대출
 직장인 최적상품(무방문대출) 신청 안내
 */

@interface SHBLoanBizNoVisitViewController : SHBBaseViewController <UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *infoWV;
@end
