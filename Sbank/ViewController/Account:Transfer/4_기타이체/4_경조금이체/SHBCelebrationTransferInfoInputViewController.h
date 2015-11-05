//
//  SHBCelebrationTransferInfoInputViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 8..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"
#import "SHBListPopupView.h"
#import "SHBSecureTextField.h"
#import "SHBTextField.h"
#import "SHBMobileCertificateService.h" // 추가인증

@interface SHBCelebrationTransferInfoInputViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBTextFieldDelegate, SHBSecureDelegate>
{
    SHBAccountService *service;
    NSDictionary *outAccInfoDic;
}

@property (nonatomic, retain) SHBAccountService *service;
@property (nonatomic, retain) NSDictionary *outAccInfoDic;

@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet SHBButton *btnSelectCelebration;
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;
@property (retain, nonatomic) IBOutlet UILabel *lblKorMoney;

@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtInAccountNo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInAmount;
@property (retain, nonatomic) IBOutlet SHBTextField *txtRecvMemo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtSendMemo;

@property (nonatomic, retain) SHBMobileCertificateService *securityCenterService; // 추가인증
@property (nonatomic, retain) OFDataSet *securityCenterDataSet; // 추가인증

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
