//
//  SHBSignupService.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSignupService.h"

@implementation SHBSignupService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = @{  \
		@ELEC_SIGNUP : @[@"E4302", SERVICE_URL],   \
		@SIGNUP_FOREIGNER_ACCOUNT_CHECK : @[@"C2097", GUEST_SERVICE_URL],   \
		@SIGNUP_CHECK_DUPLICATE_ID: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
		@SIGNUP_FOREIGNER_REQUEST_JOIN : @[@"H0011", GUEST_SERVICE_URL],   \
		@SIGNUP_PERSONAL_ACCOUNT_CHECK : @[@"C2097", GUEST_SERVICE_URL],   \
		@SIGNUP_PERSONAL_REQUEST_JOIN : @[@"H0011", GUEST_SERVICE_URL],   \
		@SIGNUP_CHECK_REAL_NAME: @[ @"TASK", TASK_COMMON_URL, @"REQUEST"], \
        @SIGNUP_QRY_ACCOUNT_CHECK : @[@"C2094", GUEST_SERVICE_URL],   \
        @SIGNUP_QRY_SERVICE : @[@"H1009", GUEST_SERVICE_URL],   \
		};
        [SHBBankingService addServiceInfo: info];
	}
}

- (void)start
{
	
    if (self.serviceId == ELEC_SIGNUP || self.serviceId == SIGNUP_FOREIGNER_ACCOUNT_CHECK || self.serviceId == SIGNUP_FOREIGNER_REQUEST_JOIN || self.serviceId == SIGNUP_CHECK_DUPLICATE_ID){
        SHBDataSet *aDataSet = self.previousData;
        [self requestDataSet:aDataSet];
		
    }else if(self.serviceId == SIGNUP_PERSONAL_ACCOUNT_CHECK || self.serviceId == SIGNUP_PERSONAL_REQUEST_JOIN || self.serviceId == SIGNUP_CHECK_REAL_NAME){
        SHBDataSet *aDataSet = self.previousData;
        [self requestDataSet:aDataSet];
	}else if (self.serviceId == SIGNUP_QRY_ACCOUNT_CHECK || self.serviceId == SIGNUP_QRY_SERVICE){
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
