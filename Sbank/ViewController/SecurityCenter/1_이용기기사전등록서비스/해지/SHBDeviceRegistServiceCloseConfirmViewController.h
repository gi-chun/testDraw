//
//  SHBDeviceRegistServiceCloseConfirmViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 7. 30..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBScrollLabel.h"

/**
 보안센터 - 이용기기 등록 서비스 - 이용기기 등록 서비스 해지
 이용기기 등록 서비스 해지 확인 화면
 */


@interface SHBDeviceRegistServiceCloseConfirmViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet SHBScrollLabel *subTitle;
@property (retain, nonatomic) IBOutlet UIView *securityView;

@end
