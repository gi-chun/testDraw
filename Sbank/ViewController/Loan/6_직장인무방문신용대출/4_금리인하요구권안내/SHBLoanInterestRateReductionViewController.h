//
//  SHBLoanInterestRateReductionViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

/**
 대출 - 직장인 무방문 신용대출
 금리인하 요구권 안내
 */

@interface SHBLoanInterestRateReductionViewController : SHBBaseViewController <UIWebViewDelegate>

//@property (retain, nonatomic) IBOutlet UIWebView *infoWV;
@property (retain, nonatomic) IBOutlet SHBWebView *infoWV;

@end
