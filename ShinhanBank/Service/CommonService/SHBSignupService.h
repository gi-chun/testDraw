//
//  SHBSignupService.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 11. 19..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBBankingService.h"

#define ELEC_SIGNUP	920001

#define SIGNUP_FOREIGNER_ACCOUNT_CHECK	920002
#define SIGNUP_CHECK_DUPLICATE_ID		920003
#define SIGNUP_FOREIGNER_REQUEST_JOIN	920004

#define SIGNUP_PERSONAL_ACCOUNT_CHECK	920005
#define SIGNUP_PERSONAL_REQUEST_JOIN	920006
#define SIGNUP_CHECK_REAL_NAME			920007

#define SIGNUP_QRY_SERVICE				920008
#define SIGNUP_QRY_ACCOUNT_CHECK        920009


@interface SHBSignupService : SHBBankingService

@end
