//
//  SHBCardService.h
//  ShinhanBank
//
//  Created by Joon on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBankingService.h"

#define CARD_E4304  @"E4304"    // 신한카드 서비스 이용동의
#define CARD_E2911  @"E2911"    // 카드 목록
#define CARD_E2902  @"E2902"    // 이용내역조회
#define CARD_E2913  @"E2913"    // 월별 청구금액 조회
#define CARD_E2914  @"E2914"    // 월별 청구금액 조회 상세
#define CARD_E2915  @"E2915"    // 결제 청구금액 조회
#define CARD_E2916  @"E2916"    // 결제 청구금액 조회 상세
#define CARD_E2905  @"E2905"    // 승인내역조회
#define CARD_E2904  @"E2904"    // 결제내역조회
#define CARD_E2906  @"E2906"    // 교통카드 내역조회
#define CARD_E2907  @"E2907"    // 포인트 조회
#define CARD_E2901  @"E2901"    // 이용한도조회

@interface SHBCardService : SHBBankingService

@property (assign, nonatomic) BOOL isFirstLogin; // 메뉴를 선택해 진입한 것인지 체크 (로그인 후 메뉴 눌러서 진입시 NO)

/// 카드 진입시 알럿 체크
- (void)cardErrorCheck;

@end
