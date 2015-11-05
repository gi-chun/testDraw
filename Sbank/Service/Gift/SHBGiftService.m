//
//  SHBGiftService.m
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBGiftService.h"

@implementation SHBGiftService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = GIFT_SERVICE_INFO;
        [SHBBankingService addServiceInfo:info];
	}
}

- (void)start
{
    if (!self.requestData) {
        self.requestData = [SHBDataSet dictionary];
    }
    
    [self requestDataSet:(SHBDataSet *)self.requestData];
}

- (void)dealloc
{
    [super dealloc];
}

@end
