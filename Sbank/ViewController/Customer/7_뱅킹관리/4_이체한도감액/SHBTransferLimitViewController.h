//
//  SHBTransferLimitViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 9. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
// 이체한도감액 - 메인화면

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBSecurityCenterService.h"

@interface SHBTransferLimitViewController : SHBBaseViewController <SHBTextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIView *contentView;                     // 컨텐츠 뷰
@property (nonatomic, retain) IBOutlet UILabel *label1;                         // 현재 1일 이체한도
@property (nonatomic, retain) IBOutlet UILabel *label2;                         // 현재 1회 이체한도
@property (nonatomic, retain) IBOutlet SHBTextField *textField1;                // 감액할 1일 이체한도
@property (nonatomic, retain) IBOutlet SHBTextField *textField2;                // 감액할 1회 이체한도
@property (nonatomic, retain) SHBSecurityCenterService *securityCenterService;  // 서비스
@property (nonatomic, retain) OFDataSet *viewDataSet;                           // 데이타셋

- (IBAction)buttonDidPush:(id)sender;                                           // 버튼 액션 이벤트

@end
