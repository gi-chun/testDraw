//
//  SHBFundDrawingApplyCompleteViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 2..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBFundDrawingApplyCompleteViewController : SHBBaseViewController

@property (nonatomic, assign) NSDictionary          *data_D6250;
@property (nonatomic, retain) NSMutableDictionary   *dicDataDictionary;
@property (retain, nonatomic) IBOutlet UIView *infoView;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 계좌명

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

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
