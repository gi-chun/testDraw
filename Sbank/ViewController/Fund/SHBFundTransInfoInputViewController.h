//
//  SHBFundTransInfoInputViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBButton.h"
#import "SHBSecureTextField.h"

@interface SHBFundTransInfoInputViewController : SHBBaseViewController<SHBTextFieldDelegate,  SHBSecureDelegate, UITextFieldDelegate>
{
    NSDictionary *data_D6310;
    NSDictionary *data_D6320;
}

@property (nonatomic, retain) NSDictionary *data_D6310;
@property (nonatomic, retain) IBOutlet NSString *accountNo;
@property (retain, nonatomic) IBOutlet UILabel  *amountLabel; // 금액라벨
@property (retain, nonatomic) IBOutlet SHBButton *transBtn; // 출금방식
@property (retain, nonatomic) IBOutlet SHBTextField *textInAmount;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *passwd; // 계좌비밀번호

@end
