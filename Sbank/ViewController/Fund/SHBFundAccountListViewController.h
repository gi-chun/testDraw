//
//  SHBFundAccountListViewController.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 12..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//
#define kNotificationSelectedFundAccount	@"SelectedFundAccount"

#import "SHBBaseViewController.h"

@interface SHBFundAccountListViewController : SHBBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIView      *footerView;          // Footer
    
    NSString            *strDataNone;           // 펀드가 없을 경우
    
    int selectedRow;
    int serviceType;
}

/**
 상세리스트 테이블뷰
 */
@property (retain, nonatomic) IBOutlet UITableView *fundAcctListTable;

- (void)openOrCloseCell:(int)row;


@end
