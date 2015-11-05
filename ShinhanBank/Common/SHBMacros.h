//
//  SHBMacros.h
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 16..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

/**
 신한S뱅크의 매크로를 정의 한다.
 */

#import "SHBAppDelegate.h"
#import "SHBAppInfo.h"
#import "SHBHTTPClient.h"

// 앱의 델리게이트.
#define AppDelegate ((SHBAppDelegate *)[UIApplication sharedApplication].delegate)

// 앱인포.
#define AppInfo [SHBAppInfo sharedSHBAppInfo]

//번들 경로를 가져온다
#define BundlePath(fileName) [AppInfo getMainBundleDirectory:fileName]

// 네트워크.
#define HTTPClient [SHBHTTPClient sharedSHBHTTPClient]

// 아이폰5 인지?
#define IS_IPHONE_5 [[UIScreen mainScreen] bounds].size.height == 568 || [[UIScreen mainScreen] bounds].size.width == 568 ? YES : NO;

// 아이폰5 여부에 따라 분기할 경우 사용.
#define DeviceSpecificSetting(iPhone, iPhoneFive) ((![SHBAppInfo sharedSHBAppInfo].isiPhoneFive) ? (iPhone) : (iPhoneFive));

// 데이터 전송.
// SendData(전문유형, 서비스코드, URL의 패스, 델리게이트, 데이터)
#define SendData(trType, serviceCodeOrtask, urlPath, delegateObj, dict) [HTTPClient sendData:trType serviceCode:serviceCodeOrtask path:urlPath obj:delegateObj data:dict]


//[short code] RELEASE
#define	SafeRelease(x)	{	if ( x!=nil ) [x release]; }

//테스트 서버, 운영서버 접속판별
//#defin ConnectServerType { if([AppInfo getServerType]) #define TEST_SERVER};
