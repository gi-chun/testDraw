//
//  SHBLoanService.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 15.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBLoanService.h"

@implementation SHBLoanService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = LOAN_SERVICE_INFO;
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