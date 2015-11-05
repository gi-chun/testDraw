//
//  SHBELD_BA17_1ViewController.h
//  ShinhanBank
//
//  Created by 6r19ht on 13. 5. 23..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//
//  상품가입 > 예금/적금가입 > 지수연동예금상품 > BA17-1

#import <UIKit/UIKit.h>
#import "SHBBaseViewController.h"

@interface SHBELD_BA17_1ViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView1; // 테이블뷰
@property (nonatomic, retain) IBOutlet UIView *view1;           // 뷰 - 모집기간이 아닙니다.
@property (nonatomic, retain) NSMutableArray *viewDataSource;   // 푸시 데이타 (테이블뷰 - 데이터 소스)
@property (nonatomic, retain) IBOutlet UIButton *button1;       // 초보자가이드 버튼

- (IBAction)buttonDidPush:(id)sender;                           // 초보자가이드 버튼 - 액션

@end
