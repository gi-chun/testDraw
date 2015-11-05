//
//  CertificateInfo.m
//  certList
//
//  Created by  김대현 on 10. 4. 20..
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CertificateInfo.h"
#import "INISAFEXSafe.h"


@implementation CertificateInfo

@synthesize index;
@synthesize user;
@synthesize issuer;
@synthesize type;
@synthesize expire;
@synthesize expired;

- (CertificateInfo *) initWithParsing: (char *)line
{
	/* line 을 파싱해서... 각 property 에 세팅 하장.. */
	/* line : index=0&user=initech.gateway.com&issuer=±›∞·ø¯TEST&type=∞¯¿Œ¿Œ¡ıº≠&expire=2008-08-21&expired=1 */
	char *p = NULL;
	char *nowp = NULL;
	char buf[256] = {0x00, };
	
	nowp = line + 6;
	
	//NSLog(@"now initWithParsing...... with line: %s \n", line);
	p = strstr(nowp, "&user=");
	if(p){
		memset(buf, 0x00, sizeof(buf));
		memcpy(buf, nowp, p - nowp);
	}
	//NSLog(@"index = %d", atoi(buf));
	[self setIndex:atoi(buf)];
	
	nowp = p + 6;
	p = strstr(nowp, "&issuer=");
	if(p){
		memset(buf, 0x00, sizeof(buf));
		memcpy(buf, nowp, p - nowp);
	}
	
	[self setUser:[[NSString alloc] initWithBytes:buf length:p-nowp encoding:NSEUCKRStringEncoding]];

	nowp = p + 8;
	p = strstr(nowp, "&type=");
	if(p){
		memset(buf, 0x00, sizeof(buf));
		memcpy(buf, nowp, p - nowp);
	}
	[self setIssuer:[[NSString alloc] initWithBytes:buf length:p-nowp encoding:NSEUCKRStringEncoding]];
//	[self setIssuer:[[NSString alloc] initWithBytes:buf length:p-nowp encoding:NSUTF8StringEncoding]];	
	
	nowp = p + 6;
	p = strstr(nowp, "&expire=");
	if(p){
		memset(buf, 0x00, sizeof(buf));
		memcpy(buf, nowp, p - nowp);
	}
	[self setType:[[NSString alloc] initWithBytes:buf length:p-nowp encoding:NSEUCKRStringEncoding]];
//	[self setType:[[NSString alloc] initWithBytes:buf length:p-nowp encoding:NSUTF8StringEncoding]];
	

	nowp = p + 8;
	p = strstr(nowp, "&expired=");
	if(p){
		memset(buf, 0x00, sizeof(buf));
		memcpy(buf, nowp, p - nowp);
	}
	[self setExpire:[[NSString alloc] initWithBytes:buf length:p-nowp encoding:NSEUCKRStringEncoding]];
		
	nowp = p + 9;
	[self setExpired:atoi(nowp)];

	return self;
}

- (int) changePassword: (char *)passwd newPasswd: (char *)newPasswd
{

	int idx = self.index;
	int ret = -1;
	
	ret = IXL_ChangePasswd(idx, passwd, newPasswd);
	if(ret != 0){
		return ret;
	}
	
	return 0;
}

- (int) deleteCert
{
	int ret = -1;
	int idx = self.index;
	
	ret = IXL_DeleteCert(idx);

	return ret;
}

@end


