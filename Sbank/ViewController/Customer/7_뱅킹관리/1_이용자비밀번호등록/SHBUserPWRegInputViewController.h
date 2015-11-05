//
//  SHBUserPWRegInputViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 환경설정 > 이용자비밀번호 등록 > 이용자 정보입력(2)
 */

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBUserPWRegInputViewController : SHBBaseViewController <UITextFieldDelegate, SHBTextFieldDelegate, SHBSecureDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *ivBox;

/**
 이용자 ID
 */
@property (retain, nonatomic) IBOutlet UILabel *lblID;

/**
 이름(실명)
 */
@property (retain, nonatomic) IBOutlet UILabel *lblName;

/**
 이용자 비밀번호
 */
@property (retain, nonatomic) IBOutlet SHBSecureTextField *tfPW;

/**
 이용자 비밀번호확인
 */
@property (retain, nonatomic) IBOutlet SHBSecureTextField *tfPWConfirm;

/**
 계좌번호
 */
@property (retain, nonatomic) IBOutlet SHBTextField *tfAccountNo;

/**
 계좌비밀번호
 */
@property (retain, nonatomic) IBOutlet SHBSecureTextField *tfAccountPW;

/**
 서비스코드 스트링 : @"H1001" 또는 @"A0051" 값으로 셋팅
 */
@property (nonatomic, retain) NSString *strServiceCode;


- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)cancelBtnAction:(SHBButton *)sender;

@end
