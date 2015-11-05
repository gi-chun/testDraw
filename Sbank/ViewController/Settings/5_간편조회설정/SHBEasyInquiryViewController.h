//
//  SHBEasyInquiryViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 환경설정 > 간편조회 설정
 */
#import "SHBBaseViewController.h"
#import "SHBSelectBox.h"
#import "SHBListPopupView.h"

@interface SHBEasyInquiryViewController : SHBBaseViewController <SHBSelectBoxDelegate, SHBListPopupViewDelegate>

@property (retain, nonatomic) IBOutlet UIButton *btnNoSet;
@property (retain, nonatomic) IBOutlet UIButton *btnSet;
@property (retain, nonatomic) IBOutlet SHBSelectBox *sbAccountList;

- (IBAction)radioBtnAction:(UIButton *)sender;
- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
