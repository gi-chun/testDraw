//
//  SHBAutoTransferViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 6..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecureTextField.h"
#import "SHBListPopupView.h"
#import "SHBPopupView.h"
#import "SHBTextField.h"
#import "SHBAccountService.h"
#import "SHBDateField.h"
#import "SHBMobileCertificateService.h"

@interface SHBAutoTransferViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBPopupViewDelegate, SHBTextFieldDelegate, SHBSecureDelegate, SHBDateFieldDelegate>
{
    SHBAccountService *service;
    NSDictionary *outAccInfoDic;
}

@property (nonatomic, assign) BOOL isInfoBack; // 안내화면에서 돌아온경우
@property (nonatomic, assign) int processFlag;

@property (nonatomic, retain) SHBAccountService *service;
@property (nonatomic, retain) NSDictionary *outAccInfoDic;

@property (nonatomic, retain) SHBMobileCertificateService *securityCenterService;
@property (nonatomic, retain) OFDataSet *securityCenterDataSet;

@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet SHBButton *btnSelectBank;
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;
@property (retain, nonatomic) IBOutlet UILabel *lblKorMoney;
@property (retain, nonatomic) IBOutlet SHBButton *btnTransferTerm;
@property (retain, nonatomic) IBOutlet SHBButton *btnTransferType;
@property (retain, nonatomic) IBOutlet SHBDateField *startDateField;
@property (retain, nonatomic) IBOutlet SHBDateField *endDateField;
@property (retain, nonatomic) IBOutlet SHBButton *btnHoliday;
@property (retain, nonatomic) IBOutlet SHBButton *btnLastDay;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtInAccountNo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInAmount;
@property (retain, nonatomic) IBOutlet SHBTextField *txtRecvMemo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtSendMemo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtEmployee;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
