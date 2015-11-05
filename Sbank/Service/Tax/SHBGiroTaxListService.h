//
//  SHBGiroTaxListService.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 17..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBankingService.h"

#define TAX_LIST                                5000
#define TAX_PAYMENT_LIST                        5001
#define TAX_PAYMENT_ACCOUNT_CONFIRM             5002
#define TAX_PAYMENT_SECURITY_CONFIRM            5003
#define TAX_PAYMENT_RUN                         5004
#define TAX_LIST_ONLY_GIRO_NUMBER               5005
#define TAX_LIST_ONLY_GIRO_NUMBER_RUN_TYPE_OCR  5006
#define TAX_LIST_ONLY_GIRO_NUMBER_RUN_TYPE_MICR 5007
#define TAX_PAYMENT_CANCEL_RUN                  5008
#define TAX_DISTRIC_PAYMENT_LIST                5009
#define TAX_DISTRIC_PAYMENT_DETAIL              5010

#define LOCAL_TAX_LIST_NEW                      5011
#define LOCAL_TAX_LIST_OLD                      5012
#define LOCAL_TAX_NEW_DETAIL                    5013
#define LOCAL_TAX_OLD_DETAIL                    5014
#define LOCAL_TAX_ACCOUNT_CONFIRM               5015
#define LOCAL_TAX_RUN                           5016


// CODE값
#define TAX_COMMON_CODE         5999


#define TAX_LIST_G0111                              @"G0111"    // 지로조회납부
#define TAX_PAYMENT_LIST_G0161                      @"G0161"    // 지로조회납부 내역조회
#define TAX_PAYMENT_ACCOUNT_CONFIRM_C2090           @"C2090"    // 지로조회납부 계좌확인
#define TAX_PAYMENT_SECURITY_CONFIRM_C2098          @"C2098"    // 지로조회납부 보안카드확인
#define TAX_PAYMENT_RUN_G0113                       @"G0113"    // 지로조회납부실행
#define TAX_LIST_ONLY_GIRO_NUMBER_G0120             @"G0120"    // 지로입력납부 조회
#define TAX_LIST_ONLY_GIRO_NUMBER_RUN_G0123         @"G0123"    // 지로입력납부 실행
#define TAX_PAYMENT_CANCEL_RUN_G0163                @"G0163"    // 지로납부 취소 실행
#define TAX_DISTRIC_PAYMENT_LIST_G1411              @"G1411"    // 지방세 납부
#define TAX_DISTRIC_PAYMENT_DETAIL_G1412            @"G1412"    // 지방세 납부 세부

#define LOCAL_TAX_LIST_NEW_G1421                    @"G1421"    // 신 지방세납부
#define LOCAL_TAX_LIST_OLD_G0321                    @"G0321"    // 구 지방세납부
#define LOCAL_TAX_NEW_DETAIL_G1422                  @"G1422"    // 신 지방세 상세 조회
#define LOCAL_TAX_OLD_DETAIL_G0322                  @"G0322"    // 구 지방세 상세 조회
#define LOCAL_TAX_ACCOUNT_CONFIRM_C2090             @"C2090"    // 지방세 계좌확인
#define LOCAL_TAX_RUN_G1414                         @"G1414"    // 신 지방세 납부


#define REGION_CODE                                 @"CODE"     // 지방코드

//SERVICE_ID, SERVICE_CODE, SERVICE_URL
#define TAX_SERVICE_INFO                    @{  \
@TAX_LIST:                                  @[TAX_LIST_G0111, SERVICE_URL],   \
@TAX_PAYMENT_LIST:                          @[TAX_PAYMENT_LIST_G0161, SERVICE_URL], \
@TAX_PAYMENT_ACCOUNT_CONFIRM:               @[TAX_PAYMENT_ACCOUNT_CONFIRM_C2090, SERVICE_URL],  \
@TAX_PAYMENT_SECURITY_CONFIRM:              @[TAX_PAYMENT_SECURITY_CONFIRM_C2098, SERVICE_URL],  \
@TAX_PAYMENT_RUN:                           @[TAX_PAYMENT_RUN_G0113, SERVICE_URL],  \
@TAX_LIST_ONLY_GIRO_NUMBER:                 @[TAX_LIST_ONLY_GIRO_NUMBER_G0120, SERVICE_URL], \
@TAX_LIST_ONLY_GIRO_NUMBER_RUN_TYPE_OCR:    @[TAX_LIST_ONLY_GIRO_NUMBER_RUN_G0123, SERVICE_URL], \
@TAX_LIST_ONLY_GIRO_NUMBER_RUN_TYPE_MICR:   @[TAX_LIST_ONLY_GIRO_NUMBER_RUN_G0123, SERVICE_URL], \
@TAX_PAYMENT_CANCEL_RUN:                    @[TAX_PAYMENT_CANCEL_RUN_G0163, SERVICE_URL], \
@TAX_DISTRIC_PAYMENT_LIST:                  @[TAX_DISTRIC_PAYMENT_LIST_G1411, SERVICE_URL],  \
@TAX_DISTRIC_PAYMENT_DETAIL:                @[TAX_DISTRIC_PAYMENT_DETAIL_G1412, SERVICE_URL],  \
@LOCAL_TAX_LIST_NEW:                        @[LOCAL_TAX_LIST_NEW_G1421, SERVICE_URL], \
@LOCAL_TAX_LIST_OLD:                        @[LOCAL_TAX_LIST_OLD_G0321, SERVICE_URL], \
@LOCAL_TAX_NEW_DETAIL:                      @[LOCAL_TAX_NEW_DETAIL_G1422, SERVICE_URL], \
@LOCAL_TAX_OLD_DETAIL:                      @[LOCAL_TAX_OLD_DETAIL_G0322, SERVICE_URL], \
@LOCAL_TAX_ACCOUNT_CONFIRM:                 @[LOCAL_TAX_ACCOUNT_CONFIRM_C2090, SERVICE_URL], \
@LOCAL_TAX_RUN:                             @[LOCAL_TAX_RUN_G1414, SERVICE_URL], \
@TAX_COMMON_CODE:                           @[REGION_CODE, CODE_URL],  \
};

@interface SHBGiroTaxListService : SHBBankingService

@end
