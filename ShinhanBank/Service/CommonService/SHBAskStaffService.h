//
//  SHBAskStaffService.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 15..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBankingService.h"

#define ASK_STAFF_QRY	910001
#define ASK_STAFF_SERVICE_INFO	@{  \
@ASK_STAFF_QRY : @[ @"E1826", GUEST_SERVICE_URL],   \
};


@interface SHBAskStaffService : SHBBankingService

@end
