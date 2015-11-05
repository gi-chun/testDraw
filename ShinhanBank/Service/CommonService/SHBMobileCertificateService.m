//
//  SHBMobileCertificateService.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 13..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBMobileCertificateService.h"

@implementation SHBMobileCertificateService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = @{
                               @MOBILE_CERT_E2114 : @[@"E2114", E2114_SERVICE_URL],
                                @MOBILE_CERT_E2116: @[ @"E2116", GUEST_SERVICE_URL],
                                @MOBILE_CERT_E4001: @[ @"E4001", GUEST_SERVICE_URL],
                                @MOBILE_CERT_E3019: @[@"E3019", SERVICE_URL],
                                @MOBILE_CERT_SIGNUP: @[ @"H1009", GUEST_SERVICE_URL],
                                @MOBILE_CERT_E4149: @[@"E4149", SERVICE_URL],
                                };
		
        [SHBBankingService addServiceInfo: info];
	}
}

- (void)start
{
    if (!self.requestData) {
        self.requestData = [SHBDataSet dictionary];
    }
    
    [self requestDataSet:(SHBDataSet *)self.requestData];
}

@end
