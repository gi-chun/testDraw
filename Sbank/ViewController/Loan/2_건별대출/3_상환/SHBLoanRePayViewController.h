//
//  SHBLoanRePayViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 2..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBListPopupView.h"
#import "SHBSecureTextField.h"
#import "SHBLoanService.h"
#import "SHBScrollLabel.h"

@interface SHBLoanRePayViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBSecureDelegate>
{
    int nType;  // 0:원리금 상환, 1:원금 상환 
    SHBLoanService *service;
    NSDictionary *accountInfo;
    NSDictionary *outAccInfoDic;
    UILabel *l_noti;
}
@property (nonatomic        ) int nType;    // 0:원리금 상환, 1:원금 상환 
@property (nonatomic, retain) SHBLoanService *service;
@property (nonatomic, assign) NSDictionary *accountInfo;
@property (retain, nonatomic) NSDictionary *outAccInfoDic;
@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;
@property (retain, nonatomic) IBOutlet UIView *accountInfoView1;
@property (retain, nonatomic) IBOutlet UIView *accountInfoView2;
@property (retain, nonatomic) IBOutlet UIView *comfirmView;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblAccName1;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblAccName2;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData1;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData2;

@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW;

@property (nonatomic, retain) IBOutlet UILabel *l_noti;

@property (retain, nonatomic) IBOutlet UIButton *btn_lastAgreeCheck;

/**
 마지막 약관 동의 체크 여부
 */
@property (getter = isLastAgreeCheck) BOOL lastAgreeCheck;


- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
