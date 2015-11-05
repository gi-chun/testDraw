//
//  SHBTextField.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/*
	Sample Source : SHBCommonControlsViewController
 */

#import <UIKit/UIKit.h>

@protocol SHBTextFieldDelegate;

@interface SHBTextField : UITextField {
	id<SHBTextFieldDelegate> accDelegate;
    NSString *strLableFormat;
    NSString *strNoDataLable;
    NSString *strHint;
    BOOL isDraw;
}

@property (nonatomic, assign) IBOutlet id/*<SHBTextFieldDelegate>*/ accDelegate;
@property (nonatomic, retain) NSString *strLableFormat;
@property (nonatomic, retain) NSString *strNoDataLable;
@property (nonatomic, retain) NSString *strHint;

- (void)focusSetWithLoss:(BOOL)focus;					// 포커스시 배경 이미지 변경
- (void)enableAccButtons:(BOOL)prev Next:(BOOL)next;	// 이전,다음버튼 (비)활성
- (void)buttonPressed:(UIButton*)sender;				// 이전,다음,완료버튼


@end


@protocol SHBTextFieldDelegate <NSObject>;

@optional

- (void)didPrevButtonTouch;		// 이전버튼
- (void)didNextButtonTouch;		// 다음버튼
- (void)didCompleteButtonTouch;	// 완료버튼

@end