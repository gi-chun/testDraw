//
//  SHBAccountService.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 21.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBBankingService.h"
#define FREQ_TRANSFER_LIST     112000     
#define FREQ_TRANSFER_INSERT   112001
#define FREQ_TRANSFER_UPDATE   112002
#define FREQ_TRANSFER_DELETE   112003
#define FREQ_MONEYMENTO_SELECT 112004 // 머니멘토 가입여부 확인
#define FREQ_MONEYMENTO_INSERT 112005 // 머니멘토 내역 전송
#define AUTO_TRANSFER_INSERT   112006 // 자동이체 등록
#define FREQ_TRANSFER_ITEM     112007  //스피드 이체 단건 조회
#define ECHE_WIDGET_ITEM       112008  //이체 위짓등록 키값 가져오기
#define ECHE_WIDGET_QUERY      112009  //이체 위짓등록 정보 가져오기

#define SEARCH                 112098  // 검색
#define SEARCH_LINK_HISTORY    112099  // 검색 결과 링크 클릭

#define PRODUCT_MENUAL         112100   // 약관 상품설명서
#define SMART_ICHE_PUSH_YN     112101   // 스마트이체 푸쉬메시지 사용여부 확인


//SERVICE_ID, SERVICE_CODE, SERVICE_URL
#define ACCOUNT_SERVICE_INFO    @{  \
    @FREQ_TRANSFER_LIST: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @FREQ_TRANSFER_INSERT: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @FREQ_TRANSFER_UPDATE: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @FREQ_TRANSFER_DELETE: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @FREQ_MONEYMENTO_SELECT: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @FREQ_MONEYMENTO_INSERT: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @AUTO_TRANSFER_INSERT: @[ @"TASK", AUTO_TRANSFER_URL, @"REQUEST"], \
    @FREQ_TRANSFER_ITEM: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @ECHE_WIDGET_ITEM: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @ECHE_WIDGET_QUERY: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @SEARCH: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @SEARCH_LINK_HISTORY: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @PRODUCT_MENUAL: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
    @SMART_ICHE_PUSH_YN: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
};

@interface SHBAccountService : SHBBankingService
{
    NSDictionary *accountInfoDic;
}
@property (nonatomic, assign) NSDictionary *accountInfoDic;

- (NSDictionary *)accountListInfo:(int)accountType;
- (NSArray *)accountInqueryListInfo;

- (NSArray *)accountAllListInfo;

- (NSArray *)initAccountInfo;
- (NSArray *)accountDefaultInfo;
- (NSArray *)accountDetailInfo;

@end
