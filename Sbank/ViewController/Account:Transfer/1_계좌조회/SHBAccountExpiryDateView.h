//
//  SHBAccountExpiryDateView.h
//  ShinhanBank
//
//  Created by Joon on 13. 12. 4..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBPopupView.h"
#import "SHBAttentionLabel.h"

/*
 계좌조회 - 만기예정 및 경과상품 안내
 */

@protocol AccountExpiryDateDelegate <NSObject>

- (void)accountExpiryDateSelected:(NSDictionary *)selectData withIndex:(NSInteger)index;

@end

@interface SHBAccountExpiryDateView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) id<AccountExpiryDateDelegate> delegate;
@property (retain, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) NSInteger accountType;

@property (retain, nonatomic) IBOutlet UIView *popupView;
@property (retain, nonatomic) IBOutlet UITableView *dataTable;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *infoView;
@property (retain, nonatomic) IBOutlet SHBAttentionLabel *infoView2;
@property (retain, nonatomic) IBOutlet UIButton *checkBtn;

- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)fadeIn;
- (void)fadeOut;

@end
