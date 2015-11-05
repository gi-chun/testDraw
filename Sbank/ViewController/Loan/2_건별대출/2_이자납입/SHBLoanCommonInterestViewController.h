//
//  SHBLoanCommonInterestViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 12. 2..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBLoanService.h"
#import "SHBDateField.h"
#import "SHBScrollLabel.h"

@interface SHBLoanCommonInterestViewController : SHBBaseViewController<SHBDateFieldDelegate>
{
    SHBLoanService *service;
    NSDictionary *accountInfo;
}
@property (nonatomic, retain) SHBLoanService *service;
@property (nonatomic, assign) NSDictionary *accountInfo;
@property (retain, nonatomic) IBOutlet SHBDateField *standardDate;
@property (retain, nonatomic) IBOutlet UILabel *lblAccNo;
@property (retain, nonatomic) IBOutlet SHBScrollLabel *lblTitle;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
