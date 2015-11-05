//
//  SHBSecureService.h
//  ShinhanBank
//
//  Created by unyong yoon on 12. 10. 25..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBBankingService.h"

#define SECURE_CARD     81000
#define SECURE_OTP      81001

#define SECURECONFIRM_SERVICE_INFO    @{  \
@SECURE_CARD : @[@"C2098",SERVICE_URL],   \
@SECURE_OTP: @[ @"C2099", SERVICE_URL], \
};

@interface SHBSecureService : SHBBankingService

@end
