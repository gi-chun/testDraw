//
//  SHBFundDepositDetailViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 15..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBAccount.h"
#import "SHBScrollLabel.h"

@interface SHBFundDepositDetailViewController : SHBBaseViewController
{
    NSDictionary *data_D6010;
    NSDictionary *data_D6210;
    
    IBOutlet UIButton       *buttonUpNext;      // 밑의 다음 버튼
    IBOutlet UIButton       *buttonBottomNext;      // 밑의 다음 버튼
}

//@property (nonatomic, retain) NSArray *data_D6010;
@property (nonatomic, retain) NSDictionary *data_D6010;
@property (nonatomic, retain) NSDictionary *data_D6210;
@property (nonatomic, retain) SHBAccount *account;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 편드명

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

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *lTView;

- (IBAction)buttonTouchUpInside:(UIButton *)sender;

@end
