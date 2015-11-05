//
//  SHBPrimiumTransferViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"
#import "SHBTextField.h"
#import "SHBSecureTextField.h"
#import "SHBListPopupView.h"

@interface SHBPrimiumTransferViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBTextFieldDelegate, SHBSecureDelegate>
{
    SHBAccountService *service;
    NSDictionary *outAccInfoDic;
}
@property (nonatomic, retain) SHBAccountService *service;
@property (nonatomic, retain) NSDictionary *outAccInfoDic;
@property (retain, nonatomic) IBOutlet UILabel *lblOutAccNo;
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;
@property (retain, nonatomic) IBOutlet UILabel *lblInterrest;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector1;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector2;
@property (retain, nonatomic) IBOutlet SHBTextField *txtAmount;
@property (retain, nonatomic) IBOutlet UILabel *lblKorMoney;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW;
@property (retain, nonatomic) IBOutlet SHBButton *btnInAccNo;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
