//
//  NSString+UUID.m
//  ShinhanBank
//
//  Created by Jong Pil Park on 12. 9. 24..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)

+ (NSString *)uuid
{
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid)
    {
        uuidString = (NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return [uuidString autorelease];
}

@end
