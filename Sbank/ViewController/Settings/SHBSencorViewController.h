//
//  SHBSencorViewController.h
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 환경설정 > 가속도센서 설정
 */

#import "SHBBaseViewController.h"

@interface SHBSencorViewController : SHBBaseViewController

/**
 가로보기 모드 Label
 */
@property (retain, nonatomic) IBOutlet UILabel *landscapeLabel;

/**
 가로보기 모드 유/무 Switch
 */
@property (retain, nonatomic) IBOutlet UISwitch *landscapeSwitch;

/**
 완료버튼
 */
@property (retain, nonatomic) IBOutlet UIButton *confirmButton;

/**
 완료버튼 눌렀을 때의 액션 : NSUserDefaults에 Switch의 BOOL값을 저장한다.
 */
- (IBAction)confirmButtonAction:(UIButton *)sender;

@end
