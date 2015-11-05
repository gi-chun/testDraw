//
//  SHBLoanCommonInterestPayViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 2..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBListPopupView.h"
#import "SHBSecureTextField.h"
#import "SHBLoanService.h"
#import "SHBScrollLabel.h"

@interface SHBLoanCommonInterestPayViewController : SHBBaseViewController<SHBListPopupViewDelegate, SHBSecureDelegate>
{
    SHBLoanService *service;
    NSDictionary *accountInfo;
    NSDictionary *outAccInfoDic;
}
@property (nonatomic, retain) SHBLoanService *service;
@property (nonatomic, assign) NSDictionary *accountInfo;
@property (retain, nonatomic) NSDictionary *outAccInfoDic;
@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet UILabel *lblBalance;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblAccName;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
