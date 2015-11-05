//
//  SHBSmartCareViewController.h
//  ShinhanBank
//
//  Created by Joon on 2014. 1. 21..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBAttentionLabel.h"

/**
 알림 - 스마트 케어 매니저
 */

@interface SHBSmartCareViewController : SHBBaseViewController
<UITableViewDataSource, UITableViewDelegate>


@property (retain, nonatomic) IBOutlet SHBButton *smartCareInfoBtn;
@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@property (retain, nonatomic) IBOutlet UIView *infoView;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *infoContentLabel;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *n_Label;
@property (retain, nonatomic) IBOutlet UILabel *tel_no;
@property (retain, nonatomic) NSString *tempLabel; // 라벨명

@property (retain, nonatomic) IBOutlet UIView *managerInfoView;
@property (retain, nonatomic) IBOutlet UIView *callView;
@property (retain, nonatomic) IBOutlet UILabel *callBtn1Label;
@property (retain, nonatomic) IBOutlet UILabel *callBtn2Label;
@end
