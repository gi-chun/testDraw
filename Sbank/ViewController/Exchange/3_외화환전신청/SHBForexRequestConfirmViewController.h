//
//  SHBForexRequestConfirmViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 외환/골드 - 외화환전신청
 외화환전신청 확인 화면
 */

@interface SHBForexRequestConfirmViewController : SHBBaseViewController

@property (retain, nonatomic) OFDataSet *exchangeDataInfo;

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIView *securityView; // 보안카드, OTP
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *lineView;

@end
