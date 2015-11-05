//
//  SHBExRatePopupView.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 12. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBPopupView.h"

@protocol SHBExRatePopupViewDelegate <NSObject>
@optional
- (void)sortProcess;
@end

@interface SHBExRatePopupView : SHBPopupView 

@property (retain, nonatomic) UITableView *tableView;

- (id)initWithTitle:(NSString *)aTitle SubViewHeight:(float)height;
- (void)sortBtn:(UIButton *)sender;
- (void)close;

@property (nonatomic, assign) id<SHBExRatePopupViewDelegate> sorTDelegate;

@end

