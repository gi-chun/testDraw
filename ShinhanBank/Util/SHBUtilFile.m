//
//  SHBUtilFile.m
//  ShinhanBank
//
//  Created by JI HOON KIM on 12. 12. 5..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUtilFile.h"
#import "UIDevice+Hardware.h"
//#import "KTBiOS.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation SHBUtilFile

static SHBUtilFile *instance = nil;

+(id)instance
{
	if (instance == nil)
	{
		instance = [self new];
		[instance initData];
	}
	return instance;
}

-(void)initData
{
	
}

-(void)setShareDataFile:(NSString*)fileName fileData:(NSDictionary*)data
{
	[data writeToFile:[self dataFilePath:fileName ] atomically:YES];
}


-(NSMutableDictionary*)getShareDataFile:(NSString*)fileName
{
	
	//Debug( @" 로드 완료 ======= " );
	
	NSString *filePath = [self dataFilePath:fileName];
	
	//Debug( @"filePath %@ " , filePath );
	
	if( [[NSFileManager defaultManager]fileExistsAtPath:filePath] )
	{
		//Debug( @" 찿았다.== " );
		
		NSMutableDictionary *data	= [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
		
		return data;
	}
	else
	{
		return NULL;
	}
	
	return NULL;
	
}

-(void)setShareListFile:(NSString*)fileName fileData:(NSArray*)data
{
	[data writeToFile:[self dataFilePath:fileName ] atomically:YES];
}


-(NSMutableArray*)getShareListFile:(NSString*)fileName
{
	
	NSString *filePath = [self dataFilePath:fileName];
	Debug(@" filePath ==> %@", filePath);
	
	if( [[NSFileManager defaultManager]fileExistsAtPath:filePath] )
	{
		NSMutableArray *array	= [NSMutableArray arrayWithContentsOfFile:filePath];
		
		return array;
	}
	else
	{
		return NULL;
	}
	
	return NULL;
	
}


-(void)setShareArrayFile:(NSString*)fileName fileData:(NSArray*)data
{
	[data writeToFile:[self dataFilePath:fileName ] atomically:YES];
}


-(NSMutableArray*)getShareArrayFile:(NSString*)fileName
{
	
	NSString *filePath = [self dataFilePath:fileName];
	
	if( [[NSFileManager defaultManager]fileExistsAtPath:filePath] )
	{
		//Debug( @"Array 파일을 찾았습니다." );
		
		NSMutableArray *data	= [NSMutableArray arrayWithContentsOfFile:filePath];
		
		return data;
	}
	else
	{
		//Debug( @"Array 파일이 없습니다." );
		return NULL;
	}
	
	return NULL;
	
}



/*
 *	파일경로 반환
 */
-(NSString *)dataFilePath:(NSString*)name
{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//Debug( @" 파일 경로 %@ " , [documentsDirectory stringByAppendingPathComponent:name] );
	
	return [documentsDirectory stringByAppendingPathComponent:name];
	
}

// Hybrid Path 반환
-(NSString *) getHybridPath:(NSInteger)path fileName:(NSString *)fileName
{
	NSString *result = nil;
	
	return result;
}

/*
 iOS가 구동될 수 있는 모든 애플 디바이스에 대한 정보로
 'iPhone4,1'와 같은 시스템 모델명이 아닌 'iPhone 4S'와 같이 알기쉽게 상품모델명을 출력합니다.
 */
+ (NSString *)getModel
{
#if !TARGET_IPHONE_SIMULATOR
    NSString *model = getModel();
    
    //    if ([model hasPrefix:@"Cm="] && [model hasSuffix:@"$"]) {
    //        model = [model substringWithRange:NSMakeRange(3, [model length] - 4)];
    //    }
    if (model == nil)
    {
        model = @"";
    }
    return model;
#else
    return [[UIDevice currentDevice] platformString];
#endif
}

/*
 현재 구동중인 iOS의 버젼을 출력합니다.
 */
+ (NSString *)getOSVersion
{
#if !TARGET_IPHONE_SIMULATOR
    return getOSVersion();
    
    NSString *version = getOSVersion();
    
    //    if ([version hasPrefix:@"Os="] && [version hasSuffix:@"$"]) {
    //        version = [version substringWithRange:NSMakeRange(3, [version length] - 4)];
    //    }
    
    if (version == nil)
    {
        version = @"";
    }
    return version;
#else
    return [[UIDevice currentDevice] osVersionName];
#endif
}

/*
 디바이스가 가입되어 있는 통신사업체명를 출력합니다.
 */
+ (NSString *)getTelecomCarrierName
{
#if !TARGET_IPHONE_SIMULATOR
    NSString *telecom = getTelecomCarrierName();
    
    //    if ([telecom hasPrefix:@"TC="] && [telecom hasSuffix:@"$"]) {
    //        telecom = [telecom substringWithRange:NSMakeRange(3, [telecom length] - 4)];
    //    }
    if (telecom == nil || [telecom length] == 0)
    {
        telecom = @"";
    }
    
    return telecom;
#else
    return @"";
#endif
}

/*
 해당 통신사업체의 국가코드를 출력합니다.
 */
+ (NSString *)getISOCountryCode
{
#if !TARGET_IPHONE_SIMULATOR
    
    NSString *countryCode = getISOCountryCode();
    if (countryCode == nil)
    {
        countryCode = @"";
    }
    return countryCode;
#else
    return @"";
#endif
}

/*
 해당 통신사업체의 숫자코드를 출력합니다.
 */
+ (NSString *)getMobileNetworkCode
{
#if !TARGET_IPHONE_SIMULATOR
    
    NSString *networkCode = getMobileNetworkCode();
    if (networkCode == nil)
    {
        networkCode = @"";
    }
    return networkCode;
#else
    return @"";
#endif
}

/*
 디바이스의 현재 네트워크 상태를 출력합니다.
 현재 영업점ATM기를 찾는 올레 앱 라이브러리와 중복되는 부분이 있어 부득이하게 관련부분을 삭제하여,
 'Conneted'라는 문자열을 출력하도록 처리하였습니다.
 */
+ (NSString *)getNetworkStatus
{
#if !TARGET_IPHONE_SIMULATOR
    NSString *networkStatus = getNetworkStatus();
    if (networkStatus == nil)
    {
        networkStatus = @"";
    }
    return networkStatus;
#else
    return @"";
#endif
}

/*
 와이파이 네트워크카드의 MAC주소를 구분자없는 상태로 바꾸어 출력합니다.
 */
+ (NSString *)getWiFiMACAddress:(BOOL)isColon
{
#if !TARGET_IPHONE_SIMULATOR
    NSMutableString *mac = [NSMutableString stringWithString:getWiFiMACAddress()];
    
    //    if ([mac hasPrefix:@"M1="] && [mac hasSuffix:@"$"]) {
    //        NSString *temp = [mac substringWithRange:NSMakeRange(3, [mac length] - 4)];
    //        mac = [NSMutableString stringWithString:temp];
    //    }
    
    if ([mac length] == 12) {
        if (isColon) {
            NSMutableString *macAddress = [NSMutableString string];
            
            for (NSInteger i = 0; i < 6; i++) {
                if (i == 0) {
                    [macAddress appendFormat:@"%@", [mac substringToIndex:2]];
                }
                else {
                    [macAddress appendFormat:@":%@", [mac substringToIndex:2]];
                }
                [mac deleteCharactersInRange:NSMakeRange(0, 2)];
            }
            
            return [macAddress uppercaseString];
        }
        else {
            return [mac uppercaseString];
        }
    }
    else {
        return @"";
    }
#else
    return [[SHBUtility getMacAddress:isColon] uppercaseString];
#endif
}

/*
 디바이스 내의 다른 네트워크카의 MAC주소를 구분자없는 상태로 바꾸어 출력합니다.
 */
+ (NSString *)getEthernetMACAddress:(BOOL)isColon
{
#if !TARGET_IPHONE_SIMULATOR
    NSMutableString *mac = [NSMutableString stringWithString:getEthernetMACAddress()];
    
    //    if ([mac hasPrefix:@"M2="] && [mac hasSuffix:@"$"]) {
    //        NSString *temp = [mac substringWithRange:NSMakeRange(3, [mac length] - 4)];
    //        mac = [NSMutableString stringWithString:temp];
    //    }
    
    if ([mac length] == 12) {
        if (isColon) {
            NSMutableString *macAddress = [NSMutableString string];
            
            for (NSInteger i = 0; i < 6; i++) {
                if (i == 0) {
                    [macAddress appendFormat:@"%@", [mac substringToIndex:2]];
                }
                else {
                    [macAddress appendFormat:@":%@", [mac substringToIndex:2]];
                }
                [mac deleteCharactersInRange:NSMakeRange(0, 2)];
            }
            
            return [macAddress uppercaseString];
        }
        else {
            return [mac uppercaseString];
        }
    }
    else {
        return @"";
    }
#else
    return [[SHBUtility getMacAddress:isColon] uppercaseString];
#endif
}

/*
 디바이스의 공인IP주소를 원격의 서버(IP:port)에 질의하여 출력합니다.
 소켓에러가 발생할 경우에는 다른 사설IP로 대체출력하게 됩니다.
 3초의 타임아웃을 초과하면 역시 사설IP로 대체출력됩니다.
 */
+ (NSString *)getExternalIPAddress:(NSString *)serverIPstr portNumber:(unsigned short)serverPortNbr
{
#if !TARGET_IPHONE_SIMULATOR
    
    NSString *externalIPAddress = getExternalIPAddress(serverIPstr, serverPortNbr);
    if (externalIPAddress == nil)
    {
        externalIPAddress = @"";
    }
    return externalIPAddress;
#else
    return @"";
#endif
}

/*
 와이파이 네트워크의 사설IP주소를 출력합니다. 네트워크 비활성화, 모바일네트워크 상태일때는 'NA'를 출력합니다.
 */
+ (NSString *)getInternalIPAddress1
{
#if !TARGET_IPHONE_SIMULATOR
    NSString *internalIPAddress1 = getInternalIPAddress1();
    if (internalIPAddress1 == nil)
    {
        internalIPAddress1 = @"";
    }
    return internalIPAddress1;
#else
    return @"";
#endif
}

/*
 모바일 통신망에서의 사설IP주소를 출력합니다.
 */
+ (NSString *)getInternalIPAddress2
{
#if !TARGET_IPHONE_SIMULATOR
    NSString *internalIPAddress2 = getInternalIPAddress2();
    if (internalIPAddress2 == nil)
    {
        internalIPAddress2 = @"";
    }
    return internalIPAddress2;
#else
    return @"";
#endif
}

/*
 디바이스가 와이파이에 접속한 상태라면 SSID(Wi-Fi이름)를 출력합니다.
 */
+ (NSString *)getSSID
{
#if !TARGET_IPHONE_SIMULATOR
    
    NSString *getSSIDstr = getSSID();
    if (getSSIDstr == nil)
    {
        getSSIDstr = @"";
    }
    return getSSIDstr;
#else
    return @"";
#endif
}

/*
 디바이스가 와이파이에 접속한 상태라면 무선 공유기의 BSSID 즉, 무선네트워크카드의 MAC주소를 출력합니다.
 */
+ (NSString *)getBSSID
{
#if !TARGET_IPHONE_SIMULATOR
    NSString *getBSSIDstr = getBSSID();
    if (getBSSIDstr == nil)
    {
        getBSSIDstr = @"";
    }
    return getBSSIDstr;
#else
    return @"";
#endif
}

/*
 iOS의 버젼이 5.0이상 6.0이하인 디바이스에 한하여 전화번호를 출력합니다.
 */
+ (NSString *)getCellNumber
{
#if !TARGET_IPHONE_SIMULATOR
    
    NSString *cellNumber = getCellNumber();
    if (cellNumber == nil)
    {
        cellNumber = @"";
    }
    return getCellNumber();
#else
    return @"";
#endif
}

/*
 iOS 6.0이상인 디바이스에 한하여 애플 사용자 계정을 출력합니다. 공장초기화된 상태에서는 'NA'라고 출력됩니다.
 */
+ (NSString *)getUserAccount
{
#if !TARGET_IPHONE_SIMULATOR
    NSString *userAccount = getUserAccount();
    if (userAccount == nil)
    {
        userAccount = @"";
    }
    return getUserAccount();
#else
    return @"";
#endif
}

/*
 20가지 이상의 패턴으로 디바이스의 현재 루팅여부를 체크합니다.
 */
+ (NSString *)checkRoot
{
#if !TARGET_IPHONE_SIMULATOR
    return checkRoot();
#else
    return @"";
#endif
}

+ (NSString *)getPhoneUUID1:(NSString *)aAccessGroup
{
#if !TARGET_IPHONE_SIMULATOR
    return getUUID1(aAccessGroup);
#else
    return @"";
#endif
}
+ (NSString *)getPhoneUUID2:(NSString *)aAccessGroup
{
#if !TARGET_IPHONE_SIMULATOR
    return getUUID2(aAccessGroup);
#else
    return @"";
#endif
}
/*
 위 16가지 항목을 모두 한줄의 문자열로 종합하여 출력합니다.
 */
+ (NSString *)getResultSum:(NSString *)serverIPstr portNumber:(unsigned short)serverPortNbr connected:(BOOL)isConnect accessGroup:(NSString *)aAccessGroup
{
#if !TARGET_IPHONE_SIMULATOR
    return getResultSum(serverIPstr, serverPortNbr,isConnect,aAccessGroup);
#else
    return @"";
#endif
}


+ (NSString *)getGlobalIPAddress
{
#if !TARGET_IPHONE_SIMULATOR
	BOOL			success;
	struct ifaddrs * addrs	= NULL;
	const struct	ifaddrs * cursor;
	NSString		*address	= @"";
	
	success = (getifaddrs(&addrs) == 0);
	if (success)
	{
		cursor = addrs;
		while (cursor != NULL) {
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) // this second test keeps from picking up the loopback address
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"])
				{ // found the WiFi adapter
					address	= [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    NSLog(@"en0 = %@", address);
					break;
				}
                else if([name isEqualToString:@"pdp_ip0"])
                {
                    address	= [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                    NSLog(@"= > pdp_ip0 = %@", address);
					break;
                }
			}
			
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
    
    // 접속된 WIFI 정보
    /*
     NSArray *ifs = (id)CNCopySupportedInterfaces();
     NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
     id info = nil;
     for (NSString *ifnam in ifs)
     { info = (id)CNCopyCurrentNetworkInfo(( CFStringRef)ifnam);
     NSLog(@"%s: %@ => %@", __func__, ifnam, info);
     if (info && [info count]) { break; }
     }
     */
    
	return address;
#else
    return @"";
#endif
}

+ (NSString *)getProxy
{
    return checkProxy();
}
@end
