//
//  NSUserDefaults+Settings.m
//  OrchestraNative
//
//  Created by Park Jong Pil on 11. 9. 23..
//  Copyright (c) 2011년 Reciper. All rights reserved.
//

#import "NSUserDefaults+Settings.h"
#import "NSString+Helper.h"

NSString * const IsUsingAutoScreenLock = @"IsUsingAutoScreenLock";
NSString * const IsUsingMultitasking = @"IsUsingMultitasking";
NSString * const IsUsingLandscapeMode = @"IsUsingLandscapeMode";
NSString * const MainMenuOrder = @"MainMenuOrder";
NSString * const MainMenuVersion = @"MainMenuVersion";
NSString * const MyMenuVersion = @"MyMenuVersion";
NSString * const EasyEnquiryData = @"EasyEnquiryData";
NSString * const IsFirstAppStart = @"IsFirstAppStart";
NSString * const IsMobilianNetMigration = @"IsMobilianNetMigration";
NSString * const TypeOfLoginCert = @"TypeOfLoginCert";
NSString * const SettingsLoginTypeKey = @"SettingsLoginTypeKey";
NSString * const CertificateData = @"CertificateData";
NSString * const DistanceSetting = @"DistanceSetting";
NSString * const WallpaperSetting = @"WallpaperSetting";
NSString * const WallpaperSettingData = @"WallpaperSettingData";
NSString * const PushFlagSetting = @"PushFlagSetting";
NSString * const ExpiryDateValue = @"ExpiryDateValue";
NSString * const ExpiryDateValue2 = @"ExpiryDateValue2";
NSString * const FavoriteBranches = @"FavoriteBranches";            // 영업점/ATM - 자주 찾는 지점 등록
NSString * const SearchPopupUse = @"SearchPopupUse";
NSString * const SecureStarUse = @"SecureStarUse";

@implementation NSUserDefaults (Settings)

#pragma mark - 화면자동잠김방지 사용 여부

- (BOOL)isUsingAutoScreenLock
{
    return [self boolForKey:IsUsingAutoScreenLock];
}

- (void)setIsUsingAutoScreenLock:(BOOL)isUsingAutoScreenLock
{
    // idleTimerDisabled의 기본값: NO.
    [[UIApplication sharedApplication] setIdleTimerDisabled:isUsingAutoScreenLock];
    [self setBool:isUsingAutoScreenLock forKey:IsUsingAutoScreenLock];
    [self synchronize];
}

#pragma mark - 멀티태스킹 사용 여부

- (BOOL)isUsingMultitasking
{
    return [self boolForKey:IsUsingMultitasking];
}

- (void)setIsUsingMultitasking:(BOOL)isUsingMultitasking
{
    [self setBool:isUsingMultitasking forKey:IsUsingMultitasking];
    [self synchronize];
}

#pragma mark - 가로보기 모드 사용 여부

- (BOOL)isUsingLandscapeMode
{
    return [self boolForKey:IsUsingLandscapeMode];
}

- (void)setIsUsingLandscapeMode:(BOOL)isUsingLandscapeMode
{
    [self setBool:isUsingLandscapeMode forKey:IsUsingLandscapeMode];
    [self synchronize];
}

#pragma mark - 메인메뉴 순서
- (NSMutableArray *)mainMenuOrderList
{
    return [self objectForKey:MainMenuOrder];
}

- (void)setMainMenuOrderList:(NSMutableArray *)orderArray
{
	[self setObject:orderArray forKey:MainMenuOrder];
    [self synchronize];
}

#pragma mark - 메인메뉴 버전

- (NSString *)mainMenuVersion
{
    return [self objectForKey:MainMenuVersion];
}

- (void)setMainMenuVersion:(NSString *)mainMenuVersion
{
    [self setObject:mainMenuVersion forKey:MainMenuVersion];
    [self synchronize];
}

#pragma mark - 마이메뉴 버전

- (NSString *)myMenuVersion
{
    return [self objectForKey:MyMenuVersion];
}

- (void)setMyMenuVersion:(NSString *)myMenuVersion
{
    [self setObject:myMenuVersion forKey:MyMenuVersion];
    [self synchronize];
}

#pragma mark - 간편조회 설정
- (NSString *)easyInquiryData
{
	return [self objectForKey:EasyEnquiryData];
}

- (void)setEasyInquiryData:(NSString *)dictionary
{
	[self setObject:dictionary forKey:EasyEnquiryData];
	[self synchronize];
}

- (void)removeEasyInquiryData
{
	[self removeObjectForKey:EasyEnquiryData];
}

#pragma mark - 앱최초 실행 확인
- (NSString *)isFirstAppStart
{
	return [self objectForKey:IsFirstAppStart];
}

- (void)setFirstAppStart:(NSString *)str
{
	[self setObject:str forKey:IsFirstAppStart];
    [self synchronize];
}

#pragma mark - 기존앱이 모빌리언승에스필터사용하다 모빌리언스넷으로 변경된경우 마이그레이션이 필요해서 마이그레이션 되었는지 기록
- (NSString *)isMobilianNetMigration
{
    return [self objectForKey:IsMobilianNetMigration];
}
- (void)setMobilianNetMigration:(NSString *)str
{
    [self setObject:str forKey:IsMobilianNetMigration];
    [self synchronize];
}

#pragma mark - 로그인 인증서 종류(테스트용인지 실인증서인지)
- (NSString *)typeOfLoginCert
{
	return [self objectForKey:TypeOfLoginCert];
}

- (void)settypeOfLoginCert:(NSString *)str
{
	[self setObject:str forKey:TypeOfLoginCert];
    [self synchronize];
}

#pragma mark - 로그인 설정
- (SettingsLoginType)loginTypeForSetting
{
	return [self integerForKey:SettingsLoginTypeKey];
}

- (void)setLoginTypeForSetting:(SettingsLoginType)type
{
	[self setInteger:type forKey:SettingsLoginTypeKey];
    [self synchronize];
}

- (void)setCertificateData:(NSMutableDictionary *)mdic
{
	[self setObject:mdic forKey:CertificateData];
    [self synchronize];
}

- (NSMutableDictionary *)certificateData
{
	return [self objectForKey:CertificateData];
}

#pragma mark - 배경화면 설정
- (SettingsWallpaperValue)wallpaper
{
	if ([self integerForKey:WallpaperSetting] == 0) {
		[self setWallpaper:SettingsWallpaperValue1];
	}
	
	return [self integerForKey:WallpaperSetting];
}

- (void)setWallpaper:(SettingsWallpaperValue)val
{
	[self setInteger:val forKey:WallpaperSetting];
	[self synchronize];
}

- (NSDictionary *)wallpaperData
{
	/**
	 배경구분 = I_640920;
	 배경적용일시 = 201212110000;
	 배경URL = http://imgdev.shinhan.com/sbank/bg/bg_4@2x.png;
	 배경이미지 = <NSData *>;
	 */
	return [self objectForKey:WallpaperSettingData];
}

- (void)setWallpaperData:(NSDictionary *)wallpaperData
{
	[self setObject:wallpaperData forKey:WallpaperSettingData];
	[self synchronize];
}

#pragma mark - 검색 반경 설정 (영업점/ATM)
- (float)distanceValue
{
	if ([self floatForKey:DistanceSetting] == 0) {
		[self setDistanceValue:1.0];
	}
	
	return [self floatForKey:DistanceSetting];
}

- (void)setDistanceValue:(float)value
{
	[self setFloat:value forKey:DistanceSetting];
	[self synchronize];
}

#pragma mark - 푸쉬(알립) 서비스 설정
- (PushServiceFlag)pushFlag{
	if ([self integerForKey:PushFlagSetting] == 0){
		[self setPushFlag:PUSH_IS_FIRST];
	}
	
	return [self integerForKey:PushFlagSetting];
}
- (void)setPushFlag:(PushServiceFlag)pushFlag{
	[self setInteger:pushFlag forKey:PushFlagSetting];
	[self synchronize];
}

#pragma mark - 만기예정 및 경과상품 안내

// 예금/신탁
- (NSString *)expiryDateValue
{
    return [self objectForKey:ExpiryDateValue];
}

- (void)setExpiryDateValue:(NSString *)expiryDateValue
{
    [self setObject:expiryDateValue forKey:ExpiryDateValue];
    [self synchronize];
}

// 대출
- (NSString *)expiryDateValue2
{
    return [self objectForKey:ExpiryDateValue2];
}

- (void)setExpiryDateValue2:(NSString *)expiryDateValue
{
    [self setObject:expiryDateValue forKey:ExpiryDateValue2];
    [self synchronize];
}

#pragma mark -
#pragma mark 영업점/ATM - 자주 찾는 지점 등록

- (NSArray *)getFavoriteBranches
{
    return [self objectForKey:FavoriteBranches];
}

- (void)setFavoriteBranches:(NSArray *)aArray
{
    [self setObject:aArray forKey:FavoriteBranches];
    [self synchronize];
}

#pragma mark -
#pragma mark 검색팝업 설정

- (NSString *)getSearchPopup
{
    return [self objectForKey:SearchPopupUse];
}

- (void)setSearchPopup:(NSString *)isSearchPopupUse
{
    [self setObject:isSearchPopupUse forKey:SearchPopupUse];
    [self synchronize];
}

- (NSString *)getSecureSetting
{
    return [self objectForKey:SecureStarUse];
}

- (void)setSecureSetting:(NSString *)isSecureSetting
{
    [self setObject:isSecureSetting forKey:SecureStarUse];
    [self synchronize];
}

@end
