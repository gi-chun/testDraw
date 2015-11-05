//
//  SHBAlertPopupView.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 13. 2. 26..
//  Copyright (c) 2013년 (주)두베 All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBSMSAlertPopupViewDelegate;

@interface SHBSMSAlertPopupView : UIView


@property (nonatomic, assign) id<SHBSMSAlertPopupViewDelegate> delegate;
@property (nonatomic, retain) UIView *mainView;

- (id)initWithString:(NSString *)aString ButtonCount:(int)count SubViewHeight:(float)height;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)closePopupViewWithButton:(UIButton*)sender;
- (void)showAlertView;
- (void)closeAlertView;
- (IBAction)touchDate:(id)sender;
@end


@protocol SHBSMSAlertPopupViewDelegate <NSObject>

@optional

- (void)popupViewDidConfirm;
- (void)popupViewDidCancel;

@end
