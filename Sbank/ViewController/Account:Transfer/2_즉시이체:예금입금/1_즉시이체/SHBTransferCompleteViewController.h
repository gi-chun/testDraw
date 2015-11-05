//
//  SHBTransferCompleteViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBTransferCompleteViewController : SHBBaseViewController <UIAlertViewDelegate>
@property (retain, nonatomic) IBOutlet UIView *dataView;
@property (retain, nonatomic) IBOutlet UIView *multiView;
@property (retain, nonatomic) IBOutlet UIView *lineView;

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
@property (retain, nonatomic) IBOutlet UILabel *lblData12;
@property (retain, nonatomic) IBOutlet UILabel *lblTranResultTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblTranResultState;
@property (retain, nonatomic) IBOutlet SHBButton *btnRegAccNo;
@property (retain, nonatomic) IBOutlet SHBButton *btnRegTransfer;
@property (retain, nonatomic) IBOutlet SHBButton *btnSendSMS;
@property (retain, nonatomic) IBOutlet SHBButton *btnSendKakao;
@property (retain, nonatomic) IBOutlet SHBButton *btnSendGagebu;
@property (retain, nonatomic) IBOutlet UIView *feeView;
@property (retain, nonatomic) IBOutlet UIView *buttonView;
@property (retain, nonatomic) IBOutlet UIView *comfirmView;
@property (retain, nonatomic) IBOutlet UILabel *lblTotCnt;
@property (retain, nonatomic) IBOutlet UILabel *lblTotAmt;





- (IBAction)buttonTouchUpInside:(UIButton *)sender;
- (IBAction)selectTap:(UIButton *)sender;
- (IBAction)mainBannerContentClick:(id)sender;

@end
