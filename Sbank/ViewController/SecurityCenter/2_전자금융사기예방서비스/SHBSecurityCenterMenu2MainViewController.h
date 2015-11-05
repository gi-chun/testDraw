//
//  SHBSecurityCenterMenu2MainViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 7. 26..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
// 보안센터 > 전자금융 사기예방 서비스

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

@interface SHBSecurityCenterMenu2MainViewController : SHBBaseViewController

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView1;   // 스크롤 뷰
@property (nonatomic, retain) IBOutlet UIView *contentView;         // 컨텐츠 뷰

@property(nonatomic, retain) IBOutlet UILabel *sumLimitLabel;

- (IBAction)buttonDidPush:(id)sender;                               // 버튼 액션 이벤트

@end
