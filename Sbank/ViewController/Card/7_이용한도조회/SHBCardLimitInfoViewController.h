//
//  SHBCardLimitInfoViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 신한카드 - 이용한도조회
 이용한도조회 화면
 */

@interface SHBCardLimitInfoViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet SHBButton *cardNumber;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@end
