//
//  SHBFreqAccountInquiryCompleteViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"
#import "SHBAccountService.h"

@interface SHBFreqAccountInquiryCompleteViewController : SHBBaseViewController
{
    SHBAccountService *service;
    NSDictionary *outAccInfoDic;
}

@property (nonatomic, retain) SHBAccountService *service;
@property (nonatomic, retain) NSDictionary *outAccInfoDic;

@property (retain, nonatomic) IBOutlet UILabel *lblData01;
@property (retain, nonatomic) IBOutlet UILabel *lblData02;
@property (retain, nonatomic) IBOutlet UILabel *lblData03;

@property (retain, nonatomic) IBOutlet SHBButton *okBtn;

@end
