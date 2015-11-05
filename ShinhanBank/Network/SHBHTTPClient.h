//
//  SHBNetworkHandler.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 신한S뱅크의 HTTP 클라이언트 클래스(SHBHTTPClient)와 프로토콜(SHBHTTPClientDelegate) 이다.
 */

#import <Foundation/Foundation.h>
#import "SHBConstants.h"
#import "SHBAlertPopupView.h"

//#import "SmartSafeAgent.h"
#import "SmartSafeClient.h"

#define JSTAR_ERROR_XML_ELEMENT_KEY @"JSTAR_ERROR"
#define ERROR_XML_ELEMENT_KEY @"ERROR"
#define WARNING_XML_ELEMENT_KEY @"WARNING"
#define SERVICE_CODE_XML_ELEMENT_KEY @"COM_SVC_CODE"


/// 얼럿을 띄운 후, 앱을 종료할 경우...
#define EXIT_ALERT_VIEW_TAG 100

#define BOLCK_SMARTSAFE 1
//#define BOLCK_SMARTSAFE 0

@protocol SHBHTTPClientDelegate <NSObject>

@optional
/**
 수신한 데이트를 화면에서 사용하기 위한 SHBNetworkHandlerDelegate 메서드.
 
 @param dict 서버에서 데이터를 수신된 데이터를 파싱한 NSDictionary 타입.
 */
- (void) receiveData:(NSDictionary *)dict;

@end

@interface SHBHTTPClient : OFHTTPClient<SHBAlertPopupViewDelegate>


/**
 SHBHTTPClientDelegate
 */
@property (nonatomic, retain) id<SHBHTTPClientDelegate> delegate;

/**
 스마트 세이프 에이전트.
 */
//@property (nonatomic, retain) SmartSafeAgent *ssAgent;

/**
 스마트 세이프 클라이언트.
 */
@property (nonatomic, retain) SmartSafeClient *ssClient;

//@property (nonatomic, retain) UIAlertView *showWarningAlert;
/**
 SHBHTTPClient 싱글턴 인스턴스를 생성한다.
 
 @return sharedSHBHTTPClient 반환.
 */
+ (SHBHTTPClient *)sharedSHBHTTPClient;

/**
 전문을 전송한다.
 
 @param trType 전문의 유형.
 @param serviceCode 서비스 코드(전문번호), 전문유형(SHBTRType)이 SHBTRTypeServiceCode이 아닐 경우 nil.
 @param path URL을 생성하기 위햔 URL의 서비스 패스.
 @param obj 델리게이트 객체.
 @param dict 전문생성을 위한 전문의 키 = 값 형태의 NSDictionary 또는 NSMutableDictionary.
 */
- (void)sendData:(SHBTRType)trType serviceCode:(NSString *)aServiceCode path:(NSString *)urlPath obj:(id)delegateObj dictionary:(NSMutableDictionary *)dict;

/**
 데이터 타입(data ? NSMutableDictionary : NSDictionary)을 확인 후 전문을 전송한다.
 전문 전송 시, sendData:withObj:andDictionary: 메서드를 사용한다.
 
 @param trType 전문의 유형.
 @param serviceCode 서비스 코드(전문번호), 전문유형(SHBTRType)이 SHBTRTypeServiceCode이 아닐 경우 nil.
 @param path URL을 생성하기 위햔 URL의 서비스 패스.
 @param obj 델리게이트 객체.
 @param dict 전문생성을 위한 전문의 키 = 값 형태의 NSDictionary 또는 NSMutableDictionary.
 */
- (void)sendData:(SHBTRType)trType serviceCode:(NSString *)aServiceCode path:(NSString *)urlPath obj:(id)delegateObj data:(id)dict;

/**
 공인인증서 로그인 관련 전문을 전송한다.
 
 @param request STLESignOn 클래스의 makeSignOnRequestWithRequest:error 메서드가 반환한 NSURLRequest 타입이다.
 */
- (void)requestCert:(NSURLRequest *)request;

/**
 전자 서명 서버확인 전문을 태운다
 
 @param request STLESignOn 클래스의 makeSignOnRequestWithRequest:error 메서드가 반환한 NSURLRequest 타입이다.
 */
- (void)requestServerSign:(NSURLRequest *)request obj:(id)delegateObj;

//스마트세이퍼를 거치지 않는 동기식 통신 방식을 스마트세이퍼를 타도록 비동기식으로 처리하기위해
- (void)requestBlockED:(NSURLRequest *)request obj:(id)delegateObj;

//- (void)showCustomAlert:(NSString *)errorMsg alertTag:(int)aTag;
@end
