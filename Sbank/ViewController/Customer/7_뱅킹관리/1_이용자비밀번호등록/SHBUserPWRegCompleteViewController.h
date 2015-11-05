//
//  SHBUserPWRegCompleteViewController.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 환경설정 > 이용자비밀번호 등록 > 이용자 정보입력(2) > 휴대폰 가입인증 > 이용자비밀번호 등록완료
 */

#import "SHBBaseViewController.h"

@interface SHBUserPWRegCompleteViewController : SHBBaseViewController

@property(nonatomic, retain) IBOutlet UIView *showView;
- (IBAction)confirmBtnAction:(SHBButton *)sender;

@end
