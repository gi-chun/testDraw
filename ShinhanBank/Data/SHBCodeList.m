//
//  SHBCodeList.h
//  ShinhanBank
//
//  Created by 차주현 on 12. 11. 01.
//  Copyright (c) 2012년 (주)두베. All rights reserved.
//

#import "SHBCodeList.h"

@implementation SHBCodeList
@synthesize bankList;
@synthesize bankCode;
@synthesize bankCodeReverse;
@synthesize celebrationCode;
@synthesize currencyList;
@synthesize jibangCode;
@synthesize jibangCodeReverse;
@synthesize jibangGwamok;
@synthesize jibangGwamokReverse;
@synthesize nationList;
@synthesize cardList;
@synthesize creditCardList;

- (id)init
{
    self = [super init];
    if (self) {
        //파일 저장 필요 ///////////////////////////////////////////////////////////////////
        bankList            = [[NSMutableArray alloc] initWithCapacity:0];
        bankCode            = [[NSMutableDictionary alloc] initWithCapacity:0];
        bankCodeReverse     = [[NSMutableDictionary alloc] initWithCapacity:0];
        ////////////////////////////////////////////////////////////////////////////////
        celebrationCode     = [[NSMutableArray alloc] initWithCapacity:0];
        currencyList        = [[NSMutableArray alloc] initWithCapacity:0];
        jibangCode          = [[NSMutableArray alloc] initWithCapacity:0];
        jibangCodeReverse   = [[NSMutableDictionary alloc] initWithCapacity:0];
        jibangGwamok        = [[NSMutableDictionary alloc] initWithCapacity:0];
        jibangGwamokReverse = [[NSMutableDictionary alloc] initWithCapacity:0];
        nationList          = [[NSMutableArray alloc] initWithCapacity:0];
        cardList            = [[NSMutableArray alloc] initWithCapacity:0];
        creditCardList      = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (NSString *)bankNameFromCode:(NSString *)code
{
	NSString *bankname;

	if (code == nil ||
		[code isEqualToString:@""] ||
		[code isEqualToString:@"00"])	// 20100213 hjshin : 임시 예외처리 00코드에 대한 값 확정 필요.
	{
		return @"";
	}
	if ([code length] == 3 && [code hasPrefix:@"0"])
	{
		bankname = [bankCodeReverse objectForKey:[code substringFromIndex:1]];
	}
	else
	{
		bankname = [bankCodeReverse objectForKey:code];
	}

	if (bankname == nil) {
		return @"";
	}
    
    if([bankname isEqualToString:@"한미은행"])
    {
        bankname = @"씨티은행";
    }
    
	return bankname;
}

- (void)dealloc
{
    [bankList release];
    [bankCode release];
    [bankCodeReverse release];
    [celebrationCode release];
    [currencyList release];
    [jibangCode release];
    [jibangCodeReverse release];
    [jibangGwamok release];
    [jibangGwamokReverse release];
    [nationList release];
    [cardList release];
    [creditCardList release];
    
    [super dealloc];
}

@end
