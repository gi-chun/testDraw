//
//  SHBBranchesService.h
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#define kC2090Id	80001
#define kE1700Id	80002	// 긴급출금등록
#define kE1701Id	80003	// 긴급출금조회
#define kE1703Id	80004	// SMS재전송
#define kE1702Id	80005	// 긴급출금취소
#define kE4306Id	80006	// ATM 조회
#define kE4307Id	80007	// 영업점 조회
#define kE4308Id	80008	// 영업점 대기고객수 조회
#define kE4310Id	80009	// 현재위치의 영업점 가져오기

#define kBranchesServiceInfo	@{	\
@kC2090Id : @[@"C2090", SERVICE_URL],	\
@kE1700Id : @[@"E1700", SERVICE_URL],	\
@kE1701Id : @[@"E1701", SERVICE_URL],	\
@kE1703Id : @[@"E1703", SERVICE_URL],	\
@kE1702Id : @[@"E1702", SERVICE_URL],	\
@kE4306Id : @[@"E4306", GUEST_SERVICE_URL],	\
@kE4307Id : @[@"E4307", GUEST_SERVICE_URL],	\
@kE4308Id : @[@"E4308", GUEST_SERVICE_URL],	\
@kE4310Id : @[@"E4310", GUEST_SERVICE_URL],	\
};

#import "SHBBankingService.h"

@interface SHBBranchesService : SHBBankingService

@end
