//
//  SHBoldDeviceRegisAddInputViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 13. 9. 3..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBTextField.h"

/**
 구이용pc 변경동의 별병등록 화면
 */


@interface SHBoldDeviceRegisAddInputViewController : SHBBaseViewController
<SHBTextFieldDelegate, UITextFieldDelegate>


@property (retain, nonatomic) IBOutlet SHBTextField *nickName; // 스마트폰 별명
@property (retain, nonatomic) IBOutlet UIView *buttonView; // 확인, 취소


- (IBAction)checkBtn:(id)sender;
- (IBAction)okBtn:(UIButton *)sender;
- (IBAction)cancelBtn:(UIButton *)sender;
@end
