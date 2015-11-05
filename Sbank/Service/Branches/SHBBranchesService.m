//
//  SHBBranchesService.m
//  ShinhanBank
//
//  Created by cubemeca on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBranchesService.h"

@implementation SHBBranchesService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
		
		NSDictionary *info = kBranchesServiceInfo;
		
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
