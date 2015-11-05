//
//  SHBFundDepositCompleteViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBFundDepositCompleteViewController : SHBBaseViewController

@property (nonatomic, assign) NSDictionary          *basicInfo;
@property (nonatomic, assign) NSDictionary          *fundInfo;
@property (nonatomic, assign) NSDictionary          *data_D6230;

@property (retain, nonatomic) IBOutlet UIView       *infoView;          // 기본정보뷰

@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 편드명

@property (nonatomic, retain) IBOutlet NSString     *accountNo;
@property (nonatomic, retain) IBOutlet NSString     *depositAccountNo;
@property (nonatomic, retain) IBOutlet NSString     *transMoney;

@property (nonatomic, retain) NSMutableDictionary   *dicDataDictionary;

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

@end
