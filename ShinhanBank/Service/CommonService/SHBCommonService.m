//
//  SHBCommonService.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 3..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCommonService.h"

@implementation SHBCommonService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = @{  \
		@OLD_ZIP_CODE: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
		@NEW_ZIP_CODE : @[@"C2821", GUEST_SERVICE_URL],   \
		};
        [SHBBankingService addServiceInfo: info];
	}
}

- (void)start
{
	
    if (self.serviceId == OLD_ZIP_CODE || self.serviceId == NEW_ZIP_CODE){
        SHBDataSet *aDataSet = self.previousData;
        [self requestDataSet:aDataSet];
		
    }
}

- (BOOL) onParse: (OFDataSet*) aDataSet string: (NSData*) aContent
{
    
    return YES;
}

- (BOOL) onBind: (OFDataSet*) aDataSet
{
    return YES;
}

@end
