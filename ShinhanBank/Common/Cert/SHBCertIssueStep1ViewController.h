//
//  SHBCertIssueStep1ViewController.h
//  ShinhanBank
//
//  Created by RedDragon on 12. 11. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBCertIssueStep1ViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UIButton *agreeBtn;
@property (nonatomic, retain) IBOutlet UILabel *contentsLabel;
@property (nonatomic, assign) BOOL isFirstLoginSetting;

- (IBAction) yesTermsClick:(id)sender;  //yes 약과보기
- (IBAction) elecBaseTermsClick:(id)sender; //전자금융 기본 약관

- (IBAction) confirmClick:(id)sender; //확인
- (IBAction) cancelClick:(id)sender; //취소

- (IBAction) agreeClick:(id)sender; //동의 클릭

- (IBAction) testClick:(id)sender;
@end
