//
//  SHBGiroTaxListService.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 10. 17..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBGiroTaxListService.h"

@implementation SHBGiroTaxListService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = TAX_SERVICE_INFO;
        [SHBBankingService addServiceInfo: info];
	}
}

- (void) start
{
    NSLog(@"Tax service start");
    SHBDataSet *aDataSet = nil;
    
    switch (self.serviceId)
    {
        case TAX_LIST:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"이용기관지로번호"    : [self.previousData objectForKey:@"이용기관지로번호"],
                         @"전자납부번호"       : [self.previousData objectForKey:@"전자납부번호"],
                         @"지정번호"          : [self.previousData objectForKey:@"지정번호"]
                         }] autorelease];
            
            aDataSet.serviceCode = TAX_LIST_G0111;
        }
            break;
            
        case TAX_PAYMENT_LIST:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"조회시작일자" : [self.previousData objectForKey:@"조회시작일자"],
                         @"조회종료일자" : [self.previousData objectForKey:@"조회종료일자"],
                         @"reservationField1" : [self.previousData objectForKey:@"reservationField1"],
                         @"reservationField2" : [self.previousData objectForKey:@"reservationField2"]
                         }] autorelease];
            aDataSet.serviceCode = TAX_PAYMENT_LIST_G0161;
        }
            break;
            
        case TAX_PAYMENT_ACCOUNT_CONFIRM:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"출금계좌비밀번호" : [self.previousData objectForKey:@"출금계좌비밀번호"],
                         @"출금계좌번호" : [self.previousData objectForKey:@"출금계좌번호"],
                         @"은행구분" : [self.previousData objectForKey:@"은행구분"],
                         @"납부금액" : [self.previousData objectForKey:@"납부금액"],
                         @"reservationField1" : [self.previousData objectForKey:@"reservationField1"]
                         }] autorelease];
            aDataSet.serviceCode = TAX_PAYMENT_ACCOUNT_CONFIRM_C2090;
        }
            break;
            
        case TAX_PAYMENT_SECURITY_CONFIRM:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"이체비밀번호" : [self.previousData objectForKey:@"이체비밀번호"],
                         @"보안카드암호1" : [self.previousData objectForKey:@"보안카드암호1"],
                         @"보안카드암호2" : [self.previousData objectForKey:@"보안카드암호2"]
                         }] autorelease];
            aDataSet.serviceCode = TAX_PAYMENT_SECURITY_CONFIRM_C2098;
        }
            break;
            
        case TAX_PAYMENT_RUN:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"이용기관지로번호" : [self.previousData objectForKey:@"이용기관지로번호"],
                         @"전자납부번호" : [self.previousData objectForKey:@"전자납부번호"],
                         @"고객조회번호" : [self.previousData objectForKey:@"고객조회번호"],
                         @"수납기관명" : [self.previousData objectForKey:@"수납기관명"],
                         @"부과년월" : [self.previousData objectForKey:@"부과년월"],
                         @"납부기한" : [self.previousData objectForKey:@"납부기한"],
                         @"고지형태" : [self.previousData objectForKey:@"고지형태"],
                         @"발행형태" : [self.previousData objectForKey:@"발행형태"],
                         @"납기내후구분" : [self.previousData objectForKey:@"납기내후구분"],
                         @"납부금액" : [self.previousData objectForKey:@"납부금액"],
                         @"납부일자" : [self.previousData objectForKey:@"납부일자"],
                         @"출금계좌번호" : [self.previousData objectForKey:@"출금계좌번호"],
                         @"출금계좌비밀번호" : [self.previousData objectForKey:@"출금계좌비밀번호"],
                         @"연락전화번호" : [self.previousData objectForKey:@"연락전화번호"],
                         @"납부자성명" : [self.previousData objectForKey:@"납부자성명"],
                         @"기타" : [self.previousData objectForKey:@"기타"]
                         }] autorelease];
            aDataSet.serviceCode = TAX_PAYMENT_RUN_G0113;
        }
            break;
            
        case TAX_LIST_ONLY_GIRO_NUMBER:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"전문종별코드"    : [self.previousData objectForKey:@"전문종별코드"],
                         @"거래구분코드"    : [self.previousData objectForKey:@"거래구분코드"],
                         @"발행기관코드"    : [self.previousData objectForKey:@"발행기관코드"],
                         @"이용기관지로번호"    : [self.previousData objectForKey:@"이용기관지로번호"],
                         @"발행기관코드2"    : [self.previousData objectForKey:@"발행기관코드2"],
                         @"이용기관지로번호2"    : [self.previousData objectForKey:@"이용기관지로번호2"]
                         }] autorelease];
            aDataSet.serviceCode = TAX_LIST_ONLY_GIRO_NUMBER_G0120;
        }
            break;
            
        case TAX_LIST_ONLY_GIRO_NUMBER_RUN_TYPE_OCR:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"이용기관지로번호"    : self.previousData[@"이용기관지로번호"],
                         @"고객조회번호"    : self.previousData[@"고객조회번호"],
                         @"부과년월"    : self.previousData[@"부과년월"],
                         @"수납기관명"    : self.previousData[@"수납기관명"],
                         @"출금계좌번호"    : self.previousData[@"출금계좌번호"],
                         @"출금계좌비밀번호"    : self.previousData[@"출금계좌비밀번호"],
                         @"납부금액"    : self.previousData[@"납부금액"],
                         @"납부일자"    : self.previousData[@"납부일자"],
                         @"금액검증번호"    : self.previousData[@"금액검증번호"],
                         @"납부자성명"    : self.previousData[@"납부자성명"],
                         @"연락전화번호"    : self.previousData[@"연락전화번호"],
                         @"reservationField1"    : self.previousData[@"reservationField1"]
                         }] autorelease];
            aDataSet.serviceCode = TAX_LIST_ONLY_GIRO_NUMBER_RUN_G0123;
            
        }
            break;
            
        case TAX_LIST_ONLY_GIRO_NUMBER_RUN_TYPE_MICR:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"이용기관지로번호"    : self.previousData[@"이용기관지로번호"],
                         @"고객조회번호"    : self.previousData[@"고객조회번호"],
                         @"부과년월"    : self.previousData[@"부과년월"],
                         @"수납기관명"    : self.previousData[@"수납기관명"],
                         @"출금계좌번호"    : self.previousData[@"출금계좌번호"],
                         @"출금계좌비밀번호"    : self.previousData[@"출금계좌비밀번호"],
                         @"납부금액"    : self.previousData[@"납부금액"],
                         @"납부일자"    : self.previousData[@"납부일자"],
                         @"납부자성명"    : self.previousData[@"납부자성명"],
                         @"연락전화번호"    : self.previousData[@"연락전화번호"],
                         @"reservationField1"    : self.previousData[@"reservationField1"]
                         }] autorelease];
            
            aDataSet.serviceCode = TAX_LIST_ONLY_GIRO_NUMBER_RUN_G0123;
            
        }
            break;
            
        case TAX_PAYMENT_CANCEL_RUN:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                           @"납부자주민등록번호" : (AppInfo.isLogin == LoginTypeNo) ? self.previousData[@"납부자주민등록번호"] : @"",
                         @"원거래전문번호" : self.previousData[@"원거래전문번호"],
                         @"납부일시" : self.previousData[@"납부일시"],
                         @"출금계좌번호" : self.previousData[@"출금계좌번호"],
                         @"납부금액" : self.previousData[@"납부금액"],
                         @"납부형태구분" : self.previousData[@"납부형태구분"]
                         }] autorelease];
            
            aDataSet.serviceCode = TAX_PAYMENT_CANCEL_RUN_G0163;
            
        }
            break;
            
            
        case TAX_DISTRIC_PAYMENT_LIST:
        {
            // 본인명의, 간편납부 재조회의 경우
            if (self.previousData[@"reservationField9"])
            {
                    aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                                 @{
                                 @"전문종별코드" : [self.previousData objectForKey:@"전문종별코드"],
                                 @"거래구분코드" : [self.previousData objectForKey:@"거래구분코드"],
                                 @"이용기관지로번호" : [self.previousData objectForKey:@"이용기관지로번호"],
                                 @"조회구분" : [self.previousData objectForKey:@"조회구분"],
                                 @"간편납부번호" : [self.previousData objectForKey:@"간편납부번호"],
                                 @"총고지건수" : [self.previousData objectForKey:@"총고지건수"],
                                 @"총고지금액" : [self.previousData objectForKey:@"총고지금액"],
                                 @"지정번호" : [self.previousData objectForKey:@"지정번호"],
                                 @"reservationField9" : [self.previousData objectForKey:@"reservationField9"],
                                 @"데이터건수" : [self.previousData objectForKey:@"데이터건수"]
                                 }] autorelease];
            }
            else            // 본인명의, 간편납부의 최초 실행경우
            {
                aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                             @{
                             @"전문종별코드" : [self.previousData objectForKey:@"전문종별코드"],
                             @"거래구분코드" : [self.previousData objectForKey:@"거래구분코드"],
                             @"이용기관지로번호" : [self.previousData objectForKey:@"이용기관지로번호"],
                             @"조회구분" : [self.previousData objectForKey:@"조회구분"],
                             @"간편납부번호" : [self.previousData objectForKey:@"간편납부번호"],
                             @"고지주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [self.previousData objectForKey:@"고지주민번호"] :@"",
                             //@"고지주민번호" : [self.previousData objectForKey:@"고지주민번호"],
                             @"총고지건수" : [self.previousData objectForKey:@"총고지건수"],
                             @"총고지금액" : [self.previousData objectForKey:@"총고지금액"],
                             @"지정번호" : [self.previousData objectForKey:@"지정번호"],
                             @"데이터건수" : [self.previousData objectForKey:@"데이터건수"]
                             }] autorelease];
            }
            
            aDataSet.serviceCode = TAX_DISTRIC_PAYMENT_LIST_G1411;
        }
            break;
            
        case TAX_DISTRIC_PAYMENT_DETAIL:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"전문종별코드" : [self.previousData objectForKey:@"전문종별코드"],
                         @"거래구분코드" : [self.previousData objectForKey:@"거래구분코드"],
                         @"이용기관지로번호" : [self.previousData objectForKey:@"이용기관지로번호"],
                         @"조회구분" : [self.previousData objectForKey:@"조회구분"],
                         @"전자납부번호" : [self.previousData objectForKey:@"전자납부번호"],
                         @"예비1" : [self.previousData objectForKey:@"예비1"]
                         }] autorelease];
            
            aDataSet.serviceCode = TAX_DISTRIC_PAYMENT_DETAIL_G1412;
        }
            break; 
            
            
        case LOCAL_TAX_LIST_NEW:
        {
            if (self.previousData[@"reservationField9"])
            {
                aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                             @{
                             @"전문종별코드" : [self.previousData objectForKey:@"전문종별코드"],
                             @"거래구분코드" : [self.previousData objectForKey:@"거래구분코드"],
                             @"이용기관지로번호" : [self.previousData objectForKey:@"이용기관지로번호"],
                             @"거래조회구분" : [self.previousData objectForKey:@"거래조회구분"],
                             @"조회계좌번호" : [self.previousData objectForKey:@"조회계좌번호"],
                             @"조회시작일자" : [self.previousData objectForKey:@"조회시작일자"],
                             @"조회종료일자" : [self.previousData objectForKey:@"조회종료일자"],
                             @"데이터건수" : [self.previousData objectForKey:@"데이터건수"],
                             @"지정번호" : [self.previousData objectForKey:@"지정번호"],
                             @"reservationField9" : [self.previousData objectForKey:@"reservationField9"]
                             }] autorelease];
            }
            else
            {
                aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                             @{
                             @"전문종별코드" : [self.previousData objectForKey:@"전문종별코드"],
                             @"거래구분코드" : [self.previousData objectForKey:@"거래구분코드"],
                             @"이용기관지로번호" : [self.previousData objectForKey:@"이용기관지로번호"],
                             @"거래조회구분" : [self.previousData objectForKey:@"거래조회구분"],
                             @"조회계좌번호" : [self.previousData objectForKey:@"조회계좌번호"],
                             @"조회시작일자" : [self.previousData objectForKey:@"조회시작일자"],
                             @"조회종료일자" : [self.previousData objectForKey:@"조회종료일자"],
                             @"데이터건수" : [self.previousData objectForKey:@"데이터건수"],
                             @"지정번호" : [self.previousData objectForKey:@"지정번호"]
                             }] autorelease];
            }
            aDataSet.serviceCode = LOCAL_TAX_LIST_NEW_G1421;
        }
            break;
            
        case LOCAL_TAX_LIST_OLD:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"전문종별코드" : [self.previousData objectForKey:@"전문종별코드"],
                         @"거래구분코드" : [self.previousData objectForKey:@"거래구분코드"],
                         @"이용기관지로번호" : [self.previousData objectForKey:@"이용기관지로번호"],
                         @"거래조회구분" : [self.previousData objectForKey:@"거래조회구분"],
                         @"조회계좌번호" : [self.previousData objectForKey:@"조회계좌번호"],
                         @"조회시작일자" : [self.previousData objectForKey:@"조회시작일자"],
                         @"조회종료일자" : [self.previousData objectForKey:@"조회종료일자"],
                         @"데이터건수" : [self.previousData objectForKey:@"데이터건수"],
                         @"지정번호" : [self.previousData objectForKey:@"지정번호"]
                         }] autorelease];
            aDataSet.serviceCode = LOCAL_TAX_LIST_OLD_G0321;
        }
            break;
            
        case LOCAL_TAX_NEW_DETAIL:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"전문종별코드" : [self.previousData objectForKey:@"전문종별코드"],
                         @"거래구분코드" : [self.previousData objectForKey:@"거래구분코드"],
                         @"이용기관지로번호" : [self.previousData objectForKey:@"이용기관지로번호"],
                         @"조회구분" : [self.previousData objectForKey:@"조회구분"],
                         @"전자납부번호" : [self.previousData objectForKey:@"전자납부번호"]
                         }] autorelease];
            aDataSet.serviceCode = LOCAL_TAX_NEW_DETAIL_G1422;
        }
            break;
            
        case LOCAL_TAX_OLD_DETAIL:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"이용기관지로번호" : [self.previousData objectForKey:@"이용기관지로번호"],
                         @"전자납부번호" : [self.previousData objectForKey:@"전자납부번호"],
                         @"납부자주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [self.previousData objectForKey:@"납부자주민번호"] : @"",
                         }] autorelease];
            
            aDataSet.serviceCode = LOCAL_TAX_OLD_DETAIL_G0322;
        }
            break;
            
        case LOCAL_TAX_ACCOUNT_CONFIRM:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"출금계좌비밀번호"          : self.previousData[@"출금계좌비밀번호"],
                         @"출금계좌번호"            : self.previousData[@"출금계좌번호"],
                         @"은행구분"              : self.previousData[@"은행구분"], // (!주의)신, 구 계좌에 따른 값 변경 있음 정보처리되어서 옴
                         @"납부금액"              : self.previousData[@"납부금액"],
                         @"reservationField1"    : self.previousData[@"reservationField1"],
                         @"reservationField2"    : self.previousData[@"reservationField2"]
                         }] autorelease];
            
            aDataSet.serviceCode = LOCAL_TAX_ACCOUNT_CONFIRM_C2090;
        }
            break;
            
        case LOCAL_TAX_RUN:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"이용기관지로번호" : self.previousData[@"이용기관지로번호"],
                         @"납세번호" : self.previousData[@"납세번호"],
                         @"전자납부번호" : self.previousData[@"전자납부번호"],
                         @"고지주민번호" : (AppInfo.isLogin == LoginTypeNo) ? self.previousData[@"고지주민번호"] : @"",
                         @"납부금액" : self.previousData[@"납부금액"],
                         @"납기내금액" : self.previousData[@"납기내금액"],
                         @"납기후금액" : self.previousData[@"납기후금액"],
                         @"납부일자" : self.previousData[@"납부일자"],
                         @"출금계좌번호" : self.previousData[@"출금계좌번호"],
                         @"출금계좌비밀번호" : self.previousData[@"출금계좌비밀번호"],
//                         @"납부자주민번호" : self.previousData[@"납부자주민번호"]           // 주민번호 미사용
                         }] autorelease];
            
            aDataSet.serviceCode = LOCAL_TAX_RUN_G1414;
        }
            break;
            
            
            
        case TAX_COMMON_CODE:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"codeKey" : [self.previousData objectForKey:@"codeKey"]
                         }] autorelease];
            aDataSet.serviceCode = REGION_CODE;
        }
            break;
            
        default:
            break;
    }
    
    [self requestDataSet:aDataSet];
}

@end
