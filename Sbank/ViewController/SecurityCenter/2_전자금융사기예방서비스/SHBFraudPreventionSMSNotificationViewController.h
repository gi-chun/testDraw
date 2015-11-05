//
//  SHBFraudPreventionSMSNotificationViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 7. 29..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
// 보안센터 > 전자금융 사기예방 서비스 > 사기예방 SMS통지 신청/해제

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBSecurityCenterService.h"

@interface SHBFraudPreventionSMSNotificationViewController : SHBBaseViewController
{
    BOOL _isSelection; // 사기예방 SMS통지 신청(NO)/해지(YES) 여부 플래그
}

@property (nonatomic, retain) IBOutlet UIButton *button1;                       // "예, 동의합니다." 버튼
@property (nonatomic, retain) SHBSecurityCenterService *securityCenterService;  // 서비스

@property(nonatomic, retain) IBOutlet UILabel *sumLimitLabel;

- (IBAction)buttonDidPush:(id)sender;                                           // 버튼 액션 이벤트

@end
