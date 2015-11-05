//
//  SHBNotificationService.h
//  ShinhanBank
//
//  Created by Joon on 12. 12. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBankingService.h"

#define SMARTLETTER_SERVICE             10000    // 스마트레터
#define COUPON_SERVICE                  10001    // 쿠폰함
#define COUPON_READ_E2611_SERVICE       10001    // 쿠폰함 읽음표시
#define SMARTLETTER_E2411_SERVICE       10003    // 스마트레터 읽음표시
#define SMARTLETTER_E2412_SERVICE       10004    // 스마트레터 삭제
#define SMARTLETTER_E2425_SERVICE       10005    // 스마트레터 수신거부 상태변경
#define SMARTLETTER_C2828_SERVICE       10006    // 스마트레터 수신상태 확인
#define NEW_STATE_SERVICE               10007    // 스마트레터, 쿠폰 NEW 상태 조회
#define COUPON_D3249_SERVICE            10008    // 영업점 상담 금리승인 내역
#define COUPON_INFO_SERVICE             10009    // 영업점 쿠폰상품 리스트
#define COUPON_D5022_SERVICE            10010    // 영업점 상담 우대금리 조회
#define COUPON_D5024_SERVICE            10011    // 영업점 상담 우대금리 조회
#define SMARTCARE_MSM_TARGET_SERVICE    10012    // 스마트케어 대상조회 및 전담상담사 조회
#define SMARTCARE_MSM_DATA_SERVICE      10013    // 스마트케어 메시지 조회
#define SMARTCARE_SCOOKIE_DATA_SERVICE  10014    // 스마트케어 S쿠키 받기
#define SMARTCARD_E2820_SERVICE         10015    // 스마트명함
#define SMARTCARD_E2823_SERVICE         10016    // 스마트명함
#define SMARTCARD_E2821_SERVICE         10017    // 스마트명함삭제
#define SMARTCARD_E2822_SERVICE         10018    // 스마트명함전화 메세지 전송
#define GET_NOTICE_SERVICE              10019    // 수신메시지 가져오기
#define GET_ALIM_SERVICE                10020    // 알림메시지 가져오기
#define COUPON_DOWNLOD_SERVICE          10021    // 쿠폰 다운로드


#define SMARTLETTER             @"TASK"     // 스마트레터
#define COUPON                  @"TASK"     // 쿠폰함
#define COUPON_READ_E2611       @"E2611"    // 쿠폰함 읽음표시
#define SMARTLETTER_E2411       @"E2411"    // 스마트레터 읽음표시
#define SMARTLETTER_E2412       @"E2412"    // 스마트레터 삭제
#define SMARTLETTER_E2425       @"E2425"    // 스마트레터 수신거부 상태변경
#define SMARTLETTER_C2828       @"C2828"    // 스마트레터 수신상태 확인
#define NEW_STATE               @"TASK"     // 스마트레터, 쿠폰 NEW 상태 조회
#define COUPON_D3249            @"D3249"    // 영업점 상담 금리승인 내역
#define COUPON_INFO             @"TASK"    // 영업점 상담 금리승인 내역
#define COUPON_D5022            @"D5022"    // 영업점 상담 금리승인 내역
#define COUPON_D5024            @"D5024"    // 영업점 상담 금리승인 내역
#define SMARTCARE_MSM_TARGET    @"TASK"    // 스마트케어 대상조회 및 전담상담사 조회
#define SMARTCARE_MSM_DATA      @"TASK"    // 스마트케어 메시지 조회
#define SMARTCARE_SCOOKIE_DATA  @"TASK"    // 스마트케어 S쿠키 받기
#define SMARTCARD_E2820         @"E2820"    // 스마트명함 리스트
#define SMARTCARD_E2823         @"E2823"    // 스마트명함 수신조회
#define SMARTCARD_E2821         @"E2821"    // 스마트명함 리스트
#define SMARTCARD_E2822         @"E2822"    // 스마트명함 전화 메세지 전송
#define GET_NOTICE              @"TASK"     // 수신메시지 가져오기
#define GET_ALIM                @"TASK"     // 알림메시지 가져오기
#define COUPON_DOWNLOD          @"TASK"     // 쿠폰 다운로드


#define NOTIFICATION_SERVICE_INFO    @{  \
@SMARTLETTER_SERVICE : @[SMARTLETTER, TASK_COMMON_URL, @"REQUEST"], \
@COUPON_SERVICE : @[COUPON, COUPON_COMMON_URL, @"REQUEST"], \
@COUPON_READ_E2611_SERVICE : @[COUPON_READ_E2611, SMARTLETTER_COUPON_URL], \
@SMARTLETTER_E2411_SERVICE : @[SMARTLETTER_E2411, SMARTLETTER_COUPON_URL], \
@SMARTLETTER_E2412_SERVICE : @[SMARTLETTER_E2412, SMARTLETTER_COUPON_URL], \
@SMARTLETTER_E2425_SERVICE : @[SMARTLETTER_E2425, SMARTLETTER_COUPON_URL], \
@SMARTLETTER_C2828_SERVICE : @[SMARTLETTER_C2828, SMARTLETTER_COUPON_URL], \
@NEW_STATE_SERVICE : @[NEW_STATE, TASK_COMMON_URL, @"REQUEST"], \
@COUPON_D3249_SERVICE : @[COUPON_D3249, SERVICE_URL], \
@COUPON_INFO_SERVICE : @[COUPON_INFO,COUPON_INOF_URL, @"REQUEST"], \
@COUPON_D5022_SERVICE : @[COUPON_D5022,D5022_SERVICE_URL], \
@COUPON_D5024_SERVICE : @[COUPON_D5024,SERVICE_URL], \
@SMARTCARE_MSM_TARGET_SERVICE : @[SMARTCARE_MSM_TARGET, SMARTCARE_URL, @"REQUEST"], \
@SMARTCARE_MSM_DATA_SERVICE : @[SMARTCARE_MSM_DATA, SMARTCARE_URL, @"REQUEST"], \
@SMARTCARE_SCOOKIE_DATA_SERVICE : @[SMARTCARE_SCOOKIE_DATA, SMARTCARE_URL, @"REQUEST"], \
@SMARTCARD_E2820_SERVICE : @[SMARTCARD_E2820, SERVICE_URL], \
@SMARTCARD_E2823_SERVICE : @[SMARTCARD_E2823, SERVICE_URL], \
@SMARTCARD_E2821_SERVICE : @[SMARTCARD_E2821, SERVICE_URL], \
@SMARTCARD_E2822_SERVICE : @[SMARTCARD_E2822, SERVICE_URL], \
@GET_NOTICE_SERVICE : @[GET_NOTICE, TASK_COMMON_URL, @"REQUEST"], \
@GET_ALIM_SERVICE : @[GET_ALIM, TASK_COMMON_URL, @"REQUEST"], \
@COUPON_DOWNLOD_SERVICE : @[COUPON_DOWNLOD, COUPON_COMMON_URL, @"REQUEST"], \
};



@interface SHBNotificationService : SHBBankingService

@end
