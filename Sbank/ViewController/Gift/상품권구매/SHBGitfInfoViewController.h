//
//  SHBGitfInfoViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 21..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBWebView.h"

@interface SHBGitfInfoViewController : SHBBaseViewController <UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet SHBWebView *infoWV;
@end
