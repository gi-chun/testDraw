//
//  SHBBankingService.h
//  OrchestraNative
//
//  Created by Jang, Seyoung on 8/31/12.
//  Copyright (c) 2012 Finger Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OFService.h"

@interface SHBBankingService : OFService

+ (NSMutableDictionary *)serviceInfo;
+ (void) addServiceInfo: (NSDictionary*) aServiceInfo;

+ (NSString*) urlForServiceId: (int) serviceId;
+ (NSString *)urlForServiceCode:(NSString *)serviceCode;

//+ (SHBBankingService*) getService: (int) aServiceId viewController: (UIViewController*) aViewController;

- (id) initWithServiceId: (int) aServiceId viewController: (UIViewController*) aViewController;
- (id) initWithServiceCode:(NSString *) aServiceCode viewController:(UIViewController*) aViewController;
- (void) requestDataSet:(SHBDataSet *)aDataSet;
- (void) delyRequestService:(SHBDataSet *)aDataSet;
@end
