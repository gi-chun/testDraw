//
//  UIAlertView+NetworkError.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 17..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 서버와의 통신 중, 에러 발생 시 얼럿을 보여 주기 위한 클래스 메서드를 제공하는 카테고리 이다.
 */

#import <UIKit/UIKit.h>
#import "SHBAlertPopupView.h"
enum
{
    ONFAlertTypeOneButton = 0,
    ONFAlertTypeTwoButton = 1,
    ONFAlertTypeOneButtonServer = 2,
    ONFAlertTypeTwoButtonServer = 3,
};

@interface UIAlertView (NetworkError)//<SHBAlertPopupViewDelegate>

/**
 NSURLConnection의 connection:didFailWithError: 델리게이트 메서드에서 발생하는 에러를 보여 준다.
 
 @param networkError 네트워크 에러.
 @return UIAlertView.
 */
+ (UIAlertView *)showWithError:(NSError *)networkError;

/**
 얼럿을 보여 주기 위한 클래스 메서드.
 
 @param obj 델리게이트 메서드를 구현할 객체.
 @param type 얼럿뷰의 버튼 타입, ONFAlertTypeOneButton(확인 버튼)/ONFAlertTypeTwoButton(확인/취소 버튼).
 @param tag 태그.
 @param title 제목.
 @param msg 내용.
 @return UIAlertView.
 */
+ (UIAlertView *)showAlert:(id)obj
                      type:(int)type
                       tag:(int)tag
                     title:(NSString *)title
                   message:(NSString *)msg;

+ (UIAlertView *)showAlertCustome:(id)obj
                      type:(int)type
                       tag:(int)tag
                     title:(NSString *)title
                     buttonTitle:(NSString *)btnTitle
                   message:(NSString *)msg;

+ (UIAlertView *)showAlertLan:(id)obj
                      type:(int)type
                       tag:(int)tag
                     title:(NSString *)title
                   message:(NSString *)msg
                   language:(int)lanType;

+ (int)myAlertTotCnt;
@end
