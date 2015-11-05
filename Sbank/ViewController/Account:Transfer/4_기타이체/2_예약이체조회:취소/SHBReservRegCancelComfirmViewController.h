//
//  SHBReservRegCancelComfirmViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 14..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBReservRegCancelComfirmViewController : SHBBaseViewController
{
    NSDictionary *infoDic;
}
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *secretView;

@property (retain, nonatomic) NSDictionary *infoDic;
@property (retain, nonatomic) IBOutlet UILabel *lblData01;
@property (retain, nonatomic) IBOutlet UILabel *lblData02;
@property (retain, nonatomic) IBOutlet UILabel *lblData03;
@property (retain, nonatomic) IBOutlet UILabel *lblData04;
@property (retain, nonatomic) IBOutlet UILabel *lblData05;
@property (retain, nonatomic) IBOutlet UILabel *lblData06;
@property (retain, nonatomic) IBOutlet UILabel *lblData07;
@property (retain, nonatomic) IBOutlet UILabel *lblData08;
@property (retain, nonatomic) IBOutlet UILabel *lblData09;

@end
