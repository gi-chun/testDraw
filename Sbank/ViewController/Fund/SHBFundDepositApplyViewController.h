//
//  SHBFundDepositApplyViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBFundDepositApplyViewController : SHBBaseViewController
{
    NSDictionary *basicInfo;
    NSDictionary *fundInfo;
}

@property (nonatomic, assign) NSDictionary *basicInfo;
@property (nonatomic, assign) NSDictionary *fundInfo;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 계좌명
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UILabel *basicLabel01;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel02;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel03;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel04;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel05;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel06;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel07;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel08;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel09;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel10;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel11;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel12;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel13;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel14;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel15;

@property (retain, nonatomic) IBOutlet UIView *fundInfoView;

@end
