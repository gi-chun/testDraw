//
//  SHBAccount.m
//  OrchestraNative
//
//  Created by Jong Pil Park on 12. 8. 21..
//  Copyright (c) 2012년 Finger Inc. All rights reserved.
//

#import "SHBAccount.h"

@implementation SHBAccount

@synthesize accountNo;
@synthesize oldAccountNo;
@synthesize bankCode;
@synthesize depositType;
@synthesize accountName;        
@synthesize issueDate;  
@synthesize balance;          
@synthesize availableBalance;

- (void)dealloc
{
    [accountNo release], accountNo = nil;
    [oldAccountNo release], oldAccountNo = nil;
    [bankCode release], bankCode = nil;
    [depositType release], depositType = nil;
    [accountName release], accountName = nil;
    [issueDate release], issueDate = nil;
    [balance release], balance = nil;
    [availableBalance release], availableBalance = nil;
    [super dealloc];
}

@end
