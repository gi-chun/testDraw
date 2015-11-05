//
//  SHBCertRenewStep1ViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBCertRenewStep1ViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UILabel *infoStr1;
@property (nonatomic, retain) IBOutlet UILabel *infoStr2;

- (IBAction) confirmClick:(id)sender; //확인
- (IBAction) cancelClick:(id)sender; //취소

/**
 최초 실행되어 로그인 설정 단계인지...
 */
@property (nonatomic, assign) BOOL isFirstLoginSetting;
@end
