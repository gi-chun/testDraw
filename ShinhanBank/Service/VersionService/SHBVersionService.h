//
//  SHBVersionService.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 11. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBankingService.h"

#define VERSION_INFO    91007	// 버젼 정보 가져오는 전형적인 태스크 방식
#define ACCOUNT_RESET   91008   // 전형적 태스크 방식이나 URL이 다름
#define XDA_S00001      91001	// 벡터형 task request 방식
#define NAME_VERIFY     91002	// 실명확인하는 리퀘스트성 전문(서비스 코드 없는 형태)
#define BANK_CD_INFO	91003	// 은행코드
#define TASK_APP_LIST	91004	// 앱정보 가져오기
#define TASK_INS_PUSH	91005	// 알림설정
#define PHONE_INFO	    91006    //폰정보 전송
#define VERSION_INFO2   91009    //버젼정보만 가져오기
#define SMSDEVICE_INFO  91010    //안심거래서비스 등록기기 조회
#define CARD_SSO_AGREE  91011    //신한카드 SSO 이용 동의
#define CARD_SSO_GROUP  91012    //신한카드 SSO sync
#define CARD_SSO_SEARCH 91013    //신한카드 SSO auto

#define VERSION_SERVICE_INFO    @{  \
@VERSION_INFO : @[@"TASK",TASK_SELECT_VERSION_INFO_URL, @"REQUEST"],   \
@ACCOUNT_RESET : @[@"TASK",TASK_COMMON_URL, @"REQUEST"],   \
@XDA_S00001  : @[@"TASK", TASK_COMMON_URL,@"REQUEST",@"vector"], \
@TASK_APP_LIST : @[@"TASK", TASK_COMMON_URL, @"REQUEST"], \
@NAME_VERIFY  : @[@"REQUEST", CHECK_REAL_NAME_URL], \
@TASK_INS_PUSH : @[@"TASK", TASK_COMMON_URL, @"REQUEST"], \
@BANK_CD_INFO  : @[@"CODE", CODE_URL], \
@PHONE_INFO : @[@"TASK",TASK_SELECT_VERSION_INFO_INPUT_URL, @"REQUEST"],   \
@VERSION_INFO2 : @[@"TASK",TASK_SELECT_VERSION_INFO_URL2, @"REQUEST"],   \
@SMSDEVICE_INFO : @[@"TASK",TASK_COMMON_URL, @"REQUEST"],   \
@CARD_SSO_AGREE : @[@"TASK",TASK_SIGN_URL, @"REQUEST"],   \
@CARD_SSO_GROUP : @[@"TASK",TASK_CARDSSO_URL, @"REQUEST"],   \
@CARD_SSO_SEARCH : @[@"TASK",TASK_CARDSSO_URL, @"REQUEST"],   \
};

@interface SHBVersionService : SHBBankingService
{
    int processStep;
}
@end
