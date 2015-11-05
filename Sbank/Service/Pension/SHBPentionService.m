//
//  SHBPentionService.m
//  ShinhanBank
//
//  Created by Jonghyeop Kim on 12. 11. 12..
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBPentionService.h"

@implementation SHBPentionService


+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = PENSION_SERVICE_INFO;
        [SHBBankingService addServiceInfo: info];
	}
}

- (void) start
{
    NSLog(@"Pension service start");
    SHBDataSet *aDataSet = nil;
    
    switch (self.serviceId)
    {
            
        case PENSION_JOIN_JUDGE:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"서비스ID" : self.previousData[@"서비스ID"],
                         @"고객구분" : self.previousData[@"고객구분"],
                         @"플랜번호" : self.previousData[@"플랜번호"],
                         @"가입자번호" : self.previousData[@"가입자번호"],
                         @"제도구분" : self.previousData[@"제도구분"],
                         @"페이지인덱스" : self.previousData[@"페이지인덱스"],
                         @"전체조회건수" : self.previousData[@"전체조회건수"],
                         @"페이지패치건수" : self.previousData[@"페이지패치건수"],
                         @"예비필드" : self.previousData[@"예비필드"],
                         @"적립금조회" : self.previousData[@"적립금조회"],
                         @"주민사업자번호" : (AppInfo.isLogin == LoginTypeNo) ? self.previousData[@"주민사업자번호"] : @"",
                         }] autorelease];
            
            aDataSet.serviceCode = PENSION_JOIN_JUDGE_E3925;
        }
            break;
            
        case PENSION_AGREE:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"고객번호" : self.previousData[@"고객번호"],
                         @"reservationField1" : self.previousData[@"reservationField1"]
                         }] autorelease];
            
            aDataSet.serviceCode = PENSION_AGREE_C2315;
        }
            break;
            
        case PENSION_AGREE_RUN:
        {
            aDataSet = [SHBDataSet dictionaryWithDictionary:self.requestData];
            
            aDataSet.serviceCode = PENSION_AGREE_RUN_C2316;
        }
            break;
            
        case PENSION_RESERVE_LIST:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"서비스ID" : [self.previousData objectForKey:@"서비스ID"],
                         @"고객구분" : [self.previousData objectForKey:@"고객구분"],
                         @"플랜번호" : [self.previousData objectForKey:@"플랜번호"],
                         @"가입자번호" : [self.previousData objectForKey:@"가입자번호"],
                         @"제도구분" : [self.previousData objectForKey:@"제도구분"],
                         @"페이지인덱스" : [self.previousData objectForKey:@"페이지인덱스"],
                         @"전체조회건수" : [self.previousData objectForKey:@"전체조회건수"],
                         @"페이지패치건수" : [self.previousData objectForKey:@"페이지패치건수"],
                         @"예비필드" : [self.previousData objectForKey:@"예비필드"],
                         @"주민사업자번호" : (AppInfo.isLogin == LoginTypeNo) ? [self.previousData objectForKey:@"주민사업자번호"] : @"",
                         }] autorelease];
            
            aDataSet.serviceCode = PENSION_RESERVE_LIST_E3946;
        }
            break;
            
        case PENSION_RESERVE_LIST_DETAIL:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"서비스ID" : self.previousData[@"서비스ID"],
                         @"고객구분" : self.previousData[@"고객구분"],
                         @"플랜번호" : self.previousData[@"플랜번호"],
                         @"가입자번호" : self.previousData[@"가입자번호"],
                         @"제도구분" : self.previousData[@"제도구분"],
                         @"페이지인덱스" : self.previousData[@"페이지인덱스"],
                         @"전체조회건수" : self.previousData[@"전체조회건수"],
                         @"페이지패치건수" : self.previousData[@"페이지패치건수"],
                         @"예비필드" : self.previousData[@"예비필드"]
                         }] autorelease];
            
            aDataSet.serviceCode = PENSION_RESERVE_LIST_DETAIL_E3700;
        }
            break;
            
        case PENSION_PRODUCT_STATE_DETAIL:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"서비스ID" : [self.previousData objectForKey:@"서비스ID"],
                         @"고객구분" : [self.previousData objectForKey:@"고객구분"],
                         @"플랜번호" : [self.previousData objectForKey:@"플랜번호"],
                         @"가입자번호" : [self.previousData objectForKey:@"가입자번호"],
                         @"제도구분" : [self.previousData objectForKey:@"제도구분"],
                         @"페이지인덱스" : [self.previousData objectForKey:@"페이지인덱스"],
                         @"전체조회건수" : [self.previousData objectForKey:@"전체조회건수"],
                         @"페이지패치건수" : [self.previousData objectForKey:@"페이지패치건수"],
                         @"예비필드" : [self.previousData objectForKey:@"예비필드"],
                         @"조회시작일자" : [self.previousData objectForKey:@"조회시작일자"],
                         @"조회종료일자" : [self.previousData objectForKey:@"조회종료일자"]
                         }] autorelease];
            
            aDataSet.serviceCode = PENSION_PRODUCT_STATE_DETAIL_E3715;
        }
            break;
            
        case PENSION_SURCHARGE_LIST:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"서비스ID" : self.previousData[@"서비스ID"],
                         @"고객구분" : self.previousData[@"고객구분"],
                         @"플랜번호" : self.previousData[@"플랜번호"],
                         @"가입자번호" : self.previousData[@"가입자번호"],
                         @"제도구분" : self.previousData[@"제도구분"],
                         @"예비필드" : self.previousData[@"예비필드"],
                         @"조회시작일자" : self.previousData[@"조회시작일자"],
                         @"조회종료일자" : self.previousData[@"조회종료일자"]
                         }] autorelease];
            
            aDataSet.serviceCode = PENSION_SURCHARGE_LIST_E3710;
        }
            break;
            
        case PENSION_SURCHARGE_DC_CONFIRM:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"서비스ID" : self.previousData[@"서비스ID"],
                         @"고객구분" : self.previousData[@"고객구분"],
                         @"플랜번호" : self.previousData[@"플랜번호"],
                         @"가입자번호" : self.previousData[@"가입자번호"],
                         @"제도구분" : self.previousData[@"제도구분"],
                         @"페이지인덱스" : self.previousData[@"페이지인덱스"],
                         @"전체조회건수" : self.previousData[@"전체조회건수"],
                         @"페이지패치건수" : self.previousData[@"페이지패치건수"],
                         @"예비필드" : self.previousData[@"예비필드"],
                         @"이체금액" : self.previousData[@"이체금액"]
                         }] autorelease];
            
            aDataSet.serviceCode = PENSION_SURCHARGE_DC_CONFIRM_E3725;
        }
            break;
            
        case PENSION_SURCHARGE_CONFIRM:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"고객번호" : self.previousData[@"고객번호"],
                         @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? self.previousData[@"주민번호"] : @"",
                         @"출금계좌번호" : self.previousData[@"출금계좌번호"],
                         @"출금계좌비밀번호" : self.previousData[@"출금계좌비밀번호"],
                         @"입금은행코드" : self.previousData[@"입금은행코드"],
                         @"입금계좌번호" : self.previousData[@"입금계좌번호"],
                         @"이체금액" : self.previousData[@"이체금액"],
                         @"reservationField1" : self.previousData[@"reservationField1"],
                         @"reservationField2" : self.previousData[@"reservationField2"]
                         }] autorelease];
            
            aDataSet.serviceCode = PENSION_SURCHARGE_CONFIRM_D2031;
        }
            break;
            
        case PENSION_SURCHARGE_RUN:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"고객번호" : self.previousData[@"고객번호"],
                         @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? self.previousData[@"주민번호"] : @"",
                         @"전문구분" : self.previousData[@"전문구분"],
                         @"출금계좌번호" : self.previousData[@"출금계좌번호"],
                         @"출금계좌비밀번호" : self.previousData[@"출금계좌비밀번호"],
//                         @"출금계좌성명" : self.previousData[@"출금계좌성명"],
                         @"입금은행코드" : self.previousData[@"입금은행코드"],
                         @"입금계좌번호" : self.previousData[@"입금계좌번호"],
//                         @"입금계좌성명" : self.previousData[@"입금계좌성명"],
//                         @"이체금액" : self.previousData[@"이체금액"],
                         @"적요코드" : self.previousData[@"적요코드"],
                         @"모바일IC코드" : self.previousData[@"모바일IC코드"],
                         @"전화번호" : self.previousData[@"전화번호"],
                         @"출금계좌통장메모" : self.previousData[@"출금계좌통장메모"],
                         @"입금계좌통장메모" : self.previousData[@"입금계좌통장메모"],
//                         @"출금계좌부기명" : self.previousData[@"출금계좌부기명"],
                         @"CMS코드" : self.previousData[@"CMS코드"],
                         @"출금은행구분" : self.previousData[@"출금은행구분"],
                         @"입금예정번호" : self.previousData[@"입금예정번호"]
                         }] autorelease];

            aDataSet.serviceCode = PENSION_SURCHARGE_RUN_D2033;
        }
            break;
            
        case PENSION_ES_NOTI_EDIT_INFO:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"서비스ID" : self.previousData[@"서비스ID"],
                         @"고객구분" : self.previousData[@"고객구분"],
                         @"플랜번호" : self.previousData[@"플랜번호"],
                         @"가입자번호" : self.previousData[@"가입자번호"],
                         @"제도구분" : self.previousData[@"제도구분"],
                         @"페이지인덱스" : self.previousData[@"페이지인덱스"],
                         @"전체조회건수" : self.previousData[@"전체조회건수"],
                         @"페이지패치건수" : self.previousData[@"페이지패치건수"],
                         @"예비필드" : self.previousData[@"예비필드"],
                         @"플랜번호_1" : self.previousData[@"플랜번호_1"],
                         @"가입자번호_1" : self.previousData[@"가입자번호_1"],
                         @"고객구분_1" : self.previousData[@"고객구분_1"],
                         @"email수신여부" : self.previousData[@"email수신여부"],
                         @"운용현황통보주기" : self.previousData[@"운용현황통보주기"],
                         @"운용현황" : self.previousData[@"운용현황"],
                         @"가입자교육자료" : self.previousData[@"가입자교육자료"],
                         @"펀드운용보고서" : self.previousData[@"펀드운용보고서"],
                         @"월간펀드리포트" : self.previousData[@"월간펀드리포트"],
                         @"신한경제브리프" : self.previousData[@"신한경제브리프"],
                         @"sms수신여부" : self.previousData[@"sms수신여부"],
                         @"운용수익률통보주기" : self.previousData[@"운용수익률통보주기"],
                         @"운용수익률" : self.previousData[@"운용수익률"],
                         @"부담금납부현황" : self.previousData[@"부담금납부현황"],
                         @"우편번호1" : self.previousData[@"우편번호1"],
                         @"우편번호2" : self.previousData[@"우편번호2"],
                         @"우편번호주소" : self.previousData[@"우편번호주소"],
                         @"상세주소" : self.previousData[@"상세주소"],
                         @"휴대전화번호_1" : self.previousData[@"휴대전화번호_1"],
                         @"휴대전화번호_2" : self.previousData[@"휴대전화번호_2"],
                         @"휴대전화번호_3" : self.previousData[@"휴대전화번호_3"],
                         @"email주소" : self.previousData[@"email주소"],
                         @"제도구분_1" : self.previousData[@"제도구분_1"],
                         @"전화번호_1" : self.previousData[@"전화번호_1"],
                         @"전화번호_2" : self.previousData[@"전화번호_2"],
                         @"전화번호_3" : self.previousData[@"전화번호_3"]
                         }] autorelease];
            
            aDataSet.serviceCode = PENSION_ES_NOTI_EDIT_INFO_E3735;
        }
            break;
            
        case PENSION_ES_NOTI_EDIT_INFO_SUMMIT:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"서비스ID" : self.previousData[@"서비스ID"],
                         @"고객구분" : self.previousData[@"고객구분"],
                         @"플랜번호" : self.previousData[@"플랜번호"],
                         @"가입자번호" : self.previousData[@"가입자번호"],
                         @"제도구분" : self.previousData[@"제도구분"],
                         @"페이지인덱스" : self.previousData[@"페이지인덱스"],
                         @"전체조회건수" : self.previousData[@"전체조회건수"],
                         @"페이지패치건수" : self.previousData[@"페이지패치건수"],
                         @"예비필드" : self.previousData[@"예비필드"],
                         @"플랜번호_1" : self.previousData[@"플랜번호_1"],
                         @"가입자번호_1" : self.previousData[@"가입자번호_1"],
                         @"고객구분_1" : self.previousData[@"고객구분_1"],
                         @"email수신여부" : self.previousData[@"email수신여부"],
                         @"운용현황통보주기" : self.previousData[@"운용현황통보주기"],
                         @"운용현황" : self.previousData[@"운용현황"],
                         @"가입자교육자료" : self.previousData[@"가입자교육자료"],
                         @"펀드운용보고서" : self.previousData[@"펀드운용보고서"],
                         @"월간펀드리포트" : self.previousData[@"월간펀드리포트"],
                         @"신한경제브리프" : self.previousData[@"신한경제브리프"],
                         @"sms수신여부" : self.previousData[@"sms수신여부"],
                         @"운용수익률통보주기" : self.previousData[@"운용수익률통보주기"],
                         @"운용수익률" : self.previousData[@"운용수익률"],
                         @"부담금납부현황" : self.previousData[@"부담금납부현황"],
                         @"우편번호1" : self.previousData[@"우편번호1"],
                         @"우편번호2" : self.previousData[@"우편번호2"],
                         @"우편번호주소" : self.previousData[@"우편번호주소"],
                         @"상세주소" : self.previousData[@"상세주소"],
                         @"휴대전화번호_1" : self.previousData[@"휴대전화번호_1"],
                         @"휴대전화번호_2" : self.previousData[@"휴대전화번호_2"],
                         @"휴대전화번호_3" : self.previousData[@"휴대전화번호_3"],
                         @"email주소" : self.previousData[@"email주소"],
                         @"제도구분_1" : self.previousData[@"제도구분_1"],
                         @"전화번호_1" : self.previousData[@"전화번호_1"],
                         @"전화번호_2" : self.previousData[@"전화번호_2"],
                         @"전화번호_3" : self.previousData[@"전화번호_3"]
                         }] autorelease];
            
            aDataSet.serviceCode = PENSION_ES_NOTI_EDIT_INFO_SUMMIT_E3740;
        }
            break;
            
        case PENSION_ES_NOTI_EDIT_AGREE_INFO_SUMMIT:
        {
            aDataSet = [[[SHBDataSet alloc] initWithDictionary:
                         @{
                         @"서비스ID" : self.previousData[@"서비스ID"],
                         @"고객구분" : self.previousData[@"고객구분"],
                         @"플랜번호" : self.previousData[@"플랜번호"],
                         @"가입자번호" : self.previousData[@"가입자번호"],
                         @"제도구분" : self.previousData[@"제도구분"],
                         @"페이지인덱스" : self.previousData[@"페이지인덱스"],
                         @"전체조회건수" : self.previousData[@"전체조회건수"],
                         @"페이지패치건수" : self.previousData[@"페이지패치건수"],
                         @"예비필드" : self.previousData[@"예비필드"],
                         @"플랜번호_1" : self.previousData[@"플랜번호_1"],
                         @"가입자번호_1" : self.previousData[@"가입자번호_1"],
                         @"고객구분_1" : self.previousData[@"고객구분_1"],
                         @"email수신여부" : self.previousData[@"email수신여부"],
                         @"운용현황통보주기" : self.previousData[@"운용현황통보주기"],
                         @"운용현황" : self.previousData[@"운용현황"],
                         @"가입자교육자료" : self.previousData[@"가입자교육자료"],
                         @"펀드운용보고서" : self.previousData[@"펀드운용보고서"],
                         @"월간펀드리포트" : self.previousData[@"월간펀드리포트"],
                         @"신한경제브리프" : self.previousData[@"신한경제브리프"],
                         @"sms수신여부" : self.previousData[@"sms수신여부"],
                         @"운용수익률통보주기" : self.previousData[@"운용수익률통보주기"],
                         @"운용수익률" : self.previousData[@"운용수익률"],
                         @"부담금납부현황" : self.previousData[@"부담금납부현황"],
                         @"우편번호1" : self.previousData[@"우편번호1"],
                         @"우편번호2" : self.previousData[@"우편번호2"],
                         @"우편번호주소" : self.previousData[@"우편번호주소"],
                         @"상세주소" : self.previousData[@"상세주소"],
                         @"휴대전화번호_1" : self.previousData[@"휴대전화번호_1"],
                         @"휴대전화번호_2" : self.previousData[@"휴대전화번호_2"],
                         @"휴대전화번호_3" : self.previousData[@"휴대전화번호_3"],
                         @"email주소" : self.previousData[@"email주소"],
                         @"제도구분_1" : self.previousData[@"제도구분_1"],
                         @"전화번호_1" : self.previousData[@"전화번호_1"],
                         @"전화번호_2" : self.previousData[@"전화번호_2"],
                         @"전화번호_3" : self.previousData[@"전화번호_3"]
                         }] autorelease];
            
            aDataSet.serviceCode = PENSION_ES_NOTI_EDIT_AGREE_INFO_SUMMIT_E3949;
        }
            break;
            
            
            
        default:
        {
            
        }
            break;
    }
    
    [self requestDataSet:aDataSet];
}
@end
