//
//  SHBUDreamInfoViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 10..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBUDreamInfoViewController : SHBBaseViewController


@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;

/**
 금리상세 버튼액션
 */
- (IBAction)interestBtnAction:(UIButton *)sender;

/**
 예금전환 버튼액션
 */
- (IBAction)depositBtnAction:(UIButton *)sender;

@end
