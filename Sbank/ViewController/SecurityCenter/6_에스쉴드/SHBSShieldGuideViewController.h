//
//  SHBSShieldGuideViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 6. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSShieldGuideViewController : SHBBaseViewController

@property(retain, nonatomic) IBOutlet UIView *mainView;
@property(retain, nonatomic) IBOutlet UIView *myView;
//@property (nonatomic, retain) NSString *encryptSsn;
//@property (nonatomic, retain) IBOutlet SHBSecureTextField *ssnPwdTextField;

//은행표준인데 하드코딩(값이 변경되지 않는다 함... 혹시 몰라 연결은 해놈...)
@property(nonatomic, retain) IBOutlet UILabel *shbDayMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbDayAvgCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbNightMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbNightAvgCnt;

@property(nonatomic, retain) IBOutlet UILabel *shbSatDayMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbSatDayAvgCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbSatNightMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbSatNightAvgCnt;

@property(nonatomic, retain) IBOutlet UILabel *shbSunDayMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbSunDayAvgCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbSunNightMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbSunNightAvgCnt;

//고객꺼
@property(nonatomic, retain) IBOutlet UILabel *myDayMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *myDayAvgCnt;
@property(nonatomic, retain) IBOutlet UILabel *myNightMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *myNightAvgCnt;

@property(nonatomic, retain) IBOutlet UILabel *mySatDayMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *mySatDayAvgCnt;
@property(nonatomic, retain) IBOutlet UILabel *mySatNightMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *mySatNightAvgCnt;

@property(nonatomic, retain) IBOutlet UILabel *mySunDayMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *mySunDayAvgCnt;
@property(nonatomic, retain) IBOutlet UILabel *mySunNightMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *mySunNightAvgCnt;

@property(nonatomic, retain) IBOutlet UIButton *confirmBtn;
-(IBAction)confirmClick:(id)sender;
@end
