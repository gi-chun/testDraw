//
//  SHBPrimiumInfoViewController.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"

@interface SHBPrimiumInfoViewController : SHBBaseViewController
{
    SHBAccountService *service;
    NSDictionary *accInfoDic;
}
@property (retain, nonatomic) SHBAccountService *service;
@property (retain, nonatomic) NSDictionary *accInfoDic;
@property (retain, nonatomic) IBOutlet UILabel *lblData01;
@property (retain, nonatomic) IBOutlet UILabel *lblData02;
@property (retain, nonatomic) IBOutlet UILabel *lblData03;
@property (retain, nonatomic) IBOutlet UILabel *lblData04;
@property (retain, nonatomic) IBOutlet UILabel *lblData05;
@property (retain, nonatomic) IBOutlet UILabel *lblData06;
@property (retain, nonatomic) IBOutlet SHBButton *btnOut;
@property (retain, nonatomic) IBOutlet SHBButton *btnIn;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;
@end
