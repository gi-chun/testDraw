//
//  SHBUrgencyInputAccountViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 영업점/ATM > ATM긴급출금 조회/취소 > ATM긴급출금 조회/취소 계좌선택
 */

#import "SHBBaseViewController.h"
#import "SHBSelectBox.h"
#import "SHBListPopupView.h"

@interface SHBUrgencyInputAccountViewController : SHBBaseViewController <SHBSelectBoxDelegate, SHBSecureDelegate, SHBListPopupViewDelegate>

/**
 출금계좌번호
 */
@property (retain, nonatomic) IBOutlet SHBSelectBox *sbAccountNum;

/**
 계좌비밀번호
 */
@property (retain, nonatomic) IBOutlet SHBSecureTextField *tfAccountPW;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)confirmBtnAction:(SHBButton *)sender;

@end
