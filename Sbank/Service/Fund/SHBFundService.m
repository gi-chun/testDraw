//
//  SHBFundService.m
//  ShinhanBank
//
//  Created by 두베아이맥 on 12. 10. 17..
//  Copyright (c) 2012년 FInger Inc. All rights reserved.
//

#import "SHBFundService.h"

@implementation SHBFundService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = FUND_SERVICE_INFO;
        [SHBBankingService addServiceInfo: info];
	}
}

- (void) start
{
    // D6010
    if(self.serviceId == FUND_LIST)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                //                                @"고객번호" : [SHBAppInfo sharedSHBAppInfo].customerNo,
                                //                                @"주민등록번호" : [SHBAppInfo sharedSHBAppInfo].ssn,
//                                @"로그인예금조회구분" : @"1",
//                                @"보안계좌조회구분" : @"1",
//                                @"인터넷제한여부" : @"0",
                                }] autorelease];
        
        [self requestDataSet:aDataSet];
        
    // D6020
    } else if(self.serviceId == FUND_DETAIL_LIST)
    {
        SHBDataSet *aDataSet = nil;
        
        if ( [[self.previousData objectForKey:@"출력횟수"] length] > 0 )
        {
        // release 처리
        aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"거래구분" : @"2",
                                @"계좌번호" : [self.previousData objectForKey:@"계좌번호"],
                                @"은행구분" : @"1",
                                @"조회시작일" : [self.previousData objectForKey:@"조회시작일"],
                                @"조회종료일" : [self.previousData objectForKey:@"조회종료일"],
                                @"미기장거래" : @"",
                                @"직원조회" : @"1",
                                @"정렬구분" : @"2",
                                @"출력횟수" : @"10",
                                @"계좌비밀번호" : @""
                                }] autorelease];
        }
        else
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                     @{
                                     @"계좌번호" : [self.previousData objectForKey:@"계좌번호"],
                                     @"조회시작일" : [self.previousData objectForKey:@"조회시작일"],
                                     @"조회종료일" : [self.previousData objectForKey:@"조회종료일"]
                                     }] autorelease];
        }
        
        [self requestDataSet:aDataSet];
    
        // D6090
    } else if(self.serviceId == FUND_BASIC_LIST)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"조회구분" : @"8",
                                @"조회시작일" : [self.previousData objectForKey:@"조회시작일"],
                                @"조회종료일" : [self.previousData objectForKey:@"조회종료일"],
                                @"은행구분" : @"1",
                                @"펀드선택" : [self.previousData objectForKey:@"펀드선택"],
                                }] autorelease];
        [self requestDataSet:aDataSet];
        
    // C2090
    } else if (self.serviceId == FUND_ACCOUNT_CONFIRM)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                 @{
                                 @"출금계좌비밀번호" : [self.previousData objectForKey:@"출금계좌비밀번호"],
                                 @"출금계좌번호" : [self.previousData objectForKey:@"출금계좌번호"],
                                 @"은행구분" : [self.previousData objectForKey:@"은행구분"],
                                 @"납부금액" : [self.previousData objectForKey:@"납부금액"],
                                 @"reservationField1" : [self.previousData objectForKey:@"reservationField1"]
                                 }] autorelease];
        [self requestDataSet:aDataSet];
        
    // D6210
    } else if (self.serviceId == FUND_DEPOSIT_CONTENT)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"거래구분" : @"1",
                                @"계좌번호" : [self.previousData objectForKey:@"계좌번호"],
                                @"조회시작일" : @"",
                                @"조회종료일" : @"",
                                @"미기장거래" : @"2",
                                @"직원조회" : @"1",
                                @"정렬순서" : @"1",
                                @"출력횟수" : @""
                                }] autorelease];
        [self requestDataSet:aDataSet];
        
    // D6310
    } else if (self.serviceId == FUND_DRAWING_CONTENT)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"거래구분" : @"1",
                                @"계좌번호" : [self.previousData objectForKey:@"계좌번호"],
                                @"조회시작일" : @"",
                                @"조회종료일" : @"",
                                @"미기장거래" : @"2",
                                @"직원조회" : @"1",
                                @"정렬순서" : @"1",
                                @"출력횟수" : @""
                                }] autorelease];
        [self requestDataSet:aDataSet];
        
    // C2092
    } else if (self.serviceId == FUND_DRAWING_CONFIRM)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"출금계좌비밀번호"       : [self.previousData objectForKey:@"출금계좌비밀번호"],
                                @"출금계좌번호"          : [self.previousData objectForKey:@"출금계좌번호"],
                                @"은행구분"             : [self.previousData objectForKey:@"은행구분"],
                                @"reservationField1"  : @"FundWithdraw"
                                }] autorelease];
        [self requestDataSet:aDataSet];
        
        // D6320
    } else if (self.serviceId == FUND_DRAWING_INPUT)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"계좌번호" : [self.previousData objectForKey:@"계좌번호"],
                                @"은행구분" : [self.previousData objectForKey:@"은행구분"],
                                @"고객번호" : [self.previousData objectForKey:@"고객번호"],
                                @"업무구분" : [self.previousData objectForKey:@"업무구분"],
                                @"조회여부" : @"Y",
                                @"지급금액" : [self.previousData objectForKey:@"지급금액"],
                                @"지급좌수" : [self.previousData objectForKey:@"지급좌수"],
                                }] autorelease];
        [self requestDataSet:aDataSet];
        
    // D6230
    } else if (self.serviceId == FUND_DEPOSIT_INPUT)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"입금계좌번호" : [self.previousData objectForKey:@"입금계좌번호"],
                                @"입금은행구분" : [self.previousData objectForKey:@"입금은행구분"],
                                @"입금계좌번호" : @"",
                                @"입금은행구분" : @"",
                                @"납부금액"    : [self.previousData objectForKey:@"납부금액"],
                                @"납부금액"    : @"",
                                @"입금구분"    : @"291",
                                @"출금계좌번호" : [self.previousData objectForKey:@"출금계좌번호"],
                                @"출금은행구분" : [self.previousData objectForKey:@"출금은행구분"],
                                @"출금계좌비밀번호" : [self.previousData objectForKey:@"출금계좌비밀번호"],
                                @"LT거래여부"  : [self.previousData objectForKey:@"LT거래여부"],
                                @"LT승인번호"  : @"0",
                                }] autorelease];
        [self requestDataSet:aDataSet];
        
    // 선물환역외펀드
    // D6024 
    } else if (self.serviceId == FUND_FORWARD_EXCHANGE_LIST)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"계좌번호" : [self.previousData objectForKey:@"계좌번호"],
                                @"은행구분" : @"1",
                                @"조회시작일" : [self.previousData objectForKey:@"조회시작일"],
                                @"조회종료일" : [self.previousData objectForKey:@"조회종료일"],
                                @"거래구분" : @"1",
                                }] autorelease];
        [self requestDataSet:aDataSet];
        
    // C2098
    } else if (self.serviceId == FUND_SECURITY_CARD)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                     @{
                     @"이체비밀번호" : [self.previousData objectForKey:@"이체비밀번호"],
                     @"보안카드암호1" : [self.previousData objectForKey:@"보안카드암호1"],
                     @"보안카드암호2" : [self.previousData objectForKey:@"보안카드암호2"]
                     }] autorelease];
        [self requestDataSet:aDataSet];
    
    // C2099
    } else if (self.serviceId == FUND_OTP)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                    @{
                    @"이체비밀번호" : [self.previousData objectForKey:@"이체비밀번호"],
                    @"OTP카드암호" : [self.previousData objectForKey:@"OTP카드암호"],
                    }] autorelease];
        [self requestDataSet:aDataSet];
    
    // D6100
    } else if (self.serviceId == FUND_DEPOSIT_CONFIRM)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"업무구분" : @"1",
                                @"조회일자" : [self.previousData objectForKey:@"조회일자"],
                                @"상품코드" : [self.previousData objectForKey:@"상품코드"]
                                }] autorelease];
        [self requestDataSet:aDataSet];
        
    // D6250
    } else if (self.serviceId == FUND_DEPOSIT_CANCEL)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"거래구분" : @"1",
                                @"은행구분" : @"1",
                                @"계좌번호" : [self.previousData objectForKey:@"계좌번호"],
                                @"거래번호" : [self.previousData objectForKey:@"거래번호"],
                                @"거래일자" : [self.previousData objectForKey:@"거래일자"],
                                @"거래금액" : [self.previousData objectForKey:@"거래금액"],
                                @"거래종류" : [self.previousData objectForKey:@"거래종류"],
                                @"업무구분" : @"61",
                                @"거래구분코드" : @"6102",
                                }] autorelease];
        [self requestDataSet:aDataSet];
        
    // D6360
    } else if (self.serviceId == FUND_DRAWING_CANCEL)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"거래구분" : @"1",
                                @"은행구분" : @"1",
                                @"계좌번호" : [self.previousData objectForKey:@"계좌번호"],
                                @"거래번호" : [self.previousData objectForKey:@"거래번호"],
                                @"거래일자" : [self.previousData objectForKey:@"거래일자"],
                                @"거래금액" : [self.previousData objectForKey:@"거래금액"],
                                @"거래종류" : [self.previousData objectForKey:@"거래종류"],
                                @"업무구분" : @"61",
                                @"거래구분코드" : @"6111",
                                }] autorelease];
        [self requestDataSet:aDataSet];
        
    // D6340
    } else if (self.serviceId == FUND_DRAWING_D6340)
    {
        // release 처리
        SHBDataSet *aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                @{
                                @"계좌번호" : [self.previousData objectForKey:@"계좌번호"],
                                @"은행구분" : [self.previousData objectForKey:@"은행구분"],
                                @"계좌번호" : @"",
                                @"은행구분" : @"",
                                @"고객번호" : [self.previousData objectForKey:@"고객번호"],
                                @"업무구분" : [self.previousData objectForKey:@"업무구분"],
                                @"조회여부" : @"N",
                                @"지급금액" : [self.previousData objectForKey:@"지급금액"],
                                @"지급좌수" : [self.previousData objectForKey:@"지급좌수"],
                                @"출금계좌비밀번호" : [self.previousData objectForKey:@"출금계좌비밀번호"],
                                @"전액대체여부" : @"Y",
                                @"LT거래여부"  : [self.previousData objectForKey:@"LT거래여부"],
                                @"LT승인번호"  : @"0",
                                }] autorelease];
        [self requestDataSet:aDataSet];
    }
}

- (void)dealloc
{
    self.fundDataSet = nil;
    [super dealloc];
}

@end
