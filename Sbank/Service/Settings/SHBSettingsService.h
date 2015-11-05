//
//  SHBSettingsService.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#define kA0051Id            90001	// 이용자비밀번호등록 > 이용자계좌확인
#define kC2097Id            90002	// 이용자비밀번호등록 > 이용자계좌확인 > 계좌비번체크
#define kA0052Id            90003	// 이용자비밀번호등록 > 이용자계좌확인 > 계좌비번체크 > 휴대폰인증 > 이용자비밀번호등록 실행
#define kE4125Id            90004	// OTP 시간보정
#define kC2090Id            90005	// 서비스 해지 계좌 비밀번호 확인
#define kE4303Id            90006	// 서비스 해지 실행
#define APPLIST_TASK1       90007     // 앱더보기 리스트
#define XDA_S00004          90008	// 배경화면조회
#define XDA_S00002          90009	// 알림설정
#define XDA_S00003          90010	// 알림설정상태조회
#define EASY_INQUIRY_SELECT	90013	// 간편계좌조회설정 조회
#define EASY_INQUIRY_UPDATE	90014	// 간편계좌조회설정 갱신
#define EASY_INQUIRY_DELETE	90015	// 간편계좌조회설정 삭제
#define XDA_FOREIG	        90016	// 해외체류 확인 
#define FISHING_DEFENCE     90017   // 피싱방지 보안설정

#define kSettingsServiceInfo	@{	\
@kA0051Id : @[@"A0051", GUEST_SERVICE_URL],	\
@kC2097Id : @[@"C2097", GUEST_SERVICE_URL],	\
@kA0052Id : @[@"A0052", GUEST_SERVICE_URL],	\
@kE4125Id : @[@"E4125", SERVICE_URL],	\
@kC2090Id : @[@"C2090", SERVICE_URL],	\
@kE4303Id : @[@"E4303", TRANSFER_URL],	\
@APPLIST_TASK1 : @[@"task", TASK_COMMON_URL, @"REQUEST"], \
@XDA_S00004  : @[@"TASK", TASK_COMMON_URL, @"REQUEST"], \
@XDA_S00002  : @[@"TASK", TASK_COMMON_URL, @"REQUEST"], \
@XDA_S00003  : @[@"TASK", TASK_COMMON_URL, @"REQUEST"], \
@EASY_INQUIRY_SELECT  : @[@"TASK", TASK_INQUIRY_MAIN_ACCOUNT_URL, @"REQUEST"], \
@EASY_INQUIRY_UPDATE  : @[@"TASK", TASK_INQUIRY_MAIN_ACCOUNT_URL, @"REQUEST"], \
@EASY_INQUIRY_DELETE  : @[@"TASK", TASK_INQUIRY_MAIN_ACCOUNT_URL, @"REQUEST"], \
@XDA_FOREIG  : @[@"TASK", TASK_COMMON_URL, @"REQUEST"], \
@FISHING_DEFENCE : @[@"E4124", SERVICE_URL],	\
};

#import "SHBBankingService.h"

@interface SHBSettingsService : SHBBankingService

@end
