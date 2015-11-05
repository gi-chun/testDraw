//
//  SHBAlertPopupView.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 13. 2. 26..
//  Copyright (c) 2013년 (주)두베 All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHBAlertPopupViewDelegate;

@interface SHBAlertPopupView : UIView
{
    id alertTarget;
    SEL targetSelector;
    BOOL isBlockChangeMessage;
}

@property (nonatomic, assign) id<SHBAlertPopupViewDelegate> delegate;
@property (nonatomic, retain) UIView *mainView;
@property (nonatomic, assign) int myTag;
//@property (nonatomic, assign) int buttonIdx;

- (id)initWithString:(NSString *)aString ButtonCount:(int)count SubViewHeight:(float)height alertTag:(int)aTag aTarget:(id)aTarget tSelector:(SEL)aSelector btnTitle:(NSString *)aBtnTitle alertType:(int)aType;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)closePopupViewWithButton:(UIButton*)sender;
- (void)showAlertView;
- (void)closeAlertView;
- (IBAction)touchChkBox:(id)sender;
@end


@protocol SHBAlertPopupViewDelegate <NSObject>

@optional

- (void)popupViewDidConfirm;
- (void)popupViewDidCancel;

@end
