//
//  LPAppStats.h
//  OrchestraNative
//
//  Created by Park Lambert on 11. 11. 24..
//  Copyright (c) 2011년 Finger Inc. All rights reserved.
//

/**
 앱의 실행 횟수를 확인하는 클래스이다.
 
 [사용법]
 앱 런칭 시, [NSObject load] 호출 후, [LPAppStats numAppOpens] 활용.
 */

#import <Foundation/Foundation.h>

@interface LPAppStats : NSObject

/**
 초기화.
 
 @return int 0.
 */
+ (int)numAppInits;

/**
 1씩 증가시켜 증가한 값은 반환.
 
 @return int 증가한 값은 반환.
 */
+ (int)numAppOpens;

@end
