//
//  SHBDataSet.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 28..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBDataSet.h"

@implementation SHBDataSet

@synthesize serviceCode;
@synthesize serviceTaskCode;
@synthesize vectorTitle;
@synthesize TaskAndVector;


- (id)initWithServiceCode:(NSString *)aServiceCode
{
    self = [super init];
    if (self) {
        self.serviceCode = aServiceCode;
    }
    return self;
}

- (void) dealloc
{
    [serviceCode release];
    [super dealloc];
}

@end
