//
//  SHBWebView.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebFrame;

@interface SHBWebView : UIWebView
{
	bool confirmResult;
@private
    bool alertViewClick;
}
- (void)loadRequestWithString:(NSString*)request;

- (void)loadRequestWithString:(NSString*)request delegateObj:(id)aDelegateObj; //새로 만듬

- (void)loadRequestWithStringFile:(NSString *)request; // pdf

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
