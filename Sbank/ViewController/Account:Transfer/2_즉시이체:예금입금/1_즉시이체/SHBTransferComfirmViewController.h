//
//  SHBTransferComfirmViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBTransferComfirmViewController : SHBBaseViewController
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *secretView;
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


@property (retain, nonatomic) IBOutlet UILabel *lblTotCnt;
@property (retain, nonatomic) IBOutlet UILabel *lblTotAmt;

- (IBAction)selectTap:(UIButton *)sender;
@end
