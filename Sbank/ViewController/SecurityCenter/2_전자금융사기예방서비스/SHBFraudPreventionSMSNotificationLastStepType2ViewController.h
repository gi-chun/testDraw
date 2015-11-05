//
//  SHBFraudPreventionSMSNotificationLastStepType2ViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 7. 29..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
// 보안센터 > 전자금융 사기예방 서비스 > 사기예방 SMS통지 해제 완료

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

@interface SHBFraudPreventionSMSNotificationLastStepType2ViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UILabel *label1; // 해제일

@property(nonatomic, retain) IBOutlet UILabel *sumLimitLabel;

- (IBAction)buttonDidPush:(id)sender;                   // 버튼 액션 이벤트

@end
