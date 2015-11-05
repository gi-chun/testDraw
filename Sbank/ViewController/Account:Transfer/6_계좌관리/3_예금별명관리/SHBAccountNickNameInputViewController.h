//
//  SHBAccountNickNameInputViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"
#import "SHBTextField.h"

@interface SHBAccountNickNameInputViewController : SHBBaseViewController<SHBTextFieldDelegate>
{
    SHBAccountService *service;
    NSDictionary *outAccInfoDic;
}

@property (nonatomic, retain) SHBAccountService *service;
@property (nonatomic, retain) NSDictionary *outAccInfoDic;

@property (retain, nonatomic) IBOutlet SHBButton *btnOk;
@property (retain, nonatomic) IBOutlet SHBButton *btnCancel;

@property (retain, nonatomic) IBOutlet UILabel *lblData01;
@property (retain, nonatomic) IBOutlet UILabel *lblData02;
@property (retain, nonatomic) IBOutlet SHBTextField *txtInNickName;

@end
