//
//  SHBEasyCloseViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 10..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 상품가입/해지 - 예금/적금 해지 - 신한e-간편해지
 신한e-간편해지 서비스 신청 화면
 */

@interface SHBEasyCloseViewController : SHBBaseViewController

@property (retain, nonatomic) NSMutableDictionary *smartNewDic;

@property (retain, nonatomic) IBOutlet UIButton *agree1;
@property (retain, nonatomic) IBOutlet UIButton *agree2;
@property (retain, nonatomic) IBOutlet UILabel *infoL;

- (void)resetUI;

@end
