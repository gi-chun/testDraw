//
//  SHBAskStaffService.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAskStaffService.h"

@implementation SHBAskStaffService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = @{	\
							@ASK_STAFF_QRY : @[@"E1826", GUEST_SERVICE_URL],	\
							};
        [SHBBankingService addServiceInfo: info];
	}
}

- (void)start{
    if (self.serviceId == ASK_STAFF_QRY){
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
