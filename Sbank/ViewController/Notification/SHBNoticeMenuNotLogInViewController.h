//
//  SHBNoticeMenuNotLogInViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 7. 9..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBWebView.h"

@interface SHBNoticeMenuNotLogInViewController : SHBBaseViewController<UIWebViewDelegate>

@property(nonatomic, retain) IBOutlet UILabel	*subTitleLabel;
@property(nonatomic, retain) IBOutlet SHBWebView	*webView;
@property(nonatomic, retain) IBOutlet UITableView *notiTabel;

@end
