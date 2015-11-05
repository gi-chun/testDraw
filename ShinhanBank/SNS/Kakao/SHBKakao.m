//
//  SHBKakao.m
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 18..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBKakao.h"

// 인코딩 함수.
static NSString *StringByAddingPercentEscapesForURLArgument(NSString *string)
{
	NSString *escapedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																				  (CFStringRef)string,
																				  NULL,
																				  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				  kCFStringEncodingUTF8);
	return [escapedString autorelease];
}

// 인자 생성 함수.
static NSString *HTTPArgumentsStringForParameters(NSDictionary *parameters)
{
	NSMutableArray *arguments = [NSMutableArray array];
    
	for (NSString *key in parameters)
    {
		NSString *parameter = [NSString stringWithFormat:@"%@=%@", key, StringByAddingPercentEscapesForURLArgument([parameters objectForKey:key])];
		[arguments addObject:parameter];
	}
	
	return [arguments componentsJoinedByString:@"&"];
}

// 카카오링크 API 버전.
static NSString * const KakaoLinkApiVerstion = @"2.0";

// 카카오링크 URL.
static NSString * const KakaoLinkURLBaseString = @"kakaolink://sendurl";

@interface SHBKakao ()
+ (BOOL)openKakaoLinkWithParams:(NSDictionary *)params;
@end

@implementation SHBKakao

#pragma mark - 클래스 메서드(프라이빗).

+ (NSString *)kakaoLinkURLStringForParameters:(NSDictionary *)parameters
{
	NSString *argumentsString = HTTPArgumentsStringForParameters(parameters);
	NSString *URLString = [NSString stringWithFormat:@"%@?%@", KakaoLinkURLBaseString, argumentsString];
	return URLString;
}

+ (BOOL)openKakaoLinkWithParams:(NSDictionary *)params
{
    NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:params];
    [_params setObject:KakaoLinkApiVerstion forKey:@"apiver"];
    
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self kakaoLinkURLStringForParameters:_params]]];
}

#pragma mark - 클래스 메서드(퍼블릭).

+ (BOOL)canOpenKakaoLink
{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:KakaoLinkURLBaseString]];
}

+ (BOOL)openKakaoLinkWithURL:(NSString *)referenceURLString
				  appVersion:(NSString *)appVersion
				 appBundleID:(NSString *)appBundleID
					 appName:(NSString *)appName
					 message:(NSString *)message
{
    if (!referenceURLString || !message || !appVersion || !appBundleID ||!appName)
		return NO;
	
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                referenceURLString, @"url",
                                message, @"msg",
                                appVersion, @"appver",
                                appBundleID, @"appid",
                                appName, @"appname",
                                @"link", @"type",
                                nil];
    
	return [self openKakaoLinkWithParams:parameters];
}

+ (BOOL)openKakaoAppLinkWithMessage:(NSString *)message
								URL:(NSString *)referenceURLString
						appBundleID:(NSString *)appBundleID
						 appVersion:(NSString *)appVersion
							appName:(NSString *)appName
					  metaInfoArray:(NSArray *)metaInfoArray
{
    BOOL avalibleAppLink = !message || !appVersion || !appBundleID || !appName || !metaInfoArray || [metaInfoArray count] > 0;
	if (!avalibleAppLink)
		return NO;
    
    // JSON 변환을 위해 JSONKit 사용.
    NSDictionary *dict = [NSDictionary dictionaryWithObject:metaInfoArray forKey:@"metainfo"];
    NSError *error = nil;
    NSString *appDataString = [dict JSONStringWithOptions:JKSerializeOptionNone error:&error];
    NSLog(@"Send data: %@", appDataString);
    
    if (appDataString == nil)
        return NO;
    
	NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       referenceURLString, @"url",
                                       message, @"msg",
                                       appVersion, @"appver",
                                       appBundleID, @"appid",
                                       appName, @"appname",
                                       @"app", @"type",
                                       appDataString, @"metainfo",
                                       nil];
    
	return [self openKakaoLinkWithParams:parameters];
}

@end
