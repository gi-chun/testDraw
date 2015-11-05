//
//  SHBFraudPreventionSMSNotificationLastStepType1ViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 7. 29..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
// 보안센터 > 전자금융 사기예방 서비스 > 사기예방 SMS통지 신청 완료

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

@interface SHBFraudPreventionSMSNotificationLastStepType1ViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UILabel *label1; // 신청일
@property(nonatomic, retain) IBOutlet UILabel *sumLimitLabel;

- (IBAction)buttonDidPush:(id)sender;                   // 버튼 액션 이벤트

@end
