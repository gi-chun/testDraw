//
//  SHBTransferLimitStep3ViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 9. 5..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
// 이체한도감액 - 완료화면

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

@interface SHBTransferLimitStep3ViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UILabel *label1; // 1일 이체한도
@property (nonatomic, retain) IBOutlet UILabel *label2; // 1회 이체한도

- (IBAction)buttonDidPush:(id)sender;                   // 버튼 액션 이벤트

@end
