//
//  SHBHTTPDummyClient.m
//  ShinhanBank
//
//  Created by unyong yoon on 12. 12. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBHTTPDummyClient.h"

@implementation SHBHTTPDummyClient

// 초기화.
- (id)init
{
    self = [super init];
	if (self)
    {
        
	}
	
	return self;
}
- (NSString *) encodeStringXML:(NSString *)stringXML
{
    // TODO: 추가 인코딩 사항이 있는지 확인할 것(현재는 기존 내용 그대로 임)!
    //stringXML = [stringXML stringByAddingPercentEscapesUsingEncoding:-2147482590];
    stringXML = [stringXML stringByAddingPercentEscapesUsingEncoding:NSEUCKRStringEncoding];
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    stringXML = [stringXML stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"[" withString:@"%5B"];
	stringXML = [stringXML stringByReplacingOccurrencesOfString:@"]" withString:@"%5D"];
    
    return stringXML;
}
- (void) requestaSyncData:(NSString *)postUrl postStr:(NSString *)postString
{
    NSURL *theURL = [NSURL URLWithString:postUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL];
    
    NSString *httpBody = [self encodeStringXML:postString];
    
    [request setHTTPMethod:OFHTTPMethodPOST];   // !!! 보낼때는 EUC-KR, 받을 때는 UTF-8.
    [request setValue:OFMIMETypeFormURLEncoded forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSData dataWithBytes:[httpBody UTF8String] length:[httpBody length]]];
    
    //NSLog(@"step 1");
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark --
#pragma mark NSURLConnection delegate method
- (void)connection:(NSURLConnection*)connection
didReceiveResponse:(NSURLResponse*)response
{
    recvData = [[NSMutableData alloc] init];
    [recvData setLength:0];
}

- (void)connection:(NSURLConnection*)connection
{
    
}
- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data
{
    [recvData appendData:data];
}
- (void)connection:(NSURLConnection*)connection
  didFailWithError:(NSError*)error
{
    //NSString *msg = @"네트워크 연결에 실패했습니다.\n잠시 후 다시 시도 주십시오.";
    //[UIAlertView showAlert:self type:ONFAlertTypeOneButton tag:0 title:@"" message:msg];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    // release 처리
    NSString *s = [[[NSString alloc] initWithData:recvData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"return dummylowdata:%@",s);
    
}

@end
