//
//  SHBDeviceRegistServiceViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 1. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 보안센터 - 이용기기 등록 서비스
 이용기기 등록 서비스 화면
 */

@interface SHBDeviceRegistServiceViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIView *mainView;

- (void)deviceRegistServiceDeleteCompleteOK;
@end
