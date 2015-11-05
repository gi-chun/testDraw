//
//  SHBCustomerService.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBankingService.h"

#define CUSTOMER_E4110_SERVICE      4110    // 보안카드 사고 조회
#define CUSTOMER_E4112_SERVICE      4112    // 보안카드 사고신고
#define CUSTOMER_E4120_SERVICE      4120    // OPT카드 사고 조회
#define CUSTOMER_E4122_SERVICE      4122    // OPT카드 사고신고
#define CUSTOMER_E4130_SERVICE      4130    // 통장/인감 사고신고, 통장/인감 사고 조회
#define CUSTOMER_E4131_SERVICE      4131    // 통장/인감 사고신고
#define CUSTOMER_E4140_SERVICE      4140    // 현금/IC카드 사고 조회
#define CUSTOMER_E4141_SERVICE      4141    // 현금/IC카드 사고신고
#define EXCHANGE_D5220_SERVICE      5220    // 현금/IC카드 사고 조회
#define EXCHANGE_D5230_SERVICE      5230    // 현금/IC카드 사고 조회
#define CUSTOMER_E4161_SERVICE      4161    // 자기앞수표 사고신고
#define CUSTOMER_E4151_SERVICE      4151    // 가계수표 사고신고
#define CUSTOMER_C2310_SERVICE      2310    // 고객정보 조회
#define CUSTOMER_C2311_SERVICE      2311    // 고객정보 변경
#define CUSTOMER_E2115_SERVICE      2312    // 휴대폰번호 변경시 SMS
#define CUSTOMER_D1410_SERVICE      1410    // 본인정보 이용제공 조회시스템
#define CUSTOMER_C2315_SERVICE      2315    // 본인정보 이용제공 조회시스템
#define CUSTOMER_C2316_SERVICE      2316    // 본인정보 이용제공 조회시스템

#define CUSTOMER_E4110  @"E4110"    // 보안카드 사고 조회
#define CUSTOMER_E4112  @"E4112"    // 보안카드 사고신고
#define CUSTOMER_E4120  @"E4120"    // OPT카드 사고 조회
#define CUSTOMER_E4122  @"E4122"    // OPT카드 사고신고
#define CUSTOMER_E4130  @"E4130"    // 통장/인감 사고신고, 통장/인감 사고 조회
#define CUSTOMER_E4131  @"E4131"    // 통장/인감 사고신고
#define CUSTOMER_E4140  @"E4140"    // 현금/IC카드 사고 조회
#define CUSTOMER_E4141  @"E4141"    // 현금/IC카드 사고신고
#define EXCHANGE_D5220  @"D5220"    // 수표 사고 조회(신한/구조흥/구신한)
#define EXCHANGE_D5230  @"D5230"    // 수표 사고 조회(그외)
#define CUSTOMER_E4161  @"E4161"    // 자기앞수표 사고신고
#define CUSTOMER_E4151  @"E4151"    // 가계수표 사고신고
#define CUSTOMER_C2310  @"C2310"    // 고객정보 조회
#define CUSTOMER_C2311  @"C2311"    // 고객정보 변경
#define CUSTOMER_E2115  @"E2115"    // 휴대폰번호 변경시 SMS
#define CUSTOMER_D1410  @"D1410"    // 본인정보 이용제공 조회시스템
#define CUSTOMER_C2315  @"C2315"    // 본인정보 이용제공 조회시스템
#define CUSTOMER_C2316  @"C2316"    // 본인정보 이용제공 조회시스템

#define CUSTOMER_SERVICE_INFO    @{  \
@CUSTOMER_E4110_SERVICE : @[CUSTOMER_E4110, SERVICE_URL], \
@CUSTOMER_E4112_SERVICE : @[CUSTOMER_E4112, SERVICE_URL], \
@CUSTOMER_E4120_SERVICE : @[CUSTOMER_E4120, SERVICE_URL], \
@CUSTOMER_E4122_SERVICE : @[CUSTOMER_E4122, SERVICE_URL], \
@CUSTOMER_E4130_SERVICE : @[CUSTOMER_E4130, SERVICE_URL], \
@CUSTOMER_E4131_SERVICE : @[CUSTOMER_E4131, SERVICE_URL], \
@CUSTOMER_E4140_SERVICE : @[CUSTOMER_E4140, SERVICE_URL], \
@CUSTOMER_E4141_SERVICE : @[CUSTOMER_E4141, SERVICE_URL], \
@EXCHANGE_D5220_SERVICE : @[EXCHANGE_D5220, SERVICE_URL], \
@EXCHANGE_D5230_SERVICE : @[EXCHANGE_D5230, SERVICE_URL], \
@CUSTOMER_E4161_SERVICE : @[CUSTOMER_E4161, SERVICE_URL], \
@CUSTOMER_E4151_SERVICE : @[CUSTOMER_E4151, SERVICE_URL], \
@CUSTOMER_C2310_SERVICE : @[CUSTOMER_C2310, SERVICE_URL], \
@CUSTOMER_C2311_SERVICE : @[CUSTOMER_C2311, SERVICE_URL], \
@CUSTOMER_E2115_SERVICE : @[CUSTOMER_E2115, SERVICE_URL], \
@CUSTOMER_D1410_SERVICE : @[CUSTOMER_D1410, SERVICE_URL], \
@CUSTOMER_C2315_SERVICE : @[CUSTOMER_C2315, SERVICE_URL], \
@CUSTOMER_C2316_SERVICE : @[CUSTOMER_C2316, SERVICE_URL], \
};

@interface SHBCustomerService : SHBBankingService

@end
