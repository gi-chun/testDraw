//
//  SHBExRateRequestViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBTextField.h"
#import "SHBDateField.h"

@interface SHBExRateRequestViewController : SHBBaseViewController <SHBTextFieldDelegate, SHBDateFieldDelegate, UITextFieldDelegate>

@property (retain, nonatomic) OFDataSet *detailData;

@property (retain, nonatomic) IBOutlet SHBDateField *txtInDate;
//@property (retain, nonatomic) IBOutlet SHBTextField *txtInDate; // 날짜
@property (retain, nonatomic) IBOutlet SHBButton *inquiryCountBtn; // 환전통화

@property (nonatomic, retain) IBOutlet SHBButton *widgetBtn;

- (IBAction)registerWidget:(id)sender;
@end
