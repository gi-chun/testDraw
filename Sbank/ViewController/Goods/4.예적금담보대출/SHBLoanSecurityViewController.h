//
//  SHBLoanSecurityViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

@interface SHBLoanSecurityViewController : SHBBaseViewController <SHBSecretCardDelegate, SHBSecretOTPDelegate>

@property (retain, nonatomic) IBOutlet UIView *bottomView;

/**
 보안카드
 */
@property (nonatomic, retain) SHBSecretCardViewController *cardViewController;

/**
 OTP
 */
@property (nonatomic, retain) SHBSecretOTPViewController *otpViewController;

/**
 사용자입력 데이터
 */
@property (nonatomic, retain) NSMutableDictionary *userItem;

@property (nonatomic, retain) NSDictionary *L1311;

- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
