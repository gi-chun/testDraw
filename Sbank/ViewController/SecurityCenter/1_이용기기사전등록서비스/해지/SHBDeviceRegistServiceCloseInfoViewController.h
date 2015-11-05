//
//  SHBDeviceRegistServiceCloseInfoViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 7. 30..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 보안센터 - 이용기기 등록 서비스 - 이용기기 등록 서비스 해지
 이용기기 등록 서비스 해지 화면
 */

@interface SHBDeviceRegistServiceCloseInfoViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIButton *checkBtn; // 예, 동의합니다.

@property(nonatomic, retain) IBOutlet UILabel *sumLimitLabel;
@end
