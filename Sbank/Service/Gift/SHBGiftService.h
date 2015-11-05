//
//  SHBGiftService.h
//  ShinhanBank
//
//  Created by Joon on 2014. 7. 22..
//  Copyright (c) 2014년 Finger Inc. All rights reserved.
//

#import "SHBBankingService.h"

#define GIFT_E1710 1234001
#define GIFT_E1720 1234002
#define GIFT_E1730 1234003
#define GIFT_E1740 1234004

#define GIFT_SERVICE_INFO    @{  \
@GIFT_E1710 : @[@"E1710", SERVICE_URL], \
@GIFT_E1720 : @[@"E1720", SERVICE_URL], \
@GIFT_E1730 : @[@"E1730", SERVICE_URL], \
@GIFT_E1740 : @[@"E1740", SERVICE_URL], \
};

@interface SHBGiftService : SHBBankingService

@end
