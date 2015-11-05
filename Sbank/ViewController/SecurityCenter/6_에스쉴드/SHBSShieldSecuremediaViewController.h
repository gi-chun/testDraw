//
//  SHBSShieldSecuremediaViewController.h
//  ShinhanBank
//
//  Created by 붉은용오름 on 2014. 6. 18..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

@interface SHBSShieldSecuremediaViewController : SHBBaseViewController

@property(nonatomic, retain) IBOutlet UILabel *shbDayMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbNightMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbSatDayMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbSatNightMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbSunDayMaxCnt;
@property(nonatomic, retain) IBOutlet UILabel *shbSunNightMaxCnt;
@property(nonatomic, retain) IBOutlet UIView *secretView;

@property(nonatomic, retain) IBOutlet UIView *mainView;
@end
