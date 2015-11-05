//
//  SHBExchangePopupView.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBPopupView.h"

/**
 외환/골드
 외환/골드 Popup 화면
 */

@interface SHBExchangePopupView : SHBPopupView
{
    
}

@property (retain, nonatomic) UITableView *tableView;

- (void)close;

@end
