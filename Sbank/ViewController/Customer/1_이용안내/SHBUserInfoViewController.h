//
//  SHBUserInfoViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBWebView.h"

@interface SHBUserInfoViewController : SHBBaseViewController<UIWebViewDelegate>
{
    IBOutlet SHBWebView		*webView;
}
@end
