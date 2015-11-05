//
//  SHBTransferLimitStep2ViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 9. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
// 이체한도감액 - 보안매체 화면 

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBSecurityCenterService.h"

@interface SHBTransferLimitStep2ViewController : SHBBaseViewController <SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *_secretCardViewController; // 보안카드 보안매체 뷰 컨트롤러
    SHBSecretOTPViewController *_secretOTPViewController;   // OTP 보안매체 뷰 컨트롤러
}

@property (nonatomic, retain) IBOutlet UIView *contentView;                                     // 컨텐츠 뷰
@property (nonatomic, retain) IBOutlet UIView *view1;                                           // 서브 뷰
@property (nonatomic, retain) IBOutlet UILabel *label1;                                         // 현재 1일 이체한도
@property (nonatomic, retain) IBOutlet UILabel *label2;                                         // 현재 1회 이체한도
@property (nonatomic, retain) IBOutlet UILabel *label3;                                         // 감액할 1일 이체한도
@property (nonatomic, retain) IBOutlet UILabel *label4;                                         // 감액할 1회 이체한도
@property (nonatomic, retain) SHBSecurityCenterService *securityCenterService;                  // 서비스

@property (nonatomic, retain) IBOutlet UIView *secretView;
@end
