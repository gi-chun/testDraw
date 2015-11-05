//
//  SHBSmartTransferAddInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 9. 24..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBAttentionLabel.h"

/**
 조회/이체 - 기타이체 - 스마트 이체 조회/등록/변경
 조회/등록/변경
 */

@interface SHBSmartTransferAddInputViewController : SHBBaseViewController <SHBTextFieldDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIView *mainV;
@property (retain, nonatomic) IBOutlet SHBButton *account; // 알림 계좌번호

@property (retain, nonatomic) IBOutlet UIButton *incomeTransfer; // 소득이체방식
@property (retain, nonatomic) IBOutlet SHBTextField *standardAmount; // 기준금액 설정(원)
@property (retain, nonatomic) IBOutlet UIButton *rateBtn; // 비율 설정(%)
@property (retain, nonatomic) IBOutlet SHBTextField *rate; // 비율 설정(%)
@property (retain, nonatomic) IBOutlet UIButton *amountBtn; // 금액 설정(원)
@property (retain, nonatomic) IBOutlet SHBTextField *amount; // 금액 설정(원)

@property (retain, nonatomic) IBOutlet UIButton *noticeTransfer; // 알림이체방식
@property (retain, nonatomic) IBOutlet SHBButton *noticeDate; // 통지 일자(매월)
@property (retain, nonatomic) IBOutlet SHBButton *noticeTime; // 통지 시간
@property (retain, nonatomic) IBOutlet SHBTextField *transferAmount; // 이체 금액(원)

@property (retain, nonatomic) IBOutlet UIButton *smartTransferSet; // 스마트이체 설정 설정
@property (retain, nonatomic) IBOutlet UIButton *smartTransferCancel; // 스마트이체 설정 해제

@property (retain, nonatomic) IBOutlet UIView *infoView; // 설정안내
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *info; // 설정안내 문구
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *topInfo; // 설정안내 버튼 아래 안내
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *bottomInfo; // 하단 안내

@end
