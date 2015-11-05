//
//  SHBTickerViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 13. 1. 9..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBWebView.h"
@interface SHBTickerViewController : SHBBaseViewController <UIWebViewDelegate>
{
    IBOutlet SHBWebView	*webView;
}
- (IBAction) closeBtn:(id)sender;
- (void)executeWithTitle:(NSString*)aTitle SubTitle:(NSString*)subTitle RequestURL:(NSString*)request;
@end
