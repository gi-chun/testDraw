//
//  SHBFreqAccountInquiryViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBListPopupView.h"
#import "SHBAccountService.h"

@interface SHBFreqAccountInquiryViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBTextFieldDelegate>
{
    SHBAccountService *service;
    NSDictionary *outAccInfoDic;
}

@property (nonatomic, retain) SHBAccountService *service;
@property (nonatomic, retain) NSDictionary *outAccInfoDic;

@property (retain, nonatomic) IBOutlet SHBButton *btnSelectBank;
@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet SHBButton *btnOk;
@property (retain, nonatomic) IBOutlet SHBButton *btnCancel;

@property (retain, nonatomic) IBOutlet SHBTextField *txtInAccountNo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInNickName;

@end
