//
//  SHBProductService.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 10. 16..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBProductService.h"

@implementation SHBProductService

- (void)dealloc
{
	[_strDepositKind release];
	[super dealloc];
}

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized) {
		initialized = YES;
		
		NSDictionary *info = @{	\
		@XDA_S00004  : @[@"TASK", TASK_COMMON_URL,@"REQUEST"], \
		@XDA_S00004_1  : @[@"TASK", TASK_COMMON_URL,@"REQUEST"], \
		@XDA_S00001_1  : @[@"TASK", TASK_COMMON_URL,@"REQUEST"], \
		@XDA_S00001_2  : @[@"TASK", TASK_COMMON_URL,@"REQUEST"], \
		@XDA_S00001_3  : @[@"TASK", TASK_COMMON_URL,@"REQUEST"], \
		@XDA_S00001_4  : @[@"TASK", TASK_COMMON_URL,@"REQUEST"], \
        @XDA_S00001_5  : @[@"TASK", TASK_COMMON_URL,@"REQUEST"], \
        @XDA_S00001_6  : @[@"TASK", TASK_COMMON_URL,@"REQUEST"], \
        @XDA_S00001_7  : @[@"TASK", TASK_COMMON_URL,@"REQUEST"], \
		@XDA_SelectEmpInfo  : @[@"TASK", TASK_COMMON_URL,@"REQUEST"], \
        @XDA_InsertPhb : @[@"TASK", TASK_COMMON_URL,@"REQUEST"], \
        @XDA_AGE : @[@"TASK", TASK_AGE_URL,@"REQUEST"], \
        @XDA_CHECK_MON : @[@"TASK", TASK_COMMON_URL, @"REQUEST"], \
        @XDA_TICKER : @[@"TASK", TASK_COMMON_URL, @"REQUEST"], \
/*		@kD3602Id : @[@"D3602", GUEST_SERVICE_URL],	\*/
		@kC2315Id : @[@"C2315", SERVICE_URL],	\
		@kD4220Id : @[@"D4220", SERVICE_URL],	\
		@kC2090Id : @[@"C2090", SERVICE_URL],	\
		@kE1826Id : @[@"E1826", SERVICE_URL],	\
		@kD4222Id : @[@"D4222", SERVICE_URL],	\
		@kD3604Id : @[@"D3604", SERVICE_URL],	\
		@kD9501Id : @[@"D9501", SERVICE_URL],	\
		@kC2316Id : @[@"C2316", SERVICE_URL],	\
		@kC2800Id : @[@"C2800", SERVICE_URL],	\
		@kE2650Id : @[@"E2650", SERVICE_URL],	\
		@kD5520Id : @[@"D5520", TRANSFER_URL],	\
		@kD3280Id : @[@"D3280", SERVICE_URL],	\
        @kD4380Id : @[@"D4380", SERVICE_URL],	\
        @kD4381Id : @[@"D4381", SERVICE_URL],	\
        @kD4390Id : @[@"D4390", SERVICE_URL],	\
		@kD3611Id : @[@"D3611", SERVICE_URL],	\
		@kD3281Id : @[@"D3281", SERVICE_URL],	\
		@kD3285Id : @[@"D3285", SERVICE_URL],	\
		@kD3286Id : @[@"D3286", SERVICE_URL],	\
		@kD3282Id : @[@"D3282", SERVICE_URL],	\
		@kL1310Id : @[@"L1310", SERVICE_URL],	\
		@kC2092Id : @[@"C2092", SERVICE_URL],	\
		@kL1311Id : @[@"L1311", SERVICE_URL],	\
		@kL1312Id : @[@"L1312", SERVICE_URL],	\
        @kL1411Id : @[@"L1411", SERVICE_URL],	\
		@kD3607Id : @[@"D3607", SERVICE_URL],	\
		@kE4903Id : @[@"E4903", SERVICE_URL],	\
        @kE4903Id_olleh : @[@"E4903", SERVICE_URL],	\
        @kE4904Id : @[@"E4904", SERVICE_URL],	\
        @kD5020Id : @[@"D5020", D5020_SERVICE_URL],	\
        @kD3300Id : @[@"D3300", SERVICE_URL],	\
        @kD3112Id : @[@"D3112", SERVICE_URL],	\
        @kD3342Id : @[@"D3342", SERVICE_URL],	\
        @kD3343Id : @[@"D3343", SERVICE_URL],	\
        @kD3310Id : @[@"D3310", SERVICE_URL],	\
        @kD3320Id : @[@"D3320", SERVICE_URL],	\
        @kD3321Id : @[@"D3321", SERVICE_URL],	\
        @kD5022Id : @[@"D5022", SERVICE_URL],	\
        @kD3603Id : @[@"D3603", SERVICE_URL],	\
        @kD3276Id : @[@"D3276", ELD_SERVICE_URL],	\
        @kD6011Id : @[@"D6011", SERVICE_URL],	\
        @kD6012Id : @[@"D6012", SERVICE_URL],	\
        @kD6115Id : @[@"D6115", SERVICE_URL],	\
        @kD3277Id : @[@"D3277", SERVICE_URL],	\
        @kD3250Id : @[@"D3250", SERVICE_URL],	\
        @kD3251Id : @[@"D3251", SERVICE_URL],   \
        @kE2670Id : @[@"E2670", SERVICE_URL],	\
        @kD3287Id : @[@"D3287", TRANSFER_URL],   \
        @SMART_NEW_LIST : @[@"TASK", MULTI_SERVICE_URL, @"REQUEST"], \
		};
		
		[SHBBankingService addServiceInfo:info];
	}
}

- (void)start
{
	if (self.serviceId == kC2315Id) {
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   @"a" : @"a",
							   }];
		
		[self requestDataSet:dataSet];
	}
//	else if (self.serviceId == kD4220Id) {
//		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
//							   @"주민번호" : AppInfo.ssn,
//							   @"세금우대_D4222저축종류" : self.strDepositKind,
//							   }];
//		
//		[self requestDataSet:dataSet];
//	}
	else if (self.serviceId == kC2800Id) {
		Debug(@"AppInfo.customerNo : %@", AppInfo.customerNo);
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   @"고객번호" : AppInfo.customerNo ? AppInfo.customerNo : @"00",
							   }];
		
		[self requestDataSet:dataSet];
	}
	else if (self.serviceId == XDA_S00001_1) {
		
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
													TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
												  TASK_ACTION_KEY : @"getPrdInfoMsg",
							   @"구분" : @"1",
							   }];
		
		[self requestDataSet:dataSet];
	}
	else if (self.serviceId == XDA_S00001_2) {
		
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
							   TASK_ACTION_KEY : @"getPrdInfoMsg",
							   @"구분" : @"2",
							   }];

		[self requestDataSet:dataSet];
	}
	else if (self.serviceId == XDA_S00001_3) {
		
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
							   TASK_ACTION_KEY : @"getPrdInfoMsg",
							   @"구분" : @"3",
							   }];
		
		[self requestDataSet:dataSet];
	}
	else if (self.serviceId == XDA_S00001_4) {
		
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
							   TASK_ACTION_KEY : @"getPrdInfoMsg",
							   @"구분" : @"4",
							   }];
		
		[self requestDataSet:dataSet];
	}
    
    else if (self.serviceId == XDA_S00001_5) {
		
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
                                TASK_ACTION_KEY : @"getPrdInfoMsg",
                                @"구분" : @"5",
                                }];
		
		[self requestDataSet:dataSet];
	}
    
    else if (self.serviceId == XDA_S00001_6) {
		
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
                                TASK_ACTION_KEY : @"getPrdInfoMsg",
                                @"구분" : @"6",
                                }];
		
		[self requestDataSet:dataSet];
	}
    else if (self.serviceId == XDA_S00001_7) {
		
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                  TASK_NAME_KEY : @"sfg.sphone.task.product.Product",
                                TASK_ACTION_KEY : @"getPrdInfoMsg",
                                @"구분" : @"7",
                                }];
		
		[self requestDataSet:dataSet];
	}
    
	else if (self.serviceId == kE4903Id) {
		
		SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   @"검색구분" : @"2",
							   //@"검색번호" : AppInfo.ssn,
                               //@"검색번호" : [AppInfo getPersonalPK],
                               @"검색번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
							   @"은행구분" : @"1",
							   @"조회구분" : @"1",
							   @"검색내용" : @"",
							   }];
		
		[self requestDataSet:dataSet];
	}
    else if (self.serviceId == kD3310Id) {
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:
                               @{
                               @"검색구분" : @"1",
                               @"고객번호" : AppInfo.customerNo,
                               @"조회시작일" : [[SHBUtility dateStringToMonth:-1 toDay:0] stringByReplacingOccurrencesOfString:@"." withString:@""],
                               @"조회종료일" : [AppInfo.tran_Date stringByReplacingOccurrencesOfString:@"." withString:@""],
                               }];
        
        [self requestDataSet:dataSet];
    }
    else if (self.serviceId == kD3276Id) { // ELD상품목록
        
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   @"업무구분" : @"9",
							   @"조회시작일" : @"",
							   @"펀드유형" : @"",
                               @"투자유형" : @"",
							   @"운용사번호" : @"",
							   @"조회상품코드" : @"",
							   }];
		
		[self requestDataSet:dataSet];
    }
    else if (self.serviceId == kD6115Id) { // Email
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
							   @"검색번호" : @"1",
                               @"고객번호" : AppInfo.customerNo,
							   }];

        
		[self requestDataSet:dataSet];
    }
    else if (self.serviceId == SMART_NEW_LIST) {
        
        SHBDataSet *dataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                     TASK_NAME_KEY      : @"sfg.sphone.task.common.SBANKTaskService",
                                                                     TASK_ACTION_KEY    : @"smartNewList",
                                                                     }];
        
        
		[self requestDataSet:dataSet];
    }
	else
	{
        
		[self requestDataSet:(SHBDataSet *)self.requestData];
	}
}


@end
