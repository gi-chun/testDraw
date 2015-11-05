//
//  SHBLoanStipulationViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBWebView.h"

@interface SHBLoanStipulationViewController : SHBBaseViewController <UIWebViewDelegate>


@property (retain, nonatomic) IBOutlet SHBWebView *marketingWV;

@property (nonatomic, retain) NSString *Loantype;

- (IBAction)agreeCheckBtnAction:(UIButton *)sender;
- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
