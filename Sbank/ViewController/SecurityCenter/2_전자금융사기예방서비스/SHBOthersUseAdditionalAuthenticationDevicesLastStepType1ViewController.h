//
//  SHBOthersUseAdditionalAuthenticationDevicesLastStepType1ViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 7. 30..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
// 보안센터 > 전자금융 사기예방 서비스 > 이용기기 외 추가인증 서비스 신청 완료

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

@interface SHBOthersUseAdditionalAuthenticationDevicesLastStepType1ViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UILabel *label1; // 신청일
@property (nonatomic, retain) IBOutlet UILabel *label2; // 300만원 관련 안내문구 라벨

@property(nonatomic, retain) IBOutlet UILabel *sumLimitLabel;

- (IBAction)buttonDidPush:(id)sender;                   // 버튼 액션 이벤트

@end
