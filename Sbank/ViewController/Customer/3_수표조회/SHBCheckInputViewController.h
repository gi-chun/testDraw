//
//  SHBCheckInputViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBListPopupView.h"
#import "SHBDateField.h"
#import "SHBPopupView.h"

@interface SHBCheckInputViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBTextFieldDelegate, SHBDateFieldDelegate, UITextFieldDelegate>

@property (nonatomic, retain) NSString *strMenuTitle;

@property (retain, nonatomic) IBOutlet UIView *mainView;

@property (retain, nonatomic) IBOutlet SHBButton *btnSelectBank;
@property (retain, nonatomic) IBOutlet SHBButton *btnOk;
@property (retain, nonatomic) IBOutlet SHBButton *btnCancel;
@property (retain, nonatomic) IBOutlet SHBButton *btnSelectCheck;

@property (retain, nonatomic) IBOutlet SHBTextField *txtInCheckNo;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInGiroCode;
@property (retain, nonatomic) IBOutlet SHBDateField *txtInDate;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInCheckAmount;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInVerificationCode;

@property (retain, nonatomic) IBOutlet UILabel *labelCheckInputTitle;  // 타이틀
@property (retain, nonatomic) IBOutlet UILabel *labelAmountString;  // 금액한글표시
@property (retain, nonatomic) IBOutlet UIView *viewHelpView;        // 도움말 view1

@end
