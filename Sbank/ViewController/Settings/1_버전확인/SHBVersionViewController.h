//
//  SHBVersionViewController.h
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 환경설정 > 버전확인
 */

#import "SHBBaseViewController.h"

@interface SHBVersionViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;
@property (retain, nonatomic) IBOutlet UIView *bottomView1;
@property (retain, nonatomic) IBOutlet UIView *bottomView2;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
/**
 현재버전 Label
 */
@property (retain, nonatomic) IBOutlet UILabel *currentVerLabel;

/**
 모델명
 */
@property (retain, nonatomic) IBOutlet UILabel *modelNameLabel;

/**
 OS버전명
 */
@property (retain, nonatomic) IBOutlet UILabel *osVersionLabel;

/**
 최신버전 Label
 */
@property (retain, nonatomic) IBOutlet UILabel *latestVerLabel;

/**
 업데이트 내용
 */
@property (retain, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)confirmBtnAction:(SHBButton *)sender;
- (IBAction)updateBtnAction:(SHBButton *)sender;


@end
