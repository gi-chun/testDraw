//
//  SHBFundDepositApplySecurityCardViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBScrollLabel.h"

@interface SHBFundDepositApplySecurityCardViewController : SHBBaseViewController<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    NSDictionary *data_D6010;
    NSDictionary *data_D6020;
    
    SHBSecretCardViewController *secretCardViewController; // 보안카드
    SHBSecretOTPViewController  *secretOTPViewController; // OTP

}
@property (nonatomic, assign) NSDictionary          *data_D6010;
@property (nonatomic, assign) NSDictionary          *data_D6020;
@property (nonatomic, retain) NSMutableDictionary   *dicDataDictionary;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 계좌명

@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;    // 기본정보뷰의 스크롤뷰
@property (retain, nonatomic) IBOutlet UIView       *mainView;          // 메인뷰
@property (retain, nonatomic) IBOutlet UIView       *infoView;          // 기본정보뷰
@property (retain, nonatomic) IBOutlet UIView       *securityView;      // 보안카드, OTP

@property (retain, nonatomic) NSString *encriptedPassword; // 이체비밀번호
@property (retain, nonatomic) NSString *encriptedNumber1; // 보안카드1
@property (retain, nonatomic) NSString *encriptedNumber2; // 보안카드2

@property (nonatomic, retain) IBOutlet UILabel *basicLabel01;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel02;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel03;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel04;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel05;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel06;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel07;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel08;
@property (nonatomic, retain) IBOutlet UILabel *basicLabel09;

@property (nonatomic, retain) IBOutlet UILabel *infoLabel;

@end
