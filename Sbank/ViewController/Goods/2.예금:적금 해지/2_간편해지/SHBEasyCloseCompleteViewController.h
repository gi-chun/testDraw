//
//  SHBEasyCloseCompleteViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 10..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 상품가입/해지 - 예금/적금 해지 - 신한e-간편해지
 신한e-간편해지 계좌 완료 화면
 */

@interface SHBEasyCloseCompleteViewController : SHBBaseViewController

@property (retain, nonatomic) NSMutableDictionary *smartNewDic;

@property (retain, nonatomic) IBOutlet SHBButton *okBtn;
@property (retain, nonatomic) IBOutlet UIView *smartNewView;

@end
