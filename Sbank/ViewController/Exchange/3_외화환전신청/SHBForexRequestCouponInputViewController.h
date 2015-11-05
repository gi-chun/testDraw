//
//  SHBForexRequestCouponInputViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBTextField.h"

/**
 외환/골드 - 외화환전신청
 외화환전신청 정보입력(1) 화면
 */

@interface SHBForexRequestCouponInputViewController : SHBBaseViewController
<SHBTextFieldDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet SHBButton *currency; // 환전통화
@property (retain, nonatomic) IBOutlet SHBTextField *money; // 환전금액
@property (retain, nonatomic) IBOutlet SHBTextField *coupon; // 쿠폰번호
@property (retain, nonatomic) NSMutableDictionary *selectCouponDic; // 선택한 쿠폰

@end
