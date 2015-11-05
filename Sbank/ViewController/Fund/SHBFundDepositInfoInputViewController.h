//
//  SHBFundDepositInfoInputViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBListPopupView.h"
#import "SHBTextField.h"
#import "SHBButton.h"
#import "SHBSecureTextField.h"

@interface SHBFundDepositInfoInputViewController : SHBBaseViewController <SHBTextFieldDelegate,  SHBSecureDelegate, UITextFieldDelegate, SHBListPopupViewDelegate>
{
    // 선택된 계좌정보 dictionary
    NSMutableDictionary     *dicAccountDic;

    IBOutlet SHBTextField   *textFieldMoney;            // 금액 textField

    NSDictionary            *data_D6210;
    NSDictionary            *data_D6100;
}

@property (nonatomic, assign) NSDictionary              *data_D6210;
@property (nonatomic, assign) NSDictionary              *data_D6100;
@property (nonatomic, retain) NSMutableDictionary       *dicDataDictionary;
@property (retain, nonatomic) IBOutlet SHBButton        *accountNumber; // 환전통화
@property (retain, nonatomic) IBOutlet UILabel          *balance; // 출금가능잔액
@property (retain, nonatomic) IBOutlet UILabel          *minAmount; // 최저입금금액
@property (retain, nonatomic) IBOutlet SHBTextField     *textInAmount;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *passwd; // 계좌비밀번호
//@property (retain, nonatomic) NSString                  *encriptedPassword; // 계좌비밀번호
// 이체 가능 계좌 list
@property (nonatomic, retain) NSMutableArray            *canTransferAccountList;
// 계좌 listArray
@property (nonatomic, retain) NSMutableArray            *listArray;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
