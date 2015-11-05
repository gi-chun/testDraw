//
//  SHBAccountService.m
//  ShinhanBank
//
//  Created by 차주현 on 12. 10. 21.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBAccountService.h"

@implementation SHBAccountService
@synthesize accountInfoDic;

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = ACCOUNT_SERVICE_INFO;
        [SHBBankingService addServiceInfo: info];
	}
}

- (void) start
{
    switch (self.serviceId) {
        case FREQ_TRANSFER_LIST:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                         TASK_NAME_KEY : @"sfg.sphone.task.sbmini.SBMini",
                                                       TASK_ACTION_KEY : @"Sp_Select",
                                    @"고객번호" : AppInfo.customerNo,
                                    }];
            self.requestData = aDataSet;
        }
            break;
        case FREQ_TRANSFER_INSERT:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                         TASK_NAME_KEY : @"sfg.sphone.task.sbmini.SBMini",
                                                       TASK_ACTION_KEY : @"Sp_Insert",
                                    @"고객번호" : AppInfo.customerNo,
                                    @"입금계좌별명" : self.previousData[@"입금계좌별명"],
                                    @"출금계좌번호" : [self.previousData[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                    @"입금은행코드" : self.previousData[@"입금은행코드"],
                                    @"입금계좌번호" : [self.previousData[@"입금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                    @"입금자명" : self.previousData[@"입금자명"],
                                    @"이체금액" : [self.previousData[@"이체금액"] stringByReplacingOccurrencesOfString:@"," withString:@""],
                                    @"받는분통장메모" : self.previousData[@"받는분통장메모"],
                                    @"보내는분통장메모" : self.previousData[@"보내는분통장메모"],
                                    }];
            
            self.requestData = aDataSet;
        }
            break;
        case FREQ_TRANSFER_UPDATE:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                         TASK_NAME_KEY : @"sfg.sphone.task.sbmini.SBMini",
                                                       TASK_ACTION_KEY : @"Sp_Update",
                                    @"고객번호" : AppInfo.customerNo,
                                    @"입금계좌별명" : self.previousData[@"입금계좌별명"],
                                    @"출금계좌번호" : [self.previousData[@"출금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                    @"입금은행코드" : self.previousData[@"입금은행코드"],
                                    @"입금계좌번호" : [self.previousData[@"입금계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                    @"입금자명" : self.previousData[@"입금자명"],
                                    @"이체금액" : [self.previousData[@"이체금액"] stringByReplacingOccurrencesOfString:@"," withString:@""],
                                    @"받는분통장메모" : self.previousData[@"받는분통장메모"],
                                    @"보내는분통장메모" : self.previousData[@"보내는분통장메모"],
                                    @"KEY" : self.previousData[@"KEY"],
                                    }];
            self.requestData = aDataSet;
        }
            break;
        case FREQ_TRANSFER_DELETE:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                         TASK_NAME_KEY : @"sfg.sphone.task.sbmini.SBMini",
                                                       TASK_ACTION_KEY : @"Sp_Delete",
                                    @"고객번호" : AppInfo.customerNo,
                                    @"KEY" : self.previousData[@"KEY"],
                                    }];
            self.requestData = aDataSet;
        }
            break;
        case FREQ_MONEYMENTO_SELECT:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                         TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                                       TASK_ACTION_KEY : @"selectAssetCustId",
                                    @"고객번호" : AppInfo.customerNo,
                                    //@"주민번호" : [AppInfo getPersonalPK],
                                    @"주민번호" : (AppInfo.isLogin == LoginTypeNo) ? [AppInfo getPersonalPK] : @"",
                                    }];
            
            self.requestData = aDataSet;
        }
            break;
            
        case AUTO_TRANSFER_INSERT:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                    @"입금계좌번호" : self.previousData[@"입금계좌번호"],
                                    @"입금은행코드" : self.previousData[@"입금은행코드"],
                                    @"이체종류" : self.previousData[@"이체종류"],
                                    @"이체종료일자" : self.previousData[@"이체종료일자"],
                                    }];
            self.requestData = aDataSet;
        }
            break;
        case FREQ_TRANSFER_ITEM:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                          TASK_NAME_KEY : @"sfg.sphone.task.sbmini.SBMini",
                                                                          TASK_ACTION_KEY : @"selectSpIdx",
                                                                          
                                                                          @"SP_IDX" : self.previousData[@"KEY"],
                                                                          //@"SP_UPDT" : self.previousData[@"DATE"]
                                                                          }];
            self.requestData = aDataSet;
        }
            break;
        case ECHE_WIDGET_ITEM:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                          TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                                                          TASK_ACTION_KEY : @"insertSbankAcno",
                                                                          
                                                                          @"계좌번호" : self.previousData[@"KEY"],
                                                                          
                                                                          }];
            self.requestData = aDataSet;
        }
            break;
        case ECHE_WIDGET_QUERY:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                          TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                                                          TASK_ACTION_KEY : @"selectCusAcno",
                                                                          
                                                                          @"CUS_ACNO" : self.previousData[@"KEY"],
                                                                          
                                                                          }];
            self.requestData = aDataSet;
        }
            break;
        case SEARCH:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                          TASK_NAME_KEY : @"sfg.sphone.task.common.SearchService",
                                                                          TASK_ACTION_KEY : @"getSearch",
                                                                          
                                                                          @"SRC_WORD" : self.previousData[@"SRC_WORD"],
                                                                          @"OS_CD" : @"I"
                                                                          }];
            self.requestData = aDataSet;
        }
            break;
        case SEARCH_LINK_HISTORY:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                          TASK_NAME_KEY : @"sfg.sphone.task.common.SearchService",
                                                                          TASK_ACTION_KEY : @"setSearchLinkHistory",
                                                                          
                                                                          @"SRC_ID" : self.previousData[@"SRC_ID"],
                                                                          @"SRC_SEQ" : self.previousData[@"SRC_SEQ"]
                                                                          }];
            self.requestData = aDataSet;
        }
            break;
        case PRODUCT_MENUAL:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                          TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                                                          TASK_ACTION_KEY : @"selectPdDescList",
                                                                          
                                                                          @"상품코드" : self.previousData[@"상품코드"]
                                                                          }];
            self.requestData = aDataSet;
        }
            break;
            
        case SMART_ICHE_PUSH_YN:
        {
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:@{
                                                                          TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                                                          TASK_ACTION_KEY : @"selectSmIchePushYN",
                                                                          
                                                                          @"SEND_SEQ" : self.previousData[@"SEND_SEQ"]
                                                                          }];
            self.requestData = aDataSet;
        }
            break;
            
        default:
            break;
    }
    
    [self requestDataSet:(SHBDataSet *)self.requestData];
}

- (NSDictionary *)accountListInfo:(int)accountType
{
    NSMutableDictionary *dataDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    NSMutableArray *dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];

    switch (accountType) {
        case 0: // 예금신탁
        {
            dataDic[@"FooterInfo"] = @[@{@"Name" : @"예금신탁 총잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"예금총합계"]]}];
            
            for(NSDictionary *dic in [self.responseData arrayWithForKey:@"예금계좌"])
            {
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                @"계좌명" : ([dic[@"상품부기명"] length] > 0) ? dic[@"상품부기명"] : dic[@"과목명"],
                                                @"계좌번호" : ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? dic[@"계좌번호"] : dic[@"구계좌번호"],
                                                @"잔액" : [NSString stringWithFormat:@"%@원", dic[@"잔액"]],
                                                @"수익률" : @"",
                                                @"은행구분" : ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? @"1" : dic[@"은행코드"],
                                                @"계좌정보상세" : dic
                                                }];
                
                NSString *accountNumber = [dic[@"계좌번호"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                int accountCode = 999;
                
                if (accountNumber != nil)
                {
                    accountCode = [[accountNumber substringWithRange:NSMakeRange(0, 3)] intValue];
                }

                infoDic[@"거래구분"] = @"0";
                
                if((accountCode >= 100 && accountCode <= 149) || accountCode == 164)		//요구불
                {
                    infoDic[@"서비스코드"] = @"D1110";
                    infoDic[@"거래구분"] = @"1";
                }
                else if(accountCode >= 150 && accountCode <= 159)	//당좌
                {
                    infoDic[@"서비스코드"] = @"D1170";
                }
                else if(accountCode >= 200 && accountCode <= 208)	//고정성 - 정기예금
                {
                    if ([dic[@"상품부기명"] hasPrefix:@"Mint(민트) 정기예금"] || [dic[@"과목명"] hasPrefix:@"Mint(민트) 정기예금"])
                    {
                        infoDic[@"서비스코드"] = @"D1121";
                    }
                    else
                    {
                        infoDic[@"서비스코드"] = @"D1120";
                    }
                }
                else if(accountCode == 209)	//세이프지수연동예금
                {
                    infoDic[@"서비스코드"] = @"D1125";
                }
                else if(accountCode >= 210 && accountCode <= 214)	//고정성 - 양도성예금, 표지어음 환매체
                {
                    infoDic[@"서비스코드"] = @"D1150";
                }
                else if(accountCode >= 215 && accountCode <= 216)	//고정성 - 국공채, 금융체
                {
                    infoDic[@"서비스코드"] = @"D1160";
                }
                else if(accountCode == 220)	//고정성 - 주택청약부금
                {
                    infoDic[@"서비스코드"] = @"D1180";
                }
                else if(accountCode == 221 || accountCode == 223)	//고정성 - 정기적립식
                {
                    infoDic[@"서비스코드"] = @"D1185";
                }
                else if(accountCode >= 230 && accountCode <= 240)	//CMA계좌
                {
                    infoDic[@"서비스코드"] = @"D1130";
                }
                else if(accountCode >= 260 && accountCode <= 299)	//신탁
                {
                    if(accountCode >= 291 && accountCode <= 297 && accountCode != 294)	//재정신탁, (2013-03-08 정상교과장의 요청으로 295, 296, 297 추가)
                    {
                        infoDic[@"서비스코드"] = @"D1143";
                    }
                    else
                    {
                        infoDic[@"서비스코드"] = @"D1140";
                    }
                }
                else
                {
                    infoDic[@"서비스코드"] = @"";
                }
                
                // 조회기간 버튼 설정
                if([infoDic[@"서비스코드"] isEqualToString:@"D1110"] || [infoDic[@"서비스코드"] isEqualToString:@"D1170"])
                {
                    infoDic[@"조회기간1"] = @"1주일";
                    infoDic[@"조회기간2"] = @"1개월";
                }
                else
                {
                    infoDic[@"조회기간1"] = @"3개월";
                    infoDic[@"조회기간2"] = @"6개월";
                }

                if([dic[@"인터넷뱅킹출금계좌여부"] isEqualToString:@"1"] && [dic[@"계좌번호"] characterAtIndex:0] == '1')
                {
                    infoDic[@"화면이동1"] = @"조회";
                    infoDic[@"화면이동2"] = @"이체";
                    infoDic[@"화면이동3"] = @"이체결과조회";
                }
                else if([dic[@"예금종류"] characterAtIndex:0] != '1' && [dic[@"입금가능여부"] isEqualToString:@"1"] )
                {
                    if (accountCode == 299)
                    {
                        infoDic[@"화면이동1"] = @"조회";
                        infoDic[@"화면이동2"] = @"입금";
                        infoDic[@"화면이동3"] = @"출금";
                        
                        if(!([dic[@"상품부기명"] isEqualToString:@"마켓프리미엄신탁"] ||
                             [dic[@"상품부기명"] isEqualToString:@"마켓프리미엄신탁(개인용)"] ||
                             [dic[@"상품부기명"] isEqualToString:@"마켓프리미엄신탁-법인용(5등급)"] ||
                             [dic[@"상품부기명"] isEqualToString:@"마켓프리미엄신탁-개인용(5등급)"] ||
                             [dic[@"과목명"] isEqualToString:@"마켓프리미엄신탁"] ||
                             [dic[@"과목명"] isEqualToString:@"마켓프리미엄신탁(개인용)"] ||
                             [dic[@"과목명"] isEqualToString:@"마켓프리미엄신탁-법인용(5등급)"] ||
                             [dic[@"과목명"] isEqualToString:@"마켓프리미엄신탁-개인용(5등급)"]))
                        {
                            infoDic[@"화면이동3"] = @"";
                        }
                        
                        if(!([dic[@"예금종류"] isEqualToString:@"3"] && [dic[@"입금가능여부"] isEqualToString:@"1"]))
                        {
                            infoDic[@"화면이동2"] = @"출금";
                            infoDic[@"화면이동3"] = @"";
                        }
                    }
                    else if (accountCode == 260 || accountCode == 289 || (accountCode >= 291 && accountCode <= 294))
                    {
                        infoDic[@"화면이동1"] = @"";
                        infoDic[@"화면이동2"] = @"";
                        infoDic[@"화면이동3"] = @"";
                    }
                    else
                    {
                        infoDic[@"화면이동1"] = @"조회";
                        infoDic[@"화면이동2"] = @"입금";
                        infoDic[@"화면이동3"] = @"";
                    }
                }
                else if([dic[@"상품코드"] isEqualToString:@"110004601"])
                {
                    infoDic[@"화면이동1"] = @"조회";
                    infoDic[@"화면이동2"] = @"입금";
                    infoDic[@"화면이동3"] = @"";
                }
                else
                {
                    infoDic[@"화면이동1"] = @"";
                    infoDic[@"화면이동2"] = @"";
                    infoDic[@"화면이동3"] = @"";
                }
                
                [dataArray addObject:infoDic];
            }
            
            if([dataArray count] == 0){
                [dataArray addObject:@{
                 @"계좌명" : @"예금신탁 계좌가 없습니다.",
                 @"계좌번호" : @"",
                 @"잔액" : @"",
                 @"수익률" : @"",
                 @"서비스코드" : @"",
                 @"거래구분" : @"",
                 @"조회기간1" : @"",
                 @"조회기간2" : @"",
                 @"화면이동1" : @"",
                 @"화면이동2" : @"",
                 @"화면이동3" : @"",
                 @"은행구분" : @"",
                 @"계좌정보상세" : @""
                 }];
            }
        }
            break;
        case 1: // 펀드
        {
            dataDic[@"FooterInfo"] = @[
            @{@"Name" : @"납입원금 합계", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"수익증권납입총액"]]},
            @{@"Name" : @"평가금액 합계", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"펀드총잔액"]]},
            @{@"Name" : @"평균수익률", @"Value" : [NSString stringWithFormat:@"%@%%", self.responseData[@"납입원금총수익률"]]},
            @{@"Name" : @"(합계 및 수익률은 역외펀드 제외)", @"Value" : @""},
            ];

            for(NSDictionary *dic in [self.responseData arrayWithForKey:@"펀드계좌"])
            {
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                @"계좌번호" : ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? dic[@"계좌번호"] : dic[@"구계좌번호"],
                                                @"수익률" : ([dic[@"누적수익율"] isEqualToString:@"0.00"]) ? @"0%" : [NSString stringWithFormat:@"%@%%", dic[@"누적수익율"]],
                                                @"계좌정보상세" : dic
                                                }];
                
                if([dic[@"상품부기명"] length] > 0)
                {
                    if([dic[@"통화코드"] isEqualToString:@"KRW"])
                    {
                        infoDic[@"계좌명"] = dic[@"상품부기명"];
                    }
                    else
                    {
                        infoDic[@"계좌명"] = [NSString stringWithFormat:@"%@ 통화종류:(%@)", dic[@"상품부기명"], dic[@"통화코드"]];
                    }
                }
                else
                {
                    infoDic[@"계좌명"] = dic[@"과목명"];
                }

                if([dic[@"통화코드"] isEqualToString:@"KRW"])
                {
                    infoDic[@"잔액"] = [NSString stringWithFormat:@"평가금액(%@) : %@원", dic[@"통화코드"],dic[@"평가금액"]];
                }
                else
                {
                    infoDic[@"잔액"] = [NSString stringWithFormat:@"평가금액 : %@", dic[@"평가금액"]];
                }
                
                infoDic[@"화면이동1"] = @"조회";
                infoDic[@"화면이동2"] = @"입금";
                infoDic[@"화면이동3"] = @"출금";
                
                if([dic[@"계좌번호"] hasPrefix:@"252"] || [dic[@"계좌번호"] hasPrefix:@"254"])
                {
                    infoDic[@"화면이동3"] = @"선물환조회";
                }
                
                [dataArray addObject:infoDic];
            }

            if([dataArray count] == 0){
                [dataArray addObject:@{
                 @"계좌명" : @"펀드 계좌가 없습니다.",
                 @"계좌번호" : @"",
                 @"잔액" : @"",
                 @"수익률" : @"",
                 @"서비스코드" : @"",
                 @"거래구분" : @"",
                 @"조회기간1" : @"",
                 @"조회기간2" : @"",
                 @"화면이동1" : @"",
                 @"화면이동2" : @"",
                 @"화면이동3" : @"",
                 @"은행구분" : @"",
                 @"계좌정보상세" : @""
                 }];
            }
        }
            break;
        case 2: // 대출
        {
            dataDic[@"FooterInfo"] = @[@{@"Name" : @"대출 총잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"대출총금액"]]}];
            
            for(NSDictionary *dic in [self.responseData arrayWithForKey:@"대출계좌목록"])
            {
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                @"계좌명" : ([dic[@"대출상품명"] length] > 0) ? dic[@"대출상품명"] : dic[@"대출과목명"],
                                                @"계좌번호" : ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? dic[@"대출계좌번호"] : dic[@"구계좌번호"],
                                                @"잔액" : [NSString stringWithFormat:@"%@원", dic[@"대출잔액"]],
                                                @"수익률" : @"",
                                                @"계좌정보상세" : dic
                                                }];

                infoDic[@"화면이동1"] = @"조회";
                infoDic[@"화면이동2"] = @"이자납입";
                infoDic[@"화면이동3"] = @"";

                if([[dic[@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] > 299)
                {
                    infoDic[@"서비스코드"] = @"L1110";
                    
                    infoDic[@"화면이동3"] = @"상환";
                }
                else if([[dic[@"대출계좌번호"] substringWithRange:NSMakeRange(0, 3)] intValue] < 150)
                {
                    infoDic[@"서비스코드"] = @"L1120";
                    
                    infoDic[@"화면이동3"] = @"한도해지";
                }
                else
                {
                    infoDic[@"서비스코드"] = @"D1170";
                }
                
                [dataArray addObject:infoDic];
            }
            
            if([dataArray count] == 0){
                [dataArray addObject:@{
                 @"계좌명" : @"대출 계좌가 없습니다.",
                 @"계좌번호" : @"",
                 @"잔액" : @"",
                 @"수익률" : @"",
                 @"서비스코드" : @"",
                 @"거래구분" : @"",
                 @"조회기간1" : @"",
                 @"조회기간2" : @"",
                 @"화면이동1" : @"",
                 @"화면이동2" : @"",
                 @"화면이동3" : @"",
                 @"은행구분" : @"",
                 @"계좌정보상세" : @""
                 }];
            }
        }
            break;
        case 3: // 외화골드
        {
            NSMutableArray *foreignAccountNumberList = [NSMutableArray array];
            NSMutableArray *foreignAccountNumberList2 = [NSMutableArray array];
            
            for(NSMutableDictionary *dic in [self.responseData arrayWithForKey:@"외화계좌"])
            {
                // 외화골드와 동일
                if ([dic[@"인터넷뱅킹출금계좌여부"] isEqualToString:@"1"] && [dic[@"통화코드"] isEqualToString:@"USD"]) {
                    
                    if ([dic[@"계좌번호"] hasPrefix:@"180"] || [dic[@"계좌번호"] hasPrefix:@"181"]) {
                        if ([dic[@"상품부기명"] length] > 0) {
                            [dic setObject:dic[@"상품부기명"]
                                    forKey:@"1"];
                        }
                        else {
                            [dic setObject:dic[@"과목명"]
                                    forKey:@"1"];
                        }
                        
                        if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                            [dic setObject:dic[@"계좌번호"]
                                    forKey:@"2"];
                        }
                        else {
                            [dic setObject:dic[@"구계좌번호"]
                                    forKey:@"2"];
                        }
                        
                        if ([dic[@"계좌번호"] hasPrefix:@"186"] ||
                            [dic[@"계좌번호"] hasPrefix:@"187"] ||
                            [dic[@"계좌번호"] hasPrefix:@"188"]) {
                            [dic setObject:[NSString stringWithFormat:@"잔량:%@(g)", dic[@"외화잔액"]]
                                    forKey:@"3"];
                        }
                        else {
                            [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"외화잔액"], dic[@"통화코드"]]
                                    forKey:@"3"];
                        }
                        [foreignAccountNumberList addObject:dic];
                    }
                }
                if ([dic[@"입금가능여부"] isEqualToString:@"1"] && [dic[@"통화코드"] isEqualToString:@"USD"]) {
                    
                    if ([dic[@"계좌번호"] hasPrefix:@"180"] || [dic[@"계좌번호"] hasPrefix:@"181"]) {
                        
                        if ([dic[@"상품부기명"] length] > 0) {
                            [dic setObject:dic[@"상품부기명"]
                                    forKey:@"1"];
                        }
                        else {
                            [dic setObject:dic[@"과목명"]
                                    forKey:@"1"];
                        }
                        
                        if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                            [dic setObject:dic[@"계좌번호"]
                                    forKey:@"2"];
                        }
                        else {
                            [dic setObject:dic[@"구계좌번호"]
                                    forKey:@"2"];
                        }
                        
                        if ([dic[@"계좌번호"] hasPrefix:@"186"] ||
                            [dic[@"계좌번호"] hasPrefix:@"187"] ||
                            [dic[@"계좌번호"] hasPrefix:@"188"]) {
                            [dic setObject:[NSString stringWithFormat:@"잔량:%@(g)", dic[@"외화잔액"]]
                                    forKey:@"3"];
                        }
                        else {
                            [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"외화잔액"], dic[@"통화코드"]]
                                    forKey:@"3"];
                        }
                        [foreignAccountNumberList2 addObject:dic];
                    }
                }
                
                if ([dic[@"옵셋여부"] isEqualToString:@"1"]) {
                    if ([dic[@"상품부기명"] length] > 0) {
                        [dic setObject:[NSString stringWithFormat:@"%@(기본계좌)", dic[@"상품부기명"]]
                                forKey:@"_계좌이름"];
                    }
                    else {
                        [dic setObject:[NSString stringWithFormat:@"%@(기본계좌)", dic[@"과목명"]]
                                forKey:@"_계좌이름"];
                    }
                    
                    if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                        [dic setObject:dic[@"계좌번호"]
                                forKey:@"_계좌번호"];
                    }
                    else {
                        [dic setObject:dic[@"구계좌번호"]
                                forKey:@"_계좌번호"];
                    }
                    
                    if ([dic[@"계좌번호"] hasPrefix:@"186"] ||
                        [dic[@"계좌번호"] hasPrefix:@"187"] ||
                        [dic[@"계좌번호"] hasPrefix:@"188"]) {
                        [dic setObject:[NSString stringWithFormat:@"잔량:%@(g)", dic[@"외화잔액"]]
                                forKey:@"_통화잔액"];
                    }
                    else {
                        [dic setObject:@"-"
                                forKey:@"_통화잔액"];
                    }
                }
                else {
                    if ([dic[@"상품부기명"] length] > 0) {
                        [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"상품부기명"], dic[@"통화코드"]]
                                forKey:@"_계좌이름"];
                    }
                    else {
                        [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"과목명"], dic[@"통화코드"]]
                                forKey:@"_계좌이름"];
                    }
                    
                    if ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) {
                        [dic setObject:dic[@"계좌번호"]
                                forKey:@"_계좌번호"];
                    }
                    else {
                        [dic setObject:dic[@"구계좌번호"]
                                forKey:@"_계좌번호"];
                    }
                    
                    if ([dic[@"계좌번호"] hasPrefix:@"186"] ||
                        [dic[@"계좌번호"] hasPrefix:@"187"] ||
                        [dic[@"계좌번호"] hasPrefix:@"188"]) {
                        [dic setObject:[NSString stringWithFormat:@"잔량:%@(g)", dic[@"외화잔액"]]
                                forKey:@"_통화잔액"];
                    }
                    else {
                        [dic setObject:[NSString stringWithFormat:@"%@(%@)", dic[@"외화잔액"], dic[@"통화코드"]]
                                forKey:@"_통화잔액"];
                    }
                }
                
                NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                @"계좌번호" : ([dic[@"신계좌변환여부"] isEqualToString:@"1"]) ? dic[@"계좌번호"] : dic[@"구계좌번호"],
                                                @"수익률" : @"",
                                                @"계좌정보상세" : dic
                                                }];
                
                if ([dic[@"옵셋여부"] isEqualToString:@"1"]) {
                    infoDic[@"계좌명"] = [NSString stringWithFormat:@"%@(기본계좌)", ([dic[@"상품부기명"] length] > 0) ? dic[@"상품부기명"] : dic[@"과목명"]];
                    
                    if ([dic[@"계좌번호"] hasPrefix:@"186"] || [dic[@"계좌번호"] hasPrefix:@"187"] || [dic[@"계좌번호"] hasPrefix:@"188"]) {
                        infoDic[@"잔액"] = [NSString stringWithFormat:@"잔량:%@(g)", dic[@"외화잔액"]];
                    }
                    else {
                        infoDic[@"잔액"] = @"-";
                    }
                }
                else {
                    infoDic[@"계좌명"] = [NSString stringWithFormat:@"%@(%@)", ([dic[@"상품부기명"] length] > 0) ? dic[@"상품부기명"] : dic[@"과목명"], dic[@"통화코드"]];
                    
                    if ([dic[@"계좌번호"] hasPrefix:@"186"] || [dic[@"계좌번호"] hasPrefix:@"187"] || [dic[@"계좌번호"] hasPrefix:@"188"]) {
                        infoDic[@"잔액"] = [NSString stringWithFormat:@"잔량:%@(g)", dic[@"외화잔액"]];
                    }
                    else {
                        infoDic[@"잔액"] = [NSString stringWithFormat:@"%@(%@)", dic[@"외화잔액"], dic[@"통화코드"]];
                    }
                }
                
                infoDic[@"화면이동1"] = @"조회";
                infoDic[@"화면이동2"] = @"입금";
                infoDic[@"화면이동3"] = @"출금";
                
                [dataArray addObject:infoDic];
            }
            
            dataDic[@"외환출금계좌리스트"] = (NSArray *)foreignAccountNumberList;
            dataDic[@"외환입금계좌리스트"] = (NSArray *)foreignAccountNumberList2;
            
            if([dataArray count] == 0){
                [dataArray addObject:@{
                 @"계좌명" : @"외화골드 계좌가 없습니다.",
                 @"계좌번호" : @"",
                 @"잔액" : @"",
                 @"수익률" : @"",
                 @"서비스코드" : @"",
                 @"거래구분" : @"",
                 @"조회기간1" : @"",
                 @"조회기간2" : @"",
                 @"화면이동1" : @"",
                 @"화면이동2" : @"",
                 @"화면이동3" : @"",
                 @"은행구분" : @"",
                 @"계좌정보상세" : @""
                 }];
            }
        }
            break;
        case 4: // 방카슈랑스
        {
            for(NSDictionary *dic in [self.responseData arrayWithForKey:@"가입내역"])
            {
                if (![dic[@"계좌감추기여부"] isEqualToString:@"1"]) {
                    NSMutableDictionary *infoDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                    @"증권번호" : dic[@"증권번호"],
                                                    @"상품명" : dic[@"상품명"],
                                                    @"제휴보험사코드" : dic[@"제휴보험사코드"],
                                                    @"제휴보험사명" : dic[@"제휴보험사명"],
                                                    @"상품코드" : dic[@"상품코드"],
                                                    @"계약일자" : dic[@"계약일자"],
                                                    @"보험구분" : dic[@"보험구분"],
                                                    @"만기일자" : dic[@"만기일자"],
                                                    @"합계보험료" : dic[@"합계보험료"],
                                                    @"계약상태" : dic[@"계약상태"],
                                                    @"상품통화코드" : dic[@"상품통화코드"],
                                                    @"계좌감추기여부" : dic[@"계좌감추기여부"],
                                                    @"관리점번호" : dic[@"관리점번호"],
                                                    @"관리점명" : dic[@"관리점명"]
                                                    }];

                    infoDic[@"화면이동1"] = @"조회";
                    infoDic[@"화면이동2"] = @"입금내역";
    //                infoDic[@"화면이동3"] = @"출금";

                    [dataArray addObject:infoDic];
                }
            }
            
            if([dataArray count] == 0){
                [dataArray addObject:@{
                 @"계좌명" : @"방카슈랑스 계좌가 없습니다.",
                 @"계좌번호" : @"",
                 @"잔액" : @"",
                 @"수익률" : @"",
                 @"서비스코드" : @"",
                 @"거래구분" : @"",
                 @"조회기간1" : @"",
                 @"조회기간2" : @"",
                 @"화면이동1" : @"",
                 @"화면이동2" : @"",
                 @"화면이동3" : @"",
                 @"은행구분" : @"",
                 @"계좌정보상세" : @""
                 }];
            }
        }
            break;

        default:
            break;
    }
    
    dataDic[@"계좌리스트"] = dataArray;
    
    return (NSDictionary *)dataDic;
}

- (NSArray *)accountInqueryListInfo
{
    NSMutableArray *dataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    NSArray *list = [self.responseData arrayWithForKey:[self.strServiceCode isEqualToString:@"D1121"] ? @"Mint거래내역" : @"거래내역"];

    int curServiceCode = [[self.strServiceCode substringFromIndex:1] intValue];

    if([list count] == 1 && [list[0][@"내용"] isEqualToString:@"***거래내역 없음***"])
    {
        return (NSArray *)dataArray;
    }
    
    for(NSDictionary *dic in list)
    {
        NSMutableDictionary *infoDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
        
        if (curServiceCode == 1121)
        {
            infoDic[@"거래일자"] = [NSString stringWithFormat:@"%@ %@ %@", dic[@"거래일자"], dic[@"수신거래구분"], [dic[@"정정취소구분"] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"정정취소구분 %@", dic[@"정정취소구분"]]];
            infoDic[@"잔액"] = [NSString stringWithFormat:@"%@원", dic[@"거래후잔액"]];
        }
        else
        {
            infoDic[@"거래일자"] = [NSString stringWithFormat:@"%@ %@", dic[@"거래일자"],  dic[@"시간"] != nil ? dic[@"시간"] : dic[@"거래시간"]];
            infoDic[@"잔액"] = [NSString stringWithFormat:@"%@원", dic[@"잔액"]];
        }
        
        if(curServiceCode != 1121 && curServiceCode != 1140 && curServiceCode != 1143)
        {
            NSString *tmp = dic[@"입지구분"];
            
            if(tmp == nil || [tmp isEqualToString:@""])
            {
                tmp = [dic[@"입금"] isEqualToString:@"0"] ? @"2" : @"1";
            }
            
            if([tmp isEqualToString:@"1"])
            {
                infoDic[@"구분"] = @"입금";
                infoDic[@"금액"] = [NSString stringWithFormat:@"%@원", dic[@"입금"]];
            }
            else if([tmp isEqualToString:@"2"])
            {
                if([dic[@"출금"] isEqualToString:@"0"])
                {
                    infoDic[@"구분"] = @"";
                    infoDic[@"금액"] = @"";
                }
                else
                {
                    infoDic[@"구분"] = @"출금";
                    infoDic[@"금액"] = [NSString stringWithFormat:@"%@원", dic[@"출금"]];
                }
            }
            else
            {
                infoDic[@"구분"] = @"";
                infoDic[@"금액"] = @"";
            }
        }
        
        switch (curServiceCode) {
            case 1110:
            case 1170:
            {
                infoDic[@"적요"] = dic[@"적요"];
                infoDic[@"내용"] = dic[@"내용"];
            }
                break;
            case 1120:
            {
                infoDic[@"세후이자"] = [dic[@"세후이자"] isEqualToString:@"0"] ? @"" : dic[@"세후이자"];
                break;
            }
            case 1125:
                infoDic[@"세후이자"] = [dic[@"세후이자"] isEqualToString:@"0"] ? @"" : dic[@"세후이자"]; //세이프지수
                break;
            case 1150:
            case 1160:
            case 1180:
            {
                infoDic[@"적요"] = dic[@"적요"];
            }
                break;
            case 1121:
            {
                infoDic[@"회차"] = [NSString stringWithFormat:@"%@회차 거래금액", dic[@"입금회차"]];
                infoDic[@"거래금액"] = dic[@"거래금액"];
                infoDic[@"세전지급이자"] = [dic[@"세전지급이자"] isEqualToString:@"0"] ? @"" : dic[@"세전지급이자"];
                infoDic[@"적용이율"] = dic[@"회차적용이율"];
            }
                break;
            case 1130:
            {
                infoDic[@"적요"] = dic[@"적요"];
                infoDic[@"내용"] = dic[@"내용"];
                
                NSString *accountName = accountInfoDic[@"계좌명"];
                
                if ([accountName rangeOfString:@"신한 월복리 적금"].location != NSNotFound ||
                    [accountName rangeOfString:@"S-MORE SHOW적금"].location != NSNotFound ||
                    [accountName rangeOfString:@"생활의 지혜 적금"].location != NSNotFound ||
                    [accountName rangeOfString:@"Mint(민트) 적금"].location != NSNotFound||
                    [accountName rangeOfString:@"MINT(민트) 적금"].location != NSNotFound ||
                    [accountName rangeOfString:@"신한 저축습관만들기"].location != NSNotFound)
                {
                    infoDic[@"회차별우대금리"] = [dic[@"회차별가산이율"] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%@%%", dic[@"회차별가산이율"]];
                }
            }
                break;
            case 1140:
            case 1143:
            {
                infoDic[@"거래구분"] = dic[@"업무구분"];
                infoDic[@"거래금액"] = [NSString stringWithFormat:@"%@원", dic[@"거래금액"]];
                infoDic[@"내용"] = dic[@"적요"];
            }
                break;
            case 1185:
            {
                infoDic[@"적요"] = dic[@"적요"];
                infoDic[@"내용"] = dic[@"내용"];
            }
                break;
            default:
                break;
        }
        
        [dataArray addObject:infoDic];
    }
    
    return (NSArray *)dataArray;
}

// 전체계좌 리스트
- (NSArray *)accountAllListInfo
{
    return @[[self accountListInfo:0], [self accountListInfo:1], [self accountListInfo:2], [self accountListInfo:4], [self accountListInfo:5]];
}

- (NSArray *)initAccountInfo
{
    NSArray *infoList = nil;
    
    int curServiceCode = [[self.strServiceCode substringFromIndex:1] intValue];
    
    switch (curServiceCode) {
        case 1110:
        case 1170:
        {
            infoList = @[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", accountInfoDic[@"잔액"] != nil ? accountInfoDic[@"잔액"] : @"0"]},
            @{@"Name" : @"출금가능잔액", @"Value" : [NSString stringWithFormat:@"%@원", accountInfoDic[@"지불가능액"] != nil ? accountInfoDic[@"지불가능액"] : @"0"]}
            ];
        }
            break;
        case 1120:
        {
            if([accountInfoDic[@"상품부기명"] hasPrefix:@"Mint(민트) 정기예금"] || [accountInfoDic[@"과목명"] hasPrefix:@"Mint(민트) 정기예금"])
            {
                infoList = @[
                @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", accountInfoDic[@"잔액"] != nil ? accountInfoDic[@"잔액"] : @"0"]},
                @{@"Name" : @"적용이율", @"Value" : @"(입금회차별 금리 참조)"},
                @{@"Name" : @"신규일자", @"Value" : accountInfoDic[@"신규일자"] != nil ? accountInfoDic[@"신규일자"] : @""},
                @{@"Name" : @"만기일자", @"Value" : accountInfoDic[@"만기일자"] != nil ? accountInfoDic[@"만기일자"] : @""},
                @{@"Name" : @"고객명", @"Value" : accountInfoDic[@"고객명"] != nil ? accountInfoDic[@"고객명"] : @""},
                ];
            }
            else
            {
                infoList = @[
                @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", accountInfoDic[@"잔액"] != nil ? accountInfoDic[@"잔액"] : @"0"]},
                @{@"Name" : @"적용이율", @"Value" : @""},
                @{@"Name" : @"신규일자", @"Value" : accountInfoDic[@"신규일자"] != nil ? accountInfoDic[@"신규일자"] : @""},
                @{@"Name" : @"만기일자", @"Value" : accountInfoDic[@"만기일자"] != nil ? accountInfoDic[@"만기일자"] : @""},
                @{@"Name" : @"고객명", @"Value" : accountInfoDic[@"고객명"] != nil ? accountInfoDic[@"고객명"] : @""},
                ];
            }
        }
            break;
        case 1130:
        {
            infoList = @[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", accountInfoDic[@"잔액"] != nil ? accountInfoDic[@"잔액"] : @"0"]},
            @{@"Name" : @"적용이율", @"Value" : @""},
            @{@"Name" : @"신규일자", @"Value" : accountInfoDic[@"신규일자"] != nil ? accountInfoDic[@"신규일자"] : @""},
            @{@"Name" : @"만기일자", @"Value" : accountInfoDic[@"만기일자"] != nil ? accountInfoDic[@"만기일자"] : @""},
            @{@"Name" : @"입금방법", @"Value" : @""},
            @{@"Name" : @"입금회차", @"Value" : @""}
            ];
        }
            break;
        case 1140:
        {
            infoList = @[
            @{@"Name" : @"현재잔액", @"Value" : [NSString stringWithFormat:@"%@원", accountInfoDic[@"잔액"] != nil ? accountInfoDic[@"잔액"] : @"0"]},
            @{@"Name" : @"현재적용이율", @"Value" : @""},
            @{@"Name" : @"신규일자", @"Value" : accountInfoDic[@"신규일자"] != nil ? accountInfoDic[@"신규일자"] : @""},
            @{@"Name" : @"만기일자", @"Value" : accountInfoDic[@"만기일자"] != nil ? accountInfoDic[@"만기일자"] : @""},
            @{@"Name" : @"입금방법", @"Value" : @""}
            
            ];
        }
            break;
        case 1143:
        {
            infoList = @[
            @{@"Name" : @"현재잔액", @"Value" : [NSString stringWithFormat:@"%@원", accountInfoDic[@"잔액"] != nil ? accountInfoDic[@"잔액"] : @"0"]},
            @{@"Name" : @"신규일자", @"Value" : accountInfoDic[@"신규일자"] != nil ? accountInfoDic[@"신규일자"] : @""},
            @{@"Name" : @"만기일자", @"Value" : accountInfoDic[@"만기일자"] != nil ? accountInfoDic[@"만기일자"] : @""},
            @{@"Name" : @"고객명", @"Value" : accountInfoDic[@"고객명"] != nil ? accountInfoDic[@"고객명"] : @""},
            ];
        }
            break;
        case 1150:
        {
            infoList = @[
            @{@"Name" : @"계약금액", @"Value" : @"0원"},
            @{@"Name" : @"적용이율", @"Value" : @""},
            @{@"Name" : @"신규일자", @"Value" : accountInfoDic[@"신규일자"] != nil ? accountInfoDic[@"신규일자"] : @""},
            @{@"Name" : @"만기일자", @"Value" : accountInfoDic[@"만기일자"] != nil ? accountInfoDic[@"만기일자"] : @""},
            @{@"Name" : @"수납금액", @"Value" : @"0원"},
            @{@"Name" : @"이자지급방식", @"Value" : @""}
            ];
        }
            break;
        case 1160:
        {
            infoList = @[
            @{@"Name" : @"액면금액", @"Value" : @"0원"},
            @{@"Name" : @"매출금액", @"Value" : @"0원"},
            @{@"Name" : @"적용이율", @"Value" : @""},
            @{@"Name" : @"신규일자", @"Value" : accountInfoDic[@"신규일자"] != nil ? accountInfoDic[@"신규일자"] : @""},
            @{@"Name" : @"만기일자", @"Value" : accountInfoDic[@"만기일자"] != nil ? accountInfoDic[@"만기일자"] : @""},
            @{@"Name" : @"이자지급방식", @"Value" : @""}
            ];
        }
            break;
        case 1180:
        {
            infoList = @[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", accountInfoDic[@"잔액"] != nil ? accountInfoDic[@"잔액"] : @"0"]},
            @{@"Name" : @"적용이율", @"Value" : @""},
            @{@"Name" : @"신규일자", @"Value" : accountInfoDic[@"신규일자"] != nil ? accountInfoDic[@"신규일자"] : @""},
            @{@"Name" : @"만기일자", @"Value" : accountInfoDic[@"만기일자"] != nil ? accountInfoDic[@"만기일자"] : @""},
            @{@"Name" : @"이자지급방식", @"Value" : @""},
            @{@"Name" : @"이자입금계좌번호", @"Value" : @""},
            @{@"Name" : @"과세적용방식", @"Value" : @""}
            ];
        }
            break;
        case 1185:
        {
            infoList = @[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", accountInfoDic[@"잔액"] != nil ? accountInfoDic[@"잔액"] : @"0"]},
            @{@"Name" : @"적용이율", @"Value" : @""},
            @{@"Name" : @"신규일자", @"Value" : accountInfoDic[@"신규일자"] != nil ? accountInfoDic[@"신규일자"] : @""},
            @{@"Name" : @"만기일자", @"Value" : accountInfoDic[@"만기일자"] != nil ? accountInfoDic[@"만기일자"] : @""},
            @{@"Name" : @"자동이체 출금계좌", @"Value" : @""},
            @{@"Name" : @"과세적용방식", @"Value" : @""}
            ];
        }
            break;
            
        default:
            break;
    }
    
    return infoList;
}

- (NSArray *)accountDefaultInfo
{
    NSMutableArray *infoList = nil;

    int curServiceCode = [[self.strServiceCode substringFromIndex:1] intValue];
    
    switch (curServiceCode) {
        case 1110:
        case 1170:
        {
            infoList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액"]]},
            @{@"Name" : @"출금가능잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"출금가능금액"]]}
            ]];
        }
            break;
        case 1120:
        {
            if([accountInfoDic[@"상품부기명"] hasPrefix:@"Mint(민트) 정기예금"] || [accountInfoDic[@"과목명"] hasPrefix:@"Mint(민트) 정기예금" ])
            {
                infoList = [NSMutableArray arrayWithArray:@[
                @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
                @{@"Name" : @"적용이율", @"Value" : @"(입금회차별 금리 참조)"},
                @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
                @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
                @{@"Name" : @"고객명", @"Value" : self.responseData[@"고객명"] != nil ? self.responseData[@"고객명"] : @""},
                ]];
                
                if(self.responseData[@"과세적용내용"] != nil && ![self.responseData[@"과세적용내용"] isEqualToString:@""])
                {
                    [infoList addObject:@{@"Name" : @"과세적용방식", @"Value" : self.responseData[@"과세적용내용"]}];
                }

            }
            else
            {
                infoList = [NSMutableArray arrayWithArray:@[
                @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
                @{@"Name" : @"적용이율", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
                @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
                @{@"Name" : @"만기일자",@"Value" : self.responseData[@"만기일자"]},
                @{@"Name" : @"고객명", @"Value" : self.responseData[@"고객명"] != nil ? self.responseData[@"고객명"] : @""},
                ]];
                
                if(self.responseData[@"과세적용내용"] != nil && ![self.responseData[@"과세적용내용"] isEqualToString:@""])
                {
                    [infoList addObject:@{@"Name" : @"과세적용방식", @"Value" : self.responseData[@"과세적용내용"]}];
                }
                
            }
        }
            break;
        case 1130:
        {
            infoList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
            @{@"Name" : @"적용이율", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"입금방법", @"Value" : (self.responseData[@"적금납입방법"] != nil) ? self.responseData[@"적금납입방법"] : @""},
            @{@"Name" : @"입금회차", @"Value" : (self.responseData[@"납입횟수"] != nil) ? self.responseData[@"납입횟수"] : @""}
            ]];
            
            if(self.responseData[@"과세적용내용"] != nil && ![self.responseData[@"과세적용내용"] isEqualToString:@""]) // 4.28일 추가 (예. s힐링적금)
            {
                [infoList addObject:@{@"Name" : @"과세적용방식", @"Value" : self.responseData[@"과세적용내용"]}];
            }
        }
            break;
        case 1140:
        {
            infoList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"현재잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
            @{@"Name" : @"현재적용이율", @"Value" : self.responseData[@"이율"]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"입금방법", @"Value" : (self.responseData[@"적금납입방법"] != nil) ? self.responseData[@"적금납입방법"] : @""},
            
            ]];

            
        }
            break;
        case 1143:
        {
            infoList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"현재잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액"]]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일"]},
            @{@"Name" : @"고객명", @"Value" : self.responseData[@"성명"]},
            ]];
        }
            break;
        case 1150:
        {
            infoList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"계약금액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"액면금액"]]},
            @{@"Name" : @"적용이율", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"수납금액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"수납금액"]]},
            @{@"Name" : @"이자지급방식", @"Value" : self.responseData[@"이자지급방식"]}
            ]];
        }
            break;
        case 1160:
        {
            infoList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"액면금액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"액면금액"]]},
            @{@"Name" : @"매출금액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"수납금액"]]},
            @{@"Name" : @"적용이율", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"이자지급방식", @"Value" : self.responseData[@"이자지급방식"]}
            ]];
        }
            break;
        case 1180:
        {
            infoList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
            @{@"Name" : @"적용이율", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"이자지급방식", @"Value" : self.responseData[@"이자지급방식"]},
            @{@"Name" : @"이자입금계좌번호", @"Value" : [self.responseData[@"이자입금구계좌사용"] isEqualToString:@"1"] ? self.responseData[@"이자입금구계좌번호"] : self.responseData[@"이자입금계좌번호"]},
            ]];
            
            if(self.responseData[@"과세적용내용"] != nil && ![self.responseData[@"과세적용내용"] isEqualToString:@""])
            {
                [infoList addObject:@{@"Name" : @"과세적용방식", @"Value" : self.responseData[@"과세적용내용"]}];
            }
        }
            break;
        case 1185:
        {
            infoList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
            @{@"Name" : @"적용이율", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"자동이체 출금계좌", @"Value" : [self.responseData[@"자동이체구계좌사용"] isEqualToString:@"1"] ? self.responseData[@"자동이체구계좌번호"] : self.responseData[@"자동이체계좌번호"]},
            ]];
            
            if(self.responseData[@"과세적용내용"] != nil && ![self.responseData[@"과세적용내용"] isEqualToString:@""])
            {
                [infoList addObject:@{@"Name" : @"과세적용방식", @"Value" : self.responseData[@"과세적용내용"]}];
            }
        }
            break;
            
        default:
            break;
    }
    
    return (NSArray *)infoList;
}

- (NSArray *)accountDetailInfo
{
    NSMutableArray *infoDetailList = nil;
    
    int curServiceCode = [[self.strServiceCode substringFromIndex:1] intValue];
    
    switch (curServiceCode) {
        case 1110:
        case 1170:
        {
            infoDetailList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액"]]},
            @{@"Name" : @"출금가능잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"출금가능금액"]]},
            @{@"Name" : @"고객명", @"Value" : self.responseData[@"고객명"]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"최종거래일", @"Value" : self.responseData[@"최종거래일"]},
            @{@"Name" : @"수표/어음금액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"수표금액"]]}
            ]];

            if(self.responseData[@"대출승인액"] != nil && ![self.responseData[@"대출승인액"] isEqualToString:@"0"])
            {
                [infoDetailList addObject:@{@"Name" : @"대출승인액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"대출승인액"]]}];
            }
            if(self.responseData[@"대출이율"] != nil && ![self.responseData[@"대출이율"] isEqualToString:@"0"])
            {
                [infoDetailList addObject:@{@"Name" : @"대출이율", @"Value" : [NSString stringWithFormat:@"%@%%", self.responseData[@"대출이율"]]}];
            }
            
            if(self.responseData[@"증권사명FNA"] != nil && ![self.responseData[@"증권사명FNA"] isEqualToString:@""])
            {
                [infoDetailList addObject:@{@"Name" : @"FNA증권사", @"Value" : self.responseData[@"증권사명FNA"]}];
                [infoDetailList addObject:@{@"Name" : @"FNA증권계좌번호", @"Value" : self.responseData[@"증권사계좌번호FNA"]}];
            }
            
            if(curServiceCode == 1110 && self.responseData[@"대출만기일"] != nil && ![self.responseData[@"대출만기일"] isEqualToString:@""])
            {
                [infoDetailList addObject:@{@"Name" : @"대출만기일", @"Value" : self.responseData[@"대출만기일"]}];
            }
            
            if(self.responseData[@"수익증권매입금액"] != nil && ![self.responseData[@"수익증권매입금액"] isEqualToString:@""])
            {
                [infoDetailList addObject:@{@"Name" : @"수익증권매입금액", @"Value" : self.responseData[@"수익증권매입금액"]}];
            }
        }
            break;
        case 1120:
        {
            if([accountInfoDic[@"상품부기명"] hasPrefix:@"Mint(민트) 정기예금"] || [accountInfoDic[@"과목명"] hasPrefix:@"Mint(민트) 정기예금" ])
            {
                infoDetailList = [NSMutableArray arrayWithArray:@[
                @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
                @{@"Name" : @"적용이율", @"Value" : @"(입금회차별 금리 참조)"},
                @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
                @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
                @{@"Name" : @"고객명", @"Value" : self.responseData[@"고객명"]},
                ]];

                if(self.responseData[@"과세적용내용"] != nil && ![self.responseData[@"과세적용내용"] isEqualToString:@""])
                {
                    [infoDetailList addObject:@{@"Name" : @"과세적용방식", @"Value" : self.responseData[@"과세적용내용"]}];
                }
                
//                if(self.responseData[@"적금납입방법"] != nil && ![self.responseData[@"적금납입방법"] isEqualToString:@""])
//                {
//                    [infoDetailList addObject:@{@"Name" : @"입금방법", @"Value" : self.responseData[@"적금납입방법"]}];
//                }
            }
            else
            {
                infoDetailList = [NSMutableArray arrayWithArray:@[
                @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
                @{@"Name" : @"적용이율", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
                @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
                @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
                @{@"Name" : @"고객명", @"Value" : self.responseData[@"고객명"]},
                ]];
                
                if(self.responseData[@"과세적용내용"] != nil && ![self.responseData[@"과세적용내용"] isEqualToString:@""])
                {
                    [infoDetailList addObject:@{@"Name" : @"과세적용방식", @"Value" : self.responseData[@"과세적용내용"]}];
                }
            }
        }
            break;
        case 1130:
        {
            NSLog(@"%@", [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]);
            
            infoDetailList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
            @{@"Name" : @"적용이율", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"입금방법", @"Value" : (self.responseData[@"적금납입방법"] != nil) ? self.responseData[@"적금납입방법"] : @""},
            @{@"Name" : @"입금회차", @"Value" : (self.responseData[@"납입횟수"] != nil) ? self.responseData[@"납입횟수"] : @""},
            @{@"Name" : @"고객명", @"Value" : self.responseData[@"고객명"]},
            @{@"Name" : @"자동이체계좌", @"Value" : (self.responseData[@"자동이체계좌번호"] != nil) ? self.responseData[@"자동이체계좌번호"] : @""}
            ]];
            
            if(self.responseData[@"과세적용내용"] != nil && ![self.responseData[@"과세적용내용"] isEqualToString:@""])
            {
                [infoDetailList addObject:@{@"Name" : @"과세적용방식", @"Value" : self.responseData[@"과세적용내용"]}];
            }
        }
            break;
        case 1140:
        {
            infoDetailList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"현재잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
            @{@"Name" : @"현재적용이율", @"Value" : self.responseData[@"이율"]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"입금방법", @"Value" : (self.responseData[@"적금납입방법"] != nil) ? self.responseData[@"적금납입방법"] : @""},
            @{@"Name" : @"고객명", @"Value" : self.responseData[@"고객명"]},
            @{@"Name" : @"자동이체계좌", @"Value" : (self.responseData[@"자동이체계좌번호"] != nil) ? self.responseData[@"자동이체계좌번호"] : @""},
            
             @{@"Name" : @"특기사항", @"Value" : self.responseData[@"세금우대종류"] != nil ? self.responseData[@"세금우대종류"] : @""},
            ]];
            
            
            if(self.responseData[@"과세적용내용"] != nil && ![self.responseData[@"과세적용내용"] isEqualToString:@""])
            {
                [infoDetailList addObject:@{@"Name" : @"과세적용방식", @"Value" : self.responseData[@"과세적용내용"]}];
            }
            
           
        }
            break;
        case 1143:
        {
            infoDetailList = [NSMutableArray arrayWithArray:@[
                              @{@"Name" : @"현재잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액"]]},
                              @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일"]},
                              @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일"]},
                              @{@"Name" : @"고객명", @"Value" : self.responseData[@"성명"]},
                              ]];
        }
            break;
        case 1150:
        {
            infoDetailList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"계약금액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"액면금액"]]},
            @{@"Name" : @"적용이율", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"수납금액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"수납금액"]]},
            @{@"Name" : @"이자지급방식", @"Value" : self.responseData[@"이자지급방식"]},
            @{@"Name" : @"고객명", @"Value" : self.responseData[@"고객명"]},
            ]];
            
            if(self.responseData[@"과세적용내용"] != nil && ![self.responseData[@"과세적용내용"] isEqualToString:@""])
            {
                [infoDetailList addObject:@{@"Name" : @"과세적용방식", @"Value" : self.responseData[@"과세적용내용"]}];
            }
        }
            break;
        case 1160:
        {
            infoDetailList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"액면금액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"액면금액"]]},
            @{@"Name" : @"매출금액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"수납금액"]]},
            @{@"Name" : @"적용이율", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"이자지급방식", @"Value" : self.responseData[@"이자지급방식"]},
            @{@"Name" : @"고객명", @"Value" : self.responseData[@"고객명"]},
            @{@"Name" : @"만기상환액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"만기지급금액"]]},
            ]];
            
            if(self.responseData[@"과세적용내용"] != nil && ![self.responseData[@"과세적용내용"] isEqualToString:@""])
            {
                [infoDetailList addObject:@{@"Name" : @"과세적용방식", @"Value" : self.responseData[@"과세적용내용"]}];
            }
        }
            break;
        case 1180:
        {
            infoDetailList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
            @{@"Name" : @"적용이율", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"이자지급방식", @"Value" : self.responseData[@"이자지급방식"]},
            @{@"Name" : @"이자입금계좌번호", @"Value" : [self.responseData[@"이자입금구계좌사용"] isEqualToString:@"1"] ? self.responseData[@"이자입금구계좌번호"] : self.responseData[@"이자입금계좌번호"]},
            @{@"Name" : @"과세적용방식", @"Value" : (self.responseData[@"과세적용내용"] != nil) ? self.responseData[@"과세적용내용"] : @""},
            @{@"Name" : @"고객명", @"Value" : self.responseData[@"고객명"]},
            @{@"Name" : @"청약지역명", @"Value" : self.responseData[@"청약지역명"]},
            @{@"Name" : @"청약전용면적", @"Value" : self.responseData[@"청약평형"]},
            @{@"Name" : @"변경전 전용면적", @"Value" : self.responseData[@"변경전평형"]},
            @{@"Name" : @"현재순위", @"Value" : self.responseData[@"현재순위"]},
            @{@"Name" : @"순위기산일자", @"Value" : self.responseData[@"순위기산일자"]},
            @{@"Name" : @"전용면적 변경일자", @"Value" : self.responseData[@"평형변경일자"]},
            @{@"Name" : @"차기전용면적 변경일자", @"Value" : self.responseData[@"차기평형변경일자"]},
            @{@"Name" : @"1순위발생일자", @"Value" : self.responseData[@"일순위발생일자"]},
            @{@"Name" : @"2순위발생일자", @"Value" : self.responseData[@"이순위발생일자"]}
            ]];
        }
            break;
        case 1185:
        {
            infoDetailList = [NSMutableArray arrayWithArray:@[
            @{@"Name" : @"계좌잔액", @"Value" : [NSString stringWithFormat:@"%@원", self.responseData[@"계좌잔액금액"]]},
            @{@"Name" : @"적용이율(가입기간별 변동금리)", @"Value" : [NSString stringWithFormat:@"%@%%(%@)", self.responseData[@"이율"], self.responseData[@"금리유형"]]},
            @{@"Name" : @"신규일자", @"Value" : self.responseData[@"신규일자"]},
            @{@"Name" : @"만기일자", @"Value" : self.responseData[@"만기일자"]},
            @{@"Name" : @"자동이체 출금계좌", @"Value" : [self.responseData[@"자동이체구계좌사용"] isEqualToString:@"1"] ? self.responseData[@"자동이체구계좌번호"] : self.responseData[@"자동이체계좌번호"]},
            @{@"Name" : @"과세적용방식", @"Value" : (self.responseData[@"과세적용내용"] != nil) ? self.responseData[@"과세적용내용"] : @""},
            @{@"Name" : @"고객명", @"Value" : self.responseData[@"고객명"]},
            @{@"Name" : @"청약지역명", @"Value" : self.responseData[@"청약지역명"]},
            @{@"Name" : @"주택형(규모)", @"Value" : self.responseData[@"청약평형"]},
            @{@"Name" : @"민영주택 순위발생일(1순위)", @"Value" : self.responseData[@"일순위발생일자"]},
            @{@"Name" : @"민영주택 순위발생일(2순위)", @"Value" : self.responseData[@"이순위발생일자"]},
            @{@"Name" : @"공공주택 순위발생일(1순위)", @"Value" : self.responseData[@"국민일순위발생일자"]},
            @{@"Name" : @"공공주택 순위발생일(2순위)", @"Value" : self.responseData[@"국민이순위발생일자"]},
            @{@"Name" : @"변경전 주택형(규모)", @"Value" : @""},  // 공란처리(2013.01.08 이종림 차장) self.responseData[@"변경전평형"]
            @{@"Name" : @"차기주택형 변경가능일", @"Value" : @""}, // 개인뱅킹에선 값이 없는것이 정상(2013.01.03 류지민 과장)
            @{@"Name" : @"주택형 변경일자", @"Value" : self.responseData[@"평형변경일자"]}
            ]];
        }
            break;
            
        default:
            break;
    }

    return (NSArray *)infoDetailList;
}

@end
