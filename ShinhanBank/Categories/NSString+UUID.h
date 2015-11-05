//
//  NSString+UUID.h
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 24..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 커스텀 UUID를 사용하기 위한 카테고리 클래스이다.
 */

#import <Foundation/Foundation.h>

@interface NSString (UUID)

/**
 커스텀 UUID를 반환 한다.
 
 @return NSString 커스텀 UUID를 반환.
 */
+ (NSString *)uuid;

@end
