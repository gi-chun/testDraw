//
//  NSUserDefaults+Settings.h
//  OrchestraNative
//
//  Created by Park Jong Pil on 11. 9. 23..
//  Copyright (c) 2011년 Reciper. All rights reserved.
//

/**
 NSUserDefaults를 편리하게 사용하기 위한 프라퍼티를 제공하는 카테고리 이다.
 */

typedef enum
{
	SettingsLoginTypeDefault = 0,				// 기본 로그인 (공인인증서/ID로그인)
	SettingsLoginTypeCertificate,			// 공인인증서 로그인
	SettingsLoginTypeCertificateSelected,	// 공인인증서 지정 로그인
    SettingsLoginTypeNone,                  // 설정없음
}SettingsLoginType;

typedef enum
{
	SettingsWallpaperValue1 = 100,
	SettingsWallpaperValue2,
	SettingsWallpaperValue3,
	SettingsWallpaperValue4,
    SettingsWallpaperValue5,
    SettingsWallpaperValue6,
    SettingsWallpaperValue7,
    SettingsWallpaperValue8,
}SettingsWallpaperValue;

typedef enum{
	PUSH_IS_FIRST = 0,
	PUSH_IS_USE,
	PUSH_NOT_USE,
}PushServiceFlag;

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Settings)

/**
 화면자동잠김방지 사용 여부.
 */
@property (assign, getter = isUsingAutoScreenLock, setter = setIsUsingAutoScreenLock:) BOOL isUsingAutoScreenLock;

/**
 멀티태스킹 사용 여부.
 */
@property (assign, getter = isUsingMultitasking, setter = setIsUsingMultitasking:) BOOL isUsingMultitasking;

/**
 가로보기 모드 사용 여부.
 */
@property (assign, getter = isUsingLandscapeMode, setter = setIsUsingLandscapeMode:) BOOL isUsingLandscapeMode;	// 사용안함. 추후삭제.

/**
 메인메뉴 순서
 */
@property (assign, getter = mainMenuOrderList, setter = setMainMenuOrderList:) NSMutableArray *mainMenuOrderList;

/**
 메인메뉴 버전
 */
@property (assign, getter = mainMenuVersion, setter = setMainMenuVersion:) NSString *mainMenuVersion;

/**
 마이메뉴 버전
 */
@property (assign, getter = myMenuVersion, setter = setMyMenuVersion:) NSString *myMenuVersion;



/**
 간편조회 설정
 */
- (NSString *)easyInquiryData;
- (void)setEasyInquiryData:(NSString *)dictionary;
- (void)removeEasyInquiryData;

/**
 앱최초 실행인지 확인
 */
- (NSString *)isFirstAppStart;		// nil or any string
- (void)setFirstAppStart:(NSString *)str;

/**
 앱최초 실행인지 확인, MobilianSFilter에서 MobilianNet(v1.4.10이상)로 전환시의 마이그레이션이 되었는지
 */
- (NSString *)isMobilianNetMigration;		// nil or any string
- (void)setMobilianNetMigration:(NSString *)str;

/**
테스트용 인증서 접속인지 실 인증서인지
 */
- (NSString *)typeOfLoginCert;		// nil or any string
- (void)settypeOfLoginCert:(NSString *)str;

/**
 로그인 설정
 */
@property (assign, getter = loginTypeForSetting, setter = setLoginTypeForSetting:) SettingsLoginType loginType;
- (void)setCertificateData:(NSMutableDictionary *)mdic;		// 공인인증서 지정 로그인시 셋팅
- (NSMutableDictionary *)certificateData;

/**
 배경화면 설정
 */
@property (assign, getter = wallpaper, setter = setWallpaper:) SettingsWallpaperValue wallpaper;
- (void)setWallpaperData:(NSDictionary *)wallpaperData;
- (NSDictionary *)wallpaperData;

/**
 검색 반경 설정 (영업점/ATM)
 */
@property (assign, getter = distanceValue, setter = setDistanceValue:) float distanceValue;

/**
 푸쉬알림 설정
 */
@property (assign, getter = pushFlag, setter = setPushFlag:) PushServiceFlag pushFlag;

/**
 만기예정 및 경과상품 안내
 */
@property (assign, getter = expiryDateValue, setter = setExpiryDateValue:) NSString *expiryDateValue; // 예금/신탁
@property (assign, getter = expiryDateValue2, setter = setExpiryDateValue2:) NSString *expiryDateValue2; // 대출

/**
 영업점/ATM - 자주 찾는 지점 등록
 */
@property (assign, getter = getFavoriteBranches, setter = setFavoriteBranches:) NSArray *favoriteBranches;

/**
 검색팝업 설정
 */
@property (assign, getter = getSearchPopup, setter = setSearchPopup:) NSString *isSearchPopupUse;

/**
 보안기패드 * 로 표시여부
 */
@property (assign, getter = getSecureSetting, setter = setSecureSetting:) NSString *isSecureSetting;
@end
