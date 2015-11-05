//
//  SHBNoticeSmartLetterDetailViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 12. 27..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBWebView.h"

/**
 알림
 스마트레터 상세 화면
 */

@protocol SHBNoticeSmartLetterDetailDelegate <NSObject>

- (void)smartLetterDetailBack;
- (void)smartLetterDetailList;

@end

@interface SHBNoticeSmartLetterDetailViewController : SHBBaseViewController <UIWebViewDelegate>

@property (assign, nonatomic) id<SHBNoticeSmartLetterDetailDelegate> delegate;
@property (retain, nonatomic) IBOutlet SHBWebView *webView;
@property (retain, nonatomic) IBOutlet UILabel *subject; // 제목
@property (retain, nonatomic) IBOutlet UILabel *message; // 메시지 내용
@property (retain, nonatomic) IBOutlet UIView *contentView; // 보낸사람, 연락처, 이메일주소, 날짜

@end
