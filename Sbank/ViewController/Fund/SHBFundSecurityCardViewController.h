//
//  SHBFundSecurityCardViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 19..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBScrollLabel.h"

@interface SHBFundSecurityCardViewController : SHBBaseViewController<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretCardViewController; // 보안카드
    SHBSecretOTPViewController  *secretOTPViewController; // OTP

    NSDictionary          *data_D6310;
    NSDictionary          *data_D6320;
}

@property (nonatomic, retain) IBOutlet NSString *accountNo;

@property (nonatomic, assign) NSDictionary          *data_D6310;
@property (nonatomic, assign) NSDictionary          *data_D6320;

@property (nonatomic, retain) NSMutableDictionary   *dicDataDictionary;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 편드명

@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;    // 기본정보뷰의 스크롤뷰
@property (retain, nonatomic) IBOutlet UIView       *mainView;          // 기본정보뷰의 메인뷰
@property (retain, nonatomic) IBOutlet UIView       *infoView;          // 기본정보뷰
@property (retain, nonatomic) IBOutlet UIView       *securityView;      // 보안카드, OTP

@property (retain, nonatomic) NSString *encriptedPassword; // 이체비밀번호
@property (retain, nonatomic) NSString *encriptedNumber1; // 보안카드1
@property (retain, nonatomic) NSString *encriptedNumber2; // 보안카드2

@property (retain, nonatomic) IBOutlet UIView       *lineView1;          // 라인1
@property (retain, nonatomic) IBOutlet UIView       *lineView2;          // 라인2
@property (retain, nonatomic) IBOutlet UIView       *lineView3;          // 라인3

@property (nonatomic, retain) IBOutlet UILabel *basicLabel00;
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

@end
