//
//  SHBSimpleLoanInfoViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 6. 13..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 대출 - 약정업체 간편대출
 약정업체 간편대출 신청 안내 화면
 */

@interface SHBSimpleLoanInfoViewController : SHBBaseViewController<UIWebViewDelegate>

//@property (retain, nonatomic) IBOutlet UIWebView *infoWV;
@property (retain, nonatomic) IBOutlet SHBWebView *infoWV;

@end
