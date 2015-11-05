//
//  SHBAccidentPopupView.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 29..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHBPopupView.h"

/**
 고객센터 - 사고신고
 사고신고 Popup 화면
 */

@interface SHBAccidentPopupView : SHBPopupView

@property (retain, nonatomic) UIScrollView *scrollView;

- (id)initWithTitle:(NSString *)aTitle SubViewHeight:(float)height setContentView:(UIView *)contentView;

@end