//
//  SHBSecureService.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 10. 25..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBSecureService.h"

@implementation SHBSecureService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = SECURECONFIRM_SERVICE_INFO;
        [SHBBankingService addServiceInfo: info];
	}
}

- (void)start
{

    if (self.serviceId == SECURE_CARD)
    {
        SHBDataSet *aDataSet = self.previousData;
        
        [self requestDataSet:aDataSet];

    } else if (self.serviceId == SECURE_OTP) {
        
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

