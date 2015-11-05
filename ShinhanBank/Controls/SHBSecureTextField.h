//
//  SHBSecureTextField.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 nFilter 보안키패드를 띄우기 위한 SHBSecureTextField 클래스이다.
 */

#import <UIKit/UIKit.h>

/**
 보안키패드 유형.
 
 현재 문자 키패드(SHBSecureTextFieldTypeCharacter)과 숫자 키패드(SHBSecureTextFieldTypeNumber) 두 개의 유형이 존재한다.
 */
typedef enum
{
	SHBSecureTextFieldTypeCharacter = 0,    // 문자 키패드.
    SHBSecureTextFieldTypeNumber = 1        // 숫자 키패드.
} SHBSecureTextFieldType;

@class SHBSecureTextFieldDelegate;
@protocol  SHBSecureDelegate;

@interface SHBSecureTextField : OFTextField

/**
 보안키패드 관련 처리를 담당하는 델리게이트.
 */
@property (nonatomic, retain) SHBSecureTextFieldDelegate *defaultDelegate;

/**
 보안키패드를 호츨한 뷰 컨트롤러.
 */
@property (nonatomic, retain) SHBBaseViewController *targetViewController;

/**
 보안키패드의 최대 텍스트 길이.
 */
@property (nonatomic, assign) int maximum;

@property (nonatomic, assign) int keybordType;

@property (nonatomic, assign) int selfOriginY;
/**
 유형에 맞는 키패드를 띄운다.
 
 @param keyPadType SHBSecureTextFieldType으로 문자키패드(SHBSecureTextFieldTypeCharacter)와 숫자키패드(SHBSecureTextFieldTypeNumber)를 호출할 수 있다.
 */
- (void)showKeyPadWitType:(SHBSecureTextFieldType)keyPadType;

/**
 유형에 맞는 보안키패드를 띄운다.
 
 @param keyPadType SHBSecureTextFieldType으로 문자키패드(SHBSecureTextFieldTypeCharacter)와 숫자키패드(SHBSecureTextFieldTypeNumber)를 호출할 수 있다.
 @param aDelegate id<SHBSecureDelegate> 타입의 SHBSecureTextFieldDelegate의 델리게이트.
 @param aTargetViewController SHBViewController 타입의 타겟 뷰컨트롤러.
 @param aMaxium 최대로 입력할 수 있는 값.
 */
- (void)showKeyPadWitType:(SHBSecureTextFieldType)keyPadType
                 delegate:(id<SHBSecureDelegate>)aDelegate
                   target:(SHBBaseViewController *)aTargetViewController
                  maximum:(int)aMaxium;

- (void)closeSecureKeyPad;

- (void)enableAccButtons:(BOOL)prev Next:(BOOL)next;	// 이전,다음버튼 (비)활성
- (void)focusSetWithLoss:(BOOL)focus;
//- (void)supportLandScape:(BOOL)isSupport;
@end
