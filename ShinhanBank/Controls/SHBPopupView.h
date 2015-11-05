//
//  SHBPopupView.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 25..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBPopupViewDelegate;

@interface SHBPopupView : UIView
{
	UIView *mainView;
}

@property (nonatomic, assign) id<SHBPopupViewDelegate> delegate;
@property (nonatomic, retain) UIView *mainView;

- (id)initWithTitle:(NSString *)aTitle SubViewHeight:(float)height;
- (id)initWithTitle:(NSString *)aTitle subView:(UIView *)aView;
- (id)initWithTitle:(NSString *)aTitle subView:(UIView *)aView topHeight:(float)top;    // 지로에서 쓰이는 팝업
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)closePopupViewWithButton:(UIButton*)sender;
- (void)fadeIn;
- (void)fadeOut;

- (id)initWithSortTitle:(NSString *)aTitle SubViewHeight:(float)height;
- (void)sortBtn;

@end

@protocol SHBPopupViewDelegate <NSObject>
@optional
- (void)popupView:(SHBPopupView *)popupView didSelectedData:(NSMutableDictionary*)mDic;
- (void)popupViewDidCancel;
@end
