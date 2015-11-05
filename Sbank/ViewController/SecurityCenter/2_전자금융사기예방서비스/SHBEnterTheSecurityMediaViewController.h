//
//  SHBEnterTheSecurityMediaViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 8. 20..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
// 보안매체 입력

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"
#import "SHBSecretCardViewController.h"
#import "SHBSecurityCenterService.h"

#define D_NAVI_TITLE @"NAVI_TITLE"          // 네비게이션 타이틀 태그
#define D_SUB_TITLE @"SUB_TITLE"            // 서브 타이틀 태그
#define D_VIEWCONTROLLER @"VIEWCONTROLLER"  // 뷰컨트롤러 구분 태그
#define D_IS_SELECTION @"IS_SELECTION"      // 신청, 해제 구분 태그
#define D_MAX_STEP @"MAX_STEP"              // 서브타이틀 - 맥스 스텝 태그
#define D_FOCUS_STEP @"FOCUS_STEP"          // 서브타이틀 - 현제 스텝 태그

@interface SHBEnterTheSecurityMediaViewController : SHBBaseViewController <SHBSecretCardDelegate>

@property (nonatomic, retain) NSMutableDictionary *viewDataSet;                                 // 데이타셋
@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;                         // 컨텐츠 영역 스크롤 뷰
@property (nonatomic, retain) IBOutlet UIView *contentView;                                     // 컨텐츠 영역 뷰
@property (nonatomic, retain) IBOutlet SHBSecretCardViewController *secretCardViewController;   // 보안매체 뷰 컨트롤러
@property (nonatomic, retain) SHBSecurityCenterService *securityCenterService;                  // 서비스

@end
