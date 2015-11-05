//
//  SHBKakao.h
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 18..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 카카오링크 API를 이용하여 카카오톡으로 링크와 메시지를 등록할 수 있다.
 
 @see 카카오링크 API(http://www.kakao.com/link/ko/api)
 */

#import <Foundation/Foundation.h>
#import "JSONKit.h"

@interface SHBKakao : NSObject

/**
 카카오링크 URL을 열 수 있는 지 여부.
 
 @return YES/NO.
 */
+ (BOOL)canOpenKakaoLink;

/**
 카카오링크 열기: URL 링크 전달.
 외부 앱, 모바일웹에서 카카오톡 친구들에게 URL 링크 혹은 메세지(TEXT)를 전송할 수 있다.
 
 @param referenceURLString 유저에게 전달될 메세지에 포함되는 링크 url(모바일웹).
 @param appVersion 3rd app의 버전(신한S뱅크).
 @param appBundleID App의 bundle id.
 @param appName 3rd app의 정확한 이름.
 @param message 유저에게 전달될 메세지 내용(UTF-8).
 @return BOOL YES/NO.
 */
+ (BOOL)openKakaoLinkWithURL:(NSString *)referenceURLString
				  appVersion:(NSString *)appVersion
				 appBundleID:(NSString *)appBundleID
					 appName:(NSString *)appName
					 message:(NSString *)message;

/**
 카카오링크 열기: App 링크 전달.
 외부 앱, 모바일웹에서 카카오톡 친구들에게 해당 앱으로 바로 연결 할 수 있는 링크를 전송할 수 있다. 
 링크를 받는 사람이 해당 앱을 설치하지 않은 경우 설치마켓으로 연결 할 수 있으며, 호환되지 않는 OS의 경우 URL 링크로 대체하여 전달 할 수 있다.
 
 @param message 유저에게 전달될 메세지 내용(UTF-8).
 @param referenceURLString 유저에게 전달될 메세지에 포함되는 링크 url(모바일웹).
 @param appBundleID App의 bundle id.
 @param appVersion 3rd app의 버전(신한S뱅크).
 @param appName 3rd app의 정확한 이름.
 @param metaInfoArray metainfo는 JSON 스트링 형태로 전달.
 @return BOOL YES/NO.
 */
+ (BOOL)openKakaoAppLinkWithMessage:(NSString *)message
								URL:(NSString *)referenceURLString
						appBundleID:(NSString *)appBundleID
						 appVersion:(NSString *)appVersion
							appName:(NSString *)appName
					  metaInfoArray:(NSArray *)metaInfoArray;

@end
