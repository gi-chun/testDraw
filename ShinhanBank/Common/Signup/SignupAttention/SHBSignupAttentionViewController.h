//
//  SHBSignupAttentionViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBWebView.h"

@interface SHBSignupAttentionViewController : SHBBaseViewController <UIWebViewDelegate>{
	IBOutlet SHBWebView	*webView;
}

- (IBAction)buttonPressed:(UIButton*)sender;


@end
