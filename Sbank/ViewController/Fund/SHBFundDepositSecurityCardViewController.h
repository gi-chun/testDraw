//
//  SHBFundDepositSecurityCardViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 19..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

#import "SHBSecretCardViewController.h"
#import "SHBSecretOTPViewController.h"
#import "SHBScrollLabel.h"

@interface SHBFundDepositSecurityCardViewController : SHBBaseViewController<SHBSecretCardDelegate, SHBSecretOTPDelegate>
{
    SHBSecretCardViewController *secretCardViewController; // 보안카드
    SHBSecretOTPViewController  *secretOTPViewController; // OTP
    
    NSDictionary                *basicInfo;
    NSDictionary                *fundInfo;

}

@property (nonatomic, assign) NSDictionary          *basicInfo;
@property (nonatomic, assign) NSDictionary          *fundInfo;
@property (nonatomic, assign) NSDictionary          *data_D6230;
@property (nonatomic, retain) IBOutlet NSString     *accountNo;
@property (nonatomic, retain) IBOutlet NSString     *depositAccountNo;
@property (nonatomic, retain) IBOutlet NSString     *transMoney;

@property (retain, nonatomic) IBOutlet UILabel          *accountName;       // 계좌명
@property (retain, nonatomic) IBOutlet UILabel          *accountNumber;     // 출금계좌번호
@property (retain, nonatomic) IBOutlet UILabel          *depositAcc;        // 입금계좌번호
@property (retain, nonatomic) IBOutlet UILabel          *depositMoney;      // 입금액
@property (retain, nonatomic) IBOutlet UILabel          *buyStandardDay;    // 매입기준가일
@property (retain, nonatomic) IBOutlet UILabel          *buySchDay;         // 입금예정일자

@property (nonatomic, retain) NSMutableDictionary   *dicDataDictionary;

@property (retain, nonatomic) IBOutlet SHBScrollLabel *fundTickerName; // 편드명

@property (retain, nonatomic) IBOutlet UIScrollView *mainScrollView;    // 기본정보뷰의 스크롤뷰
@property (retain, nonatomic) IBOutlet UIView       *mainView;          // 기본정보뷰
@property (retain, nonatomic) IBOutlet UIView       *infoView;          // 기본정보뷰
@property (retain, nonatomic) IBOutlet UIView       *securityView;      // 보안카드, OTP

@property (retain, nonatomic) NSString *encriptedPassword; // 이체비밀번호
@property (retain, nonatomic) NSString *encriptedNumber1; // 보안카드1
@property (retain, nonatomic) NSString *encriptedNumber2; // 보안카드2

@end
