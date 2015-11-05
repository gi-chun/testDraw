//
//  NSURLResponse+Header.m
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 26..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "NSURLResponse+Header.h"

@implementation NSURLResponse (Header)

- (void)printHeader
{
    NSArray *cookies;
    NSDictionary *headers;
    
    // 받은 header들을 dictionary 형태로 받고
    headers = [(NSHTTPURLResponse *)self allHeaderFields];
    
    if (headers != nil)
    {
        // headers에 포함되어 있는 항목들 출력
        for (NSString *key in headers)
        {
            NSLog(@"Header: %@ = %@", key, [headers objectForKey:key]);
        }
        
        // cookies에 포함되어 있는 항목들 출력
        cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:[self URL]];
        
        if (cookies != nil)
        {
            for (NSHTTPCookie *cookie in cookies)
            {
                NSLog(@"Cookie: %@ = %@", [cookie name], [cookie value]);
            }
        }
    }
}

@end
