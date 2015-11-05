//
//  SHBCardCashServiceViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 현금서비스 이체 화면
 */

@interface SHBCardCashServiceViewController : SHBBaseViewController
<UIWebViewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *mainSV;
@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UILabel *info1;
@property (retain, nonatomic) IBOutlet UILabel *info2;
@property (retain, nonatomic) IBOutlet UIWebView *info3;
@property (retain, nonatomic) IBOutlet UILabel *info4;
@property (retain, nonatomic) IBOutlet UILabel *info5;
@property (retain, nonatomic) IBOutlet UIImageView *bgBox;
@end
