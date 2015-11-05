//
//  SHBUserInfoEditSIDViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 12. 7..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBTextField.h"

/**
 고객센터 - 고객정보변경
 회원본인확인 화면
 */

@interface SHBUserInfoEditSIDViewController : SHBBaseViewController
<SHBTextFieldDelegate, SHBSecureDelegate, UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet SHBTextField *jumin1; // 주민등록번호 앞자리
@property (retain, nonatomic) IBOutlet SHBSecureTextField *jumin2; // 주민등록번호 뒷자리
@property (retain, nonatomic) IBOutlet UIImageView *bgBox;
@property (retain, nonatomic) IBOutlet UILabel *info; // 본인확인을 위해 주민등록번호를 입력하여 주십시오.
@property (retain, nonatomic) IBOutlet UIView *bottomView;

@end
