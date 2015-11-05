//
//  SHBNotificationService.m
//  ShinhanBank
//
//  Created by Joon on 12. 12. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBNotificationService.h"

@implementation SHBNotificationService

+ (void)initialize
{
	static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
        
        NSDictionary *info = NOTIFICATION_SERVICE_INFO;
        [SHBBankingService addServiceInfo:info];
	}
}

- (void)start
{
    
    
    switch (self.serviceId)
    {
        case SMARTLETTER_SERVICE:    // 스마트레터
        {
            self.strServiceCode = SMARTLETTER;
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                    TASK_ACTION_KEY : @"selectSmartLetter",
                                    @"고객번호" : @"system:uid",
                                    }];
            
            [self requestDataSet:aDataSet];
        }
            break;
        case COUPON_SERVICE:        // 쿠폰함
        {
            self.strServiceCode = COUPON;
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService", 
                                    TASK_ACTION_KEY : @"selectCoupon3",
                                    @"고객번호" : @"system:uid",
                                    }]; 
            
            [self requestDataSet:aDataSet];
        }
            break;
        case NEW_STATE_SERVICE:     // 스마트레터, 쿠폰 NEW 상태 조회
        {
            self.strServiceCode = NEW_STATE;
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                    TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                    TASK_ACTION_KEY : @"selectNewYN2",
                                    @"고객번호" : @"system:uid",
                                    }];
            
            [self requestDataSet:aDataSet];
        }
            break;
        case GET_NOTICE_SERVICE:     // 수신메시지 가져오기
        {
            self.strServiceCode = GET_NOTICE;
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                      TASK_ACTION_KEY : @"selectNoticeListPage",
                                      //@"CPP" : @"2",
                                      @"EQUP_CD" : @"SI",
                                      //@"PAGE" : @"1",
                                      }];
            
            [self requestDataSet:aDataSet];
        }
            break;
        case GET_ALIM_SERVICE:     // 알림메시지 가져오기
        {
            self.strServiceCode = GET_ALIM;
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.sphone.task.common.SBANKTaskService",
                                      TASK_ACTION_KEY : @"selectCommonList",
                                      @"CUSNO" : @"0741831215",
                                      @"EQUP_CD" : @"SI",
                                      //@"PAGE" : @"1",
                                      }];
            
            [self requestDataSet:aDataSet];
        }
            break;
        case COUPON_INFO_SERVICE:     // 스마트레터, 쿠폰 NEW 상태 조회
        {
            self.strServiceCode = COUPON_INFO;
            [self requestDataSet:(SHBDataSet *)self.requestData];
            
         }
            
       case COUPON_DOWNLOD_SERVICE:     // 쿠폰등록
       {
           self.strServiceCode = COUPON_DOWNLOD;
           [self requestDataSet:(SHBDataSet *)self.requestData];
           
       }

            break;
        case SMARTCARE_MSM_TARGET_SERVICE:     // 스마트케어 대상조회 및 전담상담사 조회
        {
            self.strServiceCode = NEW_STATE;
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.sphone.task.customer.MySmartManagerTask",
                                      TASK_ACTION_KEY : @"checkMSMTarget",
                                      //@"CUS_NO" : AppInfo.customerNo,
                                      }];
            
            [self requestDataSet:aDataSet];
        }
            break;
        case SMARTCARE_MSM_DATA_SERVICE:    // 스마트케어 메시지 조회
        {
            self.strServiceCode = NEW_STATE;
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.sphone.task.customer.MySmartManagerTask",
                                      TASK_ACTION_KEY : @"getMSMData",
                                      @"EQUP_CD" : @"SI",
                                      }];
            
            [self requestDataSet:aDataSet];
        }
            break;
        case SMARTCARE_SCOOKIE_DATA_SERVICE:    // 스마트케어 S쿠키 받기
        {
            self.strServiceCode = NEW_STATE;
            
            SHBDataSet *aDataSet = [SHBDataSet dictionaryWithDictionary:
                                    @{
                                      TASK_NAME_KEY : @"sfg.sphone.task.customer.MySmartManagerTask",
                                      TASK_ACTION_KEY : @"setSCookieData",
                                     // @"CUS_NO" : AppInfo.customerNo,
                                      }];
            
            [self requestDataSet:aDataSet];
        }
            break;
        default:
        {
            if (!self.requestData) {
                self.requestData = [SHBDataSet dictionary];
            }
            
            [self requestDataSet:(SHBDataSet *)self.requestData];
        }
            
            break;
    }
}

@end
