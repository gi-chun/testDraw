//
//  SHBExceptionDeviceViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 2. 17..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBAttentionLabel.h"

/**
 보안센터 - 예외 기기 로그인 알림
 예외 기기 로그인 알림 안내 화면
 */

@interface SHBExceptionDeviceViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIScrollView *mainSV;
@property (retain, nonatomic) IBOutlet UIView *bottomView1;
@property (retain, nonatomic) IBOutlet UIView *bottomView2;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *infoLabel1;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *infoLabel2;

@end
