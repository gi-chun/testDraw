//
//  SHBUtility.m
//  ShinhanBank
//
//  Created by RedDragon on 12. 11. 4..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBUtility.h"
#import <sys/timeb.h>

//맥어드레스 가져오기 위한 헤더
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
/////////////////////////

// 통신사 알아오기
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//

@implementation SHBUtility

+ (NSString *)cardnumToHiddenView:(NSString *)str
{
	NSString *cardHidden;
	
	if([str length] == 16)
	{
		cardHidden = [NSString stringWithFormat:@"%@-****-**%@-%@*",[str substringWithRange:NSMakeRange(0, 4)],
					  [str substringWithRange:NSMakeRange(10, 2)],[str substringWithRange:NSMakeRange(12, 3)] ];
        
	}
	else {
		cardHidden = [NSString stringWithFormat:@"%@-******-%@*",[str substringWithRange:NSMakeRange(0, 4)],
					  [str substringWithRange:NSMakeRange(11, 4)] ];
	}
    
	return cardHidden;
}

+ (NSString *)getDateWithDash:(NSString *)date
{
	if([date length] != 8)
		return date;
	
	NSRange range;
	int year;
	int month;
	int day;
	
	range.location	= 0;
	range.length	= 4;
	year	= [[date substringWithRange:range] intValue];
	range.location	= 4;
	range.length	= 2;
	month	= [[date substringWithRange:range] intValue];
	range.location	= 6;
	range.length	= 2;
	day		= [[date substringWithRange:range] intValue];
	
	return [[[NSString alloc] initWithFormat:@"%04d.%02d.%02d",year, month, day] autorelease];	//JINSEUNG FIX5
}



+ (int) countMultiByteStringFromUTF8String:(NSString*)str
{
	NSString *tmp = [str stringByAddingPercentEscapesUsingEncoding:-2147482590];
	
	if(tmp == nil)
	{
		return -1;
	}
	
	if([tmp isEqualToString:@""])
	{
		return 0;
	}
	
    //	NSLog(@"----%@",str);
    //	NSLog(@"====%@",tmp);
	
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%25" withString:@"1"];  //%
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%23" withString:@"1"];  //#
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%22" withString:@"1"];  //"
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%20" withString:@"1"];
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%3C" withString:@"1"];  //<
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%3E" withString:@"1"];  //>
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%5B" withString:@"1"];  //[
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%5C" withString:@"1"];  //\
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%5D" withString:@"1"];  //]
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%5E" withString:@"1"];  //^
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%7B" withString:@"1"];  //{
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%7C" withString:@"1"];  //|
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%7D" withString:@"1"];  //}
    //tmp = [tmp stringByReplacingOccurrencesOfString:@"%40" withString:@"1"];  //@  //12월7일 추가
    //tmp = [tmp stringByReplacingOccurrencesOfString:@"%21" withString:@"1"];  //?  //12월7일 추가
	
    
	//NSLog(@"tmp %@ %d %d", tmp, [tmp length], [tmp length] - 3);
	if([tmp length] < 4)
	{
		return [tmp length];
	}
	for(int i = 0; i < [tmp length] - 3; i++)
	{
		if([tmp characterAtIndex:i] == '%' && [tmp characterAtIndex:i + 3] == '%')
		{
			tmp = [tmp stringByReplacingCharactersInRange:NSMakeRange(i, 3) withString:@""];
		}
	}
	
	tmp = [tmp stringByReplacingOccurrencesOfString:@"%" withString:@""];
	
	//NSLog(@"%@",tmp);
	//NSLog(@"strlength tmp");
	return [tmp length];
	
	
}

+ (NSString *) substring:(NSString*)str ToMultiByteLength:(int)length
{
	int a[512] = {0,};
	int i,j;
    //	int endIndex;
	
    //	endIndex = 0;
//	i = 0;
	j = 0;
	
	if(str == nil)
	{
		return @"";
	}
	
	if([str isEqualToString:@""])
	{
		return @"";
	}
	
	[SHBUtility countMultiByteStringFromUTF8String:str];
	
	for (i = 0; i < [str length]; i++)
	{
		if([str characterAtIndex:i] > 127)
		{
			a[i] = 2;
		}
		else
		{
			a[i] = 1;
		}
        
		j += a[i];
		
		if (j == length)
		{
            //			endIndex = j;
			break;
		}
		else if (j > length)
		{
            //			endIndex = j - a[i];
			break;
		}
        
	}
	
	i = 0;
	j = 0;
	
	while (length > 0 && i < [str length])
	{
		
		length -= a[i];
		
		
		if (length >= 0)
		{
			j++;
			i++;
			NSLog(@"length %d a[i] %d jvalue %d",length, a[i], j);
		}
		else
		{
			break;
		}
        
	}
	
	return [str substringWithRange:NSMakeRange(0, j)];
	
	
}


+ (NSString *)commaStringToNormalString:(NSString *)commaString
{
	if ([commaString compare:@""] == 0) {
		return @"";
	}
	
    commaString = [commaString stringByReplacingOccurrencesOfString:@"원" withString:@""];
    
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc]init];
	[fmt setCurrencyCode:@"KRW"];		// 2010.04.19 leejinsm 통화코드적용.
	[fmt setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
	[fmt setNumberStyle:NSNumberFormatterDecimalStyle];
	
	NSNumber *temp = [fmt numberFromString:commaString];
	
	[fmt setNumberStyle:NSNumberFormatterNoStyle];
	
	NSString *returnValue = [fmt stringFromNumber:temp];
	
	[fmt release];
	
	return returnValue;
}

+ (NSString *)normalStringTocommaString:(NSString *)normalString
{
    normalString = [normalString stringByReplacingOccurrencesOfString:@"," withString:@""];
    
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc]init];
	[fmt setNumberStyle:NSNumberFormatterDecimalStyle];
	[fmt setCurrencyCode:@"KRW"];		// 2010.04.19 leejinsm 통화코드적용.
	[fmt setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"] autorelease]];
	NSNumber *temp = [fmt numberFromString:normalString];
	
	NSString *returnValue = [fmt stringFromNumber:temp];
	
	[fmt release];
	
	return returnValue;
}


+ (NSString *)getPreOPDate:(NSString *)str
{
	NSURL *url;
	NSURLRequest *request;
	NSURLResponse *response;
	NSData *recvData;
	NSError *err;
	NSRange tmpRange;
	NSString *startDate;
	//NSString *urlString = [NSString stringWithFormat:@"https://%@%@%@",SERVER_IP,PRE_OP_DATE_URL,str];
	NSString *urlString = [NSString stringWithFormat:@"https://%@%@%@",AppInfo.serverIP,PRE_OP_DATE_URL,str];
    
    //SHINHANBANKAppDelegate *application = GET_APP_DELEGATE();
	//[application screenLock];
	
	NSLog(@"PREOPDate URL %@",urlString);
	url = [NSURL URLWithString:urlString];
	request = [[NSURLRequest alloc] initWithURL:url];
	
	recvData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	[request release];
	if(recvData == nil)
	{
		//[application screenUnlock];
		return nil;
	}
	
	NSString *date = [NSString stringWithFormat:@"%s",[recvData bytes]];
	
	tmpRange = [date rangeOfString:@"date value='"];
	
	if (tmpRange.location == NSNotFound)
	{
		//[application screenUnlock];
		return nil;
	}
	
	tmpRange = NSMakeRange(tmpRange.location + tmpRange.length, 8);
	
	startDate = [date substringWithRange:tmpRange];
	
	
	return [[[NSString alloc] initWithString:startDate] autorelease];
}

+ (NSString *)getPostOPDate:(NSString *)str
{
	NSURL *url;
	NSURLRequest *request;
	NSURLResponse *response;
	NSData *recvData;
	NSError *err;
	NSRange tmpRange;
	NSString *startDate;
	//NSString *urlString = [NSString stringWithFormat:@"https://%@%@%@",SERVER_IP,POST_OP_DATE_URL ,str];
    NSString *urlString = [NSString stringWithFormat:@"https://%@%@%@",AppInfo.serverIP,POST_OP_DATE_URL ,str];
    
	//SHINHANBANKAppDelegate *application = GET_APP_DELEGATE();
	//[application screenLock];
	
	NSLog(@"PostOPDate URL %@",urlString);
	url = [NSURL URLWithString:urlString];
	request = [[NSURLRequest alloc] initWithURL:url];
	
	recvData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	[request release];
	if(recvData == nil)
	{
		//[application screenUnlock];
		return nil;
	}
	
	NSString *date = [NSString stringWithFormat:@"%s",[recvData bytes]];
	
	tmpRange = [date rangeOfString:@"date value='"];
	
	if (tmpRange.location == NSNotFound)
	{
		//[application screenUnlock];
		
		return nil;
	}
	
	tmpRange = NSMakeRange(tmpRange.location + tmpRange.length, 8);
	
	startDate = [date substringWithRange:tmpRange];
	
	return [[[NSString alloc] initWithString:startDate] autorelease];
}

+ (NSString *)getNextMonthOPDate:(NSString *)str
{
	NSURL *url;
	NSURLRequest *request;
	NSURLResponse *response;
	NSData *recvData;
	NSError *err;
	NSRange tmpRange;
	NSString *startDate;
	//NSString *urlString = [NSString stringWithFormat:@"https://%@%@%@",SERVER_IP,NEXT_MONTH_OPDATE_URL,str];
    NSString *urlString = [NSString stringWithFormat:@"https://%@%@%@",AppInfo.serverIP,NEXT_MONTH_OPDATE_URL,str];
    
	//SHINHANBANKAppDelegate *application = GET_APP_DELEGATE();
	//[application screenLock];
	
	NSLog(@"NEXTMOPDate URL %@",urlString);
	url = [NSURL URLWithString:urlString];
	request = [[NSURLRequest alloc] initWithURL:url];
	
	recvData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	[request release];
	if(recvData == nil)
	{
		//[application screenUnlock];
		return nil;
	}
	
	NSString *date = [NSString stringWithFormat:@"%s",[recvData bytes]];
	
	tmpRange = [date rangeOfString:@"date value='"];
	
	if (tmpRange.location == NSNotFound)
	{
		//[application screenUnlock];
		
		return nil;
	}
	
	tmpRange = NSMakeRange(tmpRange.location + tmpRange.length, 8);
	
	startDate = [date substringWithRange:tmpRange];
	
	//[application screenUnlock];
	return [[[NSString alloc] initWithString:startDate] autorelease];
}

+ (BOOL) isOPDate:(NSString *)str
{
	NSURL *url;
	NSURLRequest *request;
	NSURLResponse *response;
	NSData *recvData;
	NSError *err;
	NSRange tmpRange;
	//NSString *urlString = [NSString stringWithFormat:@"https://%@%@%@",SERVER_IP,BUSINESS_CHECK_URL,str];
    NSString *urlString = [NSString stringWithFormat:@"https://%@%@%@",AppInfo.serverIP,BUSINESS_CHECK_URL,str];
    
	//SHINHANBANKAppDelegate *application = GET_APP_DELEGATE();
	//[application screenLock];
    
	NSLog(@"isOPDate URL %@",urlString);
	
	url = [NSURL URLWithString:urlString];
	request = [[NSURLRequest alloc] initWithURL:url];
	
	recvData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	[request release];
	if(recvData == nil)
	{
		//[application screenUnlock];
        
		return NO;
	}
	
	NSString *date = [NSString stringWithFormat:@"%s",[recvData bytes]];
	
	tmpRange = [date rangeOfString:@"isOPDate value='true'"];
	
	if (tmpRange.location == NSNotFound)
	{
		//[application screenUnlock];
		NSLog(@"isOPDate NO");
		return NO;
	}
	
	//[application screenUnlock];
    
	NSLog(@"isOPDate YES");
	return YES;
	
}

+ (NSArray *)getCurrentDateAgoYear:(int)yy AgoMonth:(int)mm AgoDay:(int)dd SDate:(NSString*)str
{
	NSURL *url;
	NSURLRequest *request;
	NSURLResponse *response;
	NSData *recvData;
	NSError *err;
	NSRange tmpRange;
	//NSString *urlString = [NSString stringWithFormat:@"https://%@%@inputDate=%@&y=%d&m=%d&d=%d",SERVER_IP,DATE_URL,str,yy,mm,dd];
    NSString *urlString = [NSString stringWithFormat:@"https://%@%@inputDate=%@&y=%d&m=%d&d=%d",AppInfo.serverIP,DATE_URL,str,yy,mm,dd];
    
	NSString *startDate;
	NSString *endDate;
	NSArray *retArray;
	
	NSLog(@"getCurrentDateAgoYear URL %@",urlString);
	//SHINHANBANKAppDelegate *application = GET_APP_DELEGATE();
	
	//[application screenLock];
	
	url = [NSURL URLWithString:urlString];
	request = [[NSURLRequest alloc] initWithURL:url];
	
	recvData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	[request release];
	if(recvData == nil)
	{
		//[application screenUnlock];
		return nil;
	}
	
	NSString *date = [NSString stringWithFormat:@"%s",[recvData bytes]];
	
	tmpRange = [date rangeOfString:@"addDate value='"];
	
	if (tmpRange.location == NSNotFound)
	{
		//[application screenUnlock];
		
		return nil;
	}
	
	tmpRange = NSMakeRange(tmpRange.location + tmpRange.length, 8);
	
	startDate = [date substringWithRange:tmpRange];
	
	
	date = [NSString stringWithFormat:@"%s",[recvData bytes]];
	
	tmpRange = [date rangeOfString:@"inputDate value='"];
	
	if (tmpRange.location == NSNotFound)
	{
		//[application screenUnlock];
		
		return nil;
	}
	
	tmpRange = NSMakeRange(tmpRange.location + tmpRange.length, 8);
	
	endDate = [date substringWithRange:tmpRange];
	
	retArray = [[[NSArray alloc] initWithObjects:startDate, endDate, nil] autorelease];
	
	//[application screenUnlock];
	
	return retArray;
}


+ (NSArray *)getCurrentDateAgoYear:(int)yy AgoMonth:(int)mm AgoDay:(int)dd
{
	NSURL *url;
	NSURLRequest *request;
	NSURLResponse *response;
	NSData *recvData;
	NSError *err;
	NSRange tmpRange;
	//NSString *urlString = [NSString stringWithFormat:@"https://%@%@y=%d&m=%d&d=%d",SERVER_IP,DATE_URL,yy,mm,dd];
    NSString *urlString = [NSString stringWithFormat:@"https://%@%@y=%d&m=%d&d=%d",AppInfo.serverIP,DATE_URL,yy,mm,dd];
	NSString *startDate;
	NSString *endDate;
	NSArray *retArray;
	
	//SHINHANBANKAppDelegate *application = GET_APP_DELEGATE();
	
	//[application screenLock];
	
	url = [NSURL URLWithString:urlString];
	request = [[NSURLRequest alloc] initWithURL:url];
	
	recvData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	[request release];
	if(recvData == nil)
	{
		//[application screenUnlock];
		return nil;
	}
    
	NSString *date = [NSString stringWithFormat:@"%s",[recvData bytes]];
	
	tmpRange = [date rangeOfString:@"addDate value='"];
	
	if (tmpRange.location == NSNotFound)
	{
		//[application screenUnlock];
        
		return nil;
	}
	
	tmpRange = NSMakeRange(tmpRange.location + tmpRange.length, 8);
	
	startDate = [date substringWithRange:tmpRange];
	
	
	date = [NSString stringWithFormat:@"%s",[recvData bytes]];
	
	tmpRange = [date rangeOfString:@"inputDate value='"];
	
	if (tmpRange.location == NSNotFound)
	{
		//[application screenUnlock];
        
		return nil;
	}
	
	tmpRange = NSMakeRange(tmpRange.location + tmpRange.length, 8);
	
	endDate = [date substringWithRange:tmpRange];
	
	retArray = [[[NSArray alloc] initWithObjects:startDate, endDate, nil] autorelease];
	
	//[application screenUnlock];
    
	return retArray;
}

//2011.02.01  서버에서 날짜 시간 가져오는 메소드 추가
+ (NSString *)getCurrentTime
{
	return [self getCurrentTime:NO];
}
+ (NSString *)getCurrentTime:(BOOL) Hyphen
{
	//SHINHANBANKAppDelegate *application = GET_APP_DELEGATE();
	
	NSURL *url;
	NSURLRequest *request;
	NSURLResponse *response;
	NSData *recvData;
	NSError *err;
	NSRange tmpRange;
	NSString *urlString;
    
    //urlString = [NSString stringWithFormat:@"https://%@%@HH:mm:ss",SERVER_IP,DATE_TIME_URL];
    urlString = [NSString stringWithFormat:@"https://%@%@HH:mm:ss",AppInfo.serverIP,DATE_TIME_URL];
    
//	if(application.isTest == NO) {
//		urlString = [NSString stringWithFormat:@"http://%@%@HH:mm:ss",SERVER_IP,Date_TIME_URL];
//	}
//	else {
//		urlString = [NSString stringWithFormat:@"http://%@%@HH:mm:ss",TESTSERVER_IP,Date_TIME_URL];
//	}
    
	//[application screenLock];
	
	url = [NSURL URLWithString:urlString];
	request = [[NSURLRequest alloc] initWithURL:url];
	
	recvData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	[request release];
	if(recvData == nil)
	{
		//[application screenUnlock];
		return nil;
	}
	
	NSString *date = [NSString stringWithFormat:@"%s",[recvData bytes]];
	
	tmpRange = [date rangeOfString:@"date value='"];
	
	if (tmpRange.location == NSNotFound)
	{
		//[application screenUnlock];
		
		return nil;
	}
	
	tmpRange = NSMakeRange(tmpRange.location + tmpRange.length, 8);
	
	NSString *startDate = [date substringWithRange:tmpRange];
	
	
	//[application screenUnlock];
	NSLog(@"time = %@",[startDate stringByReplacingOccurrencesOfString:@":" withString:@""]);
	
	
	if (Hyphen) {
		//리턴 값 16:05:23
		return [NSString stringWithString:startDate];
	}
	else {
		//리턴 값 160523
		return [NSString stringWithString:[startDate stringByReplacingOccurrencesOfString:@":" withString:@""]];
	}
	
}
/////// 2011.02.01  기존에 안쓰던 소스 변경
+ (NSString *)getCurrentDate{
	return [self getCurrentDate:NO];
}
+ (NSString *)getCurrentDate:(BOOL) Hyphen
{
	//SHINHANBANKAppDelegate *application = GET_APP_DELEGATE();
	
	NSURL *url;
	NSURLRequest *request;
	NSURLResponse *response;
	NSData *recvData;
	NSError *err;
	NSRange tmpRange;
	NSString *urlString;
    
    //urlString = [NSString stringWithFormat:@"https://%@%@yyyy-MM-dd",SERVER_IP,DATE_TIME_URL];
    urlString = [NSString stringWithFormat:@"https://%@%@yyyy-MM-dd",AppInfo.serverIP,DATE_TIME_URL];
    
//	if(application.isTest == NO) {
//		urlString = [NSString stringWithFormat:@"http://%@%@yyyy-MM-dd",SERVER_IP,Date_TIME_URL];
//	}
//	else {
//		urlString = [NSString stringWithFormat:@"http://%@%@yyyy-MM-dd",TESTSERVER_IP,Date_TIME_URL];
//	}
	
	//[application screenLock];
	
	url = [NSURL URLWithString:urlString];
	request = [[NSURLRequest alloc] initWithURL:url];
	
	recvData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
	[request release];
	if(recvData == nil)
	{
		//[application screenUnlock];
		return nil;
	}
	
	NSString *date = [NSString stringWithFormat:@"%s",[recvData bytes]];
	
	tmpRange = [date rangeOfString:@"date value='"];
	
	if (tmpRange.location == NSNotFound)
	{
		//[application screenUnlock];
		
		return nil;
	}
	
	tmpRange = NSMakeRange(tmpRange.location + tmpRange.length, 10);
	
	NSString *startDate = [date substringWithRange:tmpRange];
	
	
	//[application screenUnlock];
	//NSLog(@"date = %@",[startDate stringByReplacingOccurrencesOfString:@"-" withString:@""]);
	
	if (Hyphen) {
		//리턴 값 2011-02-01
		return startDate;
	}
	else {
		//리턴 값 20110201
		return [startDate stringByReplacingOccurrencesOfString:@"-" withString:@""];
	}
    
	
}



+ (NSString *)getDateMonthAgo:(NSString *)currentDate month:(int)ago
{
	int year,month,day;
	
	year = [[currentDate substringWithRange:NSMakeRange(0, 4)] intValue];
	month = [[currentDate substringWithRange:NSMakeRange(4, 2)] intValue];
	day = [[currentDate substringWithRange:NSMakeRange(6, 2)] intValue];
	
	month = month - ago;
    
	
	if (day == 0)
	{
		month--;
		day = 32;
	}
	
	if(month < 1)
	{
		year--;
		month = 12 + month;
	}
	
	
	if(day > 28)
	{
		if(month == 2)
		{
			if((((year % 4) == 0 && (year % 100) != 0) || (year % 400) == 0))
			{
				day = 29;
                
			}
			else
			{
				day = 1;
			}
		}
		
		if(day > 30)
		{
			if(month == 1 ||
			   month == 3 ||
			   month == 5 ||
			   month == 7 ||
			   month == 8 ||
			   month == 10 ||
			   month == 12)
			{
				day = 30;
			}
			else
			{
				day = 31;
			}
            
		}
        
	}
	
	return [NSString stringWithFormat:@"%04d%02d%02d", year, month, day];
	
}

+ (NSString *)phoneNumber
{
	NSString *phoneNumber;
	NSString *retNumber;
	char tmp[12] = {0,};
	char *tmpnumber;
	
	phoneNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"SBFormattedPhoneNumber"];
	NSLog(@"%@", phoneNumber);
	
	
	if(phoneNumber == nil)
	{
		return [NSString stringWithFormat:@"01000000000"];
	}
	
	if([phoneNumber length] < 16)
	{
		return [NSString stringWithFormat:@"01000000000"];
	}
	
	if(!([phoneNumber UTF8String][1] == '8' && [phoneNumber UTF8String][2] == '2'))
	{
		return [NSString stringWithFormat:@"01000000000"];
	}
	
	retNumber = [[[NSString alloc] initWithFormat:@"0%@",[phoneNumber substringFromIndex:4]] autorelease];
	
	tmpnumber = (char *)[retNumber UTF8String];
	
	int j = 0;
	
	for(int i = 0; i < strlen(tmpnumber); i++)
	{
		if(tmpnumber[i] == '-')
		{
			continue;
		}
		
		tmp[j] = tmpnumber[i];
		j++;
		
	}
	
	return [NSString stringWithUTF8String:tmp];
}

+ (int)getCurrentHour
{
	struct timeb itb;
	struct tm *ts;
	
	ftime(&itb);
	ts = localtime(&itb.time);
	
	int ret = ts->tm_hour;
	
	return ret;
	
}

+ (int)getCurrentSecond
{
	struct timeb itb;
	struct tm *ts;
	
	ftime(&itb);
	ts = localtime(&itb.time);
	
	int ret = ts->tm_sec;
	
	return ret;
	
}

+ (int)checkDateValidation:(NSString *)yyyyMMdd
{
	int month;
	int day;
	int year;
	
	if (yyyyMMdd == nil)
	{
		return 0;
	}
	
	if ([yyyyMMdd length] != 8)
	{
		return 0;
	}
	
	year = [[yyyyMMdd substringWithRange:NSMakeRange(0,4)] intValue];
	month = [[yyyyMMdd substringWithRange:NSMakeRange(4, 2)] intValue];
	day = [[yyyyMMdd substringWithRange:NSMakeRange(6, 2)] intValue];
	
	
	if (month > 12 || month <= 0)
	{
		return 0;
	}
	
	if (day > 31 || day <= 0)
	{
		return 0;
	}
	else {
		if((month == 4 || month == 6 || month == 9 || month == 11) && day > 30 )
		{
			return 0;
		}
		else if ( month == 2 && day > 28)
		{
			if(((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) && day == 29 )
				return 1;
			else 
				return 0;
		}
	}
	
	return 1;
	
}

#pragma mark -
#pragma mark BirthYearString

+ (NSString *)birthYearString
{
    //NSString *yearPerCode = [AppInfo.ssn substringWithRange:NSMakeRange(6, 1)];
    NSString *yearPerCode = [[AppInfo getPersonalPK] substringWithRange:NSMakeRange(6, 1)];
    NSString *strBirthYear = @"";
    
    if ( [yearPerCode isEqualToString:@"1"] || [yearPerCode isEqualToString:@"2"] || [yearPerCode isEqualToString:@"5"] || [yearPerCode isEqualToString:@"6"] )
    {
        //strBirthYear = [NSString stringWithFormat:@"%@%@", @"19", [AppInfo.ssn substringToIndex:6]];
        strBirthYear = [NSString stringWithFormat:@"%@%@", @"19", [[AppInfo getPersonalPK] substringToIndex:6]];
    }
    else
    {
        //strBirthYear = [NSString stringWithFormat:@"%@%@", @"20", [AppInfo.ssn substringToIndex:6]];
        strBirthYear = [NSString stringWithFormat:@"%@%@", @"20", [[AppInfo getPersonalPK] substringToIndex:6]];
        
        if ( [yearPerCode isEqualToString:@"7"] || [yearPerCode isEqualToString:@"8"] )
        {
            NSString *strToday = [[self dateStringToMonth:0 toDay:0] stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            if ( [strToday intValue] <= [strBirthYear intValue] )      // 오늘 이후 출생의 경우 2000년 이전 출생
            {
                //strBirthYear = [NSString stringWithFormat:@"%@%@", @"19", [AppInfo.ssn substringToIndex:6]];
                strBirthYear = [NSString stringWithFormat:@"%@%@", @"19", [[AppInfo getPersonalPK] substringToIndex:6]];
            }
        }
    }
    
    return strBirthYear;
}

#pragma mark -
#pragma mark Converting 1234 -> 천이백삼십사

// 숫자를 받아 한글로 변환 (ex) 1234 -> 천이백삼십사

+ (NSString *)changeNumberStringToKoreaAmountString:(NSString*)amountString
{
    NSString    *strResult = @"";
    
    amountString = [amountString stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    if ( nil == amountString || [amountString isEqualToString:@""])
    {
        return strResult;
    }
    
    NSDictionary        *dicNumber = [[[NSDictionary alloc] initWithDictionary:@{
                                       @"0" : @"",
                                       @"1" : @"일",
                                       @"2" : @"이",
                                       @"3" : @"삼",
                                       @"4" : @"사",
                                       @"5" : @"오",
                                       @"6" : @"육",
                                       @"7" : @"칠",
                                       @"8" : @"팔",
                                       @"9" : @"구"
                                       }] autorelease];
    
    NSDictionary        *dicVolume = [[[NSDictionary alloc] initWithDictionary:@{
                                       @"0" : @"",
                                       @"1" : @"십",
                                       @"2" : @"백",
                                       @"3" : @"천"
                                       }] autorelease];
    
    NSDictionary        *dicPosition = [[[NSDictionary alloc] initWithDictionary:@{
                                         @"0" : @"",
                                         @"1" : @"만",
                                         @"2" : @"억",
                                         @"3" : @"조"
                                         }] autorelease];
    
    int     intStringLength = [amountString length];
    int     intDiv;
    int     intMod;
    
    for ( int i = 0 ; i < intStringLength ; i++)
    {
        intDiv = (intStringLength - i) / 4;
        intMod = (intStringLength - i) % 4;
        
        int intResult = 0;
        if(i != 0)
        {
            intResult = [[amountString substringWithRange:NSMakeRange(i-1, 1)] intValue];
        }
        
        if ( intResult != 0 )           // 각 단위수 추가
        {
            strResult = [strResult stringByAppendingFormat:@"%@", [dicNumber objectForKey:[NSString stringWithFormat:@"%d", intResult]]];
            strResult = [strResult stringByAppendingFormat:@"%@", [dicVolume objectForKey:[NSString stringWithFormat:@"%d", intMod]]];
        }
        
        if ( i == intStringLength - 1 )     // 일의 자리수 추가
        {
            strResult = [strResult stringByAppendingFormat:@"%@", [dicNumber objectForKey:[NSString stringWithFormat:@"%@", [amountString substringWithRange:NSMakeRange([amountString length] - 1, 1)]]]];
        }
        
        if ( intMod == 0 && intStringLength > 4 * intDiv)        // 만 억 조 추가
        {
            NSString *strApending = [dicPosition objectForKey:[NSString stringWithFormat:@"%d", intDiv]];
            
            if ([[strResult substringFromIndex:([strResult length] -1)] isEqualToString:@"억"] ||
                [[strResult substringFromIndex:([strResult length] -1)] isEqualToString:@"조"])
            {                       // '억'단위나 '조'단위의 경우 '만'이 사라진다
                strApending = @"";
            }
            
            strResult = [strResult stringByAppendingFormat:@"%@", strApending];
        }
    }
    
    return strResult;
}

// 달과 일을 받아 오늘 날짜 이후, 혹은 이전 날짜를 계산해주는 method

+ (NSString *)dateStringToMonth:(int)month toDay:(int)day
{
    NSString *strToday = [SHBAppInfo sharedSHBAppInfo].tran_Date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate *dateToday = [dateFormatter dateFromString:strToday];
    
    NSCalendar *currentUserCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    offsetComponents.month  = month;
    offsetComponents.day    = day;
    
    NSDate *resultDate = [currentUserCalendar
                          dateByAddingComponents:offsetComponents
                          toDate:dateToday
                          options:0];
    
    NSString *strResultString = [dateFormatter stringFromDate:resultDate];
    
    [dateFormatter release];
    [offsetComponents release];
    
    return strResultString;
}

+ (NSString *)nilToString:(NSString *)str
{
    if (!str) {
        return @"";
    }
    
    return str;
}

//도큐먼트 디렉토리 경로를 가져온다
+ (NSString *) getDocumentsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}
//캐시 디렉토리 경로를 가져온다
+ (NSString *) getCachesDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//지정된 경로에 파일이나 디렉토리가 있는지 확인한다.
+ (BOOL) isExistFile:(NSString *) sPath {
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:sPath];
	
    return fileExists;
}

// 전화번호 국번체크
+ (NSTextCheckingResult *)isPhoneNumberCheck:(NSString *)number1 number2:(NSString *)number2 number3:(NSString *)number3
{
    NSString *temp = [NSString stringWithFormat:@"%@%@%@", number1, number2, number3];
    
    NSString *expression = @"^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})?[0-9]{3,4}?[0-9]{4}$";
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:temp options:0 range:NSMakeRange(0, [temp length])];
    
    return match;
}

// 전화번호 국번체크
+ (NSTextCheckingResult *)isPhoneNumberCheck:(NSString *)phoneNumber
{
    NSString *temp = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *expression = @"^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})?[0-9]{3,4}?[0-9]{4}$";
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:temp options:0 range:NSMakeRange(0, [temp length])];
    
    return match;
    
}

+ (BOOL)isExistAlpabet:(NSString *)stringStr
{
    NSString *ptn = @"[a-zA-Z]";
    NSRange range = [stringStr rangeOfString:ptn options:NSRegularExpressionSearch];
    
    //NSLog(@"isExistAlpabet:%d", range.length);
    
    if (range.length > 0)
    {
        return YES;
    } else
    {
        return NO;
    }
    
    return NO;
}

+ (BOOL)isExistNumber:(NSString *)stringStr
{
    NSString *ptn = @"[0-9]";
    NSRange range = [stringStr rangeOfString:ptn options:NSRegularExpressionSearch];
    
    //NSLog(@"isExistNumber:%d", range.length);
    
    if (range.length > 0)
    {
        return YES;
        
    } else
    {
        return NO;
    }
    
    return NO;
}

+ (int) getDDay:(NSString *)fromStr
{
    NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *edate = [outputFormatter dateFromString:fromStr];
    //NSDate *sdate = [outputFormatter dateFromString:[self getCurrentDate:YES]];
    NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
    NSDate *sdate = [outputFormatter dateFromString:currentDate];
    
    NSDateComponents *dcom = [[NSCalendar currentCalendar]components: NSDayCalendarUnit
                                                                fromDate:sdate toDate:edate options:0];
    
    return [dcom day];
}

+ (NSString *)getMacAddress:(BOOL)isColon
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       macAddress[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    else
    {
        // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
        {
            // Alloc memory based on above call
            if ((msgBuffer = (char *)malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
            {
                // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
            }
        }
    }
    
    // Befor going any further...
    if (errorFlag != NULL)
    {
        NSLog(@"Error: %@", errorFlag);
        
        free(msgBuffer);
        return errorFlag;
    }
    
    // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
    // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
    // Copy link layer address data in socket structure to an array
    memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    NSString *macAddressString = @"";
    
    if (isColon) {
        macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                            macAddress[0], macAddress[1], macAddress[2],
                            macAddress[3], macAddress[4], macAddress[5]];
    }
    else {
        macAddressString = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X",
                            macAddress[0], macAddress[1], macAddress[2],
                            macAddress[3], macAddress[4], macAddress[5]];
    }
    // Read from char array into a string object, into traditional Mac address format
    
    //NSLog(@"Mac Address: %@", macAddressString);
    
    // Release the buffer memory
    free(msgBuffer);
    
    return macAddressString;
}

+ (NSString *)getSecureMacAddress:(NSString *)mac
{
    if ([mac length] == 0) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@:**:**:%@", [mac substringToIndex:8], [mac substringFromIndex:15]];
}

// 이메일주소 체크
+ (NSTextCheckingResult *)emailVaildCheck:(NSString *)email
{
    
    NSString *expression = @"^[A-Z0-9._%-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
    
    return match;
    
}

// str에서 findStr 찾기
+ (BOOL)isFindString:(NSString *)str find:(NSString *)findStr
{
    if (str == nil || findStr == nil)
    {
        return NO;
        
    }
    
    NSRange range = [str rangeOfString:findStr];
    if (range.location == NSNotFound) {
        return NO;
    }
    else {
        return YES;
    }
}

+ (NSString *)addTimeStamp:(NSString *)URL
{
    NSString *str = @"?";
    
    if ([SHBUtility isFindString:URL find:@"?"]) {
        
        str = @"&";
    }
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    
    URL = [NSString stringWithFormat:@"%@%@%@", URL, str, date];
    
    return URL;
}

// 통신사 알아오기
+ (NSString *)getCarrier
{
    CTTelephonyNetworkInfo *networkInfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    NSString *carrierName = [carrier carrierName];
    
    if (!carrierName) {
        carrierName = @"";
    }
    
    return carrierName;

}

+ (NSString *)dateStringToDate:(NSString *)date toMonth:(int)month toDay:(int)day
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSDate *dateToday = [dateFormatter dateFromString:date];
    
    NSCalendar *currentUserCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    offsetComponents.month  = month;
    offsetComponents.day    = day;
    
    NSDate *resultDate = [currentUserCalendar
                          dateByAddingComponents:offsetComponents
                          toDate:dateToday
                          options:0];
    
    NSString *strResultString = [dateFormatter stringFromDate:resultDate];
    
    [dateFormatter release];
    [offsetComponents release];
    
    return strResultString;
}

+ (NSString *)setAccountNumberMinus:(NSString *)accountNumber
{
    if ([accountNumber length] != 12) {
        return accountNumber;
    }
    
    return [NSString stringWithFormat:@"%@-%@-%@", [accountNumber substringWithRange:NSMakeRange(0, 3)],
            [accountNumber substringWithRange:NSMakeRange(3, 3)],
            [accountNumber substringWithRange:NSMakeRange(6, 6)]];
}

+ (BOOL)writeErrorLog:(NSString *)errMsg
{
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [outputFormatter setDateFormat:@"yyyyMMddhhmmss"];
    NSString *currentDate = [outputFormatter stringFromDate:[NSDate date]];
    
    NSString *filename = [NSString stringWithFormat:@"sBankErrorLog-%@.txt",currentDate];
    NSString *filedir = [self getDocumentsDirectory];
    
    NSString *filepath = [filedir stringByAppendingPathComponent:filename];
    
    BOOL isOK = [errMsg writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    if (isOK)
    {
        return YES;
    }
    return NO;
}
@end
