//
//  SHBDrawingDetailViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBScrollLabel.h"

@interface SHBDrawingDetailViewController : SHBBaseViewController
{
    NSDictionary *basicInfo;
    NSDictionary *fundInfo;
}
@property (nonatomic, assign) NSDictionary *basicInfo;
@property (nonatomic, assign) NSDictionary *fundInfo;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 편드명

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *infoView;

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
@property (nonatomic, retain) IBOutlet UILabel *basicLabel16;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel17;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel18;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel19;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel20;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel21;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel22;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel23;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel24;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel25;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel26;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel27;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel28;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel29;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel30;

@end
