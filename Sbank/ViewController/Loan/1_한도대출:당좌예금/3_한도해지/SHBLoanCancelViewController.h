//
//  SHBLoanCancelViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 14. 1. 20..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecureTextField.h"
#import "SHBLoanService.h"
#import "SHBScrollLabel.h"

@interface SHBLoanCancelViewController : SHBBaseViewController<SHBSecureDelegate>
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
