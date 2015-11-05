//
//  SHBSecurityCenterService.h
//  ShinhanBank
//
//  Created by Joon on 13. 8. 1..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBBankingService.h"

#define SECURITY_E3013_SERVICE      9000    // 이용기기 조회
#define SECURITY_E3012_SERVICE      9001    // 이용기기 등록, 삭제
#define SECURITY_E3025_SERVICE      9002    // 구 사기예방서비스 변경동의
#define SECURITY_E3026_SERVICE      9003    // 구 이용pc사전드록 서비스 변경동의
#define SECURITY_E4149_SERVICE      9004    // 이용기기 외 추가인증, 사기예방 SMS 통지
#define SECURITY_C2141_SERVICE      9005    // 이체한도조회
#define SECURITY_C2142_SERVICE      9006    // 이체한도감액변경
#define SECURITY_E2811_SERVICE      9007    //안심거래서비스신청(가입/해지)
#define SECURITY_E2812_SERVICE      9008    //안심거래서비스기기등록
#define SECURITY_E2813_SERVICE      9009    //안심거래서비스기기삭제
#define SECURITY_E2814_SERVICE      9010    //안심거래서비스해지
#define SECURITY_E3020_SERVICE      9011    // 예외 기기 로그인 알림 조회
#define SECURITY_E3021_SERVICE      9012    // 예외 기기 로그인 알림 신청
#define SECURITY_E7011_SERVICE      9013    // s-shield 설정 변경

#define SECURITY_E3013  @"E3013"    // 이용기기 조회
#define SECURITY_E3012  @"E3012"    // 이용기기 등록, 삭제
#define SECURITY_E3025  @"E3025"    // 구 사기예방서비스 변경동의
#define SECURITY_E3026  @"E3026"    // 구 이용pc사전드록 서비스 변경동의
#define SECURITY_E4149  @"E4149"    // 이용기기 외 추가인증, 사기예방 SMS 통지
#define SECURITY_C2141  @"C2141"    // 이체한도조회
#define SECURITY_C2142  @"C2142"    // 이체한도감액변경

//안심거래
#define SECURITY_E2811  @"E2811"    //안심거래서비스신청(가입/해지)
#define SECURITY_E2812  @"E2812"    //안심거래서비스기기등록
#define SECURITY_E2813  @"E2813"    //안심거래서비스기기삭제
#define SECURITY_E2814  @"E2814"    //안심거래서비스기기해지

#define SECURITY_E3020  @"E3020"    // 예외 기기 로그인 알림 조회
#define SECURITY_E3021  @"E3021"    // 예외 기기 로그인 알림 신청

#define SECURITY_E7011  @"E7011"    // s-shield 설정, 변경

#define SECURITY_SERVICE_INFO    @{  \
@SECURITY_E3013_SERVICE : @[SECURITY_E3013, SERVICE_URL], \
@SECURITY_E3012_SERVICE : @[SECURITY_E3012, SERVICE_URL], \
@SECURITY_E3025_SERVICE : @[SECURITY_E3025, SERVICE_URL], \
@SECURITY_E3026_SERVICE : @[SECURITY_E3026, SERVICE_URL], \
@SECURITY_E4149_SERVICE : @[SECURITY_E4149, SERVICE_URL], \
@SECURITY_C2141_SERVICE : @[SECURITY_C2141, SERVICE_URL], \
@SECURITY_C2142_SERVICE : @[SECURITY_C2142, SERVICE_URL], \
@SECURITY_E2811_SERVICE : @[SECURITY_E2811, SERVICE_URL], \
@SECURITY_E2812_SERVICE : @[SECURITY_E2812, SERVICE_URL], \
@SECURITY_E2813_SERVICE : @[SECURITY_E2813, SERVICE_URL], \
@SECURITY_E2814_SERVICE : @[SECURITY_E2814, SERVICE_URL], \
@SECURITY_E3020_SERVICE : @[SECURITY_E3020, SERVICE_URL], \
@SECURITY_E3021_SERVICE : @[SECURITY_E3021, SERVICE_URL], \
@SECURITY_E7011_SERVICE : @[SECURITY_E7011, SERVICE_URL], \
};

@interface SHBSecurityCenterService : SHBBankingService

@end
