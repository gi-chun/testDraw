//
//  SHBAutoTransferEditViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecureTextField.h"
#import "SHBListPopupView.h"
#import "SHBPopupView.h"
#import "SHBTextField.h"
#import "SHBAccountService.h"
#import "SHBDateField.h"

@interface SHBAutoTransferEditViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBPopupViewDelegate, SHBTextFieldDelegate, SHBSecureDelegate, SHBDateFieldDelegate>
{
    SHBAccountService *service;
    NSDictionary *outAccInfoDic;
}
@property (nonatomic, retain) SHBAccountService *service;
@property (nonatomic, retain) NSDictionary *outAccInfoDic;
@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet SHBButton *btnSelectBank;
@property (retain, nonatomic) IBOutlet UILabel *lblKorMoney;
@property (retain, nonatomic) IBOutlet SHBButton *btnTransferTerm;
@property (retain, nonatomic) IBOutlet SHBButton *btnSelectChange;
@property (retain, nonatomic) IBOutlet SHBDateField *startDateField;
@property (retain, nonatomic) IBOutlet SHBDateField *endDateField;
@property (retain, nonatomic) IBOutlet SHBButton *btnHoliday;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInAccountNo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInAmount;
@property (retain, nonatomic) IBOutlet SHBTextField *txtRecvMemo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtSendMemo;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
