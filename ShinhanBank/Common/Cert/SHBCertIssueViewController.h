//
//  SHBCertIssueViewController.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBWebView.h"
@interface SHBCertIssueViewController : SHBBaseViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet SHBWebView *termsView;
@property (nonatomic, retain) NSString *connectURL;

- (IBAction) confirmClick:(id)sender; //확인
- (IBAction) testClick:(id)sender; //확인

@end
