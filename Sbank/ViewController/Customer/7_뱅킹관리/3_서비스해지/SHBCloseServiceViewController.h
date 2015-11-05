//
//  SHBCloseServiceViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSelectBox.h"
#import "SHBListPopupView.h"

@interface SHBCloseServiceViewController : SHBBaseViewController <SHBSecureDelegate, SHBSelectBoxDelegate, SHBListPopupViewDelegate>

@property (retain, nonatomic) IBOutlet SHBSelectBox *sbAccountList;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *tfAccountPW;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)yesBtnAction:(SHBButton *)sender;
- (IBAction)noBtnAction:(SHBButton *)sender;

@end
