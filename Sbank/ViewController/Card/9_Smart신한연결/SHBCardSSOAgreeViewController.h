//
//  SHBCardSSOAgreeViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 13. 12. 17..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBCardSSOAgreeViewController : SHBBaseViewController
@property(retain, nonatomic) IBOutlet UIButton *agreeCheck; // 예, 동의합니다.
@property(nonatomic, assign) BOOL isInfoSee; // 신한카드 서비스 이용동의 확인 여부

-(void)setagreeValue:(BOOL)agreeValue;
@end
