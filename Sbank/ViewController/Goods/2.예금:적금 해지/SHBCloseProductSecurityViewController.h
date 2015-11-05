//
//  SHBCloseProductSecurityViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBCloseProductConfirmViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"

@interface SHBCloseProductSecurityViewController : SHBBaseViewController <SHBSecretCardDelegate, SHBSecretOTPDelegate>


@property (nonatomic, assign) SHBCloseProductConfirmViewController *confirmVC;


@property (nonatomic, retain) NSMutableDictionary *dicSelectedData;

/**
 보안카드
 */
@property (nonatomic, retain) SHBSecretCardViewController *cardViewController;

/**
 OTP
 */
@property (nonatomic, retain) SHBSecretOTPViewController *otpViewController;


/**
 사용자 입력 데이터
 */
@property (nonatomic, retain) NSString *Close_type;

@end
