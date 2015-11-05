//
//  SHBFundPopupView.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBPopupView.h"

@interface SHBFundPopupView : SHBPopupView

@property (retain, nonatomic) UITableView *tableView;

- (void)close;

@end
