//
//  SHBLoanInterestPayViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 28..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecureTextField.h"
#import "SHBLoanService.h"
#import "SHBScrollLabel.h"

@interface SHBLoanInterestPayViewController : SHBBaseViewController<SHBSecureDelegate>
{
    SHBLoanService *service;
    NSDictionary *accountInfo;
}
@property (nonatomic, retain) SHBLoanService *service;
@property (nonatomic, assign) NSDictionary *accountInfo;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblAccName;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *lblData;
@property (retain, nonatomic) IBOutlet SHBSecureTextField *txtAccountPW;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
