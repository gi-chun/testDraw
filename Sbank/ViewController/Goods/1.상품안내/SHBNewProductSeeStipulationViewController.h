//
//  SHBNewProductSeeStipulationViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 18..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBNewProductStipulationViewController.h"

@interface SHBNewProductSeeStipulationViewController : SHBBaseViewController<UIWebViewDelegate>

@property (nonatomic, retain) NSString *strUrl;

@property (nonatomic, retain) NSString *strName;

//@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet SHBWebView *webView;

- (IBAction)confirmBtnAction:(SHBButton *)sender;

@end
