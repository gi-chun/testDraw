//
//  SHBSettingsService.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 11. 30..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBSettingsService.h"

@implementation SHBSettingsService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
		
		NSDictionary *info = kSettingsServiceInfo;
		
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

@end
