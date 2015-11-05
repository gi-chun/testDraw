//
//  SHBAutoTransferResultInqueryViewController.h
//  ShinhanBank
//
//  Created by 두베 on 12. 12. 9..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBListPopupView.h"
#import "SHBTextField.h"
#import "SHBDateField.h"

@interface SHBAutoTransferResultInqueryViewController : SHBBaseViewController <SHBListPopupViewDelegate, SHBTextFieldDelegate, SHBDateFieldDelegate>
{
    NSDictionary *outAccInfoDic;
}
@property (nonatomic, retain) NSDictionary *outAccInfoDic;
@property (retain, nonatomic) IBOutlet SHBButton *btnAccountNo;
@property (retain, nonatomic) IBOutlet SHBDateField *startDateField;
@property (retain, nonatomic) IBOutlet SHBDateField *endDateField;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector1;
@property (retain, nonatomic) IBOutlet UIButton *btnSelector2;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
