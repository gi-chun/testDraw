//
//  SHBDeviceRegistServiceAddInfoViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 7. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 보안센터 - 이용기기 등록 서비스 - 이용기기 등록
 이용기기 등록 주의사항 화면
 */

@interface SHBDeviceRegistServiceAddInfoViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIButton *checkBtn; // 예, 동의합니다.

@property(nonatomic, retain) IBOutlet UILabel *sumLimitLabel;
@end
