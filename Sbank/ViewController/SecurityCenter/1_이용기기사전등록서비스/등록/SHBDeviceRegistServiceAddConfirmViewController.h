//
//  SHBDeviceRegistServiceAddConfirmViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 1. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBScrollLabel.h"

/**
 보안센터 - 이용기기 등록 서비스 - 이용기기 등록
 이용기기 등록 확인 화면
 */

@interface SHBDeviceRegistServiceAddConfirmViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet SHBScrollLabel *subTitle;
@property (retain, nonatomic) IBOutlet UIView *securityView;

@end
