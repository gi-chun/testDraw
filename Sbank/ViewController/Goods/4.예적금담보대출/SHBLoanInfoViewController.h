//
//  SHBLoanInfoViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBLoanInfoViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, retain) IBOutlet UIButton *button1; // 전화상담요청 버튼

- (IBAction)applyBtnAction:(SHBButton *)sender;

- (IBAction)buttonDidPush:(id)sender;           // 전화상담요청 버튼 이벤트

@end
