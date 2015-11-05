//
//  SHBPushInfo.h
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHBHTTPClient.h"

#define PUSH_DATA_FILE_NAME	@"PUSHDATA"	//Push Notification Device Token

typedef enum
{
    /*
	 ## 01 01 01 ~ 99 99 99
	 ## 6자리로 버전 관리 (앞2:그룹, 중간2:메뉴, 하위2:화면
	 */
	
	CLASS_NOTICE	= 1,	//알림
	CLASS_PRODUCT	= 2,	//상품
		
}classSeq;


@interface SHBPushInfo : NSObject <UIAlertViewDelegate, SHBHTTPClientDelegate>
{
	NSMutableArray*				_classArray;
	NSMutableArray*				_appArray;
	
	NSString* 					_deviceToken;
	NSMutableDictionary*		_dataDic;
	
	classSeq					_scrNo;
	BOOL						_isActive;
	
	NSString*					_launchMenuCode;
	NSString*					_launchDataCode;
	
	BOOL						_wantPushNotification;	// 메시지수신
	BOOL						_wantSchemeUrl;			// scheme Url수신
	BOOL						_isFirstRegister;		// 최초등록
	
	NSString*					_screenId;
	NSString*					_className;
	
	NSString*					_requestParm;
    int ssoType;
    NSString *webSSOUrl;
}

+ (SHBPushInfo*)instance;
@property (nonatomic,retain) NSString* 	deviceToken;
@property (nonatomic,retain) NSString* 	stockCode;
@property (nonatomic,assign) UIView*	viewSignal;
@property (nonatomic,assign) UIView*	viewNews;
@property (nonatomic,assign) UIView*	viewTitle;
@property (nonatomic,assign) UIView*	viewInterest;
@property (nonatomic,retain) NSString*	launchMenuCode;
@property (nonatomic,retain) NSString*	launchDataCode;
@property (nonatomic,assign) BOOL		wantMorningBrief;
@property (nonatomic,assign) BOOL		wantSchemeUrl;
@property (nonatomic,assign) BOOL		isFirstRegister;
@property (nonatomic,retain) NSString*	requestParm;

//ios7 대응으로 2013.10.07 추가
@property (nonatomic, retain) NSString *ssoSid;

- (void) setDeviceTokenWithData:(NSData*)data;
- (BOOL) readDeviceTokenFromFile;
- (void) addLaunchDataCodeToHistory;
- (void) requestPush;								// PUSH 등록
- (void) requestMyPushInfo;							// PUSH 서비스 정보 획득
- (void) onReceivePush:(NSDictionary*)userInfo;		// PUSH 수신
- (void) didChangeScreen:(classSeq)scrNo;
- (void) showViews;
- (void) showViewController;
- (void) callSchemeUrl:(NSString*)schUrl;
- (void) recieveOpenURL;  //스키마 받는부분
- (void) requestOpenURL:(NSString *)appId Parm:(NSString*)parm;
- (void) requestOpenURL:(NSString *)strUrl SSO:(BOOL)ssoFlag;
- (void) loadCertificates;
- (void) searchCert:(NSMutableArray *)certArray;



@end
