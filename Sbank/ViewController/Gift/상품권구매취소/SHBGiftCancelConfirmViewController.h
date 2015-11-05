//
//  SHBGiftCancelConfirmViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 상품권 - 모바일상품권 구매취소
 상품권 취소 정보확인 화면
 */

@interface SHBGiftCancelConfirmViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIView *mainView;
@property (retain, nonatomic) IBOutlet UIView *securityView;
@property (retain, nonatomic) IBOutlet UIView *lineView;
@property (retain, nonatomic) IBOutlet UILabel *messageView;

@end
