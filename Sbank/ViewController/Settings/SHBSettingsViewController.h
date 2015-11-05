//
//  SHBSettingsViewController.h
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 환경설정 메뉴선택 화면
 */

#import "SHBBaseViewController.h"

@interface SHBSettingsViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

/**
 셋팅 메뉴 테이블뷰
 */
@property (retain, nonatomic) IBOutlet UITableView *menuTable;

/**
 닫기 버튼 액션
 */
- (IBAction)closeBtnAction:(UIButton *)sender;

@end
