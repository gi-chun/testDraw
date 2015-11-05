//
//  SHBNoticeSmartLetterListViewController.h
//  ShinhanBank
//
//  Created by Joon on 12. 12. 27..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 알림
 스마트레터 목록 화면
 */

@interface SHBNoticeSmartLetterListViewController : SHBBaseViewController

@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@property (retain, nonatomic) IBOutlet UIView *notiSettingView; // 수신여부
@property (retain, nonatomic) IBOutlet UIButton *receive; // 수신
@property (retain, nonatomic) IBOutlet UIButton *noReceive; // 수신거부
@property (retain, nonatomic) IBOutlet UIView *deleteView;
@property (retain, nonatomic) IBOutlet UIView *moreView;
@property (retain, nonatomic) IBOutlet SHBButton *edit; // 편집
@property (retain, nonatomic) IBOutlet SHBButton *receiveSetting; // 수신거부설정
@end
