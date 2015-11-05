//
//  SHBLoanBizNoVisitListDetailViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 11. 21..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

/**
 대출 - 직장인 무방문 신용대출
 직장인신용대출상품 목록 안내
 */

@interface SHBLoanBizNoVisitListDetailViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet SHBScrollLabel *subTitleView;
@property (retain, nonatomic) IBOutlet UIWebView *contentWV;
@end
