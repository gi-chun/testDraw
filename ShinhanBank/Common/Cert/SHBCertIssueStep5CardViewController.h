//
//  SHBCertIssueStep5CardViewController.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 27..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"

@interface SHBCertIssueStep5CardViewController : SHBBaseViewController <SHBSecureDelegate,UITextFieldDelegate, SHBTextFieldDelegate>

@property (nonatomic, retain) NSString *encryptPwd1;
@property (nonatomic, retain) NSString *encryptPwd2;
@property (nonatomic, retain) NSString *encryptPwd3;
@property (nonatomic,retain) IBOutlet SHBSecureTextField *accountTransferPwdTextField;
@property (nonatomic,retain) IBOutlet SHBSecureTextField *secureCardSerialNO1TextField;
@property (nonatomic,retain) IBOutlet SHBSecureTextField *secureCardSerialNO2TextField;
@property (nonatomic,retain) IBOutlet SHBSecureTextField *secureCardSerialNO3TextField;
@property (nonatomic,retain) IBOutlet SHBSecureTextField *secureCardSerialNO4TextField;
@property (nonatomic,retain) IBOutlet SHBSecureTextField *secureCardSerialNO5TextField;
@property (nonatomic,retain) IBOutlet SHBSecureTextField *secureCardSerialNO6TextField;
@property (nonatomic,retain) IBOutlet SHBSecureTextField *secureCardSerialNO7TextField;
@property (nonatomic,retain) IBOutlet SHBSecureTextField *secureCardSerialNO8TextField;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *frontNumTextField;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *backNumTextField;

@property(nonatomic, retain) IBOutlet UILabel *frontLabel;
@property(nonatomic, retain) IBOutlet UILabel *frontNumberLabel;
@property(nonatomic, retain) IBOutlet UILabel *backLabel;
@property(nonatomic, retain) IBOutlet UILabel *backNumberLabel;
@property(nonatomic, retain) IBOutlet UILabel *secureFrontLabel;

@property (nonatomic, retain) IBOutlet SHBTextField *accountEmailTextField;
@property (nonatomic, retain) IBOutlet SHBTextField *accountPhoneTextField;
@property (nonatomic, retain) IBOutlet SHBDataSet *transDataSet;
@property (nonatomic, retain) IBOutlet UIView *mainView;

@property(nonatomic, retain) IBOutlet UIImageView *mark1ImageView;
@property(nonatomic, retain) IBOutlet UIImageView *mark2ImageView;
@property (nonatomic, assign) BOOL isFirstLoginSetting;

//보안카드 3회 정상 입력인데도 계속 인증 시도해 보안카드 번호를 획득하는 해킹을 방지하기 위해 C2098전문에 다음 전문 코드를 입력하기 위해 사용한다
@property(nonatomic, retain) NSString *nextSVC;

- (IBAction) confirmClick:(id)sender; //확인
- (IBAction) cancelClick:(id)sender; //취소

- (IBAction) accountTransferClick:(id)sender; //확인
- (IBAction) secureCardSerialNO1Click:(id)sender;
- (IBAction) secureCardSerialNO2Click:(id)sender;
- (IBAction) secureCardSerialNO3Click:(id)sender;
- (IBAction) secureCardSerialNO4Click:(id)sender;
- (IBAction) secureCardSerialNO5Click:(id)sender;
- (IBAction) secureCardSerialNO6Click:(id)sender;
- (IBAction) secureCardSerialNO7Click:(id)sender;
- (IBAction) secureCardSerialNO8Click:(id)sender;
- (IBAction) frontNumClick:(id)sender;
- (IBAction) backNumClick:(id)sender;

@end
