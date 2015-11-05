//
//  SHBCertDetailViewController.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 9. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBCertDetailViewController : SHBBaseViewController <SHBSecureDelegate>{
	
	BOOL isSignupProcess;
	
	BOOL isRequestInsPush;
}

@property (nonatomic, retain) NSString *encryptPwd;
@property (nonatomic, retain) IBOutlet SHBSecureTextField *certPWTextField;
@property (nonatomic, retain) IBOutlet NSMutableArray *certArray;
@property (nonatomic, retain) IBOutlet UILabel *subjectCNLabel;              // 인증서 정보 라벨.
@property (nonatomic, retain) IBOutlet UILabel *issuerAliasTitleLabel;            // 발급자 라벨.
@property (nonatomic, retain) IBOutlet UILabel *issuerAliasLabel;            // 발급자 라벨.
@property (nonatomic, retain) IBOutlet UILabel *certificateOIDAliasTitleLabel;    // 구분 라벨.
@property (nonatomic, retain) IBOutlet UILabel *certificateOIDAliasLabel;    // 구분 라벨.
@property (nonatomic, retain) IBOutlet UILabel *notAfterLabel;               // 만료일자 라벨.
@property (nonatomic, retain) IBOutlet UILabel *notAfterTitle;
@property (nonatomic, retain) IBOutlet UILabel *pwdTitle;

@property (nonatomic, assign) BOOL isSignupProcess; //루트로 가는거 결정
@property (nonatomic, retain) IBOutlet SHBButton *confirmBtn;
@property (nonatomic, retain) IBOutlet SHBButton *cancelBtn;
@property (nonatomic, retain) IBOutlet UIImageView *certImageView;
@property (nonatomic, retain) IBOutlet SHBButton *idBtn;

@property (nonatomic, retain) IBOutlet UILabel *subTitleLabel;
- (IBAction)confirmAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction) pushIDPWDLoginView:(id)sender;
@end
