//
//  SHBWebViewConfirmViewController.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBWebView.h"

@interface SHBWebViewConfirmViewController : SHBBaseViewController <UIWebViewDelegate>{
	IBOutlet SHBWebView	*webView;
	IBOutlet UILabel	*subTitleLabel;
}



- (IBAction)buttonPressed:(UIButton*)sender;

- (void)executeWithTitle:(NSString*)aTitle SubTitle:(NSString*)subTitle RequestURL:(NSString*)request;

@end
