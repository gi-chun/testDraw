//
//  SHBFundService.h
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 17..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBBankingService.h"

#define FUND_LIST                   3000
#define FUND_DETAIL_LIST            3001
#define FUND_BASIC_LIST             3002
#define FUND_ACCOUNT_CONFIRM        3003
#define FUND_DEPOSIT_CONTENT        3004
#define FUND_DRAWING_CONTENT        3005
#define FUND_DRAWING_CONFIRM        3006
#define FUND_DRAWING_INPUT          3007
#define FUND_DEPOSIT_INPUT          3008
#define FUND_FORWARD_EXCHANGE_LIST  3009
#define FUND_SECURITY_CARD          3010
#define FUND_OTP                    3011
#define FUND_DEPOSIT_CONFIRM        3012
#define FUND_DEPOSIT_CANCEL         3013
#define FUND_DRAWING_CANCEL         3014
#define FUND_DRAWING_D6340          3015

//SERVICE_ID, SERVICE_CODE, SERVICE_URL
#define FUND_SERVICE_INFO    @{  \
    @FUND_LIST:                 @[ @"D6010",SERVICE_URL],  \
    @FUND_DETAIL_LIST:          @[ @"D6020", SERVICE_URL], \
    @FUND_BASIC_LIST:           @[ @"D6090", SERVICE_URL], \
    @FUND_ACCOUNT_CONFIRM:      @[ @"C2090", SERVICE_URL], \
    @FUND_DEPOSIT_CONTENT:      @[ @"D6210", SERVICE_URL], \
    @FUND_DEPOSIT_CONFIRM:      @[ @"D6100", SERVICE_URL], \
    @FUND_DRAWING_CONTENT:      @[ @"D6310", SERVICE_URL], \
    @FUND_DRAWING_CONFIRM:      @[ @"C2092", SERVICE_URL], \
    @FUND_SECURITY_CARD:        @[ @"C2098", SERVICE_URL], \
    @FUND_OTP:                  @[ @"C2099", SERVICE_URL], \
    @FUND_DRAWING_INPUT:        @[ @"D6320", SERVICE_URL], \
    @FUND_DRAWING_D6340:        @[ @"D6340", SERVICE_URL], \
    @FUND_DEPOSIT_INPUT:        @[ @"D6230", SERVICE_URL], \
    @FUND_FORWARD_EXCHANGE_LIST:@[ @"D6024", SERVICE_URL], \
    @FUND_DEPOSIT_CANCEL:       @[ @"D6250", SERVICE_URL], \
    @FUND_DRAWING_CANCEL:       @[ @"D6360", SERVICE_URL]  \
};

@interface SHBFundService : SHBBankingService

@property (retain, nonatomic) SHBDataSet *fundDataSet;

@end
