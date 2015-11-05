//
//  SHBCardService.m
//  ShinhanBank
//
//  Created by Joon on 12. 11. 12..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBCardService.h"

@implementation SHBCardService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
	}
}

- (void)start
{
    if (!self.requestData) {
        self.requestData = [SHBDataSet dictionary];
    }
    
    [self requestDataSet:(SHBDataSet *)self.requestData];
}

- (void)client:(OFHTTPClient *)client didReceiveData:(NSData *)aData
{
    OFDataSet *aDataSet = [self.parser parse:aData];
    
    if ([self.strServiceCode isEqualToString:CARD_E2911]) {
        AppInfo.codeList.cardList = [aDataSet arrayWithForKey:@"LIST"];
        
        for (NSMutableDictionary *dic in AppInfo.codeList.cardList) {
            [dic setObject:dic[@"카드명"]
                    forKey:@"1"];
            [dic setObject:[SHBUtility cardnumToHiddenView:dic[@"카드번호"]]
                    forKey:@"2"];
            
             [AppInfo.codeList.creditCardList addObject:dic];
            
//            /* 카드종류
//             1: 신한 신용카드
//             2: BC 신용카드
//             3: 신한 체크카드
//             4: BC 체크카드
//             */
//            if ([dic[@"카드종류"] isEqualToString:@"1"] || [dic[@"카드종류"] isEqualToString:@"2"]) {
//                [AppInfo.codeList.creditCardList addObject:dic];
//            }
        }
        
        [self cardErrorCheck];
    }
    else {
        [self parse:aData];
    }
}

- (void)cardErrorCheck
{
    if ([AppInfo.codeList.cardList count] == 0) {
        [UIAlertView showAlert:nil
                          type:ONFAlertTypeOneButton
                           tag:0
                         title:@""
                       message:@"보유하신 신한카드가 존재하지 않습니다."];
        return;
    }
    
    // 이용대금 명세서 조회 - 월별 청구금액 조회
    // 이용대금 명세서 조회 - 결제 예정금액 조회
    // 결제내역조회
    // 이용한도조회
    if ([NSStringFromClass([AppInfo.lastViewController class]) isEqualToString:@"SHBCardMonthDateInputViewController"] ||
        [NSStringFromClass([AppInfo.lastViewController class]) isEqualToString:@"SHBCardSchedulePaymentListViewController"] ||
        [NSStringFromClass([AppInfo.lastViewController class]) isEqualToString:@"SHBCardPaymentInputViewController"] ||
        [NSStringFromClass([AppInfo.lastViewController class]) isEqualToString:@"SHBCardLimitInfoViewController"]) {
        if ([AppInfo.codeList.creditCardList count] == 0) {
            [UIAlertView showAlert:nil
                              type:ONFAlertTypeOneButton
                               tag:0
                             title:@""
                           message:@"해당메뉴는 신용카드 전용메뉴 입니다.\n소지하신 신용카드가 없습니다."];
            return;
        }
    }
    
    [AppDelegate.navigationController pushFadeViewController:AppInfo.lastViewController];
    
    if (_isFirstLogin) {
        //[(SHBBaseViewController *)AppInfo.lastViewController helloCustomer];
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
