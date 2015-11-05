//
//  SHBUserInfoUseSupplyViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 10. 29..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 고객센터 - 본인정보 이용제공 조회시스템
 본인정보 이용제공 조회시스템 화면
 */

@interface SHBUserInfoUseSupplyViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIView *noAgreeView;

@property (retain, nonatomic) IBOutlet UIView *agreeView;
@property (retain, nonatomic) IBOutlet UILabel *agreeDate;
@property (retain, nonatomic) IBOutlet UILabel *agreeLocation;
@property (retain, nonatomic) IBOutlet UILabel *agreeChannel;

@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UILabel *supplyInfo;

@property (retain, nonatomic) IBOutlet UIView *mainView;

@end
