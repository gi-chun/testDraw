//
//  SHBSecurityCenterService.m
//  ShinhanBank
//
//  Created by Joon on 13. 8. 1..
//  Copyright (c) 2013년 Finger Inc. All rights reserved.
//

#import "SHBSecurityCenterService.h"

@implementation SHBSecurityCenterService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = SECURITY_SERVICE_INFO;
        [SHBBankingService addServiceInfo:info];
	}
}

- (void)start
{
    switch (self.serviceId) {
        case SECURITY_E3013_SERVICE: // 이용기기 조회
        case SECURITY_E3012_SERVICE: // 이용기기 등록, 삭제
        case SECURITY_E3025_SERVICE: // 구 사기예방서비스 변경동의
        case SECURITY_E3026_SERVICE: // 구 이용pc사전드록 서비스 변경동의
        case SECURITY_E4149_SERVICE: // 이용기기 외 추가인증, 사기예방 SMS 통지
        case SECURITY_C2141_SERVICE: // 이체한도조회
        case SECURITY_C2142_SERVICE: // 이체한도감액변경
        case SECURITY_E2811_SERVICE: // 안심거래서비스신청(가입/해지)
        case SECURITY_E2812_SERVICE: // 안심거래서비스기기등록
        case SECURITY_E2813_SERVICE: // 안심거래서비스기기삭제
        case SECURITY_E2814_SERVICE: // 안심거래서비스해지
        case SECURITY_E3020_SERVICE: // 예외 기기 로그인 알림 조회
        case SECURITY_E3021_SERVICE: // 예외 기기 로그인 알림 신청
        case SECURITY_E7011_SERVICE: // s-shield 설정, 변경
        default:
            if (!self.requestData) {
                self.requestData = [SHBDataSet dictionary];
            }
            
            [self requestDataSet:(SHBDataSet *)self.requestData];
            
            break;
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
