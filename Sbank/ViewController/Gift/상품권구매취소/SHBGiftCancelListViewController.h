//
//  SHBGiftCancelListViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBaseViewController.h"

/**
 상품권 - 모바일상품권 구매취소
 취소할 상품권 목록 화면
 */

@interface SHBGiftCancelListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSMutableDictionary *selectAccountDic;

@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;

@end
