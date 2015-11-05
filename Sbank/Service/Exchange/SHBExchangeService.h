//
//  SHBExchangeService.h
//  ShinhanBank
//
//  Created by Joon on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBankingService.h"

#define EXCHANGE_F0010_SERVICE      6000    // 외화골드 계좌목록
#define EXCHANGE_F1110_SERVICE      6001    // 외화예금조회
#define EXCHANGE_F1113_SERVICE      6002    // 외화예금조회
#define EXCHANGE_D7012_SERVICE      6003    // 골드리슈예금조회, 멀티플예금조회
#define EXCHANGE_D7011_SERVICE      6004    // 골드리슈예금조회
#define EXCHANGE_D7013_SERVICE      6005    // 멀티플예금조회
#define EXCHANGE_TASK1_SERVICE      6006    // 우대율표 (기존 D3609)
#define EXCHANGE_CODE_SERVICE       6007    // 통화구분, 수취은행국가명
#define EXCHANGE_E2610_SERVICE      6008    // 외화환전쿠폰조회
#define EXCHANGE_F3780_SERVICE      6009    // 외화환전신청 정보 입력
#define EXCHANGE_F3511_SERVICE      6010    // 외화환전신청 정보 입력
#define EXCHANGE_D2004_SERVICE      6011    // 외화환전신청 정보 입력 - 잔액조회, 자주쓰는해외송금 정보 입력 - 잔액조회
#define EXCHANGE_F3512_SERVICE      6012    // 외화환전신청 정보 전자서명
#define EXCHANGE_E2613_SERVICE      6013    // 외화환전쿠폰 사용등록
#define EXCHANGE_F3120_SERVICE      6014    // 환전신청내역조회
#define EXCHANGE_F2035_SERVICE      6015    // 자주쓰는해외송금/조회
#define EXCHANGE_C2092_SERVICE      6016    // 외화환전신청 정보 입력 (계좌확인), 자주쓰는해외송금 정보 입력 (계좌확인)
#define EXCHANGE_F2024_SERVICE      6017    // 자주쓰는해외송금 정보 입력
#define EXCHANGE_F2027_SERVICE      6018    // 자주쓰는해외송금 정보 입력
#define EXCHANGE_F2028_SERVICE      6019    // 자주쓰는해외송금 정보 전자서명
#define EXCHANGE_F3730_SERVICE      6020    // 환율조회
#define EXCHANGE_F3740_SERVICE      6021    // 환율회차조회
#define EXCHANGE_TASK2_SERVICE      6022    // 외화수령지점2
#define EXCHANGE_TASK3_SERVICE      6023    // 외화수령지점3
#define EXCHANGE_F3732_SERVICE      6024    // 자주쓰는 해외송금 정보 입력
#define EXCHANGE_TASK4_SERVICE      6025    // 외화수령지점 안내


#define EXCHANGE_F0010  @"F0010"    // 외화골드 계좌목록
#define EXCHANGE_F1110  @"F1110"    // 외화예금조회
#define EXCHANGE_F1113  @"F1114"    // 외화예금조회
#define EXCHANGE_D7012  @"D7012"    // 골드리슈예금조회
#define EXCHANGE_D7011  @"D7011"    // 골드리슈예금조회
#define EXCHANGE_D7013  @"D7013"    // 골드리슈예금조회
#define EXCHANGE_TASK1  @"TASK"     // 우대율표
#define EXCHANGE_CODE   @"CODE"     // 통화구분, 수취은행국가명
#define EXCHANGE_E2610  @"E2610"    // 외화환전쿠폰조회
#define EXCHANGE_F3780  @"F3780"    // 외화환전신청 정보 입력
#define EXCHANGE_F3511  @"F3511"    // 외화환전신청 정보 입력
#define EXCHANGE_D2004  @"D2004"    // 외화환전신청 정보 입력 - 잔액조회, 자주쓰는해외송금 정보 입력 - 잔액조회
#define EXCHANGE_F3512  @"F3512"    // 외화환전신청 정보 전자서명
#define EXCHANGE_E2613  @"E2613"    // 외화환전쿠폰 사용등록
#define EXCHANGE_F3120  @"F3120"    // 환전신청내역조회
#define EXCHANGE_F2035  @"F2035"    // 자주쓰는해외송금/조회
#define EXCHANGE_C2092  @"C2092"    // 자주쓰는해외송금 정보 입력 (계좌확인)
#define EXCHANGE_F2024  @"F2024"    // 자주쓰는해외송금 정보 입력
#define EXCHANGE_F2027  @"F2027"    // 자주쓰는해외송금 정보 입력
#define EXCHANGE_F2028  @"F2028"    // 자주쓰는해외송금 정보 전자서명
#define EXCHANGE_F3730  @"F3730"    // 환율조회
#define EXCHANGE_F3740  @"F3740"    // 환율회차조회
#define EXCHANGE_TASK2  @"TASK"     // 외화수령지점2
#define EXCHANGE_TASK3  @"TASK"     // 외화수령지점3
#define EXCHANGE_F3732  @"F3732"    // 자주쓰는 해외송금 정보 입력
#define EXCHANGE_TASK4  @"TASK"     // 외화수령지점 안내


#define EXCHANGE_SERVICE_INFO    @{  \
@EXCHANGE_F0010_SERVICE : @[EXCHANGE_F0010, SERVICE_URL], \
@EXCHANGE_F1110_SERVICE : @[EXCHANGE_F1110, SERVICE_URL], \
@EXCHANGE_F1113_SERVICE : @[EXCHANGE_F1113, SERVICE_URL], \
@EXCHANGE_D7012_SERVICE : @[EXCHANGE_D7012, SERVICE_URL], \
@EXCHANGE_D7011_SERVICE : @[EXCHANGE_D7011, SERVICE_URL], \
@EXCHANGE_D7013_SERVICE : @[EXCHANGE_D7013, SERVICE_URL], \
@EXCHANGE_TASK1_SERVICE : @[EXCHANGE_TASK1, TASK_COMMON_URL, @"REQUEST"], \
@EXCHANGE_CODE_SERVICE  : @[EXCHANGE_CODE, CODE_URL], \
@EXCHANGE_E2610_SERVICE : @[EXCHANGE_E2610, SERVICE_URL], \
@EXCHANGE_F3780_SERVICE : @[EXCHANGE_F3780, SERVICE_URL], \
@EXCHANGE_F3511_SERVICE : @[EXCHANGE_F3511, SERVICE_URL], \
@EXCHANGE_D2004_SERVICE : @[EXCHANGE_D2004, SERVICE_URL], \
@EXCHANGE_F3512_SERVICE : @[EXCHANGE_F3512, SERVICE_URL], \
@EXCHANGE_E2613_SERVICE : @[EXCHANGE_E2613, SERVICE_URL], \
@EXCHANGE_F3120_SERVICE : @[EXCHANGE_F3120, SERVICE_URL], \
@EXCHANGE_F2035_SERVICE : @[EXCHANGE_F2035, SERVICE_URL], \
@EXCHANGE_C2092_SERVICE : @[EXCHANGE_C2092, SERVICE_URL], \
@EXCHANGE_F2024_SERVICE : @[EXCHANGE_F2024, SERVICE_URL], \
@EXCHANGE_F2027_SERVICE : @[EXCHANGE_F2027, SERVICE_URL], \
@EXCHANGE_F2028_SERVICE : @[EXCHANGE_F2028, SERVICE_URL], \
@EXCHANGE_F3730_SERVICE : @[EXCHANGE_F3730, SERVICE_URL], \
@EXCHANGE_F3740_SERVICE : @[EXCHANGE_F3740, SERVICE_URL], \
@EXCHANGE_TASK2_SERVICE : @[EXCHANGE_TASK2, TASK_COMMON_URL, @"REQUEST"], \
@EXCHANGE_TASK3_SERVICE : @[EXCHANGE_TASK3, TASK_COMMON_URL, @"REQUEST"], \
@EXCHANGE_F3732_SERVICE : @[EXCHANGE_F3732, SERVICE_URL], \
@EXCHANGE_TASK4_SERVICE : @[EXCHANGE_TASK4, TASK_COMMON_URL, @"REQUEST"], \
};

@interface SHBExchangeService : SHBBankingService

@end
