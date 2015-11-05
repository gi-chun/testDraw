//
//  SHBPentionService.h
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBankingService.h"

@interface SHBPentionService : SHBBankingService

#define PENSION_JOIN_JUDGE                          8997
#define PENSION_AGREE                               8998
#define PENSION_AGREE_RUN                           8999
#define PENSION_RESERVE_LIST                        9000
#define PENSION_RESERVE_LIST_DETAIL                 9001
#define PENSION_PRODUCT_STATE_DETAIL                9002
#define PENSION_SURCHARGE_LIST                      9003
#define PENSION_SURCHARGE_DC_CONFIRM                9004
#define PENSION_SURCHARGE_CONFIRM                   9005
#define PENSION_SURCHARGE_RUN                       9006
#define PENSION_ES_NOTI_EDIT_INFO                   9007
#define PENSION_ES_NOTI_EDIT_INFO_SUMMIT            9008
#define PENSION_ES_NOTI_EDIT_AGREE_INFO_SUMMIT      9009


#define PENSION_JOIN_JUDGE_E3925                        @"E3925"        // 퇴직연금 가입유무
#define PENSION_AGREE_C2315                             @"C2315"        // 퇴직연금 동의 여부
#define PENSION_AGREE_RUN_C2316                         @"C2316"        // 퇴직연금 동의 실행
#define PENSION_RESERVE_LIST_E3946                      @"E3946"        // 퇴직연금 적립금 조회
#define PENSION_RESERVE_LIST_DETAIL_E3700               @"E3700"        // 퇴직연금 적립금 조회 상세
#define PENSION_PRODUCT_STATE_DETAIL_E3715              @"E3715"        // 운용상품 조회
#define PENSION_SURCHARGE_LIST_E3710                    @"E3710"        // 퇴직연금 입금내역
#define PENSION_SURCHARGE_DC_CONFIRM_E3725              @"E3725"        // 퇴직연금 가입자 부담금 DC 확인
#define PENSION_SURCHARGE_CONFIRM_D2031                 @"D2031"        // 퇴직연금 가입자 부담금 확인
#define PENSION_SURCHARGE_RUN_D2033                     @"D2033"        // 퇴직연금 가입자 부담금 실행
#define PENSION_ES_NOTI_EDIT_INFO_E3735                 @"E3735"        // 퇴직연금 정보변경 정보
#define PENSION_ES_NOTI_EDIT_INFO_SUMMIT_E3740          @"E3740"        // 퇴직연금 주소정보변경 실행
#define PENSION_ES_NOTI_EDIT_AGREE_INFO_SUMMIT_E3949    @"E3949"        // 퇴직연금 동의정보변경 실행


#define PENSION_SERVICE_INFO                    @{  \
@PENSION_JOIN_JUDGE:                            @[PENSION_JOIN_JUDGE_E3925, SERVICE_URL], \
@PENSION_AGREE:                                 @[PENSION_AGREE_C2315, SERVICE_URL], \
@PENSION_AGREE_RUN:                             @[PENSION_AGREE_RUN_C2316, SERVICE_URL], \
@PENSION_RESERVE_LIST:                          @[PENSION_RESERVE_LIST_E3946, SERVICE_URL], \
@PENSION_RESERVE_LIST_DETAIL:                   @[PENSION_RESERVE_LIST_DETAIL_E3700, SERVICE_URL], \
@PENSION_PRODUCT_STATE_DETAIL:                  @[PENSION_PRODUCT_STATE_DETAIL_E3715, SERVICE_URL], \
@PENSION_SURCHARGE_LIST:                        @[PENSION_SURCHARGE_LIST_E3710, SERVICE_URL], \
@PENSION_SURCHARGE_DC_CONFIRM:                  @[PENSION_SURCHARGE_DC_CONFIRM_E3725, SERVICE_URL], \
@PENSION_SURCHARGE_CONFIRM:                     @[PENSION_SURCHARGE_CONFIRM_D2031, SERVICE_URL], \
@PENSION_SURCHARGE_RUN:                         @[PENSION_SURCHARGE_RUN_D2033, SERVICE_URL], \
@PENSION_ES_NOTI_EDIT_INFO:                     @[PENSION_ES_NOTI_EDIT_INFO_E3735, SERVICE_URL], \
@PENSION_ES_NOTI_EDIT_INFO_SUMMIT:              @[PENSION_ES_NOTI_EDIT_INFO_SUMMIT_E3740, SERVICE_URL], \
@PENSION_ES_NOTI_EDIT_AGREE_INFO_SUMMIT:        @[PENSION_ES_NOTI_EDIT_AGREE_INFO_SUMMIT_E3949, SERVICE_URL], \
};

@end
