//
//  SHBCustomerService.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 11. 23..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCustomerService.h"

@implementation SHBCustomerService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = CUSTOMER_SERVICE_INFO;
        [SHBBankingService addServiceInfo:info];
	}
}

- (void)start
{
    if (!self.requestData) {
        self.requestData = [SHBDataSet dictionary];
    }
    
    switch (self.serviceId) {
        case CUSTOMER_E4110_SERVICE:    // 보안카드 사고 조회
        case CUSTOMER_E4112_SERVICE:    // 보안카드 사고신고
        case CUSTOMER_E4120_SERVICE:    // OPT카드 사고 조회
        case CUSTOMER_E4122_SERVICE:    // OPT카드 사고신고
        case CUSTOMER_E4130_SERVICE:    // 통장/인감 사고신고, 통장/인감 사고 조회
        case CUSTOMER_E4131_SERVICE:    // 통장/인감 사고신고
        case CUSTOMER_E4140_SERVICE:    // 현금/IC카드 사고 조회
        case CUSTOMER_E4141_SERVICE:    // 현금/IC카드 사고신고
        case EXCHANGE_D5220_SERVICE:    // 수표 사고 조회
        case EXCHANGE_D5230_SERVICE:    // 수표 사고 조회
        case CUSTOMER_E4161_SERVICE:    // 자기앞수표 사고신고
        case CUSTOMER_E4151_SERVICE:    // 가계수표 사고신고
        case CUSTOMER_C2310_SERVICE:    // 고객정보 조회
        case CUSTOMER_C2311_SERVICE:    // 고객정보 변경
        case CUSTOMER_E2115_SERVICE:    // 휴대폰번호 변경시 SMS
        case CUSTOMER_D1410_SERVICE:    // 본인정보 이용제공 조회시스템
        case CUSTOMER_C2315_SERVICE:    // 본인정보 이용제공 조회시스템
        case CUSTOMER_C2316_SERVICE:    // 본인정보 이용제공 조회시스템
            
            [self requestDataSet:(SHBDataSet *)self.requestData];
            break;

        default:
            [self requestDataSet:(SHBDataSet *)self.requestData];
            break;
    }

}

- (void)dealloc
{
    [super dealloc];
}

@end
