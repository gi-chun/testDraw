//
//  SHBNoticeSmartCardListViewController.h
//  ShinhanBank
//
//  Created by gu_mac on 2014. 7. 11..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBNoticeSmartCardDetailViewController.h"
#import "SHBPopupView.h" // popup


@interface SHBNoticeSmartCardListViewController : SHBBaseViewController
<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView        *tableView1;
    IBOutlet UILabel        *labelNoList;       // 조회된 것 없을 때

    int                     intIndex;               // 현재 index
    int                     intSelectRow;           // 선택된 row
    BOOL                    isType;   // 수신 조회,등록,해제
}

@property (retain, nonatomic) NSString *productCode;

@property (retain, nonatomic) IBOutlet UIView *notiSettingView; // 수신여부
@property (retain, nonatomic) IBOutlet UIButton *receive; // 수신
@property (retain, nonatomic) IBOutlet UIButton *noReceive; // 수신거부
@property (retain, nonatomic) IBOutlet SHBButton *receiveSetting; // 수신거부설정
@property (retain, nonatomic) SHBPopupView *notiSettingPopupView;
@property (retain, nonatomic) SHBNoticeSmartCardDetailViewController *detailViewController;

@end
