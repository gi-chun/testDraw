//
//  SHBDeviceRegistServiceDeleteCompleteViewController.h
//  ShinhanBank
//
//  Created by Joon on 13. 1. 8..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 보안센터 - 이용기기 등록 서비스 - 이용기기 조회/삭제
 등록폰 삭제 완료 화면
 */

@interface SHBDeviceRegistServiceDeleteCompleteViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet UIView *infoView1; // 삭제기기가 마지막 기기인 경우
@property (retain, nonatomic) IBOutlet UIView *infoView2; // 삭제기기 외 다른 기기가 있는 경우
@end
