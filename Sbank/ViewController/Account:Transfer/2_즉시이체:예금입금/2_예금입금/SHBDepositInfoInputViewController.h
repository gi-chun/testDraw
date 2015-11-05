//
//  SHBDepositInfoInputViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"
#import "SHBSecureTextField.h"
#import "SHBListPopupView.h"
#import "SHBTextField.h"
#import "SHBScrollLabel.h"

@interface SHBDepositInfoInputViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBTextFieldDelegate, SHBSecureDelegate>
{
    SHBAccountService *service;
    NSDictionary *outAccInfoDic;
    NSDictionary *inAccInfoDic;
}
@property (nonatomic, retain) SHBAccountService *service;
@property (retain, nonatomic) NSDictionary *outAccInfoDic;
@property (retain, nonatomic) NSDictionary *inAccInfoDic;

@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW;
@property (retain, nonatomic) IBOutlet UILabel *lblInAccNo;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblInAccName;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInAmount;
@property (retain, nonatomic) IBOutlet UILabel *lblKorMoney;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
