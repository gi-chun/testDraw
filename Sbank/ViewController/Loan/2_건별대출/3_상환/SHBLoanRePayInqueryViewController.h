//
//  SHBLoanRePayInqueryViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBLoanService.h"
#import "SHBTextField.h"

@interface SHBLoanRePayInqueryViewController : SHBBaseViewController
{
    SHBLoanService *service;
    NSDictionary *accountInfo;
}
@property (nonatomic, retain) SHBLoanService *service;
@property (nonatomic, assign) NSDictionary *accountInfo;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector1;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector2;
@property (retain, nonatomic) IBOutlet SHBTextField *txtRePayAmount;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
