//
//  SHBGoldDepositInputViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 14. 7. 8..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecureTextField.h"
#import "SHBListPopupView.h"
#import "SHBTextField.h"
#import "SHBScrollLabel.h"

@interface SHBGoldDepositInputViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBTextFieldDelegate, SHBSecureDelegate>
{
    NSDictionary *outAccInfoDic;
    NSDictionary *inAccInfoDic;
}
@property (retain, nonatomic) NSDictionary *outAccInfoDic;
@property (retain, nonatomic) NSDictionary *inAccInfoDic;

@property (retain, nonatomic) IBOutlet UILabel *lblAccNoCaption;
@property (retain, nonatomic) IBOutlet UILabel *lblAccNameCaption;

@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW;
@property (retain, nonatomic) IBOutlet UILabel *lblInAccNo;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblInAccName;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrencyCode;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector1;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector2;
@property (retain, nonatomic) IBOutlet UILabel *lblDescript;

@property (retain, nonatomic) IBOutlet UIView *inMoneyView;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInAmount;

@property (retain, nonatomic) IBOutlet UIView *inGoldView;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInGold1;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInGold2;
@property (retain, nonatomic) IBOutlet UIButton *btnComfirm;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
