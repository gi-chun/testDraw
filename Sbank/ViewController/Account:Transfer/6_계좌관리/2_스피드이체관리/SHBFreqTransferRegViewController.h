//
//  SHBFreqTransferRegViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 11..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"
#import "SHBListPopupView.h"
#import "SHBPopupView.h"
#import "SHBTextField.h"

@interface SHBFreqTransferRegViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBPopupViewDelegate, SHBTextFieldDelegate>
{
    int nType;
    SHBAccountService *service;
    NSDictionary *outAccInfoDic;
}
@property (nonatomic        ) int nType;    // 0 : 등록, 1 : 변경, 9 : 등록(이체화면에서 올경우) 
@property (nonatomic, retain) SHBAccountService *service;
@property (nonatomic, retain) NSDictionary *outAccInfoDic;

@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet SHBButton *btnSelectBank;
@property (retain, nonatomic) IBOutlet UILabel *lblKorMoney;

@property (retain, nonatomic) IBOutlet SHBTextField *txtNickName;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInAccountNo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInAmount;
@property (retain, nonatomic) IBOutlet SHBTextField *txtRecvMemo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtSendMemo;
@property (retain, nonatomic) IBOutlet SHBButton *btnOK;
@property (retain, nonatomic) IBOutlet SHBButton *btnCancel;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
