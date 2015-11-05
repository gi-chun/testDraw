//
//  SHBSecureTextFieldDelegate.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 24..
//  Copyright (c) 2012년 LambertPark. All rights reserved.
//

/**
 SHBSecureTextField의 테이게이트 클래스 이다.
 */

#import <Foundation/Foundation.h>
#import "SHBSecureTextField.h"

/**
 SHBSecureDelegate 프로토콜이다. SHBSecureTextField를 사용한 뷰컨트롤러에서 구현해야 한다.
 */
@protocol SHBSecureDelegate

@required
/**
 SHBSecureDelegate의 델리게이트 메서드, 필수.
 
 @param textField SHBSecureTextField.
 @param value 암호화된 데이터.
 */
- (void)textField:(SHBSecureTextField *)textField didEncriptedData:(NSData *)aData didEncriptedVaule:(NSString *)value;



@optional
- (void)didGetToMaxmum;
- (void)secureTextFieldDidBeginEditing:(SHBSecureTextField *)textField;
- (void)onPreviousClick:(NSData*)pPlainText encText:(NSString*)pEncText;
- (void)onNextClick:(NSData*)pPlainText encText:(NSString*)pEncText;
- (void)onPressSecureKeypad:(NSData*)pPlainText encText:(NSString*)pEncText;
@end

@interface SHBSecureTextFieldDelegate : NSObject <UITextFieldDelegate>
{
    float targrtOriginalViewHeight;
    float targrtViewOriginalYPos;
    
}

/**
 SHBSecureTextField.
 */
@property (nonatomic, assign) SHBSecureTextField *parentTextField;

/**
 SHBSecureDelegate 델리게이트.
 */
@property (nonatomic, assign) id<SHBSecureDelegate> delegate;

/**
 보안키패드를 호출한 뷰컨트롤러.
 */
@property (nonatomic, retain) SHBBaseViewController *targetViewController;

/**
 SHBSecureTextFieldDelegate의 인스턴스를 반환하는 클래스 메서드 이다.
 
 @return id SHBSecureTextFieldDelegate의 인스턴스 반환.
 */
+ (id)secureDelegate;

//- (void) rotateViewSet;
- (void) closeKeyPad;
- (void)enableAccButtons:(BOOL)prev Next:(BOOL)next;	// 이전,다음버튼 (비)활성

@property(nonatomic, assign) BOOL preBtnEnable;
@property(nonatomic, assign) BOOL nextBtnEnable;
@end
