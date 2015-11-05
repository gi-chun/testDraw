//
//  SHBExchangeService.m
//  ShinhanBank
//
//  Created by Joon on 12. 10. 22..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBExchangeService.h"

@implementation SHBExchangeService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = EXCHANGE_SERVICE_INFO;
        [SHBBankingService addServiceInfo:info];
	}
}

- (void)start
{
    switch (self.serviceId) {
        case EXCHANGE_F0010_SERVICE:    // 외화골드 계좌목록
        case EXCHANGE_F1110_SERVICE:    // 외화예금조회
        case EXCHANGE_F1113_SERVICE:    // 외화예금조회
        case EXCHANGE_D7012_SERVICE:    // 골드리슈예금조회
        case EXCHANGE_D7011_SERVICE:    // 골드리슈예금조회
        case EXCHANGE_D7013_SERVICE:    // 골드리슈예금조회
        case EXCHANGE_CODE_SERVICE:     // 통화구분, 수취은행국가명
        case EXCHANGE_F3780_SERVICE:    // 외화환전신청 정보 입력
        case EXCHANGE_F3511_SERVICE:    // 외화환전신청 정보 입력
        case EXCHANGE_D2004_SERVICE:    // 외화환전신청 정보 입력 - 잔액조회, 자주쓰는해외송금 정보 입력 - 잔액조회
        case EXCHANGE_F3512_SERVICE:    // 외화환전신청 정보 전자서명
        case EXCHANGE_E2613_SERVICE:    // 외화환전쿠폰 사용등록
        case EXCHANGE_F3120_SERVICE:    // 환전신청내역조회
        case EXCHANGE_F2035_SERVICE:    // 자주쓰는해외송금/조회
        case EXCHANGE_C2092_SERVICE:    // 자주쓰는해외송금 정보 입력 (계좌확인)
        case EXCHANGE_F2024_SERVICE:    // 자주쓰는해외송금 정보 입력
        case EXCHANGE_F2027_SERVICE:    // 자주쓰는해외송금 정보 입력
        case EXCHANGE_F2028_SERVICE:    // 자주쓰는해외송금 정보 확인
        case EXCHANGE_F3730_SERVICE:    // 환율 정보 확인
        case EXCHANGE_F3740_SERVICE:    // 환율 회차 정보 확인
        case EXCHANGE_TASK2_SERVICE:    // 외화수령지점2
        case EXCHANGE_TASK3_SERVICE:    // 외화수령지점3
        case EXCHANGE_F3732_SERVICE:    // 자주쓰는 해외송금 정보 입력
            
            if (!self.requestData) {
                self.requestData = [SHBDataSet dictionary];
            }
            
            [self requestDataSet:(SHBDataSet *)self.requestData];
            
            break;
        case EXCHANGE_TASK1_SERVICE:    // 우대율표
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
                                    TASK_ACTION_KEY : @"getExchangePrime",
                                    @"구분" : @"1",
                                    }];
            
            [self requestDataSet:aDataSet];
        }
            break;
        case EXCHANGE_E2610_SERVICE:    // 외화환전쿠폰조회
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    @"쿠폰종류" : @"12",
                                    }];
            
            [self requestDataSet:aDataSet];
        }
            break;
        case EXCHANGE_TASK4_SERVICE:    // 외화수령지점 안내
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
                                      TASK_ACTION_KEY : @"getPrdInfoMsg",
                                      @"구분" : @"8",
                                      }];
            
            [self requestDataSet:aDataSet];
        }
            break;
        default:
            if (!self.requestData) {
                self.requestData = [SHBDataSet dictionary];
            }
            
            [self requestDataSet:(SHBDataSet *)self.requestData];
            
            break;
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
