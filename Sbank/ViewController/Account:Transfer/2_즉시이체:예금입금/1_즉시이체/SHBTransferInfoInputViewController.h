//
//  SHBTransferInfoInputViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"
#import "SHBSecureTextField.h"
#import "SHBListPopupView.h"
#import "SHBPopupView.h"
#import "SHBTextField.h"
#import "SHBMobileCertificateService.h"

@interface SHBTransferInfoInputViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBPopupViewDelegate, SHBTextFieldDelegate, SHBSecureDelegate>
{
    SHBAccountService *service;
    NSDictionary *outAccInfoDic;
     
}

@property (nonatomic, assign) int processFlag;

@property (nonatomic, retain) SHBAccountService *service;
@property (nonatomic, retain) NSDictionary *outAccInfoDic;

@property (nonatomic, retain) SHBMobileCertificateService *securityCenterService;
@property (nonatomic, retain) OFDataSet *securityCenterDataSet;

@property (retain, nonatomic) IBOutlet UIView *contentsView;
@property (retain, nonatomic) IBOutlet UIView *additionTransferBgView;
@property (retain, nonatomic) IBOutlet UIView *inputView;

@property (retain, nonatomic) IBOutlet UIButton *btnTab;
@property (retain, nonatomic) IBOutlet UIButton *btnTab1;
@property (retain, nonatomic) IBOutlet UIButton *btnTab2;
@property (retain, nonatomic) IBOutlet UIButton *btnTab3;
@property (retain, nonatomic) IBOutlet UIButton *btnTab4;
@property (retain, nonatomic) IBOutlet UIButton *btnTab5;

@property (retain, nonatomic) IBOutlet UIView *cancelView;

@property (retain, nonatomic) IBOutlet UILabel *lblTotCnt;
@property (retain, nonatomic) IBOutlet UILabel *lblTotAmt;

@property (retain, nonatomic) IBOutlet UILabel *lblData01;
@property (retain, nonatomic) IBOutlet UILabel *lblData02;
@property (retain, nonatomic) IBOutlet UILabel *lblData03;
@property (retain, nonatomic) IBOutlet UILabel *lblData04;
@property (retain, nonatomic) IBOutlet UILabel *lblData05;
@property (retain, nonatomic) IBOutlet UILabel *lblData06;
@property (retain, nonatomic) IBOutlet UILabel *lblData07;
@property (retain, nonatomic) IBOutlet UILabel *lblData08;
@property (retain, nonatomic) IBOutlet UILabel *lblData09;
@property (retain, nonatomic) IBOutlet UILabel *lblData11;
@property (retain, nonatomic) IBOutlet UILabel *lblData12;
@property (retain, nonatomic) IBOutlet UILabel *lblData13;
@property (retain, nonatomic) IBOutlet UILabel *lblData14;
@property (retain, nonatomic) IBOutlet UILabel *lblData15;
@property (retain, nonatomic) IBOutlet UILabel *lblData16;
@property (retain, nonatomic) IBOutlet UILabel *lblData17;
@property (retain, nonatomic) IBOutlet UILabel *lblData18;
@property (retain, nonatomic) IBOutlet UILabel *lblData19;

@property (retain, nonatomic) IBOutlet UIView *buttonView1;
@property (retain, nonatomic) IBOutlet UIView *buttonView2;

@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet SHBButton *btnSelectBank;
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;
@property (retain, nonatomic) IBOutlet UILabel *lblKorMoney;

@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtInAccountNo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInAmount;
@property (retain, nonatomic) IBOutlet SHBTextField *txtRecvMemo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtSendMemo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtCMSCode;
@property (retain, nonatomic) IBOutlet UIView *comfirmView;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
- (IBAction)selectTap:(UIButton *)sender;

- (NSString *)getServiceCode:(NSString *)strBankName withAccCode:(NSString *)strAccCode;
@end
