//
//  SHBTransferResultViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBPopupView.h"
#import "SHBTextField.h"

@interface SHBTransferResultViewController : SHBBaseViewController <SHBTextFieldDelegate, SHBPopupViewDelegate>
{
    NSDictionary *infoDic;
}
@property (retain, nonatomic) IBOutlet UILabel *lblData01;
@property (retain, nonatomic) IBOutlet UILabel *lblData02;
@property (retain, nonatomic) IBOutlet UILabel *lblData03;
@property (retain, nonatomic) IBOutlet UILabel *lblData04;
@property (retain, nonatomic) IBOutlet UILabel *lblData05;
@property (retain, nonatomic) IBOutlet UILabel *lblData06;
@property (retain, nonatomic) IBOutlet UILabel *lblData07;
@property (retain, nonatomic) IBOutlet UILabel *lblData08;
@property (retain, nonatomic) IBOutlet UILabel *lblData09;
@property (retain, nonatomic) IBOutlet UILabel *lblData10;
@property (retain, nonatomic) IBOutlet UILabel *lblData11;
@property (retain, nonatomic) IBOutlet UILabel *lblCaption;
@property (retain, nonatomic) IBOutlet SHBButton *btnFaxSend;
@property (retain, nonatomic) IBOutlet SHBButton *btnRegTransfer;
@property (retain, nonatomic) IBOutlet SHBButton *btnOK;

@property (retain, nonatomic) IBOutlet UIView *faxInfoView;
@property (retain, nonatomic) IBOutlet SHBTextField *txtFaxNo;
@property (nonatomic, assign) NSDictionary *infoDic;
- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
